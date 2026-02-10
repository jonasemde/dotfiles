# Jonas' dotfiles

Personal dotfiles with modern shell tooling, optimized for Laravel/PHP development with Herd. Features fast startup times, smart directory navigation, and modern CLI tools.

Also used by some other geeks at [mindtwo.de](https://www.mindtwo.de)

Inspired by [freekmurze's dotfiles](https://github.com/freekmurze/dotfiles)

## Key Features

- **Custom Agnoster Theme** - Clean powerline prompt with no branch symbols, `•` for changes
- **Version-Controlled Skills & Agents** - All Claude Code skills and agents synced via dotfiles
- **Fast Tools** - fnm, zoxide, ripgrep, bat, eza (all Rust-based for speed)
- **Nerd Fonts** - Installed automatically via Brewfile for perfect icon support
- **One Command Install** - `bin/install` sets up everything including Claude Code
- **Herd Compatible** - Fully integrated with Laravel Herd for PHP management
- **Daily Updates** - Automated system updates twice daily (optional)

---

## Quick Start

```bash
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles
bin/install
```

---

## What's Included

### Shell & Prompt

- **Oh My Zsh** - Framework for managing Zsh configuration (with agnoster theme)
- **zoxide** - Smart directory jumping based on frecency (replaces z)
- **fzf** - Fuzzy finder for files and history
- **direnv** - Automatic environment variables per directory
- **zsh-artisan** - Laravel Artisan plugin

### Modern CLI Tools

- **fnm** - Fast Node.js version manager
- **bat** - Cat with syntax highlighting
- **eza** - Modern ls replacement with icons
- **ripgrep** - Fast grep alternative
- **fd** - Fast find alternative
- **git-delta** - Better git diffs
- **jq** - JSON processor and formatter
- **yq** - YAML processor and formatter
- **bottom** - Modern system monitor

### Development Tools

- **PHP** - Managed by Laravel Herd
- **Composer** - Dependency manager via Homebrew
- **Node.js** - LTS version managed via fnm
- **MySQL** - Database with auto-start
- **Mailhog** - Email testing tool

### QuickLook Plugins

Instant file previews in Finder: code files, markdown, JSON, CSV, patches, and archives.

---

## How It Works

### Symlinked Files

The installation creates symlinks from your home directory to the dotfiles repository. This allows you to version control your configuration while keeping files in their expected locations.

| Symlink Location | Points To | Purpose |
|-----------------|-----------|---------|
| `~/.zshrc` | `~/.dotfiles/home/.zshrc` | Main Zsh configuration (Oh My Zsh with agnoster) |
| `~/.gitconfig` | `~/.dotfiles/home/.gitconfig` | Git configuration with delta diff viewer |
| `~/.global-gitignore` | `~/.dotfiles/home/.global-gitignore` | Global Git ignore patterns |
| `~/.vimrc` | `~/.dotfiles/home/.vimrc` | Vim configuration |
| `~/.vim/` | `~/.dotfiles/home/.vim/` | Vim runtime files |
| `~/.mackup.cfg` | `~/.dotfiles/macos/.mackup.cfg` | Mackup backup configuration (if exists) |
| `~/.claude/skills` | `~/.dotfiles/config/claude/skills/` | All Claude Code skills (version-controlled) |
| `~/.claude/agents` | `~/.dotfiles/config/claude/agents/` | All Claude Code agents (version-controlled) |
| `~/.claude/CLAUDE.md` | `~/.dotfiles/config/claude/CLAUDE.md` | Claude Code configuration |
| `~/.claude/laravel-php-guidelines.md` | `~/.dotfiles/config/claude/laravel-php-guidelines.md` | Laravel coding standards |
| `~/.claude/settings.json` | `~/.dotfiles/config/claude/settings.json` | Claude Code settings |

### Sourced Files

These files are loaded by `.zshrc` but remain in the dotfiles directory:

- `home/.aliases` - Shell command aliases
- `home/.functions` - Custom shell functions
- `home/.exports` - Environment variables

### Custom Agnoster Theme

The default configuration uses a customized agnoster theme stored in `oh-my-zsh-custom/themes/agnoster.zsh-theme`:

**Customizations:**
- No git branch symbol (cleaner look)
- Uses `•` for unstaged changes instead of `±`
- Powerline arrows for segment separators
- Requires Nerd Font with powerline glyphs

**Git Status Symbols:**
- `✚` - Staged changes (files added with `git add`)
- `•` - Unstaged changes (modified files not yet staged)
- Yellow background - Uncommitted changes
- Green background - Clean working directory

---

## Daily Usage

### Smart Navigation

```bash
z dotfiles          # Jump to frequently used directories
zi                  # Interactive directory picker
Ctrl+R              # Fuzzy search command history
Ctrl+T              # Fuzzy find files
Alt+C               # Fuzzy change directory
```

### Laravel/PHP Shortcuts

```bash
a                   # php artisan
p                   # Run Pest/PHPUnit tests
c                   # composer
mfs                 # php artisan migrate:fresh --seed
nah                 # git reset --hard; git clean -df
```

### Data Processing

```bash
# JSON processing with jq
curl api.github.com/users/jonasemde | jq
cat composer.json | jq '.require'
php artisan tinker --execute="echo json_encode(User::first());" | jq

# YAML processing with yq
yq '.jobs' .github/workflows/ci.yml
yq -o json docker-compose.yml

# System monitoring
btm                 # Modern system monitor (aliased from top/htop)
```

### Maintenance Commands

```bash
bin/update          # Update all packages and tools
```

---

## Version Management

### Node.js (via fnm)

```bash
fnm install --lts     # Install latest LTS
fnm use lts-latest    # Use latest LTS
fnm install 20        # Install specific version
fnm use 20            # Switch to specific version
fnm list              # Show installed versions
```

### PHP (via Herd)

PHP is managed by Laravel Herd. Use the Herd app to switch PHP versions.

---

## Package Management

All Homebrew packages are declared in `config/Brewfile`. To add a new tool:

```bash
echo 'brew "neovim"' >> ~/.dotfiles/config/Brewfile
brew bundle --file=~/.dotfiles/config/Brewfile
```

**Complete package list in `config/Brewfile`:**

- **Core**: git, node, php, composer, wget, httpie, hub, gh, ack, mysql, yarn, mackup, httrack, mailhog
- **Modern CLI**: zoxide, bat, eza, ripgrep, fd, git-delta, fnm, fzf, direnv, jq, yq, bottom
- **Fonts**: font-meslo-lg-nerd-font (powerline icons and modern glyphs)
- **QuickLook**: qlcolorcode, qlstephen, qlmarkdown, quicklook-json, qlprettypatch, quicklook-csv, betterzip, suspicious-package

---

## Claude Code Integration

### Quick Install (Standalone)

Install just Claude Code without the full dotfiles:

```bash
curl -fsSL https://raw.githubusercontent.com/jonasemde/dotfiles/master/bin/install-claude-code | bash
```

### What's Included

- **Claude Code CLI** - Installed via Homebrew
- **Custom configuration** - CLAUDE.md with coding guidelines, laravel-php-guidelines.md
- **Version-controlled skills** - Entire `~/.claude/skills` directory symlinked to dotfiles
- **Version-controlled agents** - Entire `~/.claude/agents` directory symlinked to dotfiles

### Skills (Version Controlled)

All skills are stored in `config/claude/skills/` and version-controlled with your dotfiles. When you run the installer on a new Mac, all skills are immediately available.

### Adding New Skills

```bash
# Install a new skill (adds directly to your dotfiles)
npx skills add <owner/repo>

# Commit to version control
cd ~/.dotfiles
git add config/claude/skills/
git commit -m "Add new skill"
git push
```

Browse more skills at [skills.sh](https://skills.sh)

### Agents (Version Controlled)

All custom agents are stored in `config/claude/agents/` and version-controlled with your dotfiles.

---

## Daily Updates Automation

Automates system package updates for Homebrew, npm, and Composer. Runs twice daily (10 AM & 6 PM).

### Setup

The `bin/install` script automatically sets this up. To manually configure:

```bash
cd ~/.dotfiles
cp com.user.daily-updates.plist.template com.user.daily-updates.plist
cp bin/daily-updates.sh.template bin/daily-updates.sh
sed -i '' "s|/ABSOLUTE/PATH/TO/HOME|$HOME|g" com.user.daily-updates.plist bin/daily-updates.sh
cp com.user.daily-updates.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.user.daily-updates.plist
```

### Management

```bash
# Enable/Disable
launchctl load ~/Library/LaunchAgents/com.user.daily-updates.plist
launchctl unload ~/Library/LaunchAgents/com.user.daily-updates.plist

# Status & Manual Run
launchctl list | grep daily-updates
launchctl start com.user.daily-updates

# Logs
tail -f /tmp/daily-updates.log
```

**Note:** Working files contain user-specific paths and are git-ignored. Always edit `.template` versions.

---

## Customization

### Personal Aliases & Functions

Create custom configurations that won't be committed:

```bash
mkdir -p ~/.dotfiles-custom/shell
vim ~/.dotfiles-custom/shell/.aliases
```

These files are automatically loaded by `.zshrc` if they exist.

### Project-Specific Variables

Use `direnv` for automatic environment loading:

```bash
cd my-project
echo 'export DEBUG=true' > .envrc
direnv allow
```

Variables load when you enter the directory and unload when you leave.

---

## Post-Installation

1. **Configure iTerm2 font**:
   - Open iTerm2 Preferences (Cmd+,)
   - Go to Profiles → Text
   - Change Font to **MesloLGM Nerd Font Mono** (size 12-14)
   - Enable "Use built-in Powerline glyphs"

2. **Import theme**: In iTerm2, import color scheme from `config/iterm/`

3. **Restore settings** (optional): Run `mackup restore` if you have backups

4. **Migrate history** (upgrading only): Run `migration/migrate-z-to-zoxide.sh` if you have `~/.z`

5. **Set macOS defaults** (optional): Run `~/.dotfiles/macos/set-defaults.sh`

---

## Tool Comparisons

| Old Tool | New Tool | Why Better |
|----------|----------|------------|
| z.sh | zoxide | Smarter frecency algorithm, Rust speed |
| nvm | fnm | 40x faster, simpler, Rust-based |
| cat | bat | Syntax highlighting, git integration |
| ls | eza | Icons, tree view, git status |
| grep | ripgrep | 5-10x faster, respects .gitignore |
| find | fd | Simpler syntax, 10x faster |
| diff | delta | Side-by-side diffs, syntax highlighting |
| htop | bottom | Better UI, graphs, Rust-based |

---

## Utilities

The `bin/` directory contains helper scripts:

- **install** - Main installation script (idempotent, safe to re-run)
- **install-claude-code** - Standalone Claude Code installer
- **update** - Update dotfiles, Homebrew, npm, and Composer packages
- **daily-updates.sh** - Automated daily updates script (template)

---

## Migration Notes

If upgrading from an older setup:

1. **Directory structure**: Files moved from `shell/` to `home/` directory
2. **Directory history**: Run `migration/migrate-z-to-zoxide.sh` to import your `~/.z` data
3. **Version managers**: fnm manages Node.js (if not using Herd's node)
4. **Fonts**: Meslo Nerd Font installed via Brewfile
5. **Claude Code**: Now version-controlled in `config/claude/` and symlinked
6. **Custom Theme**: Custom agnoster theme stored in `oh-my-zsh-custom/themes/`

---

## Credits

Created and maintained by Jonas Emde

Used by the team at [mindtwo.de](https://www.mindtwo.de)

Inspired by [Freek Van der Herten's dotfiles](https://github.com/freekmurze/dotfiles)
