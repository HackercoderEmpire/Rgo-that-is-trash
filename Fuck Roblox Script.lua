local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Age Of Fuck Hub", "Synapse")



local ATab = Window:NewTab("Main");
local ASection = ATab:NewSection("Main Tools Lol");
local Tab = Window:NewTab("AutoFarm");
local MainSection = Tab:NewSection("AutoFarm Menu");
local TargetTab = Window:NewTab("TP Player");
local TargetSection = TargetTab:NewSection("Teleport To Player");
local STab = Window:NewTab("Self");
local SSection = STab:NewSection("Self Menu");
local StatTab = Window:NewTab("AutoStat Menu");
local StatSection = StatTab:NewSection("AutoStat Menu");
local TTab = Window:NewTab("Teleport Menu");
local TSection = TTab:NewSection("Teleport Menu");
local KTab = Window:NewTab("Keybind Menu");
local KSection = KTab:NewSection("Keybind Menu");
local MTab = Window:NewTab("Server Fucker");
local MSection = MTab:NewSection("Server - Player - Modifyer");
local GTab = Window:NewTab("Chat modes");
local GSection = GTab:NewSection("Chat spam/spoof - Infinite Yield");


























local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PunchEvent = ReplicatedStorage.Events.Punch

-- Function to handle rapid punching
local function handleRapidPunch(toggleState, punchType, duration, power, repetitions)
    if toggleState then
        getgenv().rapidState = true
        local function onInputEnded(inputObject, gameProcessedEvent)
            if gameProcessedEvent then return end
            if getgenv().rapidState and inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                spawn(function()
                    for _ = 1, repetitions do
                        PunchEvent:FireServer(punchType, duration, power)
                        task.wait(0.05) -- Small delay between punches to reduce lag
                    end
                end)
            end
        end
        -- Connect the input event
        UserInputService.InputEnded:Connect(onInputEnded)
    else
        getgenv().rapidState = false
    end
end

-- Mini Rapid Punch Toggle
SSection:NewToggle("Mini Rapid Punch", "", function(state)
    handleRapidPunch(state, 2, 0.1, 4, 1)
end)

-- Rapid Punch Toggle
SSection:NewToggle("Rapid Punch", "", function(state)
    handleRapidPunch(state, 0, 0.2, 1, 7)
end)

-- Rapid Heavy Punch Toggle
SSection:NewToggle("Rapid Heavy Punch", "", function(state)
    handleRapidPunch(state, 0.4, 0.1, 1, 15)
end)

-- Godly Rapid Punch Toggle
SSection:NewToggle("Godly Rapid Punch", "", function(state)
    if state then
        getgenv().superrapid = true
        local function onInputEnded(inputObject, gameProcessedEvent)
            if gameProcessedEvent or not getgenv().superrapid then return end
            if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                spawn(function()
                    local punchEvent = game:GetService("ReplicatedStorage").Events.Punch
                    for i = 1, 100 do -- Adjust the number of punches here
                        punchEvent:FireServer(0, 0.1, 1)
                    end
                end)
            end
        end
        UserInputService.InputEnded:Connect(onInputEnded)
    else
        getgenv().superrapid = false
    end
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Define the levels for ground crack strength
local levels = {
    {name = "Light", delay = 0.5},
    {name = "Medium", delay = 0.3},
    {name = "Heavy", delay = 0.1},
    {name = "Insane", delay = 0.05}
}

local currentLevel = 1 -- Default to Light level
local crackLoop = nil -- Variable to store the coroutine
local isToggled = false -- Track the toggle state

-- Dropdown to select crack strength
ASection:NewDropdown("Crack Strength", "Select ground crack strength", {"Light", "Medium", "Heavy", "Insane"}, function(selected)
    for i, level in ipairs(levels) do
        if level.name == selected then
            currentLevel = i
            print("Strength set to:", levels[currentLevel].name)
            break
        end
    end
end)

-- Toggle to enable or disable ground crack effect
ASection:NewToggle("Ground Crack Effect", "Toggle annoying ground cracks", function(state)
    isToggled = state -- Update the toggle state

    if isToggled then
        -- Start the effect when toggled on
        if crackLoop == nil then
            crackLoop = coroutine.create(function()
                while isToggled do
                    local level = levels[currentLevel]
                    ReplicatedStorage.Events.GroundCrack:FireServer() -- Trigger ground crack effect
                    wait(level.delay) -- Wait based on the selected strength delay
                end
            end)
            coroutine.resume(crackLoop)
        end
    else
        -- Stop the effect when toggled off
        if crackLoop then
            -- Explicitly stop the coroutine
            crackLoop = nil -- Terminate the coroutine
        end
    end
end)
SSection:NewToggle("NPC ESP", "Enable or disable NPC ESP", function(state)
    _G.NPCESP = state
    -- Function to apply ESP to NPCs
    local function applyNPCESP(npc)
        local npcModels = {"Police", "Thug", "Citizen"}
        for _, npcModel in pairs(npcModels) do
            if npc.Name == npcModel then
                -- Create ESP box or highlight with pink color
                local box = Instance.new("Highlight", npc)
                box.FillColor = Color3.fromRGB(255, 105, 180) -- Pink box for NPCs
            end
        end
    end

    -- Apply ESP to existing NPCs
    if _G.NPCESP then
        for _, npc in pairs(workspace:GetChildren()) do
            applyNPCESP(npc)  -- Apply to already existing NPCs
        end

        -- Monitor new NPCs that are added to the workspace (e.g., respawned NPCs)
        workspace.ChildAdded:Connect(function(child)
            if child:IsA("Model") then
                applyNPCESP(child)  -- Apply ESP to the newly added NPC
            end
        end)
    else
        -- Remove ESP from existing NPCs
        for _, npc in pairs(workspace:GetChildren()) do
            if npc:FindFirstChildOfClass("Highlight") then
                npc:FindFirstChildOfClass("Highlight"):Destroy()
            end
        end

        -- Stop monitoring new NPCs
        workspace.ChildAdded:Disconnect()
    end
end)


SSection:NewButton("Collect All Orbs", "Click to collect all orbs at once for XP", function()
    spawn(function()
        pcall(function()
            local localPlayer = game.Players.LocalPlayer  -- Reference the local player
            if localPlayer and localPlayer.Character then
                local hrp = localPlayer.Character:FindFirstChild("HumanoidRootPart")  -- Get the HumanoidRootPart
                if hrp then
                    local targetPosition = hrp.Position  -- Store player position
                    local orbs = game:GetService("Workspace").ExperienceOrbs:GetChildren()  -- Get all orbs

                    -- Loop through all orbs and move them to the player
                    for _, orb in ipairs(orbs) do
                        if orb:IsA("Part") and orb.Parent then
                            -- Move orb directly to the player's position
                            orb.CFrame = CFrame.new(targetPosition) * CFrame.new(0, 5, 0)  -- Hover above player
                        end
                    end
                end
            end
        end)
    end)
end)

SSection:NewToggle("Auto Collect All Orbs", "Collect all orbs at once for XP", function(state)
    spawn(function()
        if state then
            getgenv().ORBGIVE = true
            local localPlayer = game.Players.LocalPlayer  -- Reference the local player
            
            while getgenv().ORBGIVE do
                pcall(function()
                    if localPlayer and localPlayer.Character then
                        local hrp = localPlayer.Character:FindFirstChild("HumanoidRootPart")  -- Get the HumanoidRootPart
                        if hrp then
                            local targetPosition = hrp.Position  -- Store player position
                            local orbs = game:GetService("Workspace").ExperienceOrbs:GetChildren()  -- Get all orbs

                            -- Loop through all orbs and move them to the player
                            for _, orb in ipairs(orbs) do
                                if orb:IsA("Part") and orb.Parent then
                                    -- Move orb directly to the player's position
                                    orb.CFrame = CFrame.new(targetPosition) * CFrame.new(0, 5, 0)  -- Hover above player
                                end
                            end
                        end
                    end
                end)
                task.wait(0.2)  -- Add a small delay to prevent server strain
            end
        else
            getgenv().ORBGIVE = false  -- Stop the orb collection
        end
    end)
end)

SSection:NewToggle("NPC Police Killaura", "Automatically attack nearby NPC Police.", function(state)
    local player = game.Players.LocalPlayer
    local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

    if state then
        -- Enable NPC Killaura
        getgenv().NPCPoliceKillaura = true
        spawn(function()
            while getgenv().NPCPoliceKillaura do
                pcall(function()
                    for _, npc in pairs(game.Workspace:GetChildren()) do
                        if npc:IsA("Model") and npc.Name == "Police" and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                            local npcRoot = npc:FindFirstChild("HumanoidRootPart")
                            if npcRoot and (rootPart.Position - npcRoot.Position).Magnitude <= 15 then
                                -- Attack the NPC Police
                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                            end
                        end
                    end
                end)
                wait(0.1) -- Check and attack every 0.1 seconds
            end
        end)
    else
        -- Disable NPC Killaura
        getgenv().NPCPoliceKillaura = false
    end
end)


SSection:NewToggle("Thug Killaura", "Automatically attack nearby Thugs.", function(state)
    local player = game.Players.LocalPlayer
    local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

    if state then
        -- Enable Killaura
        getgenv().ThugKillaura = true
        spawn(function()
            while getgenv().ThugKillaura do
                pcall(function()
                    for _, thug in pairs(game.Workspace:GetChildren()) do
                        if thug:IsA("Model") and thug.Name == "Thug" and thug:FindFirstChild("Humanoid") and thug.Humanoid.Health > 0 then
                            -- Check distance between the player and the Thug
                            if (rootPart.Position - thug.HumanoidRootPart.Position).Magnitude <= 15 then
                                -- Attack the Thug
                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                            end
                        end
                    end
                end)
                wait(0.1) -- Check and attack every 0.1 seconds
            end
        end)
    else
        -- Disable Killaura
        getgenv().ThugKillaura = false
    end
end)


local mouse = game.Players.LocalPlayer:GetMouse()
TargetSection:NewButton("Mouse Control", "", function()
    -- Toggle the control on and off
    if _G.CToggle == false then
        -- When Mouse Control is enabled
        spawn(function()
            getNearPlayer(99) -- Adjust range as necessary
            _G.CToggle = true
            getgenv().CarryP = true

            while getgenv().CarryP do
                -- Check every frame for movement
                wait(0.1)
                for _, v in pairs(plrlist) do
                    -- Ensure this doesn't affect the local player
                    if v ~= game.Players.LocalPlayer then
                        local targetPlayer = game.Players:FindFirstChild(v.Name)
                        if targetPlayer and targetPlayer.Character then
                            -- Move the player's HumanoidRootPart to the mouse position
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
        -- When Mouse Control is disabled
        _G.CToggle = false
        plrlist = {}  -- Clear the player list
        getgenv().CarryP = false
    end
end)


-- Declare a variable to track the state of the tag disabler
local tagDisablerEnabled = false

-- Function to disable chat tags in real-time
local function disableTags()
    -- Access the chat service
    local ChatService = game:GetService("Chat")

    -- Listen for any chat messages and manipulate the content to remove tags
    for _, player in pairs(game.Players:GetPlayers()) do
        -- When the player chats, modify the message
        player.Chatted:Connect(function(message)
            if tagDisablerEnabled then
                -- Modify the message to remove the tag (username/group)
                message = message:gsub("%[.-%]", "")  -- Removes anything inside [brackets] (commonly used for tags)
                message = message:gsub("%b<>", "")  -- Removes anything inside angle brackets < > (another common format for tags)

                -- Send the message again without tags
                ChatService:Chat(player.Character, message)
            end
        end)
    end
end
SSection:NewToggle("Shield Burst - Age Of Heroes", "Toggle Shield Burst effect", function(state)
    shieldBurstActive = state  -- Update the Shield Burst state

    -- Local variables
    local burstIntensity = 5  -- Customize the intensity of shield bursts
    local shieldWaitTime = 0.1 -- Time between each burst
    local maxBurstCount = 10  -- Maximum burst count before reset
    local pauseTime = 0.3 -- Time to wait after reaching max burst count for smoother performance

    if shieldBurstActive then
        -- Begin Shield Burst in a coroutine to prevent blocking the main thread
        coroutine.wrap(function()
            local burstCount = 0  -- Tracks number of activations

            while shieldBurstActive do
                -- Fire the shield activation event
                game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(true)

                burstCount = burstCount + 1  -- Increment the activation count

                -- If burst count reaches set intensity, reset or pause briefly
                if burstCount >= maxBurstCount then
                    burstCount = 0
                    wait(pauseTime)  -- Pause briefly after reaching max burst for smoother performance
                end

                -- Wait before firing the next burst to control the frequency
                wait(shieldWaitTime)  
            end

            -- Ensure shield is turned off when Shield Burst is deactivated
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false)
        end)()
    else
        -- Ensure shield is turned off immediately when Shield Burst toggle is deactivated
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false)
    end
end)




SSection:NewToggle("Thunderous Fist Frenzy", "Unleash rapid punches on nearby targets with lightning speed", function(state)
    getgenv().superRapidAura = state
    if state then
        -- Start the rapid punching aura with fast speed and strong effect
        spawn(function()
            -- Apply aura with specified parameters: radius 15, punch count 100, punch cooldown 0.03
            while getgenv().superRapidAura do
                applyAura("superRapidAura", 15, 100, 0.03)  -- Higher punch speed and intensity
            end
        end)
    else
        -- Disable the rapid punching aura when toggled off
        getgenv().superRapidAura = false
    end
end)

