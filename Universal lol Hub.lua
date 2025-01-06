local library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ShaddowScripts/Main/main/Library"))()
local Main = library:CreateWindow("Universal lol Hub Script","Deep Sea")
local tab1 = Main:CreateTab("AutoClickers")
local tab2 = Main:CreateTab("ESP")
local tab3 = Main:CreateTab("Cheats")
local tab4 = Main:CreateTab("Self Menu")
local tab5 = Main:CreateTab("Target")
local tab6 = Main:CreateTab("Farming")
local tab7 = Main:CreateTab("Aura")
local tab8 = Main:CreateTab("Misc")
local tab9 = Main:CreateTab("Settings")








getgenv().OutlineColor = Color3.new(1, 0, 1)
getgenv().ESPEnabled = false

local function addESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then

        local highlight = Instance.new("Highlight")
        highlight.Parent = player.Character
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0 
        highlight.OutlineColor = getgenv().OutlineColor 

        local billboard = Instance.new("BillboardGui")
        billboard.Parent = player.Character:WaitForChild("Head")
        billboard.Size = UDim2.new(1, 0, 1, 0)
        billboard.Adornee = player.Character.Head
        billboard.SizeOffset = Vector2.new(0, 2) 

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = player.Name
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.new(1, 1, 1) 
        nameLabel.Font = Enum.Font.SourceSans
        nameLabel.TextSize = 14
        nameLabel.Parent = billboard
    end
end

local function removeESP(player)
    if player.Character then
        local highlight = player.Character:FindFirstChildOfClass("Highlight")
        if highlight then
            highlight:Destroy()
        end
        local billboard = player.Character:FindFirstChildOfClass("BillboardGui")
        if billboard then
            billboard:Destroy()
        end
    end
end


tab2:CreateToggle("Player ESP", function(state)
    getgenv().ESPEnabled = state

    if state then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                addESP(player)
            end
        end
        game.Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function(character)
                if player ~= game.Players.LocalPlayer then
                    addESP(player)
                end
            end)
        end)

    else
        for _, player in pairs(game.Players:GetPlayers()) do
            removeESP(player)
        end
    end
end)
tab2:CreateToggle("NPC ESP", function(a)
    _G.NPCESP = a

    local function applyNPCESP(npc)
        -- Check if the NPC is a Model and has Humanoid-like characteristics
        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
            -- Avoid creating duplicate highlights
            if not npc:FindFirstChild("Highlight") then
                local highlight = Instance.new("Highlight")
                highlight.Parent = npc
                highlight.FillColor = Color3.fromRGB(255, 105, 180) -- Pink
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- White
                highlight.FillTransparency = 0.5 -- Slightly transparent
            end
        end
    end

    if _G.NPCESP then
        -- Apply ESP to all existing NPCs in the workspace
        for _, npc in pairs(workspace:GetDescendants()) do
            applyNPCESP(npc)
        end

        -- Listen for newly added NPCs
        if not _G.npcAddedConnection then
            _G.npcAddedConnection = workspace.DescendantAdded:Connect(function(descendant)
                applyNPCESP(descendant)
            end)
        end
    else
        -- Remove ESP from all NPCs
        for _, npc in pairs(workspace:GetDescendants()) do
            local highlight = npc:FindFirstChild("Highlight")
            if highlight then
                highlight:Destroy()
            end
        end

        -- Disconnect the connection if it exists
        if _G.npcAddedConnection then
            _G.npcAddedConnection:Disconnect()
            _G.npcAddedConnection = nil
        end
    end
end)

--# AutoClickers for K, F, E, Q, G, X, T, Y
local keys = {"K", "F", "E", "Q", "G", "X", "T", "Y", "N", "B", "C", "Z", "V"} -- List of keys to create toggles for
 -- Create a tab for AutoClickers

-- Function to create an auto-clicker toggle for a specific key
local function createAutoClickToggle(key)
    tab1:CreateToggle("AutoClick'" .. key .. "'", function(state)
        getgenv()["autoClick" .. key] = state -- Dynamically set a global variable for each key's state

        if state then
            -- Start Auto Clicking
            task.spawn(function()
                local vim = game:GetService("VirtualInputManager")
                while getgenv()["autoClick" .. key] do
                    -- Simulate pressing and releasing the key
                    vim:SendKeyEvent(true, key, false, nil)  -- Press key
                    task.wait(0.001)                          -- Adjust the interval between key presses
                    vim:SendKeyEvent(false, key, false, nil) -- Release key
                    task.wait(0.001)                          -- Interval before the next key press
                end
            end)
        else
            -- Stop Auto Clicking when toggle is off
            getgenv()["autoClick" .. key] = false
        end
    end)
end

-- Create a toggle for each key in the list
for _, key in ipairs(keys) do
    createAutoClickToggle(key)
end

