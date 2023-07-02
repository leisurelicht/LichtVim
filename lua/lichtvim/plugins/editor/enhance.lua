return {
  { "itchyny/vim-cursorword", event = { "BufNewFile", "BufRead" } }, -- 标注所有光标所在单词
  { "nacro90/numb.nvim", lazy = true, config = true },
  { "karb94/neoscroll.nvim", lazy = true, config = true },
  { "echasnovski/mini.bufremove", lazy = true },
  { "junegunn/vim-easy-align", lazy = true },
  { "phaazon/hop.nvim", lazy = true, opts = { keys = "etovxqpdygfblzhckisuran" } },
  { "kevinhwang91/nvim-hlslens", lazy = true },
  {
    "NvChad/nvim-colorizer.lua",
    lazy = true,
    cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers" },
    config = function(_, opts)
      require("colorizer").setup(opts)
    end,
  },
}
