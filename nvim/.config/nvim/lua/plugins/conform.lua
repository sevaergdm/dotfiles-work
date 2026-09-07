vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		python = { "isort", "black" },
		terraform = { "terraform_fmt" },
		sql = { "pg_format" },
	},
})

vim.keymap.set({ "n", "v" }, "<leader>gf", function()
	require("conform").format({
		lsp_format = "fallback",
		async = false,
		timeout_ms = 500,
	})
end, { desc = "format file or range (Conform)" })
