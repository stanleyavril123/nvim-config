-- Color schemes selectable through `theme` (see lua/config/theme.lua). Every
-- plugin stays lazy; the theme module loads the one the active theme needs.
-- Backgrounds are transparent so Kitty's own background shows through.
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		opts = {
			transparent_background = true,
			integrations = {
				alpha = true,
				cmp = true,
				gitsigns = true,
				indent_blankline = { enabled = true, scope_color = "mauve" },
				mason = true,
				native_lsp = { enabled = true },
				neotree = true,
				telescope = { enabled = true },
				treesitter = true,
				trouble = true,
				which_key = true,
			},
			custom_highlights = function(cp)
				return {
					CursorLine = { bg = cp.surface0 },
					CursorLineNr = { fg = cp.peach, bold = true },
					FloatBorder = { fg = cp.surface1, bg = cp.mantle },
					LineNr = { fg = cp.overlay0 },
					NormalFloat = { bg = cp.mantle },
					Pmenu = { bg = cp.mantle },
					PmenuSel = { bg = cp.surface1, bold = true },
					Visual = { bg = cp.surface1 },
					WinSeparator = { fg = cp.surface0, bg = "NONE" },
					TelescopeBorder = { fg = cp.surface1, bg = cp.mantle },
					TelescopeNormal = { bg = cp.mantle },
					TelescopePreviewTitle = { fg = cp.crust, bg = cp.green, bold = true },
					TelescopePromptBorder = { fg = cp.blue, bg = cp.mantle },
					TelescopePromptTitle = { fg = cp.crust, bg = cp.blue, bold = true },
					TelescopeResultsTitle = { fg = cp.crust, bg = cp.mauve, bold = true },
				}
			end,
		},
	},
	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = {
			transparent = true,
			styles = { sidebars = "transparent", floats = "transparent" },
		},
	},
	{
		"ellisonleao/gruvbox.nvim",
		lazy = true,
		opts = { transparent_mode = true },
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = true,
		opts = { styles = { transparency = true } },
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		opts = { transparent = true },
	},
	{
		"gbprod/nord.nvim",
		lazy = true,
		opts = { transparent = true },
	},
	{
		"neanias/everforest-nvim",
		main = "everforest",
		lazy = true,
		opts = { background = "medium", transparent_background_level = 2 },
	},
	{
		"Mofiqul/dracula.nvim",
		lazy = true,
		opts = { transparent_bg = true },
	},
	{
		"navarasu/onedark.nvim",
		lazy = true,
		opts = { style = "dark", transparent = true },
	},
	{
		"maxmx03/solarized.nvim",
		lazy = true,
		opts = { transparent = { enabled = true } },
	},
	{
		"projekt0n/github-nvim-theme",
		main = "github-theme",
		lazy = true,
		opts = { options = { transparent = true } },
	},
	{
		"Shatur/neovim-ayu",
		main = "ayu",
		lazy = true,
		opts = { terminal = false, overrides = { Normal = { bg = "NONE" } } },
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = true,
		opts = { options = { transparent = true } },
	},
	{
		-- No opts: its colors/monokai.vim calls setup() with no arguments, so
		-- any configuration here would be discarded. config/theme.lua strips the
		-- background it paints.
		"tanvirtin/monokai.nvim",
		lazy = true,
	},
}
