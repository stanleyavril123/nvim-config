# Dotfiles

Reproducible Ubuntu development environment for Neovim, Kitty, and tmux. The
bootstrap installs pinned application and font versions, links the tracked
configuration into `$HOME`, and restores Neovim plugins and development tools.

<p align="center">
  <img src=".config/nvim/assets/screenshot-dashboard.png" alt="Neovim dashboard" width="700"/>
</p>

## Fresh Ubuntu Installation

```bash
sudo apt update && sudo apt install -y git
git clone https://github.com/stanleyavril123/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

Restart Kitty after the installer completes. Then open Neovim and run
`:checkhealth` if you want to inspect the installed providers.

The installer is safe to run again. Existing files that are not already linked
to this repository are moved to timestamped backups before the links are made.

To install only the links without downloading packages or tools:

```bash
~/.dotfiles/install.sh --link-only
```

To install the editor and terminal setup without optional coding-agent CLIs:

```bash
~/.dotfiles/install.sh --no-agents
```

## Managed Setup

- Neovim 0.10.3 and its locked plugins
- Kitty 0.32.2 with transparency
- A shared theme selector for Kitty, tmux, and Neovim
- Kitty windows start maximized through the tracked `~/.local/bin/kitty` launcher
- tmux with `Ctrl-a`, Vim navigation, copy mode, and system clipboard support
- JetBrainsMono Nerd Font 3.3.0
- Starship 1.24.2 with a colored Nerd Font prompt and Git status
- Mason language servers and formatters
- Claude Code stable channel
- A terminal-first coding-agent workflow using tmux and Git
- Ubuntu command-line dependencies such as ripgrep, Node.js, Python, and build tools

Configuration is stored in the standard home-directory layout:

```text
~/.dotfiles/
├── .config/
│   ├── kitty/
│   ├── bash/
│   ├── nvim/
│   ├── themes/
│   └── starship.toml
├── bin/
├── .tmux.conf
└── install.sh
```

The installer creates these links:

```text
~/.config/nvim  -> ~/.dotfiles/.config/nvim
~/.config/kitty -> ~/.dotfiles/.config/kitty
~/.config/bash/prompt.bash -> ~/.dotfiles/.config/bash/prompt.bash
~/.config/starship.toml -> ~/.dotfiles/.config/starship.toml
~/.tmux.conf    -> ~/.dotfiles/.tmux.conf
~/.local/bin/kitty -> ~/.dotfiles/bin/kitty
~/.local/bin/theme -> ~/.dotfiles/bin/theme
```

## Themes

`theme` switches the color theme of Kitty, tmux, and Neovim together, including
sessions that are already open.

```bash
theme              # pick a theme, with live preview
theme list         # list the available themes
theme set nord     # apply a theme by name
theme next         # cycle to the next theme
```

The picker applies each theme as the selection moves and restores the previous
one if you leave with `Esc`. `Ctrl-Shift-p` opens it in a Kitty overlay,
`Ctrl-a T` in a tmux popup, and `<leader>ut` or `:Theme` inside Neovim.

23 themes are included:

| Theme | Variants |
| --- | --- |
| Catppuccin | Mocha, Latte |
| Tokyo Night | Night, Storm, Day |
| Gruvbox | Dark, Light |
| Rose Pine | Main, Dawn |
| Solarized | Dark, Light |
| GitHub | Dark, Light |
| Ayu | Dark, Mirage |
| Dracula | - |
| One Dark | - |
| Monokai | - |
| Nord | - |
| Nightfox | Nightfox, Carbonfox |
| Kanagawa | Wave |
| Everforest | Dark |

Each theme is a palette file in [.config/themes](.config/themes). Applying one
writes the generated color files that Kitty, tmux, and Neovim read:

```text
~/.config/kitty/theme.conf       included by kitty.conf, untracked
~/.local/state/theme/current     active theme name
~/.local/state/theme/tmux.conf   sourced by ~/.tmux.conf
~/.local/state/theme/nvim.lua    read and watched by Neovim
```

Kitty only resolves include paths relative to its own configuration directory,
which is why its generated file sits there and is listed in `.gitignore`.
Recoloring an open Kitty window uses its remote control socket, so windows that
were already running before this configuration was installed need one restart.

Add a theme by copying a palette file, either into `.config/themes` to track it
or into `~/.config/themes` to keep it on one machine. Neovim needs a matching
color scheme plugin in
[colorschemes.lua](.config/nvim/lua/plugins/colorschemes.lua); the palette
file's `nvim_plugin` and `nvim_colorscheme` values point at it.

### Readability

Published terminal palettes are drawn for looks rather than for contrast, and
many leave text uncomfortable to read, especially the light ones. Every palette
here is therefore checked against WCAG contrast ratios, measured against its own
background:

| Role | Minimum contrast |
| --- | --- |
| `foreground` | 7.0, AAA body text |
| colors 1-7, 9-15, `cursor`, selected text | 4.5, AA body text |
| `color8`, used for dim text | 3.0 |
| `color0` on a dark theme | 1.6, a shade of the background |

Colors that fell short were moved in lightness only, so hue and saturation stay
as published. Rerun the check after editing a palette:

```bash
~/.dotfiles/bin/theme-contrast         # report every palette
~/.dotfiles/bin/theme-contrast --fix   # raise whatever is below the floor
```

Neovim needs the same care, and it renders on Kitty's background because its
color schemes run transparent, so
[theme.lua](.config/nvim/lua/config/theme.lua) measures against that background
and lifts `Normal`, `Comment`, `LineNr`, `NonText`, and `Whitespace` when a color
scheme dims them too far. It also strips any background a color scheme paints
itself, which keeps Kitty's opacity working everywhere.

## Updating

Edit the files through their normal paths, commit from `~/.dotfiles`, and push:

```bash
cd ~/.dotfiles
git add .
git commit -m "chore: update development environment"
git push
```

On another computer:

```bash
cd ~/.dotfiles
git pull
./install.sh
```

That is the normal sync loop: make a change on one computer, commit and push
it, then pull and rerun the installer on the other. The symlinks mean edits made
through `~/.config/nvim`, `~/.config/kitty`, or `~/.tmux.conf` are edits to this
repository and are ready to commit.

## What Stays Machine-local

The installer adds one source line to `~/.bashrc` for the tracked prompt config.
The repository deliberately does not contain SSH keys, GitHub tokens, or Claude
credentials. Sign in to the required services once on each computer. Everything
else listed above is recreated by the installer.

## Neovim Workflow

Leader is `Space`.

| Mapping | Action |
| --- | --- |
| `<C-p>` / `<leader>sf` | Find files |
| `<leader>sg` | Live grep project |
| `<leader>xx` | Workspace diagnostics |
| `<leader>xb` | Buffer diagnostics |
| `<S-h>` / `<S-l>` | Previous or next buffer |
| `<leader>bp` | Pick a visible buffer |
| `<leader>bd` | Close buffer |
| `<C-n>` | Toggle file explorer |
| `<leader>gg` | Open Neogit |
| `<leader>gd` | Open Diffview |
| `<leader>mp` | Toggle rendered Markdown preview |
| `<leader>ut` | Switch theme |

Use `:Mason`, `:ConformInfo`, `:OverseerRun`, and `:checkhealth` to inspect the
development tooling.

## Coding Agents

Coding agents run in a separate tmux pane while Neovim remains the editor and
Git provides the review boundary. From a project opened in Neovim:

1. Press `Ctrl-a v` to create a pane on the right.
2. Start `codex` or `claude` from the project root and give it a coherent task.
3. Move between the editor and agent with `Ctrl-h` and `Ctrl-l`.
4. After the agent finishes, use `[h` and `]h` to inspect changed hunks or
   `<leader>gd` to review the complete working-tree diff.
5. Use `<leader>gg` to stage, discard, and commit the reviewed changes.

Neovim checks for externally modified files when focus returns, so edits made by
the agent are reloaded without an agent-specific preview plugin. Commit before a
large task when an easy rollback point is useful.

## tmux Workflow

`Ctrl-a` is the prefix. Use `Ctrl-a [` to enter Vim-style copy mode, `v` to
select, `y` or `Enter` to copy, and `Ctrl-a ]` to paste. Prefix followed by
`h`, `j`, `k`, or `l` changes panes. `Ctrl-a T` opens the theme picker.

## License

MIT - see [LICENSE](LICENSE).
