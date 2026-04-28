--- options
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.clipboard = "unnamedplus" --- 與系統共享clipboard
vim.opt.tabstop = 4 -- 1 個 Tab 等於 4 個空白的寬度
vim.opt.shiftwidth = 4 -- 每一級縮排（按 >> 或 << 時）的寬度
vim.opt.softtabstop = 4 -- 編輯時按退格鍵，一次刪除 4 個空白
vim.opt.expandtab = true -- 把 Tab 自動轉換成空白鍵
--- absolute line
vim.opt.number = true
--- relative line
vim.opt.relativenumber = true

vim.pack.add({
	{ src = "https://github.com/ellisonleao/gruvbox.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
	{ src = "https://github.com/Saghen/blink.cmp" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/sphamba/smear-cursor.nvim" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

--- colorscheme
vim.cmd.colorscheme("gruvbox")

--- lsp
vim.lsp.enable("lua_ls") --- need to download lua-language-server
vim.lsp.enable("clangd") --- need to download clang
--- dianostic
vim.opt.updatetime = 1000
require("tiny-inline-diagnostic").setup()
vim.diagnostic.config({ virtual_text = false })

--- cmp
require("blink.cmp").setup({
	keymap = { preset = "enter" },
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = { documentation = { auto_show = false } },
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
})
--- format
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" }, --- need to download stylua
		python = { "isort", "black" }, --- need to download python-isort python-black
		rust = { "rustfmt", lsp_format = "fallback" },
		c = { "clang-format" },
		cpp = { "clang-format" },
	},
})

require("conform").setup({
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

--- cursor
require("smear_cursor").setup({
	smear_between_buffers = true,
	smear_between_neighbor_lines = true,
	scroll_buffer_space = true,
	legacy_computing_symbols_support = false,
	smear_insert_mode = true,
})

--- auto pair
require("nvim-autopairs").setup({})

--- telescope

--- nvim-treesitter
require("nvim-treesitter").setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

require("nvim-treesitter").install({ "lua", "c", "cpp", "rust", "javascript", "zig" })

-- 对所有常见文件类型自动启用 treesitter
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

--- neo-tree
require("neo-tree").setup({
	close_if_last_window = true,
	filesystem = {
		follow_current_file = {
			enabled = true,
		},
		hijack_netrw_behavior = "open_default",
	},
	window = {
		position = "left",
		width = 30,
	},
})

---keymaps
vim.keymap.set("n", ";", ":")
vim.keymap.set("c", "'", "wq<enter>")

vim.keymap.set("n", "J", "5j")
vim.keymap.set("n", "K", "5k")
vim.keymap.set("n", "L", "2e")
vim.keymap.set("n", "H", "2b")

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })

vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })
vim.keymap.set("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "Delete other buffers" })

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Goto references" })
vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "Goto implementation" })
vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { desc = "Goto type definition" })
vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, { desc = "Hover documentation" })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })

vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Search current word" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search keymaps" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Resume last search" })

vim.keymap.set("n", "<leader>e", ":Neotree toggle left filesystem<CR>", { desc = "Toggle file explorer" })
