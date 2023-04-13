local Keys = require("lazy.core.handler.keys")
local format = require("lichtvim.plugins.lsp.config.format").format
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
    { "<leader>lF", format, desc = "Format document", has = "documentFormatting" },
    { "<leader>lF", format, desc = "Format range", mode = "v", has = "documentRangeFormatting" },
    { "<leader>lk", vim.lsp.buf.signature_help, desc = "Signature help", has = "signatureHelp" },
    { "<c-k>", vim.lsp.buf.signature_help, desc = "Signature help", mode = "i", has = "signatureHelp" },
    { "<leader>lo", "<cmd>SymbolsOutline<cr>", desc = "Open outline" },
    { "<leader>lh", vim.lsp.buf.hover, desc = "Hover" },
    { "<leader>ld", vim.lsp.buf.definition, desc = "Goto definition" },
    { "<leader>lt", vim.lsp.buf.type_definition, desc = "Goto type definition" },
    { "<leader>li", vim.lsp.buf.implementation, desc = "Goto implementation", has = "implementation" },
    { "<leader>lf", vim.lsp.buf.references, desc = "Goto references" },
    {
      "<leader>la",
      vim.lsp.buf.code_action,
      mode = { "v", "n" },
      desc = "Code action",
      has = "codeAction",
    },
    {
      "<leader>lD",
      function()
        vim.lsp.buf.definition({ jump_type = "tab" })
      end,
      desc = "Goto definition (tab)",
    },
    {
      "<leader>ll",
      function()
        vim.diagnostic.open_float({
          border = "rounded",
        })
      end,
      desc = "Diagnostic (line)",
    },
    { "<leader>lg", vim.lsp.buf.references, desc = "Diagnostic (buffer)" },
  }

  if lazy.has("actions-preview.nvim") then
    _keys = {
      {
        "<leader>la",
        function()
          require("actions-preview").code_actions()
        end,
        mode = { "v", "n" },
        desc = "Code action (preview)",
        has = "codeAction",
      },
    }
    list.extend(M._keys, _keys)
  end

  if lazy.has("lspsaga.nvim") and false then
    _keys = {
      {
        "<leader>la",
        "<cmd>Lspsaga code_action<CR>",
        mode = { "v", "n" },
        desc = "Code action",
        has = "codeAction",
      },
      { "<leader>lh", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover" },
      { "<leader>lH", "<cmd>Lspsaga hover_doc ++keep<cr>", desc = "Hover" },
      {
        "<leader>ll",
        "<cmd>Lspsaga show_line_diagnostics<CR>",
        desc = "Diagnostic (line)",
      },
      {
        "<leader>lc",
        "<cmd>Lspsaga show_cursor_diagnostics<CR>",
        desc = "Diagnostic (cursor)",
      },
    }
    list.extend(M._keys, _keys)
  end

  if lazy.has("telescope.nvim") then
    local builtin = require("telescope.builtin")
    local _keys = {
      {
        "<leader>ld",
        function()
          builtin.lsp_definitions({ reuse_win = true })
        end,
        desc = "Goto definition",
        has = "definition",
      },
      {
        "<leader>lf",
        function()
          builtin.lsp_references({})
        end,
        desc = "Goto references",
        has = "references",
      },
      {
        "<leader>li",
        function()
          builtin.lsp_implementations({})
        end,
        desc = "Goto implementation",
        has = "implementation",
      },
      {
        "<leader>lt",
        function()
          builtin.lsp_type_definitions({})
        end,
        desc = "Goto type definition",
        has = "typeDefinition",
      },
      {
        "<leader>lL",
        function()
          builtin.diagnostics({})
        end,
        desc = "Diagnostic (project)",
      },
    }
    list.extend(M._keys, _keys)
  end

  if lazy.has("inc-rename.nvim") then
    M._keys[#M._keys + 1] = {
      "<leader>lr",
      function()
        require("inc_rename")
        return ":IncRename " .. vim.fn.expand("<cword>")
      end,
      expr = true,
      desc = "Rename",
      has = "rename",
    }
  else
    M._keys[#M._keys + 1] = { "<leader>lr", vim.lsp.buf.rename, desc = "Rename", has = "rename" }
  end

  return M._keys
end

function M.on_attach(client, buffer)
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