-- Make sure Rayfield library is loaded properly
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create the Window
local Window = Rayfield:CreateWindow({
    Name = "(Scripters) God Script",
    LoadingTitle = "(Scripters) 2026 Hub",
    LoadingSubtitle = "by Scripter",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true 
    },
    KeySystem = true,
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "Get the key to fucking use it",
        FileName = "The Key",
        SaveKey = false,
        GrabKeyFromSite = true,
        Key = {"https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/Key"}
    }
})

-- Notify the user
Rayfield:Notify({
    Title = "Follow Scripter ON Roblox",
    Content = "Sell or Give out for fee is a ban",
    Duration = 5,
    Image = nil,
    Actions = { 
        Ignore = {
            Name = "Okay",
            Callback = function()
                print("The user tapped Okay!")
            end
        }
    },
})

-- Tabs Setup




local SelfTab = Window:CreateTab("Self", nil)
local SelfSection = SelfTab:CreateSection("")

local FarmTab = Window:CreateTab("Auto Farm", nil)
local FarmSection = FarmTab:CreateSection("")

local RapidTab = Window:CreateTab("Rapid", nil)
local RapidSection = RapidTab:CreateSection("")

local TargetTab = Window:CreateTab("Target", nil)
local TargetSection = TargetTab:CreateSection("")

local TeleTab = Window:CreateTab("Tele", nil)
local TeleSection = TeleTab:CreateSection("")

local StatTab = Window:CreateTab("Stats", nil)
local StatSection = StatTab:CreateSection("")

local PlayerTab = Window:CreateTab("Random", nil)
local PlayerSection = PlayerTab:CreateSection("")

local MainTab = Window:CreateTab("GUI Scripts", nil)
local MainSection = MainTab:CreateSection("")

local TeleportTab = Window:CreateTab("Teleport", nil)
local TeleportSection = TeleportTab:CreateSection("")

local SettingsTab = Window:CreateTab("Settings", nil)
local SettingsSection = SettingsTab:CreateSection("")






-- Main Scripts Buttons

local mainButton1 = MainTab:CreateButton({
    Name = "Age Of Scripts",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/LOLOLOLOLOLOL.lua"))()
    end
})

local mainButton2 = MainTab:CreateButton({
    Name = "Krnl Executor Neon",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/Custom%20Krnl.lua"))()
    end
})

local mainButton3 = MainTab:CreateButton({
    Name = "Mini Tools",
    Callback = function()
        loadstring(game:GetService('HttpService'):GetAsync("https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/mini%20tools.lua"))()
    end
})

local mainButton4 = MainTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:GetService('HttpService'):GetAsync("https://cdn.wearedevs.net/scripts/Infinite%20Yield.txt"))()  
    end
})

local mainButton5 = MainTab:CreateButton({
    Name = "Solara Hub v3",
    Callback = function()
        loadstring(game:GetService('HttpService'):GetAsync("https://cdn.wearedevs.net/scripts/Solara%20Hub%20v3.txt"))()
    end
})






-- Player Scripts Buttons

local playerButton1 = PlayerTab:CreateButton({
    Name = "Remove Legs",
    Callback = function()
        loadstring(game:GetService('HttpService'):GetAsync("https://cdn.wearedevs.net/scripts/Remove%20Legs.txt"))()
    end
})

local playerButton2 = PlayerTab:CreateButton({
    Name = "Fly",
    Callback = function()
        loadstring(game:GetService('HttpService'):GetAsync("https://cdn.wearedevs.net/scripts/Fly.txt"))()
    end
})

local playerButton3 = PlayerTab:CreateButton({
    Name = "Infinity Jump",
    Callback = function()
        loadstring(game:GetService('HttpService'):GetAsync("https://cdn.wearedevs.net/scripts/Infinite%20Jump.txt"))()
    end
})

local playerButton4 = PlayerTab:CreateButton({
    Name = "ESP",
    Callback = function()
        loadstring(game:GetService('HttpService'):GetAsync("https://cdn.wearedevs.net/scripts/WRD%20ESP.txt"))()
    end
})




SelfTab:CreateToggle({
    Name = "Enable Anti-Telekinesis",
    CurrentValue = false,
    Flag = "antiTtoggle",
    Callback = function(state)
        getgenv().AntiT = state

        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local LocalPlayer = Players.LocalPlayer
        local RunService = game:GetService("RunService")

        local Events = ReplicatedStorage:FindFirstChild("Events")
        local TeleEvent = Events and Events:FindFirstChild("ToggleTelekinesis")

        if not TeleEvent then
            warn("[Anti-Telekinesis] Event not found.")
            return
        end

        local function nuke()
            if not getgenv().AntiT or not TeleEvent then return end
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                pcall(function()
                    TeleEvent:InvokeServer(hrp.Position, false, char)
                end)
            end
        end

        local function stopThreads()
            for _, conn in pairs({ "AntiT_HB", "AntiT_Char" }) do
                if getgenv()[conn] then
                    getgenv()[conn]:Disconnect()
                    getgenv()[conn] = nil
                end
            end
        end

        if state then
            -- Run nuke as fast as possible on Heartbeat
            getgenv().AntiT_HB = RunService.Heartbeat:Connect(nuke)

            -- Run on character respawn
            getgenv().AntiT_Char = LocalPlayer.CharacterAdded:Connect(function()
                repeat
                    nuke()
                until not getgenv().AntiT
            end)
        else
            stopThreads()
        end
    end
})




