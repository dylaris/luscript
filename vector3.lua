local Vector3 = {}
Vector3.__index = Vector3

function Vector3:new(x, y, z)
    local obj = {}
    setmetatable(obj, self)
    obj.x = x or 0
    obj.y = y or 0
    obj.z = z or 0
    return obj
end

function Vector3:scale(scalar)
    return Vector3:new(self.x * scalar, self.y * scalar, self.z * scalar)
end

function Vector3:dot(v)
    return self.x * v.x + self.y * v.y + self.z * v.z
end

function Vector3:norm()
    return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
end

function Vector3:normalize()
    local len = self:norm()
    if len == 0 then
        return Vector3:new(0, 0, 0)
    else
        return Vector3:new(self.x / len, self.y / len, self.z / len)
    end
end

Vector3.__add = function(v1, v2)
    return Vector3:new(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z)
end

Vector3.__sub = function(v1, v2)
    return Vector3:new(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z)
end

return Vector3
