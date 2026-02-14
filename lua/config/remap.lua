vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")
vim.keymap.set("i", "<Tab>", "<C-n>")

vim.keymap.set("n", "bc", function()
    vim.cmd("bp | sp | bn | bd") end )


vim.keymap.set("x", "<leader>p", [["_dP]])
