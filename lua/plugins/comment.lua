return {
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({
      })
      vim.keymap.set("n", "<C-_>", function()
        require("Comment.api").toggle.linewise.current()
      end, { desc = "Toggle comment on current line" })

      vim.keymap.set("v", "<C-_>", function()
        -- Start comment for selected block
        require("Comment.api").toggle.linewise(vim.fn.visualmode())
      end, { desc = "Toggle comment on selected block" })
    end,
  },
}
