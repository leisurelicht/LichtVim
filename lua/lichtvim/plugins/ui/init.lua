return {
  { "nvim-tree/nvim-web-devicons", lazy = true }, -- 图标
  { "MunifTanjim/nui.nvim", lazy = true },
  { import = "lichtvim.plugins.ui.alpha" },
  { import = "lichtvim.plugins.ui.lualine" },
  { import = "lichtvim.plugins.ui.bufferline" },
  { -- lsp progress
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      window = {
        relative = "editor",
      },
    },
    config = true,
  },
  { -- notify
    "rcarriga/nvim-notify",
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
      vim.notify = require("notify")
    end,
  },
  { -- better vim.ui
    "stevearc/dressing.nvim",
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
    opts = function()
      return {
        input = {
          relative = "cursor",
          win_options = {
            listchars = "precedes:❮,extends:❯",
          },
          mappings = {
            i = {
              ["<esc>"] = "close",
            },
          },
        },
        select = {
          backend = { "telescope", "builtin" },
        },
      }
    end,
  },
  {
    "folke/trouble.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = { use_diagnostic_signs = true },
  },
}