tab3:CreateButton("Collect Orbs", function()
    spawn(function()
        pcall(function()
            local localPlayer = game.Players.LocalPlayer  -- Reference the local player
            if localPlayer and localPlayer.Character then
                local torso = localPlayer.Character:FindFirstChild("UpperTorso") or localPlayer.Character:FindFirstChild("HumanoidRootPart")  -- Get the Torso or HumanoidRootPart
                if torso then
                    local targetPosition = torso.Position  -- Store player's torso position
                    local orbs = game:GetService("Workspace").ExperienceOrbs:GetChildren()  -- Get all orbs

                    -- Loop through all orbs and move them to the player's torso position
                    for _, orb in ipairs(orbs) do
                        if orb:IsA("Part") and orb.Parent then
                            -- Move orb directly to the player's torso position
                            orb.CFrame = CFrame.new(targetPosition) * CFrame.new(0, 5, 0)  -- Hover above player
                        end
                    end
                end
            end
        end)
    end)
end)

tab3:CreateToggle("Auto Orbs", function(state)
    spawn(function()
        getgenv().ORBGIVE = state  -- Update the global variable to track the toggle state
        local localPlayer = game.Players.LocalPlayer  -- Reference the local player
        
        while getgenv().ORBGIVE do
            pcall(function()
                if localPlayer and localPlayer.Character then
                    local torso = localPlayer.Character:FindFirstChild("UpperTorso") or localPlayer.Character:FindFirstChild("HumanoidRootPart")  -- Get UpperTorso or HumanoidRootPart
                    if torso then
                        local targetPosition = torso.Position  -- Store player position
                        local orbs = game:GetService("Workspace").ExperienceOrbs:GetChildren()  -- Get all orbs

                        -- Loop through all orbs and move them to the player
                        for _, orb in ipairs(orbs) do
                            if orb:IsA("Part") and orb.Parent then
                                -- Move orb directly to the player's torso position
                                orb.CFrame = CFrame.new(targetPosition) * CFrame.new(0, 5, 0)  -- Hover above player
                            end
                        end
                    end
                end
            end)
            task.wait(0.2)  -- Add a small delay to prevent server strain
        end
    end)
end)


tab7:CreateToggle("PoliceKillaura", function(state)
    local player = game.Players.LocalPlayer
    local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

    if state then
        -- Enable NPC Killaura
        getgenv().NPCPoliceKillaura = true
        spawn(function()
            while getgenv().NPCPoliceKillaura do
                pcall(function()
                    -- Loop through all models in the workspace
                    for _, npc in pairs(game.Workspace:GetChildren()) do
                        -- Check if the npc is of the type "Police" and has a Humanoid
                        if npc:IsA("Model") and npc.Name == "Police" and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                            local npcRoot = npc:FindFirstChild("HumanoidRootPart")
                            if npcRoot and rootPart then
                                -- Calculate the distance between the player and the NPC
                                local distance = (rootPart.Position - npcRoot.Position).Magnitude
                                if distance <= 15 then
                                    -- Attack the NPC Police (Firing a punch)
                                    game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                                end
                            end
                        end
                    end
                end)
                wait(0.01)  -- Add a small delay between checks to avoid spamming requests
            end
        end)
    else
        -- Disable NPC Killaura
        getgenv().NPCPoliceKillaura = false
    end
end)

tab7:CreateToggle("ThugKillaura", function(state)
    local player = game.Players.LocalPlayer
    local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

    if state then
        -- Enable Killaura
        getgenv().ThugKillaura = true
        spawn(function()
            while getgenv().ThugKillaura do
                pcall(function()
                    -- Loop through all models in the workspace
                    for _, thug in pairs(game.Workspace:GetChildren()) do
                        -- Check if the model is a "Thug" and has a valid Humanoid
                        if thug:IsA("Model") and thug.Name == "Thug" and thug:FindFirstChild("Humanoid") and thug.Humanoid.Health > 0 then
                            local thugRoot = thug:FindFirstChild("HumanoidRootPart")
                            if thugRoot and rootPart then
                                -- Calculate the distance between the player and the thug
                                local distance = (rootPart.Position - thugRoot.Position).Magnitude
                                if distance <= 15 then
                                    -- Attack the Thug
                                    game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                                end
                            end
                        end
                    end
                end)
                wait(0.01) -- Check every 0.1 seconds
            end
        end)
    else
        -- Disable Killaura
        getgenv().ThugKillaura = false
    end
end)
-- Ensure shieldBurstActive is defined before use
local shieldBurstActive = false  -- Default state of the shield burst

tab3:CreateToggle("Shield Burst", function(state)
    shieldBurstActive = state  -- Update the Shield Burst state with the toggle input

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
                    task.wait(pauseTime)  -- Pause briefly after reaching max burst for smoother performance
                end

                -- Wait before firing the next burst to control the frequency
                task.wait(shieldWaitTime)  
            end

            -- Ensure shield is turned off when Shield Burst is deactivated
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false)
        end)()
    else
        -- Ensure shield is turned off immediately when Shield Burst toggle is deactivated
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false)
    end
end)

