vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim...")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable", -- latest stable release
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup("plugins", {
  -- Automatically check for plugin updates
  checker = { enabled = true },
})
vim.opt.number = true         -- Absolute line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.shell = "/bin/bash"
vim.opt.clipboard = "unnamedplus"
vim.keymap.set("n", "<leader>ps", ":terminal<CR>")

-- Python: Run with Python
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.keymap.set("n", "<leader>r", ":!python %<CR>", { silent = true, buffer = true })
  end,
})

-- JavaScript: Run with Node.js
vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript",
  callback = function()
    vim.keymap.set("n", "<leader>r", ":!node %<CR>", { silent = true, buffer = true })
  end,
})

vim.diagnostic.config({
  virtual_text = false, -- keep code clean; rely on tooltip
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Show diagnostic tooltip automatically when cursor is idle
vim.o.updatetime = 250
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})
