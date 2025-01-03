--- @class BufferManipulator
--- @field bufnr number
--- @field from number
--- @field to number
local M = {}

--- Sets up the plugin with the given options
--- Force visual mode if visual mode is not recognized (0,0) on the first call issue
function M:setup()
    vim.cmd("normal! v$")

    self.bufnr = vim.api.nvim_get_current_buf()
    self.from = vim.api.nvim_buf_get_mark(self.bufnr, "<")[1]
    self.to = vim.api.nvim_buf_get_mark(self.bufnr, ">")[1]

    if self.from > self.to then
        self.from, self.to = self.to, self.from
    end
end

--- Returns the lines that are currently selected in visual mode
--- @return table<string>
function M:get_lines()
    return vim.api.nvim_buf_get_lines(self.bufnr, self.from - 1, self.to, false)
end

--- Substitutes the lines in the given buffer (those which were selecte to those which are sorted)
--- @param lines table<string>
function M:set_lines(lines)
    vim.api.nvim_buf_set_lines(self.bufnr, self.from - 1, self.to, false, lines)
end

--- Removes selection, leaves visual mode
function M:reset_selection()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end

return M
