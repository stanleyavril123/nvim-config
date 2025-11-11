return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			telescope.setup({
				defaults = {
					file_ignore_patterns = { "venv/", "%.pyc", "__pycache__/", "node_modules" },
				},
				pickers = {
					colorscheme = { enable_preview = true },
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
			pcall(telescope.load_extension, "fzf")

			-- FILES
			vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Resume last picker" })

			-- SEARCH CODE
			vim.keymap.set("n", "<leader>sw", builtin.current_buffer_fuzzy_find, { desc = "Search in current file" })
			vim.keymap.set("n", "<leader>st", builtin.treesitter, { desc = "Treesitter symbols in file" })

			vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "Find references (LSP)" })
			vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Go to definition (LSP)" })
		end,
	},
}
