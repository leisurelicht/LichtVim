local utils = require("lichtvim.utils")

return {
  { "kkharji/sqlite.lua", lazy = true },
  {
    "nvim-pack/nvim-spectre",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = function()
      require("which-key").register({ ["<leader>r"] = { name = "󰛔 Replace" }, mode = { "n", "v" } })
      return {
        { "<leader>rr", utils.func.call(require("spectre").open), desc = "Spectre" },
        { "<leader>rw", utils.func.call(require("spectre").open_visual, { select_word = true }), desc = "Word" },
        { "<leader>rw", utils.func.call(require("spectre").open_visual), mode = "v", desc = "Word" },
        {
          "<leader>frs",
          utils.func.call(require("spectre").open_file_search, { select_word = true }),
          desc = "Word in file",
        },
      }
    end,
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
    dependencies = {
      { "folke/trouble.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-frecency.nvim", dependencies = { "kkharji/sqlite.lua" } },
      { "nvim-telescope/telescope-file-browser.nvim" },
    },
    keys = function()
      require("which-key").register({ ["<leader>f"] = { name = " Find" }, mode = { "n", "v" } })
      local _keys = {
        { "<leader>f<tab>", utils.plugs.telescope("commands"), desc = "Commands" },
        { "<leader>fc", utils.plugs.telescope("command_history"), desc = "Commands history" },
        { "<leader>fs", utils.plugs.telescope("search_history"), desc = "Search history" },
        { "<leader>ff", utils.plugs.telescope("files"), desc = "Files (root dir)" },
        { "<leader>ff", utils.plugs.telescope("files", { cwd = false }), desc = "Files (cwd)" },
        { "<leader>fm", utils.plugs.telescope("marks"), desc = "Marks" },
        { "<leader>fo", utils.plugs.telescope("oldfiles"), desc = "Recently files" },
        { "<leader>fO", utils.plugs.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recently files (cwd)" },
        { "<leader>fg", utils.plugs.telescope("live_grep"), desc = "Grep (root dir)" },
        { "<leader>fG", utils.plugs.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
        { "<leader>fw", utils.plugs.telescope("grep_string"), desc = "Word (root dir)" },
        { "<leader>fW", utils.plugs.telescope("grep_string", { cwd = false }), desc = "Word (cwd)" },
        { "<leader>fj", utils.plugs.telescope("jumplist"), desc = "Jump list" },
        { "<leader>fp", "<cmd>Telescope neoclip a extra=star,plus,b theme=dropdown<cr>", desc = "Paster" },
        {
          "<leader>fe",
          utils.func.call(require("telescope").extensions.file_browser.file_browser, { path = vim.fn.expand("~") }),
          desc = "File Browser",
        },
      }

      return _keys
    end,
    opts = function(_, opts)
      local Job = require("plenary.job")
      local actions = require("telescope.actions")
      local previewers = require("telescope.previewers")
      local themes = require("telescope.themes")
      local fb_actions = require("telescope").extensions.file_browser.actions
      local trouble = require("trouble.providers.telescope")

      -- Dont preview binaries
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
        prompt = "",
        previewer = false,
      })

      opts = {
        defaults = {
          prompt_prefix = "   ",
          selection_caret = " ",
          path_display = { "truncate" },
          set_env = { ["COLORTERM"] = "truecolor" },
          buffer_previewer_maker = new_maker,
          sorting_strategy = "ascending",
          layout_config = { horizontal = { prompt_position = "top" } },
          mappings = {
            i = {
              ["<ESC>"] = actions.close,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
              ["<C-h>"] = actions.cycle_history_prev,
              ["<C-l>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-n>"] = actions.move_selection_next,
              ["<C-t>"] = trouble.open_with_trouble,
            },
            n = {
              -- ["q"] = actions.close,
              ["<ESC>"] = actions.close,
              ["<C-t>"] = trouble.open_with_trouble,
            },
          },
        },
        pickers = {
          find_files = { theme = "dropdown", find_command = { "fd", "--type", "f", "--strip-cwd-prefix" } },
          git_files = { theme = "dropdown" },
          oldfiles = center_list,
          buffers = center_list,
          marks = { theme = "dropdown" },
          commands = { theme = "dropdown" },
          command_history = { theme = "dropdown" },
          search_history = { theme = "dropdown" },
          git_commits = { theme = "ivy" },
          git_bcommits = { theme = "ivy" },
          git_branches = { theme = "ivy" },
          git_status = { theme = "ivy" },
          git_stash = { theme = "ivy" },
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

      return opts
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("frecency")
      telescope.load_extension("file_browser")

      if require("lazy.core.config").plugins["LichtVim"].dev then
        map.set("n", "<leader>fT", utils.plugs.telescope("builtin"), "Builtin")
        map.set("n", "<leader>fA", utils.plugs.telescope("autocommands"), "AutoCommands")
        map.set("n", "<leader>fM", utils.plugs.telescope("man_pages"), "Man pages")
        map.set("n", "<leader>fP", utils.plugs.telescope("vim_options"), "Vim option")
        map.set("n", "<leader>fK", utils.plugs.telescope("keymaps"), "Key maps")
        map.set("n", "<leader>fC", utils.plugs.telescope("colorscheme", { enable_preview = true }), "Colorscheme")
        map.set("n", "<leader>fH", utils.plugs.telescope("help_tags"), "Help tags")
      end
    end,
  },
}
