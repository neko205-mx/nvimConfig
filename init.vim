call plug#begin('~/.local/share/nvim/plugged')

" 插件列表
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'akinsho/toggleterm.nvim'  " 添加 ToggleTerm 插件
Plug 'nvim-tree/nvim-tree.lua'  " 添加 nvim-tree 插件
Plug 'nvim-tree/nvim-web-devicons'  " 添加文件图标插件
Plug 'hrsh7th/nvim-cmp'          " nvim-cmp 插件
Plug 'hrsh7th/cmp-nvim-lsp'      " LSP 补全源
Plug 'hrsh7th/cmp-buffer'        " 缓冲区补全源
Plug 'hrsh7th/cmp-path'          " 路径补全源
Plug 'hrsh7th/cmp-cmdline'       " cmdline 补全源插件
Plug 'saadparwaiz1/cmp_luasnip'  " LuaSnip 补全源
Plug 'L3MON4D3/LuaSnip'          " LuaSnip 插件
Plug 'neovim/nvim-lspconfig'     " LSP 配置插件
Plug 'williamboman/mason.nvim'   " Mason 插件
Plug 'williamboman/mason-lspconfig.nvim' " Mason LSP 配置插件
Plug 'nvim-treesitter/nvim-treesitter'   " 代码高亮

call plug#end()

" ToggleTerm 插件配置
lua << EOF
require("toggleterm").setup{
  size = 20,  -- 设置底部终端的高度
  open_mapping = [[<C-\>]], -- 快捷键 Ctrl + \ 打开/关闭终端
  direction = 'horizontal',  -- 水平底部终端
  shade_terminals = true,  -- 终端颜色阴影效果
}
EOF

" nvim-tree 插件配置
lua << EOF
require('nvim-tree').setup {
  sort_by = 'name',
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  view = {
    width = 30,
    side = 'left',
  },
  filters = {
    dotfiles = false,
  },
  git = {
    enable = true,
    ignore = false,
  },
  renderer = {
    icons = {
      show = {
        git = true,    -- 关闭 Git 图标
        folder = true, -- 关闭文件夹图标
        file = true,   -- 关闭文件图标
      },
    },
  },
}
EOF

" nvim-cmp 插件配置
lua << EOF
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For luasnip users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-e>'] = cmp.mapping.abort(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
    { name = 'cmdline' }, -- 添加 cmdline 补全源
  }),
  experimental = {
    ghost_text = true,  -- 显示预选补全内容
  },
})

-- cmdline 补全配置
require('cmp').setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

require('cmp').setup.cmdline(':', {
  sources = {
    { name = 'cmdline' },
    { name = 'path' }
  }
})
EOF

" Mason 配置
lua << EOF
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'clangd','asm_lsp', 'pyright', 'ts_ls', 'gopls', 'rust_analyzer' }
})
EOF

" LSP 配置
lua << EOF
local lspconfig = require('lspconfig')

-- 配置补全能力
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- 设置 LSP 服务器
local servers = { 'clangd','asm_lsp', 'pyright', 'ts_ls', 'gopls', 'rust_analyzer' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    capabilities = capabilities,
  })
end
EOF


lua << EOF

-- treesitter设置
require'nvim-treesitter.configs'.setup {
  -- 安装 language parser
  -- :TSInstallInfo 命令查看支持的语言
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline","asm"},
  -- 启用代码高亮功能
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  },
  -- 启用增量选择
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      node_decremental = '<BS>',
      scope_incremental = '<TAB>',
    }
  },
  -- 启用基于Treesitter的代码格式化(=) . NOTE: This is an experimental feature.
  indent = {
    enable = true
  }
}
-- 开启 Folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
-- 默认不要折叠
-- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
vim.wo.foldlevel = 99
EOF


" 快捷键映射
nnoremap <leader>n :NvimTreeToggle<CR>  " 使用 Leader+n 打开/关闭 NvimTree
nnoremap <C-n> :NvimTreeToggle<CR>  

set number          " 显示绝对行号
set relativenumber  " 显示相对行号