-- TelePurge Script

-- State to control the toggle
local TelePurgeState = false

-- Function to disable other players' telekinesis features
local function disableOthers()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            pcall(function()
                -- Attempt to disable known globals
                local env = getrenv()
                if env.getgenv then
                    local g = env.getgenv()
                    if g.AntiT ~= nil then g.AntiT = false end
                    if g.AntiT_HB then g.AntiT_HB:Disconnect() g.AntiT_HB = nil end
                    if g.AntiT_RS then g.AntiT_RS:Disconnect() g.AntiT_RS = nil end
                    if g.AntiT_CharAdded then g.AntiT_CharAdded:Disconnect() g.AntiT_CharAdded = nil end
                    if g.AntiT_Char then g.AntiT_Char:Disconnect() g.AntiT_Char = nil end
                end
            end)
        end
    end
end

-- Loop to continuously run TelePurge
local function loopPurge()
    if getgenv().TelePurge_Running then return end
    getgenv().TelePurge_Running = true
    spawn(function()
        while getgenv().TelePurge do
            disableOthers()
            task.wait(0.2) -- Fast enough to keep others down, slow enough to not spike CPU
        end
    end)
end

-- Stop the TelePurge loop
local function stopPurge()
    getgenv().TelePurge_Running = false
end

-- Toggle function to enable/disable TelePurge
local function toggleTelePurge()
    if TelePurgeState then
        loopPurge()  -- Start TelePurge
    else
        stopPurge()  -- Stop TelePurge
    end
end

-- Add the toggle button in the UI
TeleTab:CreateToggle({
    Name = "Disable AntiTele",
    CurrentValue = TelePurgeState,
    Flag = "telePurgeToggle",
    Callback = function(value)
        TelePurgeState = value
        toggleTelePurge()
    end
})


-- Define the stuck detection logic as a function
local function checkAndReleaseIfStuck()
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then return end

    local lastPosition = HumanoidRootPart.Position
    local stuckTime = 0
    local threshold = 1 -- Time threshold (in seconds) to detect if you're stuck

    local function checkIfStuck()
        if HumanoidRootPart.Position == lastPosition then
            stuckTime = stuckTime + 1
        else
            stuckTime = 0
        end

        if stuckTime >= threshold then
            -- Release action: teleport the player or reset the position
            print("You're stuck! Releasing you...")
            HumanoidRootPart.CFrame = CFrame.new(lastPosition + Vector3.new(5, 0, 5)) -- move slightly to release (can adjust)
            stuckTime = 0 -- Reset stuck timer
        end

        lastPosition = HumanoidRootPart.Position -- Update the last position
    end

    -- Start monitoring the position
    local releaseLoop = game:GetService("RunService").Heartbeat:Connect(checkIfStuck)

    -- Stop monitoring after releasing
    task.wait(2) -- Keeps the loop active for 2 seconds, just in case it wasn't stuck immediately.
    releaseLoop:Disconnect()
end

-- Add a button in the Rayfield UI to trigger the stuck detection
SelfTab:CreateButton({
    Name = "Check if Stuck and Release",
    Callback = function()
        checkAndReleaseIfStuck()  -- Call the function when the button is pressed
    end
})
SelfTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Flag = "NoClipToggle",
    Callback = function(state)
        getgenv().NoClip = state
    end
})

