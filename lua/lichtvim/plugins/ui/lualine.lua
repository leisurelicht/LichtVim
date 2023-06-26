local win_num = require("lichtvim.utils").win.num

local function title(t)
  return string.format("[[%s]]", t)
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    opts = function()
      local ic = require("lichtvim.config").icons
      local i_git = ic.git
      local i_diag = ic.diagnostics
      return {
        options = {
          theme = "auto",
          disabled_filetypes = { statusline = { "alpha" }, winbar = { "alpha", "neo-tree" } },
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
          refresh = {
            statusline = 100,
          },
        },
        tabline = {},
        winbar = {
          lualine_a = { { win_num } },
          lualine_c = {
            {
              "filename",
              path = 1,
              newfile_status = false,
              symbols = { modified = "[Modified]", readonly = "[Read Only]", unnamed = "[No Name]", newfile = "[New]" },
            },
          },
        },
        inactive_winbar = {
          lualine_a = { { win_num, separator = { right = "" }, color = { fg = "white", bg = "grey" } } },
          lualine_c = {
            {
              "filename",
              path = 4,
              newfile_status = false,
              symbols = { modified = "[Modified]", readonly = "[Read Only]", unnamed = "[No Name]", newfile = "[New]" },
            },
          },
        },
        sections = {
          lualine_a = { { "mode" } },
          lualine_b = {
            { "branch" },
            { "diff", symbols = { added = i_git.Add, modified = i_git.Change, removed = i_git.Delete } },
          },
          lualine_c = {
            {
              function()
                return require("nvim-navic").get_location()
              end,
              cond = function()
                return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
              end,
            },
          },
          lualine_x = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              sections = { "error", "warn", "info", "hint" },
              symbols = { error = i_diag.Error, warn = i_diag.Warn, info = i_diag.Info, hint = i_diag.Hint },
              colored = true, -- Displays diagnostics status in color if set to true.
              update_in_insert = false, -- Update diagnostics in insert mode.
              always_visible = true, -- Show diagnostics even if there are none.
            },
            { "encoding" },
            { "filetype" },
            { "fileformat" },
          },
          lualine_y = {
            { require("lazy.status").updates, cond = require("lazy.status").has_updates },
          },
          lualine_z = {
            { "location" },
            { "progress" },
          },
        },
        extensions = {
          {
            filetypes = { "lazy", "mason", "TelescopePrompt", "toggleterm", "Trouble", "qf" },
            sections = {
              lualine_a = { { title("     "), separator = { right = "" } } },
              lualine_z = { { title("     "), separator = { left = "" } } },
            },
          },
        },
      }
    end,
  },
}
