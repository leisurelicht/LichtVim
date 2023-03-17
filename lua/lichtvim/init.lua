local M = {}

---@param opts? LichtVimConfig
function M.setup(opts)
  require("lichtvim.config").setup(opts)
end

return M
