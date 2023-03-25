local function is_whitespace(line) return vim.fn.match(line, [[^\s*$]]) ~= -1 end

local function all(tbl, check)
  for _, entry in ipairs(tbl) do if not check(entry) then return false end end
  return true
end

function ts_b(builtin, opts)
  local params = {builtin = builtin, opts = opts}
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", {
      cwd = require("lichtvim.utils").path.get_root()
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
  {"tami5/sqlite.lua"},
  {
    "folke/todo-comments.nvim",
    cmd = {"TodoTrouble", "TodoTelescope"},
    event = {"BufReadPost", "BufNewFile"},
    keys = {
      {
        "]t",
        function() require("todo-comments").jump_next() end,
        desc = "Next todo comment"
      },
      {
        "[t",
        function() require("todo-comments").jump_prev() end,
        desc = "Previous todo comment"
      },
      {"<leader>ut", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)"},
      {
        "<leader>uT",
        "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",
        desc = "Todo/Fix/Fixme (Trouble)"
      },
      {"<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Todo"}
    }
  },
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = "tami5/sqlite.lua",
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
            custom = {}
          },
          n = {
            select = "<cr>",
            paste = "p",
            paste_behind = "P",
            replay = "<nop>",
            delete = "dd",
            custom = {}
          }
        }
      }
    }
  },
  {
    "ahmedkhalf/project.nvim",
    opts = {
      manual_mode = false,
      detection_methods = {"lsp", "pattern"},
      patterns = {
        ".git",
        "_darcs",
        ".hg",
        ".bzr",
        ".svn",
        "Makefile",
        "package.json"
      },
      ignore_lsp = {"dockerls"},
      exclude_dirs = {},
      show_hidden = true,
      silent_chdir = false,
      datapath = vim.fn.stdpath("data")
    },
    config = function(_, opts) require("project_nvim").setup(opts) end
  },
  {
    "nvim-telescope/telescope.nvim",
    version = false,
    cmd = "Telescope",
    dependencies = {
      {"nvim-telescope/telescope-fzf-native.nvim", build = "make"},
      {"nvim-telescope/telescope-ui-select.nvim"},
      {"nvim-telescope/telescope-frecency.nvim"}
    },
    keys = {
      {"<leader>fT", ts_b("builtin"), desc = "Built In"},
      {"<leader>fb", ts_b("buffers"), desc = "Buffers"},
      {"<leader>f<tab>", ts_b("commands"), desc = "Commands"},
      {"<leader>fc", ts_b("command_history"), desc = "History Command"},
      {"<leader>fs", ts_b("search_history"), desc = "History Search"},
      {"<leader>fA", ts_b("autocommands"), desc = "AutoCommand"},
      {"<leader>ff", ts_b("files"), desc = "Files(root dir)"},
      {"<leader>ff", ts_b("files", {cwd = false}), desc = "Files(cwd)"},
      {"<leader>fH", ts_b("help_tags"), desc = "Help Tags"},
      {"<leader>fm", ts_b("marks"), desc = "Marks"},
      {"<leader>fM", ts_b("man_pages"), desc = "Man Pages"},
      {"<leader>fo", ts_b("oldfiles"), desc = "Recently Opened File"},
      {"<leader>fO", ts_b("vim_options"), desc = "Vim Option"},
      {"<leader>fg", ts_b("live_grep"), desc = "Grep(root dir)"},
      {"<leader>fG", ts_b("live_grep", {cwd = false}), desc = "Grep(cwd)"},
      {"<leader>fw", ts_b("grep_string"), desc = "Word(root dir)"},
      {"<leader>fW", ts_b("grep_string", {cwd = false}), desc = "Word(cwd)"},
      {"<leader>fk", ts_b("keymaps"), desc = "Key Maps"},
      {
        "<leader>fC",
        ts_b("colorscheme", {enable_preview = true}),
        desc = "Colorscheme"
      },

      {"<leader>gC", ts_b("git_bcommits"), desc = "Buffer's Commits"},
      {"<leader>gc", ts_b("git_commits"), desc = "Commits"},
      {"<leader>gS", ts_b("git_stash"), desc = "Stash"},
      {"<leader>gn", ts_b("git_branches"), desc = "Branches"},
      {"<leader>gs", ts_b("git_status"), desc = "Status"},

      {
        "<leader>fn",
        "<CMD>Telescope notify theme=dropdown<CR>",
        desc = "Notify"
      },
      {
        "<leader>fj",
        "<CMD>Telescope projects theme=dropdown<CR>",
        desc = "Projects"
      },
      {
        "<leader>fp",
        "<CMD>Telescope neoclip a extra=star,plus,b theme=dropdown<CR>",
        desc = "Paster"
      }
    },
    config = function()
      local Job = require("plenary.job")
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local previewers = require("telescope.previewers")
      local themes = require("telescope.themes")
      local sorters = require("telescope.sorters")
      local trouble = require("trouble.providers.telescope")

      local new_maker = function(filepath, bufnr, opts)
        filepath = vim.fn.expand(filepath)
        Job:new({
          command = "file",
          args = {"--mime-type", "-b", filepath},
          on_exit = function(j)
            local mime_type = vim.split(j:result()[1], "/")[1]
            if mime_type == "text" then
              previewers.buffer_previewer_maker(filepath, bufnr, opts)
            else
              -- maybe we want to write something to the buffer here
              vim.schedule(function()
                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {"BINARY"})
              end)
            end
          end
        }):sync()
      end

      local function no_preview()
        return themes.get_dropdown({
          borderchars = {
            {"─", "│", "─", "│", "┌", "┐", "┘", "└"},
            prompt = {"─", "│", " ", "│", "┌", "┐", "│", "│"},
            results = {"─", "│", "─", "│", "├", "┤", "┘", "└"},
            preview = {"─", "│", "─", "│", "┌", "┐", "┘", "└"}
          },
          width = 0.8,
          previewer = false,
          prompt_title = false
        })
      end

      telescope.setup({
        defaults = {
          prompt_prefix = "🔍 ",
          selection_caret = " ",
          file_sorter = sorters.get_fuzzy_file,
          generic_sorter = sorters.get_generic_fuzzy_sorter,
          path_display = {"truncate"},
          winblend = 0,
          border = {},
          borderchars = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
          use_less = true,
          set_env = {["COLORTERM"] = "truecolor"}, -- default = nil,
          file_previewer = previewers.vim_buffer_cat.new,
          grep_previewer = previewers.vim_buffer_vimgrep.new,
          qflist_previewer = previewers.vim_buffer_qflist.new,
          buffer_previewer_maker = new_maker, -- Dont preview binaries
          mappings = {
            i = {
              ["<C-t>"] = trouble.open_with_trouble,
              ["<A-t>"] = trouble.open_selected_with_trouble,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
              ["<ESC>"] = actions.close
            },
            n = {["<ESC>"] = actions.close}
          }
        },
        pickers = {
          find_files = {theme = "dropdown"},
          git_files = {theme = "dropdown"},
          oldfiles = {theme = "dropdown"},
          buffers = {theme = "dropdown"},
          marks = {theme = "dropdown"},
          commands = {theme = "dropdown"},
          command_history = {theme = "dropdown"},
          search_history = {theme = "dropdown"},
          git_commits = {theme = "ivy"},
          git_bcommits = {theme = "ivy"},
          git_branches = {theme = "ivy"},
          git_status = {theme = "ivy"},
          git_stash = {theme = "ivy"}
        },
        extensions = {["ui-select"] = {no_preview()}}
      })

      telescope.load_extension("fzf")
      telescope.load_extension("notify")
      telescope.load_extension("neoclip")
      telescope.load_extension("ui-select")
      telescope.load_extension("projects")
      telescope.load_extension("frecency")
    end
  }

}
