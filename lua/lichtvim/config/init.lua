-- =================
-- init.lua
-- Note: config init
-- =================
--
_G.map = require("lichtvim.utils.mapping")
_G.log = require("lichtvim.utils.lazy").log

-- 展开打印各种数据
_G.Dump = function(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

local icons = require("lichtvim.config.ui.icons")
local utils = require("lichtvim.utils")

local M = {}

M.lazy_version = ">=9.1.0"

---@class LichtVimConfig
local defaults = {
  -- colorscheme can be a string like `catppuccin` or a function that will load the colorscheme
  ---@type string|fun()
  colorscheme = "catppuccin",
  -- load the default settings
  defaults = {
    autocmds = true, -- lichtvim.config.autocmds
    keymaps = true, -- lichtvim.config.keymaps
    options = true, -- lichtvim.config.options
  },
  -- icons used by other plugins
  icons = {
    diagnostics = icons.Diagnostics,
    git = icons.Git,
    kinds = icons.Kinds,
    sources = icons.Sources,
    file = icons.File,
    other = icons.Other,
  },
  ---@type string
  lang = "en",

  auto_save = false,
}

local options

function M.setup(opts)
  options = vim.tbl_deep_extend("force", defaults, opts or {})
  if not M.has() then
    require("lazy.config.util").error(
      "**LichtVim** needs **lazy.nvim** version "
        .. M.lazy_version
        .. " to work properly.\n"
        .. "Please upgrade **lazy.nvim**",
      { title = utils.title.string }
    )
    error("Exiting")
  end

  if vim.fn.argc(-1) == 0 then
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup(utils.title.add("Setup"), { clear = true }),
      pattern = "VeryLazy",
      callback = function()
        M.load("autocmds")
        M.load("keymaps")
      end,
    })
  else
    M.load("autocmds")
    M.load("keymaps")
  end

  require("lazy.core.util").try(function()
    if type(M.colorscheme) == "function" then
      M.colorscheme()
    else
      vim.cmd.colorscheme(M.colorscheme)
    end
  end, {
    msg = "Could not load your colorscheme",
    on_error = function(msg)
      require("lazy.core.util").error(msg)
      vim.cmd.colorscheme("habamax")
    end,
  })
end

function M.has(range)
  local Semver = require("lazy.manage.semver")
  return Semver.range(range or M.lazy_version):matches(require("lazy.core.config").version or "0.0.0")
end

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
  local Util = require("lazy.core.util")
  local function _load(mod)
    Util.try(function()
      require(mod)
    end, {
      msg = "Failed loading " .. mod,
      on_error = function(msg)
        local info = require("lazy.core.cache").find(mod)
        if info == nil or (type(info) == "table" and #info == 0) then
          return
        end
        Util.error(msg)
      end,
    })
  end

  -- always load lichtvim, then user file
  if M.defaults[name] then
    _load("lichtvim.config." .. name)
  end
  _load("config." .. name)
  if vim.bo.filetype == "lazy" then
    -- HACK: LichtVim may have overwritten options of the Lazy ui, so reset this here
    vim.cmd([[do VimResized]])
  end
end

M.did_init = false
function M.init()
  if not M.did_init then
    M.did_init = true
    require("lichtvim.utils.lazy").lazy_notify()

    require("lichtvim.config").load("options")
  end
end

setmetatable(M, {
  __index = function(_, key)
    if options == nil then
      return vim.deepcopy(defaults)[key]
    end
    ---@cast options LichtVimConfig
    return options[key]
  end,
})

return M
