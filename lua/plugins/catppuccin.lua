return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.opt.termguicolors = true
			vim.opt.background = "dark"

			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = false,
				custom_highlights = function(cp)
					return {
						Normal = { bg = "#000000" },
						NormalNC = { bg = "#000000" },
						SignColumn = { bg = "#000000" },
						Folded = { bg = "#000000" },
						WinSeparator = { fg = cp.surface1, bg = "#000000" },
					}
				end,
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
