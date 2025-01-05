local library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ShaddowScripts/Main/main/Library"))()
local Main = library:CreateWindow("AutoClickers", "Deep Sea")

-- Create separate tabs for different key groups
local tabLetters = Main:CreateTab("Letters")
local tabNumbers = Main:CreateTab("Numbers")
local tabFunctions = Main:CreateTab("Functions")
local tabSpecials = Main:CreateTab("Special Keys")
local tabSettings = Main:CreateTab("Settings")

-- Group keys
local letterKeys = {
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
}
local numberKeys = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
local functionKeys = {"F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12"}
local specialKeys = {
    "Tab", "CapsLock", "Shift", "Ctrl", "Alt", "Escape", "Enter", "Space",
    "Backspace", "Delete", "Insert", "Home", "End", "PageUp", "PageDown",
    "Left", "Right", "Up", "Down",
    "-", "=", "[", "]", "\\", ";", "'", ",", ".", "/", "`"
}

-- Default settings
getgenv().ClickSpeed = 0.1 -- Default click speed in seconds
getgenv().WalkSpeed = 16 -- Default walk speed (normal Roblox speed)
getgenv().JumpPower = 50 -- Default jump height

-- Function to create an auto-clicker toggle for a specific key
local function createAutoClickToggle(tab, key)
    tab:CreateToggle("Auto '" .. key .. "'", function(state)
        getgenv()["auto" .. key] = state -- Dynamically set a global variable for each key's state

        if state then
            -- Start Auto Clicking
            task.spawn(function()
                local vim = game:GetService("VirtualInputManager")
                while getgenv()["auto" .. key] do
                    -- Simulate pressing and releasing the key
                    vim:SendKeyEvent(true, key, false, nil)  -- Press key
                    task.wait(getgenv().ClickSpeed)          -- User-defined click speed
                    vim:SendKeyEvent(false, key, false, nil) -- Release key
                    task.wait(getgenv().ClickSpeed)          -- Interval before the next key press
                end
            end)
        else
            -- Stop Auto Clicking when toggle is off
            getgenv()["autoClick" .. key] = false
        end
    end)
end

-- Create toggles for each group of keys
for _, key in ipairs(letterKeys) do
    createAutoClickToggle(tabLetters, key)
end
for _, key in ipairs(numberKeys) do
    createAutoClickToggle(tabNumbers, key)
end
for _, key in ipairs(functionKeys) do
    createAutoClickToggle(tabFunctions, key)
end
for _, key in ipairs(specialKeys) do
    createAutoClickToggle(tabSpecials, key)
end

-- Function to apply walk speed and jump power to the player's character
local function applyPlayerSettings()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = getgenv().WalkSpeed
        player.Character.Humanoid.JumpPower = getgenv().JumpPower
    end
end

-- Monitor for character changes (respawning, resetting)
local function monitorPlayerCharacter()
    local player = game.Players.LocalPlayer
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid") -- Ensure the Humanoid is present
        applyPlayerSettings() -- Reapply the settings when the character is added
    end)
end

-- Settings Tab for Click Speed, Walk Speed, and Jump Height
tabSettings:CreateSlider("Click Speed", 1, 500, getgenv().ClickSpeed * 1000, function(value)
    getgenv().ClickSpeed = value / 1000 -- Convert ms to seconds
end)

tabSettings:CreateSlider("Player Speed", 16, 100, getgenv().WalkSpeed, function(value)
    getgenv().WalkSpeed = value
    applyPlayerSettings() -- Apply settings dynamically
end)

tabSettings:CreateSlider("Jump Height", 50, 300, getgenv().JumpPower, function(value)
    getgenv().JumpPower = value
    applyPlayerSettings() -- Apply settings dynamically
end)

tabSettings:CreateLabel("Adjust your gameplay settings below:")
tabSettings:CreateLabel("Lower click speed = faster clicking.")
tabSettings:CreateLabel("Increase walk speed and jump height for faster movement.")

-- Initialize the script
applyPlayerSettings() -- Apply the settings initially
monitorPlayerCharacter() -- Start monitoring for character changes