tab3:CreateToggle("Anti Grab", function(state)
    -- Toggle the Anti-Grab functionality
    getgenv().AntiT = state

    -- Local references for efficiency
    local player = game.Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local toggleTelekinesisEvent = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("ToggleTelekinesis")

    -- Function to block telekinesis effects
    local function protectPlayer()
        if getgenv().AntiT and toggleTelekinesisEvent and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                toggleTelekinesisEvent:InvokeServer(Vector3.new(1, 1, 1), false, player.Character)
            end
        end
    end

    -- Manage the connection for RenderStepped
    if state then
        -- Fast, real-time anti-grab logic
        getgenv().protectionConnection = RunService.RenderStepped:Connect(protectPlayer)
    else
        -- Cleanly disconnect protection
        if getgenv().protectionConnection then
            getgenv().protectionConnection:Disconnect()
            getgenv().protectionConnection = nil
        end
        getgenv().AntiT = false
    end
end)

tab6:CreateToggle("Laser Civilian", function(state)
    if state then
        getgenv().LaserC = true
        coroutine.wrap(function()
            local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
            local part = event:InvokeServer(true)
            
            -- Ensure part is valid
            if not part or not part:IsA("BasePart") then
                warn("Failed to get a valid part for Laser Vision!")
                return
            end
            
            -- Set laser color and material (optional)
            part.Color = Color3.fromRGB(255, 255, 255)  -- White laser
            part.Material = Enum.Material.Neon  -- Neon material for visibility

            -- Main loop to track civilians
            while getgenv().LaserC do
                local foundCivilian = false
                
                -- Loop through all models in the workspace to find Civilians
                for _, v in pairs(game.Workspace:GetChildren()) do
                    if v:IsA("Model") and v.Name == "Civilian" and v:FindFirstChild("Humanoid") then
                        local humanoid = v.Humanoid
                        -- If the humanoid is alive, update the laser position
                        if humanoid.Health > 0 then
                            part.Position = v.HumanoidRootPart.Position
                            foundCivilian = true
                            break  -- Stop the loop once we find one civilian to target
                        end
                    end
                end
                
                -- Adjust wait times based on whether a civilian was found
                if not foundCivilian then
                    wait(0.5)  -- Wait longer if no civilian is found
                else
                    wait(0.1)  -- Shorter wait time if a civilian is found and the laser position is updated
                end
            end
            
            -- Disable Laser Vision and cleanup
            event:InvokeServer(false)
        end)()
    else
        getgenv().LaserC = false
        -- Stop laser action and reset any necessary variables
        breakvelocity()  -- Make sure this function is defined in your game logic
    end
end)
tab6:CreateToggle("Laser Police", function(state)
    if state then
        getgenv().LaserV = true
        coroutine.wrap(function()
            local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
            local part = event:InvokeServer(true)
            
            -- Ensure part is valid
            if not part or not part:IsA("BasePart") then
                warn("Failed to get a valid part for Laser Vision!")
                return
            end

            -- Set laser color and material (optional for visibility)
            part.Color = Color3.fromRGB(255, 0, 0)  -- Red laser
            part.Material = Enum.Material.Neon  -- Neon material for better visibility

            -- Main loop to track police officers
            while getgenv().LaserV do
                local foundPolice = false
                
                -- Loop through all models in the workspace to find Police models
                for _, v in pairs(game.Workspace:GetChildren()) do
                    if v:IsA("Model") and v.Name == "Police" and v:FindFirstChild("Humanoid") then
                        local humanoid = v.Humanoid
                        -- If the humanoid is alive, update the laser position
                        if humanoid.Health > 0 then
                            part.Position = v.HumanoidRootPart.Position
                            foundPolice = true
                            break  -- Stop the loop once we find one police officer to target
                        end
                    end
                end
                
                -- Adjust wait times based on whether a police officer was found
                if not foundPolice then
                    wait(0.5)  -- Wait longer if no police officer is found
                else
                    wait(0.1)  -- Shorter wait time if a police officer is found and position is updated
                end
            end
            
            -- Disable Laser Vision when stopping
            event:InvokeServer(false)
        end)()
    else
        getgenv().LaserV = false
        -- Stop laser action and reset any necessary variables
        breakvelocity()  -- Make sure breakvelocity is defined in your game logic
    end
end)
tab6:CreateToggle("Laser Thug", function(state)
    if state then
        getgenv().LaserH = true
        coroutine.wrap(function()
            local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
            local part = event:InvokeServer(true)

            -- Ensure the part is valid and set up laser color and material
            if part and part:IsA("BasePart") then
                part.Color = Color3.fromRGB(255, 255, 255)  -- White laser color
                part.Material = Enum.Material.Neon  -- Neon material for better visibility
            else
                warn("Laser part is invalid or not a BasePart!")
                return
            end

            -- Mute the laser sound if it exists
            local laserSound = part:FindFirstChild("LaserSound")
            if laserSound then
                laserSound.Volume = 0  -- Mute the sound
            end

            -- Create a pink highlight for ESP effect (visual enhancement)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255, 182, 193)  -- Light pink for fill
            highlight.OutlineColor = Color3.fromRGB(255, 105, 180)  -- Darker pink for outline
            highlight.FillTransparency = 0.7
            highlight.OutlineTransparency = 0
            highlight.Parent = game.CoreGui  -- Make sure it's visible through walls

            -- Main loop to track Thug models
            while getgenv().LaserH and part do
                local thugFound = false

                -- Loop through all models in the workspace
                for _, v in pairs(game.Workspace:GetChildren()) do
                    if v:IsA("Model") and v.Name == "Thug" and v:FindFirstChild("Humanoid") then
                        local humanoid = v.Humanoid
                        if humanoid.Health > 0 then
                            -- Set the laser to the Thug's position and update ESP
                            part.Position = v.HumanoidRootPart.Position
                            highlight.Adornee = v  -- Attach ESP to the Thug model
                            thugFound = true
                            break  -- Exit the loop once a Thug is found
                        end
                    end
                end

                -- Adjust the wait time depending on whether a Thug is found
                if thugFound then
                    wait(0.1)  -- Shorter wait time if a Thug is found
                else
                    wait(0.5)  -- Longer wait time if no Thug is found
                end
            end

            -- Disable Laser Vision and clean up once done
            event:InvokeServer(false)
            highlight:Destroy()  -- Clean up the highlight
        end)()
    else
        getgenv().LaserH = false
        -- Additional cleanup logic can be added here if necessary
    end
