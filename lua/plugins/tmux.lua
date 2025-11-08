return {
	"christoomey/vim-tmux-navigator",
	lazy = false,
	init = function()
		vim.g.tmux_navigator_no_mappings = 1
	end,
	keys = {
		{ "<C-h>", "<Cmd>TmuxNavigateLeft<CR>", desc = "Navigate left" },
		{ "<C-j>", "<Cmd>TmuxNavigateDown<CR>", desc = "Navigate down" },
		{ "<C-k>", "<Cmd>TmuxNavigateUp<CR>", desc = "Navigate up" },
		{ "<C-l>", "<Cmd>TmuxNavigateRight<CR>", desc = "Navigate right" },
		{ "<C-\\>", "<Cmd>TmuxNavigatePrevious<CR>", desc = "Navigate previous" },
	},
}
