local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
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

-- Function to hide UI with animation
local function hideUI(Frame)
    local fadeOut = TweenService:Create(Frame, TweenInfo.new(0.8), {BackgroundTransparency = 1})
    fadeOut:Play()
    fadeOut.Completed:Connect(function()
        Frame.Parent:Destroy()  -- Remove UI after fade-out
    end)
end

-- Function to create the UI
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
    Frame.Parent = ScreenGui

    -- Cyber Glow Effect
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 3
    UIStroke.Color = Color3.fromRGB(0, 183, 255)
    UIStroke.Parent = Frame

    -- Title Label
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0.2, 0)
    Title.Text = "Age Of Heroes"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextScaled = true
    Title.BackgroundTransparency = 1
    Title.Parent = Frame

    -- Subtitle
    local SubText = Instance.new("TextLabel")
    SubText.Size = UDim2.new(1, 0, 0.15, 0)
    SubText.Position = UDim2.new(0, 0, 0.2, 0)
    SubText.Text = "Updates Coming Soon!"
    SubText.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubText.Font = Enum.Font.SourceSans
    SubText.TextScaled = true
    SubText.BackgroundTransparency = 1
    SubText.Parent = Frame

    -- Main Script Button
    local MainButton = Instance.new("TextButton")
    MainButton.Size = UDim2.new(0.8, 0, 0.2, 0)
    MainButton.Position = UDim2.new(0.1, 0, 0.4, 0)
    MainButton.Text = "▶ Main Script"
    MainButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainButton.Font = Enum.Font.SourceSansBold
    MainButton.TextScaled = true
    MainButton.Parent = Frame

    -- Coming Soon Button
    local SoonButton = Instance.new("TextButton")
    SoonButton.Size = UDim2.new(0.8, 0, 0.2, 0)
    SoonButton.Position = UDim2.new(0.1, 0, 0.65, 0)
    SoonButton.Text = "⏳ Coming Soon"
    SoonButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    SoonButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SoonButton.Font = Enum.Font.SourceSansBold
    SoonButton.TextScaled = true
    SoonButton.Parent = Frame

    -- Button Click Effects (With Fade-Out)
    MainButton.MouseButton1Click:Connect(function()
        print("Loading Main Script")
        loadScript("https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/Age%20of%20Fuck%20you.lua")
        hideUI(Frame)  -- Hide UI after clicking
    end)

    SoonButton.MouseButton1Click:Connect(function()
        print("Feature Coming Soon!")
        hideUI(Frame)  -- Hide UI after clicking
    end)

    -- Fade In Effect
    Frame.BackgroundTransparency = 1
    local fadeIn = TweenService:Create(Frame, TweenInfo.new(1), {BackgroundTransparency = 0})
    fadeIn:Play()
end

-- Execute UI
createCustomUI()
