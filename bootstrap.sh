#!/bin/bash

set -e

echo "🚀 Bootstrap de l'environnement..."

# Définir le PATH pour chezmoi
export PATH="$HOME/.local/bin:$PATH"

# Installer chezmoi si absent
if ! command -v chezmoi &> /dev/null; then
    echo "📦 Installation de chezmoi..."
    BINDIR="$HOME/.local/bin" sh -c "$(curl -fsLS get.chezmoi.io)"
    export PATH="$HOME/.local/bin:$PATH"
fi

# Initialiser chezmoi si nécessaire
if [ ! -d "$HOME/.local/share/chezmoi" ]; then
    echo "🔧 Initialisation de chezmoi avec ton dépôt Git..."
    export PATH="$HOME/.local/bin:$PATH"
    chezmoi init https://github.com/nicotinii/dotfiles.git
fi

# Installer Zsh si absent
if ! command -v zsh &> /dev/null; then
    echo "🔧 Installation de Zsh..."
    sudo apt update && sudo apt install -y zsh
fi

# Installer Oh My Zsh si absent
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "✨ Installation de Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Installer plugins Oh My Zsh si absents
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "🔌 Installation du plugin zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "🔌 Installation du plugin zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]; then
    echo "🔌 Installation du plugin zsh-history-substring-search..."
    git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
fi

# Installer kubecolor si absent
if ! command -v kubecolor &> /dev/null; then
    echo "🌈 Installation de kubecolor..."
    sudo apt update && sudo apt install -y kubecolor
fi

# Installer starship globalement si absent
if ! command -v starship &> /dev/null; then
    echo "🚀 Installation de Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    sudo mv ~/.local/bin/starship /usr/local/bin/
fi

# Réappliquer la config chezmoi pour écraser les modifs d'installateurs
echo "📂 Réapplication de la configuration chezmoi..."
chezmoi apply

# Définir Zsh comme shell par défaut si ce n'est pas déjà fait
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "⚙️ Définition de Zsh comme shell par défaut..."
    chsh -s "$(which zsh)"
fi


echo "✅ Environnement prêt. Relance ton terminal ou tape 'zsh' pour profiter de ta config !"