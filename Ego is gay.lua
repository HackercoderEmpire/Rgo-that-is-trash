-- Create ScreenGui and components
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local ToggleTracerButton = Instance.new("TextButton")
local ChatBox = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local ShowPlayersButton = Instance.new("TextButton")
local PlayerListFrame = Instance.new("Frame")
local PlayerList = Instance.new("ScrollingFrame")
local PlayerListLayout = Instance.new("UIListLayout")

-- Parent the ScreenGui to the Player's GUI
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Configure MainFrame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Active = true -- Enable dragging

-- Make MainFrame draggable
local isDragging = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and isDragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Configure CloseButton
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.Text = "Close"
CloseButton.Size = UDim2.new(0, 80, 0, 30)
CloseButton.Position = UDim2.new(1, -90, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true

-- Functionality to close the MainFrame
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Configure ToggleTracerButton
ToggleTracerButton.Name = "ToggleTracerButton"
ToggleTracerButton.Parent = MainFrame
ToggleTracerButton.Text = "Toggle Tracer"
ToggleTracerButton.Size = UDim2.new(0, 100, 0, 30)
ToggleTracerButton.Position = UDim2.new(0, 10, 0, 10)
ToggleTracerButton.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
ToggleTracerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTracerButton.TextScaled = true

-- Configure ChatBox
ChatBox.Name = "ChatBox"
ChatBox.Parent = MainFrame
ChatBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ChatBox.Size = UDim2.new(0, 280, 0, 300)
ChatBox.Position = UDim2.new(0, 10, 0, 50)
ChatBox.ScrollBarThickness = 5

-- Configure UIListLayout inside ChatBox
UIListLayout.Parent = ChatBox
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Function to add a message to ChatBox
local function addMessage(text)
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Parent = ChatBox
    messageLabel.Size = UDim2.new(1, -10, 0, 20)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = text
    messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    messageLabel.TextScaled = true
    messageLabel.TextWrapped = true
end

-- Capture chat messages in real-time
game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents")
    .OnMessageDoneFiltering.OnClientEvent:Connect(function(chatData)
        local playerName = chatData.FromSpeaker
        local message = chatData.Message
        addMessage(playerName .. ": " .. message)
        
        -- Ensure the ChatBox scrolls to the bottom as new messages come in
        ChatBox.CanvasPosition = Vector2.new(0, ChatBox.UIListLayout.AbsoluteContentSize.Y)
    end)

-- Configure ShowPlayersButton
ShowPlayersButton.Name = "ShowPlayersButton"
ShowPlayersButton.Parent = MainFrame
ShowPlayersButton.Text = "Show Players"
ShowPlayersButton.Size = UDim2.new(0, 100, 0, 30)
ShowPlayersButton.Position = UDim2.new(0, 10, 0, 360)
ShowPlayersButton.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
ShowPlayersButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowPlayersButton.TextScaled = true

-- Configure PlayerListFrame (pop-up)
PlayerListFrame.Name = "PlayerListFrame"
PlayerListFrame.Parent = ScreenGui
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PlayerListFrame.Size = UDim2.new(0, 200, 0, 300)
PlayerListFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
PlayerListFrame.Visible = false

-- Configure PlayerList inside PlayerListFrame
PlayerList.Name = "PlayerList"
PlayerList.Parent = PlayerListFrame
PlayerList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PlayerList.Size = UDim2.new(1, -10, 1, -10)
PlayerList.Position = UDim2.new(0, 5, 0, 5)
PlayerList.ScrollBarThickness = 5

-- Configure UIListLayout inside PlayerList
PlayerListLayout.Parent = PlayerList
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Function to update PlayerList with current players
local function updatePlayerList()
    PlayerList:ClearAllChildren()
    for _, player in pairs(game.Players:GetPlayers()) do
        local playerLabel = Instance.new("TextLabel")
        playerLabel.Parent = PlayerList
        playerLabel.Size = UDim2.new(1, -10, 0, 20)
        playerLabel.BackgroundTransparency = 1
        playerLabel.Text = player.Name
        playerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        playerLabel.TextScaled = true
        playerLabel.TextWrapped = true
    end
end

-- Show or hide the PlayerListFrame on button click
ShowPlayersButton.MouseButton1Click:Connect(function()
    PlayerListFrame.Visible = not PlayerListFrame.Visible
    if PlayerListFrame.Visible then
        updatePlayerList()
    end
end)

-- Update PlayerList in real time when players join or leave
game.Players.PlayerAdded:Connect(updatePlayerList)
game.Players.PlayerRemoving:Connect(updatePlayerList)

-- Initial population of the player list
updatePlayerList()
