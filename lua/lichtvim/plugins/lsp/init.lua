return {
  { import = "lichtvim.plugins.lsp.lsp-config" },
  { import = "lichtvim.plugins.lsp.cmp" },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "LspAttach",
    keys = {
      { "<leader>pn", "<cmd>NullLsInfo<cr>", desc = "Null-ls info" },
    },
    opts = function()
      local null_ls = require("null-ls")
      return {
        debug = false,
        sources = {
          null_ls.builtins.completion.spell,
        },
      }
    end,
    config = true,
  },
  {
    "williamboman/mason.nvim",
    enabled = true,
    cmd = "Mason",
    build = ":MasonUpdate",
    keys = {
      { "<leader>pm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      ensure_installed = {},
    },
    config = function(_, opts)
      require("mason").setup(opts)

      local mr = require("mason-registry")

      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end

      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true
      require("lichtvim.utils.lazy").on_attach(function(client, buffer)
        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = function()
      return {
        highlight = true,
        separator = "  ",
        icons = require("lichtvim.config").icons.kinds,
        click = true,
      }
    end,
  },
  {
    "kosayoda/nvim-lightbulb",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      sign = { enabled = false },
      float = {
        enabled = true,
        win_opts = {
          border = "none",
        },
      },
      autocmd = { enabled = true, events = { "CursorHold" } },
    },
  },
}
