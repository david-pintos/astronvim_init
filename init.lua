-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

require "lazy_setup"
require "polish"
require("remote-sshfs").setup {}
require("telescope").load_extension "remote-sshfs"

local api = require "remote-sshfs.api"
vim.keymap.set("n", "<leader>rc", api.connect, { desc = "Remote SSHFS connect" })
vim.keymap.set("n", "<leader>rd", api.disconnect, { desc = "Remote SSHFS disconnect" })
vim.keymap.set("n", "<leader>re", api.edit, { desc = "SSH config file edit" })

-- (optional) Override telescope find_files and live_grep to make dynamic based on if connected to host
local builtin = require "telescope.builtin"
local connections = require "remote-sshfs.connections"
-- local opts = {}

vim.keymap.set("n", "<leader>ff", function()
  if connections.is_connected() then
    require("telescope").extensions["remote-sshfs"].find_files {}
    -- api.find_files()
  else
    builtin.find_files()
  end
end, {})
vim.keymap.set("n", "<leader>fw", function()
  if connections.is_connected() then
    require("telescope").extensions["remote-sshfs"].live_grep {}
    -- api.live_grep()
  else
    builtin.live_grep()
  end
end, {})
