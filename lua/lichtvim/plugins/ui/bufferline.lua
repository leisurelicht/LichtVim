return {
  "akinsho/bufferline.nvim",
  event = "VimEnter",
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
  },
  opts = function()
    -- vim.opt.mousemoveevent = true
    return {
      options = {
        numbers = "ordinal",
        separator_style = "slant",
        indicator = {
          style = "underline",
        },
        -- hover = {
        --   enabled = true,
        --   delay = 200,
        --   reveal = { "close" },
        -- },
        -- stylua: ignore
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        -- stylua: ignore
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local dig = require("lichtvim.config").icons.diagnostics
          local s = " "
          for e, n in pairs(diagnostics_dict) do
            local sym = e == "error" and dig.Error
              or (e == "warning" and dig.Warn or (e == "info" and dig.Info or dig.Hint))
            s = s .. sym .. n
          end
          return s
        end,
        offsets = {
          {
            filetype = "NvimTree",
            -- text = "󰄽󰄾 󰞇 File Explorer",
            text = "󰄽󰄾 󰚀 File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    }
  end,
}
