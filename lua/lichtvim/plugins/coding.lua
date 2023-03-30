return {
  { "tpope/vim-surround", event = { "BufRead", "BufNewFile" } },
  { "p00f/nvim-ts-rainbow", event = { "BufRead", "BufNewFile" } },
  { -- 自动配对
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { enable_check_bracket_line = false, ignored_next_char = "[%w%.]" },
  },
  {
    "andymass/vim-matchup",
    event = { "BufNewFile", "BufRead" },
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "poopup" }
      if lazy.has("which-key.nvim") then
        require("which-key").register({
          ["]%"] = "Next Matchup",
          ["[%"] = "Previous Matchup",
          mode = "n",
        })
      end
    end,
  },
  { -- 缩进标识线
    "lukas-reineke/indent-blankline.nvim",
    enabled = true,
    event = { "BufNewFile", "BufRead" },
    opts = {
      show_current_context = false,
      show_current_context_start = false,
      filetype_exclude = {
        "log",
        "help",
        "lazy",
        "mason",
        "alpha",
        "neo-tree",
        "NvimTree",
        "Trouble",
        "terminal",
        "markdown",
        "dashboard",
        "toggleterm",
        "TelescopePrompt",
      },
    },
  },
  { "vim-scripts/indentpython.vim", enabled = false, ft = { "python", "djangohtml" } },
  {
    "echasnovski/mini.indentscope",
    enabled = true,
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "log",
          "help",
          "lazy",
          "mason",
          "alpha",
          "neo-tree",
          "NvimTree",
          "Trouble",
          "terminal",
          "markdown",
          "dashboard",
          "toggleterm",
          "TelescopePrompt",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
    config = function(_, opts)
      require("mini.indentscope").setup(opts)
      if lazy.has("which-key.nvim") then
        require("which-key").register({
          ["]i"] = "Goto Indent Scope Bottom",
          ["[i"] = "Goto Indent Scope Top",
          mode = "n",
        })
      end
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufRead", "BufNewFile" },
    opts = {
      toggler = {
        line = "gcc", -- 切换行注释
        block = "gCC", --- 切换块注释
      },
      opleader = {
        line = "gc", -- 可视模式下的行注释
        block = "gC", -- 可视模式下的块注释
      },
      extra = {
        above = "gcO", -- 在当前行上方新增行注释
        below = "gco", -- 在当前行下方新增行注释
        eol = "gcl", -- 在当前行行尾新增行注释
      },
      ignore = "^$",
    },
  },
}
