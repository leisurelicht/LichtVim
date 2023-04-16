return {
  { import = "lichtvim.plugins.coding.indent" },
  { import = "lichtvim.plugins.coding.autopairs" },
  { import = "lichtvim.plugins.coding.git" },
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
}
