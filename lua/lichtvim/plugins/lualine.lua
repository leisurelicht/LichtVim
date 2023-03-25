local icons_g = require("lichtvim.utils.ui.icons").git
local icons_d = require("lichtvim.utils.ui.icons").diagnostics

local function window_num()
  -- local num = vim.inspect([[%{tabpagewinnr(tabpagenr())}]])
  local num = [[%{winnr()}]]
  return "[" .. num .. "]"
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {"gitsigns.nvim"},
  config = function()

    local function fg(name)
      return function()
        ---@type {foreground?:number}?
        local hl = vim.api.nvim_get_hl_by_name(name, true)
        return hl and hl.foreground and
                   {fg = string.format("#%06x", hl.foreground)}
      end
    end

    require("lualine").setup({
      options = {theme = "nightfox"},
      sections = {
        lualine_a = {
          -- {"tabs", separator = {right = ""}},
          {
            window_num,
            separator = {right = ""},
            color = {fg = "white", bg = "grey"}
          },
          {
            "mode",
            fmt = function(str) return str:sub(1, 1) end,
            separator = {right = ""}
          },
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function()
              return package.loaded["noice"] and
                         require("noice").api.status.mode.has()
            end,
            separator = {right = ""}
          }

        },
        lualine_c = {{vim.fn.getcwd()}, "filename"},
        lualine_x = {
          {"encoding"},
          {"fileformat"},
          {"filetype"},
          {
            function()
              return require("noice").api.status.command.get()
            end,
            cond = function()
              return package.loaded["noice"] and
                         require("noice").api.status.command.has()
            end,
            color = fg("Statement")
          },
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = fg("Special")
          }
        },
        lualine_y = {
          {
            "diff",
            symbols = {
              added = icons_g.added,
              modified = icons_g.modified,
              removed = icons_g.removed
            },
            separator = {left = ""},
            color = {fg = "white", bg = "black"}
          },
          {
            "diagnostics",
            -- Table of diagnostic sources, available sources are:
            --   'nvim_lsp', 'nvim_diagnostic', 'coc', 'ale', 'vim_lsp'.
            -- or a function that returns a table as such:
            --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
            sources = {"nvim_diagnostic", "nvim_lsp"},
            -- Displays diagnostics for the defined severity types
            sections = {"error", "warn", "info", "hint"},
            diagnostics_color = {
              -- Same values as the general color option can be used here.
              error = "DiagnosticError", -- Changes diagnostics' error color.
              warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
              info = "DiagnosticInfo", -- Changes diagnostics' info color.
              hint = "DiagnosticHint" -- Changes diagnostics' hint color.
            },
            symbols = {
              error = icons_d.Error,
              warn = icons_d.Warn,
              info = icons_d.Info,
              hint = icons_d.Hint
            },
            colored = true, -- Displays diagnostics status in color if set to true.
            update_in_insert = false, -- Update diagnostics in insert mode.
            always_visible = false, -- Show diagnostics even if there are none.
            separator = {left = ""}
          },
          {"progress", separator = {left = ""}}
        }
      },
      inactive_sections = {
        lualine_a = {
          -- {"tabs", separator = {right = ""}},
          {
            window_num,
            separator = {right = ""},
            color = {fg = "white", bg = "grey"}
          }
        }
      },
      extensions = {"nvim-tree", "symbols-outline", "fzf"}
    })
  end
}
