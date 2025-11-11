return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		opts = {}, -- mason default setup
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				"pyright",
				"clangd",
				"jdtls",
				"html",
				"gopls",
				"sqls",
			},
			automatic_installation = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- list of "boring" servers
			local servers = { "pyright", "clangd", "jdtls", "html", "gopls", "sqls" }

			for _, server in ipairs(servers) do
				lspconfig[server].setup({ capabilities = capabilities })
			end

			-- lua_ls with extra settings
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			})

			-- ts_ls with inlay hints only
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayFunctionLikeReturnTypeHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayFunctionLikeReturnTypeHints = true,
						},
					},
				},
			})

			-- keymaps, same as you already had
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
			vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
		end,
	},
}