-- NoClip Runtime Loop
game:GetService("RunService").Stepped:Connect(function()
    if getgenv().NoClip then
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    part.CanCollide = false
                end
            end
        end
    end
end)
TeleportTab:CreateButton({
    Name = "Teleport To Middle",
    Callback = function()
        -- Check if bring is enabled
        if _G.bring == true then
            local targetPlayer = game:GetService("Workspace")[_G.teleportplayer]

            if targetPlayer and targetPlayer:FindFirstChild("HumanoidRootPart") then
                local hrp = targetPlayer.HumanoidRootPart
                if hrp:FindFirstChild("telekinesisPosition") then
                    hrp.telekinesisPosition:Destroy()
                end
                hrp.CFrame = CFrame.new(-376, 94, 91)
            end

            -- Call ToggleTelekinesis event
            local char = game.Players[_G.teleportplayer] and game.Players[_G.teleportplayer].Character
            if char then
                game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, char)
            end
        else
            -- Teleport local player
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(-376, 94, 91)
            end
        end

        -- Run the post-teleport handler
        if typeof(breakvelocity) == "function" then
            breakvelocity()
        end
    end
})
FarmTab:CreateToggle({
    Name = "Auto Orb Farm",
    CurrentValue = false,
    Flag = "AutoOrbToggle",
    Callback = function(state)
        getgenv().ORBGIVE = state

        if state then
            spawn(function()
                local localPlayer = game.Players.LocalPlayer

                while getgenv().ORBGIVE do
                    if localPlayer and localPlayer.Character then
                        local hrp = localPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local targetPosition = hrp.Position
                            local orbs = game:GetService("Workspace").ExperienceOrbs:GetChildren()
                            local orbCount = 0

                            for _, orb in ipairs(orbs) do
                                if orb:IsA("Part") and orb.Parent then
                                    orb.CFrame = CFrame.new(targetPosition) * CFrame.new(0, 5, 0)
                                    orbCount += 1

                                    pcall(function()
                                        if orb:FindFirstChild("Touched") then
                                            orb.Touched:Fire()
                                        end
                                    end)

                                    if orbCount >= 10 then
                                        break
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})
local selectedStat = nil
local autoStatsDelay = 0.01  -- Default 10ms in seconds
getgenv().AutoStats = false

-- Dropdown for selecting a stat
StatTab:CreateDropdown({
    Name = "AutoStats",
    Options = {
        "vitality", "healing", "strength", "energy", "flight", "speed", 
        "climbing", "swinging", "fireball", "frost", "lightning", 
        "power", "telekinesis", "shield", "laserVision", "metalSkin"
    },
    CurrentOption = "",
    Callback = function(option)
        selectedStat = option
    end
})

-- Slider to set delay in milliseconds
StatTab:CreateSlider({
    Name = "AutoStats Delay (ms)",
    Range = {1, 1000},
    Increment = 1,
    Suffix = "ms",
    CurrentValue = 10,
    Callback = function(value)
        autoStatsDelay = value / 1000  -- Convert ms to seconds
    end
})

-- Toggle to start/stop AutoStats
StatTab:CreateToggle({
    Name = "Toggle AutoStats",
    CurrentValue = false,
    Callback = function(state)
        getgenv().AutoStats = state

        if state then
            if not selectedStat then
                warn("[AutoStats] No stat selected!")
                return
            end

            task.spawn(function()
                while getgenv().AutoStats do
                    task.wait(autoStatsDelay)
                    pcall(function()
                        for _ = 1, 1000 do
                            game:GetService("ReplicatedStorage").Events.UpgradeAbility:InvokeServer(selectedStat)
                        end
                    end)
                end
            end)
        end
    end
})

-- Button to reset stats
StatTab:CreateButton({
    Name = "Reset Stats",
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage").Events.ResetStats:InvokeServer()
            print("[AutoStats] Stats have been reset.")
        end)
    end
})

-- Button to auto-select best stat by role
StatTab:CreateButton({
    Name = "Auto Select Recommended Stat",
    Callback = function()
        local recommended = "strength"
        local role = game.Players.LocalPlayer.Character:FindFirstChild("Role")
        if role then
            if role.Value == "Tank" then
                recommended = "vitality"
            elseif role.Value == "DPS" then
                recommended = "strength"
            elseif role.Value == "Healer" then
                recommended = "healing"
            end
        end
        selectedStat = recommended
        print("[AutoStats] Recommended stat selected:", recommended)
    end
})

local player = game.Players.LocalPlayer

local function setupFarm(name, toggleKey)
    FarmTab:CreateToggle({
        Name = name .. " Farm",
        CurrentValue = false,
        Callback = function(state)
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end

            local returnKey = toggleKey .. "ReturnPos"
            local runningKey = toggleKey

            if state then
                getgenv()[runningKey] = true
                getgenv()[returnKey] = root.CFrame

                task.spawn(function()
                    while getgenv()[runningKey] do
                        task.wait(0.2)
                        pcall(function()
                            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            if not root then return end

                            local closestTarget = nil
                            local closestDistance = math.huge

                            -- Find the closest target (Civilian, Police, Thug, etc.)
                            for _, v in ipairs(workspace:GetChildren()) do
                                if v:IsA("Model") and v.Name == name and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                    local targetRoot = v:FindFirstChild("HumanoidRootPart")
                                    if targetRoot then
                                        local distance = (root.Position - targetRoot.Position).Magnitude
                                        if distance < closestDistance then
                                            closestDistance = distance
                                            closestTarget = v
                                        end
                                    end
                                end
                            end

                            -- If we found a target and it's within punching range, punch
                            if closestTarget and closestDistance <= 5 then
                                game.ReplicatedStorage.Events.Punch:FireServer(0, 0.1, 1)
                            end

                            -- If we found a target, teleport to it
                            if closestTarget then
                                root.CFrame = closestTarget.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                            end
                        end)
                    end
                end)
            else
                getgenv()[runningKey] = false
                task.delay(0.2, function()
                    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if root and getgenv()[returnKey] then
                        root.CFrame = getgenv()[returnKey]  -- Teleport back to the original position
                    end
                end)
            end
        end
    })
end

-- Create the farm toggles using shared logic
setupFarm("Civilian", "Civilian")
setupFarm("Police", "Police")
setupFarm("Thug", "Thug")






local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local respawnPosition = nil
local deathCheckEnabled = false

-- Set current position as spawn
local function setSpawnPoint()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        respawnPosition = player.Character.HumanoidRootPart.Position
        deathCheckEnabled = true
    end
end

-- Teleport to saved spawn
local function teleportToSpawn()
    if respawnPosition and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(respawnPosition)
    end
end

-- Handle death
local function onPlayerDied()
    if deathCheckEnabled and respawnPosition then
        task.wait(0.01)
        teleportToSpawn()
    end
end

-- Handle respawn
local function onPlayerRespawned()
    if respawnPosition then
        task.wait(0.1)
        teleportToSpawn()
    end
