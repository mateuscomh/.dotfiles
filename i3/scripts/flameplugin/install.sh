#!/bin/bash
# -------------------------------------------------------------------------
# Descrição: Instala o Flameshot, Tesseract OCR, xclip e configura um script
#              para capturar uma área da tela, converter a imagem para texto e
#              copiar o texto para a área de transferência.
# Autor: Matheus Martins
# Data: 23/02/2024
# Uso: ./install.sh
# Dependências: apt-get, dnf, pacman (um gerenciador de pacotes deve estar presente)
#               notify-send (para notificações de desktop)
# Requisitos: O script suporta pacotes para distribuições baseadas em Debian (apt-get),
#             Fedora (dnf) e Arch Linux (pacman).
# -------------------------------------------------------------------------
#!/bin/bash

# install packages depending on the package manager
install_packages() {
    local packages="$1"
    case "$2" in
        apt-get)
            sudo apt-get update
            sudo apt-get install -y $packages
            ;;
        dnf)
            sudo dnf install -y $packages
            ;;
        pacman)
            sudo pacman -S --noconfirm $packages
            ;;
        *)
            echo "Package manager not supported."
            exit 1
            ;;
    esac
}

# Detect the package manager
if command -v apt-get &>/dev/null; then
    package_manager="apt-get"
elif command -v dnf &>/dev/null; then
    package_manager="dnf"
elif command -v pacman &>/dev/null; then
    package_manager="pacman"
else
    echo "No compatible package manager found."
    exit 1
fi

# Install Flameshot, Tesseract, and xclip
install_packages "notify-osd flameshot tesseract-ocr-por xclip" $package_manager

# Create the directory if it does not exist
mkdir -p ~/.config/ocr

# Create the flameshot_ocr.sh script
cat > ~/.config/ocr/flameshot_ocr.sh << 'EOF'
#!/bin/bash

TEMPFILE="$(mktemp /tmp/screenshot-XXXXXX.png)"
flameshot gui --raw > "$TEMPFILE"
if [ -s "$TEMPFILE" ]; then
    tesseract "$TEMPFILE" stdout -l spa | xclip -selection clipboard
    echo "Text copied to clipboard."
    notify-send "Text copied to clipboard."
    rm "$TEMPFILE"
else
    echo "No screenshot was taken."
    notify-send "No screenshot was taken"
    rm "$TEMPFILE"
fi
EOF

# Grant necessary permissions
chmod +x ~/.config/ocr/flameshot_ocr.sh

echo "Installation completed. The script is located in ~/.config/ocr/flameshot_ocr.sh"
