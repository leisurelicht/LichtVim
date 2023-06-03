local Util = require("lazy.core.util")

local M = {}

M.autoformat = true

function M.toggle()
  if vim.b.autoformat == false then
    vim.b.autoformat = nil
    M.autoformat = true
  else
    M.autoformat = not M.autoformat
  end
  if M.autoformat then
    Util.info("Enabled format on save", { title = LichtVimTitle })
  else
    Util.warn("Disabled format on save", { title = LichtVimTitle })
  end
end

function M.format()
  if vim.b.autoformat == false then
    return
  end

  local buf = vim.api.nvim_get_current_buf()

  vim.lsp.buf.format({
    bufnr = buf,
    filter = function(client)
      return client.name == "null-ls"
    end,
    async = true,
  })
end

function M.on_attach(client, buf)
  if
    client.config
    and client.config.capabilities
    and client.config.capabilities.documentFormattingProvider == false
  then
    return false
  end

  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup(add_title("formatting"), { clear = true }),
      buffer = buf,
      callback = function()
        if M.autoformat then
          M.format()
        end
      end,
    })
  end
end

return M