----------------------------------------------------------------------------------------------
ASection:NewButton("Give Bomb", "", function(state)
    loadstring(game:HttpGet('https://pastebin.com/raw/861SQXj7'))()
end);

-- Variables
local tagDisablerEnabled = false -- Toggle state

-- Function to disable tags
local function disableTags()
    local Chat = game:GetService("Chat")
    -- Force disable chat tags for the player
    local chatModules = Chat:FindFirstChild("ClientChatModules")
    if chatModules then
        local tagHandler = chatModules:FindFirstChild("ChatSettings")
        if tagHandler then
            local settings = require(tagHandler)
            settings.PlayerDisplayNamesEnabled = not tagDisablerEnabled -- Toggle based on state
        end
    end
end

-- Declare a variable to track the state of the tag disabler
local tagDisablerEnabled = false

-- Function to disable chat tags in real-time
local function disableTags()
    -- Access the chat service
    local ChatService = game:GetService("Chat")
    
    -- Disable tags by overriding the default format or manipulating chat message text
    -- This intercepts the chat message and removes the tag
    hookfunction(ChatService.FilterStringForBroadcast, function(message, player)
        -- Remove any tags from the message by replacing it with plain text
        return message:match("%S+.*") -- This keeps the message without the tags (you can refine this regex if needed)
    end)
    
    -- Disable chat tags for all existing players (this will run for the current players)
    for _, player in pairs(game.Players:GetPlayers()) do
        -- Clear the tags from the player's chat
        player.Chatted:Connect(function(message)
            if tagDisablerEnabled then
                -- Modify the message to remove any tags (e.g., names, groups, etc.)
                message = message:gsub("tag_pattern", "")  -- Replace 'tag_pattern' with actual tag patterns you want to hide
            end
        end)
    end
end

ASection:NewButton("Teleport To Middle", "Click to teleport to the middle without using the keybind", function()
    if (_G.bring == true) then
        -- Destroy telekinesis and teleport the specified player
        local targetPlayer = game:GetService("Workspace")[_G.teleportplayer]
        if targetPlayer and targetPlayer:FindFirstChild("HumanoidRootPart") and targetPlayer.HumanoidRootPart:FindFirstChild("telekinesisPosition") then
            targetPlayer.HumanoidRootPart.telekinesisPosition:Destroy()
        end
        if targetPlayer and targetPlayer:FindFirstChild("HumanoidRootPart") then
            targetPlayer.HumanoidRootPart.CFrame = CFrame.new(-376, 94, 91)
        end
        wait(0.2)
        -- Toggle telekinesis for the target player
        game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[_G.teleportplayer].Character)
    else
        -- Teleport the local player
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-376, 94, 91)
        end
    end
    -- Call the breakvelocity function to handle any post-teleport adjustments
    breakvelocity()
end)

local mouse = game.Players.LocalPlayer:GetMouse()

ASection:NewToggle("Auto Clicker 'V'", "", function(state)
    getgenv().autoClickV = state -- Track toggle state globally
    
    if state then
        print("Auto Clicker activated.") -- Notify user
        task.spawn(function()
            local vim = game:GetService("VirtualInputManager")
            while getgenv().autoClickV do
                pcall(function()
                    vim:SendKeyEvent(true, "V", false, nil)  -- Press 'V'
                    vim:SendKeyEvent(false, "V", false, nil) -- Release 'V'
                end)
                task.wait(0.05) -- Throttle interval (20 clicks/second)
            end
        end)
    else
        print("Auto Clicker deactivated.") -- Notify user
        getgenv().autoClickV = false -- Stop clicking
    end
end)
-- Toggle for Auto Click 'C' Key
ASection:NewToggle("Auto Click 'C'", "Automatically presses the C key repeatedly.", function(state)
    getgenv().autoClickC = state -- Set a global variable to track the toggle state

    if state then
        -- Start Auto Clicking
        spawn(function()
            while getgenv().autoClickC do
                -- Simulate pressing the C key
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "C", false, nil)
                wait(0.001) -- Adjust the interval between clicks
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "C", false, nil)
                wait(0.001) -- Interval before the next key press
            end
        end)
    end
end)

-- Toggle for Auto Click 'Z' Key
ASection:NewToggle("Auto Click 'Z'", "Automatically presses the Z key repeatedly.", function(state)
    getgenv().autoClickZ = state -- Set a global variable to track the toggle state

    if state then
        -- Start Auto Clicking
        spawn(function()
            while getgenv().autoClickZ do
                -- Simulate pressing the Z key
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, nil)  -- Press 'Z'
                wait(0.1)  -- Adjust the interval between key presses
                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, nil)  -- Release 'Z'
                wait(0.1)  -- Interval before the next key press
            end
        end)
    else
        -- Stop the auto clicker when the toggle is off
        getgenv().autoClickZ = false
    end
end)
-- Creating a fast toggle with a cool name
ASection:NewToggle("Teleport Shield", "Activate shield against teleport effects", function(state)
    -- Set the local player variable
    local player = game.Players.LocalPlayer

    -- Toggle anti-teleport functionality in a separate coroutine
    spawn(function()
        getgenv().antiTele = state
        while getgenv().antiTele do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                -- Activate the anti-teleport using the ReplicatedStorage event
                game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(0, 0, 0), false, player.Character)
            else
                warn("Character or HumanoidRootPart not found.")
            end
            wait(0.02) -- Reduced wait time for faster response
        end
    end)
end)
    
    -- Variables for ESP settings
    getgenv().OutlineColor = Color3.new(1, 0, 1) -- Default color is pink
    getgenv().ESPEnabled = false
    
    -- Function to add ESP to a player
    local function addESP(player)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Create Highlight for outline ESP
            local highlight = Instance.new("Highlight")
            highlight.Parent = player.Character
            highlight.FillTransparency = 1 -- Fully transparent fill
            highlight.OutlineTransparency = 0 -- No transparency on outline
            highlight.OutlineColor = getgenv().OutlineColor -- Set outline color
    
            -- Create a BillboardGui for player name above the head
            local billboard = Instance.new("BillboardGui")
            billboard.Parent = player.Character:WaitForChild("Head")
            billboard.Size = UDim2.new(1, 0, 1, 0)
            billboard.Adornee = player.Character.Head
            billboard.SizeOffset = Vector2.new(0, 2) -- Adjust height offset
    
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Text = player.Name
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextColor3 = Color3.new(1, 1, 1) -- White text
            nameLabel.Font = Enum.Font.SourceSans
            nameLabel.TextSize = 14
            nameLabel.Parent = billboard
        end
    end
    
    -- Function to remove ESP from a player
    local function removeESP(player)
        if player.Character then
            -- Remove Highlight
            local highlight = player.Character:FindFirstChildOfClass("Highlight")
            if highlight then
                highlight:Destroy()
            end
            
            -- Remove BillboardGui
            local billboard = player.Character:FindFirstChildOfClass("BillboardGui")
            if billboard then
                billboard:Destroy()
            end
        end
    end
    
    -- Toggle for displaying ESP
    ASection:NewToggle("Toggle Player ESP", "Display an outline around all players except yourself", function(state) 
        if state then
            getgenv().ESPEnabled = true
    
            -- Add ESP to all players except the local player
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    addESP(player)
                end
            end
    
            -- Detect new players and add ESP
            game.Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(character)
                    if player ~= game.Players.LocalPlayer then
                        addESP(player)
                    end
                end)
            end)
    
        else
            getgenv().ESPEnabled = false
    
            -- Remove ESP from all players
            for _, player in pairs(game.Players:GetPlayers()) do
                removeESP(player)
            end
        end
    end)
    
    -- Create a color picker for the ESP outline color
    ASection:NewColorPicker("Outline Color", "Pick the color for player outlines", Color3.new(1, 0, 1), function(color)
        getgenv().OutlineColor = color -- Set the new outline color
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local highlight = player.Character:FindFirstChildOfClass("Highlight")
                if highlight then
                    highlight.OutlineColor = getgenv().OutlineColor -- Update the outline color in real-time
                end
            end
        end
    end)
    
    -- Create additional effects toggle for ESP visibility through walls
    ASection:NewToggle("Show Through Walls", "Enable ESP visibility through walls", function(state)
        getgenv().ESPThroughWalls = state -- Set state for ESP through walls
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local highlight = player.Character:FindFirstChildOfClass("Highlight")
                if highlight then
                    highlight.Enabled = state -- Toggle visibility
                end
            end
        end
    end)
    
    -- Create a toggle to turn off all ESP
    ASection:NewToggle("Turn Off All ESP", "Disable ESP for all players", function(state) 
        if state then
            -- Remove ESP from all players
            for _, player in pairs(game.Players:GetPlayers()) do
                removeESP(player)
            end
            getgenv().ESPEnabled = false -- Ensure ESP is disabled
        end
    end)

    local player = game.Players.LocalPlayer
    
    KSection:NewKeybind("Carry Player", "", Enum.KeyCode.H, function()
        if (_G.CToggle == false) then
            spawn(function()
                getNearPlayer(99);
                wait();
                _G.CToggle = true;
                getgenv().CarryP = true;
                while CarryP do
                    wait();
                    spawn(function()
                        for i, v in pairs(plrlist) do
                            if (v == player) then
                            else
                                Xt = player.Character.HumanoidRootPart.Position['X'];
                                Yt = player.Character.HumanoidRootPart.Position['Y'];
                                Zt = player.Character.HumanoidRootPart.Position['Z'];
                                game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition.Position = Vector3.new(Xt, Yt + 8, Zt + 5);
                            end
                        end
                    end);
                end
            end);
        else
            spawn(function()
                _G.CToggle = false;
                plrlist = {};
                getgenv().CarryP = false;
            end);
        end
    end);

    KSection:NewKeybind("Carry NPC", "", Enum.KeyCode['O'], function()
        if (_G.CToggle == false) then
            spawn(function()
                -- Call the function to get nearby players and NPCs
                getNearPlayer(99);
                wait();
                _G.CToggle = true;
                getgenv().CarryP = true;
        
                while CarryP do
                    wait(0.2);  -- Minimal wait to reduce performance impact
    
                    -- Loop through the plrlist to handle players and NPCs
                    spawn(function()
                        for _, v in pairs(plrlist) do
                            if v == player then
                                -- Skip the local player
                                continue
                            end
    
                            local target
                            -- Check if the target is a player or an NPC
                            if game.Players:FindFirstChild(v.Name) then
                                target = game.Players[v.Name].Character
                            else
                                target = game.Workspace:FindFirstChild(v.Name) -- Assumes NPCs are in Workspace
                            end
    
                            -- Ensure the target has a HumanoidRootPart to avoid errors
                            if target and target:FindFirstChild("HumanoidRootPart") then
                                local targetHumanoidRootPart = target.HumanoidRootPart
                                local playerHumanoidRootPart = player.Character.HumanoidRootPart
                                
                                -- Move the target's HumanoidRootPart relative to the player
                                targetHumanoidRootPart.CFrame = playerHumanoidRootPart.CFrame * CFrame.new(0, 8, 5)
                            end
                        end
                    end)
                end
            end)
        else
            -- Disable carry when toggle is off
            spawn(function()
                _G.CToggle = false;
                plrlist = {};  -- Clear the player list
                getgenv().CarryP = false;
            end)
        end
    end)
    
    
    KSection:NewKeybind("Telekinesis Lock", "", Enum.KeyCode['T'], function()
        spawn(function()
            -- Define a Neon Part or UI element to change color
            local neonPart = game.Workspace:FindFirstChild("NeonPart")  -- Replace with your part's name
            local neonColors = {Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255)}
    
            -- Change the color of the NeonPart if it exists
            if neonPart then
                for _, color in ipairs(neonColors) do
                    neonPart.BrickColor = BrickColor.new(color)
                    neonPart.Material = Enum.Material.Neon
                    wait(0.1) -- Adjust the delay for a smoother transition
                end
            end
    
            -- Execute the original Telekinesis logic
            local LookVector = game.Workspace.Camera.CFrame.LookVector;
            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, true);
            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, false);
        end)
    end)
    
    KSection:NewKeybind("Enhanced Telekinesis Kill", "Targets nearby players and neutralizes them", Enum.KeyCode.G, function()
        spawn(function()
            -- Get players near 99 studs
            getNearPlayer(99)
            
            for _, targetPlayer in pairs(plrlist) do
                if targetPlayer ~= player then
                    spawn(function()
                        -- Attempt to destroy their Neck (critical hit)
                        local character = targetPlayer.Character
                        if character and character:FindFirstChild("Head") and character.Head:FindFirstChild("Neck") then
                            character.Head.Neck:Destroy()
                        end
                        
                        -- Additional: Forcefully immobilize
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0) -- Sends them far off the map
                        end
                        
                        -- Invoke Telekinesis with aggressive parameters
                        spawn(function()
                            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(
                                Vector3.new(999, 999, 999), -- High force vector
                                true, -- Enable telekinesis
                                character
                            )
                        end)
    
                        -- Final fallback: Attempt to remove Humanoid
                        wait(0.1) -- Minor delay for cleanup
                        if character and character:FindFirstChild("Humanoid") then
                            character.Humanoid:Destroy()
                        end
                    end)
                end
            end
            
            -- Clear player list after action
            plrlist = {}
        end)
    end)    
    KSection:NewKeybind("Toggle UI", "", Enum.KeyCode.Y, function()
        Library:ToggleUI();
    end);
    KSection:NewKeybind("Release Telekinesis", "", Enum.KeyCode['C'], function()
        plrlist = {};
        Players = game:GetService("Players");
        for i, player in pairs(Players:GetPlayers()) do
            spawn(function()
                game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[player.Name].Character);
            end);
        end
    end);
    KSection:NewKeybind("Teleport To Motel", "", Enum.KeyCode.Z, function()
      if (_G.bring == true) then
            game:GetService("Workspace")[_G.teleportplayer].HumanoidRootPart.telekinesisPosition:Destroy()
            game:GetService("Workspace")[_G.teleportplayer].HumanoidRootPart.CFrame = CFrame.new(-1745, 95, -1530);
            wait(0.2)
            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[_G.teleportplayer].Character);
        else
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1745, 95, -1530);
        end
        breakvelocity();
    end);
    KSection:NewKeybind("Teleport To Middle", "", Enum.KeyCode.V, function()
     if (_G.bring == true) then
            game:GetService("Workspace")[_G.teleportplayer].HumanoidRootPart.telekinesisPosition:Destroy()
            game:GetService("Workspace")[_G.teleportplayer].HumanoidRootPart.CFrame = CFrame.new(-376, 94, 91);
            wait(0.2)
            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[_G.teleportplayer].Character);
        else
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-376, 94, 91);
        end
        breakvelocity();
    end);
    GSection:NewToggle("Enable Orbit (Really funny to use)", "", function(state)
    getgenv().cua = state
    end);
    KSection:NewKeybind("Toggle Fly", "Press to toggle fly", Enum.KeyCode.J, function()
        fly()
    end)
    
