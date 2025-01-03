--- @class KeymapSetter
--- @field line_sorter LineSorter?
local M = {}

--- @param opts? LineSorterOptions
function M:setup(opts)
    self.line_sorter = require("nvim-line-sorter")

    local local_opts = opts or {}

    local plugin_prefix = local_opts.plugin_prefix or "s"

    local alphabetical_prefix = local_opts.alphabetical_prefix or "a"
    local length_prefix = local_opts.length_prefix or "l"

    local asc_prefix = local_opts.asc_prefix or "a"
    local desc_prefix = local_opts.desc_prefix or "d"

    self:set_keymaps(plugin_prefix, alphabetical_prefix, length_prefix, asc_prefix, desc_prefix)
end

--- Sets the keymap for the given key
--- @param key string
--- @param type? SortType
--- @param order? SortOrder
function M:set_keymap(key, type, order)
    vim.keymap.set("v", "<leader>" .. key, function() self.line_sorter:run(type, order) end,
        { noremap = true, silent = true })
end

--- Sets the keymaps for the plugin
function M:set_keymaps(plugin_prefix, alphabetical_prefix, length_prefix, asc_prefix, desc_prefix)
    self:set_keymap(plugin_prefix .. alphabetical_prefix .. asc_prefix, self.line_sorter.sort_type.alphabetical,
        self.line_sorter.sort_order.asc)
    self:set_keymap(plugin_prefix .. alphabetical_prefix .. desc_prefix, self.line_sorter.sort_type.alphabetical,
        self.line_sorter.sort_order.desc)
    self:set_keymap(plugin_prefix .. length_prefix .. asc_prefix, self.line_sorter.sort_type.length,
        self.line_sorter.sort_order.asc)
    self:set_keymap(plugin_prefix .. length_prefix .. desc_prefix, self.line_sorter.sort_type.length,
        self.line_sorter.sort_order.desc)
end

return M
