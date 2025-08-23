local Node = {}
Node.__index = Node

function Node:new(value)
    local obj = {}
    setmetatable(obj, self)
    obj.value = value
    obj.prev = nil
    obj.next = nil
    return obj
end

local List = {}
List.__index = List

function List:new()
    local obj = {}
    setmetatable(obj, self)
    obj.head = nil
    obj.tail = nil
    obj.size = 0
    return obj
end

function List:append(value)
    local new_node = Node:new(value)
    
    if self.size == 0 then
        self.head = new_node
        self.tail = new_node
    else
        new_node.prev = self.tail
        self.tail.next = new_node
        self.tail = new_node
    end
    
    self.size = self.size + 1
    return new_node
end

function List:prepend(value)
    local new_node = Node:new(value)
    
    if self.size == 0 then
        self.head = new_node
        self.tail = new_node
    else
        new_node.next = self.head
        self.head.prev = new_node
        self.head = new_node
    end
    
    self.size = self.size + 1
    return new_node
end

function List:insert_at(value, index)
    if index < 1 or index > self.size + 1 then
        return nil
    end
    
    if index == 1 then
        return self:prepend(value)
    elseif index == self.size + 1 then
        return self:append(value)
    end
    
    local new_node = Node:new(value)
    local current = self.head
    
    for i = 1, index - 1 do
        current = current.next
    end
    
    new_node.prev = current.prev
    new_node.next = current
    current.prev.next = new_node
    current.prev = new_node
    
    self.size = self.size + 1
    return new_node
end

function List:remove_node(node)
    if not node then
        return nil
    end
    
    if node.prev then
        node.prev.next = node.next
    else
        self.head = node.next
    end
    
    if node.next then
        node.next.prev = node.prev
    else
        self.tail = node.prev
    end
    
    self.size = self.size - 1
    return node.value
end

function List:remove_at(index)
    if index < 1 or index > self.size then
        return nil
    end
    
    local current = self.head
    for i = 1, index - 1 do
        current = current.next
    end
    
    return self:remove_node(current)
end

function List:remove_value(value)
    local current = self.head
    while current do
        if current.value == value then
            return self:remove_node(current)
        end
        current = current.next
    end
    return nil
end

function List:get_value(index)
    local node = self.get_node(index)
    if node then
        return node.value
    else
        return nil
    end
end

function List:get_node(index)
    if index < 1 or index > self.size then
        return nil
    end
    
    local current = self.head
    for i = 1, index - 1 do
        current = current.next
    end
    
    return current
end

function List:contains(value)
    local current = self.head
    while current do
        if current.value == value then
            return true
        end
        current = current.next
    end
    return false
end

function List:find(value)
    local current = self.head
    while current do
        if current.value == value then
            return current
        end
        current = current.next
    end
    return nil
end

function List:for_each(callback)
    local current = self.head
    local index = 1
    while current do
        callback(current.value, index)
        current = current.next
        index = index + 1
    end
end

function List:for_each_reverse(callback)
    local current = self.tail
    local index = self.size
    while current do
        callback(current.value, index)
        current = current.prev
        index = index - 1
    end
end

function List:to_array()
    local array = {}
    local current = self.head
    while current do
        table.insert(array, current.value)
        current = current.next
    end
    return array
end

function List:clear()
    self.head = nil
    self.tail = nil
    self.size = 0
end

function List:is_empty()
    return self.size == 0
end

function List:print()
    if self:is_empty() then
        print("Empty list")
        return
    end
    
    local current = self.head
    local output = ""
    while current do
        output = output .. tostring(current.value)
        if current.next then
            output = output .. " <-> "
        end
        current = current.next
    end
    print(output)
end

return List
