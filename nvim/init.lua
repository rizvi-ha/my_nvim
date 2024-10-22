
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
	{
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
	},
	
	{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate", highlight = {enable = true },
	indent = {enable = true}, },
	
	{"nvim-lua/plenary.nvim",},

	{"nvim-tree/nvim-web-devicons",},

	{"MunifTanjim/nui.nvim",},

	{
	    "nvim-neo-tree/neo-tree.nvim",
	    branch = "v3.x",
	    dependencies = {
	      "nvim-lua/plenary.nvim",
	      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
	      "MunifTanjim/nui.nvim",
	      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
       }},

       {'akinsho/toggleterm.nvim', version = "*", opts={shade_terminals = true,
	winbar = {
		enabled = false,
		name_formatter = function(term) return term.name end}, 
	size=10}},

	{ "EdenEast/nightfox.nvim" },

	{
	    "lukas-reineke/indent-blankline.nvim",
	    main = "ibl",
	    opts = {},
	},

	{ 'neovim/nvim-lspconfig' }, -- LSP configurations
	{ 'williamboman/mason.nvim', build = ':MasonUpdate' }, -- Manage LSP servers
	{ 'williamboman/mason-lspconfig.nvim' }, -- LSP configuration for Mason
    	{ 'hrsh7th/cmp-nvim-lsp' }, -- LSP completion source for nvim-cmp
    	{ 'hrsh7th/nvim-cmp' }, -- Completion plugin

	{
	  "akinsho/bufferline.nvim",
	  event = "VeryLazy",
	  keys = {
	    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
	    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
	    { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
	    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
	    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
	    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
	    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
	    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
	    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
	    { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
	    { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
	  },
	  opts = {
	    options = {
	      diagnostics = "nvim_lsp",
	      always_show_bufferline = false,
	      offsets = {
		{
		  filetype = "neo-tree",
		  text = "Neo-tree",
		  highlight = "Directory",
		  text_align = "left",
		},
	      },
	    },
	  },
	  config = function(_, opts)
	    require("bufferline").setup(opts)
	    -- Fix bufferline when restoring a session
	    vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
	      callback = function()
		vim.schedule(function()
		  pcall(nvim_bufferline)
		end)
	      end,
	    })
	  end,
	},

	{
		"chrisgrieser/nvim-origami",
		event = "VeryLazy",
		opts = {}, -- needed even when using default config
	},
	{
		"https://github.com/nvim-telescope/telescope.nvim",
		lazy = false,
		init = function()
			vim.keymap.set("n", "<Leader>ff", "<Cmd>Telescope find_files<CR>", { desc = "find file" })
			vim.keymap.set("n", "<Leader>fr", "<Cmd>Recent<CR>", { desc = "find frecent file" })
			vim.keymap.set("n", "<Leader>fo", "<Cmd>Telescope oldfiles<CR>", { desc = "find recent file" })
			vim.keymap.set("n", "<Leader>,", "<Cmd>Telescope buffers<CR>", { desc = "switch to buffer" })
			vim.keymap.set("n", [[<Leader>']], "<Cmd>Telescope resume<CR>", { desc = "resume previous search" })
			vim.keymap.set("n", [[<Leader>sp]], "<Cmd>Telescope live_grep_args<CR>", { desc = "ripgrep" })
			vim.keymap.set("n", "<Leader>gg", "<Cmd>0Git<CR>", { desc = "fugitive" })
			vim.keymap.set("n", "<Leader>hh", "<Cmd>Telescope help_tags<CR>", { desc = "help" })
		end,
		config = function()
			local actions = require("telescope.actions")
			local lga_actions = require("telescope-live-grep-args.actions")
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<Down>"] = actions.cycle_history_next,
							["<Up>"] = actions.cycle_history_prev,
						},
					},
					history = {
						cycle_wrap = true,
					},
					path_display = { absolute = true },
					prompt_prefix = "   ",
					selection_caret = "  ",
					entry_prefix = "  ",
				},
				pickers = {
					buffers = {
						previewer = false,
						theme = "ivy",
						layout_config = {
							height = 0.5,
						},
						mappings = {
							i = {
								["<C-k>"] = actions.delete_buffer,
							},
						},
					},
					oldfiles = {
						previewer = false,
						theme = "ivy",
						layout_config = {
							height = 0.5,
						},
					},
					find_files = {
						hidden = true,
						find_command = { "rg", "--files", "--iglob", "!.git", "--hidden" },
						previewer = false,
						theme = "ivy",
						layout_config = {
							height = 0.5,
						},
					},
					frecency = {
						theme = "ivy",
					},
				},
				extensions = {
					file_browser = {
						theme = "ivy",
						hijack_netrw = true,
					},
					frecency = {
						show_scores = false,
						auto_validate = false,
					},
					live_grep_args = {
						auto_quoting = true,
						mappings = {
							i = {
								["<C-k>"] = lga_actions.quote_prompt(),
								["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
							},
						},
						theme = "ivy", -- use dropdown theme
						layout_config = {
							height = 0.5,
						},
					},
				},
			})
			require("telescope").load_extension("frecency")
			require("telescope").load_extension("file_browser")
			local themes = require("telescope.themes")
			vim.api.nvim_create_user_command("Recent", function()
				local Path = require("plenary.path")
				local os_home = vim.loop.os_homedir()
				require("telescope").extensions.frecency.frecency(themes.get_ivy({
					path_display = function(_, filename)
						if
							vim.startswith(filename, os_home --[[@as string]])
						then
							filename = "~/" .. Path:new(filename):make_relative(os_home)
						end
						return filename
					end,
					sorter = require("telescope.config").values.file_sorter(),
					layout_config = {
						height = 0.5,
					},
					previewer = false,
				}))
			end, {})
		end,
	},
	"nvim-telescope/telescope-frecency.nvim",
	{ "https://github.com/nvim-telescope/telescope-live-grep-args.nvim" },
	"https://github.com/nvim-telescope/telescope-file-browser.nvim",

	"https://github.com/tpope/vim-fugitive",
	{
		"NeogitOrg/neogit",
		branch = "master",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = true,
	},
	{
		"https://github.com/lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				on_attach = function()
					local gs = package.loaded.gitsigns
					vim.keymap.set("n", "<leader>sh", gs.stage_hunk, { desc = "stage hunk" })
					vim.keymap.set("v", "<leader>sh", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "stage selected" })
					vim.keymap.set("n", "<leader>sb", gs.stage_buffer, { desc = "stage buffer" })
					vim.keymap.set("n", "<leader>rh", "<Cmd>Gitsigns reset_hunk<CR>", { desc = "reset hunk" })
					vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<cr>", { desc = "next hunk" })
					vim.keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", { desc = "previous hunk" })
					vim.keymap.set(
						"n",
						"<leader>phi",
						"<cmd>Gitsigns preview_hunk_inline<cr>",
						{ desc = "preview hunk inline" }
					)
					vim.keymap.set(
						"n",
						"<leader>pho",
						"<cmd>Gitsigns preview_hunk<cr>",
						{ desc = "preview hunk overlay" }
					)
				end,
			})
		end,
	},
	"https://github.com/moll/vim-bbye",
	
	{ 'projekt0n/github-nvim-theme', name = 'github-theme' }
		
},
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- Keybinds