KSection:NewKeybind("MetalSkin", "", Enum.KeyCode['LeftShift'], function()
	if (_G.metalskin == false) then
		game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", true);
		_G.metalskin = true;
	else
		game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", false);
		_G.metalskin = false;
	end
end);
KSection:NewKeybind("Telekinesis Lock", "", Enum.KeyCode['T'], function()
	spawn(function()
		local LookVector = game.Workspace.Camera.CFrame.LookVector;
		game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, true);
		game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, false);
	end);
end);
KSection:NewKeybind("Telekinesis kill", "", Enum.KeyCode['G'], function()
	spawn(function()
		getNearPlayer(99);
		for i, v in pairs(plrlist) do
			if (v == player) then
			else
				spawn(function()
					v.Head.Neck:Destroy();
					plrlist = {};
					wait(0.2);
					spawn(function()
						game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
					end);
				end);
			end
		end
	end);
end);
KSection:NewKeybind("Release Telekinesis", "", Enum.KeyCode['C'], function()
	plrlist = {};
	Players = game:GetService("Players");
	for i, player in pairs(Players:GetPlayers()) do
		spawn(function()
			game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[player.Name].Character);
		end);
	end
end);
    
    GSection:NewTextBox("Distance", "", function(txt)
      getgenv().size = txt
    end)
    
    GSection:NewTextBox("Heigh", "", function(txt)
        getgenv().heigh = txt
    end)
    GSection:NewButton("Infinite Yield", "", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end);
    GSection:NewButton("Chat Spammer", "", function()
        loadstring(game:HttpGet(('https://raw.githubusercontent.com/ColdStep2/Chatdestroyer-Hub-V1/main/Chatdestroyer%20Hub%20V1'),true))()
    end);
    GSection:NewButton("Dex/Explorer", "", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end);
    GSection:NewButton("Chat Spoofer", "", function()
        loadstring(game:HttpGet(('https://pastebin.com/raw/djBfk8Li'),true))()
    end);
    GSection:NewButton("Chat bypasser", "", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/synnyyy/synergy/additional/betterbypasser", true))()
    end)
    
    _G.CToggle = false;
    _G.metalskin = false;
    _G.LOCALPLAYER = game.Players.LocalPlayer.Name;
    _G.bring = false;
    player = game.Players.LocalPlayer;
    breakvelocity = function()
        spawn(function()
            local BeenASecond, V3 = false, Vector3.new(0, 0, 0);
            delay(1, function()
                BeenASecond = true;
            end);
            while not BeenASecond do
                for _, v in ipairs(player.Character:GetDescendants()) do
                    if v.IsA(v, "BasePart") then
                        v.Velocity, v.RotVelocity = V3, V3;
                    end
                end
                wait();
            end
        end);
    end;
    plrlist = {};
    plrnum = 0;
    getNearPlayer = function(maxDistance)
        pcall(function()
            if (player and player.Character) then
                local playerLocation = player.Character.HumanoidRootPart.Position;
                for i, v in pairs(game.Players:GetChildren()) do
                    if (v.Character and (v.Character.Health ~= 0)) then
                        local location = v.Character.HumanoidRootPart.Position;
                        if (((location - playerLocation).Magnitude <= maxDistance) and (v.Character.Health ~= 0)) then
                            pcall(function()
                                if (v == player) then
                                else
                                    local teleexist = game:GetService("Workspace")[v.Name].HumanoidRootPart;
                                    if (not teleexist:FindFirstChild("telekinesisPosition") and (v.Character.Health ~= 0)) then
                                    elseif (v ~= player) then
                                        plrnum += 1
                                        table.insert(plrlist, v.Character);
                                    end
                                end
                            end);
                        end
                    end
                end
            end
        end);
    end;
    GetList = function()
        x = 1;
        Plyr = game.Players:GetPlayers();
        dropdown = {};
        for value in pairs(Plyr) do
            PLR = Plyr[x].Name;
            x += 1
            table.insert(dropdown, PLR);
        end
    end;
    TSection:NewDropdown("Safezone Locations", "", {"Bar","Building Park","City Square","Evil Lair","Feild","Hero HQ","Hero Lair","Motel","Mountain","Mountain-2","Park","Plains","Prison"}, function(currentOption)
        _G.selectedstat = currentOption;
    end);
    TSection:NewDropdown("Other Locations", "", {"Contruction Building","Corner-1","Corner-2","Corner-3","Corner-4","Ignite Tower","Military Base","Mountain Hole","Police Department","Cave"}, function(currentOption)
        _G.selectedstat = currentOption;
    end);
    TSection:NewDropdown("Unfortunate Locations", "", {"Unfortunate Spot (Secret Area)","Unfortunate Spot (In Building)", "Unfortunate Spot (Trap)","Unfortunate Spot (Space)","Unfortunate Spot (Under Map)","Unfortunate Spot (Dead End)","Unfortunate Spot (Box)","Unfortunate Spot (Arena)","Unfortunate Spot (Backrooms)","Unfortunate Spot (Sex Dungeon)"}, function(currentOption)
        _G.selectedstat = currentOption;
    end);
    TSection:NewToggle("Teleport Player", "", function(state)
        if state then
            _G.bring = true;
        else
            _G.bring = false;
        end
    end);
    TSection:NewButton("Teleport", "", function()
        getNearPlayer(99);
        if (_G.selectedstat == "Bar") then
            if (_G.bring == true) then
                getNearPlayer(99);
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-1313, 197, 149);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1313, 197, 149);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Building Park") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-1751, 442, 1266);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1751, 442, 1266);
                breakvelocity();
            end
        elseif (_G.selectedstat == "City Square") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-385, 86, 256);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-385, 86, 256);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Evil Lair") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-905, 94, -1086);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-905, 94, -1086);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Feild") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(2355, 81, 4);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2355, 81, 4);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Hero HQ") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(259, 169, 2748);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(259, 169, 2748);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Hero Lair") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(2351, 39, -1855);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2351, 39, -1855);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Motel") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-1750, 94, -1349);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1750, 94, -1349);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Mountain") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-2206, 817, -2425);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2206, 817, -2425);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Mountain-2") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-2429, 762, -2363);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2429, 762, -2363);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Park") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(1399, 94, 1154);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1399, 94, 1154);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Plains") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-3683, 97, -144);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3683, 97, -144);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Prison") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-779, 269, -2594);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-779, 269, -2594);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Contruction Building") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(650, 779, 284);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(650, 779, 284);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Corner-1") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(2773, 96, -4996);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2773, 96, -4996);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Corner-2") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-3757, 97, -3801);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3757, 97, -3801);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Corner-3") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-3650, 97, 2764);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3650, 97, 2764);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Corner-4") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(2810, 102, 2821);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2810, 102, 2821);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Ignite Tower") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-70, 616, -247);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-70, 616, -247);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Military Base") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(259, 99, -4639);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(259, 99, -4639);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Mountain Hole") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-2732, 256, -1776);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2732, 256, -1776);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Police Department") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-62, 94, -480);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-62, 94, -480);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Cave") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(269, -59, 2729);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(269, -59, 2729);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Unfortunate Spot (Secret Area)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-1100, 61, -1169);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1100, 61, -1169);
                breakvelocity();
            end
            elseif (_G.selectedstat == "Unfortunate Spot (In Building)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-494, 96, -98);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-494, 96, -98);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Unfortunate Spot (Trap)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-790, 135, -2769);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-790, 135, -2769);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Unfortunate Spot (Space)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(0, 9999999, 0);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 9999999, 0);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Unfortunate Spot (Under Map)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(0, 0, 0);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 0, 0);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Unfortunate Spot (Dead End)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(1453, 98, -2506);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1453, 98, -2506);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Unfortunate Spot (Box)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-1695, 94, -1309);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1695, 94, -1309);
            end
        elseif (_G.selectedstat == "Unfortunate Spot (Arena)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-1728, 94, -1188);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1728, 94, -1188);
            end
        elseif (_G.selectedstat == "Unfortunate Spot (Backrooms)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-1519, 95, -1072);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1519, 95, -1072);
            end
        elseif (_G.selectedstat == "Unfortunate Spot (Sex Dungeon)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-1585, 95, -1159);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1585, 95, -1159);
            end
        end
        plrlist = {};
    end);
-- Dropdown for selecting a stat
StatSection:NewDropdown("AutoStats", "Select a stat to upgrade automatically", 
    {
        "vitality", "healing", "strength", "energy", "flight", "speed", 
        "climbing", "swinging", "fireball", "frost", "lightning", 
        "power", "telekinesis", "shield", "laserVision", "metalSkin"
    }, 
    function(currentOption)
        selectedstat = currentOption
    end
)

-- Toggle for enabling/disabling AutoStats
StatSection:NewToggle("Toggle AutoStats", "Enable or disable AutoStats", function(state)
    if state then
        -- Ensure a stat is selected before proceeding
        if not selectedstat then
            warn("No stat selected! Please select a stat from the dropdown.")
            return
        end

        getgenv().AutoStats = true
        coroutine.wrap(function()
            while getgenv().AutoStats do
                wait(0.00) -- Delay set to 0.01 seconds to achieve approximately 100 actions per second
                pcall(function()
                    -- Upgrade the selected stat multiple times per tick
                    for _ = 1, 1000 do
                        game:GetService("ReplicatedStorage").Events.UpgradeAbility:InvokeServer(selectedstat)
                    end
                end)
            end
        end)()
    else
        -- Disable AutoStats
        getgenv().AutoStats = false
    end
end)


-- Additional Option: Reset Stats
StatSection:NewButton("Reset Stats", "Reset all stats to base level", function()
    pcall(function()
        game:GetService("ReplicatedStorage").Events.ResetStats:InvokeServer()
        print("Stats have been reset successfully!")
    end)
end)

-- Additional Option: Auto Select Most Important Stat
StatSection:NewButton("Auto Select Recommended Stat", "Automatically selects the best stat based on your character's role", function()
    local recommendedStat = "strength" -- Default recommendation
    local role = game.Players.LocalPlayer.Character:FindFirstChild("Role") -- Example role check (customize as needed)

    if role then
        if role.Value == "Tank" then
            recommendedStat = "vitality"
        elseif role.Value == "DPS" then
            recommendedStat = "strength"
        elseif role.Value == "Healer" then
            recommendedStat = "healing"
        end
    end

    selectedstat = recommendedStat
    print("Recommended stat selected:", recommendedStat)
end)


    -- Laser Civilian Farm Toggle
    MainSection:NewToggle("Laser Civilian Farm", "", function(state)
        if state then
            getgenv().LaserC = true
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)
                while getgenv().LaserC and part do
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Model") and v.Name == "Civilian" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            part.Position = v.HumanoidRootPart.Position
                        end
                    end
                    wait()
                end
                event:InvokeServer(false)
            end)()
        else
            getgenv().LaserC = false
            breakvelocity()
        end
    end)
    
    -- Laser Police Farm Toggle
    MainSection:NewToggle("Laser Police Farm", "", function(state)
        if state then
            getgenv().LaserV = true
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)
                while getgenv().LaserV and part do
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Model") and v.Name == "Police" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            part.Position = v.HumanoidRootPart.Position
                        end
                    end
                    wait()
                end
                event:InvokeServer(false)
            end)()
        else
            getgenv().LaserV = false
            breakvelocity()
        end
    end)
    
    MainSection:NewToggle("Laser Players", "", function(state)
        if state then
            getgenv().LaserV = true
            coroutine.wrap(function()
                local laserEvent = game:GetService("ReplicatedStorage").Events:FindFirstChild("ToggleLaserVision")
                local attackEvent = game:GetService("ReplicatedStorage").Events:FindFirstChild("AttackPlayer") -- Verify the correct name of your attack event
    
                if not laserEvent or not attackEvent then
                    warn("Laser or Attack event not found in ReplicatedStorage.")
                    return
                end
    
                -- Activate laser vision
                local laserPart = laserEvent:InvokeServer(true)
    
                -- Check if the part was created
                if not laserPart then
                    warn("Laser part could not be created.")
                    return
                end
    
                -- Continuously aim laser at other players
                while getgenv().LaserV do
                    for _, player in pairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and player.Character then
                            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                            local humanoid = player.Character:FindFirstChild("Humanoid")
                            
                            -- Only target players with health
                            if hrp and humanoid and humanoid.Health > 0 then
                                -- Position the laser part to aim at the player
                                laserPart.Position = hrp.Position
                                
                                -- Fire the attack event
                                attackEvent:FireServer(player)
                            end
                        end
                    end
                    wait(0.1) -- Adjust frequency as needed for performance
                end
    
                -- Deactivate laser vision when toggled off
                laserEvent:InvokeServer(false)
            end)()
        else
            getgenv().LaserV = false
        end
    end)
    
    -- Assuming you have a UI section for player input
    local playerNameInput = MainSection:NewTextBox("Target Player", "Enter the name of the player to laser", function(inputText)
        getgenv().targetPlayerName = inputText
    end)
    
    MainSection:NewToggle("Laser Selected Player", "", function(state)
        if state then
            getgenv().LaserV = true
            coroutine.wrap(function()
                local laserEvent = game:GetService("ReplicatedStorage").Events:FindFirstChild("ToggleLaserVision")
                local attackEvent = game:GetService("ReplicatedStorage").Events:FindFirstChild("AttackPlayer") -- Verify the correct name of your attack event
    
                if not laserEvent or not attackEvent then
                    warn("Laser or Attack event not found in ReplicatedStorage.")
                    return
                end
    
                -- Activate laser vision
                local laserPart = laserEvent:InvokeServer(true)
    
                -- Check if the part was created
                if not laserPart then
                    warn("Laser part could not be created.")
                    return
                end
    
                -- Continuously aim laser at specified player
                while getgenv().LaserV do
                    local targetPlayer = game.Players:FindFirstChild(getgenv().targetPlayerName)
                    
                    if targetPlayer and targetPlayer.Character then
                        local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                        
                        -- Only target players with health
                        if hrp and humanoid and humanoid.Health > 0 then
                            -- Position the laser part to aim at the player
                            laserPart.Position = hrp.Position
                            
                            -- Fire the attack event
                            attackEvent:FireServer(targetPlayer)
                        end
                    else
                        warn("Target player not found or has no character.")
                    end
                    
                    wait(0.1) -- Adjust frequency as needed for performance
                end
    
                -- Deactivate laser vision when toggled off
                laserEvent:InvokeServer(false)
            end)()
        else
            getgenv().LaserV = false
        end
    end)
    
    
    -- Toggle for Laser Thug Farm with Pink ESP and White Laser
    MainSection:NewToggle("Laser Thug Farm", "Shows laser ESP through walls for Thugs", function(state)
        if state then
            getgenv().LaserH = true
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)
                
                -- Set laser color to white (if applicable in game)
                if part:IsA("BasePart") then
                    part.Color = Color3.fromRGB(255, 255, 255) -- Set laser color to white
                    part.Material = Enum.Material.Neon -- Optional: Neon material for brightness
                end
                
                -- Mute the laser sound if there's a sound instance
                if part:FindFirstChild("LaserSound") then
                    part.LaserSound.Volume = 0 -- Assuming the sound is named "LaserSound"
                end
                
                -- Create a pink highlight for ESP effect
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 182, 193)  -- Light pink color for fill
                highlight.OutlineColor = Color3.fromRGB(255, 105, 180)  -- Darker pink outline
                highlight.FillTransparency = 0.7
                highlight.OutlineTransparency = 0
                highlight.Parent = game.CoreGui  -- Add to GUI to keep it visible through walls
    
                while getgenv().LaserH and part do
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Model") and v.Name == "Thug" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            -- Set the laser part to thug's position and enable ESP
                            part.Position = v.HumanoidRootPart.Position
                            highlight.Adornee = v -- Assign ESP to the thug model
                        end
                    end
                    wait() -- Repeat with each update
                end
    
                -- Disable laser and cleanup
                event:InvokeServer(false)
                highlight:Destroy()
            end)()
        else
            getgenv().LaserH = false
            -- Additional function cleanup if necessary
        end
    end)
    
    local player = game.Players.LocalPlayer
    local carryingThugs = false  -- Tracks whether carrying is enabled
    
    -----
    local player = game.Players.LocalPlayer
    
    MainSection:NewToggle("Teleport Thug's to player", "Teleports thugs directly to player", function(state)
        if state then
            getgenv().LaserH = true
            coroutine.wrap(function()
                -- Start looping to teleport thugs to the player
                while getgenv().LaserH do
                    for _, thug in pairs(game.Workspace:GetChildren()) do
                        if thug:IsA("Model") and thug.Name == "Thug" and thug:FindFirstChild("Humanoid") and thug.Humanoid.Health > 0 then
                            -- Teleport thug to the player's position, with slight offset for visibility
                            thug:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5))
                        end
                    end
                    wait(0.1) -- Wait briefly to avoid excessive resource use
                end
            end)()
        else
            -- Stop teleporting thugs
            getgenv().LaserH = false
        end
    end)
    
    
    
    -- Laser Civilian Farm From Sky Toggle
    MainSection:NewToggle("Laser Civilian Farm From Sky", "", function(state)
        if state then
            local orbPos = player.Character.HumanoidRootPart.Position
            player.Character.HumanoidRootPart.CFrame = CFrame.new(orbPos.X, 2500, orbPos.Z)
            getgenv().LaserC = true
            wait(0.2)
            player.Character.HumanoidRootPart.Anchored = true
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)
                while getgenv().LaserC and part do
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Model") and v.Name == "Civilian" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            part.Position = v.HumanoidRootPart.Position
                        end
                    end
                    wait()
                end
                event:InvokeServer(false)
            end)()
        else
            player.Character.HumanoidRootPart.Anchored = false
            getgenv().LaserC = false
            player.Character.HumanoidRootPart.CFrame = CFrame.new(orbPos)
            breakvelocity()
        end
    end)
    MainSection:NewToggle("Laser Thug Farm From Sky", "", function(state)
        if state then
            local thugPos = player.Character.HumanoidRootPart.Position
            player.Character.HumanoidRootPart.CFrame = CFrame.new(thugPos.X, 2500, thugPos.Z)
            getgenv().LaserH = true
            wait(0.2)
            player.Character.HumanoidRootPart.Anchored = true
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)
                while getgenv().LaserH and part do
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Model") and v.Name == "Thug" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            part.Position = v.HumanoidRootPart.Position
                        end
                    end
                    wait()
                end
                event:InvokeServer(false)
            end)()
        else
            player.Character.HumanoidRootPart.Anchored = false
            getgenv().LaserH = false
            player.Character.HumanoidRootPart.CFrame = CFrame.new(thugPos)
            breakvelocity()
        end
    end)
    -- Laser Police Farm From Sky Toggle
    MainSection:NewToggle("Laser Police Farm From Sky", "", function(state)
        if state then
            local orbPos = player.Character.HumanoidRootPart.Position
            player.Character.HumanoidRootPart.CFrame = CFrame.new(orbPos.X, 2500, orbPos.Z)
            getgenv().LaserV = true
            wait(0.2)
            player.Character.HumanoidRootPart.Anchored = true
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)
                while getgenv().LaserV and part do
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Model") and v.Name == "Police" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            part.Position = v.HumanoidRootPart.Position
                        end
                    end
                    wait()
                end
                event:InvokeServer(false)
            end)()
        else
            player.Character.HumanoidRootPart.Anchored = false
            getgenv().LaserV = false
            player.Character.HumanoidRootPart.CFrame = CFrame.new(orbPos)
            breakvelocity()
        end
    end)
    
    MainSection:NewToggle("Civilian Farm", "", function(state)
        if state then
            -- Store original position
            local civilianPos = player.Character.HumanoidRootPart.CFrame
            getgenv().Civilian = true
    
            -- Start farming loop
            coroutine.wrap(function()
                while getgenv().Civilian do
                    wait(0.2)
                    pcall(function()
                        for _, v in pairs(game.Workspace:GetChildren()) do
                            if v:IsA("Model") and v.Name == "Civilian" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                                player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                            end
                        end
                    end)
                end
            end)()
    
            -- Store position for reset when toggle is turned off
            getgenv().CivilianReturnPos = civilianPos
        else
            -- Stop the farm and return to saved position
            getgenv().Civilian = false
            wait(0.2)
            if getgenv().CivilianReturnPos then
                player.Character.HumanoidRootPart.CFrame = getgenv().CivilianReturnPos
            end
        end
    end)

    MainSection:NewToggle("Police Farm", "", function(state)
        if state then
            -- Store original position
            local policePos = player.Character.HumanoidRootPart.CFrame
            getgenv().Police = true
    
            -- Start farming loop
            coroutine.wrap(function()
                while getgenv().Police do
                    wait(0.2)
                    pcall(function()
                        for _, v in pairs(game.Workspace:GetChildren()) do
                            if v:IsA("Model") and v.Name == "Police" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                                player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                            end
                        end
                    end)
                end
            end)()
    
            -- Store position for reset when toggle is turned off
            getgenv().PoliceReturnPos = policePos
        else
            -- Stop the farm and return to saved position
            getgenv().Police = false
            wait(0.2)
            if getgenv().PoliceReturnPos then
                player.Character.HumanoidRootPart.CFrame = getgenv().PoliceReturnPos
            end
        end
    end)
    
    
    -- Toggle to start or stop Thug farming
    MainSection:NewToggle("Thug Farm V2", "", function(state)
        local player = game.Players.LocalPlayer
        local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
        if state then
            -- Save player's original position
            if rootPart then
                thugX, thugY, thugZ = rootPart.Position.X, rootPart.Position.Y, rootPart.Position.Z
            end
            getgenv().Thug = true
    
            -- Farming loop
            spawn(function()
                while getgenv().Thug do
                    wait(0.5) -- Increased wait time for slower farming
                    pcall(function()
                        for _, v in pairs(game.Workspace:GetChildren()) do
                            if v:IsA("Model") and v.Name == "Thug" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                -- Move player near the Thug and punch
                                rootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                                wait(0.2) -- Add a slight delay between punches
                            end
                        end
                    end)
                end
            end)
        else
            -- Stop farming and return to original position
            getgenv().Thug = false
            spawn(function()
                wait(0.2)
                if rootPart then
                    rootPart.CFrame = CFrame.new(thugX, thugY, thugZ)
                end
            end)
        end
    end)
    -- Toggle to start or stop Thug farming
    
    SSection:NewToggle("Spawn Point", "", function(state)
        if state then
            getgenv().Deathcheck = true
            local spawnPosition = player.Character.UpperTorso.Position
            
            -- Coroutine for respawning at the saved position
            coroutine.wrap(function()
                while getgenv().Deathcheck do
                    local health = game.Players.LocalPlayer.Character.Humanoid.Health
                    if health == 0 then
                        wait(6.5) -- Wait before teleporting to avoid instant respawn issues
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(spawnPosition)
                    end
                    wait(1) -- Check health every second
                end
            end)()
        else
            getgenv().Deathcheck = false -- Stop respawn loop when toggled off
        end
    end)
    MainSection:NewToggle("Laser Player Farm From Sky", "", function(state)
        if state then
            local playerPos = player.Character.HumanoidRootPart.Position
            player.Character.HumanoidRootPart.CFrame = CFrame.new(playerPos.X, 2500, playerPos.Z)
            getgenv().LaserPlayer = true
            wait(0.2)
            player.Character.HumanoidRootPart.Anchored = true
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)
                while getgenv().LaserPlayer and part do
                    for _, v in pairs(game.Players:GetPlayers()) do
                        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                            part.Position = v.Character.HumanoidRootPart.Position
                        end
                    end
                    wait()
                end
                event:InvokeServer(false)
            end)()
        else
            player.Character.HumanoidRootPart.Anchored = false
            getgenv().LaserPlayer = false
            player.Character.HumanoidRootPart.CFrame = CFrame.new(playerPos)
            breakvelocity()
        end
    end)
    
    
    SSection:NewToggle("Rapid Punch", "", function(state)
        if state then
            -- Activate Rapid Punch
            getgenv().rapid = true
            local UserInputService = game:GetService("UserInputService")
            
            -- Function to handle input
            local function onInputEnded(inputObject, gameProcessedEvent)
                if gameProcessedEvent then return end -- Ignore if the input was processed by the game
                
                if getgenv().rapid and inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                    -- Fire the punch event multiple times rapidly
                    for i = 1, 10 do -- Change the number to adjust how many punches per input
                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                    end
                end
            end
            
            -- Store the connection so we can disconnect it later
            getgenv().RapidPunchConnection = UserInputService.InputEnded:Connect(onInputEnded)
        else
            -- Deactivate Rapid Punch
            getgenv().rapid = false
            
            -- Disconnect the connection to stop listening for input
            if getgenv().RapidPunchConnection then
                getgenv().RapidPunchConnection:Disconnect()
                getgenv().RapidPunchConnection = nil
            end
        end
    end)
    
    SSection:NewToggle("Rapid Heavy Punch", "", function(state)
        if state then
            -- Activate Rapid Heavy Punch
            getgenv().Hrapid = true
            local UserInputService = game:GetService("UserInputService")
            
            -- Function to handle input
            local function onInputEnded(inputObject, gameProcessedEvent)
                if gameProcessedEvent then return end -- Ignore if the input was processed by the game
                
                if getgenv().Hrapid and inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                    -- Fire the punch event multiple times rapidly
                    for i = 1, 10 do -- Change the number to adjust how many punches per input
                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0.4, 0.1, 1)
                    end
                end
            end
            
            -- Store the connection so we can disconnect it later
            getgenv().RapidPunchConnection = UserInputService.InputEnded:Connect(onInputEnded)
        else
            -- Deactivate Rapid Heavy Punch
            getgenv().Hrapid = false
            
            -- Disconnect the connection to stop listening for input
            if getgenv().RapidPunchConnection then
                getgenv().RapidPunchConnection:Disconnect()
                getgenv().RapidPunchConnection = nil
            end
        end
    end)
    
    -- Toggleable Super Rapid Punch Aura
