local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleBar = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local TextBox = Instance.new("TextBox")
local ExecuteButton = Instance.new("TextButton")
local ESPButton = Instance.new("TextButton")
local ChatButton = Instance.new("TextButton")
local ChatFrame = Instance.new("Frame")
local ChatLog = Instance.new("TextLabel")

-- Properties
ScreenGui.Name = "ExecutorUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.5  -- Semi-transparent background
MainFrame.Size = UDim2.new(0, 500, 0, 250)  -- Made wider
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -125)
MainFrame.Draggable = true
MainFrame.Active = true

TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.Font = Enum.Font.SourceSansBold
TitleBar.Text = "Lua Executor (Custom Made)"
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.TextSize = 16

CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Position = UDim2.new(1, -25, 0, 0)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

TextBox.Name = "TextBox"
TextBox.Parent = MainFrame
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.Size = UDim2.new(1, -20, 0.6, -35)
TextBox.Position = UDim2.new(0, 10, 0, 35)
TextBox.Font = Enum.Font.Code
TextBox.Text = "-- Write your script here"
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 14
TextBox.ClearTextOnFocus = false
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.TextYAlignment = Enum.TextYAlignment.Top
TextBox.MultiLine = true
TextBox.ClipsDescendants = true

-- Adjusting Button Sizes and Positions
ExecuteButton.Name = "ExecuteButton"
ExecuteButton.Parent = MainFrame
ExecuteButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
ExecuteButton.Size = UDim2.new(0.3, -10, 0, 25)  -- Smaller width to fit more buttons side by side
ExecuteButton.Position = UDim2.new(0, 10, 1, -40)
ExecuteButton.Font = Enum.Font.SourceSansBold
ExecuteButton.Text = "Execute"
ExecuteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteButton.TextSize = 16
ExecuteButton.MouseButton1Click:Connect(function()
    local scriptToRun = TextBox.Text
    if scriptToRun then
        loadstring(scriptToRun)()
    end
end)

ESPButton.Name = "ESPButton"
ESPButton.Parent = MainFrame
ESPButton.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
ESPButton.Size = UDim2.new(0.3, -10, 0, 25)  -- Smaller width
ESPButton.Position = UDim2.new(0.3, 5, 1, -40)  -- Adjusted to be next to ExecuteButton
ESPButton.Font = Enum.Font.SourceSansBold
ESPButton.Text = "Toggle ESP"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.TextSize = 16
ESPButton.MouseButton1Click:Connect(function()
    local espEnabled = false
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and not v.Character:FindFirstChild("ESPBox") then
            local esp = Instance.new("BoxHandleAdornment")
            esp.Name = "ESPBox"
            esp.Adornee = v.Character
            esp.Size = Vector3.new(4, 5, 2)
            esp.Color3 = Color3.new(128, 0, 128)
            esp.AlwaysOnTop = true
            esp.Parent = v.Character
            espEnabled = true
        else
            if v.Character:FindFirstChild("ESPBox") then
                v.Character:FindFirstChild("ESPBox"):Destroy()
                espEnabled = false
            end
        end
    end
    ESPButton.Text = espEnabled and "Disable ESP" or "Enable ESP"
end)

ChatButton.Name = "ChatButton"
ChatButton.Parent = MainFrame
ChatButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ChatButton.Size = UDim2.new(0.3, -10, 0, 25)  -- Smaller width
ChatButton.Position = UDim2.new(0.6, 5, 1, -40)  -- Placed next to ESPButton
ChatButton.Font = Enum.Font.SourceSansBold
ChatButton.Text = "Show Chat"
ChatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ChatButton.TextSize = 16
ChatButton.MouseButton1Click:Connect(function()
    -- Create and display the Chat Log UI
    if not ChatFrame.Parent then
        ChatFrame.Parent = ScreenGui
        ChatFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        ChatFrame.BackgroundTransparency = 0.7
        ChatFrame.Size = UDim2.new(0, 500, 0, 200)  -- Widened ChatFrame
        ChatFrame.Position = UDim2.new(0.5, -250, 0.5, 75)
        
        ChatLog.Parent = ChatFrame
        ChatLog.BackgroundTransparency = 1
        ChatLog.Size = UDim2.new(1, 0, 1, 0)
        ChatLog.Font = Enum.Font.Code
        ChatLog.TextColor3 = Color3.fromRGB(255, 255, 255)
        ChatLog.TextSize = 14
        ChatLog.Text = "Chat Logs\n"

        -- Update chat log with real-time messages
        game:GetService("Players").PlayerAdded:Connect(function(player)
            player.Chatted:Connect(function(message)
                ChatLog.Text = ChatLog.Text .. player.Name .. ": " .. message .. "\n"
            end)
        end)
    end
end)