end

-- Monitor death loop
local function monitorDeath()
    while deathCheckEnabled do
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            humanoid.Died:Connect(onPlayerDied)
        end
        task.wait(0.01)
    end
end

-- F2 keybind to teleport
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F2 then
        teleportToSpawn()
    end
end)

-- On character respawn
player.CharacterAdded:Connect(function()
    onPlayerRespawned()
end)

-- Rayfield Button
SelfTab:CreateButton({
    Name = "Set Spawn Point",
    Callback = function()
        setSpawnPoint()
        task.spawn(monitorDeath)
    end
})

-- Services
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ToggleBlocking = ReplicatedStorage:WaitForChild("Events"):WaitForChild("ToggleBlocking")

-- Variables
local infJumpEnabled = false
local infJumpConnection = nil
local shieldBurstActive = false
local shieldBurstCoroutine = nil

-- Infinite Jump Toggle
SelfTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJumpToggle",
    Callback = function(state)
        infJumpEnabled = state

        if infJumpEnabled then
            -- Connect to JumpRequest
            infJumpConnection = UserInputService.JumpRequest:Connect(function()
                local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            -- Disconnect to disable
            if infJumpConnection then
                infJumpConnection:Disconnect()
                infJumpConnection = nil
            end
        end
    end
})

SelfTab:CreateToggle({
    Name = "Shield Burst - Age Of Heroes",
    CurrentValue = false,
    Flag = "ShieldBurstToggle",
    Callback = function(state)
        shieldBurstActive = state

        if shieldBurstActive then
            shieldBurstCoroutine = coroutine.create(function()
                local burstCount = 0
                while burstCount < 30 and shieldBurstActive do
                    ToggleBlocking:FireServer(true)
                    wait(0.01)
                    burstCount += 1
                end

                -- Keep shield ON after 20 bursts
                if shieldBurstActive then
                    ToggleBlocking:FireServer(true)
                end
            end)
            coroutine.resume(shieldBurstCoroutine)
        else
            -- Turn off shield when toggled off
            ToggleBlocking:FireServer(false)
        end
    end
})


local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Define punch speed settings
local punchSpeeds = {
    ["Ultra Slow"] = {count = 20, delay = 0.2},
    ["Slow"]       = {count = 30, delay = 0.1},
    ["Normal"]     = {count = 40, delay = 0.05},
    ["Fast"]       = {count = 50, delay = 0.03},
    ["Super Fast"] = {count = 60, delay = 0.015},
    ["Ultra Fast"] = {count = 75, delay = 0.01}
}

-- Default speed setting
getgenv().punchSpeedSetting = "Normal"

-- Function to perform the rapid punch
local function rapidPunch()
    local speed = punchSpeeds[getgenv().punchSpeedSetting]
    for _ = 1, speed.count do
        ReplicatedStorage.Events.Punch:FireServer(0, 0.1, 1)
        task.wait(speed.delay)
    end
end

-- Function to handle input
local function onInputEnded(input, gameProcessed)
    if not gameProcessed and getgenv().superrapidpunch and input.UserInputType == Enum.UserInputType.MouseButton1 then
        rapidPunch()
    end
end

-- Toggle to enable/disable rapid punch
RapidTab:CreateToggle({
    Name = "Enable Super Rapid Punch",
    CurrentValue = false,
    Callback = function(state)
        getgenv().superrapidpunch = state
        if state then
            getgenv().superrapidpunch_conn = UserInputService.InputEnded:Connect(onInputEnded)
        else
            if getgenv().superrapidpunch_conn then
                getgenv().superrapidpunch_conn:Disconnect()
                getgenv().superrapidpunch_conn = nil
            end
        end
    end,
})

-- Dropdown to choose punch speed
RapidTab:CreateDropdown({
    Name = "Punch Speed",
    Options = {"Ultra Slow", "Slow", "Normal", "Fast", "Super Fast", "Ultra Fast"},
    CurrentOption = "Normal",
    Callback = function(Selected)
        getgenv().punchSpeedSetting = Selected
    end,
})


-- Central teleport function
local function teleportTo(position)
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(position)
        print("Teleported to location: " .. tostring(position))
    else
        warn("Character or HumanoidRootPart not found!")
    end
end

-- Create Buttons
TeleportTab:CreateButton({
    Name = "Teleport to Bar",
    Callback = function()
        teleportTo(Vector3.new(-1313, 197, 149))
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Corner-4",
    Callback = function()
        teleportTo(Vector3.new(2810, 102, 2821))
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Corner-3",
    Callback = function()
        teleportTo(Vector3.new(-3650, 97, 2764))
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Corner-2",
    Callback = function()
        teleportTo(Vector3.new(-3757, 97, -3801))
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Corner-1",
    Callback = function()
        teleportTo(Vector3.new(2773, 96, -4996))
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Secret Spot",
    Callback = function()
        teleportTo(Vector3.new(-1685.116, 128.436, -1405.940))
    end,
})
-- Central teleport function
local function teleportPlayerTo(location)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(location)
        print("Teleported to location: " .. tostring(location))
    else
        warn("HumanoidRootPart not found!")
    end
end

