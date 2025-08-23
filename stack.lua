local Stack = {}
Stack.__index = Stack

function Stack:new()
    local obj = {}
    setmetatable(obj, self)
    obj.top = 0
    obj.items = {}
    return obj
end

function Stack:push(elem)
    self.top = self.top + 1
    self.items[self.top] = elem
end

function Stack:pop()
    if self.top == 0 then
        return nil
    else
        local item = self.items[self.top]
        self.top = self.top - 1
        return item
    end
end

function Stack:peek(distance)
    local index = self.top - distance
    if index < 1 then
        return nil
    else
        return sefl.items[index]
    end
end

function Stack:is_empty()
    return self.top == 0
end

return Stack
