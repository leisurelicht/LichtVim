-- =================
-- icons.lua
-- Note: 图标
-- =================
--
local M = {}

M.lsp = {
  Action = "💡",
}

M.diagnostics = {
  Error = " ",
  Warn = " ",
  Hint = "",
  Info = " ",
}

M.git = {
  added = " ",
  modified = " ",
  removed = " ",
}

M.kinds = {
  Array = " ",
  Boolean = " ",
  Class = "פּ ",
  Color = " ",
  Constant = " ",
  Constructor = " ",
  Copilot = " ",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = "ﰠ ",
  File = " ",
  Folder = " ",
  Function = " ",
  Interface = " ",
  Key = " ",
  Keyword = " ",
  Method = " ",
  Module = " ",
  Namespace = " ",
  Null = " ",
  Number = " ",
  Object = " ",
  Operator = " ",
  Package = " ",
  Property = " ",
  Reference = " ",
  Snippet = " ",
  String = " ",
  Struct = " ",
  Text = " ",
  TypeParameter = " ",
  Unit = "塞 ",
  Value = " ",
  Variable = " ",
  TabNine = " ",
  Comment = " ",
}

M.sources = {
  nvim_lsp = "󰘐 ",
  path = "󰴠 ",
  buffer = "﬘ ",
  nvim_lua = " ",
  look = "󰍄 ",
  vsnip = " ",
  spell = "󰓆 ",
  cmp_tabnine = "󰐭 ",
  cmdline = " ",
  fuzzy_buffer = "󱁴 ",
  copilot = "",
  luasnip = "󰾁",
  treesitter = " ",
}

return M
