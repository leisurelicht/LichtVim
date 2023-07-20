return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "ninja", "python", "rst", "toml", "htmldjango" })
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
