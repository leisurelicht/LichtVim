return {
  require("lichtvim.plugins.coding.indent"),
  require("lichtvim.plugins.coding.autopairs"),
  require("lichtvim.plugins.coding.git"),
  require("lichtvim.plugins.coding.others"),
  { "tpope/vim-surround", event = { "BufRead", "BufNewFile" } },
  { "p00f/nvim-ts-rainbow", event = { "BufRead", "BufNewFile" } },
  {
    "andymass/vim-matchup",
    event = { "BufNewFile", "BufRead" },
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "poopup" }
      if lazy.has("which-key.nvim") then
        require("which-key").register({
          ["]%"] = "Jump to next matchup",
          ["[%"] = "Jump to previous matchup",
          ["g%"] = "Jump to close matchup",
          ["z%"] = "Jump inside matchup",
          mode = "n",
        })
      end
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufRead", "BufNewFile" },
    opts = {
      toggler = {
        line = "gcc", -- 切换行注释
        block = "gCC", --- 切换块注释
      },
      opleader = {
        line = "gc", -- 可视模式下的行注释
        block = "gC", -- 可视模式下的块注释
      },
      extra = {
        above = "gcO", -- 在当前行上方新增行注释
        below = "gco", -- 在当前行下方新增行注释
        eol = "gcl", -- 在当前行行尾新增行注释
      },
      ignore = "^$",
    },
  },
}
