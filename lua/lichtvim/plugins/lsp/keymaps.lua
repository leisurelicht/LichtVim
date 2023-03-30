local Keys = require("lazy.core.handler.keys")
local format = require("lichtvim.plugins.lsp.format").format
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
    { "<leader>lI", "<CMD>LspInfo<CR>", desc = "Info" },
    -- { "<leader>lo", "<CMD>SymbolsOutline<CR>", desc = "Open Outline"},
    { "<leader>ln", M.diagnostic_goto(true), desc = "Next Diagnostic" },
    { "<leader>lp", M.diagnostic_goto(false), desc = "Prev Diagnostic" },
    { "]d", M.diagnostic_goto(true), desc = "Next Diagnostic" },
    { "[d", M.diagnostic_goto(false), desc = "Prev Diagnostic" },
    { "]e", M.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
    { "[e", M.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
    { "]w", M.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
    { "[w", M.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
    { "<leader>lF", format, desc = "Format Document", has = "documentFormatting" },
    { "<leader>lF", format, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
    { "<leader>lk", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
    { "<c-k>", vim.lsp.buf.signature_help, desc = "Signature Help", mode = "i", has = "signatureHelp" },
    { "<leader>lh", vim.lsp.buf.hover, desc = "Hover" },
    {
      "<leader>ll",
      vim.diagnostic.open_float,
      desc = "Line Diagnostic",
    },
    {
      "<leader>la",
      function()
        require("actions-preview").code_actions({
          context = {
            only = { "source" },
            diagnostics = {},
          },
        })
      end,
      mode = { "v", "n" },
      desc = "Code Action",
      has = "codeAction",
    },
    -- {
    --   "<leader>lA",
    --   function()
    --     vim.lsp.buf.code_action({
    --       context = {
    --         only = {
    --           "source",
    --         },
    --         diagnostics = {},
    --       },
    --     })
    --   end,
    --   desc = "Code Action",
    --   has = "codeAction",
    -- },
  }

  if lazy.has("telescope.nvim") then
    local _keys = {
      { "<leader>lf", "<cmd>Telescope lsp_references<cr>", desc = "Goto References" },
      {
        "<leader>ld",
        "<cmd>Telescope lsp_definitions theme=dropdown<cr>",
        desc = "Goto Definition",
        has = "definition",
      },
      { "<leader>li", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
      { "<leader>lt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto Type Definition" },
      { "<leader>lg", "<CMD>Telescope diagnostics<CR>", desc = "Diagnostic" },
    }

    list.extend(M._keys, _keys)
  else
    local _keys = {
      { "<leader>lf", vim.lsp.buf.references, "References" },
      { "<leader>ld", vim.lsp.buf.definition, "Definition" },
      { "<leader>lt", vim.lsp.buf.type_definition, "Type Definition" },
      { "<leader>li", vim.lsp.buf.implementation, "Implementation" },
      { "<leader>lg", vim.diagnostic.setloclist, "Diagnostic" },
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
