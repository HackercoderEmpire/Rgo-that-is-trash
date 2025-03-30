local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
repeat wait() until player:FindFirstChildOfClass("PlayerGui")
local PlayerGui = player:FindFirstChildOfClass("PlayerGui")

-- Function to load scripts
local function loadScript(url)
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("⚠ Failed to execute script:", err)
    end
end

-- Function to show notifications
local function showNotification(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = "🔮 " .. title,
        Text = text,
        Duration = duration
    })
end

-- Function to create and animate futuristic UI
local function createCyberUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = PlayerGui
    ScreenGui.IgnoreGuiInset = true

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.4, 0, 0.4, 0)
    Frame.Position = UDim2.new(0.3, 0, 0.35, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui

    -- Neon Glow Effect
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 5
    UIStroke.Parent = Frame

    -- Smooth Rounded Corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.1, 0)
    UICorner.Parent = Frame

    -- Function for animated RGB border
    local function animateBorder()
        local colors = {
            Color3.fromRGB(255, 0, 255),  -- Magenta
            Color3.fromRGB(0, 255, 255),  -- Cyan
            Color3.fromRGB(0, 255, 0),    -- Green
            Color3.fromRGB(255, 0, 0),    -- Red
        }
        local index = 1
        while true do
            local tween = TweenService:Create(UIStroke, TweenInfo.new(1, Enum.EasingStyle.Linear), {Color = colors[index]})
            tween:Play()
            index = (index % #colors) + 1
            wait(1)
        end
    end
    task.spawn(animateBorder)

    -- Title Label
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0.2, 0)
    Title.Text = "Future Hub 2030"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.BackgroundTransparency = 1
    Title.Parent = Frame

    -- Animated Username Label (instead of timer)
    local UsernameLabel = Instance.new("TextLabel")
    UsernameLabel.Size = UDim2.new(1, 0, 0.15, 0)
    UsernameLabel.Position = UDim2.new(0, 0, 0.2, 0)
    UsernameLabel.Text = "Welcome, " .. player.Name  -- Display the player's username
    UsernameLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    UsernameLabel.Font = Enum.Font.GothamBold
    UsernameLabel.TextScaled = true
    UsernameLabel.BackgroundTransparency = 1
    UsernameLabel.Parent = Frame

    -- Function to animate username with RGB effect
    local function animateUsername()
        local colors = {
            Color3.fromRGB(255, 255, 0),   -- Yellow
            Color3.fromRGB(0, 255, 0),     -- Green
            Color3.fromRGB(255, 0, 255),   -- Magenta
            Color3.fromRGB(0, 255, 255),   -- Cyan
        }
        local index = 1
        while true do
            local tween = TweenService:Create(UsernameLabel, TweenInfo.new(1, Enum.EasingStyle.Linear), {TextColor3 = colors[index]})
            tween:Play()
            index = (index % #colors) + 1
            wait(1)
        end
    end
    task.spawn(animateUsername)

    -- Fade-out function
    local function fadeOutUI()
        local fadeOut = TweenService:Create(Frame, TweenInfo.new(0.8), {BackgroundTransparency = 1})
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            Frame.Parent:Destroy()
        end)
    end

    -- Buttons
    local function createButton(text, position, color, action)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.8, 0, 0.2, 0)
        Button.Position = position
        Button.Text = text
        Button.BackgroundColor3 = color
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.GothamBold
        Button.TextScaled = true
        Button.Parent = Frame
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0.2, 0)
        ButtonCorner.Parent = Button
        
        Button.MouseButton1Click:Connect(function()
            action()
            fadeOutUI()  -- Fade out UI when button is pressed
        end)
        return Button
    end

    -- Add the "Start Script" button
    createButton("▶ Start Script", UDim2.new(0.1, 0, 0.5, 0), Color3.fromRGB(0, 150, 255), function()
        loadScript("https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/Age%20of%20Fuck%20you.lua")
    end)

    -- Add the "Coming Soon" button
    createButton("Xeno Executor UI", UDim2.new(0.1, 0, 0.75, 0), Color3.fromRGB(100, 100, 100), function()
        local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/Xeno%20UI%20Executor.lua"))()
    end)

    -- UI Fade In Animation
    Frame.BackgroundTransparency = 1
    TweenService:Create(Frame, TweenInfo.new(1), {BackgroundTransparency = 0}):Play()
end

-- Execute UI
createCyberUI()