-- Buttons
TeleportTab:CreateButton({
    Name = "Teleport to Hidden Location",
    Callback = function()
        teleportPlayerTo(Vector3.new(-1742.1266, 442.5756, 1210.2801))
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Chair",
    Callback = function()
        teleportPlayerTo(Vector3.new(-1295.6533, 196.8809, 175.9001))
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Middle Corner",
    Callback = function()
        teleportPlayerTo(Vector3.new(-553.23, 94.34, 89.34))
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to New Location",
    Callback = function()
        teleportPlayerTo(Vector3.new(-428.08, 110.59, 434.46))
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Middle Bottom",
    Callback = function()
        teleportPlayerTo(Vector3.new(-386.02, 94.34, 430.05))
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Predefined Spot",
    Callback = function()
        teleportPlayerTo(Vector3.new(2810, 102, 2821))
    end,
})








-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Variables
local player = Players.LocalPlayer
local respawnPosition = nil
local deathCheckEnabled = false

-- Functions
local function setSpawnPoint()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        respawnPosition = player.Character.HumanoidRootPart.Position
        deathCheckEnabled = true
        print("Spawn point set at: " .. tostring(respawnPosition))
    end
end

local function teleportToSpawn()
    if respawnPosition and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(respawnPosition)
        print("Teleported to spawn point.")
    end
end

local function onPlayerDied()
    if deathCheckEnabled and respawnPosition then
        task.wait(0.01)
        teleportToSpawn()
    end
end

local function onPlayerRespawned()
    if respawnPosition then
        task.wait(0.1)
        teleportToSpawn()
    end
end

local function monitorDeath()
    while deathCheckEnabled do
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            humanoid.Died:Connect(onPlayerDied)
        end
        wait(0.01)
    end
end

-- F2 Hotkey to teleport
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F2 then
        teleportToSpawn()
    end
end)

-- Teleport on respawn
player.CharacterAdded:Connect(function()
    onPlayerRespawned()
end)

-- Rayfield Button
SelfTab:CreateButton({
    Name = "Set Spawn Point",
    Callback = function()
        setSpawnPoint()
        spawn(monitorDeath)
    end,
})








-- Variables
local mouse = game.Players.LocalPlayer:GetMouse()
local plrlist = {}
_G.CToggle = false
getgenv().CarryP = false

