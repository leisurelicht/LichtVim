-- local wk = require("which-key")
local util = require("lspconfig.util")

return {
	settings = {
		document_diagnostics = true,
		document_formatting = true,
		formatting_on_save = false,
	},
	-- attach = function(_, bufnr)
		-- wk.register({
		-- 	y = {
		-- 		name = "+Golang",
		-- 		a = { "<cmd>GoCodeAction<cr>", "Action" },
		-- 		t = {
		-- 			name = "+Tag",
		-- 			a = { "<cmd>GoAddTag<cr>", "Add Tag" },
		-- 			r = { "<cmd>GoRmTag<cr>", "Rm Tag" },
		-- 			c = { "<cmd>GoClearTag<cr>", "Clear Tag" },
		-- 		},
		-- 		c = { "<cmd>GoCmt<cr>", "Add Comment" },
		-- 		f = { "<cmd>GoFmt<cr>", "Format" },
		--
		-- 		m = { "<cmd>GoModTidy<cr>", "Go Mod Tidy" },
		-- 	},
		-- }, { prefix = "<leader>", buffer = bufnr })
	-- end,
	options = {
		cmd = { "gopls" },
		single_file_support = true,
		filetypes = { "go", "gomod", "gotmpl" },
		root_dir = function(fname)
			return util.root_pattern("go.work")(fname) or util.root_pattern("go.mod", ".git")(fname)
		end,
	},
}