end)

tab6:CreateToggle("Civilian Sky", function(state)
    local player = game.Players.LocalPlayer  -- Ensure we're working with the correct player

    if state then
        -- Safety check to ensure the character and HumanoidRootPart exist
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local orbPos = player.Character.HumanoidRootPart.Position
            -- Set position in the sky (X and Z stay the same, Y is set to 2500)
            player.Character.HumanoidRootPart.CFrame = CFrame.new(orbPos.X, 2500, orbPos.Z)
            getgenv().LaserC = true
            wait(0.2)  -- Small delay to ensure position is updated
            player.Character.HumanoidRootPart.Anchored = true  -- Anchor the character to keep it in place

            -- Coroutine to handle laser targeting civilians
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)  -- Activate Laser Vision
                
                -- Main loop to track civilian positions and update laser part
                while getgenv().LaserC and part do
                    local foundCivilian = false
                    -- Loop through all models in the workspace to find "Civilian" models
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Model") and v.Name == "Civilian" and v:FindFirstChild("Humanoid") then
                            local humanoid = v.Humanoid
                            -- If the humanoid is alive, set the laser position
                            if humanoid.Health > 0 then
                                part.Position = v.HumanoidRootPart.Position
                                foundCivilian = true
                                break  -- Exit the loop once a civilian is found
                            end
                        end
                    end
                    
                    -- If no civilian found, wait a little before checking again
                    if not foundCivilian then
                        wait(0.5)  -- Adjust wait time as needed for performance
                    else
                        wait(0.1)  -- Shorter wait time if civilian is found and laser position is updated
                    end
                end
                
                -- Deactivate Laser Vision when the loop ends
                event:InvokeServer(false)
            end)()
        else
            warn("HumanoidRootPart not found in character!")
        end
    else
        -- Reset the character's position and disable laser functionality when toggled off
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Anchored = false  -- Unanchor the character
            getgenv().LaserC = false
            player.Character.HumanoidRootPart.CFrame = CFrame.new(orbPos)  -- Restore original position
            breakvelocity()  -- Call to break any velocity or stop other actions
        else
            warn("HumanoidRootPart not found in character when turning off!")
        end
    end
end)
tab6:CreateToggle("Thug fromsky", function(state)
    local player = game.Players.LocalPlayer  -- Ensure we're working with the correct player

    if state then
        -- Safety check to ensure the character and HumanoidRootPart exist
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local thugPos = player.Character.HumanoidRootPart.Position
            -- Set position in the sky (X and Z stay the same, Y is set to 2500)
            player.Character.HumanoidRootPart.CFrame = CFrame.new(thugPos.X, 2500, thugPos.Z)
            getgenv().LaserH = true
            wait(0.2)  -- Small delay to ensure position is updated
            player.Character.HumanoidRootPart.Anchored = true  -- Anchor the character to keep it in place

            -- Coroutine to handle laser targeting thugs
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)  -- Activate Laser Vision
                
                -- Main loop to track thug positions and update laser part
                while getgenv().LaserH and part do
                    local foundThug = false
                    -- Loop through all models in the workspace to find "Thug" models
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Model") and v.Name == "Thug" and v:FindFirstChild("Humanoid") then
                            local humanoid = v.Humanoid
                            -- If the humanoid is alive, set the laser position
                            if humanoid.Health > 0 then
                                part.Position = v.HumanoidRootPart.Position
                                foundThug = true
                                break  -- Exit the loop once a thug is found
                            end
                        end
                    end
                    
                    -- If no thug found, wait a little before checking again
                    if not foundThug then
                        wait(0.5)  -- Adjust wait time as needed for performance
                    else
                        wait(0.1)  -- Shorter wait time if thug is found and laser position is updated
                    end
                end
                
                -- Deactivate Laser Vision when the loop ends
                event:InvokeServer(false)
            end)()
        else
            warn("HumanoidRootPart not found in character!")
        end
    else
        -- Reset the character's position and disable laser functionality when toggled off
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Anchored = false  -- Unanchor the character
            getgenv().LaserH = false
            player.Character.HumanoidRootPart.CFrame = CFrame.new(thugPos)  -- Restore original position
            breakvelocity()  -- Call to break any velocity or stop other actions
        else
            warn("HumanoidRootPart not found in character when turning off!")
        end
    end