-- Dummy getNearPlayer function (you should replace this with your actual implementation)
function getNearPlayer(range)
    plrlist = {} -- Clear previous list
    for _, v in ipairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (v.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance <= range then
                table.insert(plrlist, v)
            end
        end
    end
end

-- Rayfield Button
TargetTab:CreateButton({
    Name = "Mouse Control",
    Callback = function()
        if not _G.CToggle then
            _G.CToggle = true
            getgenv().CarryP = true
            getNearPlayer(99) -- Adjust range as needed

            spawn(function()
                while getgenv().CarryP do
                    wait(0.1)
                    for _, v in pairs(plrlist) do
                        if v ~= game.Players.LocalPlayer then
                            local targetPlayer = game.Players:FindFirstChild(v.Name)
                            if targetPlayer and targetPlayer.Character then
                                local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    hrp.CFrame = CFrame.new(mouse.Hit.X, mouse.Hit.Y, mouse.Hit.Z)
                                end
                            end
                        end
                    end
                end
            end)
        else
            _G.CToggle = false
            getgenv().CarryP = false
            plrlist = {}
            print("Mouse Control disabled.")
        end
    end,
})

-- Player List Function
local dropdown = {}
function GetList()
    dropdown = {}
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer then
            table.insert(dropdown, v.Name)
        end
    end
end

GetList()

-- Dropdown
local playerDropdown = TargetTab:CreateDropdown({
    Name = "Select Player",
    Options = dropdown,
    CurrentOption = "",
    Callback = function(option)
        _G.tplayer = option
    end,
})

-- Refresh Button
TargetTab:CreateButton({
    Name = "Refresh Player List",
    Callback = function()
        GetList()
        playerDropdown:Refresh(dropdown)
    end,
})

-- Teleport Function
local function teleportToPlayer(name)
    local localPlayer = game.Players.LocalPlayer
    local target = game.Players:FindFirstChild(name)

    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and
       localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        localPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        localPlayer.Character.HumanoidRootPart.Velocity = Vector3.zero
    else
        warn("Teleport failed: Invalid target.")
    end
end

-- Teleport Button
TargetTab:CreateButton({
    Name = "Teleport To Player",
    Callback = function()
        if _G.tplayer then
            teleportToPlayer(_G.tplayer)
        else
            warn("No player selected.")
        end
    end,
})

-- U Keybind for teleport
game:GetService("UserInputService").InputBegan:Connect(function(input, isProcessed)
    if not isProcessed and input.KeyCode == Enum.KeyCode.U then
        if _G.tplayer then
            teleportToPlayer(_G.tplayer)
        else
            warn("No player selected.")
        end
    end
end)

-- Spectate Toggle
TargetTab:CreateToggle({
    Name = "Spectate Player",
    CurrentValue = false,
    Callback = function(state)
        getgenv().watch = state

        local function getTargetPlayer()
            local target = game.Players:FindFirstChild(_G.tplayer)
            if target and target.Character and target.Character:FindFirstChild("Humanoid") then
                return target
            end
            return nil
        end

        if getgenv().watch then
            getgenv().spectateConnection = game:GetService("RunService").RenderStepped:Connect(function()
                local target = getTargetPlayer()
                if target then
                    workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
                else
                    warn("Invalid target, stopping spectate.")
                    workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                    if getgenv().spectateConnection then
                        getgenv().spectateConnection:Disconnect()
                        getgenv().spectateConnection = nil
                    end
                end
            end)
        else
            if getgenv().spectateConnection then
                getgenv().spectateConnection:Disconnect()
                getgenv().spectateConnection = nil
            end
            workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        end
    end
})

-- Fling Toggle
TargetTab:CreateToggle({
    Name = "Fling Player",
    CurrentValue = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

        local root = player.Character.HumanoidRootPart
        getgenv().fling = state

        if state then
            -- Apply fling
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CustomPhysicalProperties = PhysicalProperties.new(math.huge, 0.3, 0.5)
                end
            end

            local bav = Instance.new("BodyAngularVelocity", root)
            bav.AngularVelocity = Vector3.new(0, 1000, 0)
            bav.MaxTorque = Vector3.new(0, math.huge, 0)
            bav.P = 10000

            task.spawn(function()
                while getgenv().fling and player and player.Character do
                    task.wait()
                    pcall(function()
                        for _, model in ipairs(workspace:GetChildren()) do
                            if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
                                if model.Name == _G.tplayer then
                                    root.CFrame = model.HumanoidRootPart.CFrame
                                end
                            end
                        end
                    end)

                    for _, bp in ipairs(player.Character:GetChildren()) do
                        if bp:IsA("BasePart") then
                            bp.CanCollide = false
                            bp.Massless = true
                            bp.Velocity = Vector3.zero
                        end
                    end
                end
            end)
        else
            -- Reset
            for _, obj in ipairs(player.Character:GetDescendants()) do
                if obj:IsA("BodyAngularVelocity") then obj:Destroy() end
                if obj:IsA("BasePart") then
                    obj.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
                    obj.CanCollide = true
                    obj.Massless = false
                end
            end
            if root then
                root.Velocity = Vector3.zero
            end
        end
    end
})
-- Crash Trigger (Target Only)
TargetTab:CreateButton({
    Name = "Allow Target To Crash",
    Callback = function()
        spawn(function()
            local target = game.Players:FindFirstChild(_G.tplayer)
            if target then
                target.Chatted:Connect(function(msg)
                    msg = string.lower(msg)
                    if msg == "crash" or msg == "crash server" or msg == "cs" then
                        for _ = 1, 15000 do
                            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true")
                            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer()
                        end
                    end
                end)
            else
                warn("Target not found.")
            end
        end)
    end,
})

-- Crash Trigger (All Players)
TargetTab:CreateButton({
    Name = "Allow All Players To Crash",
    Callback = function()
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer then
                plr.Chatted:Connect(function(msg)
                    msg = string.lower(msg)
                    if msg == "crash" or msg == "crash server" or msg == "cs" then
                        for _ = 1, 15000 do
                            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true")
                            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer()
                        end
                    end
                end)
            end
        end
    end,
})

TargetTab:CreateButton({
    Name = "Allow Target to Kill Players (say: kill <username>)",
    Callback = function()
        local function GetPlayer(input)
            for _, Player in pairs(game:GetService("Players"):GetPlayers()) do
                if string.lower(input) == string.sub(string.lower(Player.Name), 1, #input) then
                    return Player
                end
            end
        end

        spawn(function()
            local target = game.Players[_G.tplayer]
            if not target then
                warn("Target player not found.")
                return
            end

            target.Chatted:Connect(function(Message)
                local Chat = string.split(Message, " ")
                if string.lower(Chat[1]) == "kill" and Chat[2] then
                    local varX = game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X
                    local varY = game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y
                    local varZ = game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z
                    local pos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

                    getgenv().breakv = true
                    game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", true)

                    task.spawn(function()
                        local KillingTime = 0
                        repeat
                            KillingTime += 1
                            task.wait()

                            spawn(function()
                                pcall(function()
                                    for _, v in pairs(game.Workspace:GetChildren()) do
                                        local victim = GetPlayer(Chat[2])
                                        if victim and victim.Character and v == victim.Character and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                            local p1 = game.Players.LocalPlayer.Character.HumanoidRootPart
                                            p1.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)

                                            for _ = 1, 4 do
                                                spawn(function()
                                                    for _ = 1, 7 do
                                                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                                                    end
                                                end)
                                            end

                                            spawn(function()
                                                local LookVector = game.Workspace.Camera.CFrame.LookVector
                                                game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, true)
                                                game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, false)
                                            end)
                                        end
                                    end
                                end)
                            end)

                        until KillingTime == 40

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(varX, varY, varZ)
                        spawn(function()
                            getgenv().breakv = false
                            wait(0.2)
                            if typeof(breakvelocity) == "function" then
                                breakvelocity()
                            end
                        end)
                    end)
                end
            end)
        end)
    end,
})
TargetTab:CreateToggle({
    Name = "Kill Player",
    Callback = function(state)
        if state then
            -- Enable global toggles
            getgenv().killplr = true
            getgenv().breakv = true

            -- Validate the target player
            local targetPlayer = game.Players:FindFirstChild(_G.tplayer)
            if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                warn("Invalid target player: " .. tostring(_G.tplayer))
                return
            end

            -- Store the target's position
            local playerPosition = targetPlayer.Character.HumanoidRootPart.Position

            -- Break velocity loop
            spawn(function()
                while getgenv().breakv do
                    pcall(function()
                        if typeof(breakvelocity) == "function" then
                            breakvelocity() -- Ensure breakvelocity() is defined elsewhere
                        end
                        game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", true)
                    end)
                    task.wait(1)
                end
            end)

            -- Kill player loop
            spawn(function()
                while getgenv().killplr do
                    task.wait(0.5) -- Adjust wait time for smoother execution

                    -- Teleport to target player and attack
                    pcall(function()
                        local localPlayer = game.Players.LocalPlayer
                        for _, obj in ipairs(game.Workspace:GetChildren()) do
                            if obj.Name == _G.tplayer and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                                local hrp = obj:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    localPlayer.Character.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 0, 1)
                                end
                            end
                        end
                    end)

                    -- Fire punch events
                    pcall(function()
                        for _ = 1, 10 do -- Fire the punch event 10 times
                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                        end
                    end)
                end
            end)
        else
            -- Disable global toggles
            getgenv().killplr = false
            getgenv().breakv = false
        end
    end,
})
-- Stick to Player Toggle
TargetTab:CreateToggle({
    Name = "Stick To Player",
    Callback = function(state)
        if state then
            getgenv().loopgoto = true
            local player = game.Players.LocalPlayer
            local varX = player.Character.HumanoidRootPart.Position['X']
            local varY = player.Character.HumanoidRootPart.Position['Y']
            local varZ = player.Character.HumanoidRootPart.Position['Z']
            wait()
            local p1 = player.Character.HumanoidRootPart
            getgenv().breakv = true

            -- Break velocity loop
            spawn(function()
                while getgenv().breakv do
                    wait(1)
                    breakvelocity()
                end
            end)

            -- Stick to player loop
            while getgenv().loopgoto do
                task.wait()
                spawn(function()
                    pcall(function()
                        for i, v in pairs(game.Workspace:GetChildren()) do
                            if v.Name == _G.tplayer and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                            end
                        end
                    end)
                end)
                spawn(function()
                    if not getgenv().loopgoto then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(varX, varY, varZ)
                    end
                end)
            end
        else
            -- Stop sticking to player
            spawn(function()
                getgenv().breakv = false
                wait(0.2)
                getgenv().loopgoto = false
                wait(0.1)
                getgenv().loopgoto = true
                breakvelocity()
            end)
        end
    end,
})

