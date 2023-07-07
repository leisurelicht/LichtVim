return {
  {
    "tiagovla/scope.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = { restore_state = false },
    config = function(_, opts)
      require("scope").setup(opts)
      -- require("telescope").load_extension("scope")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    opts = function()
      local icons = require("lichtvim.config").icons
      return {
        options = {
          numbers = "ordinal",
          separator_style = "thin",
          always_show_bufferline = false,
          hover = {
            enabled = true,
            delay = 200,
            reveal = { "close" },
          },
          indicator = { style = "underline" },
          close_command = function(n)
            require("mini.bufremove").delete(n, false)
          end,
          right_mouse_command = function(n)
            require("mini.bufremove").delete(n, false)
          end,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            return count > 0 and icons.diagnostics.Logo or nil
          end,
          offsets = {
            {
              filetype = "neo-tree",
              text = icons.file.FolderClosed .. " File Explorer",
              text_align = "center",
              separator = true,
            },
          },
        },
      }
    end,
  },
}
