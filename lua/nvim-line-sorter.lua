--- @class LineSorter @field lines table<string> List of lines to sort
local M = {}

--- @enum SortOrder
M.sort_order = {
    asc = "ASC",
    desc = "DESC"
}

--- @enum SortType
M.sort_type = {
    alphabetical = "ALPHABETICAL",
    length = "LENGTH"
}

--- @class LineSorterOptions
--- @field plugin_prefix? string
--- @field alphabetical_prefix? string
--- @field length_prefix? string
--- @field asc_prefix? string
--- @field desc_prefix? string

--- Sets up the plugin with the given options
--- @param opts? LineSorterOptions
function M:setup(opts)
    local local_opts = opts or {}
    local plugin_prefix = local_opts.plugin_prefix or "s"
    local alphabetical_prefix = local_opts.alphabetical_prefix or "a"
    local length_prefix = local_opts.length_prefix or "l"
    local asc_prefix = local_opts.asc_prefix or "a"
    local desc_prefix = local_opts.desc_prefix or "d"

    M:set_keymaps(plugin_prefix, alphabetical_prefix, length_prefix, asc_prefix, desc_prefix)
end

--- Returns the lines that are currently selected in visual mode
--- @param from number
--- @param to number
--- @return table<string>
function M:get_lines(bufnr, from, to)
    return vim.api.nvim_buf_get_lines(bufnr, from - 1, to, false)
end

--- Sorts the lines that are currently selected in visual mode
--- @param type? SortType
--- @param order? SortOrder
function M:run(type, order)
    -- Force visual mode if visual mode is not recognized (0,0) on the first call issue
    vim.cmd("normal! v$")

    type = type or self.sort_type.alphabetical
    order = order or self.sort_order.asc

    local bufnr = vim.api.nvim_get_current_buf()

    local start_row = vim.api.nvim_buf_get_mark(bufnr, "<")[1]
    local finish_row = vim.api.nvim_buf_get_mark(bufnr, ">")[1]

    if start_row == finish_row then
        return
    end

    --- Nvim will complain if you select bottom-to-top
    if start_row > finish_row then
        start_row, finish_row = finish_row, start_row
    end


    local lines = self:get_lines(bufnr, start_row, finish_row)
    local sorted_lines = self:sort_lines(lines, type, order)

    self:subsitute_lines(bufnr, start_row, finish_row, sorted_lines)

    self:reset_selection()
end

function M:reset_selection()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end

--- Sorts the lines in the given order
function M:sort_lines(lines, sort_type, order)
    local Sorter = require("sorter.sorter")
    return Sorter:sort_lines(lines, sort_type, order)
end

--- Substitutes the lines in the given buffer (those which were selecte to those which are sorted)
function M:subsitute_lines(bufnr, from, to, lines)
    vim.api.nvim_buf_set_lines(bufnr, from - 1, to, false, lines)
end

--- Sets the keymap for the given key
--- @param key string
--- @param type? SortType
--- @param order? SortOrder
function M:set_keymap(key, type, order)
    vim.keymap.set("v", "<leader>" .. key, function() M:run(type, order) end,
        { noremap = true, silent = true })
end

--- Sets the keymaps for the plugin
function M:set_keymaps(plugin_prefix, alphabetical_prefix, length_prefix, asc_prefix, desc_prefix)
    self:set_keymap(plugin_prefix .. alphabetical_prefix .. asc_prefix, M.sort_type.alphabetical, M.sort_order.asc)
    self:set_keymap(plugin_prefix .. alphabetical_prefix .. desc_prefix, M.sort_type.alphabetical, M.sort_order.desc)
    self:set_keymap(plugin_prefix .. length_prefix .. asc_prefix, M.sort_type.length, M.sort_order.asc)
    self:set_keymap(plugin_prefix .. length_prefix .. desc_prefix, M.sort_type.length, M.sort_order.desc)
end

return M
