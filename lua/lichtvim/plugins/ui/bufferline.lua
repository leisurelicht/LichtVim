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
            local dig = icons.diagnostics
            local s = " "
            for e, n in pairs(diagnostics_dict) do
              local sym = e == "error" and dig.Error or (e == "warning" and dig.Warn or (e == "info" and dig.Info or dig.Hint))
              s = s .. sym .. n .. " "
            end
            return vim.trim(s)
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
