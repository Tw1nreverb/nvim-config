set number  
set relativenumber
set autoindent
set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4
set mouse=a
set encoding=UTF-8
set noswapfile
set laststatus=3
set iminsert=0
set imsearch=0
nnoremap <silent> <leader>f :Format<CR>
nnoremap <silent> <leader>F :FormatWrite<CR>
augroup END
call plug#begin()
Plug 'https://github.com/kylechui/nvim-surround.git'
Plug 'windwp/nvim-autopairs'
Plug 'https://github.com/hrsh7th/cmp-buffer.git'
Plug 'nvim-lualine/lualine.nvim'
Plug 'https://github.com/airblade/vim-rooter.git'
Plug 'preservim/nerdtree'
Plug 'mhartington/formatter.nvim'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/airblade/vim-gitgutter.git'
Plug 'neovim/nvim-lspconfig'
Plug 'https://github.com/ellisonleao/gruvbox.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'L3MON4D3/LuaSnip',{'do': 'make install_jsregexp'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.6' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plug 'ray-x/lsp_signature.nvim'
Plug 'https://github.com/jremmen/vim-ripgrep.git'
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
Plug 'Pocco81/auto-save.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'rafamadriz/friendly-snippets'
Plug 'junegunn/fzf.vim'
call plug#end()
colorscheme gruvbox
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
nnoremap ,<space> :nohlsearch<CR>
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
inoremap jk <esc>
lua << EOF
vim.o.completeopt = 'menuone,noselect'
require("nvim-autopairs").setup {}
-- luasnip setup
local luasnip = require 'luasnip'
local async = require "plenary.async"
-- nvim-cmp setup
--require("luasnip.loaders.from_vscode").load {
--    include = { "python" },
--}
require("luasnip.loaders.from_vscode").lazy_load()
local cmp = require 'cmp'
cmp.setup {
    snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  completion = {
	  autocomplete = false
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
	['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
	['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
	{name = 'buffer'},
  },
}
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  require "lsp_signature".on_attach({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      floating_window = true,
      floating_window_above_cur_line = true,
      floating_window_off_x = 20,
      doc_lines = 10,
      hint_prefix = ''
    }, bufnr)  -- Note: add in lsp client on-attach
end
local servers = { 'pyright' }
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
	capabilities = lsp_capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
require"toggleterm".setup{
	size = 13,
	open_mapping = [[<c-\>]],
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 1,
	shell = 'wsl.exe',
	direction = 'horizontal',
	}
    local Terminal  = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = 'float' })
    
    function _lazygit_toggle()
      lazygit:toggle()
    end
    
    vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
	require("bufferline").setup{}
	vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>')
	vim.keymap.set('n', '<s-Tab>', ':BufferLineCyclePrev<CR>')
	vim.keymap.set('n', '<leader>X', ':BufferLineCloseRight<CR>')
	require("auto-save").setup(
    {
    }
	)
-- Utilities for creating configurations
local util = require "formatter.util"

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
	  python = {
		  require("formatter.filetypes.python").ruff,
	  },
    -- Formatter configurations for filetype "lua" go here
    -- and will be executed in order
   lua = {
      -- "formatter.filetypes.lua" defines default configurations for the
      -- "lua" filetype
      require("formatter.filetypes.lua").stylua,

    }, 

    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
      }
}
require('lualine').setup()
-- nvim-tree-sitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "python","lua", "vim", "vimdoc", "markdown", "markdown_inline" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {enable = true},
  incremental_selection = {
	  enable = true,
	  keymaps = {
		  init_selection="<C-space>",
		  node_incremental="<C-space>",
		  scope_incremental=false,
		  node_incremental = "<bs>",
		  },
	  },
}
require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
})
EOF
inoremap <C-x><C-o> <Cmd>lua require('cmp').complete()<CR>
