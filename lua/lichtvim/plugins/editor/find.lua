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

return {
  { "kkharji/sqlite.lua", lazy = true },
  { "nvim-pack/nvim-spectre", lazy = true, dependencies = { "nvim-lua/plenary.nvim" } },
  {
    "leisurelicht/telescope.nvim",
    version = false,
    lazy = true,
    cmd = "Telescope",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-frecency.nvim", dependencies = { "sqlite.lua" } },
      { "nvim-telescope/telescope-file-browser.nvim" },
      {
        "AckslD/nvim-neoclip.lua",
        lazy = true,
        dependencies = { { "sqlite.lua", module = "sqlite" } },
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
    },
    opts = function(_, opts)
      local Job = require("plenary.job")
      local actions = require("telescope.actions")
      local previewers = require("telescope.previewers")
      local themes = require("telescope.themes")
      local sorters = require("telescope.sorters")
      local fb_actions = require("telescope").extensions.file_browser.actions

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

      local center_list = themes.get_dropdown({
        winblend = 10,
        width = 0.5,
        prompt = " ",
        results_height = 15,
        previewer = false,
      })

      -- -- Settings for with preview option
      local with_preview = {
        winblend = 10,
        show_line = false,
        results_title = false,
        preview_title = false,
        layout_config = {
          preview_width = 0.5,
        },
        sorting_strategy = "ascending",
      }

      opts = {
        defaults = {
          prompt_prefix = "  ",
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
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              -- ["<C-g>"] = function(prompt_bufnr)
              --   -- Use nvim-window-picker to choose the window by dynamically attaching a function
              --   local action_set = require("telescope.actions.set")
              --   local action_state = require("telescope.actions.state")

              --   local picker = action_state.get_current_picker(prompt_bufnr)
              --   picker.get_selection_window = function(picker, entry)
              --     local picked_window_id = require("window-picker").pick_window() or vim.api.nvim_get_current_win()
              --     -- Unbind after using so next instance of the picker acts normally
              --     picker.get_selection_window = nil
              --     return picked_window_id
              --   end

              --   return action_set.edit(prompt_bufnr, "edit")
              -- end,
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
          file_browser = vim.tbl_extend("force", center_list, {
            theme = "ivy",
            -- disables netrw and use telescope-file-browser in its place
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

      if lazy.has("project.nvim") then
        telescope.load_extension("projects")
      end
      if lazy.has("nvim-notify") then
        telescope.load_extension("notify")
      end

      telescope.load_extension("file_browser")
      telescope.load_extension("neoclip")
    end,
  },
}
