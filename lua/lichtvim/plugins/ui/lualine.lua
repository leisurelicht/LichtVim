local icons_g = require("lichtvim.utils.ui.icons").git
local icons_d = require("lichtvim.utils.ui.icons").diagnostics
local fg = require("lichtvim.utils.ui.colors").fg

local function window_num()
  -- local num = vim.inspect([[%{tabpagewinnr(tabpagenr())}]])
  local num = [[%{winnr()}]]
  return "[" .. num .. "]"
end

local function file_explorer()
  return [[File Explorer]]
end

local function toggleterm()
  return [[Terminal]]
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "gitsigns.nvim" },
    opts = function()
      return {
        options = {
          theme = "auto",
          disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { { "mode", fmt = window_num, separator = { right = "" } } },
          lualine_b = {
            { "branch" },
            { "diff", symbols = { added = icons_g.Add, modified = icons_g.Change, removed = icons_g.Delete } },
          },
          lualine_c = {},
          lualine_x = {
            { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              sections = { "error", "warn", "info", "hint" },
              diagnostics_color = {
                error = "DiagnosticError", -- Changes diagnostics' error color.
                warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
                info = "DiagnosticInfo", -- Changes diagnostics' info color.
                hint = "DiagnosticHint", -- Changes diagnostics' hint color.
              },
              symbols = { error = icons_d.Error, warn = icons_d.Warn, info = icons_d.Info, hint = icons_d.Hint },
              colored = true, -- Displays diagnostics status in color if set to true.
              update_in_insert = false, -- Update diagnostics in insert mode.
              always_visible = false, -- Show diagnostics even if there are none.
            },
            { "filetype" },
            { "fileformat" },
            { "encoding" },
          },
          lualine_y = { { "location" } },
          lualine_z = { { "progress" } },
        },
        inactive_sections = {
          lualine_a = { { window_num, separator = { right = "" }, color = { fg = "white", bg = "grey" } } },
          lualine_c = {},
          lualine_x = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              sections = { "error", "warn", "info", "hint" },
              diagnostics_color = {
                error = "DiagnosticError", -- Changes diagnostics' error color.
                warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
                info = "DiagnosticInfo", -- Changes diagnostics' info color.
                hint = "DiagnosticHint", -- Changes diagnostics' hint color.
              },
              symbols = { error = icons_d.Error, warn = icons_d.Warn, info = icons_d.Info, hint = icons_d.Hint },
              colored = true, -- Displays diagnostics status in color if set to true.
              update_in_insert = false, -- Update diagnostics in insert mode.
              always_visible = false, -- Show diagnostics even if there are none.
            },
            { "filetype" },
            { "fileformat" },
            { "encoding" },
          },
          lualine_y = { { "location" } },
          lualine_z = {},
        },
        extensions = {
          "quickfix",
          "lazy",
          "nvim-dap-ui",
          "trouble",
          "man",
          {
            filetypes = { "NvimTree", "neo-tree" },
            sections = {
              lualine_a = {
                { window_num, separator = { right = "" }, color = { fg = "white", bg = "grey" } },
                { file_explorer, separator = { right = "" } },
              },
            },
            inactive_sections = {
              lualine_a = {
                { window_num, separator = { right = "" }, color = { fg = "white", bg = "grey" } },
                { file_explorer, separator = { right = "" } },
              },
            },
          },
          {
            filetypes = { "toggleterm" },
            sections = {
              lualine_a = {
                { window_num, separator = { right = "" }, color = { fg = "white", bg = "grey" } },
                { toggleterm, separator = { right = "" } },
              },
            },
            inactive_sections = {
              lualine_a = {
                { window_num, separator = { right = "" }, color = { fg = "white", bg = "grey" } },
                { toggleterm, separator = { right = "" } },
              },
            },
          },
        },
      }
    end,
  },
}
