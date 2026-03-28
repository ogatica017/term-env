# Homebrew-installed zsh plugins and completions.

if [[ -x /opt/homebrew/bin/brew ]]; then
  BREW_PREFIX="$(/opt/homebrew/bin/brew --prefix)"
elif [[ -x /usr/local/bin/brew ]]; then
  BREW_PREFIX="$(/usr/local/bin/brew --prefix)"
else
  BREW_PREFIX=""
fi

if [[ -n "$BREW_PREFIX" ]]; then
  if [[ -d "$BREW_PREFIX/share/zsh-completions" ]]; then
    fpath=("$BREW_PREFIX/share/zsh-completions" $fpath)
  fi

  if [[ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  fi

  if [[ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  fi
fi
