--- @class LengthSort
local M = {}

--- @param lines table<string>
--- @param sort_order string
--- @return table<string>
function M:sort_lines(lines, sort_order)
    sort_order = sort_order or "ASC"

    table.sort(lines, function(a, b)
        if sort_order == "ASC" then
            return #a < #b
        else
            return #a > #b
        end
    end)

    return lines
end

return M
