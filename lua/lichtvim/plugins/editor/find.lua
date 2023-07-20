local utils = require("lichtvim.utils")

return {
  { "kkharji/sqlite.lua", lazy = true },
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "plenary.nvim" },
    keys = function()
      require("which-key").register({ ["<leader>r"] = { name = "󰛔 Replace" }, mode = { "n", "v" } })
      return {
        { "<leader>rr", utils.func.call(require("spectre").open), desc = "Spectre" },
        { "<leader>rw", utils.func.call(require("spectre").open_visual, { select_word = true }), desc = "Word" },
        { "<leader>rw", utils.func.call(require("spectre").open_visual), mode = "v", desc = "Word" },
        -- stylua: ignore
        { "<leader>rs", utils.func.call(require("spectre").open_file_search, { select_word = true }), desc = "Word in file" },
      }
    end,
    opts = { open_cmd = "noswapfile vnew" },
  },
  {
    "AckslD/nvim-neoclip.lua",
    lazy = true,
    dependencies = { { "sqlite.lua", module = "sqlite" } },
    opts = { enable_persistent_history = true, db_path = vim.fn.stdpath("data") .. "/telescope/neoclip.sqlite3" },
    config = function(_, opts)
      require("neoclip").setup(opts)
      require("telescope").load_extension("neoclip")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    version = false,
    dependencies = {
      { "trouble.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-file-browser.nvim" },
    },
    keys = function()
      require("which-key").register({ ["<leader>f"] = { name = " Find" }, mode = { "n", "v" } })

      local plugs = utils.plugs
      return {
        { "<leader>f<tab>", plugs.telescope("commands"), desc = "Commands" },
        { "<leader>fc", plugs.telescope("command_history"), desc = "Commands history" },
        { "<leader>fs", plugs.telescope("search_history"), desc = "Search history" },
        { "<leader>ff", plugs.telescope("files"), desc = "Files (root)" },
        { "<leader>ff", plugs.telescope("files", { cwd = false }), desc = "Files (cwd)" },
        { "<leader>fm", plugs.telescope("marks"), desc = "Marks" },
        { "<leader>fo", plugs.telescope("oldfiles"), desc = "Recently files" },
        { "<leader>fO", plugs.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recently files (cwd)" },
        { "<leader>fg", plugs.telescope("live_grep"), desc = "Grep (root)" },
        { "<leader>fG", plugs.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
        { "<leader>fw", plugs.telescope("grep_string"), mode = { "n", "v" }, desc = "Word (root)" },
        { "<leader>fW", plugs.telescope("grep_string", { cwd = false }), mode = { "n", "v" }, desc = "Word (cwd)" },
        { "<leader>fj", plugs.telescope("jumplist"), desc = "Jump list" },
        { "<leader>fr", plugs.telescope("treesitter"), desc = "Treesitter" },
        { "<leader>fp", "<cmd>Telescope neoclip a extra=star,plus,b theme=dropdown<cr>", desc = "Paster" },
        {
          "<leader>fe",
          utils.func.call(require("telescope").extensions.file_browser.file_browser, { path = vim.fn.expand("~") }),
          desc = "File Browser",
        },
      }
    end,
    opts = function(_, opts)
      local themes = require("telescope.themes")
      local actions = require("telescope.actions")
      local make_entry = require("telescope.make_entry")
      local entry_display = require("telescope.pickers.entry_display")
      local fb_actions = require("telescope").extensions.file_browser.actions
      local trouble = require("trouble.providers.telescope")

      local gen_from_commands = function()
        local displayer = entry_display.create({
          items = {
            { width = 0.9 },
            { width = 0.05 },
            { remaining = 0.05 },
          },
        })

        -- stylua: ignore
        local make_display = function(entry)
          local attrs = ""
          if entry.bang then attrs = attrs .. " !" end
          if entry.bar then attrs = attrs .. " |" end
          if entry.register then attrs = attrs .. ' "' end
          return displayer({
            { entry.name, "TelescopeResultsIdentifier" },
            attrs,
            "  " .. entry.nargs
          })
        end

        return function(entry)
          return make_entry.set_default_entry_mt({
            name = entry.name,
            bang = entry.bang,
            nargs = entry.nargs,
            --
            value = entry,
            ordinal = entry.name,
            display = make_display,
          }, opts)
        end
      end

      return {
        defaults = {
          prompt_prefix = "   ",
          selection_caret = " ",
          sorting_strategy = "ascending",
          layout_config = { horizontal = { prompt_position = "top" } },
          history = { path = vim.fn.stdpath("data") .. "/telescope/history" },
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
              ["<ESC>"] = actions.close,
              ["<C-t>"] = trouble.open_with_trouble,
            },
          },
        },
        pickers = {
          find_files = { theme = "dropdown" },
          git_files = { theme = "dropdown" },
          oldfiles = themes.get_dropdown({ previewer = false }),
          buffers = themes.get_dropdown({ previewer = false }),
          commands = { theme = "dropdown", entry_maker = gen_from_commands() },
          command_history = { theme = "dropdown" },
          search_history = { theme = "dropdown" },
          live_grep = {
            prompt_title = "Text Search",
            preview_title = "Text Preview",
            disable_coordinates = true,
            path_display = { "tail" },
          },
          grep_string = {
            preview_title = "Word Preview",
            disable_coordinates = true,
            word_match = "-w",
            path_display = { "tail" },
            only_sort_text = true,
          },
          treesitter = { theme = "ivy" },
          marks = { theme = "ivy" },
          git_commits = { theme = "ivy" },
          git_bcommits = { theme = "ivy" },
          git_branches = { theme = "ivy" },
          git_status = { theme = "ivy" },
          git_stash = { theme = "ivy" },
          lsp_references = { theme = "ivy" },
          lsp_definitions = { theme = "ivy" },
          lsp_implementations = { theme = "ivy" },
          lsp_type_definitions = { theme = "ivy" },
          lsp_incoming_calls = { theme = "ivy" },
          lsp_outgoing_calls = { theme = "ivy" },
        },
        extensions = {
          fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case" },
          file_browser = themes.get_dropdown({
            previewer = false,
            sorting_strategy = "ascending",
            layout_config = { prompt_position = "top", width = 0.4, height = 0.5 },
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
              ["n"] = {},
            },
          }),
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
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

      if require("lichtvim.utils.lazy").has("nvim-notify") then
        telescope.load_extension("notify")
        map.set(
          "n",
          "<leader>uq",
          utils.func.call(require("notify").dismiss, { silent = true, pending = true }),
          "Clear notifications"
        )
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup(require("lichtvim.utils").title.add("Keymap"), { clear = false }),
        pattern = { "*" },
        callback = function(event)
          map.set("n", "<leader>bs", utils.plugs.telescope("buffers"), "Buffers", { buffer = event.buf, silent = true })
        end,
      })
    end,
  },
}
