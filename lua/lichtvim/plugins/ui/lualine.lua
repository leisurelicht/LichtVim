local icons_g = require("lichtvim.utils.ui.icons").git
local icons_d = require("lichtvim.utils.ui.icons").diagnostics
local fg = require("lichtvim.utils.ui.colors").fg

local function window_num()
  -- local num = vim.inspect([[%{tabpagewinnr(tabpagenr())}]])
  local num = [[%{winnr()}]]
  return "[" .. num .. "]"
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
          component_separators = { left = "\\", right = "/" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            {
              window_num,
              separator = { right = "" },
              color = { fg = "white", bg = "grey" },
            },
            {
              "mode",
              fmt = function(s)
                return s:sub(1, 1)
              end,
              separator = { right = "" },
            },
          },
          lualine_b = {
            { "branch", separator = { right = "" } },
            {
              "diff",
              symbols = {
                added = icons_g.added,
                modified = icons_g.modified,
                removed = icons_g.removed,
              },
              separator = { right = "" },
            },
          },
          lualine_c = {
            "filename",
          },
          lualine_x = {
            { "encoding" },
            { "filetype" },
            { "fileformat" },
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = fg("Statement"),
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = fg("Special"),
            },
          },
          lualine_y = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic", "nvim_lsp" },
              sections = { "error", "warn", "info", "hint" },
              diagnostics_color = {
                error = "DiagnosticError", -- Changes diagnostics' error color.
                warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
                info = "DiagnosticInfo", -- Changes diagnostics' info color.
                hint = "DiagnosticHint", -- Changes diagnostics' hint color.
              },
              symbols = {
                error = icons_d.Error,
                warn = icons_d.Warn,
                info = icons_d.Info,
                hint = icons_d.Hint,
              },
              colored = true, -- Displays diagnostics status in color if set to true.
              update_in_insert = false, -- Update diagnostics in insert mode.
              always_visible = false, -- Show diagnostics even if there are none.
              separator = { left = "" },
            },
            { "progress", separator = { left = "" } },
          },
        },
        inactive_sections = {
          lualine_a = {
            {
              window_num,
              separator = { right = "" },
              color = { fg = "white", bg = "grey" },
            },
          },
          lualine_c = {
            {
              "filename",
              color = { fg = "grey" },
            },
          },
          lualine_x = {
            {
              "location",
              color = { fg = "grey" },
            },
          },
        },
        extensions = {
          -- "nvim-tree",
          "symbols-outline",
          "fzf",
          "quickfix",
          "lazy",
          "nvim-dap-ui",
          "toggleterm",
          "trouble",
          "man",
          {
            sections = {
              lualine_a = {
                { window_num, separator = { right = "" }, color = { fg = "white", bg = "grey" } },
                {
                  function()
                    return [[File Explorer]]
                  end,
                  separator = { right = "" },
                },
              },
            },
            inactive_sections = {
              lualine_a = {
                { window_num, separator = { right = "" }, color = { fg = "white", bg = "grey" } },
                {
                  function()
                    return [[File Explorer]]
                  end,
                  separator = { right = "" },
                },
              },
            },
            filetypes = { "NvimTree", "neo-tree" },
          },
        },
      }
    end,
  },
}
