return {
  { "tpope/vim-surround", event = { "BufRead", "BufNewFile" } },
  { "p00f/nvim-ts-rainbow", event = { "BufRead", "BufNewFile" } },
  { -- 自动配对
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { enable_check_bracket_line = false, ignored_next_char = "[%w%.]" },
  },
  {
    "folke/todo-comments.nvim",
    lazy = true,
    cmd = { "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>ft", "<CMD>TodoTelescope keywords=TODO,FIXME,HACK,PERF theme=dropdown<CR>", desc = "Todo" },
    },
    config = function()
      require("todo-comments").setup({})
    end,
  },
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
  { -- 缩进标识线
    "lukas-reineke/indent-blankline.nvim",
    enabled = true,
    event = { "BufNewFile", "BufRead" },
    opts = {
      show_current_context = false,
      show_current_context_start = false,
      filetype_exclude = {
        "log",
        "help",
        "lazy",
        "mason",
        "alpha",
        "neo-tree",
        "NvimTree",
        "Trouble",
        "terminal",
        "markdown",
        "dashboard",
        "toggleterm",
        "TelescopePrompt",
      },
    },
  },
  { "vim-scripts/indentpython.vim", enabled = false, ft = { "python", "djangohtml" } },
  {
    "echasnovski/mini.indentscope",
    enabled = true,
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "log",
          "help",
          "lazy",
          "mason",
          "alpha",
          "neo-tree",
          "NvimTree",
          "Trouble",
          "terminal",
          "markdown",
          "dashboard",
          "toggleterm",
          "TelescopePrompt",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
    config = function(_, opts)
      require("mini.indentscope").setup(opts)
      if lazy.has("which-key.nvim") then
        require("which-key").register({
          ["]i"] = "Goto indent scope bottom",
          ["[i"] = "Goto indent scope top",
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
  { -- better text-objects
    "echasnovski/mini.ai",
    enabled = false,
    event = "VeryLazy",
    dependencies = { "nvim-treesitter-textobjects" },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      -- register all text objects with which-key
      if lazy.has("which-key.nvim") then
        ---@type table<string, string|table>
        local i = {
          [" "] = "Whitespace",
          ['"'] = 'Balanced "',
          ["'"] = "Balanced '",
          ["`"] = "Balanced `",
          ["("] = "Balanced (",
          [")"] = "Balanced ) including white-space",
          [">"] = "Balanced > including white-space",
          ["<lt>"] = "Balanced <",
          ["]"] = "Balanced ] including white-space",
          ["["] = "Balanced [",
          ["}"] = "Balanced } including white-space",
          ["{"] = "Balanced {",
          ["?"] = "User Prompt",
          _ = "Underscore",
          a = "Argument",
          b = "Balanced ), ], }",
          c = "Class",
          f = "Function",
          o = "Block, conditional, loop",
          q = "Quote `, \", '",
          t = "Tag",
        }
        local a = vim.deepcopy(i)
        for k, v in pairs(a) do
          a[k] = v:gsub(" including.*", "")
        end

        local ic = vim.deepcopy(i)
        local ac = vim.deepcopy(a)
        for key, name in pairs({ n = "Next", l = "Last" }) do
          i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
          a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
        end

        if lazy.has("which-key.nvim") then
          require("which-key").register({
            mode = { "o", "x" },
            i = i,
            a = a,
          })
        end
      end
    end,
  },
}
