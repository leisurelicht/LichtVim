return {
  { "tiagovla/scope.nvim", config = true },
  {
    "akinsho/bufferline.nvim",
    event = "VimEnter",
    opts = function()
      local icons = require("lichtvim.config").icons
      return {
        options = {
          numbers = "ordinal",
          separator_style = "slope",
          always_show_bufferline = false,
          hover = {
            enabled = true,
            delay = 200,
            reveal = { "close" },
          },
          indicator = {
            style = "underline",
          },
          close_command = function(n)
            require("mini.bufremove").delete(n, false)
          end,
          right_mouse_command = function(n)
            require("mini.bufremove").delete(n, false)
          end,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            if count > 0 then
              return icons.diagnostics.Logo
            else
              return
            end
          end,
          offsets = {
            {
              filetype = "NvimTree",
              text = icons.file.FolderClosed .. "  File Explorer",
              text_align = "center",
            },
            {
              filetype = "neo-tree",
              text = icons.file.FolderClosed .. "  File Explorer",
              text_align = "center",
              separator = true,
            },
          },
        },
      }
    end,
  },
}
