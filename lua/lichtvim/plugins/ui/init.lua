local utils = require("lichtvim.utils")

return {
  { "nvim-tree/nvim-web-devicons", lazy = true }, -- 图标
  { "MunifTanjim/nui.nvim", lazy = true },
  { import = "lichtvim.plugins.ui.alpha" },
  { import = "lichtvim.plugins.ui.lualine" },
  { import = "lichtvim.plugins.ui.bufferline" },
  { -- better notify
    "rcarriga/nvim-notify",
    keys = {
      { "<leader>fn", "<cmd>Telescope notify theme=dropdown<cr>", desc = "Notify" },
    },
    init = function()
      vim.notify = require("notify")
    end,
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    config = function(_, opts)
      require("notify").setup(opts)
      require("telescope").load_extension("notify")
      map.set(
        "n",
        "<leader>uq",
        utils.func.call(require("notify").dismiss, { silent = true, pending = true }),
        "Clear notifications"
      )
    end,
  },
  { -- better vim.ui
    "stevearc/dressing.nvim",
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
        },
        select = {
          backend = { "telescope", "nui" },
        },
      }
    end,
  },
  {
    "folke/trouble.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = utils.func.call(vim.cmd.cprev)
            if not ok then
              log.warn(err)
            end
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
            local ok, err = utils.func.call(vim.cmd.cnext)
            if not ok then
              log.warn(err)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
    opts = { use_diagnostic_signs = true },
  },
  {
    "luukvbaal/statuscol.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        segments = {
          { text = { " ", builtin.lnumfunc }, click = "v:lua.ScLa" },
          {
            sign = { name = { "Git" }, maxwidth = 1, colwidth = 1, auto = false, wrap = false },
            click = "v:lua.ScSa",
          },
          { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
        },
      })
    end,
  },
}
