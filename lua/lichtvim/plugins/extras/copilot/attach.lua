-- Copilot
--
-- Copilot is a language server that uses machine learning to provide
-- intelligent code completions. It is designed to be lightweight and
-- fast, and it works with any language that has a language server.
--
return {
  {
    "zbirenbaum/copilot.lua",
    -- build = ":Copilot auth",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
        layout = { position = "bottom", ratio = 0.4 },
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
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        -- yaml = false,
        -- markdown = false,
        -- ["."] = false,
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)
    end,
  },
  {
    "nvim-cmp",
    optional = true,
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

      -- hide suggestion window when cmp menu is open
      local cmp = require("cmp")
      cmp.event:on("menu_opened", function()
        suggestion.dismiss()
        vim.b.copilot_suggestion_hidden = true
      end)

      cmp.event:on("menu_closed", function()
        vim.b.copilot_suggestion_hidden = false
      end)

      cmp.event:on("confirm_done", function()
        vim.b.copilot_suggestion_hidden = false
      end)

      cmp.event:on("complete_done", function()
        vim.b.copilot_suggestion_hidden = false
      end)
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    dependencies = {
      "leisurelicht/lualine-copilot.nvim",
    },
    opts = function(_, opts)
      table.insert(opts.sections.lualine_y, 1, { "copilot" })
    end,
  },
}
