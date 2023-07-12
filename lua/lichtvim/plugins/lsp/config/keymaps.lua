local M = {}

---@type PluginLspKeys
M._keys = nil

---@return (LazyKeys|{has?:string})[]
function M.get()
  local format = require("lichtvim.plugins.lsp.config.format")
  local builtin = require("telescope.builtin")
  local utils = require("lichtvim.utils")
  local call = utils.func.call

  local formatting = function()
    format.format({ force = true })
  end

  if not M._keys then
  ---@class PluginLspKeys
    -- stylua: ignore
    M._keys =  {
      { "<leader>pi", "<cmd>LspInfo<cr>", desc = "Info" },
      { "<leader>ln", M.diagnostic_goto(true), desc = "Next diagnostic" },
      { "<leader>lp", M.diagnostic_goto(false), desc = "Previous diagnostic" },
      { "]d", M.diagnostic_goto(true), desc = "Next diagnostic" },
      { "[d", M.diagnostic_goto(false), desc = "Previous diagnostic" },
      { "]e", M.diagnostic_goto(true, "ERROR"), desc = "Next diagnostic (error)" },
      { "[e", M.diagnostic_goto(false, "ERROR"), desc = "Previous diagnostic (error)" },
      { "]w", M.diagnostic_goto(true, "WARN"), desc = "Next diagnostic (warning)" },
      { "[w", M.diagnostic_goto(false, "WARN"), desc = "Previous diagnostic (warning)" },
      { "<leader>lf", format.toggle, desc = "Toggle format", has = "documentFormatting" },
      { "<leader>lF", formatting, desc = "Format document", has = "formatting" },
      { "<leader>lF", formatting, desc = "Format range", mode = "v", has = "rangeFormatting" },
      { "<leader>lk", vim.lsp.buf.signature_help, desc = "Signature help", has = "signatureHelp" },
      { "<c-k>", vim.lsp.buf.signature_help, desc = "Signature help", mode = "i", has = "signatureHelp" },
      { "<leader>li", vim.lsp.buf.incoming_calls, desc = "Incoming calls", has = "callHierarchy" },
      { "<leader>lo", vim.lsp.buf.outgoing_calls, desc = "Outgoing calls", has = "callHierarchy" },
      { "<leader>lh", vim.lsp.buf.hover, desc = "Hover", has = "hover" },
      { "<leader>lr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
      { "<leader>la", vim.lsp.buf.code_action, mode = { "v", "n" }, desc = "Code action", has = "codeAction" },
      { "<leader>ll", call(vim.diagnostic.open_float, { scope = "line", border = "rounded" }), desc = "Diagnostic (line)" },
      { "<leader>lc", call(vim.diagnostic.open_float, { scope = "cursor", border = "rounded" }), desc = "Diagnostic (cursor)" },
      { "<leader>lD", call(vim.lsp.buf.declaration, {}), desc = "Goto declaration", has = "declaration" },

      { "<leader>lL", call(builtin.diagnostics, {}), desc = "Diagnostic (project)" },
      { "<leader>le", call(builtin.lsp_references, { show_line = false }), desc = "Goto references", has = "references" },
      { "<leader>li", call(builtin.lsp_implementations, { show_line = false }), desc = "Goto implementation", has = "implementation" },
      { "<leader>lt", call(builtin.lsp_type_definitions, { show_line = false }), desc = "Goto type definition", has = "typeDefinition" },
      { "<leader>ld", call(builtin.lsp_definitions, { reuse_win = true, show_line = false }), desc = "Goto definition", has = "definition" },
      { "<leader>li", call(builtin.lsp_incoming_calls, {}), desc = "Incoming calls", has = "callHierarchy/incomingCalls" },
      { "<leader>lo", call(builtin.lsp_outgoing_calls, {}), desc = "Outgoing calls", has = "callHierarchy/outgoingCalls" },
    }
  end

  return M._keys
end
---@param method string
function M.has(buffer, method)
  method = method:find("/") and method or "textDocument/" .. method
  local clients = vim.lsp.get_active_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

function M.resolve(buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = {} ---@type table<string,LazyKeys|{has?:string}>

  local function add(keymap)
    local keys = Keys.parse(keymap)
    if keys[2] == false then
      keymaps[keys.id] = nil
    else
      keymaps[keys.id] = keys
    end
  end
  for _, keymap in ipairs(M.get()) do
    add(keymap)
  end

  local opts = require("lichtvim.utils.lazy").opts("nvim-lspconfig")
  local clients = vim.lsp.get_active_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    for _, keymap in ipairs(maps) do
      add(keymap)
    end
  end
  return keymaps
end

function M.on_attach(_, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    if not keys.has or M.has(buffer, keys.has) then
      local opts = Keys.opts(keys)
      ---@diagnostic disable-next-line: no-unknown
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys[1], keys[2], opts)
    end
  end

  require("which-key").register({ ["<leader>l"] = { name = "󰖳 Lsp" }, mode = { "n", "v" } })
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity, float = { border = "rounded" } })
  end
end

return M