end)
tab6:CreateToggle("Police Sky", function(state)
    local player = game.Players.LocalPlayer  -- Ensure we're working with the correct player

    if state then
        -- Safety check to ensure the character and HumanoidRootPart exist
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local orbPos = player.Character.HumanoidRootPart.Position
            -- Set position in the sky (X and Z stay the same, Y is set to 2500)
            player.Character.HumanoidRootPart.CFrame = CFrame.new(orbPos.X, 2500, orbPos.Z)
            getgenv().LaserV = true
            wait(0.2)  -- Small delay to ensure position is updated
            player.Character.HumanoidRootPart.Anchored = true  -- Anchor the character to keep it in place

            -- Coroutine to handle laser targeting police
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)  -- Activate Laser Vision
                
                -- Main loop to track police positions and update laser part
                while getgenv().LaserV and part do
                    local foundPolice = false
                    -- Loop through all models in the workspace to find "Police" models
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Model") and v.Name == "Police" and v:FindFirstChild("Humanoid") then
                            local humanoid = v.Humanoid
                            -- If the humanoid is alive, set the laser position
                            if humanoid.Health > 0 then
                                part.Position = v.HumanoidRootPart.Position
                                foundPolice = true
                                break  -- Exit the loop once a police officer is found
                            end
                        end
                    end
                    
                    -- If no police found, wait a little before checking again
                    if not foundPolice then
                        wait(0.5)  -- Adjust wait time as needed for performance
                    else
                        wait(0.1)  -- Shorter wait time if a police officer is found and laser position is updated
                    end
                end
                
                -- Deactivate Laser Vision when the loop ends
                event:InvokeServer(false)
            end)()
        else
            warn("HumanoidRootPart not found in character!")
        end
    else
        -- Reset the character's position and disable laser functionality when toggled off
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Anchored = false  -- Unanchor the character
            getgenv().LaserV = false
            player.Character.HumanoidRootPart.CFrame = CFrame.new(orbPos)  -- Restore original position
            breakvelocity()  -- Call to break any velocity or stop other actions
        else
            warn("HumanoidRootPart not found in character when turning off!")
        end
    end
end)
tab6:CreateToggle("Civilian Farm", function(state)
    local player = game.Players.LocalPlayer  -- Ensure we are working with the correct player
    
    -- Check if the player's character exists before proceeding
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Store original position
        local civilianPos = player.Character.HumanoidRootPart.CFrame
        getgenv().Civilian = state  -- Set the state globally to control the farming loop

        if state then
            -- Start farming loop
            coroutine.wrap(function()
                while getgenv().Civilian do
                    wait(0.2)  -- Adjust the wait time as needed for performance
                    pcall(function()
                        -- Loop through all models in the workspace to find Civilian models
                        for _, v in pairs(game.Workspace:GetChildren()) do
                            -- Check if the model is a "Civilian" with a valid humanoid
                            if v:IsA("Model") and v.Name == "Civilian" and v:FindFirstChild("Humanoid") then
                                local humanoid = v.Humanoid
                                -- If the humanoid is alive, perform the punch and move towards the civilian
                                if humanoid.Health > 0 then
                                    -- Fire the Punch event to damage the civilian
                                    game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                                    
                                    -- Move player towards the civilian's HumanoidRootPart with a small offset
                                    player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                                end
                            end
                        end
                    end)
                end
            end)()

            -- Store the return position so we can reset it when the toggle is turned off
            getgenv().CivilianReturnPos = civilianPos
        else
            -- Stop farming and return to the original position when toggled off
            getgenv().Civilian = false
            wait(0.2)  -- Slight delay to ensure the farming loop has time to stop
            if getgenv().CivilianReturnPos then
                -- Reset the character's position to the stored original position
                player.Character.HumanoidRootPart.CFrame = getgenv().CivilianReturnPos
            end
        end
    else
        warn("Player's character or HumanoidRootPart not found!")
    end
end)
tab6:CreateToggle("Police Farm", function(state)
    local player = game.Players.LocalPlayer  -- Ensure we are working with the correct player
    
    -- Check if the player's character exists before proceeding
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Store original position
        local policePos = player.Character.HumanoidRootPart.CFrame
        getgenv().Police = state  -- Set the state globally to control the farming loop

        if state then
            -- Start farming loop
            coroutine.wrap(function()
                while getgenv().Police do
                    wait(0.2)  -- Adjust the wait time as needed for performance
                    pcall(function()
                        -- Loop through all models in the workspace to find Police models
                        for _, v in pairs(game.Workspace:GetChildren()) do
                            -- Check if the model is a "Police" with a valid humanoid
                            if v:IsA("Model") and v.Name == "Police" and v:FindFirstChild("Humanoid") then
                                local humanoid = v.Humanoid
                                -- If the humanoid is alive, perform the punch and move towards the police
                                if humanoid.Health > 0 then
                                    -- Fire the Punch event to damage the police
                                    game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                                    
                                    -- Move player towards the police's HumanoidRootPart with a small offset
                                    player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                                end
                            end
                        end
                    end)
                end
            end)()

            -- Store the return position so we can reset it when the toggle is turned off
            getgenv().PoliceReturnPos = policePos
        else
            -- Stop farming and return to the original position when toggled off
            getgenv().Police = false
            wait(0.2)  -- Slight delay to ensure the farming loop has time to stop
            if getgenv().PoliceReturnPos then
                -- Reset the character's position to the stored original position
                player.Character.HumanoidRootPart.CFrame = getgenv().PoliceReturnPos
            end
        end
    else
        warn("Player's character or HumanoidRootPart not found!")
    end
end)

