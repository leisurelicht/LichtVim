-- =================
-- init.lua
-- =================
--
--
return {
  {"nvim-lua/plenary.nvim", lazy = true, cmd = {"PlenaryBustedFile", "PlenaryBustedDirectory"}},
  -- {"MunifTanjim/nui.nvim", lazy = true},
  {"ahmedkhalf/project.nvim", config = function() require("project_nvim").setup() end},
  {"p00f/nvim-ts-rainbow", event = {"BufRead", "BufNewFile"}},
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {enable_check_bracket_line = false, ignored_next_char = "[%w%.]"}
  }, -- 自动配对
  {"tpope/vim-surround", event = "InsertEnter"}, -- 快速修改
  {"vim-scripts/indentpython.vim", ft = {"python", "djangohtml"}}, -- python indent
  {
    "andymass/vim-matchup",
    event = {"BufNewFile", "BufRead"},
    init = function() vim.g.matchup_matchparen_offscreen = {method = "poopup"} end
  },
  {"itchyny/vim-cursorword", event = {"BufNewFile", "BufRead"}} -- 标注所有光标所在单词
}
