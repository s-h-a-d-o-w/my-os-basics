#!/usr/bin/env bash

set -uo pipefail
export LC_ALL=C

INITIAL_STATUS="/var/log/installer/initial-status.gz"

# Only Depends and Pre-Depends count as dependencies here.
APT_FLAGS=(
    --installed
    --no-recommends
    --no-suggests
    --no-conflicts
    --no-breaks
    --no-replaces
    --no-enhances
)

if [[ ! -r "$INITIAL_STATUS" ]]; then
    printf 'Error: cannot read %s\n' "$INITIAL_STATUS" >&2
    exit 1
fi

CACHE_DIR=$(mktemp -d)
trap 'rm -rf "$CACHE_DIR"' EXIT

# List manually installed packages that were not present during OS
# installation, minus OS-managed kernel, firmware and metapackages.
list_user_packages() {
    comm -23 \
        <(apt-mark showmanual | sort -u) \
        <(
            gzip -dc "$INITIAL_STATUS" |
                sed -n 's/^Package: //p' |
                sort -u
        ) |
        awk '
            !/^linux-(firmware|hwe-|image|headers|modules|tools)/ &&
            !/^(ubuntu|kubuntu|xubuntu|lubuntu)-(desktop|standard|minimal|server)$/
        '
}

# Print the package's own Installed-Size in KiB.
own_size_kib() {
    dpkg-query -W -f='${Installed-Size}' "$1" 2>/dev/null || printf '0'
}

# Print the package plus every recursively installed dependency, sorted.
dependency_closure() {
    apt-cache depends --recurse "${APT_FLAGS[@]}" "$1" 2>/dev/null |
        sed -n '/^[^[:space:]<]/p' |
        sed 's/:.*$//' |
        sort -u
}

# Sum Installed-Size in KiB over the package names read from stdin.
sum_sizes_kib() {
    xargs -r dpkg-query -W -f='${Installed-Size}\n' 2>/dev/null |
        awk '{ total += $1 } END { print total + 0 }'
}

# Print the installed packages that depend on the given package.
# Results are cached on disk so they survive subshells.
reverse_dependencies() {
    local package=$1
    local cache_file="$CACHE_DIR/$package"

    if [[ ! -f "$cache_file" ]]; then
        apt-cache rdepends "${APT_FLAGS[@]}" "$package" 2>/dev/null |
            awk '
                /^Reverse Depends:/ { inside = 1; next }

                inside {
                    line = $0
                    gsub(/^[[:space:]|]+/, "", line)
                    if (line == "") next
                    sub(/[[:space:]].*$/, "", line)
                    sub(/:.*$/, "", line)
                    print line
                }
            ' |
            sort -u >"$cache_file"
    fi

    cat "$cache_file"
}

# Succeed when nothing outside the closure depends on any of its members.
closure_is_exclusive() {
    local closure_file=$1
    local outsiders

    outsiders=$(
        while IFS= read -r member; do
            reverse_dependencies "$member"
        done <"$closure_file" |
            sort -u |
            comm -23 - "$closure_file"
    )

    [[ -z "$outsiders" ]]
}

show_progress() {
    if [[ -t 2 ]]; then
        printf '\r\033[KProcessing %d/%d: %s' "$1" "$2" "$3" >&2
    else
        printf 'Processing %d/%d: %s\n' "$1" "$2" "$3" >&2
    fi
}

mapfile -t packages < <(list_user_packages)
total=${#packages[@]}

printf '%10s | %10s | %s\n' 'all' 'own' 'name'
printf '%10s-+-%10s-+-%s\n' '----------' '----------' '----'

{
    closure_file="$CACHE_DIR/closure"

    for ((i = 0; i < total; i++)); do
        package=${packages[i]}

        show_progress "$((i + 1))" "$total" "$package"

        dependency_closure "$package" >"$closure_file"

        all_kib=$(sum_sizes_kib <"$closure_file")
        own_kib=$(own_size_kib "$package")

        if closure_is_exclusive "$closure_file"; then
            marker='*'
        else
            marker=' '
        fi

        # Convert KiB to bytes for numfmt.
        printf '%s\t%s\t%s\t%s\n' \
            "$((own_kib * 1024))" \
            "$((all_kib * 1024))" \
            "$marker" \
            "$package"
    done

    [[ -t 2 ]] && printf '\r\033[K' >&2
} |
    sort -nr -k1,1 |
    numfmt --delimiter=$'\t' --field=1,2 --to=iec-i --suffix=B |
    while IFS=$'\t' read -r own_size all_size marker package; do
        printf '%10s | %10s | %s %s\n' \
            "$own_size" "$all_size" "$marker" "$package"
    done

cat <<'EOF'

* All dependencies this package are not depended on by anything outside the dependency chain. I.e. the amount of "all" space can be reclaimed by removing this package and its dependencies.

Inspect the dependency chain of a specific package with:

  apt-cache depends --recurse --installed --important 'PACKAGE_NAME' | less
EOF
