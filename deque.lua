local Deque = {}
Deque.__index = Deque

function Deque:new()
    local obj = {}
    setmetatable(obj, self)
    obj.items = {}
    obj.front = nil
    obj.rear = nil
    obj.size = 0
    return obj
end

function Deque:push_front(item)
    if self.size == 0 then
        self.front = 0
        self.rear = 0
    else
        self.front = self.front - 1
    end
    self.items[self.front] = item
    self.size = self.size + 1
end

function Deque:push_back(item)
    if self.size == 0 then
        self.front = 0
        self.rear = 0
    else
        self.rear = self.rear + 1
    end
    self.items[self.rear] = item
    self.size = self.size + 1
end

function Deque:pop_front()
    if self:is_empty() then
        return nil
    end
    local item = self.items[self.front]
    self.items[self.front] = nil
    self.front = self.front + 1
    self.size = self.size - 1
    return item
end

function Deque:pop_back()
    if self:is_empty() then
        return nil
    end
    local item = self.items[self.rear]
    self.items[self.rear] = nil
    self.rear = self.rear - 1
    self.size = self.size - 1
    return item
end

function Deque:peek_front()
    if self:is_empty() then
        return nil
    end
    return self.items[self.front]
end

function Deque:peek_back()
    if self:is_empty() then
        return nil
    end
    return self.items[self.rear]
end

function Deque:is_empty()
    return self.size == 0
end

function Deque:clear()
    self.items = {}
    self.front = nil
    self.rear = nil
    self.size = 0
end

function Deque:to_array()
    local result = {}
    for i = self.front, self.rear do
        table.insert(result, self.items[i])
    end
    return result
end

return Deque
