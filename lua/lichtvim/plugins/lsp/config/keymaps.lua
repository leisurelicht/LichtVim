local M = {}

---@type PluginLspKeys
M._keys = nil

---@return (LazyKeys|{has?:string})[]
function M.get()
  local format = function()
    require("lichtvim.plugins.lsp.config.format").format({ force = true })
  end

  local builtin = require("telescope.builtin")
  local utils = require("lichtvim.utils")
  local call = utils.func.call

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
      -- { "<leader>lf", format.toggle, desc = "Toggle format", has = "documentFormatting" },
      { "<leader>lF", format, desc = "Format document", has = "documentFormatting" },
      { "<leader>lF", format, desc = "Format range", mode = "v", has = "documentRangeFormatting" },
      { "<leader>lk", vim.lsp.buf.signature_help, desc = "Signature help", has = "signatureHelp" },
      { "<c-k>", vim.lsp.buf.signature_help, desc = "Signature help", mode = "i", has = "signatureHelp" },
      { "<leader>li", vim.lsp.buf.incoming_calls, desc = "Incoming calls", has = "callHierarchy" },
      { "<leader>lo", vim.lsp.buf.outgoing_calls, desc = "Outgoing calls", has = "callHierarchy" },
      { "<leader>lh", vim.lsp.buf.hover, desc = "Hover", has = "hover" },
      { "<leader>lr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
      { "<leader>la", vim.lsp.buf.code_action, mode = { "v", "n" }, desc = "Code action", has = "codeAction" },
      { "<leader>ll", call(vim.diagnostic.open_float, { scope = "line", border = "rounded" }), desc = "Diagnostic (line)" },
      { "<leader>lc", call(vim.diagnostic.open_float, { scope = "cursor", border = "rounded" }), desc = "Diagnostic (cursor)" },
      { "<leader>lD", call(vim.lsp.buf.definition, { jump_type = "tab" }), desc = "Goto definition (tab)", has = "definition" },

      { "<leader>lL", call(builtin.diagnostics, {}), desc = "Diagnostic (project)" },
      { "<leader>le", call(builtin.lsp_references, { show_line = false }), desc = "Goto references", has = "references" },
      { "<leader>li", call(builtin.lsp_implementations, { show_line = false }), desc = "Goto implementation", has = "implementation" },
      { "<leader>lt", call(builtin.lsp_type_definitions, { show_line = false }), desc = "Goto type definition", has = "typeDefinition" },
      { "<leader>ld", call(builtin.lsp_definitions, { reuse_win = true, show_line = false }), desc = "Goto definition", has = "definition" },
      { "<leader>li", call(builtin.lsp_incoming_calls, {}), desc = "Incoming calls", has = "callHierarchy" },
      { "<leader>lo", call(builtin.lsp_outgoing_calls, {}), desc = "Outgoing calls", has = "callHierarchy" },
    }
  end
  if require("lichtvim.utils.lazy").has("lspsaga.nvim") then
    local keys = {
      { "<leader>lh", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover", has = "hover" },
      { "<leader>lH", "<cmd>Lspsaga hover_doc ++keep<cr>", desc = "Hover keep", has = "hover" },
      { "<leader>la", "<cmd>Lspsaga code_action<cr>", mode = { "v", "n" }, desc = "Code action", has = "codeAction" },
    }
    utils.list.extend(M._keys, keys)
  end

  return M._keys
end

function M.on_attach(client, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = {} ---@type table<string,LazyKeys|{has?:string}>

  for _, value in ipairs(M.get()) do
    local keys = Keys.parse(value)
    if keys[2] == vim.NIL or keys[2] == false then
      keymaps[keys.id] = nil
    else
      keymaps[keys.id] = keys
    end
  end

  for _, keys in pairs(keymaps) do
    if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
      local opts = Keys.opts(keys)
      ---@diagnostic disable-next-line: no-unknown
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys[1], keys[2], opts)
    end
  end

  require("which-key").register({ l = { name = " LSP" }, mode = { "n", "v" }, prefix = "<leader>" })
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

return M
