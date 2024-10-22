local g = vim.g     -- Global variables
local opt = vim.opt -- Set options (global/buffer/windows-scoped)

-----------------------------------------------------------
-- General
-----------------------------------------------------------
opt.mouse = 'a'                               -- Enable mouse support
opt.clipboard = 'unnamedplus'                 -- Copy/paste to system clipboard
opt.swapfile = false                          -- Don't use swapfile
opt.completeopt = 'menuone,noinsert,noselect' -- Autocomplete options

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number = true         -- Show line number
opt.showmatch = true      -- Highlight matching parenthesis
opt.foldmethod = 'marker' -- Enable folding (default 'foldmarker')
opt.colorcolumn = '120'   -- Line lenght marker at 80 columns
opt.splitright = true     -- Vertical split to the right
opt.splitbelow = true     -- Horizontal split to the bottom
opt.ignorecase = true     -- Ignore case letters when search
opt.smartcase = true      -- Ignore lowercase for the whole pattern
opt.linebreak = true      -- Wrap on word boundary
opt.termguicolors = true  -- Enable 24-bit RGB colors
opt.laststatus = 3        -- Set global statusline

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true   -- Use spaces instead of tabs
opt.shiftwidth = 2     -- Shift 2 spaces when tab
opt.tabstop = 2        -- 1 tab == 2 spaces
opt.smartindent = true -- Autoindent new lines

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true    -- Enable background buffers
opt.history = 100    -- Remember N lines in history
-- opt.lazyredraw = true -- Faster scrolling
opt.synmaxcol = 240  -- Max column for syntax highlight
opt.updatetime = 250 -- ms to wait for trigger an event

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------
-- Disable nvim intro
opt.shortmess:append "sI"

-----------------------------------------------------------
-- Persistent undo
-----------------------------------------------------------
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.tmp-nvim-undo"

-----------------------------------------------------------
-- Git gutter
-----------------------------------------------------------
g.gitgutter_max_signs = 1000

-----------------------------------------------------------
-- Minimap
-----------------------------------------------------------
g.minimap_width = 10
g.minimap_auto_start = 1
g.minimap_auto_start_win_enter = 1
g.minimap_git_colors = 1

opt.signcolumn = 'yes' -- Always show signcolumn
opt.cursorline = true  -- Highlight current line

local os = require("os")
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Save last nvim server id when nvim loses focus (FocusLost)
autocmd("FocusLost", {
  group = augroup("focus_lost", {}),
  pattern = "*",
  callback = function()
    local servername = vim.v.servername
    -- TODO: use OS-agnostic temp dir path
    vim.fn.writefile({ servername }, "/tmp/nvim-focuslost")
  end,
})
