-- Quick keys
nmap('<leader>w', ':w<CR>', 'Save')

-- Buffer
nmap('<C-p>', '<Cmd>BufferNext<CR>', 'Next buffer')
nmap('<C-o>', '<Cmd>BufferPrevious<CR>', 'Previous buffer')
nmap('<C-c>', '<Cmd>BufferClose<CR>', 'Close buffer')
nmap('<C-x>', '<Cmd>BufferRestore<CR>', 'Close buffer')
nmap('<A-Left>', '<Cmd>BufferMovePrevious<CR>', 'Previous buffer')
nmap('<A-Right>', '<Cmd>BufferMoveNext<CR>', 'Next buffer')
nmap('<A-0>', '<Cmd>BufferLast<CR>', 'Next buffer')

-- Diagnostic
nmap('<leader>dp', vim.diagnostic.goto_prev, 'Previous diagnostic')
nmap('<leader>dn', vim.diagnostic.goto_next, 'Next diagnostic')
nmap('<space>e', vim.diagnostic.open_float, 'Open float')

-- Copy relative path of the current buffer in the clipboard
nmap("<Leader>l", ":let @+ = expand('%') . ':' . line('.')<cr>", 'Copy relative path')
