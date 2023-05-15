return {
  { -- 自动配对
    "windwp/nvim-autopairs",
    enabled = true,
    event = { "BufNewFile", "BufRead" },
    opts = { enable_check_bracket_line = false, ignored_next_char = "[%w%.]" },
  },
  {
    "echasnovski/mini.pairs",
    enabled = false,
    event = { "BufNewFile", "BufRead" },
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },
}
