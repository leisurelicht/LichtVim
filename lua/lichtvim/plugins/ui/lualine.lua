local icons = require("lichtvim.config").icons
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
          lualine_a = {
            { win_num },
          },
          lualine_c = {
            {
              "filename",
              newfile_status = false,
              path = 1,
              symbols = {
                modified = "[Modified]", -- Text to show when the file is modified.
                readonly = "[Read Only]", -- Text to show when the file is non-modifiable or readonly.
                unnamed = "[No Name]", -- Text to show for unnamed buffers.
                newfile = "[New]", -- Text to show for newly created file before first write
              },
            },
          },
        },
        inactive_winbar = {
          lualine_a = {
            { win_num, separator = { right = "" }, color = { fg = "white", bg = "grey" } },
          },
          lualine_c = {
            {
              "filename",
              newfile_status = false,
              path = 4,
              symbols = {
                modified = "[Modified]", -- Text to show when the file is modified.
                readonly = "[Read Only]", -- Text to show when the file is non-modifiable or readonly.
                unnamed = "[No Name]", -- Text to show for unnamed buffers.
                newfile = "[New]", -- Text to show for newly created file before first write
              },
            },
          },
        },
        sections = {
          lualine_a = { { "mode" } },
          lualine_b = {
            { "branch" },
            {
              "diff",
              symbols = { added = icons.git.Add, modified = icons.git.Change, removed = icons.git.Delete },
            },
          },
          lualine_c = {},
          lualine_x = {
            { "filetype" },
            { "fileformat" },
            { "encoding" },
          },
          lualine_y = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              sections = { "error", "warn", "info", "hint" },
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
            { require("lazy.status").updates, cond = require("lazy.status").has_updates },
            -- { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
          },
          lualine_z = {
            { "location" },
            { "progress" },
          },
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
