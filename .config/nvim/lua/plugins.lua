local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
end

return require("packer").startup(function()
  use "wbthomason/packer.nvim"
  use "navarasu/onedark.nvim"
  use "alec-gibson/nvim-tetris"
  use "shaeinst/roshnivim-cs"
  use "akinsho/toggleterm.nvim"
  use "tribela/vim-transparent"
  use "folke/which-key.nvim"
  use "terrortylor/nvim-comment"
  use "hrsh7th/nvim-compe"
  use "windwp/nvim-autopairs"
  use "glepnir/dashboard-nvim"
  use { "neovim/nvim-lspconfig", "williamboman/nvim-lsp-installer" }
  use { "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons", }
  use { "kyazdani42/nvim-tree.lua", requires = "kyazdani42/nvim-web-devicons", }
  use { "akinsho/bufferline.nvim", requires = "kyazdani42/nvim-web-devicons"}
  use { "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } }
  use { "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } }
  use { "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } }
  use {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = "markdown",
    config = function()
      vim.g.mkdp_auto_start = 1
    end,
  }
  use {
    "nacro90/numb.nvim",
    event = "BufRead",
    config = function()
      require("numb").setup {
        show_numbers = true,
        show_cursorline = true,
      }
    end,
  }
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate"
  }
  use {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require('neoscroll').setup({
        mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
        '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
        hide_cursor = true,
        stop_eof = true,
        use_local_scrolloff = false,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = nil,
        pre_hook = nil,
        post_hook = nil,
      })
    end
  }
  use "Chiel92/vim-autoformat"

end)
