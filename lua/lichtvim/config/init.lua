-- =================
-- init.lua
-- Note: config init
-- =================
--
--
local M = {}

require("lichtvim.utils.G")

M.lazy_version = ">=9.1.0"

---@class LazyVimConfig
local defaults = {
  -- colorscheme can be a string like `catppuccin` or a function that will load the colorscheme
  ---@type string|fun()
  colorscheme = function()
    require("tokyonight").load()
  end,
  -- load the default settings
  defaults = {
    autocmds = true, -- lazyvim.config.autocmds
    keymaps = true, -- lazyvim.config.keymaps
    options = true -- lazyvim.config.options
  },
  -- icons used by other plugins
  icons = {
    diagnostics = {
      Error = " ",
      Warn = " ",
      Hint = " ",
      Info = " "
    },
    git = {
      added = " ",
      modified = " ",
      removed = " "
    },
    kinds = {
      Array = " ",
      Boolean = " ",
      Class = " ",
      Color = " ",
      Constant = " ",
      Constructor = " ",
      Copilot = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = " ",
      File = " ",
      Folder = " ",
      Function = " ",
      Interface = " ",
      Key = " ",
      Keyword = " ",
      Method = " ",
      Module = " ",
      Namespace = " ",
      Null = " ",
      Number = " ",
      Object = " ",
      Operator = " ",
      Package = " ",
      Property = " ",
      Reference = " ",
      Snippet = " ",
      String = " ",
      Struct = " ",
      Text = " ",
      TypeParameter = " ",
      Unit = " ",
      Value = " ",
      Variable = " "
    }
  }
}

function M.setup(opts)
  options = vim.tbl_deep_extend("force", defaults, opts or {})
  if not M.has() then
    require("lazy.config.util").error(
      "**LazyVim** needs **lazy.nvim** version " ..
        M.lazy_version .. " to work properly.\n" .. "Please upgrade **lazy.nvim**",
      {title = "LazyVim"}
    )
    error("Exiting")
  end

  if vim.fn.argc(-1) == 0 then
    api.autocmd(
      "User",
      {
        group = api.augroup("LichtVim"),
        pattern = "VeryLazy",
        callback = function()
          -- require("lichtvim.config.autocmds")
          -- require("lichtvim.config.keymaps")
          M.load("autocmds")
          M.load("keymaps")
        end
      }
    )
  else
    -- require("lichtvim.config.autocmds")
    -- require("lichtvim.config.keymaps")

    M.load("autocmds")
    M.load("keymaps")
  end

  require("lazy.core.util").try(
    function()
      if type(M.colorscheme) == "function" then
        M.colorscheme()
      else
        vim.cmd.colorscheme(M.colorscheme)
      end
    end,
    {
      msg = "Could not load your colorscheme",
      on_error = function(msg)
        require("lazy.core.util").error(msg)
        vim.cmd.colorscheme("nightfox")
      end
    }
  )
end

function M.has(range)
  local Semver = require("lazy.manage.semver")
  return Semver.range(range or M.lazy_version):matches(require("lazy.core.config").version or "0.0.0")
end

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
  local Util = require("lazy.core.util")
  local function _load(mod)
    Util.try(
      function()
        require(mod)
      end,
      {
        msg = "Failed loading " .. mod,
        on_error = function(msg)
          local modpath = require("lazy.core.cache").find(mod)
          if modpath then
            Util.error(msg)
          end
        end
      }
    )
  end
  -- always load lichtvim, then user file
  if M.defaults[name] then
    _load("lichtvim.config." .. name)
  end

  _load("config." .. name)
  if vim.bo.filetype == "lazy" then -- HACK: LazyVim may have overwritten options of the Lazy ui, so reset this here
    vim.cmd([[do VimResized]])
  end
end

M.did_init = false
function M.init()
  if not M.did_init then
    M.did_init = true
    require("lichtvim.utils").lazy_notify()

    require("lichtvim.config").load("options")
  end
end

setmetatable(
  M,
  {
    __index = function(_, key)
      if options == nil then
        return vim.deepcopy(defaults)[key]
      end
      ---@cast options LichtVimConfig
      return options[key]
    end
  }
)

return M
