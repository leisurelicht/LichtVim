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
    opts = { use_diagnostic_signs = true },
  },
  {
    "kevinhwang91/nvim-ufo",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
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
    },
    init = function()
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
      open_fold_hl_timeout = 400,
      close_fold_kinds = { "imports", "comment" },
      preview = {
        win_config = {
          border = { "", "─", "", "", "", "─", "", "" },
          winblend = 0,
        },
        mappings = {
          scrollU = "<C-u>",
          scrollD = "<C-d>",
          jumpTop = "[",
          jumpBot = "]",
        },
      },
    },
    config = function(_, opts)
      require("ufo").setup(opts)
    end,
  },
}
