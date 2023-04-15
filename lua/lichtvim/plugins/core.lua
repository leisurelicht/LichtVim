require("lichtvim.config").init()

local core = {
  { "folke/lazy.nvim", version = "*" },
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
    cmd = { "PlenaryBustedFile", "PlenaryBustedDirectory" },
  },
}

local dev = os.getenv("LICHTVIM_DEV")
if dev == "1" then
  return core
else
  table.insert(
    core,
    2,
    { "leisurelicht/LichtVim", priority = 10000, lazy = false, config = true, cond = true, version = "*" }
  )
  return core
end
