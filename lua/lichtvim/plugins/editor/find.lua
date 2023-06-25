return {
  { "kkharji/sqlite.lua", lazy = true },
  {
    "nvim-pack/nvim-spectre",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { open_cmd = "noswapfile vnew" },
  },
  {
    "AckslD/nvim-neoclip.lua",
    lazy = true,
    dependencies = { { "kkharji/sqlite.lua", module = "sqlite" } },
    opts = {
      enable_persistent_history = true,
      db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
      config = function(_, opts)
        require("neoclip").setup(opts)
        require("telescope").load_extension("neoclip")
      end,
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    version = false,
    lazy = true,
    cmd = "Telescope",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-frecency.nvim", dependencies = { "kkharji/sqlite.lua" } },
      { "nvim-telescope/telescope-file-browser.nvim" },
    },
    opts = function(_, opts)
      local Job = require("plenary.job")
      local actions = require("telescope.actions")
      local previewers = require("telescope.previewers")
      local themes = require("telescope.themes")
      local sorters = require("telescope.sorters")
      local fb_actions = require("telescope").extensions.file_browser.actions

      local new_maker = function(filepath, bufnr, options)
        filepath = vim.fn.expand(filepath)
        Job:new({
          command = "file",
          args = { "--mime-type", "-b", filepath },
          on_exit = function(j)
            local mime_type = vim.split(j:result()[1], "/")[1]
            if mime_type == "text" then
              previewers.buffer_previewer_maker(filepath, bufnr, options)
            else
              -- maybe we want to write something to the buffer here
              vim.schedule(function()
                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
              end)
            end
          end,
        }):sync()
      end

      local center_list = themes.get_dropdown({
        winblend = 0, -- 透明度
        width = 0.5,
        prompt = " ",
        results_height = 15,
        previewer = false,
      })

      opts = {
        defaults = {
          prompt_prefix = "   ",
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
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<ESC>"] = actions.close,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
              ["<C-h>"] = actions.cycle_history_prev,
              ["<C-l>"] = actions.cycle_history_next,
              -- ["<C-k>"] = actions.move_selection_previous,
              -- ["<C-j>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-n>"] = actions.move_selection_next,
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
          -- buffers = vim.deepcopy(center_list),
          buffers = { theme = "dropdown" },
          marks = { theme = "dropdown" },
          commands = { theme = "ivy" },
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
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          frecency = {
            db_root = vim.fn.stdpath("data") .. "/databases",
            show_scores = true,
          },
          file_browser = vim.tbl_extend("force", center_list, {
            hijack_netrw = true,
            sorting_strategy = "ascending",
            layout_config = {
              -- preview_cutoff = 0.5,
              prompt_position = "top",
              width = 0.4,
              height = 0.5,
            },
            mappings = {
              ["i"] = {
                ["<A-y>"] = false,
                ["<A-m>"] = false,
                ["<A-c>"] = false,
                ["<A-r>"] = false,
                ["<A-d>"] = false,
                ["<A-q>"] = false,
                ["<C-Q>"] = false,
                ["<C-G>"] = false,
                ["<C-f>"] = fb_actions.goto_parent_dir,
                ["<C-r>"] = fb_actions.rename,
                ["<C-a>"] = fb_actions.create,
                ["<C-y>"] = fb_actions.copy,
                ["<C-d>"] = fb_actions.remove,
              },
              ["n"] = {
                -- your custom normal mode mappings
              },
            },
          }),
        },
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
      telescope.load_extension("frecency")
      telescope.load_extension("file_browser")

      if lazy.has("project.nvim") then
        telescope.load_extension("projects")
      end
      if lazy.has("nvim-notify") then
        telescope.load_extension("notify")
      end

      if lazy.has("scope.nvim") then
        telescope.load_extension("scope")
      end
    end,
  },
}
