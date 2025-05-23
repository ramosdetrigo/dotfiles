require "options"
require "mappings"
require "commands"
vim = vim

-- bootstrap plugins & lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim" -- path where its going to be installed

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    }
end

vim.diagnostic.config({
  virtual_text = true,
  signs = false,
  float = true,
})

vim.opt.rtp:prepend(lazypath)

local plugins = require "plugins"

require("lazy").setup(plugins, require "lazy_config")
require("colorizer").setup()
vim.wo.relativenumber = true

vim.cmd "colorscheme kanagawa"
