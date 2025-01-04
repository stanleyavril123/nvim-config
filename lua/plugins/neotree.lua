return {
  {
    -- Neo-tree
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true, -- Automatically close if it's the last window
        filesystem = {
          filtered_items = {
            visible = true, -- Show hidden files
            hide_dotfiles = false,
          },
        },
      })
      -- Key mapping to toggle Neo-tree
      vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>', { silent = true })
    end,
  }
}