ASection:NewToggle("Super Rapid Punch", "", function(state)
    -- Set toggle for super rapid punch
    getgenv().superrapid = state
    local UserInputService = game:GetService("UserInputService")

    -- Parameters for rapid punching
    local punchCount = 50  -- Number of punches per activation, adjust for more or fewer punches
    local punchCooldown = 0.1  -- Delay between activations for performance control

    -- Function to fire punches rapidly
    local function rapidPunch()
        for _ = 1, punchCount do
            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
        end
    end

    -- Function to detect mouse input and trigger punches
    local function onInputEnded(inputObject, gameProcessedEvent)
        if not gameProcessedEvent and getgenv().superrapid and inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
            rapidPunch()
        end
    end

    -- Manage input connection for toggling
    local inputConnection
    if state then
        -- Connect input detection when enabled
        inputConnection = UserInputService.InputEnded:Connect(onInputEnded)
    else
        -- Disconnect to stop rapid punch when disabled
        getgenv().superrapid = false
        if inputConnection then inputConnection:Disconnect() end
    end
end)

-- Function to get the player's root part
getRoot = function(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

SSection:NewToggle("Super Rapid Punch", "", function(state)
    local UserInputService = game:GetService("UserInputService")
    
    if state then
        -- Activate Super Rapid Punch
        getgenv().superrapid = true
        
        local function onInputEnded(inputObject, gameProcessedEvent)
            if gameProcessedEvent or not getgenv().superrapid then return end
            
            if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                spawn(function()
                    for _ = 1, 50 do -- Rapidly send 50 punches
                        if not getgenv().superrapid then break end
                        pcall(function()
                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                        end)
                        task.wait(0.05) -- Small delay between punches
                    end
                end)
            end
        end
        
        -- Connect the input listener
        UserInputService.InputEnded:Connect(onInputEnded)
    else
        -- Deactivate Super Rapid Punch
        getgenv().superrapid = false
    end
end)

    getRoot = function(char)
        local rootPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso");
        return rootPart;
    end;
    Players = game:GetService("Players");
    SSection:NewButton("Name Esp", "", function()
        local esp_settings = {textsize=20};
        local gui = Instance.new("BillboardGui");
        local esp = Instance.new("TextLabel", gui);
        gui.Name = "esp";
        gui.ResetOnSpawn = false;
        gui.AlwaysOnTop = true;
        gui.LightInfluence = 0;
        gui.Size = UDim2.new(1.75, 0, 1.75, 0);
        esp.BackgroundColor3 = Color3.fromRGB(0, 255, 255);
        esp.Text = "";
        esp.Size = UDim2.new(0.0001, 0.00001, 0.0001, 0.00001);
        esp.BorderSizePixel = 4;
        esp.BorderColor3 = Color3.new(0, 255, 255);
        esp.BorderSizePixel = 0;
        esp.Font = "SourceSansSemibold";
        esp.TextSize = esp_settings.textsize;
        esp.TextColor3 = Color3.fromRGB(0, 255, 255);
        getgenv().esp = true;
        game:GetService("RunService").RenderStepped:Connect(function()
            for i, v in pairs(game:GetService("Players"):GetPlayers()) do
                if ((v ~= game:GetService("Players").LocalPlayer) and Players.LocalPlayer.Character and (v.Character.Head:FindFirstChild("esp") == nil)) then
                    esp.Text = "Name: " .. v.Name .. "";
                    gui:Clone().Parent = v.Character.Head;
                end
            end
        end);
    end);
    local player = game.Players.LocalPlayer
    
    SSection:NewToggle("GodMode", "", function(state)
        if state then
            -- Save current position
            local currentPos = player.Character.HumanoidRootPart.CFrame
            
            -- Teleport to a specific position for GodMode
            player.Character.HumanoidRootPart.CFrame = CFrame.new(2142, -195, -1925)
            wait(0.2)
            
            -- Destroy the Waist part to simulate GodMode
            local upperTorso = player.Character:FindFirstChild("UpperTorso")
            if upperTorso and upperTorso:FindFirstChild("Waist") then
                upperTorso.Waist:Destroy()
            end
            
            -- Anchor the Head to prevent movement
            local head = player.Character:FindFirstChild("Head")
            if head then
                head.Anchored = true
            end
            
            wait(2)
            
            -- Return to the saved position
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = currentPos
            end
    
        else
            -- Save the current position before breaking joints
            local resetPos = player.Character.HumanoidRootPart.CFrame
            
            -- Break joints to reset the character
            player.Character:BreakJoints()
            wait(6.5)
            
            -- Teleport character back to the saved position
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = resetPos
            end
        end
    end)
    
    
    SSection:NewToggle("Invisibility", "", function(state)
        if state then
            -- Save current position
            local currentPos = player.Character.HumanoidRootPart.CFrame
            -- Teleport to a specific position outside of visibility
            player.Character.HumanoidRootPart.CFrame = CFrame.new(-2711, 229, -1769)
            wait(0.2)
    
            -- Remove the LowerTorso to make character invisible
            local lowerTorso = player.Character:FindFirstChild("LowerTorso")
            if lowerTorso and lowerTorso:FindFirstChild("Root") then
                lowerTorso.Root:Destroy()
            end
    
            wait(2)
            -- Return to the saved position
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = currentPos
            end
    
        else
            -- Save the current position before resetting the character
            local resetPos = player.Character.HumanoidRootPart.CFrame
            -- Reset character by breaking joints, making them visible again
            player.Character:BreakJoints()
            wait(6.5)
    
            -- Teleport character back to saved position
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = resetPos
            end
        end
    end)
    
    local player = game.Players.LocalPlayer
    
    SSection:NewToggle("Invisibility With Godmode", "", function(state)
        if state then
            -- Save current position
            local currentPos = player.Character.HumanoidRootPart.CFrame
            
            -- Teleport to a specific position for invisibility
            player.Character.HumanoidRootPart.CFrame = CFrame.new(-320, 86, 271)
            wait(0.2)
            
            -- Remove the LowerTorso to make character invisible
            local lowerTorso = player.Character:FindFirstChild("LowerTorso")
            if lowerTorso and lowerTorso:FindFirstChild("Root") then
                lowerTorso.Root:Destroy()
            end
            
            wait(2)
            
            -- Return to the saved position
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = currentPos
            end
    
        else
            -- Save the current position before breaking joints
            local resetPos = player.Character.HumanoidRootPart.CFrame
            
            -- Break joints to enable godmode (can be enhanced for actual godmode)
            player.Character:BreakJoints()
            wait(6.5)
            
            -- Teleport character back to the saved position
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = resetPos
            end
        end
    end)
    
    local player = game.Players.LocalPlayer
    
    SSection:NewToggle("Hide Title Gui", "", function(state)
        if state then
            getgenv().hide = true
            while getgenv().hide do
                wait(0.1) -- Reduced wait time for more responsive checks
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local rP = player.Character.HumanoidRootPart
                    -- Check for titleGui in the character
                    if rP:FindFirstChild("titleGui") then
                        rP.titleGui:Destroy()
                    end
                end
            end
        else
            getgenv().hide = false -- Set hide to false when the toggle is off
        end
    end)
    
    local playerToProtect = game.Players.LocalPlayer
    
    
    SSection:NewToggle("Auto MetalSkin", "Auto Turns On MetalSkin", function(state)
        getgenv().metal = state -- Directly set metal state based on the toggle
    
        if state then
            spawn(function() -- Start a new thread for the loop
                while getgenv().metal do
                    game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", true)
                    wait(0.2) -- Wait time to prevent overloading
                end
            end)
        else
            -- Turn off MetalSkin once if the toggle is off
            game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", false)
        end
    end)
    
    
    SSection:NewToggle("Destroy ForceFeild", "Turns Of The Forcefeild Around You When You Die", function(state)
        if state then
            getgenv().ff = true;
            while ff do
                wait(0.2);
                spawn(function()
                    game:GetService("Workspace")[_G.LOCALPLAYER].ForceField:Destroy();
                end);
            end
        else
            spawn(function()
                getgenv().ff = false;
            end);
        end
    end);
    local UserInputService = game:GetService("UserInputService")
local jumpHeight = 100 -- The height of the super jump
local defaultJumpHeight = game.Players.LocalPlayer.Character.Humanoid.JumpHeight -- Store default jump height

SSection:NewToggle("Super Jump", "Toggle to enable super jumps", function(state)
    local player = game.Players.LocalPlayer
    local character = player.Character
    local humanoid = character:WaitForChild("Humanoid")
    
    if state then
        -- When toggled on, set jump height to super high
        humanoid.JumpHeight = jumpHeight
        print("Super Jump Activated!")
    else
        -- When toggled off, revert jump height to normal
        humanoid.JumpHeight = defaultJumpHeight
        print("Super Jump Deactivated!")
    end
end)
SSection:NewToggle("Telekinesis Lock Aura", "", function(state)
    if state then
        getgenv().teleaura = true;
        while teleaura do
            wait();
            spawn(function()
                local LookVector = game.Workspace.Camera.CFrame.LookVector;
                game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, true);
                game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, false);
            end);
        end
    else
        spawn(function()
            getgenv().teleaura = false;
        end);
    end
