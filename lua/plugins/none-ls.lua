return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting
    null_ls.setup({
      sources = {
        -- formatting
        -- lua
        formatting.stylua,
        -- python
        formatting.black,
        formatting.isort,
        -- javaScript
        formatting.prettierd,
        --Java
        formatting.google_java_format,
        -- Golang
        formatting.goimports,
      },
    })
    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
  end,
}
