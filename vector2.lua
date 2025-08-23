local Vector2 = {}
Vector2.__index = Vector2

function Vector2:new(x, y)
    local obj = {}
    setmetatable(obj, self)
    obj.x = x or 0
    obj.y = y or 0
    return obj
end

function Vector2:scale(scalar)
    return Vector2:new(self.x * scalar, self.y * scalar)
end

function Vector2:dot(v)
    return self.x * v.x + self.y * v.y 
end

function Vector2:norm()
    return math.sprt(self.x * self.x + self.y * self.y)
end

function Vector2:normalize()
    local len = self:norm()
    if len == 0 then
        return Vector2:new(0, 0)
    else
        return Vector2:new(self.x / len, self.y / len)
    end
end

Vector2.__add = function(v1, v2)
    return Vector2:new(v1.x + v2.x, v1.y + v2.y)
end

Vector2.__sub = function(v1, v2)
    return Vector2:new(v1.x - v2.x, v1.y - v2.y)
end

return Vector2
