local function is_whitespace(line)
  return vim.fn.match(line, [[^\s*$]]) ~= -1
end

local function all(tbl, check)
  for _, entry in ipairs(tbl) do
    if not check(entry) then
      return false
    end
  end
  return true
end

local function ts_b(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", {
      cwd = require("lichtvim.utils").path.get_root(),
    }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    require("telescope.builtin")[builtin](opts)
  end
end

return {
  { "kkharji/sqlite.lua", lazy = true },
  {
    "AckslD/nvim-neoclip.lua",
    lazy = true,
    dependencies = {
      { "kkharji/sqlite.lua", module = "sqlite" },
    },
    opts = {
      history = 1000,
      enable_persistent_history = true,
      continuous_sync = true,
      db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
      filter = function(data)
        return not all(data.event.regcontents, is_whitespace)
      end,
      keys = {
        telescope = {
          i = {
            select = "<cr>",
            paste = "<a-p>",
            past_behind = "<a-o>",
            replay = "<nop>",
            delete = "<c-d>",
            custom = {},
          },
          n = {
            select = "<cr>",
            paste = "p",
            paste_behind = "P",
            replay = "<nop>",
            delete = "dd",
            custom = {},
          },
        },
      },
    },
  },
  {
    "ahmedkhalf/project.nvim",
    enabled = true,
    cmd = "Telescope",
    opts = {
      manual_mode = true,
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
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    -- dir = "~/Code/neovim/plugins/telescope.nvim",
    version = false,
    lazy = true,
    cmd = "Telescope",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-frecency.nvim", dependencies = { "kkharji/sqlite.lua" } },
      { "project.nvim" },
      { "nvim-telescope/telescope-file-browser.nvim" },
      {
        "folke/todo-comments.nvim",
        lazy = true,
        cmd = { "TodoTelescope" },
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
          require("todo-comments").setup({})
        end,
      },
    },
    keys = {
      { "<leader>fT", ts_b("builtin"), desc = "Built In" },
      { "<leader>f<tab>", ts_b("commands"), desc = "Commands" },
      { "<leader>fc", ts_b("command_history"), desc = "History Command" },
      { "<leader>fs", ts_b("search_history"), desc = "History Search" },
      { "<leader>fA", ts_b("autocommands"), desc = "AutoCommand" },
      { "<leader>ff", ts_b("files"), desc = "Files(root dir)" },
      { "<leader>ff", ts_b("files", { cwd = false }), desc = "Files(cwd)" },
      { "<leader>fH", ts_b("help_tags"), desc = "Help Tags" },
      { "<leader>fm", ts_b("marks"), desc = "Marks" },
      { "<leader>fM", ts_b("man_pages"), desc = "Man Pages" },
      { "<leader>fo", ts_b("oldfiles"), desc = "Recently Opened File" },
      { "<leader>fO", ts_b("vim_options"), desc = "Vim Option" },
      { "<leader>fg", ts_b("live_grep"), desc = "Grep(root dir)" },
      { "<leader>fG", ts_b("live_grep", { cwd = false }), desc = "Grep(cwd)" },
      { "<leader>fw", ts_b("grep_string"), desc = "Word(root dir)" },
      { "<leader>fW", ts_b("grep_string", { cwd = false }), desc = "Word(cwd)" },
      { "<leader>fk", ts_b("keymaps"), desc = "Key Maps" },
      { "<leader>fb", ts_b("buffers"), desc = "Buffers" },
      { "<leader>fJ", ts_b("jumplist"), desc = "Jump List" },
      {
        "<leader>fC",
        ts_b("colorscheme", { enable_preview = true }),
        desc = "Colorscheme",
      },
      { "<leader>gC", ts_b("git_bcommits"), desc = "Buffer's Commits" },
      { "<leader>gc", ts_b("git_commits"), desc = "Commits" },
      { "<leader>gS", ts_b("git_stash"), desc = "Stash" },
      { "<leader>gn", ts_b("git_branches"), desc = "Branches" },
      { "<leader>gs", ts_b("git_status"), desc = "Status" },
      {
        "<leader>fj",
        "<cmd>Telescope projects theme=dropdown<cr>",
        desc = "Projects",
      },
      {
        "<leader>fp",
        "<cmd>Telescope neoclip a extra=star,plus,b theme=dropdown<cr>",
        desc = "Paster",
      },
      { "<leader>ft", "<cmd>TodoTelescope keywords=TODO,FIX,HACK,PERF theme=dropdown<cr>", desc = "Todo" },
      {
        "<leader>fe",
        function()
          require("telescope").extensions.file_browser.file_browser({
            sorting_strategy = "ascending",
            layout_config = {
              -- preview_cutoff = 0.5,
              prompt_position = "top",
            },
          })
        end,
        desc = "File Browser",
      },
    },
    opts = function(_, opts)
      local Job = require("plenary.job")
      local actions = require("telescope.actions")
      local previewers = require("telescope.previewers")
      -- local themes = require("telescope.themes")
      local sorters = require("telescope.sorters")

      local new_maker = function(filepath, bufnr, opts)
        filepath = vim.fn.expand(filepath)
        Job:new({
          command = "file",
          args = { "--mime-type", "-b", filepath },
          on_exit = function(j)
            local mime_type = vim.split(j:result()[1], "/")[1]
            if mime_type == "text" then
              previewers.buffer_previewer_maker(filepath, bufnr, opts)
            else
              -- maybe we want to write something to the buffer here
              vim.schedule(function()
                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
              end)
            end
          end,
        }):sync()
      end

      -- local no_preview = themes.get_dropdown({
      --   borderchars = {
      --     { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      --     prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
      --     results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
      --     preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      --   },
      --   width = 0.8, previewer = false, prompt_title = false,
      -- })

      -- local center_list = themes.get_dropdown({
      --   winblend = 10,
      --   width = 0.5,
      --   prompt = " ",
      --   results_height = 15,
      --   previewer = false,
      -- })

      -- -- Settings for with preview option
      -- local with_preview = {
      --   winblend = 10,
      --   show_line = false,
      --   results_title = false,
      --   preview_title = false,
      --   layout_config = {
      --     preview_width = 0.5,
      --   },
      --   sorting_strategy = "ascending",
      -- }

      opts = {
        defaults = {
          prompt_prefix = "🔍 ",
          selection_caret = " ",
          file_sorter = sorters.get_fuzzy_file,
          generic_sorter = sorters.get_generic_fuzzy_sorter,
          path_display = { "truncate" },
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          use_less = true,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          file_previewer = previewers.vim_buffer_cat.new,
          grep_previewer = previewers.vim_buffer_vimgrep.new,
          qflist_previewer = previewers.vim_buffer_qflist.new,
          buffer_previewer_maker = new_maker, -- Dont preview binaries
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim", -- add this value
          },
          layout_config = {
            height = 0.7,
            width = 0.6,
          },
          mappings = {
            i = {
              ["<ESC>"] = actions.close,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
            n = {
              ["q"] = actions.close,
              ["<ESC>"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = { theme = "dropdown", find_command = { "fd", "--type", "f", "--strip-cwd-prefix" } },
          git_files = { theme = "dropdown" },
          oldfiles = { theme = "dropdown" },
          buffers = { theme = "dropdown" },
          marks = { theme = "dropdown" },
          commands = { theme = "dropdown" },
          command_history = { theme = "dropdown" },
          search_history = { theme = "dropdown" },
          git_commits = { theme = "ivy" },
          git_bcommits = { theme = "ivy" },
          git_branches = { theme = "ivy" },
          git_status = { theme = "ivy" },
          git_stash = { theme = "ivy" },
          lsp_definitions = {},
          lsp_type_definitions = {},
          lsp_implementations = {},
          lsp_references = {},
          diagnostics = {},
          lsp_document_symbols = {},
          lsp_workspace_symbols = {},
          lsp_incoming_calls = {},
          lsp_outgoing_calls = {},
        },
        extensions = {},
      }

      if lazy.has("trouble.nvim") then
        local trouble = require("trouble.providers.telescope")
        opts.defaults.mappings.n =
          vim.tbl_deep_extend("force", opts.defaults.mappings.n, { ["<C-q>"] = trouble.open_with_trouble })
        opts.defaults.mappings.i =
          vim.tbl_extend("force", opts.defaults.mappings.i, { ["<C-q>"] = trouble.open_with_trouble })
      end

      return opts
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      telescope.load_extension("fzf")
      telescope.load_extension("neoclip")
      telescope.load_extension("projects")
      telescope.load_extension("frecency")
      telescope.load_extension("file_browser")

      if lazy.has("noice.nvim") then
        telescope.load_extension("noice")
        map.set("n", "<leader>fN", "<cmd>Telescope noice theme=dropdown<cr>", "Noice")
      end

      if lazy.has("nvim-notify") then
        telescope.load_extension("notify")
        map.set("n", "<leader>fn", "<cmd>Telescope notify theme=dropdown<cr>", "Notify")
      end
    end,
  },
}
