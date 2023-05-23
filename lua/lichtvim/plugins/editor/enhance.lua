return {
  { "yianwillis/vimcdoc", lazy = true },
  { "itchyny/vim-cursorword", event = { "BufNewFile", "BufRead" } }, -- 标注所有光标所在单词
  { "nacro90/numb.nvim", lazy = true, config = true },
  { "karb94/neoscroll.nvim", lazy = true, config = true },
  { "echasnovski/mini.bufremove", lazy = true },
  { "junegunn/vim-easy-align", lazy = true },
  { "phaazon/hop.nvim", lazy = true, config = { keys = "etovxqpdygfblzhckisuran" } },
  {
    "kevinhwang91/nvim-hlslens",
    lazy = true,
    config = function()
      require("hlslens").setup()
    end,
  },
}