tab4:CreateToggle("Rapid low", function(state)
    if state then
        -- Activate Rapid Punch
        getgenv().rapid = true
        local UserInputService = game:GetService("UserInputService")
        
        -- Function to handle input
        local function onInputEnded(inputObject, gameProcessedEvent)
            if gameProcessedEvent then return end -- Ignore if the input was processed by the game
            
            if getgenv().rapid and inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                -- Fire the punch event multiple times rapidly (you can adjust this number)
                for i = 1, 10 do
                    -- Ensure we are not overwhelming the server with too many requests at once
                    pcall(function() 
                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                    end)
                    wait(0.01)  -- Add a small delay between punches to prevent issues
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
tab4:CreateToggle("Rapid Godly", function(state)
    if state then
        -- Activate Rapid Punch
        getgenv().rapid = true
        local UserInputService = game:GetService("UserInputService")
        
        -- Function to handle input
        local function onInputEnded(inputObject, gameProcessedEvent)
            if gameProcessedEvent then return end -- Ignore if the input was processed by the game
            
            if getgenv().rapid and inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                -- Fire the punch event multiple times rapidly
                for i = 1, 10 do
                    if not getgenv().rapid then break end -- Exit early if the toggle is turned off
                    pcall(function() 
                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.01, 1)
                    end)
                    wait(0.001)  -- Adjusted delay between punches
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
getRoot = function(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end
local UserInputService = game:GetService("UserInputService")
local inputConnection = nil  -- Make the input connection global to persist across toggles

tab4:CreateToggle("Super Rapid", function(state)
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
                        task.wait(0.01) -- Small delay between punches
                    end
                end)
            end
        end

        -- Connect the input listener if it's not already connected
        if not inputConnection then
            inputConnection = UserInputService.InputEnded:Connect(onInputEnded)
        end
    else
        -- Deactivate Super Rapid Punch
        getgenv().superrapid = false
        
        -- Disconnect the input listener when the toggle is off
        if inputConnection then
            inputConnection:Disconnect()
            inputConnection = nil
        end
    end
end)
tab3:CreateToggle("Space Fling", function()
    if state then
        -- Activate Telekinesis Space Fling
        telesauras = true
        
        spawn(function()
            while telesauras do
                task.wait(0.2) -- Prevent overloading the server
                
                pcall(function()
                    -- Invoke the telekinesis events with extreme coordinates
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(999999, 999999, 999999), true)
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(999999, 999999, 999999), false)
                end)
            end
        end)
    else
        -- Deactivate Telekinesis Space Fling
        telesauras = false
    end
end)

