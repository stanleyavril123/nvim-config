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
				transparent_background = true,
				custom_highlights = function(cp)
					return {
						WinSeparator = { fg = cp.surface1, bg = "NONE" },
					}
				end,
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
