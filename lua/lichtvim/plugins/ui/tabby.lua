local str = require("lichtvim.utils").str

local name_map = {
  alpha = "Alpha",
  checkhealth = "CheckHealth",
  NvimTree = "File Explorer",
  ["neo-tree"] = "File Explorer",
  toggleterm = "Terminal",
}

return {
  {
    "nanozuki/tabby.nvim",
    config = function()
      local t_name = require("tabby.feature.tab_name")
      local t_api = require("tabby.module.api")
      require("tabby.tabline").set(function(line)
        return {
          { { "  ", hl = "LichtTLHead" }, line.sep("", "LichtTLHead", "LichtTLLineSep") },
          line.tabs().foreach(function(tab)
            if t_api.is_float_win(0) then
              return
            end

            local buf = tab.current_win().buf().id
            local ft = vim.api.nvim_buf_get_option(buf, "filetype")
            local tab_name = name_map[ft] or tab.name()

            local hl = tab.is_current() and "LichtTLActiveTab" or "LichtTLUnActive"
            return {
              line.sep(" ", hl, "LichtTLLineSep"),
              tab.is_current() and "" or "",
              tab.number(),
              tab_name,
              tab.is_current() and tab.close_btn("") or "",
              line.sep("", hl, "LichtTLLineSep"),
              hl = hl,
              margin = " ",
            }
          end),
          line.spacer(),
          line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            if t_api.is_float_win(0) then
              return
            end

            local buf = win.buf().id
            local ft = vim.api.nvim_buf_get_option(buf, "filetype")
            local win_name = name_map[ft] or win.buf_name()

            local hl = win.is_current() and "LichtTLActiveWin" or "LichtTLUnActive"
            return {
              line.sep(" ", hl, "LichtTLLineSep"),
              win.is_current() and "" or "",
              win_name,
              line.sep("", hl, "LichtTLLineSep"),
              hl = hl,
              margin = " ",
            }
          end),
          { line.sep(" ", "LichtTLTail", "LichtTLLineSep"), { " ", hl = "LichtTLTail" } },
          hl = "LichtTLLineSep",
        }
      end)
    end,
  },
}
