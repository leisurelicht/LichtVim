local utils = require("lichtvim.utils")

return {
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
      current_line_blame_opts = {
        virt_text_pos = "right_align",
        delay = 0,
      },
      preview_config = {
        -- Options passed to nvim_open_win
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      on_attach = function(bufnr)
        if utils.unset_keybind_buf(vim.bo[bufnr].filetype) then
          return
        end

        if not utils.git.is_repo() then
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
        map.set("n", "<leader>gb", gs.toggle_current_line_blame, "Toggle line blame", { buffer = bufnr })
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
    end,
  },
}
