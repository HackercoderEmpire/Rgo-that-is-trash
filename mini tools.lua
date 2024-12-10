-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/lime"))()

-- Create a Window
local Window = Library:Window("Tools")

Window:Toggle("Auto Click V", function(state)
    getgenv().autoClickV = state -- Set a global variable to track the toggle state
    
    if state then
        -- Start Auto Clicking
        task.spawn(function()
            local vim = game:GetService("VirtualInputManager")
            while getgenv().autoClickV do
                pcall(function()
                    -- Simulate pressing and releasing the V key
                    vim:SendKeyEvent(true, "V", false, nil)  -- Press 'V'
                    vim:SendKeyEvent(false, "V", false, nil) -- Release 'V'
                end)
                task.wait(0.05)  -- Adjust interval to throttle clicking speed
            end
        end)
    else
        -- Stop Auto Clicking if toggle is switched off
        getgenv().autoClickV = false
    end
end)
Window:Toggle("Kill Aura", function(state)
    getgenv().superRapidAura = state  -- Toggle state for the Kill Aura

    if state then
        -- Start the rapid punching aura
        spawn(function()
            while getgenv().superRapidAura do
                -- Apply the aura effect with specified parameters
                local radius = 15          -- Distance from the player to hit targets
                local punchCount = 100     -- Number of punches per activation
                local punchCooldown = 0.03 -- Delay between punches

                -- Function to simulate aura
                applyAura("superRapidAura", radius, punchCount, punchCooldown)

                -- Add a small wait to avoid excessive loop frequency
                wait(0.1)
            end
        end)
    else
        -- Stop the rapid punching aura
        getgenv().superRapidAura = false
    end
end)

-- Function: Apply Aura Effect
function applyAura(auraType, radius, punchCount, punchCooldown)
    pcall(function()
        -- Find nearby targets
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end

        local hrp = character.HumanoidRootPart
        local targets = {}

        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj ~= character and obj:FindFirstChild("Humanoid") then
                local targetHRP = obj:FindFirstChild("HumanoidRootPart")
                if targetHRP and (targetHRP.Position - hrp.Position).Magnitude <= radius then
                    table.insert(targets, obj)
                end
            end
        end

        -- Apply damage to targets
        for _, target in ipairs(targets) do
            for _ = 1, punchCount do
                if not getgenv().superRapidAura then return end
                -- Simulate a punch effect
                game:GetService("ReplicatedStorage").Events.Punch:FireServer(target)

                wait(punchCooldown)
            end
        end
    end)
end
-- Toggle for Anti Grab
Window:Toggle("Anti Grab", function(state)
    -- Toggle the Anti-Grab functionality
    getgenv().AntiT = state

    -- Local references for efficiency
    local player = game.Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")

    -- Check if the event exists
    local toggleTelekinesisEvent = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("ToggleTelekinesis")

    -- Function to protect the player from grab attempts
    local function protectPlayer()
        if getgenv().AntiT and toggleTelekinesisEvent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Block telekinesis effects
            toggleTelekinesisEvent:InvokeServer(Vector3.new(1, 1, 1), false, player.Character)
        end
    end

    if state then
        -- Enable real-time protection
        getgenv().protectionConnection = RunService.RenderStepped:Connect(protectPlayer)
    else
        -- Disable protection and clean up connection
        if getgenv().protectionConnection then
            getgenv().protectionConnection:Disconnect()
            getgenv().protectionConnection = nil
        end
        getgenv().AntiT = false
    end
end)


-- Collect All Orbs Button
Window:Button("Collect All Orbs", function()
    spawn(function()
        local player = game.Players.LocalPlayer
        if player and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local orbs = game:GetService("Workspace").ExperienceOrbs:GetChildren()
                for _, orb in ipairs(orbs) do
                    if orb:IsA("Part") then
                        orb.CFrame = hrp.CFrame + Vector3.new(0, 5, 0)
                    end
                end
            end
        end
    end)
end)
-- Toggle for Auto Collect All Orbs
Window:Toggle("Auto Collect All Orbs", function(state)
    getgenv().autoCollectOrbs = state -- Store the toggle state in a global variable

    if state then
        spawn(function()
            while getgenv().autoCollectOrbs do
                pcall(function()
                    local player = game.Players.LocalPlayer
                    if player and player.Character then
                        local torso = player.Character:FindFirstChild("HumanoidRootPart")
                        if torso then
                            local orbs = game:GetService("Workspace").ExperienceOrbs:GetChildren()
                            for _, orb in ipairs(orbs) do
                                if orb:IsA("Part") then
                                    -- Teleport orb directly to the player's torso
                                    orb.CFrame = torso.CFrame + Vector3.new(0, 5, 0)
                                end
                            end
                        end
                    end
                end)

                -- Small delay to avoid excessive script execution
                wait(0.1)
            end
        end)
    end
end)
