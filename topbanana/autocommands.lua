--vim.api.nvim_create_autocmd("VimEnter", {
--    callback = function()
--        require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() }) -- Open Neo-tree
--        vim.cmd("wincmd p") -- Switch back to the file
--    end,
--})

vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    command = "set norelativenumber"
})

vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    command = "set relativenumber"
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
