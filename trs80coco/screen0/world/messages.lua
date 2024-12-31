local M = {}
function M.construct(world, message, message_data)
    function message:add_line(line)
        table.insert(message_data, line)
    end
    function message:get_lines()
        local result = {}
        for _,line in ipairs(message_data) do
            table.insert(result, line)
        end
        return result
    end
end
return M