vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v', 'i' }, '<Up>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v', 'i' }, '<Down>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v', 'i' }, '<Left>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v', 'i' }, '<Right>', '<Nop>', { silent = true })

vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")
vim.keymap.set("n", "<leader>D", "\"+D")

vim.keymap.set("n", "<leader>ss", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "<leader>r", ":source ~/.config/nvim/init.lua<CR>")
vim.keymap.set("n", "<leader><leader>x", ":source %<CR>")

vim.keymap.set("i", "<C-u>", "<Nop>")

-- Moving between splits
vim.keymap.set("n", "<A-h>", "<C-w>h")
vim.keymap.set("n", "<A-j>", "<C-w>j")
vim.keymap.set("n", "<A-k>", "<C-w>k")
vim.keymap.set("n", "<A-l>", "<C-w>l")

-- Resizing splits
vim.keymap.set("n", "<A-=>", "<C-w>=")
vim.keymap.set("n", "<A-o>", "<C-w>o")
vim.keymap.set("n", "<A-s-=>", "<C-w>+")
vim.keymap.set("n", "<A-x>", "<C-w>5+")
vim.keymap.set("n", "<A-c>", "<C-w>5-")
vim.keymap.set("n", "<A-.>", "<C-w>5>")
vim.keymap.set("n", "<A-,>", "<C-w>5<")

-- Creating splits
vim.keymap.set("n", "<A-v>", "<C-w>v")
vim.keymap.set("n", "<A-s>", "<C-w>s")

-- Reordering splits
vim.keymap.set("n", "<A-r>", "<C-w>r")
vim.keymap.set("n", "<A-s-h>", "<C-w>H")
vim.keymap.set("n", "<A-s-j>", "<C-w>J")
vim.keymap.set("n", "<A-s-k>", "<C-w>K")
vim.keymap.set("n", "<A-s-l>", "<C-w>L")

-- Quickfix list
vim.keymap.set("n", "]c", "<cmd>cnext<cr>")
vim.keymap.set("n", "[c", "<cmd>cprev<cr>")
