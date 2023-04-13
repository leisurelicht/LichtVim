return {
  { "vim-scripts/indentpython.vim", enabled = false, ft = { "python", "djangohtml" } },
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
          ["]i"] = "Goto indent scope bottom",
          ["[i"] = "Goto indent scope top",
          mode = "n",
        })
      end
    end,
  },
}