end);
SSection:NewToggle("Telekinesis Space Fling", "", function(state)
    if state then
        -- Activate Telekinesis Space Fling
        getgenv().telesauras = true
        
        spawn(function()
            while getgenv().telesauras do
                task.wait(0.2) -- Wait to prevent overloading the server
                
                pcall(function()
                    -- Invoke the telekinesis events with extreme coordinates
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(999999, 999999, 999999), true)
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(999999, 999999, 999999), false)
                end)
            end
        end)
    else
        -- Deactivate Telekinesis Space Fling
        getgenv().telesauras = false
    end
end)
local UserInputService = game:GetService("UserInputService")
local isTelekinesisActive = false

-- Function to toggle Telekinesis Push
local function toggleTelekinesis()
    if not isTelekinesisActive then
        isTelekinesisActive = true

        spawn(function()
            while isTelekinesisActive do
                task.wait(0.2) -- Wait to prevent overloading the server

                pcall(function()
                    -- Get the player's character
                    local playerChar = game.Players.LocalPlayer.Character
                    if playerChar and playerChar:FindFirstChild("HumanoidRootPart") then
                        local myPosition = playerChar.HumanoidRootPart.Position
                        
                        -- Find nearby players (this could be improved to target only specific players if needed)
                        for _, v in pairs(game.Players:GetChildren()) do
                            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                                local target = v.Character
                                if target ~= playerChar then
                                    local targetHRP = target.HumanoidRootPart
                                    
                                    -- Calculate direction to push the target away from your character
                                    local direction = (targetHRP.Position - myPosition).unit -- Get the direction vector
                                    local pushForce = direction * 20 -- Adjust this number to control how much force is applied
                                    
                                    -- Apply the force to the target's humanoid root part
                                    targetHRP.Velocity = pushForce
                                end
                            end
                        end
                    end
                end)
            end
        end)
    else
        isTelekinesisActive = false
    end
end

-- Listen for the E key press to toggle Telekinesis
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.E then
        toggleTelekinesis() -- Toggle on key press
    end
end)

SSection:NewToggle("Safe Teleport", "", function(state)
    if state then
        -- Activate Safe Teleport
        local player = game.Players.LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        
        -- Ensure humanoid exists
        if not humanoid then
            warn("Humanoid not found! Safe Teleport cannot be enabled.")
            return
        end

        -- Calculate the health threshold
        local healthThreshold = humanoid.Health / 3
        getgenv().st = true

        -- Main loop for monitoring health and teleporting
        spawn(function()
            while getgenv().st do
                task.wait()
                if humanoid.Health < healthThreshold then
                    pcall(function()
                        -- Trigger telekinesis event
                        game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, player.Character)

                        -- Teleport the player to the safe position
                        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            rootPart.CFrame = CFrame.new(-1368.27539, 195.429108, 195.75)
                        end
                    end)
                end
            end
        end)
    else
        -- Deactivate Safe Teleport
        getgenv().st = false
    end
end)

