return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      operators = {},
      key_labels = {
        ["<c-w>"] = "<C-W>",
        ["<leader>"] = "<Leader>",
      },
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "", -- symbol used between a key and it's label
        group = "", -- symbol prepended to a group
      },
      popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
      },
      window = {
        border = "rounded", -- none, single, double, shadow
        position = "bottom", -- bottom, top
      },
      layout = {
        align = "center", -- align columns left, center or right
      },
      ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
      hidden = { "<Ignore>", "<Plug>", "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- hide mapping boilerplate
      show_help = true, -- show a help message in the command line for using WhichKey
      show_keys = true, -- show the currently pressed key and its label as a message in the command line
      triggers = "auto", -- automatically setup triggers
      disable = {
        buftypes = {},
        filetypes = { "TelescopePrompt", "lazy", "NvimTree", "mason", "lspinfo", "toggleterm", "neo-tree" },
      },
    },
    config = true,
  },
}