-- Anti-Telekinesis Toggle
TargetTab:CreateToggle({
    Name = "Gives Player Anti-Tele",
    Description = "Gives Assigned Player Anti Tele",
    Callback = function(state)
        local playerName = _G.tplayer
        local player = game:GetService("Players"):FindFirstChild(playerName)
        
        if not player then
            warn("Player not found: " .. tostring(playerName))
            return
        end

        getgenv().at = state

        if state then
            -- Activate anti-telekinesis
            spawn(function()
                while getgenv().at do
                    pcall(function()
                        if player.Character then
                            -- Disable telekinesis for the player
                            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(
                                Vector3.new(0, 0, 0), -- No specific position
                                false,                -- Disable telekinesis
                                player.Character     -- Target player's character
                            )
                        end
                    end)
                    task.wait(0.1) -- Wait briefly before next check
                end
            end)
        else
            -- Deactivate anti-telekinesis
            print("Anti-Telekinesis deactivated for " .. tostring(playerName))
        end
    end,
})
-- TP Orbs to Players in Telekinesis Toggle
TargetTab:CreateToggle({
    Name = "TP Orbs to Players in Telekinesis",
    Callback = function(state)
        function TpOrbs()
            if state then
                -- Call function to get nearby players
                getNearPlayer(999999)
                getgenv().ORBGIVE = true
                while getgenv().ORBGIVE do
                    for _, v in pairs(plrlist) do
                        if v ~= player then
                            local targetCharacter = game.Players[v.Name] and game.Players[v.Name].Character
                            if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
                                local hrp = targetCharacter.HumanoidRootPart
                                for _, orb in pairs(game:GetService("Workspace").ExperienceOrbs:GetChildren()) do
                                    orb.CFrame = hrp.CFrame
                                end
                            end
                        end
                        wait()
                    end
                    wait()
                end
            else
                getgenv().ORBGIVE = false
            end
        end

        spawn(function()
            TpOrbs()
        end)
    end,
})

