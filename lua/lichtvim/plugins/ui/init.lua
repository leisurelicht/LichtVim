return {
  { "nvim-tree/nvim-web-devicons", lazy = true }, -- 图标
  { "MunifTanjim/nui.nvim", lazy = true },
  { import = "lichtvim.plugins.ui.alpha" },
  { import = "lichtvim.plugins.ui.lualine" },
  { import = "lichtvim.plugins.ui.bufferline" },
  { -- lsp progress
    "j-hui/fidget.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("fidget").setup({ window = { blend = 0 } })
    end,
  },
  { -- notify
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>uq",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Clear notifications",
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
      vim.notify = require("notify")
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
          override = function(conf)
            local title = vim.trim(conf.title)
            local buf = vim.api.nvim_get_current_buf()
            local ft = vim.api.nvim_buf_get_option(buf, "filetype")
            if ft == "NvimTree" and title == "Rename to" then
              if conf.relative == "editor" then
                conf.title = " Move to "
              else
                conf.title = " Rename to "
              end
            end
            return conf
          end,
          get_config = function(conf)
            local buf = vim.api.nvim_get_current_buf()
            local ft = vim.api.nvim_buf_get_option(buf, "filetype")
            local prompt = vim.trim(conf.prompt)
            local is_path = vim.fn.isdirectory(conf.default) == 1
            local opts = {}
            if ft == "NvimTree" and prompt == "Rename to" and is_path then
              opts["relative"] = "editor"
            end
            return opts
          end,
        },
        select = {
          get_config = function(conf)
            local str = require("lichtvim.utils").str
            local buf = vim.api.nvim_get_current_buf()
            local ft = vim.api.nvim_buf_get_option(buf, "filetype")
            local opts = {}
            if ft == "NvimTree" and str.starts_with(conf.prompt, "Remove") then
              opts["backend"] = "telescope"
            end
            return opts
          end,
        },
      }
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            vim.cmd.cprev()
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            vim.cmd.cnext()
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },
}
