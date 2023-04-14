return {
  { "nvim-tree/nvim-web-devicons", lazy = true }, -- 图标
  { -- notify
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>uc",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Clear notify",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    init = function()
      if not lazy.has("noice.nvim") then
        lazy.on_very_lazy(function()
          vim.notify = require("notify")
        end)
      end
    end,
  },
  { -- lsp progress
    "j-hui/fidget.nvim",
    enabled = function()
      return vim.g.neovide
    end,
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("fidget").setup({
        window = { blend = 0 },
      })
    end,
  },

  require("lichtvim.plugins.ui.theme"),
  require("lichtvim.plugins.ui.alpha"),
  require("lichtvim.plugins.ui.lualine"),
  require("lichtvim.plugins.ui.tabby"),
  require("lichtvim.plugins.ui.trouble"),
  require("lichtvim.plugins.ui.dressing"),
}
