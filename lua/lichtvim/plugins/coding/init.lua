return {
  { import = "lichtvim.plugins.coding.indent" },
  { import = "lichtvim.plugins.coding.autopairs" },
  { import = "lichtvim.plugins.coding.git" },
  { import = "lichtvim.plugins.coding.toggleterm" },
  -- { import = "lichtvim.plugins.coding.nvterm" },
  { "tpope/vim-surround", event = { "BufRead", "BufNewFile" } },
  {
    "andymass/vim-matchup",
    event = { "BufNewFile", "BufRead" },
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "poopup" }
      if lazy.has("which-key.nvim") then
        require("which-key").register({
          ["]%"] = "Jump to next matchup",
          ["[%"] = "Jump to previous matchup",
          ["g%"] = "Jump to close matchup",
          ["z%"] = "Jump inside matchup",
          mode = "n",
        })
      end
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
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
      map.set("n", "<leader>fj", "<cmd>Telescope projects theme=dropdown<cr>", "Projects")
    end,
  },
  {
    "echasnovski/mini.comment",
    event = { "BufNewFile", "BufRead" },
    opts = {},
    main = "mini.comment",
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
