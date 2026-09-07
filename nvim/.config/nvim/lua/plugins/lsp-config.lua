vim.pack.add({
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{
		src = "https://github.com/Saghen/blink.cmp",
		version = vim.version.range("1"),
	},
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
})

require("mason").setup()
require("blink.cmp").setup({
	keymap = {
		preset = "default",
		["<Tab>"] = { "snippet_forward", "select_and_accept", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 250 },
		trigger = { prefetch_on_insert = false },
		menu = {
			draw = {
				components = {
					label_description = {
						width = { max = 50 },
						text = function(ctx)
							-- gopls puts the import path of an unimported package in
							-- item.detail, which blink otherwise ignores
							if ctx.label_description ~= "" then return ctx.label_description end
							return ctx.item.detail or ""
						end,
						highlight = "BlinkCmpLabelDescription",
					},
				},
			},
		},
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	signature = { enabled = true },
})

vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local opts = { buffer = event.buf }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
	end,
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

vim.lsp.config("gopls", {
	settings = {
		gopls = {
			staticcheck = false,
		},
	},
})

vim.lsp.config("terraformls", {
	setings = {
		terraformls = {
			formatting = {
				timeout_ms = 5000,
			},
		},
	},
})

require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"bashls",
		"clangd",
		"dockerls",
		"gopls",
		"jsonls",
		"pyright",
		"vimls",
		"terraformls",
		"tflint",
		"sqls",
	},
	automatic_enable = true,
})
