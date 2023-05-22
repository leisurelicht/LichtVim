return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "lua" })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "luacheck",
        "stylua",
      })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      vim.list_extend(opts.sources, {
        null_ls.builtins.diagnostics.luacheck.with({
          extra_args = { "--globals=vim" },
        }),
        null_ls.builtins.formatting.stylua,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    ft = "lua",
    opts = {
      servers = {
        lua_ls = {
          disable_diagnostics = true,
          cmd = { "lua-language-server" },
          -- cmd = { "lua-language-server", "--locale=zh-CN" },
          filetypes = { "lua" },
          log_level = 2,
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              workspace = {
                library = "checkThirdParty",
              },
              completion = { callSnippet = "Replace" },
              diagnostics = { enable = false },
              telemetry = { enable = false },
              format = { enable = false },
            },
          },
        },
      },
    },
  },
}
