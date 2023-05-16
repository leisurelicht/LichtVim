-- =================
-- global.lua
-- Note:
-- =================
--
_G.LichtVimTitle = "LichtVim"

_G.lazy = require("lichtvim.utils.lazy")
_G.map = require("lichtvim.utils.mapping")
_G.api = require("lichtvim.utils.api")

-- 展开打印各种数据
function _G.Dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end
