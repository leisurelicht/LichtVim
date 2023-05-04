return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "go", "gomod", "gowork", "gosum" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            document_diagnostics = true,
            document_formatting = true,
            formatting_on_save = false,
          },
          options = {
            cmd = { "gopls" },
            settings = {
              gopls = {
                experimentalPostfixCompletions = true,
                analyses = {
                  unusedparams = true,
                  shadow = true,
                },
                staticcheck = true,
              },
            },
            init_options = {
              usePlaceholders = true,
            },
          },
        },
      },
    },
  },
}
