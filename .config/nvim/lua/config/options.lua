local opt = vim.opt

opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.laststatus = 3
opt.showmode = false
opt.pumheight = 12
opt.title = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldclose = "", diff = "╱" }

opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"
opt.scrolloff = 6
opt.sidescrolloff = 8
opt.wrap = false

opt.splitbelow = true
opt.splitright = true
opt.confirm = true
opt.autoread = true
opt.updatetime = 250
opt.timeoutlen = 400

opt.clipboard = "unnamedplus"
opt.completeopt = { "menu", "menuone" }

opt.undofile = true
local undodir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undodir, "p")
opt.undodir = undodir

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
