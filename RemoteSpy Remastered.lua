-- Remote Spy with hookmetamethod
local logEnabled = true -- Toggle logging

-- Function to log remote calls
local function logRemote(remote, method, args)
    if logEnabled then
        print("Remote called!")
        print("Remote Name:", remote.Name)
        print("Remote Path:", remote:GetFullName())
        print("Method:", method)
        print("Arguments:")
        for i, v in ipairs(args) do
            print(string.format("[%d]: %s", i, tostring(v)))
        end
        print("------------------------")
    end
end

-- Use safer hookmetamethod
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    -- Check if the method relates to remotes
    if (method == "FireServer" or method == "InvokeServer") and self:IsA("RemoteEvent") or self:IsA("RemoteFunction") then
        -- Log the remote call
        pcall(logRemote, self, method, args)
    end

    -- Call the original method
    return oldNamecall(self, ...)
end)

-- Monitor new remotes dynamically
game.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
        print("New Remote Detected:", descendant.Name, descendant:GetFullName())
    end
end)

print("Remote Spy is active!")
