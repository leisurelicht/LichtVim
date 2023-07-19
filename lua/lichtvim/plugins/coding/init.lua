return {
  { import = "lichtvim.plugins.coding.indent" },
  { import = "lichtvim.plugins.coding.git" },
  { "tpope/vim-surround", event = { "BufRead", "BufNewFile" } },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTelescope", "TodoTrouble" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ft", "<cmd>TodoTelescope theme=ivy<cr>", desc = "Todo (Telescope)" },
    },
    config = function()
      require("todo-comments").setup({})
    end,
  },
  { -- 自动配对
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { enable_check_bracket_line = false, ignored_next_char = "[%w%.]" },
  },
  {
    "andymass/vim-matchup",
    event = { "BufNewFile", "BufRead" },
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "poopup" }
      require("which-key").register({
        ["]%"] = "Jump to next matchup",
        ["[%"] = "Jump to previous matchup",
        ["g%"] = "Jump to close matchup",
        ["z%"] = "Jump inside matchup",
      }, { mode = "n" })
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufRead", "BufNewFile" },
    opts = function()
      return {
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
      }
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    opts = {
      manual_mode = false,
      detection_methods = { "pattern" },
      patterns = {
        ".git",
        "_darcs",
        ".hg",
        ".bzr",
        ".svn",
        "Makefile",
        "package.json",
        "go.mod",
        "requirements.txt",
        "pyproject.toml",
        "Cargo.toml",
      },
      ignore_lsp = { "dockerls", "null_ls", "copilot" },
      exclude_dirs = { "/", "~" },
      show_hidden = false,
      silent_chdir = false,
      scope_chdir = "tab",
      datapath = vim.fn.stdpath("data"),
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
      require("telescope").load_extension("projects")

      require("which-key").register({ mode = "n", ["<leader>n"] = { name = " Projects" } })
      map.set("n", "<leader>na", "<cmd>AddProject<cr>", "Add")
      map.set("n", "<leader>nj", function()
        local buffers = vim.api.nvim_list_bufs()
        local wins = vim.api.nvim_list_wins()
        if #wins > 1 or #buffers > 1 then
          vim.cmd([[silent wa | silent %bd | Alpha]])
        end

        vim.cmd([[Telescope projects theme=dropdown ]])
      end, "Recently")
    end,
  },
  {
    "m4xshen/smartcolumn.nvim",
    event = { "BufNewFile", "BufRead" },
    opts = {
      colorcolumn = "0",
      disabled_filetypes = {
        "help",
        "text",
        "markdown",
        "lazy",
        "mason",
        "notify",
        "alpha",
        "checkhealth",
      },
      custom_colorcolumn = {},
      scope = "file",
    },
    config = function(_, opts)
      require("smartcolumn").setup(opts)
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    keys = function()
      require("which-key").register({ mode = { "n" }, ["<leader>o"] = { name = " Terminal" } })
      return {
        { "<C-\\>", "<CMD>exe v:count1 . 'ToggleTerm'<CR>", desc = "Toggle terminal" },
        { "<leader>of", "<CMD>ToggleTerm direction=float<CR>", desc = "Toggle in float" },
        { "<leader>ot", "<CMD>ToggleTerm direction=tab<CR>", desc = "Toggle in tab" },
        { "<leader>oh", "<CMD>ToggleTerm direction=horizontal<CR>", desc = "Toggle in horizontal" },
        { "<leader>ov", "<CMD>ToggleTerm direction=vertical<CR>", desc = "Toggle in vertical" },
        { "<leader>or", "<CMD>ToggleTermSendCurrentLine<CR>", desc = "Send current line" },
        { "<leader>or", "<CMD>ToggleTermSendVisualLines<CR>", desc = "Send visual lines" },
        { "<leader>os", "<CMD>ToggleTermSendVisualSelection<CR>", desc = "Send visual selection" },
      }
    end,
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "rounded", -- 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local utils = require("lichtvim.utils")

      --- Add a terminal window
      local function smart_add_terminal()
        ---@diagnostic disable-next-line: undefined-field
        if vim.b.toggle_number == nil then
          log.warn("Need to create a terminal and move in it first", { title = " Terminal" })
          return
        end

        local direction = require("toggleterm.ui").guess_direction()

        if direction == nil then
          if vim.g._term_direction == 1 then
            direction = "vertical"
          elseif vim.g._term_direction == 2 then
            direction = "horizontal"
          elseif vim.g._term_direction == 0 then
            log.warn("Can not add a terminal window", { title = " Terminal" })
            return
          end
        end

        if direction == "vertical" then
          vim.cmd("exe b:toggle_number+1.'ToggleTerm direction=vertical'")
          vim.g._term_direction = 1
        elseif direction == "horizontal" then
          vim.cmd("exe b:toggle_number+1.'ToggleTerm direction=horizontal'")
          vim.g._term_direction = 2
        end
      end

      vim.api.nvim_create_autocmd({ "TermOpen" }, {
        group = vim.api.nvim_create_augroup(utils.title.add("TermKeymap"), { clear = true }),
        pattern = { "term://*" },
        callback = function()
          map.set("t", "<space><esc>", [[<C-\><C-n>]], "Esc", { buffer = 0 })
          map.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], "Up", { buffer = 0 })
          map.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], "Down", { buffer = 0 })
          map.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], "Left", { buffer = 0 })
          map.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], "Right", { buffer = 0 })
          map.set("t", "<C-a>", smart_add_terminal, "Add new terminal", { buffer = 0 })
        end,
      })
    end,
  },
}