-- Telekinesis Push (Pushing nearby players away)
local function toggleTelekinesisPush()
    if not isTelekinesisActive then
        isTelekinesisActive = true
        
        spawn(function()
            while isTelekinesisActive do
                task.wait(0.2) -- Prevent overloading the server
                
                pcall(function()
                    -- Get the player's character
                    local playerChar = player.Character
                    if playerChar and playerChar:FindFirstChild("HumanoidRootPart") then
                        local myPosition = playerChar.HumanoidRootPart.Position
                        
                        -- Find nearby players
                        for _, v in pairs(game.Players:GetChildren()) do
                            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                                local target = v.Character
                                if target ~= playerChar then
                                    local targetHRP = target.HumanoidRootPart
                                    
                                    -- Calculate direction to push the target away from the player
                                    local direction = (targetHRP.Position - myPosition).unit
                                    local force = direction * pushForce -- Adjust this for more/less force
                                    
                                    -- Apply the force to the target's humanoid root part
                                    targetHRP.Velocity = force
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

-- Listen for the E key press to toggle Telekinesis Push
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.E then
        toggleTelekinesisPush() -- Toggle telekinesis push on key press
    end
end)
tab3:CreateToggle("AntiKnockback", function()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local PrimaryPart = character.PrimaryPart or character:WaitForChild("HumanoidRootPart")
    
    if state then
        -- Enable Anti-Knockback
        getgenv().AntiKnockback = true
        local LastPosition = PrimaryPart.CFrame -- Initial position
        
        -- Start the anti-knockback loop using Heartbeat for better frame rate independence
        game:GetService("RunService").Heartbeat:Connect(function()
            if not getgenv().AntiKnockback then return end
            
            if PrimaryPart then
                -- Check for high velocity to cancel knockback
                if (PrimaryPart.AssemblyLinearVelocity.Magnitude > 250 or PrimaryPart.AssemblyAngularVelocity.Magnitude > 250) then
                    PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    PrimaryPart.CFrame = LastPosition -- Reset the position to the last valid one
                elseif (PrimaryPart.AssemblyLinearVelocity.Magnitude < 50 and PrimaryPart.AssemblyAngularVelocity.Magnitude < 50) then
                    -- Update LastPosition when velocity is low, indicating no knockback
                    LastPosition = PrimaryPart.CFrame
                end
            end
        end)
    else
        -- Disable Anti-Knockback
        getgenv().AntiKnockback = false
    end
end)

tab5:CreateDropdown("Select Player", dropdown, function(state)
    -- Directly assign the selected option to `_G.tplayer`
    _G.tplayer = currentOption
end)

-- Utility function to refresh the player list
local function GetList()
    dropdown = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        table.insert(dropdown, player.Name) -- Populate the dropdown list with player names
    end
end

-- Refresh the dropdown menu
tab5:CreateButton("Refresh Dropdown", function()
    GetList()
    -- Assuming your GUI library has a `Refresh` method for dropdowns:
    tab5:Refresh(dropdown) -- Replace `tab5` with the specific dropdown element object if needed
        spawn(function()
        GetList();
        slcplr:Refresh(dropdown);
    end);
end)
tab5:CreateButton("TP to Player",function()
    spawn(function()
        local p1 = game.Players.LocalPlayer.Character.HumanoidRootPart;
        p1.CFrame = game.Players[_G.tplayer].Character.HumanoidRootPart.CFrame;
        breakvelocity();
    end);
end)
tab5:CreateToggle("Spectate Player",function(state)
    -- Update watch state based on toggle
    getgenv().watch = state
    -- Define function to spectate the target player
    local function spectatePlayer()
        while getgenv().watch do
            local targetPlayer = game.Players:FindFirstChild(_G.tplayer)
            if targetPlayer and targetPlayer.Character then
                workspace.CurrentCamera.CameraSubject = targetPlayer.Character
            end
            wait(0.01) -- Slight delay for smoother transitions
        end
    end
end) 
tab5:CreateToggle("Kill Player",function(state)
    local player = game.Players.LocalPlayer
    local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    -- Early exit if player doesn't have a valid root part
    if not rootPart then
        return
    end

    if state then
        -- Save original position for later use
        getgenv().originalPos = rootPart.CFrame  

        -- Activate the kill mode
        getgenv().killplr = true
        getgenv().breakv = true

        -- Loop to reset velocity continuously
        spawn(function()
            while getgenv().breakv do
                pcall(function()
                    breakvelocity()  -- Ensure this function is defined elsewhere
                    game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", true)
                end)
                wait(0.01)  -- Reduced delay for faster updates
            end
        end)

        -- Main loop for targeting and attacking the player
        spawn(function()
            while getgenv().killplr do
                local targetFound = false
                for _, target in pairs(game.Workspace:GetChildren()) do
                    if target.Name == _G.tplayer and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
                        targetFound = true
                        
                        -- Move to target's position
                        pcall(function()
                            player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                        end)
                        
                        -- Perform multiple punches
                        for i = 1, 5 do
                            if not getgenv().killplr then break end
                            pcall(function()
                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(1, 0.02, 2)
                            end)
                            wait(0.01)  -- Reduced delay between punches
                        end

                        -- Use telekinesis quickly
                        local LookVector = game.Workspace.Camera.CFrame.LookVector
                        pcall(function()
                            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, true)
                            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, false)
                        end)

                        break  -- Exit loop after attacking the target
                    end
                end

                -- If no target found, wait briefly before checking again
                if not targetFound then
                    wait(0.1)  -- Faster recheck for targets
                end
            end
        end)

    else
        -- Deactivate kill mode
        getgenv().breakv = false
        getgenv().killplr = false

        -- Return the player to their original position if saved
        if getgenv().originalPos then
            pcall(function()
                player.Character.HumanoidRootPart.CFrame = getgenv().originalPos
            end)
        end

        -- Reset velocity to normal
        pcall(function()
            breakvelocity()  -- Ensure this function is defined elsewhere
        end)
    end
