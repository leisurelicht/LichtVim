local str = require("lichtvim.utils").str

return {
  {
    "nanozuki/tabby.nvim",
    event = "VeryLazy",
    config = function()
      local theme = {
        fill = "TabLineFill",
        head = "TabLine",
        current_tab = "TabLineSel",
        tab = "TabLine",
        win = "TabLine",
        tail = "TabLine",
      }
      require("tabby.tabline").set(function(line)
        return {
          { { "  ", hl = theme.head }, line.sep("", theme.head, theme.fill) },
          line.tabs().foreach(function(tab)
            local tab_name = tab.name()
            if
              str.starts_with(vim.fn.tolower(tab_name), "nvimtree")
              or str.starts_with(vim.fn.tolower(tab_name), "neo-tree")
            then
              tab_name = "File Explorer"
            end
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
              line.sep("", hl, theme.fill),
              tab.is_current() and "" or "",
              tab.number(),
              tab_name,
              tab.is_current() and tab.close_btn("") or "",
              line.sep("", hl, theme.fill),
              hl = hl,
              margin = " ",
            }
          end),
          line.spacer(),
          line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            local win_name = win.buf_name()
            if
              str.starts_with(vim.fn.toupper(win_name), "nvimtree")
              or str.starts_with(vim.fn.tolower(tab_name), "neo-tree")
            then
              win_name = "File Explorer"
            end
            return {
              line.sep("", theme.win, theme.fill),
              win.is_current() and "" or "",
              win_name,
              line.sep("", theme.win, theme.fill),
              hl = theme.win,
              margin = " ",
            }
          end),
          { line.sep("", theme.tail, theme.fill), { "  ", hl = theme.tail } },
          hl = theme.fill,
        }
      end)
    end,
  },
}