vim.g.mapleader = ","

vim.keymap.set('n', '<C-b>', '<Cmd>Neotree toggle<CR>')

vim.keymap.set('n', '<C-t>', '<Cmd>ToggleTerm<CR>')

vim.keymap.set('n', '<C-;>d', '<Cmd>colorscheme dawnfox<CR>')
vim.keymap.set('n', '<C-;>n', '<Cmd>colorscheme duskfox<CR>')
vim.keymap.set('n', '<leader>x', '<Cmd>Bdelete<CR>')

vim.keymap.set('t', '<C-SPACE>', "<C-\\><C-n><C-w>k<C-w>l",{silent = true})

vim.cmd('Neotree')

vim.cmd('colorscheme duskfox')
-- vim.cmd('colorscheme github_light_high_contrast')
vim.cmd('cd ~')

-- aesthetics

vim.opt.number = true
vim.opt.signcolumn = "number"

-- LSP stuff below

require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = { "pyright", "java_language_server", "ocamllsp" },
})

local lspconfig = require('lspconfig')

local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts) -- References
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts) -- Go to implementation
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts) -- Rename symbol
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts) -- Format document
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts) -- Show diagnostics
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts) -- Previous diagnostic
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts) -- Next diagnostic
end

lspconfig.pyright.setup{
    on_attach = on_attach,
}

lspconfig.java_language_server.setup{
    on_attach = on_attach,
}

lspconfig.ocamllsp.setup{
    on_attach = on_attach,
}

-- folding stuff

vim.opt.foldmethod = "expr"

vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function()
    if require("nvim-treesitter.parsers").has_parser() then
      vim.opt.foldmethod = "manual"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    else
      vim.opt.foldmethod = "syntax"
    end
  end,
})

--Neovide settings (stolen from michael)

if vim.g.neovide then
	vim.g.neovide_input_macos_alt_is_meta = true
	vim.opt.linespace = 5
	-- vim.opt.guifont = { "JetBrains Mono", "JetBrainsMono Nerd Font", ":h18" }

	vim.g.neovide_floating_shadow = true
	vim.g.neovide_floating_z_height = 5
	vim.g.neovide_light_angle_degrees = 45
	vim.g.neovide_light_radius = 60

	vim.g.neovide_cursor_vfx_mode = "railgun"
	vim.g.neovide_cursor_vfx_particle_lifetime = 1.5
	vim.g.neovide_cursor_vfx_particle_density = 17.0
	vim.g.neovide_cursor_vfx_particle_phase = 4.5
	vim.g.neovide_cursor_vfx_particle_curl = 4.0

	vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
	vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
	vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
end
