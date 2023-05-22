local icons = require("lichtvim.config").icons
local fg = require("lichtvim.config.ui.colors").fg

local function window_num()
  -- local num = vim.inspect([[%{tabpagewinnr(tabpagenr())}]])
  local num = [[%{winnr()}]]
  return "[" .. num .. "]"
end

local function title(title)
  return string.format("[[%s]]", title)
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    dependencies = { "gitsigns.nvim" },
    opts = function()
      return {
        options = {
          theme = "auto",
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { { "mode", separator = { right = "" } } },
          lualine_b = {
            { "branch" },
            {
              "diff",
              symbols = { added = icons.git.Add, modified = icons.git.Change, removed = icons.git.Delete },
            },
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
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
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
        extensions = {
          -- "quickfix",
          -- "nvim-dap-ui",
          -- "man",
          {
            filetypes = { "toggleterm" },
            sections = {
              lualine_a = { { title("Terminal"), separator = { right = "" } } },
              lualine_z = { { title("Terminal"), separator = { left = "" } } },
            },
          },
          {
            filetypes = { "Trouble" },
            sections = {
              lualine_a = { { title("Trouble"), separator = { right = "" } } },
              lualine_z = { { title("Trouble"), separator = { left = "" } } },
            },
          },
          {
            filetypes = { "TelescopePrompt" },
            sections = {
              lualine_a = { { title("Telescope"), separator = { right = "" } } },
              lualine_z = { { title("Telescope"), separator = { left = "" } } },
            },
          },
          {
            filetypes = { "lazy" },
            sections = {
              lualine_a = { { title("Lazy"), separator = { right = "" } } },
              lualine_z = { { title("Lazy"), separator = { left = "" } } },
            },
          },
        },
      }
    end,
  },
}
