vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-ui-select.nvim",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
})

-- build fzf-native if available
if vim.fn.executable("make") == 1 then
	local path = vim.fn.stdpath("data")
	.. "/site/pack/core/start/telescope-fzf-native.nvim"

	if vim.uv.fs_stat(path) then
		vim.system({ "make" }, { cwd = path }):wait()
	end
end

local telescope = require("telescope")
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)


telescope.setup({
	defaults = {
		sorting_strategy = "ascending",
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
			"--no-ignore-vcs",
		},
	},
	extensions = {
		fzf = {},
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
	},
})

pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "ui-select")
