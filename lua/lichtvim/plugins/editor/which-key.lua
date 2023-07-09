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
      defaults = {
        n = {
          mode = { "n" },
          ["<SNR>"] = { name = "Script Number" },
          ["<leader>"] = { name = "Show Custom Key Map" },
          ["<localleader>"] = { "<cmd>WhichKey<cr>", "Show Key Map" },

          g = { name = "Goto" },
          gug = { name = "Goto" },
          gui = { name = "Inside" },
          gua = { name = "Around" },
          guz = { name = "Z" },
          ["gu["] = { name = "Previous" },
          ["gu]"] = { name = "Next" },
          gUg = { name = "Goto" },
          gUi = { name = "Inside" },
          gUa = { name = "Around" },
          gUz = { name = "Z" },
          ["gU["] = { name = "previous" },
          ["gU]"] = { name = "next" },
          ["g~g"] = { name = "Goto" },
          ["g~i"] = { name = "Inside" },
          ["g~a"] = { name = "Around" },
          ["g~z"] = { name = "Z" },
          ["g~["] = { name = "Previous" },
          ["g~]"] = { name = "Next" },
          ["g'"] = { name = "Marks" },
          ["g`"] = { name = "Marks" },
          z = { name = "Z" },
          zfg = { name = "Goto" },
          zfi = { name = "Inside" },
          zfa = { name = "Around" },
          zfz = { name = "Z" },
          ["zf["] = { name = "Previous" },
          ["zf]"] = { name = "Next" },
          yg = { name = "Goto" },
          yi = { name = "Inside" },
          ya = { name = "Around" },
          yz = { name = "Z" },
          ["y["] = { name = "Previous" },
          ["y]"] = { name = "Next" },
          vg = { name = "Goto" },
          vi = { name = "Inside" },
          va = { name = "Around" },
          vz = { name = "Z" },
          ["v["] = { name = "Previous" },
          ["v]"] = { name = "Next" },
          dg = { name = "Goto" },
          di = { name = "Inside" },
          da = { name = "Around" },
          dz = { name = "Z" },
          ["d["] = { name = "Previous" },
          ["d]"] = { name = "Next" },
          cg = { name = "Goto" },
          ci = { name = "Inside" },
          ca = { name = "Around" },
          cz = { name = "Z" },
          ["c["] = { name = "Previous" },
          ["c]"] = { name = "Next" },

          ["["] = { name = "Previous" },
          ["]"] = { name = "Next" },
          ["@"] = { name = "Registers" },
          ['"'] = { name = "Registers" },
          ["'"] = { name = "Marks" },
          ["`"] = { name = "Marks" },
          ["<c-w>"] = { name = "Window" },

          ["<leader>r"] = { name = " Projects" },
          ["<leader>f"] = { name = "󰛔 Find & Replace" },
          ["<leader>o"] = { name = " Terminal" },
          ["<leader>t"] = { name = "󱏈 Tab" },
          ["<leader>to"] = { name = "Close Only" },
          ["<leader>u"] = { name = "󰨙 UI" },
          ["<leader>p"] = { name = "󰏖 Packages" },
          ["<leader>pl"] = { "<cmd>Lazy<cr>", "Lazy" },
        },
        v = {
          mode = { "v" },
          ["<leader>f"] = { name = "󰛔 Find & Replace" },
        },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults.n)
      wk.register(opts.defaults.v)

      local utils = require("lichtvim.utils")
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup(utils.title.add("Keymap"), { clear = false }),
        pattern = { "*" },
        callback = function(event)
          wk.register({
            -- d = { name = " Debugger" },
            c = { name = " ShortCuts" },
            b = { name = "󰓩 Buffers" },
            w = { name = " Window Split" },
            u = { name = "󰨙 UI" },
          }, { mode = "n", prefix = "<leader>", buffer = event.buf })
        end,
      })
    end,
  },
}
