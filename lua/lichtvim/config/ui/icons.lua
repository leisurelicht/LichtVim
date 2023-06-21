-- =================
-- icons.lua
-- Note: 图标
-- =================
--
local M = {}

M.Other = {
  Codeaction = "",
}

M.File = {
  DefaultFile = "󰈙",
  FileModified = "",
  FileReadOnly = "",
  FoldClosed = "",
  FoldOpened = "",
  FoldSeparator = " ",
  FolderClosed = "",
  FolderEmpty = "",
  FolderOpen = "",
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
  Branch = "󰘬",
  Add = " ",
  Change = " ",
  Delete = " ",
  Staged = " ",
  Unstaged = " ",
  Conflict = " ",
  Ignored = " ",
  Renamed = "➜",
  Untracked = "",
}

M.Kinds = {
  Text = "󰰦",
  Method = "󰰑",
  Function = "󰯼",
  Constructor = "󰯱",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
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
