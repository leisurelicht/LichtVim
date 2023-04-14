return {
  require("lichtvim.plugins.ui.theme"),
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
  { -- better vim.ui
    "stevearc/dressing.nvim",
    enabled = true,
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
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
  require("lichtvim.plugins.ui.alpha"),
  require("lichtvim.plugins.ui.lualine"),
  require("lichtvim.plugins.ui.tabby"),
  -- require("lichtvim.plugins.ui.trouble"),
}
