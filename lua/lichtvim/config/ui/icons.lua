-- =================
-- icons.lua
-- Note: 图标
-- =================
--
local M = {}

M.Other = {
  DefaultFile = "󰈙 ",
  FileModified = " ",
  FileReadOnly = " ",
  FoldClosed = " ",
  FoldOpened = " ",
  FoldSeparator = " ",
  FolderClosed = " ",
  FolderEmpty = " ",
  FolderOpen = " ",

  Codeaction = "",
}

M.Diagnostics = {
  Logo = "󰒡 ",
  Hint = " ",
  Info = " ",
  Warn = " ",
  Error = " ",
}

M.Git = {
  Logo = "󰊢 ",
  Branch = "󰘬 ",
  Add = " ",
  Change = " ",
  Delete = " ",
  Staged = " ",
  Unstaged = " ",
  Conflict = " ",
  Ignored = " ",
  Renamed = "➜ ",
  Untracked = " ",
}

M.Kinds = {
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
  Function = "󰊕 ",
  Interface = " ",
  Key = " ",
  Keyword = " ",
  Method = " ",
  Module = "󰕳 ",
  Namespace = " ",
  Null = "󰟢 ",
  Number = " ",
  Object = " ",
  Operator = " ",
  Package = "󱧕 ",
  Property = " ",
  Reference = " ",
  Snippet = " ",
  String = "󰅳 ",
  Struct = " ",
  Text = "󰊄 ",
  TypeParameter = " ",
  Unit = " ",
  Value = " ",
  Variable = "󰫧 ",
}

M.Sources = {
  nvim_lsp = "󰘐",
  nvim_lua = "",
  path = "󰴠",
  buffer = "󱁹",
  look = "󰍄",
  spell = "󰓆",
  cmdline = "",
  fuzzy_buffer = "󱁴",
  copilot = "",
  cmp_tabnine = "󰐭",
  luasnip = "",
  vsnip = "",
  treesitter = "󰔱",
}

return M
