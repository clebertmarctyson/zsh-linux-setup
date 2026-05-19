#!/bin/bash
# ==============================================================================
# Zsh Power Setup — Arch Linux
# Author: github.com/clebertmarctyson
# Description: Installs and configures Zsh with Oh My Zsh, Powerlevel10k,
#              plugins, fonts, nvm, Node, pnpm, and ip-navigator-cli.
# Usage: chmod +x arch.sh && ./arch.sh
# ==============================================================================
set -euo pipefail

# ─────────────────────────────────────────────
# Guard: Arch-based systems only
# ─────────────────────────────────────────────
if ! command -v pacman >/dev/null; then
    echo "❌ This script is designed for Arch-based systems only." >&2
    exit 1
fi

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║        Zsh Power Setup — Arch Linux      ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ─────────────────────────────────────────────
# 1. Install Zsh
# ─────────────────────────────────────────────
echo "▶ [1/8] Checking Zsh..."
if ! command -v zsh >/dev/null; then
    echo "  → Installing Zsh..."
    sudo pacman -S zsh --noconfirm
else
    echo "  ⏭ Zsh already installed, skipping."
fi

# ─────────────────────────────────────────────
# 2. Install system packages via pacman
# ─────────────────────────────────────────────
echo ""
echo "▶ [2/8] Installing system packages..."
sudo pacman -S --noconfirm --needed \
    git \
    curl \
    thefuck \
    github-cli

# ─────────────────────────────────────────────
# 3. Install Oh My Zsh (non-interactive)
# ─────────────────────────────────────────────
echo ""
echo "▶ [3/8] Checking Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "  → Installing Oh My Zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "  ⏭ Oh My Zsh already installed, skipping."
fi

# ─────────────────────────────────────────────
# 4. Redirect Bash → Zsh (interactive shells only)
# ─────────────────────────────────────────────
echo ""
echo "▶ [4/8] Configuring Bash → Zsh redirect..."
if ! grep -q "exec zsh" ~/.bashrc; then
    # $- == *i* ensures we never hijack non-interactive subshells or scripts
    sed -i '1i\if [[ $- == *i* && -t 0 ]]; then exec zsh; fi' ~/.bashrc
    echo "  ✅ .bashrc updated."
else
    echo "  ⏭ .bashrc already configured, skipping."
fi

# ─────────────────────────────────────────────
# 5. nvm → Node → pnpm → ip-navigator-cli
# ─────────────────────────────────────────────
echo ""
echo "▶ [5/8] Setting up nvm, Node, pnpm..."

if [ ! -d "$HOME/.nvm" ]; then
    echo "  → Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
else
    echo "  ⏭ nvm already installed, skipping."
fi

# Source nvm immediately so we can use it in this script
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo "  → Installing latest Node.js..."
nvm install node
nvm use node
nvm alias default node

export PNPM_HOME="$HOME/.local/share/pnpm"
if ! command -v pnpm >/dev/null; then
    echo "  → Installing pnpm..."
    curl -fsSL https://get.pnpm.io/install.sh | env SHELL=bash sh -
else
    echo "  ⏭ pnpm already installed, skipping."
fi

# Source pnpm into current PATH so we can use it immediately
export PATH="$PNPM_HOME/bin:$PATH"

if ! command -v ipnav >/dev/null; then
    echo "  → Installing ip-navigator-cli..."
    pnpm add -g --allow-build=esbuild ip-navigator-cli
else
    echo "  ⏭ ip-navigator-cli already installed, skipping."
fi

# ─────────────────────────────────────────────
# 6. Clone third-party plugins & Powerlevel10k
# ─────────────────────────────────────────────
echo ""
echo "▶ [6/8] Cloning plugins and theme..."

ZTHEMES="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes"
ZDIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
mkdir -p "$ZTHEMES" "$ZDIR"

