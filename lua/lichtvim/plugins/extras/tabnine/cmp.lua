---@diagnostic disable: undefined-field, undefined-doc-name
return {
  {
    "nvim-cmp",
    dependencies = {
      {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
        config = function()
          require("cmp_tabnine.config"):setup({
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
          })

          api.autocmd("BufRead", {
            group = api.augroup("prefetch", { clear = true }),
            pattern = { "*.py", "*.go", "*.lua", "*.sh" },
            callback = function()
              require("cmp_tabnine"):prefetch(vim.fn.expand("%:p"))
            end,
          })
        end,
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, 1, { name = "cmp_tabnine", group_index = 1 })
      table.insert(opts.sorting.comparators, 5, require("cmp_tabnine.compare"))
    end,
  },
}
