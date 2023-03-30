require("lichtvim.config").init()

local dev = os.getenv("LICHT_VIM_DEV")
if dev == "1" then
  return {
    { "folke/lazy.nvim", version = "*" },
  }
else
  return {
    { "folke/lazy.nvim", version = "*" },
    { "leisurelicht/LichtVim", priority = 10000, lazy = false, config = true, cond = true, version = "*" },
  }
end