SSection:NewToggle("Anti-Knockback", "", function(state)
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local PrimaryPart = character.PrimaryPart or character:WaitForChild("HumanoidRootPart")
    
    if state then
        getgenv().AntiKnockback = true
        local LastPosition = PrimaryPart.CFrame -- Initial position

        -- Start the anti-knockback loop
        while getgenv().AntiKnockback do
            task.wait()
            spawn(function()
                if PrimaryPart then
                    -- Check for high velocity to cancel knockback
                    if (PrimaryPart.AssemblyLinearVelocity.Magnitude > 250 or PrimaryPart.AssemblyAngularVelocity.Magnitude > 250) then
                        PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        PrimaryPart.CFrame = LastPosition
                    elseif (PrimaryPart.AssemblyLinearVelocity.Magnitude < 50 and PrimaryPart.AssemblyAngularVelocity.Magnitude < 50) then
                        -- Update LastPosition when velocity is low, indicating no knockback
                        LastPosition = PrimaryPart.CFrame
                    end
                end
            end)
        end
    else
        getgenv().AntiKnockback = false -- Stop the anti-knockback loop
    end
end)

SSection:NewToggle("Anti-Fling", "", function(state)
    if state then
        player.Character.HumanoidRootPart.Anchored = true;
    else
        player.Character.HumanoidRootPart.Anchored = false;
    end
end);
MSection:NewSlider("Speed", "", 2000, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s;
end);
MSection:NewSlider("Jump", "", 700, 50, function(s)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = s;
end);
MSection:NewButton("Inf jump", "", function()
    game:GetService("UserInputService").JumpRequest:connect(function()
        game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping");
    end);
end);
-- Table to hold clones of objects that will be destroyed
local destroyedObjects = {}

-- Function to destroy the specified objects and store clones
local function destroyObjects()
    local objectsToDestroy = {
        game:GetService("Workspace").City.Buildings,
        game:GetService("Workspace").City.Interactive.Bank.Model,
        game:GetService("Workspace").City.Interactive["Police Station"]:GetChildren()[28],
        game:GetService("Workspace").City.Interactive.Grove.WareHouse,
        game:GetService("Workspace").City.Interactive["Main Plaza"]:GetChildren()[38],
    }
    -- SafeZone barriers (assuming they are all the same part to simplify)
    for _, barrier in ipairs(game:GetService("Workspace").SafeZones:GetChildren()) do
        if barrier.Name == "Barrier" then
            table.insert(objectsToDestroy, barrier)
        end
    end

    -- Clone and destroy each object
    for _, obj in pairs(objectsToDestroy) do
        if obj and obj.Parent then
            table.insert(destroyedObjects, {clone = obj:Clone(), original = obj})
            obj:Destroy()
        end
    end
end

-- Function to restore the destroyed objects from their clones
local function restoreObjects()
    for _, entry in pairs(destroyedObjects) do
        if entry.clone and entry.original.Parent == nil then
            entry.clone.Parent = entry.original.Parent -- Set back to original location
        end
    end
    destroyedObjects = {} -- Clear the table after restoring
end

-- Toggle function for Destroy Safezone & Parts
MSection:NewButton("Safezone & Parts Destruction", "Destroy or restore safezone and specific parts", function(state)
    if state then
        destroyObjects() -- Destroy objects if toggle is ON
    else
        restoreObjects() -- Restore objects if toggle is OFF
    end
end)

MSection:NewButton("Anti-Lag", "", function()
    local Terrain = workspace:FindFirstChildOfClass("Terrain");
    Terrain.WaterWaveSize = 0;
    Terrain.WaterWaveSpeed = 0;
    Terrain.WaterReflectance = 0;
    Terrain.WaterTransparency = 0;
    settings().Rendering.QualityLevel = 1;
    for i, v in pairs(game:GetDescendants()) do
        if (v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart")) then
            v.Material = "Plastic";
            v.Reflectance = 0;
        elseif v:IsA("Decal") then
            v.Transparency = 1;
        elseif (v:IsA("ParticleEmitter") or v:IsA("Trail")) then
            v.Lifetime = NumberRange.new(0);
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1;
            v.BlastRadius = 1;
        end
    end
    workspace.DescendantAdded:Connect(function(child)
        coroutine.wrap(function()
            if child:IsA("ForceField") then
                RunService.Heartbeat:Wait();
                child:Destroy();
            elseif child:IsA("Sparkles") then
                RunService.Heartbeat:Wait();
                child:Destroy();
            elseif (child:IsA("Smoke") or child:IsA("Fire")) then
                RunService.Heartbeat:Wait();
                child:Destroy();
            end
        end)();
    end);
end);
MSection:NewButton("Ground Crack Lag", "", function(state)
    for i = 1, 1000 do
        game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
    end
end);
MSection:NewButton("Mini Ground Crack Lag", "", function(state)
    for i = 1, 500 do
        game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
    end
end);
MSection:NewButton("Mini Mini Ground Crack Lag", "", function(state)
    for i = 1, 200 do
        game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
    end
end);
MSection:NewButton("Mini Crash", "", function(state)
    local x = 0;
    repeat
        x += 1
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
    until x == 5000 
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
    wait();
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
end);
MSection:NewButton("Crash Server", "", function(state)
    local x = 0;
    repeat
        x += 1
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
    until x == 20000 
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
    wait();
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
end);
MSection:NewButton("Mini Crash Server + Mini ground crack lag", "", function(state)
    local x = 0;
    repeat
        x += 1
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
        game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
    until x == 4000
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
    wait();
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
end);

MSection:NewButton("Crash Server + ground crack lag", "", function(state)
    spawn(function ()
        local x = 0;
        repeat
            x += 1
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
        until x == 10000
    end)
    spawn(function ()
        local x = 0;
        repeat
            x += 1
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
        until x == 7500
    end)
    spawn(function ()
        local x = 0;
        repeat
            x += 1
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
        until x == 5000
    end)
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
    wait();
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
end);
MSection:NewButton("Break Velocity", "", function()
    breakvelocity();
end);
MSection:NewButton("Reset", "", function()
    player.Character:BreakJoints();
end);
GetList();
local slcplr = TargetSection:NewDropdown("Select Player", "", dropdown, function(currentOption)
    spawn(function()
        _G.tplayer = currentOption;
    end);
end);
TargetSection:NewButton("Refresh Dropdown", "", function()
    spawn(function()
        GetList();
        slcplr:Refresh(dropdown);
    end);
end);
-- Teleportation Functionality
local function teleportToPlayer(targetPlayerName)
local localPlayer = game.Players.LocalPlayer
local targetPlayer = game.Players:FindFirstChild(targetPlayerName)

if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and
    localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
    -- Teleport to the target player
    localPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
    -- Optional: Reset velocity if needed (e.g., breakvelocity function)
    localPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
else
    warn("Target player not found or invalid!")
end
end

-- Add a button in the UI for teleportation
TargetSection:NewButton("Teleport To Player", "", function()
if _G.tplayer then
    teleportToPlayer(_G.tplayer)
else
    warn("No target player set!")
end
end)

-- Bind the U key to teleportation
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, isProcessed)
if isProcessed then return end -- Ignore inputs already processed by other systems

if input.KeyCode == Enum.KeyCode.U then
    if _G.tplayer then
        teleportToPlayer(_G.tplayer)
    else
        warn("No target player set!")
    end
end
end)

-- Toggle to Spectate a Player
TargetSection:NewToggle("Spectate Player", "", function(state)
-- Update watch state based on toggle
getgenv().watch = state

-- Validate the target player
local function getTargetPlayer()
    local targetPlayer = game.Players:FindFirstChild(_G.tplayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
        return targetPlayer
    end
    return nil -- Return nil if the target is invalid
end

-- Function to spectate the target player
local function spectatePlayer()
    while getgenv().watch do
        local targetPlayer = getTargetPlayer()
        if targetPlayer then
            workspace.CurrentCamera.CameraSubject = targetPlayer.Character:FindFirstChild("Humanoid")
        else
            warn("Target player is invalid or not available.")
            break -- Exit the loop if the target becomes invalid
        end
        task.wait(0.001) -- Slight delay for smoother transitions and better performance
    end
end

-- Start or stop spectating based on toggle state
if getgenv().watch then
    -- Start spectating in a new thread
    spawn(spectatePlayer)
else
    -- Reset camera to the local player
    workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
end
end)

TargetSection:NewButton("Allow Target To Crash", "", function()
    spawn(function()
        game.Players[_G.tplayer].Chatted:Connect(function(Message) 
            if string.lower(Message) == "crash" or string.lower(Message) == "crash server" or string.lower(Message) == "cs" then
                for i = 1, 15000 do
                    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
                    game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
                end
            end
        end);
    end);
end);
TargetSection:NewButton("Allow All Players To Crash", "", function()
    for i, v in pairs(game.Players:GetPlayers()) do
        v.Chatted:Connect(function(Message) 
            if string.lower(Message) == "crash" or string.lower(Message) == "crash server" or string.lower(Message) == "cs" then
                for i = 1, 15000 do
                    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
                    game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
                end
            end
        end);
    end
end);
TargetSection:NewButton("Allow Target to Kill Players (kill <username>)", "", function()
    local function GetPlayer(input)
        for _, Player in pairs(game:GetService("Players"):GetPlayers()) do
            if (string.lower(input) == string.sub(string.lower(Player.Name), 1, #input)) then
                return Player;
            end
        end
    end

    spawn(function()
        game.Players[_G.tplayer].Chatted:Connect(function(Message)
            local KillingTime = 0
            local Chat = string.split(Message, " ")
            if string.lower(Chat[1]) == "kill" then
                local varX = game.Players.LocalPlayer.Character.HumanoidRootPart.Position['X'];
                local varY = game.Players.LocalPlayer.Character.HumanoidRootPart.Position['Y'];
                local varZ = game.Players.LocalPlayer.Character.HumanoidRootPart.Position['Z'];
                wait();
                local p1 = game.Players.LocalPlayer.Character.HumanoidRootPart;
                local pos = p1.CFrame;
                getgenv().breakv = true;
                game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", true);
                spawn(function()
                    repeat KillingTime += 1
                        task.wait();
                        task.wait();
                        task.wait();
                        task.wait();
                        task.wait();
                        task.wait();
                        spawn(function()
                            pcall(function()
                                for i, v in pairs(game.Workspace:GetChildren()) do
                                    if ((string.lower(v.Name) == string.lower(GetPlayer(Chat[2]).Character.Name)) and v:FindFirstChild("Humanoid") and (v.Humanoid.Health > 0)) then
                                        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1);
                                        spawn(function()
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                        end)
                                        spawn(function()
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                        end)
                                        spawn(function()
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                        end)
                                        spawn(function()
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                        end)
                                        spawn(function()
                                            local LookVector = game.Workspace.Camera.CFrame.LookVector;
                                            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, true);
                                            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, false);
                                        end);	
                                    end
                                end
                            end);
                        end);
                    until KillingTime == 40
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(varX, varY, varZ);
                    spawn(function()
                        getgenv().breakv = false;
                        wait(0.2);
                        breakvelocity();
                    end)
                end)
            end
        end)
    end);
end);


TargetSection:NewButton("Farm", "", function()
    local player = game.Players[_G.tplayer]
    lplayer = game.Players.LocalPlayer
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("","All")

    player.Chatted:Connect(function(msg) 
        if msg == "reset" then
            lplayer.Character:BreakJoints()
        else if msg == "Reset" then
                lplayer.Character:BreakJoints()
            else if msg == "Farm" then
                    spawn(function()
                        getgenv().lb = true
                        while lb do
                            game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin",true)
                            spawn(function()
                                game:GetService("Workspace")[lplayer.Name].ForceField:Destroy()
                            end)
                            wait()
                            spawn(function()
                                X = player.Character.HumanoidRootPart.Position.X
                                Y = player.Character.HumanoidRootPart.Position.Y
                                Z = player.Character.HumanoidRootPart.Position.Z
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(X,Y,Z + 3)
                            end)
                        end
                    end)
                else if msg == "farm" then
                        spawn(function()
                            getgenv().lb = true
                            while lb do
                                game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin",true)
                                spawn(function()
                                    game:GetService("Workspace")[lplayer.Name].ForceField:Destroy()
                                end)
                                wait()
                                spawn(function()
                                    X = player.Character.HumanoidRootPart.Position.X
                                    Y = player.Character.HumanoidRootPart.Position.Y
                                    Z = player.Character.HumanoidRootPart.Position.Z
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(X,Y,Z + 3)
                                end)
                            end
                        end)
                    else if msg == "unfarm" then
                            getgenv().lb = false
                        else if msg == "Unfarm" then
                                getgenv().lb = false
                            else if msg == "z" then
                                    game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1)
                                    game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) 
                                    game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) 
                                else if msg == "Z" then
                                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1)
                                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) 
                                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) 
                                    else if msg == "kill" then
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1)
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) 
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1)  
                                        else if msg == "Kill" then
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1)
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) 
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1)  
                                            else if msg == "help" then
                                                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Commands: farm, unfarm, reset, kill","All")
                                                else if msg == "Help" then
                                                        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Commands: farm, unfarm, reset, kill","All")
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end);
-- Kill Player Toggle
TargetSection:NewToggle("Kill Player", "", function(state)
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
                breakvelocity() -- Ensure breakvelocity() is defined elsewhere
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
end)


