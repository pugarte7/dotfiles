# dotfiles

My personal collection of curated dotfiles. Kitty & Neovim based workflow.

## Layout

| Path | Contents |
| --- | --- |
| `claude/` | Claude Code setup: `settings.json`, `CLAUDE.md`, hooks, skills, plugins |
| `karabiner/` | Karabiner-Elements keyboard remapping |
| `kitty/` | Kitty terminal config and theme |
| `nvim/` | Neovim config (NvChad + lazy.nvim) |
| `wezterm/` | WezTerm config |
| `zsh/` | `.zshrc` and powerlevel10k prompt |

## Install

Clone, then symlink whatever you want:

```sh
git clone https://github.com/pugarte7/dotfiles.git ~/dotfiles
cd ~/dotfiles

ln -s "$PWD/nvim"                 ~/.config/nvim
ln -s "$PWD/kitty"                ~/.config/kitty
ln -s "$PWD/claude/CLAUDE.md"     ~/.claude/CLAUDE.md
ln -s "$PWD/claude/settings.json" ~/.claude/settings.json
ln -s "$PWD/claude/skills"        ~/.claude/skills
ln -s "$PWD/claude/hooks"         ~/.claude/hooks
ln -s "$PWD/zsh/.zshrc"           ~/.zshrc
ln -s "$PWD/zsh/.p10k.zsh"        ~/.p10k.zsh
ln -s "$PWD/wezterm/.wezterm.lua" ~/.wezterm.lua
```

`~/.claude` itself is Claude Code state (history, projects, cache), so link the files
inside it rather than the directory. `claude/plugins/` is reference only, see
claude/README.md.

Neovim will bootstrap lazy.nvim and install plugins on first launch.
