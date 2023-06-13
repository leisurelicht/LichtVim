return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore" })
      end
    end,
  },
  {
    "f-person/git-blame.nvim",
    event = { "BufRead", "BufNewFile" },
    init = function()
      vim.g.gitblame_enabled = 0
    end,
    config = function() end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufRead", "BufNewFile" },
    dependencies = { "f-person/git-blame.nvim" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "!" },
        delete = { text = "-" },
        changedelete = { text = "~" },
      },
      on_attach = function()
        vim.api.nvim_command("doautocmd User Gitsigns")
      end,
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
  },
}
