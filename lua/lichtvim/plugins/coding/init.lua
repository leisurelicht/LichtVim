return {
  { import = "lichtvim.plugins.coding.indent" },
  { import = "lichtvim.plugins.coding.git" },
  { "tpope/vim-surround", event = { "BufRead", "BufNewFile" } },
  { -- 自动配对
    "windwp/nvim-autopairs",
    enabled = true,
    event = "InsertEnter",
    opts = { enable_check_bracket_line = false, ignored_next_char = "[%w%.]" },
  },
  {
    "andymass/vim-matchup",
    event = { "BufNewFile", "BufRead" },
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "poopup" }
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
  {
    "ahmedkhalf/project.nvim",
    opts = {
      manual_mode = false,
      detection_methods = { "pattern" },
      patterns = {
        ".git",
        "_darcs",
        ".hg",
        ".bzr",
        ".svn",
        "Makefile",
        "package.json",
        "go.mod",
        "requirements.txt",
        "pyproject.toml",
        "Cargo.toml",
      },
      ignore_lsp = { "dockerls", "null_ls", "copilot" },
      exclude_dirs = { "/", "~" },
      show_hidden = false,
      silent_chdir = true,
      scope_chdir = "tab",
      datapath = vim.fn.stdpath("data"),
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
    end,
  },
  {
    "m4xshen/smartcolumn.nvim",
    event = { "BufNewFile", "BufRead" },
    opts = {
      colorcolumn = "0",
      disabled_filetypes = {
        "help",
        "text",
        "markdown",
        "lazy",
        "mason",
        "notify",
        "alpha",
        "checkhealth",
      },
      custom_colorcolumn = {
        ["htmldjango"] = "120",
      },
      scope = "file",
    },
    config = function(_, opts)
      require("smartcolumn").setup(opts)
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved", -- 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    },
    config = true,
  },
}
