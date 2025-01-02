return {
  {
    -- nvim-treesitter plugin
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        highlight = {
          enable = true, -- Enables syntax highlighting
        },
        indent = {
          enable = true, -- Enables improved indentation
        },
      })
    end,
  },
}
