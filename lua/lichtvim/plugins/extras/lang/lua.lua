return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "lua" })
      end
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
        null_ls.builtins.formatting.stylua.with({
          "--indent-type=Spaces",
          "--indent-width=2",
        }),
        null_ls.builtins.completion.luasnip,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = {
        lua_ls = {
          settings = {
            document_diagnostics = false,
            document_formatting = false,
            formatting_on_save = true,
          },
          options = {
            -- cmd = { "lua-language-server", "--locale=zh-CN" },
            cmd = { "lua-language-server" },
            filetypes = { "lua" },
            log_level = 2,
            settings = {
              Lua = {
                runtime = {
                  version = "LuaJIT",
                },
                diagnostics = {
                  globals = { "vim" },
                },
                workspace = {
                  -- library = vim.api.nvim_get_runtime_file("", true),
                  library = "checkThirdParty",
                },
                telemetry = {
                  enable = false,
                },
                completion = {
                  callSnippet = "Replace",
                },
                format = {
                  enable = true,
                  -- Put format options here
                  -- NOTE: the value should be STRING!!
                  defaultConfig = {
                    indent_style = "space",
                    indent_size = "2",
                  },
                },
              },
            },
          },
        },
      }
    end,
  },
}
