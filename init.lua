require("config.lazy")
require("config.remap")

require("lazy").setup("plugins")

vim.cmd[[set expandtab sw=4 sts=4]]
vim.cmd[[set virtualedit=all]]
vim.cmd([[colorscheme catppuccin]])
vim.cmd([[set number]])
vim.cmd([[set relativenumber]])
vim.cmd([[set smarttab]])
vim.cmd([[set autoindent]])
            
