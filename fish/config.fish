# Aliases
alias hx="helix"

# Startup
if status is-interactive
    macchina
end

fzf --fish | source
zoxide init fish | source
