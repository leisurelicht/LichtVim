-- =================
-- init.lua
-- Note: core init
-- =================
--
--

local M = {}

function M.setup(opts)
  vim.notify = vim.pretty_print

  require("lichtvim.core.basic")

  if vim.fn.argc(-1) == 0 then
    api.autocmd(
      "User",
      {
        group = api.augroup("LichtVim"),
        pattern = "VeryLazy",
        callback = function()
          require("lichtvim.core.autocmds")
          require("lichtvim.core.keybindings")
        end
      }
    )
  else
    require("lichtvim.core.autocmds")
    require("lichtvim.core.keybindings")
  end
end

return M
