local ic = require("lichtvim.config").icons
local win_num = require("lichtvim.utils").win.num

local function title(t)
  return string.format("[[%s]]", t)
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    opts = function()
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
            { "diff", symbols = { added = ic.git.Add, modified = ic.git.Change, removed = ic.git.Delete } },
          },
          lualine_c = {},
          lualine_x = { { "filetype" }, { "fileformat" }, { "encoding" } },
          lualine_y = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              sections = { "error", "warn", "info", "hint" },
              symbols = {
                error = ic.diagnostics.Error,
                warn = ic.diagnostics.Warn,
                info = ic.diagnostics.Info,
                hint = ic.diagnostics.Hint,
              },
              colored = true, -- Displays diagnostics status in color if set to true.
              update_in_insert = false, -- Update diagnostics in insert mode.
              always_visible = false, -- Show diagnostics even if there are none.
            },
            { require("lazy.status").updates, cond = require("lazy.status").has_updates },
          },
          lualine_z = { { "location" }, { "progress" } },
        },
        extensions = {
          -- {
          --   filetypes = { "neo-tree" },
          --   sections = {
          --     lualine_a = { { "mode" } },
          --     lualine_b = {
          --       { "branch" },
          --       { "diff", symbols = { added = ic.git.Add, modified = ic.git.Change, removed = ic.git.Delete } },
          --     },
          --   },
          -- },
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
            filetypes = { "lazy", "TelescopePrompt", "mason" },
            sections = {
              lualine_a = { { title("   "), separator = { right = "" } } },
              lualine_z = { { title("   "), separator = { left = "" } } },
            },
          },
        },
      }
    end,
  },
}