TargetSection:NewToggle("Stick To Player", "", function(state)
    if state then
        getgenv().loopgoto = true;
        local varX = player.Character.HumanoidRootPart.Position['X'];
        local varY = player.Character.HumanoidRootPart.Position['Y'];
        local varZ = player.Character.HumanoidRootPart.Position['Z'];
        wait();
        local p1 = game.Players.LocalPlayer.Character.HumanoidRootPart;
        local pos = p1.CFrame;
        getgenv().breakv = true;
        spawn(function()
            while breakv do
                wait(1);
                breakvelocity();
            end
        end);
        while loopgoto do
            task.wait();
            spawn(function()
                pcall(function()
                    for i, v in pairs(game.Workspace:GetChildren()) do
                        if ((v.Name == _G.tplayer) and v:FindFirstChild("Humanoid") and (v.Humanoid.Health > 0)) then
                            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4);
                        end
                    end
                end);
            end);
            spawn(function()
                if (loopgoto == false) then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(varX, varY, varZ);
                end
            end);
        end
    else
        spawn(function()
            getgenv().breakv = false;
            wait(0.2);
            getgenv().loopgoto = false;
            wait(0.1);
            getgenv().loopgoto = true;
            breakvelocity();
        end);
    end
end);
-- Anti-Telekinesis Toggle
TargetSection:NewToggle("Give Player Anti-Tele", "Gives Assigned Player Anti-Tele", "", function(state)
spawn(function()
    if state then
        getgenv().at = true
        while getgenv().at do
            local player = game:GetService("Players")[_G.tplayer]
            if player and player.Character then
                game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(
                    Vector3.new(0, 0, 0),
                    false,
                    player.Character
                )
            end
            wait(0.1)
        end
    else
        getgenv().at = false
    end
end)
end)

-- TP Orbs to Players in Telekinesis Toggle
TargetSection:NewToggle("TP orbs to Players in telekinesis", "", function(state)
function TpOrbs()
    if state then
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
end)


TargetSection:NewToggle("Laser", "", function(state)
    spawn(function()
        if state then
            getgenv().LaserL = true;
            wait();
            coroutine.resume(coroutine.create(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision;
                local part = event:InvokeServer(true);
                getgenv().LaserL = true;
                while LaserL and part and _G.tplayer do
                    wait();
                    local target = game.Players:FindFirstChild(_G.tplayer);
                    if (target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")) then
                        part.Position = target.Character.HumanoidRootPart.Position;
                    end
                end
                event:InvokeServer(false);
            end));
        else
            spawn(function()
                getgenv().LaserL = false;
            end);
        end
    end);
end);
TargetSection:NewToggle("Laser From Sky", "Laser Beams Assigned Player From Sky", function(state)
    spawn(function()
        if state then
            local orbX = player.Character.HumanoidRootPart.Position["X"];
            local orbY = player.Character.HumanoidRootPart.Position["Y"];
            local orbZ = player.Character.HumanoidRootPart.Position["Z"];
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(orbX, 5000, orbZ);
            getgenv().LaserL = true;
            wait(0.2);
            player.Character.HumanoidRootPart.Anchored = true;
            coroutine.resume(coroutine.create(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision;
                local part = event:InvokeServer(true);
                getgenv().LaserL = true;
                while LaserL and part and _G.tplayer do
                    wait();
                    local target = game.Players:FindFirstChild(_G.tplayer);
                    if (target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")) then
                        part.Position = target.Character.HumanoidRootPart.Position;
                    end
                end
                event:InvokeServer(false);
            end));
        else
            player.Character.HumanoidRootPart.Anchored = false;
            spawn(function()
                getgenv().LaserL = false;
            end);
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(orbX, orbY, orbZ);
            breakvelocity();
        end
    end);
end);
TargetSection:NewToggle("Give Orbs", "", function(state)
    spawn(function()
        if state then
            getgenv().ORBGIVE = true;
            while ORBGIVE do
                local character = game.Players:FindFirstChild(_G.tplayer).Character;
                for i, v in pairs(game:GetService("Workspace").ExperienceOrbs:GetChildren()) do
                    local hrp = character.HumanoidRootPart;
                    v.CFrame = hrp.CFrame;
                end
                wait();
            end
        else
            spawn(function()
                getgenv().ORBGIVE = false;
            end);
        end
    end);
end);
TargetSection:NewButton("Remove Gyro", "", function()
    game:GetService("Workspace")[_G.tplayer].HumanoidRootPart.telekinesisGyro:Destroy();
    game:GetService("Workspace")[_G.tplayer].HumanoidRootPart.telekinesisPosition:Destroy();
    game:GetService("Workspace")[_G.tplayer].Humanoid.PlatformStand = false;
    game:GetService("Workspace")[_G.tplayer].Humanoid.WalkSpeed = 200;
    game:GetService("Workspace")[_G.tplayer].Humanoid.JumpPower = 150;
end);
TargetSection:NewToggle("Disable Telekinesis", "", function(state)
    spawn(function()
        if state then
            Players = game:GetService("Players");
            for i, player in pairs(Players:GetPlayers()) do
                getgenv().LToggle = true;
                spawn(function()
                    while LToggle do
                        wait();
                        game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[player.Name].Character);
                    end
                end);
            end
        else
            spawn(function()
                getgenv().LToggle = false;
            end);
        end
    end);
end);
TargetSection:NewToggle("Fling Player", "", function(state)
    if state then
        -- Activate Fling
        getgenv().fling = true
        local startPosition = player.Character.HumanoidRootPart.Position
        wait()

        local p1 = player.Character.HumanoidRootPart

        -- Update physical properties for all parts of the character
        for _, child in pairs(player.Character:GetDescendants()) do
            if child:IsA("BasePart") then
                child.CustomPhysicalProperties = PhysicalProperties.new(math.huge, 0.3, 0.5)
            end
        end

        -- Add BodyAngularVelocity to the HumanoidRootPart
        local bambam = Instance.new("BodyAngularVelocity")
        bambam.Parent = p1
        bambam.AngularVelocity = Vector3.new(0, 1000, 0)
        bambam.MaxTorque = Vector3.new(0, math.huge, 0)

        -- Loop to manage the fling functionality
        spawn(function()
            while getgenv().fling do
                task.wait()
                pcall(function()
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v.Name == _G.tplayer and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            p1.CFrame = v.HumanoidRootPart.CFrame
                        end
                    end
                end)

                -- Prevent the player from being affected by physics
                for _, v in pairs(player.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                        v.Massless = true
                        v.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end)
    else
        -- Deactivate Fling
        getgenv().fling = false
        wait(0.1)

        -- Reset character properties
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BodyAngularVelocity") then
                v:Destroy()
            end
            if v:IsA("BasePart") or v:IsA("MeshPart") then
                v.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
                v.CanCollide = true
                v.Massless = false
            end
        end

        -- Optional: Ensure velocity and physics reset
        if player.Character.HumanoidRootPart then
            player.Character.HumanoidRootPart.Velocity = Vector3.zero
        end
    end
end)

    TargetSection:NewToggle("Gives Player Anti-Fling", "Gives Assigned Player Anti Fling", function(state)
        -- Ensure the player variable is set correctly
        local playerName = _G.tplayer
        local player = game:GetService("Players"):FindFirstChild(playerName)
    
        if not player then
            warn("Player not found: " .. tostring(playerName))
            return
        end
    
        spawn(function()
            getgenv().af = state
            while getgenv().af do 
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = player.Character.HumanoidRootPart
                    -- Adjust the position slightly to counteract fling forces
                    rootPart.Velocity = Vector3.new(0, 0, 0)
                    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                else
                    warn("Character or HumanoidRootPart not found for player: " .. tostring(playerName))
                end
                wait(0.1)
            end
        end)
    end)
    
    TargetSection:NewToggle("Gives Player Anti-Tele", "Gives Assigned Player Anti Tele", function(state)
        -- Ensure the player variable is set correctly
        local playerName = _G.tplayer
        local player = game:GetService("Players"):FindFirstChild(playerName)
    
        if not player then
            warn("Player not found: " .. tostring(playerName))
            return
        end
    
        spawn(function()
            getgenv().at = state
            while getgenv().at do 
                if player.Character then
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(0, 0, 0), false, player.Character)
                else
                    warn("Character not found for player: " .. tostring(playerName))
                end
                wait(0.1)
            end
        end)
    end)
    
    
    TargetSection:NewToggle("Laser", "", function(state)
        if state then
            getgenv().LaserL = true
            local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
            local part = event:InvokeServer(true)
    
            -- Using a coroutine for continuous execution
            spawn(function()
                while getgenv().LaserL and part and _G.tplayer do
                    wait()
                    local target = game.Players:FindFirstChild(_G.tplayer)
                    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        -- Set the position of the laser part to the target's HumanoidRootPart position
                        part.Position = target.Character.HumanoidRootPart.Position
                    end
                end
                -- Turn off the laser vision when the toggle is switched off
                event:InvokeServer(false)
            end)
        else
            getgenv().LaserL = false
        end
    end)
    
    
    TargetSection:NewToggle("Laser From Sky", "Laser Beams Assigned Player From Sky", function(state)
        spawn(function()
            if state then
                local orbPosition = player.Character.HumanoidRootPart.Position
                player.Character.HumanoidRootPart.CFrame = CFrame.new(orbPosition.X, 5000, orbPosition.Z)
                wait(0.2)
                player.Character.HumanoidRootPart.Anchored = true
                getgenv().LaserL = true
    
                coroutine.resume(coroutine.create(function()
                    local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                    local part = event:InvokeServer(true)
                    while LaserL and part and _G.tplayer do
                        wait()
                        local target = game.Players:FindFirstChild(_G.tplayer)
                        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                            part.Position = target.Character.HumanoidRootPart.Position
                        end
                    end
                    event:InvokeServer(false)
                end))
            else
                player.Character.HumanoidRootPart.Anchored = false
                getgenv().LaserL = false
                local orbPosition = player.Character.HumanoidRootPart.Position
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(orbPosition.X, orbPosition.Y, orbPosition.Z)
                breakvelocity() -- Make sure to define breakvelocity elsewhere in your code
            end
        end)
    end)
    
    TargetSection:NewToggle("Give Orbs", "", function(state)
        spawn(function()
            if state then
                getgenv().ORBGIVE = true
                while ORBGIVE do
                    local character = game.Players:FindFirstChild(_G.tplayer).Character
                    for _, v in pairs(game:GetService("Workspace").ExperienceOrbs:GetChildren()) do
                        local hrp = character.HumanoidRootPart
                        v.CFrame = hrp.CFrame
                    end
                    wait()
                end
            else
                getgenv().ORBGIVE = false
            end
        end)
    end)
    
    TargetSection:NewButton("Remove Gyro", "", function()
        local targetPlayer = game:GetService("Workspace")[_G.tplayer]
        if targetPlayer and targetPlayer:FindFirstChild("HumanoidRootPart") then
            targetPlayer.HumanoidRootPart.telekinesisGyro:Destroy()
            targetPlayer.HumanoidRootPart.telekinesisPosition:Destroy()
            targetPlayer.Humanoid.PlatformStand = false
            targetPlayer.Humanoid.WalkSpeed = 200
            targetPlayer.Humanoid.JumpPower = 150
        end
    end)
    
-- Anti-exploit toggle for disabling telekinesis with auto-reset if tampered
TargetSection:NewToggle("Enable Telekinesis", "Automatically prevents telekinesis", function(state)
    -- Toggle to enable/disable telekinesis protection
    getgenv().LToggle = state

    -- Start the main telekinesis protection loop
    spawn(function()
        while true do
            -- Ensure LToggle remains enabled
            if getgenv().LToggle then
                -- Loop through all players to protect them from telekinesis
                for _, targetPlayer in pairs(game:GetService("Players"):GetPlayers()) do
                    if targetPlayer.Character then
                        game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, targetPlayer.Character)
                    end
                end
            else
                -- If LToggle was set to false by any outside influence, reset it to true
                getgenv().LToggle = true
            end
            wait(0.1) -- Small delay to reduce server load while checking
        end
    end)
end)


    TargetSection:NewToggle("Disable Telekinesis", "", function(state)
        spawn(function()
            getgenv().LToggle = state
            for _, targetPlayer in pairs(game:GetService("Players"):GetPlayers()) do
                spawn(function()
                    while getgenv().LToggle do
                        wait()
                        game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, targetPlayer.Character)
                    end
                end)
            end
        end)
    end)
SSection:NewToggle("Shield Burst - Age Of Heroes", "Toggle Shield Burst effect", function(state)
    shieldBurstActive = state  -- Update the Shield Burst state

    if shieldBurstActive then
        -- Begin Shield Burst in a coroutine to prevent blocking the main thread
        coroutine.wrap(function()
            local burstCount = 0  -- Tracks number of activations
            
            while shieldBurstActive do
                -- Fire the shield activation event
                game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(true)

                burstCount = burstCount + 1  -- Increment the activation count
                
                -- If burst count reaches set intensity, reset or pause briefly
                if burstCount >= shieldBurstIntensity then
                    burstCount = 0
                    wait(0.3)  -- Pause briefly after reaching max burst for smoother performance
                end

                wait(0.1)  -- Control frequency of shield activations
            end

            -- Turn off shield when Shield Burst is deactivated
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false)
        end)()
    else
        -- Ensure shield is turned off when Shield Burst toggle is deactivated
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false)
    end
end)


