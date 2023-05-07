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
            selection_chars = "ABFJDKSL;CMRUEIWOQP",
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
    keys = { { "<leader>e", "<cmd>Neotree filesystem focus reveal toggle<cr>", desc = "Explorer" } },
    opts = function()
      return {
        default_component_configs = {},
        window = {
          mappings = {
            ["<space>"] = "none",
            ["e"] = "none",
            ["o"] = "split_with_window_picker",
            ["s"] = "vsplit_with_window_picker",
            ["S"] = "none",
            ["<cr>"] = "open_with_window_picker",
          },
        },
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function()
              -- This effectively hides the cursor
              vim.cmd("highlight! Cursor blend=100")
            end,
          },
          {
            event = "neo_tree_buffer_leave",
            handler = function()
              -- Make this whatever your current Cursor highlight group is.
              vim.cmd("highlight! Cursor guibg=#5f87af blend=0")
            end,
          },
        },
        filesystem = {
          bind_to_cwd = false,
          follow_current_file = true,
          use_libuv_file_watcher = true,
          window = {
            popup = {
              position = { col = "1%", row = "2" },
              size = function(state)
                local root_name = vim.fn.fnamemodify(state.path, ":~")
                local root_len = string.len(root_name) + 4
                return {
                  width = math.max(root_len, 50),
                  height = vim.o.lines - 6,
                }
              end,
            },
          },
        },
        default_component_configs = {
          indent = {
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
        },
      }
    end,
    config = function(_, opts)
      vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },
}
