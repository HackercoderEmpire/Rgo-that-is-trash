local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Rainbow effect for text
local function animateRGB(textLabel)
	local colors = {
		Color3.fromRGB(255, 0, 0),
		Color3.fromRGB(255, 127, 0),
		Color3.fromRGB(255, 255, 0),
		Color3.fromRGB(0, 255, 0),
		Color3.fromRGB(0, 255, 255),
		Color3.fromRGB(0, 0, 255),
		Color3.fromRGB(139, 0, 255)
	}
	local i = 1
	coroutine.wrap(function()
		while textLabel.Parent do
			TweenService:Create(textLabel, TweenInfo.new(0.4), {TextColor3 = colors[i]}):Play()
			i = (i % #colors) + 1
			wait(0.4)
		end
	end)()
end

-- Notification Function
local function createCustomNotification(title, message, duration)
	local ScreenGui = Instance.new("ScreenGui", PlayerGui)
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local Frame = Instance.new("Frame", ScreenGui)
	Frame.Size = UDim2.new(0.45, 0, 0.2, 0)
	Frame.Position = UDim2.new(0.275, 0, 0.8, 0)
	Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	Frame.BackgroundTransparency = 0.2
	Frame.BorderSizePixel = 0
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0.1, 0)

	local TitleLabel = Instance.new("TextLabel", Frame)
	TitleLabel.Size = UDim2.new(1, 0, 0.4, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = title
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextScaled = true
	TitleLabel.TextColor3 = Color3.new(1, 1, 1)
	animateRGB(TitleLabel)

	local MessageLabel = Instance.new("TextLabel", Frame)
	MessageLabel.Position = UDim2.new(0, 0, 0.4, 0)
	MessageLabel.Size = UDim2.new(1, 0, 0.6, 0)
	MessageLabel.BackgroundTransparency = 1
	MessageLabel.Text = message
	MessageLabel.Font = Enum.Font.Gotham
	MessageLabel.TextScaled = true
	MessageLabel.TextColor3 = Color3.new(1, 1, 1)
	animateRGB(MessageLabel)

	-- Slide In Animation
	TweenService:Create(Frame, TweenInfo.new(0.4), {
		Position = UDim2.new(0.275, 0, 0.7, 0),
		BackgroundTransparency = 0.1
	}):Play()

	task.wait(duration or 4)

	-- Slide Out
	TweenService:Create(Frame, TweenInfo.new(0.4), {
		Position = UDim2.new(0.275, 0, 0.9, 0),
		BackgroundTransparency = 1
	}):Play()

	task.delay(0.4, function()
		ScreenGui:Destroy()
	end)
end

-- ✅ Example usage
createCustomNotification("🔔 Future Hub", "Updating Will Be Back Soon", 5)
