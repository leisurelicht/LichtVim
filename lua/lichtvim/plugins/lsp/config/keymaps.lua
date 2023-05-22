local Keys = require("lazy.core.handler.keys")
local format = require("lichtvim.plugins.lsp.config.format").format
local toggle = require("lichtvim.plugins.lsp.config.format").toggle
local list = require("lichtvim.utils").list

local M = {}

M._keys = nil

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

function M.get()
  if M._keys then
    return M._keys
  end

  M._keys = {
    { "<leader>lI", "<cmd>LspInfo<cr>", desc = "Info" },
    { "<leader>ln", M.diagnostic_goto(true), desc = "Next diagnostic" },
    { "<leader>lp", M.diagnostic_goto(false), desc = "Previous diagnostic" },
    { "]d", M.diagnostic_goto(true), desc = "Next diagnostic" },
    { "[d", M.diagnostic_goto(false), desc = "Previous diagnostic" },
    { "]e", M.diagnostic_goto(true, "ERROR"), desc = "Next diagnostic (error)" },
    { "[e", M.diagnostic_goto(false, "ERROR"), desc = "Previous diagnostic (error)" },
    { "]w", M.diagnostic_goto(true, "WARN"), desc = "Next diagnostic (warning)" },
    { "[w", M.diagnostic_goto(false, "WARN"), desc = "Previous diagnostic (warning)" },
    { "<leader>lf", toggle, desc = "Toggle format", has = "documentFormatting" },
    { "<leader>lF", format, desc = "Format document", has = "documentFormatting" },
    { "<leader>lF", format, desc = "Format range", mode = "v", has = "documentRangeFormatting" },
    { "<leader>lk", vim.lsp.buf.signature_help, desc = "Signature help", has = "signatureHelp" },
    { "<c-k>", vim.lsp.buf.signature_help, desc = "Signature help", mode = "i", has = "signatureHelp" },
    { "<leader>lh", vim.lsp.buf.hover, desc = "Hover", has = "hover" },
    { "<leader>lr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
    { "<leader>la", vim.lsp.buf.code_action, mode = { "v", "n" }, desc = "Code action", has = "codeAction" },
    -- stylua: ignore
    { "<leader>ll", function() vim.diagnostic.open_float({ border = "rounded" }) end, desc = "Diagnostic (line)" },
    -- stylua: ignore
    { "<leader>lD", function() vim.lsp.buf.definition({ jump_type = "tab" }) end, desc = "Goto definition (tab)", has = "definition" },
  }

  if lazy.has("lspsaga.nvim") then
    _keys = {
      { "<leader>lh", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover", has = "hover" },
      { "<leader>lH", "<cmd>Lspsaga hover_doc ++keep<cr>", desc = "Hover", has = "hover" },
      { "<leader>ll", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Diagnostic (line)" },
      { "<leader>lc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", desc = "Diagnostic (cursor)" },
    }
    list.extend(M._keys, _keys)
  end

  if lazy.has("telescope.nvim") then
    local builtin = require("telescope.builtin")
    -- stylua: ignore
    local _keys = {
      { "<leader>lL", function() builtin.diagnostics({}) end, desc = "Diagnostic (project)" },
      { "<leader>le", function() builtin.lsp_references({ show_line = false }) end, desc = "Goto references", has = "references" },
      { "<leader>li", function() builtin.lsp_implementations({ show_line = false }) end, desc = "Goto implementation", has = "implementation" },
      { "<leader>lt", function() builtin.lsp_type_definitions({ show_line = false }) end, desc = "Goto type definition", has = "typeDefinition" },
      { "<leader>ld", function() builtin.lsp_definitions({ reuse_win = true, show_line = false }) end, desc = "Goto definition", has = "definition" },
    }
    list.extend(M._keys, _keys)
  end

  return M._keys
end

function M.on_attach(client, buffer)
  vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local keymaps = {}
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
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      map.set(keys.mode or "n", keys[1], keys[2], nil, opts)
    end
  end

  if lazy.has("which-key.nvim") then
    require("which-key").register({
      l = { name = "LSP" },
      mode = { "n", "v" },
      prefix = "<leader>",
    })
  end
end

return M