-- Laser Toggle
TargetTab:CreateToggle({
    Name = "Laser",
    Callback = function(state)
        spawn(function()
            local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision

            if state then
                -- Activate Laser Vision
                getgenv().LaserL = true
                local part = event:InvokeServer(true) -- Activate laser and get the part reference

                -- Start the laser targeting logic
                if part then
                    while getgenv().LaserL do
                        task.wait()
                        local targetPlayer = game.Players:FindFirstChild(_G.tplayer)

                        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            -- Set the laser's position to the target's HumanoidRootPart position
                            part.Position = targetPlayer.Character.HumanoidRootPart.Position
                        end
                    end
                    -- Turn off laser when the loop exits
                    event:InvokeServer(false)
                end
            else
                -- Deactivate Laser Vision
                getgenv().LaserL = false
            end
        end)
    end,
})
-- Laser From Sky Toggle
TargetTab:CreateToggle({
    Name = "Laser From Sky",
    Description = "Laser Beams Assigned Player From Sky",
    Callback = function(state)
        spawn(function()
            if state then
                local orbX = player.Character.HumanoidRootPart.Position.X
                local orbY = player.Character.HumanoidRootPart.Position.Y
                local orbZ = player.Character.HumanoidRootPart.Position.Z
                
                -- Move the player high into the sky
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(orbX, 5000, orbZ)
                
                -- Set up Laser functionality
                getgenv().LaserL = true
                wait(0.2)
                player.Character.HumanoidRootPart.Anchored = true
                
                -- Start laser logic
                coroutine.resume(coroutine.create(function()
                    local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                    local part = event:InvokeServer(true)
                    getgenv().LaserL = true
                    
                    while getgenv().LaserL and part and _G.tplayer do
                        wait()
                        local target = game.Players:FindFirstChild(_G.tplayer)
                        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                            part.Position = target.Character.HumanoidRootPart.Position
                        end
                    end
                    event:InvokeServer(false)
                end))
            else
                -- Reset player position and stop laser if toggle is off
                player.Character.HumanoidRootPart.Anchored = false
                spawn(function()
                    getgenv().LaserL = false
                end)
                
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(orbX, orbY, orbZ)
                breakvelocity()
            end
        end)
    end,
})
-- Give Orbs Toggle
TargetTab:CreateToggle({
    Name = "Give Orbs",
    Description = "Position orbs above the target player's head",
    Callback = function(state)
        spawn(function()
            if state then
                getgenv().ORBGIVE = true
                while getgenv().ORBGIVE do
                    local targetPlayer = game.Players:FindFirstChild(_G.tplayer)
                    if targetPlayer and targetPlayer.Character then
                        local character = targetPlayer.Character
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        
                        if hrp then
                            for _, orb in pairs(game:GetService("Workspace").ExperienceOrbs:GetChildren()) do
                                -- Position the orb slightly above the player's head
                                local orbPosition = hrp.Position + Vector3.new(0, 5, 0) -- Adjust height as needed
                                orb.CFrame = CFrame.new(orbPosition)
                            end
                        end
                    end
                    wait()
                end
            else
                getgenv().ORBGIVE = false
            end
        end)
    end,
})
-- Remove Gyro Button
TargetTab:CreateButton({
    Name = "Remove Gyro",
    Description = "Remove Gyro and reset humanoid properties for target player",
    Callback = function()
        local targetPlayer = game:GetService("Workspace")[_G.tplayer]
        if targetPlayer then
            local hrp = targetPlayer:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Destroy Gyro and Position objects
                local gyro = hrp:FindFirstChild("telekinesisGyro")
                if gyro then gyro:Destroy() end
                local position = hrp:FindFirstChild("telekinesisPosition")
                if position then position:Destroy() end
            end

            local humanoid = targetPlayer:FindFirstChild("Humanoid")
            if humanoid then
                -- Reset humanoid properties
                humanoid.PlatformStand = false
                humanoid.WalkSpeed = 200
                humanoid.JumpPower = 150
            end
        end
    end,
})
-- Disable Telekinesis Toggle
TeleTab:CreateToggle({
    Name = "Disable Telekinesis",
    Description = "Disables Telekinesis for all players",
    Callback = function(state)
        spawn(function()
            if state then
                getgenv().LToggle = true
                local Players = game:GetService("Players")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")

                -- Disable telekinesis for all players
                for _, player in pairs(Players:GetPlayers()) do
                    spawn(function()
                        while getgenv().LToggle do
                            wait()
                            -- Disables telekinesis for the player's character
                            ReplicatedStorage.Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, player.Character)
                        end
                    end)
                end
            else
                getgenv().LToggle = false
            end
        end)
    end,
})
-- Carry Player Toggle
SettingsSection:CreateToggle({
    Name = "Carry Player",
    Description = "Toggle to carry the selected player",
    Default = false,
    Callback = function(state)
        if state then
            -- When the toggle is ON
            spawn(function()
                getNearPlayer(99)  -- Get nearby players
                wait()
                _G.CToggle = true
                getgenv().CarryP = true

                -- Start carrying players
                while CarryP do
                    wait()

                    spawn(function()
                        for i, v in pairs(plrlist) do
                            -- Skip the local player
                            if v == player then
                                -- Skip the local player
                            else
                                -- Carry the player by modifying their position
                                Xt = player.Character.HumanoidRootPart.Position['X']
                                Yt = player.Character.HumanoidRootPart.Position['Y']
                                Zt = player.Character.HumanoidRootPart.Position['Z']
                                
                                -- Set the player's telekinesis position (carrying effect)
                                game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition.Position = Vector3.new(Xt, Yt + 8, Zt + 5)
                            end
                        end
                    end)
                end
            end)
        else
            -- When the toggle is OFF, stop carrying players
            spawn(function()
                _G.CToggle = false
                plrlist = {}
                getgenv().CarryP = false
            end)
        end
    end,
})

