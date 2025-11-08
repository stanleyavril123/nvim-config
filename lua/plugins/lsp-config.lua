return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
			ensure_installed = { "lua_ls", "ts_ls", "pyright", "clangd", "jdtls", "html", "gopls", "angularls", "sqls" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			local util = require("lspconfig.util")

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				root_dir = function(fname)
					-- pass VARARGS, not a table
					local ts_root = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")
					return ts_root(fname) or util.find_git_ancestor(fname) or vim.loop.cwd()
				end,
			})
			lspconfig.angularls.setup({
				capabilities = capabilities,
				root_dir = function(fname)
					local ng_root = util.root_pattern("angular.json", "project.json", "nx.json", "package.json", ".git")
					return ng_root(fname) or util.find_git_ancestor(fname) or vim.loop.cwd()
				end,
			})
			lspconfig.pyright.setup({ capabilities = capabilities })
			lspconfig.clangd.setup({ capabilities = capabilities })
			lspconfig.jdtls.setup({ capabilities = capabilities })
			lspconfig.html.setup({ capabilities = capabilities })
			lspconfig.gopls.setup({ capabilities = capabilities })
			lspconfig.sqls.setup({ capabilities = capabilities })

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
