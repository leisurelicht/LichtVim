local M = {}

---@param opts? LazyVimConfig
function M.setup(opts)
  require("lichtvim.utils.G")

  require("lichtvim.core").setup(opts)
end

return M
