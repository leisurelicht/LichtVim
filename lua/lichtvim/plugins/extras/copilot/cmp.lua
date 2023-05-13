return {
  {
    "zbirenbaum/copilot.lua",
    build = ":Copilot auth",
    cmd = "Copilot",
    event = "LspAttach",
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
    },
    config = function(_, opts)
      require("copilot").setup(opts)
    end,
  },
  {
    "nvim-cmp",
    dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        dependencies = "copilot.lua",
        opts = {},
        config = function(_, opts)
          local copilot_cmp = require("copilot_cmp")
          copilot_cmp.setup(opts)
          -- attach cmp source whenever copilot attaches
          -- fixes lazy-loading issues with the copilot cmp source
          require("lichtvim.utils.lazy").on_attach(function(client)
            if client.name == "copilot" then
              copilot_cmp._on_insert_enter({})
            end
          end)
        end,
      },
    },
    -- @param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")

      table.insert(opts.sources, 1, { name = "copilot", group_index = 2 })

      local confirm = opts.mapping["<cr>"]
      local confirm_copilot = cmp.mapping.confirm({
        select = true,
        behavior = cmp.ConfirmBehavior.Replace,
      })

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<CR>"] = function(...)
          local entry = cmp.get_selected_entry()
          if entry and entry.source.name == "copilot" then
            return confirm_copilot(...)
          end
          return confirm(...)
        end,
      })
      table.insert(opts.sorting.comparators, #opts.sorting.comparators, require("copilot_cmp.comparators"))
    end,
  },
}
