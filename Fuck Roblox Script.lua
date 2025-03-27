local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local PlayerGui = player:FindFirstChildOfClass("PlayerGui")

-- Function to load scripts
local function loadScript(url)
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Failed to execute script:", err)
    end
end

-- Function to show a notification
local function showNotification(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration
    })
end

-- Function to hide UI with animation
local function hideUI(Frame)
    local fadeOut = TweenService:Create(Frame, TweenInfo.new(0.8), {BackgroundTransparency = 1})
    fadeOut:Play()
    fadeOut.Completed:Connect(function()
        Frame.Parent:Destroy()  -- Remove UI after fade-out
    end)
end

-- Function to create draggable UI with dynamic RGB border
local function createCustomUI()
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = PlayerGui
    ScreenGui.IgnoreGuiInset = true

    -- Main Frame
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.4, 0, 0.3, 0)
    Frame.Position = UDim2.new(0.3, 0, 0.35, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
    Frame.BorderSizePixel = 0
    Frame.Active = true  -- Enables dragging
    Frame.Draggable = true  -- Makes UI draggable
    Frame.Parent = ScreenGui

    -- Rounded Corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.1, 0)  -- Smooth round effect
    UICorner.Parent = Frame

    -- RGB Border Outline Effect
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 5
    UIStroke.Transparency = 0.4
    UIStroke.Parent = Frame

    -- Function to animate RGB border color change
    local function rgbBorderAnimation()
        local colors = {
            Color3.fromRGB(255, 0, 0),  -- Red
            Color3.fromRGB(0, 255, 0),  -- Green
            Color3.fromRGB(0, 0, 255),  -- Blue
            Color3.fromRGB(255, 255, 0), -- Yellow
            Color3.fromRGB(255, 165, 0), -- Orange
            Color3.fromRGB(238, 130, 238), -- Violet
            Color3.fromRGB(0, 255, 255), -- Cyan
        }

        -- Create a tween to cycle through the colors
        local index = 1
        while true do
            local tween = TweenService:Create(UIStroke, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {Color = colors[index]})
            tween:Play()
            index = (index % #colors) + 1  -- Cycle through the colors
            wait(2)
        end
    end

    -- Start the RGB animation
    spawn(rgbBorderAnimation)

    -- Title Label
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0.2, 0)
    Title.Text = "Age Of Heroes"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextScaled = true
    Title.BackgroundTransparency = 1
    Title.Parent = Frame

    -- Username Label (display the player's username)
    local UsernameLabel = Instance.new("TextLabel")
    UsernameLabel.Size = UDim2.new(1, 0, 0.15, 0)
    UsernameLabel.Position = UDim2.new(0, 0, 0.2, 0)
    UsernameLabel.Text = "User: " .. player.Name  -- Display player username
    UsernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    UsernameLabel.Font = Enum.Font.SourceSans
    UsernameLabel.TextScaled = true
    UsernameLabel.BackgroundTransparency = 1
    UsernameLabel.Parent = Frame

    -- Function to animate the RGB text effect on the username
    local function rgbTextAnimation()
        local colors = {
            Color3.fromRGB(255, 0, 0),  -- Red
            Color3.fromRGB(0, 255, 0),  -- Green
            Color3.fromRGB(0, 0, 255),  -- Blue
            Color3.fromRGB(255, 255, 0), -- Yellow
            Color3.fromRGB(255, 165, 0), -- Orange
            Color3.fromRGB(238, 130, 238), -- Violet
            Color3.fromRGB(0, 255, 255), -- Cyan
        }

        local index = 1
        while true do
            UsernameLabel.TextColor3 = colors[index]
            index = (index % #colors) + 1  -- Cycle through the colors
            wait(0.5)  -- Change every 0.5 seconds
        end
    end

    -- Start the RGB text animation
    spawn(rgbTextAnimation)

    -- Subtitle
    local SubText = Instance.new("TextLabel")
    SubText.Size = UDim2.new(1, 0, 0.15, 0)
    SubText.Position = UDim2.new(0, 0, 0.35, 0)
    SubText.Text = "Updates Coming Soon!"
    SubText.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubText.Font = Enum.Font.SourceSans
    SubText.TextScaled = true
    SubText.BackgroundTransparency = 1
    SubText.Parent = Frame

    -- Main Script Button
    local MainButton = Instance.new("TextButton")
    MainButton.Size = UDim2.new(0.8, 0, 0.2, 0)
    MainButton.Position = UDim2.new(0.1, 0, 0.5, 0)
    MainButton.Text = "▶ Main Script"
    MainButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainButton.Font = Enum.Font.SourceSansBold
    MainButton.TextScaled = true
    MainButton.Parent = Frame

    -- Rounded corners for button
    local ButtonCorner1 = Instance.new("UICorner")
    ButtonCorner1.CornerRadius = UDim.new(0.2, 0)  -- Smooth button edges
    ButtonCorner1.Parent = MainButton

    -- Coming Soon Button
    local SoonButton = Instance.new("TextButton")
    SoonButton.Size = UDim2.new(0.8, 0, 0.2, 0)
    SoonButton.Position = UDim2.new(0.1, 0, 0.75, 0)
    SoonButton.Text = "⏳ Coming Soon"
    SoonButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    SoonButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SoonButton.Font = Enum.Font.SourceSansBold
    SoonButton.TextScaled = true
    SoonButton.Parent = Frame

    -- Rounded corners for button
    local ButtonCorner2 = Instance.new("UICorner")
    ButtonCorner2.CornerRadius = UDim.new(0.2, 0)  -- Smooth button edges
    ButtonCorner2.Parent = SoonButton

    -- Button Click Effects (With Fade-Out)
    MainButton.MouseButton1Click:Connect(function()
        print("Loading Main Script")
        loadScript("https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/Age%20of%20Fuck%20you.lua")
        hideUI(Frame)  -- Hide UI after clicking
    end)

    SoonButton.MouseButton1Click:Connect(function()
        print("Feature Coming Soon!")
        showNotification("⚠ Update Info", "This script is coming in the next update!", 5)  -- Show notification
        hideUI(Frame)  -- Hide UI after clicking
    end)

    -- Fade In Effect
    Frame.BackgroundTransparency = 1
    local fadeIn = TweenService:Create(Frame, TweenInfo.new(1), {BackgroundTransparency = 0})
    fadeIn:Play()
end

-- Execute UI
createCustomUI()
