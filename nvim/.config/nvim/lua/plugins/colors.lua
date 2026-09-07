vim.pack.add({
	{
		src = "https://github.com/rebelot/kanagawa.nvim"
	},
})

require("kanagawa").setup({
	undercurl = true,
	transparent = false,
	commentStyle = { italic = true },
	theme = "wave",
	background = {
		dark = "wave",
	},
})
vim.cmd.colorscheme("kanagawa")
