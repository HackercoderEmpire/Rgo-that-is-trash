local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- GUI container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = PlayerGui
ScreenGui.Name = "Fuck_UI"

-- Main frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 650, 0, 400)
Frame.Position = UDim2.new(0.5, -325, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0.02, 0)

local Shadow = Instance.new("UIStroke")
Shadow.Color = Color3.fromRGB(0, 255, 255)
Shadow.Thickness = 2
Shadow.Transparency = 0.4
Shadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Shadow.Parent = Frame

-- Title bar
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "The Fuck you Executor Level 7"
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.PaddingLeft = UDim.new(0, 10)
Title.Parent = Frame

Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 4)

-- Close button
local Close = Instance.new("TextButton")
Close.Text = "✕"
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 2)
Close.TextColor3 = Color3.fromRGB(255, 100, 100)
Close.BackgroundColor3 = Color3.fromRGB(35, 0, 0)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 16
Close.Parent = Frame
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 4)
Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Script editor
local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.75, -20, 0.65, -10)
TextBox.Position = UDim2.new(0, 10, 0, 45)
TextBox.Text = "-- Type your script here"
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TextBox.Font = Enum.Font.Code
TextBox.TextSize = 16
TextBox.MultiLine = true
TextBox.ClearTextOnFocus = false
TextBox.TextWrapped = true
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.TextYAlignment = Enum.TextYAlignment.Top
TextBox.Parent = Frame
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0.02, 0)

-- Buttons container
local ButtonFrame = Instance.new("Frame")
ButtonFrame.Size = UDim2.new(0.75, -20, 0, 50)
ButtonFrame.Position = UDim2.new(0, 10, 1, -60)
ButtonFrame.BackgroundTransparency = 1
ButtonFrame.Parent = Frame

local Layout = Instance.new("UIListLayout", ButtonFrame)
Layout.FillDirection = Enum.FillDirection.Horizontal
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
Layout.Padding = UDim.new(0, 10)

-- Button factory
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 40)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.AutoButtonColor = false
    btn.Parent = ButtonFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0.15, 0)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    end)

    btn.MouseButton1Click:Connect(callback)
end

-- Button functions
createButton("Execute", function()
    local text = TextBox.Text
    local success, err = pcall(function()
        local func = loadstring(text)
        if func then func() end
    end)
    if not success then warn("Execution error: " .. err) end
end)

createButton("Clear", function()
    TextBox.Text = ""
end)

createButton("Inject", function()
    print("Inject clicked (placeholder)")
end)

createButton("Open", function()
    print("Open File clicked (placeholder)")
end)

createButton("Save", function()
    print("Save File clicked (placeholder)")
end)

-- Script Hub Sidebar
local ScriptHub = Instance.new("Frame")
ScriptHub.Size = UDim2.new(0.25, -10, 1, -10)
ScriptHub.Position = UDim2.new(0.75, 0, 0, 5)
ScriptHub.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ScriptHub.Parent = Frame
Instance.new("UICorner", ScriptHub).CornerRadius = UDim.new(0.03, 0)

local Scroll = Instance.new("ScrollingFrame", ScriptHub)
Scroll.Size = UDim2.new(1, 0, 1, 0)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 6
Scroll.BackgroundTransparency = 1

local ScrollLayout = Instance.new("UIListLayout", Scroll)
ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScrollLayout.Padding = UDim.new(0, 5)

local Padding = Instance.new("UIPadding", Scroll)
Padding.PaddingTop = UDim.new(0, 5)
Padding.PaddingLeft = UDim.new(0, 5)
Padding.PaddingRight = UDim.new(0, 5)

-- Add ScriptHub Buttons
local function addScript(scriptName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Text = scriptName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.Parent = Scroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0.1, 0)

    btn.MouseButton1Click:Connect(function()
        TextBox.Text = "-- Loaded script: " .. scriptName
    end)
end

-- Example scripts
addScript("Fly Script")
addScript("Speed Hack")
addScript("ESP")
addScript("TP to Player")

-- Dynamic canvas size update
ScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, ScrollLayout.AbsoluteContentSize.Y + 10)
end)