end)
tab5:CreateToggle("Stick To Player",function()
    local player = game.Players.LocalPlayer
    local playerPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position

    if not playerPos then return end -- Early exit if the player's position is not found

    if state then
        -- Enable the toggles for sticking functionality
        getgenv().loopgoto = true
        getgenv().breakv = true

        -- Break velocity continuously while sticking
        spawn(function()
            while getgenv().breakv do
                pcall(function()
                    breakvelocity() -- Ensure this function is defined elsewhere
                end)
                wait(0.1) -- Prevent excessive CPU usage
            end
        end)

        -- Main loop for sticking to the target player
        spawn(function()
            while getgenv().loopgoto do
                local targetPlayer = nil

                -- Find the target player in Workspace
                for _, v in pairs(game.Workspace:GetChildren()) do
                    if v.Name == _G.tplayer and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        targetPlayer = v
                        break
                    end
                end

                if targetPlayer then
                    -- Move to the target player using CFrame
                    pcall(function()
                        player.Character.HumanoidRootPart.CFrame = targetPlayer.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    end)
                end

                wait(0.1) -- Prevent locking the thread and ensure responsiveness
            end
        end)

    else
        -- Disable the toggles for sticking functionality
        getgenv().breakv = false
        getgenv().loopgoto = false

        -- Reset the player's position to their original spot
        if playerPos then
            pcall(function()
                player.Character.HumanoidRootPart.CFrame = CFrame.new(playerPos.X, playerPos.Y, playerPos.Z)
            end)
        end

        -- Ensure velocity is reset when the state changes
        pcall(function()
            breakvelocity() -- Ensure this function is defined elsewhere
        end)
    end
end)
local platformSpawning = false  -- Flag to track if spawning is active
local spawnInterval = 0.2  -- Time in seconds between platform spawns (faster spawning)
local spawnHeight = 5  -- Height at which platforms will spawn above the character

-- Function to spawn a platform at the player's position
local function spawnPlatform(character)
    while platformSpawning do
        wait(spawnInterval)  -- Wait before spawning the next platform
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Create a new part (platform) above the character
            local platform = Instance.new("Part")
            platform.Size = Vector3.new(10, 1, 10)  -- Size of the platform
            platform.Position = humanoidRootPart.Position + Vector3.new(0, spawnHeight, 0)  -- Position above the player
            platform.Anchored = true  -- Make sure the platform stays in place
            platform.CanCollide = true  -- Make the platform collide with other objects
            platform.Material = Enum.Material.SmoothPlastic  -- Platform material
            platform.Parent = workspace  -- Parent the platform to the workspace
            
            -- Optionally, you can add additional properties like color, transparency, etc.
            platform.BrickColor = BrickColor.new("Bright blue")
        end
    end
end

-- Button to toggle platform spawning
tab3:CreateButton("Spawn Platform", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    -- Toggle the spawning status
    platformSpawning = not platformSpawning
    
    -- If spawning is now active, start the loop
    if platformSpawning then
        -- Start spawning platforms
        spawnPlatform(character)
    end
end)
tab8:CreateButton("Anti-Lag", function()
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        -- Disable water-related effects
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 0
    end
    
    -- Set rendering quality to low
    settings().Rendering.QualityLevel = 1
    
    -- Modify properties of parts and meshes
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        elseif v:IsA("Decal") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        end
    end

    -- Remove specific effects as they're added
    workspace.DescendantAdded:Connect(function(child)
        coroutine.wrap(function()
            if child:IsA("ForceField") or child:IsA("Sparkles") or child:IsA("Smoke") or child:IsA("Fire") then
                child:Destroy()
            end
        end)()
    end)
end)

tab8:CreateButton("Crack lag",function()
    for i = 1, 1000 do
        game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
    end
end)
tab8:CreateButton("Mini lag",function()
    for i = 1, 500 do
        game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
    end
end)
tab8:CreateButton("MiniMinilag",function()
    for i = 1, 200 do
        game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
    end
end)
tab8:CreateButton("Mini crash",function()
    local x = 0;
    repeat
        x += 1
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
    until x == 5000 
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
    wait();
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
end)
tab8:CreateButton("Crash Server",function()
    local x = 0;
    repeat
        x += 1
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
    until x == 20000 
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
    wait();
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
end)






tab9:CreateSlider("Set AutoClick", 1, 1000, 1, function(value)
    getgenv().clickInterval = value / 1000 -- Convert milliseconds to seconds
end)
tab9:CreateSlider("Set Outline", getgenv().OutlineColor, function(color)
    getgenv().OutlineColor = color
end)
-- Speed slider: Controls the walking speed
tab9:CreateSlider("Speed", 200, 16, function(s)
    local humanoid = game.Players.LocalPlayer.Character.Humanoid
    humanoid.WalkSpeed = s
end)

-- Jump Power slider: Controls the jump power
tab9:CreateSlider("Jump", 100, 50, function(s)
    local humanoid = game.Players.LocalPlayer.Character.Humanoid
    humanoid.JumpPower = s
end)

-- Infinite Jump Button: Allows the player to jump infinitely
tab9:CreateButton("inf-jump", function()
    local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if humanoid:GetState() == Enum.HumanoidStateType.Seated then
                return  -- Prevent jumping while seated (optional, you can adjust this behavior)
            end
            humanoid:ChangeState("Jumping")
        end)
    end
end)
