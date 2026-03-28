if [[ "${TERM_ENV_DISABLE_THEME:-0}" == "1" ]]; then
  return 0
fi

if [[ -f "$HOME/.p10k.zsh" ]]; then
  source "$HOME/.p10k.zsh"
fi
