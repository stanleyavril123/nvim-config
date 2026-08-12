return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "auto",
				globalstatus = true,
				component_separators = { left = "│", right = "│" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { statusline = { "alpha" } },
			},
			sections = {
				lualine_a = { {
					"mode",
					fmt = function(value)
						return value:sub(1, 1)
					end,
				} },
				lualine_b = { "branch", "diff" },
				lualine_c = {
					{ "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" } },
				},
				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
					},
					"encoding",
					"fileformat",
				},
				lualine_y = { "filetype", "progress" },
				lualine_z = { "location" },
			},
			extensions = { "lazy", "mason", "neo-tree", "trouble" },
		},
	},
}
