return {
  { "itchyny/vim-cursorword", event = { "BufNewFile", "BufRead" } }, -- 标注所有光标所在单词
  { "nacro90/numb.nvim", lazy = true, config = true },
  { "karb94/neoscroll.nvim", lazy = true, config = true },
  { "echasnovski/mini.bufremove", lazy = true },
  { "junegunn/vim-easy-align", lazy = true },
  { "phaazon/hop.nvim", lazy = true, opts = { keys = "etovxqpdygfblzhckisuran" } },
  {
    "kevinhwang91/nvim-hlslens",
    lazy = true,
    config = function()
      require("hlslens").setup()
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    lazy = true,
    cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers" },
    config = function(_, opts)
      require("colorizer").setup(opts)
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require("statuscol.builtin")
          require("statuscol").setup({
            relculright = true,
            segments = {
              { text = { " ", builtin.lnumfunc }, click = "v:lua.ScLa" },
              {
                sign = { name = { "Git" }, maxwidth = 1, colwidth = 1, auto = false, wrap = false },
                click = "v:lua.ScSa",
              },
              { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
            },
          })
        end,
      },
    },
    init = function()
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
      open_fold_hl_timeout = 400,
      close_fold_kinds = { "imports", "comment" },
      preview = {
        win_config = {
          border = { "", "─", "", "", "", "─", "", "" },
          -- winhighlight = "Normal:Folded",
          winblend = 0,
        },
        mappings = {
          scrollU = "<C-u>",
          scrollD = "<C-d>",
          jumpTop = "[",
          jumpBot = "]",
        },
      },
    },
    config = function(_, opts)
      require("ufo").setup(opts)
    end,
  },
}
