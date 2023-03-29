local Keys = require("lazy.core.handler.keys")
local has = require("lichtvim.utils.lazy").has
local format = require("lichtvim.plugins.lsp.format").format
local wk_ok, wk = pcall(require, "which-key")
local telescope_ok, _ = pcall(require, "telescope")

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
    -- map.set("n", "<leader>lo", "<CMD>SymbolsOutline<CR>", "Open Outline")

    { "<leader>ln", M.diagnostic_goto(true), desc = "Next Diagnostic" },
    { "<leader>lp", M.diagnostic_goto(false), desc = "Prev Diagnostic" },
    { "]d", M.diagnostic_goto(true), desc = "Next Diagnostic" },
    { "[d", M.diagnostic_goto(false), desc = "Prev Diagnostic" },
    { "]e", M.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
    { "[e", M.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
    { "]w", M.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
    { "[w", M.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
    { "<leader>lf", format, desc = "Format Document", has = "documentFormatting" },
    { "<leader>lf", format, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
    { "<leader>lk", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
    { "<c-k>", vim.lsp.buf.signature_help, desc = "Signature Help", mode = "i", has = "signatureHelp" },
    { "<leader>lh", vim.lsp.buf.hover, desc = "Hover" },
    {
      "<leader>la",
      function()
        vim.lsp.buf.code_action({
          context = {
            only = {
              "source",
            },
            diagnostics = {},
          },
        })
      end,
      desc = "Source Action",
      has = "codeAction",
    },
  }

  if has("lspsaga.nvim") then
    M._keys[#M._keys + 1] = {
      "<leader>ll",
      "<CMD>Lspsaga show_line_diagnostics<CR>",
      desc = "Line Diagnostic",
    }
  else
    M._keys[#M._keys + 1] = {
      "<leader>ll",
      vim.diagnostic.open_float,
      desc = "Line Diagnostic",
    }
  end

  if has("inc-rename.nvim") then
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

  if wk_ok then
    wk.register({
      l = { name = "LSP" },
      mode = { "n", "v" },
      prefix = "<leader>",
    })
  end
end

return M
