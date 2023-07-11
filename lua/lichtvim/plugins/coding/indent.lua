local utils = require("lichtvim.utils")

return {
  { "vim-scripts/indentpython.vim", ft = { "python", "djangohtml" } },
  { -- 缩进标识线
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      show_current_context = false,
      show_current_context_start = false,
      filetype_exclude = {
        "log",
        "help",
        "lazy",
        "noice",
        "mason",
        "alpha",
        "notify",
        "neo-tree",
        "NvimTree",
        "Trouble",
        "terminal",
        "lazyterm",
        "markdown",
        "dashboard",
        "toggleterm",
        "TelescopePrompt",
      },
      buftype_exclude = { "terminal" },
    },
  },
  {
    "echasnovski/mini.indentscope",
    opts = { symbol = "│", options = { try_as_border = true } },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup(utils.title.add("DisableMiniIndentScope"), { clear = true }),
        pattern = {
          "log",
          "help",
          "lazy",
          "noice",
          "mason",
          "alpha",
          "notify",
          "neo-tree",
          "NvimTree",
          "Trouble",
          "terminal",
          "lazyterm",
          "markdown",
          "dashboard",
          "toggleterm",
          "TelescopePrompt",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
      require("which-key").register({
        ["]i"] = "Goto indent scope bottom",
        ["[i"] = "Goto indent scope top",
      }, { mode = "n" })
    end,
    config = true,
  },
}
