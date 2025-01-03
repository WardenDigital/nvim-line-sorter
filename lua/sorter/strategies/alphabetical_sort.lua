--- @class AlphabeticalSort
local M = {}

--- @param lines table<string>
--- @param sort_order string
--- @return table<string>
function M:sort_lines(lines, sort_order)
    sort_order = sort_order or "ASC"

    table.sort(lines, function(a, b)
        a = self:sanitize(a)
        b = self:sanitize(b)
        if sort_order == "ASC" then
            return a < b
        else
            return a > b
        end
    end)

    return lines
end

M.sanitized_lines = {
    "%s+",
    "\"",
    "'",
}

--- Sanitizes the given line
--- @param line string
--- @return string
function M:sanitize(line)
    line = string.lower(line)
    for _, pattern in ipairs(self.sanitized_lines) do
        line = string.gsub(line, pattern, "")
    end
    return line
end

return M
