#!/usr/bin/env bash
# install.sh - AdiOS Doom Emacs PKM Plugin Installation Script

set -e

echo "=== AdiOS Doom Emacs PKM Plugin Installer ==="
echo "Enterprise-grade knowledge management with dual-brain architecture"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running in AdiOS environment
ADIOS_INTEGRATION=false
if [ -f "../../libs/adios-core/Cargo.toml" ]; then
    ADIOS_INTEGRATION=true
    log_info "AdiOS integration detected"
fi

# Check prerequisites
log_info "Checking prerequisites..."

command -v emacs >/dev/null 2>&1 || { 
    log_error "Emacs not installed. Please install: sudo apt install emacs"
    exit 1
}

command -v git >/dev/null 2>&1 || { 
    log_error "Git not installed. Please install: sudo apt install git"
    exit 1
}

command -v rg >/dev/null 2>&1 || { 
    log_error "Ripgrep not installed. Please install: sudo apt install ripgrep"
    exit 1
}

command -v sqlite3 >/dev/null 2>&1 || { 
    log_error "SQLite3 not installed. Please install: sudo apt install sqlite3"
    exit 1
}

log_success "All prerequisites satisfied"

# Check if Doom Emacs is installed
if [ ! -d "$HOME/.config/emacs" ]; then
    log_info "Doom Emacs not found. Installing..."
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
    ~/.config/emacs/bin/doom install
    log_success "Doom Emacs installed"
else
    log_success "Doom Emacs found at ~/.config/emacs"
fi

# Create symlinks for configuration files
log_info "Creating configuration symlinks..."

mkdir -p ~/.config/doom

ln -sf "$(pwd)/config.el" ~/.config/doom/config.el
ln -sf "$(pwd)/init.el" ~/.config/doom/init.el
ln -sf "$(pwd)/packages.el" ~/.config/doom/packages.el

log_success "Configuration files linked"

# Create custom.el if it doesn't exist
if [ ! -f ~/.config/doom/custom.el ]; then
    log_info "Creating custom.el for machine-specific settings..."
    cat > ~/.config/doom/custom.el <<EOF
;;; custom.el --- Machine-specific customizations for AdiOS Doom Emacs PKM

;; This file is gitignored and safe for local changes

;; Basic user information
(setq user-full-name "Your Name"
      user-mail-address "your.email@example.com")

;; AdiOS integration settings
(setq adios-doom-pkm-integration ${ADIOS_INTEGRATION}
      adios-luna-ai-enabled nil          ; Enable when Luna AI is available
      adios-sync-protocol-enabled nil    ; Enable when sync protocol is available
      adios-gamification-enabled nil)    ; Enable when gamification is available

;; EWA git remote (customize for your organization)
(setq adios-ewa-git-remote "git@github.com:yourorg/knowledge-base.git")

;;; custom.el ends here
EOF
    log_success "Created custom.el - please edit with your details"
else
    log_info "custom.el already exists - skipping creation"
fi

# Set up dual-brain directory structure
log_info "Setting up dual-brain directory structure..."

mkdir -p ~/org/personal/{daily,projects,learning,architecture}
mkdir -p ~/org/ewa/{shared,blueprints,meetings}

# Create initial files if they don't exist
for brain in personal ewa; do
    for file in inbox.org tasks.org clips.org; do
        if [ ! -f ~/org/$brain/$file ]; then
            cat > ~/org/$brain/$file <<EOF
#+title: $(echo $file | sed 's/.org//' | tr '[:lower:]' '[:upper:]')
#+date: $(date -u +"%Y-%m-%d")
#+filetags: :$brain:

* $(echo $file | sed 's/.org//' | tr '[:lower:]' '[:upper:]')

EOF
        fi
    done
done

log_success "Dual-brain directory structure created"

# Initialize git repositories
log_info "Initializing git repositories..."

# Personal brain (local only)
if [ ! -d ~/org/personal/.git ]; then
    cd ~/org/personal
    git init
    echo "# Personal Knowledge Base" > README.md
    echo "This is a private knowledge base that stays local." >> README.md
    git add .
    git commit -m "Initial personal brain setup"
    log_success "Personal brain git repository initialized"
else
    log_info "Personal brain git repository already exists"
fi

# EWA brain (enterprise, will be synced)
if [ ! -d ~/org/ewa/.git ]; then
    cd ~/org/ewa
    git init
    echo "# Enterprise Knowledge Base (EWA)" > README.md
    echo "This knowledge base syncs to the enterprise repository." >> README.md
    git add .
    git commit -m "Initial EWA brain setup"
    log_success "EWA brain git repository initialized"
    log_warning "Remember to add remote: git remote add origin <your-enterprise-repo>"
else
    log_info "EWA brain git repository already exists"
fi

cd "$(dirname "$0")"

# Sync Doom packages
log_info "Syncing Doom Emacs packages..."
~/.config/emacs/bin/doom sync

log_success "Doom packages synchronized"

echo ""
echo "=== Installation Complete ==="
echo ""
log_success "AdiOS Doom Emacs PKM Plugin installed successfully!"
echo ""
echo "Next steps:"
echo "1. Edit ~/.config/doom/custom.el with your personal details"
echo "2. Launch Emacs: emacs"
echo "3. Test capture: SPC X (in Doom) or C-c c"
echo "4. Test brain switching: SPC m b p (personal) / SPC m b e (EWA)"
echo ""
log_info "Happy knowledge managing! 🧠✨"
