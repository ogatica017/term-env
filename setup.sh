#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_ROOT="$HOME/.term-env-backups"
TIMESTAMP="$(date +"%Y-%m-%dT%H-%M-%S")"
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"
LOCAL_OVERRIDE="$HOME/.term-env-local.zsh"

MANAGED_FILES=(
  ".zshrc:$REPO_DIR/shell/zshrc"
  ".zprofile:$REPO_DIR/shell/zprofile"
)

SNAPSHOT_FILES=(
  "$HOME/.zshrc"
  "$HOME/.zprofile"
  "$HOME/.zshenv"
  "$HOME/.p10k.zsh"
)

BACKED_UP_FILES=()

backup_file() {
  local target="$1"
  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$BACKUP_DIR"
    cp -a "$target" "$BACKUP_DIR/"
    BACKED_UP_FILES+=("$target")
    echo "Backed up $target -> $BACKUP_DIR"
  fi
}

was_backed_up() {
  local target="$1"
  local backed
  for backed in "${BACKED_UP_FILES[@]}"; do
    if [[ "$backed" == "$target" ]]; then
      return 0
    fi
  done
  return 1
}

snapshot_existing_dotfiles() {
  local copied_any=0
  for target in "${SNAPSHOT_FILES[@]}"; do
    if [[ -e "$target" || -L "$target" ]]; then
      backup_file "$target"
      copied_any=1
    fi
  done

  if [[ "$copied_any" -eq 0 ]]; then
    echo "No existing zsh dotfiles found to snapshot"
  else
    echo "Snapshot complete: $BACKUP_DIR"
  fi
}

link_file() {
  local target="$1"
  local source="$2"

  if [[ -L "$target" ]]; then
    local current
    current="$(readlink "$target")"
    if [[ "$current" == "$source" ]]; then
      echo "Already linked: $target"
      return
    fi
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    if ! was_backed_up "$target"; then
      backup_file "$target"
    fi
    rm -f "$target"
  fi

  ln -s "$source" "$target"
  echo "Linked $target -> $source"
}

install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install_brew_deps() {
  echo "Installing brew dependencies..."
  brew bundle --file "$REPO_DIR/Brewfile"
}

install_oh_my_zsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    echo "oh-my-zsh already installed"
    return
  fi

  echo "Installing oh-my-zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

setup_theme() {
  local target="$HOME/.p10k.zsh"
  local source="$REPO_DIR/shell/p10k.zsh"

  if [[ -e "$target" || -L "$target" ]]; then
    echo "Existing ~/.p10k.zsh detected; leaving it in place"
    return
  fi

  ln -s "$source" "$target"
  echo "Linked $target -> $source"
}

create_local_override() {
  if [[ -e "$LOCAL_OVERRIDE" ]]; then
    echo "Local override exists: $LOCAL_OVERRIDE"
    return
  fi

  cat > "$LOCAL_OVERRIDE" <<'EOF'
# ~/.term-env-local.zsh
# Put private, machine-specific, or work-specific zsh customizations here.

# Examples:
# alias workproj='cd ~/src/work/project'
# export TERM_ENV_DISABLE_THEME=1
EOF

  echo "Created local override: $LOCAL_OVERRIDE"
}

main() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "term-env v1 currently supports macOS only."
    exit 1
  fi

  mkdir -p "$BACKUP_ROOT"
  snapshot_existing_dotfiles

  install_homebrew
  install_brew_deps
  install_oh_my_zsh

  for mapping in "${MANAGED_FILES[@]}"; do
    local_name="${mapping%%:*}"
    source_path="${mapping#*:}"
    link_file "$HOME/$local_name" "$source_path"
  done

  setup_theme
  create_local_override

  echo
  echo "term-env setup complete."
  echo "Backups, if any, are under: $BACKUP_ROOT"
  echo "Restart your shell or run: exec zsh"
}

main "$@"
