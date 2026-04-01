alias a=alias
alias ag="alias | grep"
alias cz="cat ~/.zshrc"
alias cb="cat ~/.bashrc"
alias c=clear
alias e=explorer.exe . # WSL
alias rmn="rm -rf node_modules"
alias sb="source ~/.bashrc"
alias sz="source ~/.zshrc"
alias vb="vim ~/.bashrc"
alias vz="vim ~/.zshrc"

# Based on https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/pulumi
# "p" instead of "pul" and some `--yes` added
alias p='pulumi'
alias pcs='pulumi config set'
alias pd='pulumi destroy --yes'
alias pl='pulumi logs -f'
alias pp='pulumi preview'
alias pr='pulumi refresh'
alias ps='pulumi stack'
alias psh='pulumi stack history'
alias psi='pulumi stack init'
alias psl='pulumi stack ls'
alias pso='pulumi stack output'
alias pss='pulumi stack select'
alias pu='pulumi up --yes'
