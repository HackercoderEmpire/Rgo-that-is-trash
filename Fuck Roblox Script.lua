local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
repeat wait() until player:FindFirstChildOfClass("PlayerGui")
local PlayerGui = player:FindFirstChildOfClass("PlayerGui")

-- Optional: add blur background
local blur = Instance.new("BlurEffect")
blur.Size = 10
blur.Parent = game:GetService("Lighting")

-- Notification helper
local function showNotification(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = "Age Of Heroes" .. title,
        Text = text,
        Duration = duration
    })
end

-- Create Sleek UI
local function createCyberUI()
    local ScreenGui = Instance.new("ScreenGui", PlayerGui)
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0.35, 0, 0.45, 0)
    Frame.Position = UDim2.new(0.325, 0, 0.275, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    Frame.BackgroundTransparency = 0.1
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true

    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0.05, 0)

    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Thickness = 2
    Stroke.Color = Color3.fromRGB(0, 255, 255)

    -- RGB Animation
    task.spawn(function()
        local colors = {Color3.fromRGB(255,0,255), Color3.fromRGB(0,255,255), Color3.fromRGB(255,255,0)}
        local i = 1
        while Frame.Parent do
            TweenService:Create(Stroke, TweenInfo.new(1, Enum.EasingStyle.Linear), {Color = colors[i]}):Play()
            i = (i % #colors) + 1
            task.wait(1)
        end
    end)

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0.2, 0)
    Title.Text = "🌐 Future Hub 2030"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true

    local Subtitle = Instance.new("TextLabel", Frame)
    Subtitle.Position = UDim2.new(0, 0, 0.18, 0)
    Subtitle.Size = UDim2.new(1, 0, 0.15, 0)
    Subtitle.Text = "Welcome, " .. player.Name
    Subtitle.BackgroundTransparency = 1
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextScaled = true
    Subtitle.TextColor3 = Color3.fromRGB(255, 255, 0)

    -- Animate Subtitle Color
    task.spawn(function()
        local colors = {Color3.fromRGB(255,255,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,200,255)}
        local i = 1
        while Subtitle.Parent do
            TweenService:Create(Subtitle, TweenInfo.new(1), {TextColor3 = colors[i]}):Play()
            i = (i % #colors) + 1
            task.wait(1)
        end
    end)

    -- Button Factory
    local function createButton(text, yPos, color, callback)
        local btn = Instance.new("TextButton", Frame)
        btn.Position = UDim2.new(0.1, 0, yPos, 0)
        btn.Size = UDim2.new(0.8, 0, 0.18, 0)
        btn.Text = text
        btn.BackgroundColor3 = color
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextScaled = true
        btn.AutoButtonColor = false

        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0.15, 0)

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Transparency = 0.3

        -- Hover tween
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = btn.BackgroundColor3:Lerp(Color3.new(1,1,1), 0.2)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
        end)

        btn.MouseButton1Click:Connect(function()
            callback()
            TweenService:Create(Frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
            wait(0.5)
            ScreenGui:Destroy()
            blur:Destroy()
        end)
    end

    createButton("▶ Start Script (WIP)", 0.45, Color3.fromRGB(0, 170, 255), function()
        local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/Age%20of%20Fuck%20you.lua"))()
    end)

    createButton("🚧 Executor", 0.68, Color3.fromRGB(100, 100, 100), function()
                local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/Xeno%20UI%20Executor.lua"))()
    end)
end

-- Launch UI
createCyberUI()