clone_git() {
    if [ ! -d "$2" ]; then
        echo "  → Cloning $(basename $2)..."
        git clone --depth=1 "$1" "$2"
    else
        echo "  ⏭ $(basename $2) already exists, skipping."
    fi
}

# Theme (must go into custom/themes/ for OMZ to find it)
clone_git "https://github.com/romkatv/powerlevel10k.git" \
    "$ZTHEMES/powerlevel10k"

# Third-party plugins
clone_git "https://github.com/zsh-users/zsh-autosuggestions.git" \
    "$ZDIR/zsh-autosuggestions"
clone_git "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
    "$ZDIR/zsh-syntax-highlighting"
clone_git "https://github.com/zsh-users/zsh-history-substring-search.git" \
    "$ZDIR/zsh-history-substring-search"
clone_git "https://github.com/zsh-users/zsh-completions.git" \
    "$ZDIR/zsh-completions"
clone_git "https://github.com/clebertmarctyson/oh-my-zsh-ipnav.git" \
    "$ZDIR/ipnav"

# ─────────────────────────────────────────────
# 7. Install MesloLGS NF Fonts
# ─────────────────────────────────────────────
echo ""
echo "▶ [7/8] Installing MesloLGS NF fonts..."

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"

for style in "Regular" "Bold" "Italic" "Bold%20Italic"; do
    FILE="MesloLGS NF ${style//%20/ }.ttf"   # space in filename
    ENCODED="MesloLGS%20NF%20${style}.ttf"   # %20 encoded for URL

    if [ ! -f "$FONT_DIR/$FILE" ]; then
        echo "  → Downloading $FILE..."
        if ! curl -fL "${BASE_URL}/${ENCODED}" -o "$FONT_DIR/$FILE"; then
            echo "  ❌ Failed to download $FILE — removing partial file." >&2
            rm -f "$FONT_DIR/$FILE"   # prevents stale file on next run
            exit 1
        fi
        echo "  ✅ $FILE installed."
    else
        echo "  ⏭ $FILE already exists, skipping."
    fi
done

echo "  → Refreshing font cache..."
fc-cache -f > /dev/null

# ─────────────────────────────────────────────
# 8. Write .zshrc
# ─────────────────────────────────────────────
echo ""
echo "▶ [8/8] Writing ~/.zshrc..."

cat << 'EOF' > ~/.zshrc
# ── Powerlevel10k instant prompt (must stay at the very top) ──────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Oh My Zsh ─────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  # ── Git ───────────────────────────────
  git
  gh
  git-auto-fetch

  # ── Node / JS ─────────────────────────
  npm
  node
  nvm
  yarn

  # ── Python ────────────────────────────
  pip
  python

  # ── Docker ────────────────────────────
  docker
  docker-compose

  # ── Terminal UX ───────────────────────
  sudo
  extract
  z
  history
  aliases
  alias-finder
  colored-man-pages
  command-not-found
  copypath
  copyfile
  dirhistory
  safe-paste
  thefuck

  # ── Tools ─────────────────────────────
  web-search
  jsontools
  vscode

  # ── Third-party ───────────────────────
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
  zsh-completions
  ipnav
)

source $ZSH/oh-my-zsh.sh

# ── nvm ───────────────────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ── pnpm ──────────────────────────────────────────────────────────────────────
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

# ── thefuck ───────────────────────────────────────────────────────────────────
eval $(thefuck --alias)

# ── Locale ────────────────────────────────────────────────────────────────────
export LANG=en_US.UTF-8

# ── Powerlevel10k config ──────────────────────────────────────────────────────
# Run 'p10k configure' to regenerate
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

# ─────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║              ✅  All done!               ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "  Next steps:"
echo "  1. Restart your terminal"
echo "  2. Set font to 'MesloLGS NF' in terminal settings"
echo "     (Konsole → Settings → Edit Current Profile → Appearance → Choose font)"
echo "  3. Run 'p10k configure' on first Zsh launch"
echo ""