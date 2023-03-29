return {
  {"tpope/vim-surround", event = {"BufRead", "BufNewFile"}},
  {"p00f/nvim-ts-rainbow", event = {"BufRead", "BufNewFile"}},
  { -- 自动配对
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {enable_check_bracket_line = false, ignored_next_char = "[%w%.]"}
  },
  {
    "andymass/vim-matchup",
    event = {"BufNewFile", "BufRead"},
    init = function()
      vim.g.matchup_matchparen_offscreen = {method = "poopup"}
    end
  }, 
  {"vim-scripts/indentpython.vim", ft = {"python", "djangohtml"}},
  { -- 缩进标识线
    "lukas-reineke/indent-blankline.nvim",
    event = {"BufNewFile", "BufRead"},
    opts = {
      show_current_context = true,
      show_current_context_start = true,
      filetype_exclude = {
        "alpha",
        "lazy",
        "terminal",
        "help",
        "log",
        "markdown",
        "TelescopePrompt",
        "mason",
        "toggleterm"
      }
    }
  },
  {
    "numToStr/Comment.nvim",
    event = {"BufRead", "BufNewFile"},
    opts = {
      toggler = {
        line = "gcc", -- 切换行注释
        block = "gCC" --- 切换块注释
      },
      opleader = {
        line = "gc", -- 可视模式下的行注释
        block = "gC" -- 可视模式下的块注释
      },
      extra = {
        above = "gcO", -- 在当前行上方新增行注释
        below = "gco", -- 在当前行下方新增行注释
        eol = "gcl" -- 在当前行行尾新增行注释
      },
      ignore = '^$'
    }
  }
}

