#!/bin/bash

set -e

echo "🚀 Bootstrap de l'environnement..."

# Installer chezmoi si absent
if ! command -v chezmoi &> /dev/null; then
    echo "📦 Installation de chezmoi..."
    BINDIR="$HOME/.local/bin" sh -c "$(curl -fsLS get.chezmoi.io)"
    export PATH="$HOME/.local/bin:$PATH"
else
    export PATH="$HOME/.local/bin:$PATH"
fi

# Initialisation chezmoi
if [ ! -d "$HOME/.local/share/chezmoi" ]; then
    echo "🔧 Initialisation de chezmoi avec ton dépôt Git..."
    chezmoi init https://github.com/nicotinii/chezmoi.git
fi

echo "📂 Application de la configuration..."
chezmoi apply


# Installer Zsh si pas déjà fait
if ! command -v zsh &> /dev/null; then
    echo "🔧 Installation de Zsh..."
    sudo apt update && sudo apt install -y zsh
fi

# Installer Oh My Zsh si pas déjà fait
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "✨ Installation de Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Installer Starship si pas déjà fait
if ! command -v starship &> /dev/null; then
    echo "🚀 Installation de Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

echo "✅ Environnement prêt. Lance zsh pour profiter de ta config !"
