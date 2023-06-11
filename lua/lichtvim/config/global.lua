-- =================
-- global.lua
-- Note:
-- =================
--
_G.LichtVimTitle = "LichtVim"
_G.add_title = function(body)
  if body == nil then
    return LichtVimTitle
  end
  return string.format("%s%s", LichtVimTitle, body)
end

_G.lazy = require("lichtvim.utils.lazy")
_G.map = require("lichtvim.utils.mapping")

-- 展开打印各种数据
function _G.Dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end
