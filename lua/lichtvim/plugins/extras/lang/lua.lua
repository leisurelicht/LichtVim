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
        "stylua",
      })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      vim.list_extend(opts.sources, {
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
          disable_diagnostics = false,
          -- cmd = { "lua-language-server" },
          cmd = { "lua-language-server", "--locale=zh-CN" },
          filetypes = { "lua" },
          root_dir = function(fname)
            local util = require("lspconfig.util")

            local root_files = {
              ".luarc.json",
              ".luarc.jsonc",
              ".luacheckrc",
              ".stylua.toml",
              "stylua.toml",
              "selene.toml",
              "selene.yml",
            }

            local root = util.root_pattern(unpack(root_files))(fname)
            if root and root ~= vim.env.HOME then
              return root
            end
            root = util.root_pattern("lua/")(fname)
            if root then
              return root .. "/lua/"
            end
            return util.find_git_ancestor(fname)
          end,
          single_file_support = true,
          log_level = vim.lsp.protocol.MessageType.Warning,
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
              },
              completion = { callSnippet = "Replace" },
              diagnostics = {
                enable = true,
                globals = { "vim" },
              },
              telemetry = { enable = false },
              format = { enable = false },
            },
          },
        },
      },
    },
  },
}
