if [[ "${TERM_ENV_DISABLE_THEME:-0}" == "1" ]]; then
  return 0
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  BREW_PREFIX="$(/opt/homebrew/bin/brew --prefix)"
elif [[ -x /usr/local/bin/brew ]]; then
  BREW_PREFIX="$(/usr/local/bin/brew --prefix)"
else
  BREW_PREFIX=""
fi

if [[ -n "$BREW_PREFIX" && -f "$BREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "$BREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
fi

if [[ -f "$HOME/.p10k.zsh" ]]; then
  source "$HOME/.p10k.zsh"
fi
