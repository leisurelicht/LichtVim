return {
  {
    "zbirenbaum/copilot.lua",
    build = ":Copilot auth",
    cmd = "Copilot",
    event = "LspAttach",
    opts = {
      panel = { enabled = false },
      suggestion = { enabled = false },
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
      table.insert(opts.sources, 1, { name = "copilot", group_index = 2 })
      table.insert(opts.sorting.comparators, 1, require("copilot_cmp.comparators"))
    end,
  },
    {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "leisurelicht/lualine-copilot.nvim",
    },
    opts = function(_, opts)
      table.insert(opts.sections.lualine_y, 1, { "copilot" })
    end,
  },

}
