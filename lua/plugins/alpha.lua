return {
  {
    "goolord/alpha-nvim",
    -- load on startup
    event = "VimEnter",
    -- optional: to get icons in your buttons
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- 1) Customize your header (ASCII art)
      dashboard.section.header.val = {
        [[                                  __]],
        [[     ___     ___    ___   __  __ /\_\    ___ ___]],
        [[    / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\]],
        [[   /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \]],
        [[   \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[    \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
      }

      -- 2) Define buttons
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("t", "  Find text", ":Telescope live_grep<CR>"),
        dashboard.button("q", "  Quit NVIM", ":qa<CR>"),
      }

      -- 3) (Optional) Footer
      dashboard.section.footer.val = ""
      table.insert(dashboard.config.layout, 1, { type = "padding", val = 4 })
      -- 4) Send to alpha
      alpha.setup(dashboard.config)
    end,
  },
}
