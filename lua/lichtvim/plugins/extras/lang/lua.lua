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
    "nvim-lspconfig",
    opts = function(_, opts)
      table.insert(opts.servers, 1, { "lua_ls" })
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
