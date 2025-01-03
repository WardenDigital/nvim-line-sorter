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
    require("keymap-setter"):setup(opts)
end

--- Sorts the lines that are currently selected in visual mode
--- @param type SortType
--- @param order SortOrder
function M:run(type, order)
    local buffer = require("buffer-manipulator")
    buffer:setup()

    local lines = buffer:get_lines()

    local sorted_lines = self:sort_lines(lines, type, order)

    buffer:set_lines(sorted_lines)
    buffer:reset_selection()
end

--- Sorts the lines in the given order
function M:sort_lines(lines, sort_type, order)
    local sorter = require("sorter.sorter")
    return sorter:sort_lines(lines, sort_type, order)
end

return M
