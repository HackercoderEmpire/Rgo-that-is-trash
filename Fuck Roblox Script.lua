local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Main GUI
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "TabbedScriptHub"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Main Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0.3, 0, 0.5, 0)
Frame.Position = UDim2.new(0.35, 0, 0.25, 0)
Frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0.05, 0)

-- Close Button
local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(0.1, 0, 0.08, 0)
CloseBtn.Position = UDim2.new(0.9, -5, 0, 5)
CloseBtn.Text = "✖"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextScaled = true
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Tabs
local Tabs = Instance.new("Frame", Frame)
Tabs.Size = UDim2.new(1, 0, 0.1, 0)
Tabs.Position = UDim2.new(0, 0, 0.08, 0)
Tabs.BackgroundTransparency = 1

local TabButtons = {}
local TabContents = {}

-- Tab Button Factory
local function createTabButton(name, order)
	local btn = Instance.new("TextButton", Tabs)
	btn.Size = UDim2.new(0.5, 0, 1, 0)
	btn.Position = UDim2.new(0.5 * (order - 1), 0, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	TabButtons[name] = btn
	return btn
end

-- Tab Content Frame Factory
local function createTabContent(name)
	local tab = Instance.new("Frame", Frame)
	tab.Name = name
	tab.Position = UDim2.new(0, 0, 0.18, 0)
	tab.Size = UDim2.new(1, 0, 0.8, 0)
	tab.BackgroundTransparency = 1
	tab.Visible = false
	TabContents[name] = tab
	return tab
end

-- Toggle Tabs
local function showTab(name)
	for tabName, content in pairs(TabContents) do
		content.Visible = (tabName == name)
	end
end

-- Make Tabs
local mainTabBtn = createTabButton("Main", 1)
local descTabBtn = createTabButton("Description", 2)

local mainTab = createTabContent("Main")
local descTab = createTabContent("Description")
showTab("Main")

mainTabBtn.MouseButton1Click:Connect(function() showTab("Main") end)
descTabBtn.MouseButton1Click:Connect(function() showTab("Description") end)

-- Button Creator
local function createScriptButton(parent, text, yPos, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Position = UDim2.new(0.1, 0, yPos, 0)
	btn.Size = UDim2.new(0.8, 0, 0.12, 0)
	btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextScaled = true
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0.1, 0)
	btn.MouseButton1Click:Connect(callback)
end

-- Main Tab Buttons
createScriptButton(mainTab, "(Main) Age Of Fuck you", 0.13, function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/LOLOLOLOLOLOL.lua"))()
end)

createScriptButton(mainTab, "Krnl Executor Neon", 0.25, function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/Custom%20Krnl.lua"))()
end)

createScriptButton(mainTab, "Infinite Yield", 0.37, function()
	loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Infinite%20Yield.txt"))()
end)

createScriptButton(mainTab, "(pending fix) Solara Hub v3", 0.49, function()
	loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Solara%20Hub%20v3.txt"))()
end)

createScriptButton(mainTab, "Mini Tools", 0.61, function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/mini%20tools.lua"))()
end)

createScriptButton(mainTab, "(trash) AgeOfHerosUltimate", 0.73, function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/SirUsefull/Zennedy/main/AgeOfHerosUltimate.txt"))()
end)

-- Description Tab Text
local descText = Instance.new("TextLabel", descTab)
descText.Size = UDim2.new(1, -20, 1, -20)
descText.Position = UDim2.new(0, 10, 0, 10)
descText.BackgroundTransparency = 1
descText.TextColor3 = Color3.fromRGB(255, 255, 255)
descText.Font = Enum.Font.Gotham
descText.TextScaled = true
descText.TextWrapped = true
descText.Text = [[
🧾 Script Descriptions:

1. Age Of Fuck You: Take the piss in game

2. Krnl Executor Neon: Custom executor

3. Infinite Yield: Admin command GUI

4. Solara Hub v3: Universal game GUI

5. Mini Tools: Auto Exp Works others Dont

6. AgeOfHerosUltimate: is trash and Weak

           Made By: Scripter              
2025           ScriptHub           V1.1.3
]]
