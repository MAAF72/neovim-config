local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ═══════════════════════════════════════════════════════════
-- BUFFER NAVIGATION (think browser tabs)
-- ═══════════════════════════════════════════════════════════

-- Tab/Shift-Tab: Like browser tabs, feels natural
map("n", "<Tab>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })

-- ═══════════════════════════════════════════════════════════
-- WINDOW MANAGEMENT (splitting and navigation)
-- ═══════════════════════════════════════════════════════════

-- Move between windows with Ctrl+hjkl (like tmux)
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- -- Resize windows with Ctrl+Shift+arrows (macOS friendly)
-- map("n", "<C-S-Up>", "<Cmd>resize +5<CR>", opts)
-- map("n", "<C-S-Down>", "<Cmd>resize -5<CR>", opts)
-- map("n", "<C-S-Left>", "<Cmd>vertical resize -5<CR>", opts)
-- map("n", "<C-S-Right>", "<Cmd>vertical resize +5<CR>", opts)

-- Window splitting
map("n", "<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>sh", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>sv", "<C-W>v", { desc = "Split Window Right", remap = true })

-- ═══════════════════════════════════════════════════════════
-- SMART LINE MOVEMENT
-- ═══════════════════════════════════════════════════════════

-- Moves by visual lines when no count, real lines with count
-- map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
-- map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move lines up/down
map("n", "<A-j>", "<Cmd>:m .+1<CR>==", { desc = "Move Line Down", silent = true })
map("n", "<A-k>", "<Cmd>:m .-2<CR>==", { desc = "Move Line Up", silent = true })
map("i", "<A-j>", "<Esc><Cmd>:m .+1<CR>==gi", { desc = "Move Line Down", silent = true })
map("i", "<A-k>", "<Esc><Cmd>:m .-2<CR>==gi", { desc = "Move Line Up", silent = true })
map("v", "<A-j>", "<Esc><Cmd>:'<,'>move '>+1<CR>gv=gv", { desc = "Move Selected Down", silent = true })
map("v", "<A-k>", "<Esc><Cmd>:'<,'>move '<-2<CR>gv=gv", { desc = "Move Selected Up", silent = true })

-- Move text left/right
map("v", "<A-h>", "<Esc><Cmd>normal! >gv", { desc = "Move Selected Left", silent = true })
map("v", "<A-l>", "<Esc><Cmd>normal! <gv", { desc = "Move Selected Right", silent = true })

-- ═══════════════════════════════════════════════════════════
-- SEARCH & NAVIGATION (ergonomic improvements)
-- ═══════════════════════════════════════════════════════════

-- Better line start/end (more comfortable than $ and ^)
map("n", "<A-h>", "^", { desc = "Go to start of line", silent = true })
map("n", "<A-l>", "$", { desc = "Go to end of line", silent = true })

-- Select all content
map("n", "==", "gg<S-v>G")
map("n", "<A-a>", "ggVG", { noremap = true, silent = true, desc = "Select all" })

-- Clear search highlighting
map({ "i", "n" }, "<Esc>", "<Cmd>noh<CR><Esc>", { desc = "Escape and Clear hlsearch" })
map("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" })

-- Smart search navigation (n always goes forward, N always backward)
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- ═══════════════════════════════════════════════════════════
-- SMART TEXT EDITING
-- ═══════════════════════════════════════════════════════════

-- Smart indenting (visual mode)
map("v", "<Tab>", "<Esc><Cmd>'<,'>silent normal! >\\<CR>gv=gv", { desc = "Add Indent", silent = true })
map("v", "<S-Tab>", "<gv", { desc = "Remove Indent", silent = true })

-- Better paste (doesn't replace clipboard with deleted text)
map("v", "p", '"_dP', opts)

-- Copy whole file to clipboard
map("n", "<C-c>", ":%y+<CR>", opts)

-- Smart undo break-points (create undo points at logical stops)
map("i", ",", ",<C-g>u")
map("i", ".", ".<C-g>u")
map("i", ";", ";<C-g>u")

-- Delete line(s)
map("n", "d", "<Nop>") -- Disable default 'd' in normal mode
map("v", "d", "<Nop>") -- Disable default 'd' in visual mode
map("n", "<A-d>", "dd", { desc = "Delete Line" })
map("i", "<A-d>", "<Esc>ddi", { desc = "Delete Line" })
map("v", "<A-d>", "d", { desc = "Delete Selected Line" })

-- ═══════════════════════════════════════════════════════════
-- FILE OPERATIONS
-- ═══════════════════════════════════════════════════════════

-- Save file (works in all modes)
map({ "i", "x", "n", "s" }, "<C-s>", "<Cmd>w<CR><Esc>", { desc = "Save File" })

-- Create new file
map("n", "<leader>fn", "<Cmd>enew<CR>", { desc = "New File" })

-- Quit operations
map("n", "<leader>q", "<Cmd>Bdelete<CR>", { desc = "Quit Current Buffer" })
map("n", "<leader>qq", "<Cmd>qa<CR>", { desc = "Quit All" })

-- ═══════════════════════════════════════════════════════════
-- DEVELOPMENT TOOLS
-- ═══════════════════════════════════════════════════════════

-- Toggle diagnostic
map("n", "<leader>dt", function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable(true)
  end
end, { desc = "Toggle Diagnostic" })

-- Commenting (add comment above/below current line)
map("n", "gco", "o<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<bs>", { desc = "Add Comment Above" })

-- Quickfix and location lists
map("n", "<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })

map("n", "<leader>xq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- Inspection tools (useful for debugging highlights and treesitter)
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", "<Cmd>InspectTree<CR>", { desc = "Inspect Tree" })

-- Keyword program (K for help on word under cursor)
map("n", "<leader>K", "<Cmd>norm! K<CR>", { desc = "Keywordprg" })

-- ═══════════════════════════════════════════════════════════
-- TERMINAL INTEGRATION
-- ═══════════════════════════════════════════════════════════

-- Terminal mode navigation
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Enter Normal Mode" })
map("t", "<C-h>", "<Cmd>wincmd h<CR>", { desc = "Go to Left Window" })
map("t", "<C-j>", "<Cmd>wincmd j<CR>", { desc = "Go to Lower Window" })
map("t", "<C-k>", "<Cmd>wincmd k<CR>", { desc = "Go to Upper Window" })
map("t", "<C-l>", "<Cmd>wincmd l<CR>", { desc = "Go to Right Window" })
map("t", "<C-/>", "<Cmd>close<CR>", { desc = "Hide Terminal" })
map("t", "<C-_>", "<Cmd>close<CR>", { desc = "which_key_ignore" })

-- ═══════════════════════════════════════════════════════════
-- TAB MANAGEMENT (when you need multiple workspaces)
-- ═══════════════════════════════════════════════════════════

map("n", "<leader><tab>l", "<Cmd>tablast<CR>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<Cmd>tabonly<CR>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<Cmd>tabfirst<CR>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<Cmd>tabnew<CR>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<Cmd>tabnext<CR>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<Cmd>tabclose<CR>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<Cmd>tabprevious<CR>", { desc = "Previous Tab" })

-- ═══════════════════════════════════════════════════════════
-- FOLDING NAVIGATION (for code organization)
-- ═══════════════════════════════════════════════════════════

-- Close all folds except current one (great for focus)
map("n", "zv", "zMzvzz", { desc = "Close all folds except the current one" })

-- Smart fold navigation (closes current, opens next/previous)
map("n", "zj", "zcjzOzz", { desc = "Close current fold when open. Always open next fold." })
map("n", "zk", "zckzOzz", { desc = "Close current fold when open. Always open previous fold." })

-- ═══════════════════════════════════════════════════════════
-- UTILITY SHORTCUTS
-- ═══════════════════════════════════════════════════════════

-- Toggle line wrapping
map("n", "<leader>tw", "<Cmd>set wrap!<CR>", { desc = "Toggle Wrap", silent = true })

-- Fix spelling (picks first suggestion)
map("n", "z0", "1z=", { desc = "Fix word under cursor" })

-- Copy Paste
map("v", "<C-c>", '"+y', { noremap = true, expr = false, silent = true, desc = "Copy Selected" })
map("n", "<C-v>", '"+p', { noremap = true, expr = false, silent = true, desc = "Paste Selected" })

map("n", "<C-z>", "u", { noremap = true, silent = true, desc ="Undo "})
map("n", "<C-y>", "<C-r>", { noremap = true, silent = true, desc ="Redo" })
map("i", "<C-z>", "<C-o>u", { noremap = true, silent = true, desc ="Undo "})
map("i", "<C-y>", "<C-o><C-r>", { noremap = true, silent = true, desc ="Redo" })