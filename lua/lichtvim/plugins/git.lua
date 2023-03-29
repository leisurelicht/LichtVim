local function git_key(gs, bufnr)
  map.set("n", "<leader>gB", "<CMD>GitBlameToggle<CR>", "Toggle Line Blame")
  map.set("n", "<leader>go", "<CMD>GitBlameOpenCommitURL<CR>", "Open Commit URL")

  map.set({ "n", "v" }, "<leader>ga", ":Gitsigns stage_hunk<CR>", "Add Hunk", { buffer = bufnr })
  map.set("n", "<leader>gA", gs.stage_buffer, "Add Buffer", { buffer = bufnr })
  map.set({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk", { buffer = bufnr })
  map.set("n", "<leader>gR", gs.reset_buffer, "Reset Buffer", { buffer = bufnr })
  map.set("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk", { buffer = bufnr })
  map.set("n", "<leader>gw", gs.preview_hunk, "Preview Hunk", { buffer = bufnr })
  map.set("n", "<leader>gb", function()
    gs.blame_line({ full = true })
  end, "Show Blame Line", { buffer = bufnr })
  map.set("n", "<leader>gd", gs.diffthis, "Diff This", { buffer = bufnr })
  map.set("n", "<leader>gD", function()
    gs.diffthis("~")
  end, "Diff This?", { buffer = bufnr })
  map.set("n", "<leader>gt", gs.toggle_deleted, "Toggle Deleted", { buffer = bufnr })

  map.set("n", "]g", function()
    if vim.wo.diff then
      return "gn"
    end
    vim.schedule(function()
      gs.next_hunk()
    end)
    return "<Ignore>"
  end, "Next Git Hunk", { buffer = bufnr, expr = true })

  map.set("n", "[g", function()
    if vim.wo.diff then
      return "gp"
    end
    vim.schedule(function()
      gs.prev_hunk()
    end)
    return "<Ignore>"
  end, "Previous Git Hunk", { buffer = bufnr, expr = true })

  -- Text object
  map.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
end

return {
  {
    "f-person/git-blame.nvim",
    event = { "BufRead", "BufNewFile" },
    init = function()
      vim.g.gitblame_enabled = 0
    end,
    config = function() end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufRead", "BufNewFile" },
    dependencies = { "f-person/git-blame.nvim" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = {
            hl = "GitSignsAdd",
            text = "+",
            numhl = "GitSignsAddNr",
            linehl = "GitSignsAddLn",
          },
          change = {
            hl = "GitSignsChange",
            text = "!",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
          },
          delete = {
            hl = "GitSignsDelete",
            text = "-",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn",
          },
          changedelete = {
            hl = "GitSignsChange",
            text = "~",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
          },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          git_key(gs, bufnr)
        end,
      })
    end,
  },
}
