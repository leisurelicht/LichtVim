local utils = require("lichtvim.utils")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(
          opts.ensure_installed,
          { "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore" }
        )
      end
    end,
  },
  {
    "f-person/git-blame.nvim",
    event = { "BufRead", "BufNewFile" },
    init = function()
      vim.g.gitblame_enabled = 0
    end,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup(utils.title.add("Keymap"), { clear = false }),
        pattern = { "*" },
        callback = function(event)
          if vim.bo[event.buf].filetype == "neo-tree" then
            return
          end

          local opt = { buffer = event.buf, silent = true }
          if utils.git.is_repo() then
            map.set("n", "<leader>gb", "<cmd>GitBlameToggle<cr>", "Toggle line blame", opt)
          end
        end,
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufRead", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "│" },
        topdelete = { text = "│" },
        changedelete = { text = "│" },
        untracked = { text = "┆" },
      },
      signcolumn = true,
      numhl = true,
      preview_config = {
        -- Options passed to nvim_open_win
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      on_attach = function(bufnr)
        if vim.bo[bufnr].filetype == "neo-tree" then
          return
        end

        local gs = package.loaded.gitsigns
        map.set("n", "<leader>ga", gs.stage_hunk, "Add hunk", { buffer = bufnr })
        map.set("n", "<leader>gr", gs.reset_hunk, "Reset hunk", { buffer = bufnr })
        -- stylua: ignore
        map.set("v", "<leader>ga", utils.func.call(gs.stage_hunk, { vim.fn.line("."), vim.fn.line("v") }), "Add hunk", { buffer = bufnr })
        -- stylua: ignore
        map.set("v", "<leader>gr", utils.func.call(gs.reset_hunk, { vim.fn.line("."), vim.fn.line("v") }), "Reset hunk", { buffer = bufnr })
        map.set("n", "<leader>gA", gs.stage_buffer, "Add buffer", { buffer = bufnr })
        map.set("n", "<leader>gR", gs.reset_buffer, "Reset buffer", { buffer = bufnr })
        map.set("n", "<leader>gp", gs.preview_hunk, "Preview hunk", { buffer = bufnr })
        -- stylua: ignore
        map.set("n", "]g", function() if vim.wo.diff then return "]g" end vim.schedule(function() gs.next_hunk() end) return "<Ignore>" end, "Next git hunk", { buffer = bufnr, expr = true })
        -- stylua: ignore
        map.set("n", "[g", function() if vim.wo.diff then return "[g" end vim.schedule(function() gs.prev_hunk() end) return "<Ignore>" end, "Previous git hunk", { buffer = bufnr, expr = true })

        -- Text object
        map.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<cr>", "Select git hunk", { buffer = bufnr })

        map.set("n", "<leader>gc", utils.plugs.telescope("git_bcommits"), "Buffer's Commits", { buffer = bufnr })
        map.set("n", "<leader>gs", utils.plugs.telescope("git_stash"), "Stash", { buffer = bufnr })
        map.set("n", "<leader>gn", utils.plugs.telescope("git_branches"), "Branches", { buffer = bufnr })
      end,
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)

      if utils.git.is_repo() then
        require("which-key").register({ g = { name = "󰊢 Git" }, mode = { "n", "v" }, prefix = "<leader>" })

        local lazyUtils = require("lichtvim.utils.lazy")
        local opt = { border = "rounded", cmd = utils.path.get_root, esc_esc = false, ctrl_hjkl = false }
        map.set("n", "<leader>gg", utils.func.call(lazyUtils.float_term, { "lazygit" }, opt), "Lazygit")
        map.set("n", "<leader>gl", utils.func.call(lazyUtils.float_term, { "lazygit", "log" }, opt), "Lazygit log")
      end
    end,
  },
}
