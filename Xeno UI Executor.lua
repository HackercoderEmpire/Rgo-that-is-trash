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
    Frame.Size = UDim2.new(0.3, 0, 0.35, 0)  -- Smaller size
    Frame.Position = UDim2.new(0.35, 0, 0.3, 0)  -- Adjust position for smaller size
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
    Title.Size = UDim2.new(1, 0, 0.2, 0)
    Title.Text = "Xeno Script Executor"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.BackgroundTransparency = 1
    Title.Parent = Frame

    -- Script Input Box
    local ScriptInput = Instance.new("TextBox")
    ScriptInput.Size = UDim2.new(0.8, 0, 0.25, 0)  -- Smaller input box
    ScriptInput.Position = UDim2.new(0.1, 0, 0.25, 0)
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
    StatusLabel.Position = UDim2.new(0, 0, 0.65, 0)
    StatusLabel.Text = "Status: Ready"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextScaled = true
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Parent = Frame

    -- Buttons (Position them next to each other, slightly moved to the left)
    local function createButton(text, position, color, action)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.3, 0, 0.2, 0)  -- Smaller size
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
