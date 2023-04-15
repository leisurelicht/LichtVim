return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    version = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      {
        -- only needed if you want to use the commands with "_with_window_picker" suffix
        "s1n7ax/nvim-window-picker",
        version = "v1.*",
        config = function()
          require("window-picker").setup({
            autoselect_one = true,
            include_current = false,
            selection_chars = 'ABFJDKSL;CMRUEIWOQP',
            filter_rules = {
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { "neo-tree", "neo-tree-popup", "notify" },

                -- if the buffer type is one of following, the window will be ignored
                buftype = { "terminal", "quickfix" },
              },
            },
            other_win_hl_color = "#e35e4f",
          })
        end,
      },
    },
    keys = { { "<leader>e", "<cmd>NeoTreeRevealToggle<cr>", desc = "Explorer" } },
    opts = function()
      local icons = require("lichtvim.utils.ui.icons").diagnostics

      return {
        default_component_configs = {},
        window = {
          mappings = {
            ["<space>"] = "none",
            ["o"] = "split_with_window_picker",
            ["s"] = "vsplit_with_window_picker",
            ["S"] = "none",
            ["<cr>"] = "open_with_window_picker",
          },
        },
      }
    end,
  },
}
