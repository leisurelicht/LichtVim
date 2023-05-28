-- Copilot
--
-- Copilot is a language server that uses machine learning to provide
-- intelligent code completions. It is designed to be lightweight and
-- fast, and it works with any language that has a language server.
--
return {
  {
    "zbirenbaum/copilot.lua",
    build = ":Copilot auth",
    cmd = "Copilot",
    event = { "BufNewFile", "BufRead" },
    opts = {
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
        layout = {
          position = "bottom", -- | top | left | right
          ratio = 0.2,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<M-CR>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-e>",
        },
      },
      filetypes = {
        -- yaml = false,
        -- markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        -- ["."] = false,
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)
    end,
  },
  {
    "nvim-cmp",
    opts = function(_, opts)
      local suggestion = require("copilot.suggestion")
      for k, v in pairs(opts.mapping["<Tab>"]) do
        opts.mapping["<Tab>"][k] = function(...)
          if suggestion.is_visible() then
            suggestion.accept()
          else
            v(...)
          end
        end
      end
    end,
  },
}
