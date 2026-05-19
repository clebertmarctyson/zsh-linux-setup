# ⚡ zsh-linux-setup

> One-shot Zsh power environment for Linux — Powerlevel10k, Oh My Zsh, smart plugins, nvm, pnpm, and IP tools, all wired up automatically.
>
> Supports **Arch Linux** and **Ubuntu/Debian**.

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

## 🖥️ Requirements

| Distro | Script | Package manager |
|---|---|---|
| Arch Linux / Manjaro / EndeavourOS | `arch.sh` | `pacman` |
| Ubuntu / Debian / Mint / Pop!_OS | `ubuntu.sh` | `apt` |

> Each script exits immediately if the expected package manager is not found.

---

## 🚀 Usage

```bash
# Clone the repo
git clone https://github.com/clebertmarctyson/zsh-linux-setup.git
cd zsh-linux-setup
```

**Arch Linux:**
```bash
chmod +x arch.sh && ./arch.sh
```

**Ubuntu / Debian:**
```bash
chmod +x ubuntu.sh && ./ubuntu.sh
```

---

## 🔡 Font Setup

After running the script, set your terminal font to **MesloLGS NF**.

**Konsole (Arch):**
1. **Settings** → **Edit Current Profile...** → **Appearance** → **Choose...**
2. Search for `MesloLGS NF` → select → **OK** → **Apply**

**GNOME Terminal (Ubuntu):**
1. **Edit** → **Preferences** → select your profile → **Text** tab
2. Enable **Custom font** → click the font button → search for `MesloLGS NF` → **Select**

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
   - Ubuntu: adds the official `cli.github.com` apt repo before installing `gh`
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
