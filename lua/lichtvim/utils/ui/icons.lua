-- =================
-- icons.lua
-- Note: 图标
-- =================
--
local M = {}

M.lsp = {
  Action = "",
}

M.diagnostics = {
  Hint = " ",
  Info = " ",
  Warn = " ",
  Error = " ",
}

M.git = {
  Git = "󰊢",
  Add = "",
  Branch = "",
  Change = "",
  Conflict = "",
  Delete = "",
  Ignored = "◌",
  Renamed = "➜",
  Staged = "✓",
  Unstaged = "✗",
  Untracked = "★",
}

M.kinds = {
  Array = " ",
  Boolean = " ",
  Class = " ",
  Color = " ",
  Constant = " ",
  Constructor = " ",
  Copilot = " ",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = " ",
  File = " ",
  Folder = " ",
  Function = " ",
  Interface = " ",
  Key = " ",
  Keyword = " ",
  Method = " ",
  Module = " ",
  Namespace = " ",
  Null = " ",
  Number = " ",
  Object = " ",
  Operator = " ",
  Package = " ",
  Property = " ",
  Reference = " ",
  Snippet = " ",
  String = " ",
  Struct = " ",
  Text = "󰊄 ",
  TypeParameter = " ",
  Unit = " ",
  Value = " ",
  Variable = " ",
}

M.sources = {
  nvim_lsp = "󰘐",
  path = "󰴠",
  buffer = "󱁹",
  nvim_lua = "",
  look = "󰍄",
  vsnip = "",
  spell = "󰓆",
  cmp_tabnine = "󰐭",
  cmdline = "",
  fuzzy_buffer = "󱁴",
  copilot = "",
  luasnip = "󰾁",
  treesitter = "󰔱",
}

return M
