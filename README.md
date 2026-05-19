# ⚡ zsh-linux-setup

> One-shot Zsh power environment for Linux — Powerlevel10k, Oh My Zsh, smart plugins, nvm, pnpm, and IP tools, all wired up automatically.
>
> Pick the script for your distro and run it. More distros coming soon.

---

## 🐧 Supported Distros

| Distro | Examples | Script | Package manager |
|---|---|---|---|
| Arch-based | Arch Linux, Manjaro, EndeavourOS | `arch.sh` | `pacman` |
| Debian-based | Debian, Ubuntu, Kali, Mint, Pop!_OS | `debian.sh` | `apt` |

> More distro scripts are planned. Each script exits immediately if the expected package manager is not found.

---

## 📦 What It Installs

| Category | Tools |
|---|---|
| Shell | Zsh, Oh My Zsh, Powerlevel10k |
| Fonts | MesloLGS NF (Regular, Bold, Italic, Bold Italic) |
| Node | nvm → latest Node.js + npm → pnpm |
| System | thefuck, GitHub CLI (`gh`) |
| OMZ Plugins | See full list below |

### 🔌 Plugins

| Plugin | Source |
|---|---|
| `zsh-autosuggestions` | zsh-users |
| `zsh-syntax-highlighting` | zsh-users |
| `zsh-history-substring-search` | zsh-users |
| `zsh-completions` | zsh-users |
| `ipnav` | clebertmarctyson/oh-my-zsh-ipnav |
| `git`, `gh`, `git-auto-fetch` | Built-in OMZ |
| `npm`, `node`, `nvm`, `yarn` | Built-in OMZ |
| `docker`, `docker-compose` | Built-in OMZ |
| `pip`, `python` | Built-in OMZ |
| `sudo`, `extract`, `z`, `thefuck` | Built-in OMZ |
| `history`, `aliases`, `alias-finder` | Built-in OMZ |
| `colored-man-pages`, `command-not-found` | Built-in OMZ |
| `copypath`, `copyfile`, `dirhistory` | Built-in OMZ |
| `safe-paste`, `web-search`, `jsontools` | Built-in OMZ |
| `vscode` | Built-in OMZ |

---

## 🚀 Usage

```bash
# Clone the repo
git clone https://github.com/clebertmarctyson/zsh-linux-setup.git
cd zsh-linux-setup
```

Or run directly with one command:

```bash
# Arch-based
curl -fsSL https://raw.githubusercontent.com/clebertmarctyson/zsh-linux-setup/main/arch.sh | bash && source ~/.zshrc

# Debian-based (Ubuntu, Kali, Mint, Pop!_OS…)
curl -fsSL https://raw.githubusercontent.com/clebertmarctyson/zsh-linux-setup/main/debian.sh | bash && source ~/.zshrc
```

> **Note:** `exec zsh` does not work when the script is piped via `curl | bash`. Use `source ~/.zshrc` instead to reload your config in the current session.

---

## 🔡 Font Setup

After running the script, set your terminal font to **MesloLGS NF**.

The exact steps depend on your terminal emulator, but the general flow is:
1. Open your terminal's **Preferences** or **Profile settings**
2. Navigate to the **Font** or **Appearance** section
3. Enable a custom font and select **MesloLGS NF**

If the font doesn't appear, run:
```bash
fc-cache -fv | grep -i meslo
```

---

## 🔄 First Launch

On your first Zsh session, run:
```bash
p10k configure
```
This launches the Powerlevel10k interactive setup wizard.

---

## ⚙️ What the Scripts Do (Step by Step)

1. **Install Zsh** via the distro package manager if not present
2. **Install system packages** — `git`, `curl`, `thefuck`, GitHub CLI (`gh`)
3. **Install Oh My Zsh** non-interactively (`RUNZSH=no CHSH=no`)
4. **Patch `.bashrc`** to redirect interactive sessions to Zsh safely
5. **Install nvm** → latest Node.js → pnpm → `ip-navigator-cli`
6. **Clone** Powerlevel10k theme + third-party plugins
7. **Download MesloLGS NF fonts** with partial-file cleanup on failure
8. **Write a complete `.zshrc`** with all plugins and environment config

---

## 🛡️ Safety Features

- `set -euo pipefail` — aborts on any error
- Distro guard — each script exits early on the wrong system
- Idempotent — all steps check before installing, safe to re-run
- Bash → Zsh redirect only fires in interactive shells (`$- == *i*`)
- Font partial-file cleanup on failed `curl` download

---

## 📝 License

MIT
