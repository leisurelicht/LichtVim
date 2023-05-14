return {
  {
    "tzachar/cmp-tabnine",
    build = "./install.sh",
    opts = {
      max_lines = 1000,
      max_num_results = 5,
      sort = true,
      run_on_every_keystroke = true,
      snippet_placeholder = "..",
      ignored_file_types = {
        TelescopePrompt = true,
        NvimTree = true,
        ["neo-tree"] = true,
        ["neo-tree-popup"] = true,
        toggleterm = true,
      },
      show_prediction_strength = false,
    },
    config = function(_, opts)
      require("cmp_tabnine.config"):setup(opts)

      api.autocmd("BufRead", {
        group = api.augroup("prefetch", { clear = true }),
        pattern = { "*.py", "*.go", "*.lua", "*.sh" },
        callback = function()
          require("cmp_tabnine"):prefetch(vim.fn.expand("%:p"))
        end,
      })
    end,
  },
  {
    "nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sources, 1, { name = "cmp_tabnine", group_index = 1 })
      table.insert(opts.sorting.comparators, 1, require("cmp_tabnine.compare"))
    end,
  },
}
