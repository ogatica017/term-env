# Generic aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias hgrep='history | grep'
alias goland='open -na "GoLand.app"'

# Make helpers
alias mcr='make compile-reqs'
alias mr='make run'
alias ms='make shell'
alias ml='make lint'
alias mt='make test'

# Git helpers
alias gs='git status'
alias gca='git commit --amend --no-edit'
alias gpr='git pull -r origin main'
alias gsp='git show --pretty --name-only'
alias gcm='git checkout main && git pull origin main'
alias gch='git checkout'

gchf() {
  local branch
  branch="$(git branch --format='%(refname:short)' | fzf)" || return
  [[ -n "$branch" ]] || return
  git checkout "$branch"
}
