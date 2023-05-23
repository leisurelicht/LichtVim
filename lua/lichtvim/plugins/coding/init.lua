return {
  { import = "lichtvim.plugins.coding.indent" },
  { import = "lichtvim.plugins.coding.git" },
  { import = "lichtvim.plugins.coding.toggleterm" },
  { "tpope/vim-surround", event = { "BufRead", "BufNewFile" } },
  { -- 自动配对
    "windwp/nvim-autopairs",
    enabled = true,
    event = { "BufNewFile", "BufRead" },
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
    -- event = "VeryLazy",
    cmd = { "Telescope", "ProjectRoot", "AddProject" },
    dependencies = { "telescope.nvim" },
    opts = {
      manual_mode = true,
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
      silent_chdir = false,
      scope_chdir = "tab",
      datapath = vim.fn.stdpath("data"),
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
      require("telescope").load_extension("projects")
    end,
  },
  {
    "m4xshen/smartcolumn.nvim",
    event = { "BufNewFile", "BufRead" },
    opts = {
      colorcolumn = "80",
      disabled_filetypes = {
        "help",
        "text",
        "markdown",
        "lazy",
        "mason",
        "notify",
        "alpha",
      },
      custom_colorcolumn = {
        ["htmldjango"] = "120",
        ["lua"] = "120",
      },
      scope = "file",
    },
  },
}
