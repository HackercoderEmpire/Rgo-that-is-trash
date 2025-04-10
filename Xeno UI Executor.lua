local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
repeat wait() until player:FindFirstChildOfClass("PlayerGui")
local PlayerGui = player:FindFirstChildOfClass("PlayerGui")

-- Function to show notifications
local function showNotification(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = "🔮 " .. title,
        Text = text,
        Duration = duration
    })
end

-- Create the Executor UI
local function createExecutorUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = PlayerGui
    ScreenGui.IgnoreGuiInset = true

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.4, 0, 0.5, 0)
    Frame.Position = UDim2.new(0.3, 0, 0.25, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui

    -- Neon Glow Effect
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 3
    UIStroke.Parent = Frame

    -- Smooth Rounded Corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.1, 0)
    UICorner.Parent = Frame

    -- Title Label
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Text = "Xeno Script Executor"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.BackgroundTransparency = 1
    Title.Parent = Frame

    -- Tab System
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, 0, 0, 40)
    TabContainer.Position = UDim2.new(0, 0, 0.1, 0)
    TabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabContainer.Parent = Frame

    local Tabs = {"Script 1", "Script 2", "Script 3"}
    local TabButtons = {}
    local ActiveTab = nil

    -- Function to create tabs
    local function createTabButton(tabName, index)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0.3, 0, 1, 0)
        TabButton.Position = UDim2.new(0.33 * (index - 1), 0, 0, 0)
        TabButton.Text = tabName
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextScaled = true
        TabButton.Parent = TabContainer

        -- On button click, switch tabs
        TabButton.MouseButton1Click:Connect(function()
            -- Set active tab
            if ActiveTab then
                ActiveTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end
            ActiveTab = TabButton
            TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

            -- Change script display area
            ScriptDisplay.Text = "Editing: " .. tabName
            ScriptInput.Text = "Script content for " .. tabName
        end)

        table.insert(TabButtons, TabButton)
    end

    -- Create tab buttons dynamically
    for i, tabName in ipairs(Tabs) do
        createTabButton(tabName, i)
    end

    -- Script Input Box
    local ScriptInput = Instance.new("TextBox")
    ScriptInput.Size = UDim2.new(0.8, 0, 0.25, 0)
    ScriptInput.Position = UDim2.new(0.1, 0, 0.45, 0)
    ScriptInput.Text = ""
    ScriptInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    ScriptInput.Font = Enum.Font.Gotham
    ScriptInput.TextScaled = true
    ScriptInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ScriptInput.BorderSizePixel = 0
    ScriptInput.ClearTextOnFocus = true
    ScriptInput.Parent = Frame

    -- Status Label
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0.1, 0)
    StatusLabel.Position = UDim2.new(0, 0, 0.75, 0)
    StatusLabel.Text = "Status: Ready"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextScaled = true
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Parent = Frame

    -- Buttons
    local function createButton(text, position, color, action)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.3, 0, 0.2, 0)
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

        Button.MouseButton1Click:Connect(action)
        return Button
    end

    -- Button to execute script
    createButton("▶ Execute", UDim2.new(0.05, 0, 0.85, 0), Color3.fromRGB(0, 150, 255), function()
        local scriptText = ScriptInput.Text
        if scriptText == "" then
            showNotification("⚠ Error", "Please enter a script to execute!", 3)
            return
        end

        -- Update status to executing
        StatusLabel.Text = "Status: Executing..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)

        -- Load and execute the script
        local success, err = pcall(function()
            loadstring(scriptText)()
        end)

        if success then
            StatusLabel.Text = "Status: Executed Successfully"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            showNotification("Success", "Script executed successfully.", 3)
        else
            StatusLabel.Text = "Status: Error"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            showNotification("Error", "Failed to execute script: " .. err, 5)
        end
    end)

    -- Button to clear script input
    createButton("⛔ Clear", UDim2.new(0.37, 0, 0.85, 0), Color3.fromRGB(255, 0, 0), function()
        ScriptInput.Text = ""
        StatusLabel.Text = "Status: Ready"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end)

    -- Button to close the UI
    createButton("❌ Close", UDim2.new(0.69, 0, 0.85, 0), Color3.fromRGB(255, 0, 0), function()
        ScreenGui:Destroy()
    end)

    -- UI Fade In Animation
    Frame.BackgroundTransparency = 1
    TweenService:Create(Frame, TweenInfo.new(1), {BackgroundTransparency = 0}):Play()
end

-- Execute UI
createExecutorUI()
