local cloneref = cloneref or function(...) return ... end
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local BufferRemote = ReplicatedStorage:WaitForChild("ByteNetReliable", math.huge)

local HitBufferData = {
    [0] = 12;
    [1] = 1;
    [2] = 0;
    [3] = 1;
    [4] = 1;
    [5] = 1;
    [6] = 0
}

local function HitTarget(EntityId)
    local NewBufferData = HitBufferData
    NewBufferData[3] = EntityId % 256
    NewBufferData[4] = (EntityId // 256) % 256
    NewBufferData[5] = (EntityId // 65536) % 256

    local HitBuffer = buffer.create(7)
    for Index, Value in next, NewBufferData do 
        buffer.writeu8(HitBuffer, Index, Value)
    end
    BufferRemote:FireServer(HitBuffer)
end

return HitTarget
