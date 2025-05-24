
require("core.options")
require("core.keymaps")


-- Treesitter configuration
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,              -- bật tô màu cú pháp
  },
  indent = {
    enable = true               -- bật tự động thụt lề
  },
}

vim.cmd.colorscheme("catppuccin")
require("catppuccin").setup()

-- Thanh trạng thái lualine
require('lualine').setup() 
-- {
--   options = {
--     theme = 'catppuccin',
--   },
-- }