SSection:NewToggle("Ground Crack Aura", "", function(state)
    -- Toggle control
    getgenv().GroundCrackAuraActive = state

    -- Set cooldown interval in seconds to reduce frequency
    local crackCooldown = 0.2
    local lastCrackTime = 0

    -- Function to activate Ground Crack with cooldown
    local function activateGroundCrack()
        if (tick() - lastCrackTime) >= crackCooldown then
            lastCrackTime = tick()
            pcall(function()
                -- Fire GroundCrack event at a controlled rate
                game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer()
            end)
        end
    end

    -- Manage aura activation with RunService Stepped
    local auraConnection
    if state then
        -- Enable aura with interval checking to reduce lag
        auraConnection = game:GetService("RunService").Stepped:Connect(function()
            if getgenv().GroundCrackAuraActive then
                activateGroundCrack()
            else
                auraConnection:Disconnect()
            end
        end)
    else
        -- Disable the aura
        getgenv().GroundCrackAuraActive = false
        if auraConnection then auraConnection:Disconnect() end
    end
end)
SSection:NewToggle("Speed Spam - Age Of Heroes", "", function(state)
    isSpamming = state -- Update the spamming state

    if isSpamming then
        -- Continuously enable speed based on the set intensity
        while isSpamming do
            game:GetService("ReplicatedStorage").Events.ToggleSpeed:FireServer(true) -- Turn on speed
            wait(0.1)  -- Small wait to avoid overwhelming the client
        end
    else
        -- Ensure speed is disabled if spamming is stopped
        game:GetService("ReplicatedStorage").Events.ToggleSpeed:FireServer(false) -- Turn off speed
    end
end)


SSection:NewToggle("Rapid Heavy Punch", "", function(state)
    getgenv().Hrapid = state  -- Update the state of the rapid punching

    local UserInputService = game:GetService("UserInputService")
    
    if state then
        -- When the toggle is turned on
        local function onInputEnded(inputObject, gameProcessedEvent)
            if gameProcessedEvent then
                return
            end
            if getgenv().Hrapid and (inputObject.UserInputType == Enum.UserInputType.MouseButton1) then
                -- Loop to perform the punching action
                for i = 1, 10 do  -- Number of punches
                    game:GetService("ReplicatedStorage").Events.Punch:FireServer(0.4, 0.1, 1)
                    wait(0.1)  -- Small wait to avoid overwhelming the server
                end
            end
        end
        UserInputService.InputEnded:Connect(onInputEnded)
    else
        -- When the toggle is turned off
        getgenv().Hrapid = false
    end
end)



MSection:NewButton("Super Mega Crash", "", function(state)
    local totalIterations = 25000 -- Set total iterations
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local toggleBlockingEvent = replicatedStorage.Events.ToggleBlocking

    -- Function to fire the server event with a delay
    local function fireEvent(times)
        for i = 1, times do
            toggleBlockingEvent:FireServer("true")
            wait(0.01) -- Small delay to prevent server overload (adjust as needed)
        end
    end

    -- Spawn three threads to fire the event with dynamic counts
    spawn(function()
        fireEvent(math.ceil(totalIterations * 0.5)) -- 50% of total iterations
    end)

    spawn(function()
        fireEvent(math.ceil(totalIterations * 0.75)) -- 75% of total iterations
    end)

    spawn(function()
        fireEvent(totalIterations) -- 100% of total iterations
    end)

    -- Fire the toggleBlocking event with false after all events
    wait(totalIterations * 0.01 * 3) -- Adjust wait based on total calls (considering the delay)
    toggleBlockingEvent:FireServer(false)
end)

MSection:NewToggle("Anti AFK", "Prevents you from being marked as AFK", function(state)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    
    -- Variable to track Anti-AFK status
    getgenv().AntiAFKEnabled = false
    
    -- Function to enable or disable Anti-AFK
    local function toggleAntiAFK(state)
        getgenv().AntiAFKEnabled = state
    
        if state then
            -- Create a heartbeat connection to keep the player active
            RunService.Heartbeat:Connect(function()
                if getgenv().AntiAFKEnabled then
                    local player = Players.LocalPlayer
                    if player and player.Character then
                        -- Simulate character movement to prevent AFK status
                        local humanoid = player.Character:FindFirstChild("Humanoid")
                        if humanoid then
                            -- Slightly move the character
                            humanoid:Move(Vector3.new(0.01, 0, 0), true)  -- Move character slightly
                            humanoid:Move(Vector3.new(-0.01, 0, 0), false) -- Reset movement
                        end
                    end
                end
            end)
        end
    end
    
    
        toggleAntiAFK(state)
    end)


MSection:NewButton("Anti-Lag", "", optimizePerformance)
MSection:NewButton("Ground Crack Lag", "", function(state)
    for i = 1, 1000 do
        game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
    end
end);
MSection:NewButton("Mini Ground Crack Lag", "", function(state)
    for i = 1, 500 do
        game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
    end
end);
MSection:NewButton("Mini Mini Ground Crack Lag", "", function(state)
    for i = 1, 200 do
        game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
    end
end);
MSection:NewButton("Mini Crash", "", function(state)
    local x = 0;
    repeat
        x += 1
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
    until x == 5000 
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
    wait();
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
 end);
MSection:NewButton("Super Crash", "", function(state)
local x = 0;
local y = 0
local z = 0
spawn(function()
repeat
    x += 1
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
until x == 10000
end)
spawn(function()
repeat
    y += 1
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
until y == 10000 
end)
spawn(function()
repeat
    z += 1
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
until z == 10000 
end)


    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
    wait();
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
end);
MSection:NewButton("Haha crasher", "Initiates secure blocking actions.", function()
    -- Initialize counters
    local x, y, z = 0, 0, 0

    -- Helper function to safely fire the event with rate-limiting and validation
    local function safeFireServer(event, action, counter, max)
        if counter < max then
            event:FireServer(action)
            return counter + 1
        else
            warn("Maximum limit reached for firing this event.")
            return counter
        end
    end

    -- Function to execute repetitive actions securely
    local function executeSafeAction(maxCount, eventName, action)
        local counter = 0
        local event = game:GetService("ReplicatedStorage").Events[eventName]

        spawn(function()
            repeat
                counter = safeFireServer(event, action, counter, maxCount)
                task.wait(0.001) -- Add a short delay to reduce spam and avoid abuse
            until counter >= maxCount
        end)
    end

    -- Execute secure actions with proper limits
    executeSafeAction(25000, "ToggleBlocking", "true")
    executeSafeAction(25000, "ToggleBlocking", "true")
    executeSafeAction(25000, "ToggleBlocking", "true")
    executeSafeAction(25000, "ToggleBlocking", "true")
    executeSafeAction(25000, "ToggleBlocking", "true")
    executeSafeAction(25000, "ToggleBlocking", "true")
    executeSafeAction(25000, "ToggleBlocking", "true")
    executeSafeAction(25000, "ToggleBlocking", "true")

    -- Additional state changes (if required)
    local blockingEvent = game:GetService("ReplicatedStorage").Events.ToggleBlocking
    task.wait(0.5) -- Short delay to allow previous actions to settle
    blockingEvent:FireServer(false)
    task.wait(0.5)
    blockingEvent:FireServer(false)
end)



MSection:NewButton("Super Mega Crash", "", function(state)
local x = 0;
local y = 0
local z = 0
spawn(function()
repeat
    x += 1
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
until x == 25000
end)
spawn(function()
repeat
    y += 1
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
until y == 25000 
end)
spawn(function()
repeat
    z += 1
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
until z == 25000 
end)


    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
    wait();
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
end);
MSection:NewButton("Global Anti-Crash", "", function()
    -- Check and destroy the objects safely
    if game:FindFirstChild("ClientStorage") and game.ClientStorage:FindFirstChild("Effects") then
        if game.ClientStorage.Effects:FindFirstChild("Shield") then
            game.ClientStorage.Effects.Shield:Destroy()
        end
    end
    if game:FindFirstChild("Workspace") and game.Workspace:FindFirstChild("Effects") then
        game.Workspace.Effects:Destroy()
    end
end)

-- To make the button global, repeat it in other sections or centralize its functionality:
local GlobalButton = function()
    if game:FindFirstChild("ClientStorage") and game.ClientStorage:FindFirstChild("Effects") then
        if game.ClientStorage.Effects:FindFirstChild("Shield") then
            game.ClientStorage.Effects.Shield:Destroy()
        end
    end
    if game:FindFirstChild("Workspace") and game.Workspace:FindFirstChild("Effects") then
        game.Workspace.Effects:Destroy()
    end
end

MSection:NewButton("Anti-Crash", "", function()
  game.ClientStorage.Effects.Shield:Destroy()
  game.Workspace.Effects:destroy() 
end);














KSection:NewKeybind("MetalSkin", "", Enum.KeyCode['LeftShift'], function()
    if (_G.metalskin == false) then
        game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", true);
        _G.metalskin = true;
    else
        game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", false);
        _G.metalskin = false;
     end
end);
local player = game.Players.LocalPlayer
local plrlist = {}

KSRCSection:NewKeybind("Carry Player", "", Enum.KeyCode['H'], function()
    if not _G.CToggle then
        spawn(function()
            getNearPlayer(99) -- Assuming this function populates plrlist with nearby players and NPCs
            wait()
            _G.CToggle = true
            getgenv().CarryP = true
            
            while getgenv().CarryP do
                wait(0.1) -- Added a small wait for performance
                for _, v in pairs(plrlist) do
                    if v ~= player then -- Ensure we're not trying to carry ourselves
                        local target
                        -- Check if the target is a player or an NPC
                        if game.Players:FindFirstChild(v.Name) then
                            target = game.Players[v.Name].Character
                        else
                            target = game.Workspace:FindFirstChild(v.Name) -- Assumes NPCs are directly in Workspace
                        end

                        -- Ensure the target has a valid character and HumanoidRootPart
                        if target and target:FindFirstChild("HumanoidRootPart") then
                            local targetHumanoidRootPart = target.HumanoidRootPart
                            local Xt = player.Character.HumanoidRootPart.Position.X
                            local Yt = player.Character.HumanoidRootPart.Position.Y
                            local Zt = player.Character.HumanoidRootPart.Position.Z
                            
                            -- Set the target's telekinesis position
                            targetHumanoidRootPart.Position = Vector3.new(Xt, Yt + 8, Zt + 5)
                        end
                    end
                end
            end
        end)
    else
        -- Turn off carrying
        spawn(function()
            _G.CToggle = false
            plrlist = {}
            getgenv().CarryP = false
        end)
    end
end)

KSection:NewKeybind("Telekinesis Lock", "", Enum.KeyCode['T'], function()
    spawn(function()
        local LookVector = game.Workspace.Camera.CFrame.LookVector;
        game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, true);
        game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, false);
    end);
end);
KSection:NewKeybind("Telekinesis kill", "", Enum.KeyCode['G'], function()
    spawn(function()
        getNearPlayer(99);
        for i, v in pairs(plrlist) do
            if (v == player) then
            else
                spawn(function()
                    v.Head.Neck:Destroy();
                    plrlist = {};
                    wait(0.2);
                    spawn(function()
                        game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                    end);
                end);
            end
        end
    end);
end);
KSection:NewKeybind("Release Telekinesis", "", Enum.KeyCode['C'], function()
    plrlist = {};
    Players = game:GetService("Players");
    for i, player in pairs(Players:GetPlayers()) do
        spawn(function()
            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[player.Name].Character);
        end);
    end
end);
KSection:NewKeybind("Telekinesis kill (Target Only)", "", Enum.KeyCode.Seven, function()
    spawn(function()
        getNearPlayer(999999);
        for i, v in pairs(plrlist) do
            if (v == player) then
            else
                spawn(function()
                    if (v.Name == _G.tplayer) then
                        v.Head.Neck:Destroy();
                        plrlist = {};
                        wait(0.2);
                        spawn(function()
                            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                        end);
                    end
                end);
            end
        end
    end);
end);
KSection:NewKeybind("Teleport To Motel", "", Enum.KeyCode.Z, function()
  if (_G.bring == true) then
        game:GetService("Workspace")[_G.teleportplayer].HumanoidRootPart.telekinesisPosition:Destroy()
        game:GetService("Workspace")[_G.teleportplayer].HumanoidRootPart.CFrame = CFrame.new(-1745, 95, -1530);
        wait(0.2)
        game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[_G.teleportplayer].Character);
    else
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1745, 95, -1530);
    end
    breakvelocity();
end);
KSection:NewKeybind("Teleport To Middle", "", Enum.KeyCode.V, function()
 if (_G.bring == true) then
        game:GetService("Workspace")[_G.teleportplayer].HumanoidRootPart.telekinesisPosition:Destroy()
        game:GetService("Workspace")[_G.teleportplayer].HumanoidRootPart.CFrame = CFrame.new(-376, 94, 91);
        wait(0.2)
        game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[_G.teleportplayer].Character);
    else
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-376, 94, 91);
    end
    breakvelocity();
end);
KSection:NewKeybind("Toggle UI", "", Enum.KeyCode.Y, function()
    Library:ToggleUI();
end);
GSection:NewButton("Infinite Yield", "", function()
loadstring(game:HttpGet("https://pastebin.com/raw/aCmksbMy"))();
end);
GSection:NewButton("Chat Spammer", "", function()
loadstring(game:HttpGet(('https://raw.githubusercontent.com/ColdStep2/Chatdestroyer-Hub-V1/main/Chatdestroyer%20Hub%20V1'),true))()
end);
GSection:NewButton("Chat Spoofer", "", function()
 loadstring(game:HttpGet(('https://pastebin.com/raw/djBfk8Li'),true))()
end);