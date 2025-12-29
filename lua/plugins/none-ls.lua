return {
	"nvimtools/none-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting

		null_ls.setup({
			sources = {
				-- Lua
				formatting.stylua,

				-- Python
				formatting.black,
				formatting.isort,

				-- JavaScript/TypeScript
				formatting.prettier,

				-- Java
				formatting.google_java_format,

				-- Go
				formatting.gofmt,
				formatting.goimports,
			},
		})

		-- Format
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format file" })
	end,
}
