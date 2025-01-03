--- @class Sorter
local M = {}

--- @param lines table<string>
--- @param sort_type string
--- @param sort_order string
--- @return table<string>
function M:sort_lines(lines, sort_type, sort_order)
    if sort_type == "ALPHABETICAL" then
        return require("sorter.strategies.alphabetical_sort"):sort_lines(lines, sort_order)
    elseif sort_type == "LENGTH" then
        return require("sorter.strategies.length_sort"):sort_lines(lines, sort_order)
    end

    return lines
end

return M
