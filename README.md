# AdiOS Plugin: Doom Emacs PKM

Enterprise-grade Doom Emacs configuration for dual-brain knowledge management with org-roam, integrated with the AdiOS ecosystem.

## Features

- **Dual-Brain Architecture**: Separate personal and enterprise knowledge bases
- **org-roam Integration**: Zettelkasten-style linking with SQLite databases
- **System-wide Capture**: org-protocol for capturing from any Linux application
- **Chrome Integration**: Bookmarklet for web clipping with automatic categorization
- **AdiOS Sync**: Integrates with adios-sync-protocol for cross-device synchronization
- **AI Enhancement**: Luna AI integration for context-aware suggestions
- **Enterprise Ready**: EWA brain syncs to enterprise Git repositories
- **Privacy First**: Personal brain stays local, enterprise brain follows governance

## Installation

### Standalone Installation

```bash
# Prerequisites (Ubuntu/Pop!_OS)
sudo apt update
sudo apt install emacs ripgrep sqlite3 git fd-find

# Clone this plugin
git clone https://github.com/tridentbiz/adios-doom-emacs-pkm.git
cd adios-doom-emacs-pkm

# Install Doom Emacs (if not already installed)
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install

# Run installation script
./install.sh

# Set up dual-brain structure
mkdir -p ~/org/{personal,ewa}
cd ~/org/personal && git init
cd ~/org/ewa && git init && git remote add origin git@github.com:yourorg/knowledge-base.git

# Launch Emacs
emacs
```

### AdiOS Integration

```bash
# Add as plugin to AdiOS ecosystem
cd /path/to/0001-adios
git submodule add https://github.com/tridentbiz/adios-doom-emacs-pkm.git plugins/doom-emacs-pkm

# Install through AdiOS plugin manager
adios plugin install doom-emacs-pkm

# Configure integration
adios plugin configure doom-emacs-pkm --enable-luna-ai --enable-sync
```

## Usage

### Daily Workflows

**Morning Routine:**
1. Launch Emacs: `emacs`
2. Check today's notes: `SPC n j`
3. Switch between brains: `SPC m b p` (personal) / `SPC m b e` (enterprise)

**Capture Workflows:**
- Quick capture: `Super+Shift+C` (global hotkey)
- From Emacs: `SPC X`
- From Chrome: Click "Clip to Org" bookmarklet

**Knowledge Management:**
- Create notes: `SPC n r f`
- Link notes: `SPC n r i`
- View graph: `SPC n r g`
- Sync enterprise: `SPC m s`

## Configuration

### Basic Configuration
Edit `~/.config/doom/custom.el`:
```elisp
(setq user-full-name "Your Name"
      user-mail-address "your.email@example.com"
      adios-ewa-git-remote "git@github.com:yourorg/knowledge.git")
```

### AdiOS Integration Settings
```elisp
;; Enable AdiOS integration
(setq adios-doom-pkm-integration t
      adios-luna-ai-enabled t
      adios-sync-protocol-enabled t
      adios-gamification-enabled t)
```

## Development

```bash
# Clone for development
git clone https://github.com/tridentbiz/adios-doom-emacs-pkm.git
cd adios-doom-emacs-pkm

# Make changes
# Test locally
./scripts/test.sh

# Commit and push
git add . && git commit -m "Add new feature"
git push origin main
```

## License

MIT License - see LICENSE file