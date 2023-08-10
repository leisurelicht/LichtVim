return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "ninja", "python", "rst", "toml", "htmldjango" })
    end,
  },
  {
    -- "numiras/semshi",
    "wookayin/semshi", -- use a maintained fork
    ft = "python",
    build = ":UpdateRemotePlugins",
    init = function()
      -- Disabled these features better provided by LSP or other more general plugins
      vim.g["semshi#error_sign"] = false
      vim.g["semshi#simplify_markup"] = false
      vim.g["semshi#mark_selected_nodes"] = false
      vim.g["semshi#update_delay_factor"] = 0.001

      -- This autocmd must be defined in init to take effect
      vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
        group = vim.api.nvim_create_augroup("SemanticHighlight", {}),
        callback = function()
          -- Only add style, inherit or link to the LSP's colors
          vim.cmd([[
            highlight! semshiGlobal gui=italic
            highlight! semshiImported gui=bold
            highlight! link semshiParameter @lsp.type.parameter
            highlight! link semshiParameterUnused DiagnosticUnnecessary
            highlight! link semshiBuiltin @function.builtin
            highlight! link semshiAttribute @attribute
            highlight! link semshiSelf @lsp.type.selfKeyword
            highlight! link semshiUnresolved @lsp.type.unresolvedReference
            ]])
        end,
      })
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    ft = "python",
    keys = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup(require("lichtvim.utils").title.add("Keymap"), { clear = false }),
        pattern = { "*" },
        callback = function(event)
          if vim.fn.index({ "python", "htmldjango" }, vim.bo[event.buf].filetype) == -1 then
            return
          end

          local opt = { buffer = event.buf, silent = true }
          map.set("n", "<leader>cv", "<cmd>:VenvSelect<cr>", "Select VirtualEnv", opt)
        end,
      })
    end,
    opts = {},
    config = true,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        pyright = {},
        ruff_lsp = {},
      },
    },
    setup = {
      ruff_lsp = function()
        require("lazyvim.util").on_attach(function(client, _)
          if client.name == "ruff_lsp" then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end
        end)
      end,
    },
  },
}
