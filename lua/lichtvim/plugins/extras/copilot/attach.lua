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
    event = "InsertEnter",
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
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
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
      for k, v in pairs(opts.mapping["<S-Tab>"]) do
        opts.mapping["<S-Tab>"][k] = function(...)
          if suggestion.is_visible() then
            suggestion.dismiss()
          else
            v(...)
          end
        end
      end

      local cmp = require("cmp")
      cmp.event:on("menu_opened", function()
        vim.b.copilot_suggestion_hidden = true
      end)

      cmp.event:on("menu_closed", function()
        vim.b.copilot_suggestion_hidden = false
      end)
    end,
  },
}
