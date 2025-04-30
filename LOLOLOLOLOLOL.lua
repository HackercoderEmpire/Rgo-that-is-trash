local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/Fuck-KavoUI.lua"))()

local CyberBlueTheme = {
    SchemeColor = Color3.fromRGB(140, 0, 255),  
    Background = Color3.fromRGB(10, 0, 20),        
    Header = Color3.fromRGB(35, 0, 65),          
    TextColor = Color3.fromRGB(255, 255, 255),     
    ElementColor = Color3.fromRGB(45, 0, 85),    

    ButtonColor = Color3.fromRGB(160, 0, 255),     
    ButtonHover = Color3.fromRGB(200, 100, 255),   
    BorderColor = Color3.fromRGB(190, 60, 255),    
    GlowEffect = Color3.fromRGB(220, 120, 255),    
    HighlightColor = Color3.fromRGB(255, 0, 200),  
    ShadowEffect = Color3.fromRGB(25, 0, 60),      
}


local Window = Library.CreateLib("[HAHAHAHA Script] 2025 (Scripter)", CyberBlueTheme)

local ATab = Window:NewTab("Main");
local ASection = ATab:NewSection("Useful Tools");
local STab = Window:NewTab("Self");
local SSection = STab:NewSection("Useful Self Tools");  
local TargetTab = Window:NewTab("Target");
local TargetSection = TargetTab:NewSection("Teleport To Player");
local AutoTab = Window:NewTab("Teleport");
local AutoSection = AutoTab:NewSection("Teleport/Auto Teleport");
local StatsTab = Window:NewTab("Stats")
local StatSection = StatsTab:NewSection("Stat Upgrader")
local MainTab = Window:NewTab("Auto Farm");
local MainSection = MainTab:NewSection("Auto Farm NPC/Player");
local GUITab = Window:NewTab("GUI's");
local GUISection = GUITab:NewSection("GUI's that can be fun/help");
local TTab = Window:NewTab("Teleport Menu");
local TSection = TTab:NewSection("Teleport Menu");
local KTab = Window:NewTab("KeyBinds");
local KSection = KTab:NewSection("GUI/Game KeyBinds");
local GTab = Window:NewTab("Misc");
local GSection = GTab:NewSection("Chat spam/spoof - Infinite Yield");


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

ASection:NewToggle("Super Rapid Punch", "Punches instantly when you click", function(state)
    getgenv().superrapidpunch = state

    -- Punch function: 50 punch packets, no delay
    local function rapidPunch()
        for _ = 1, 50 do
            ReplicatedStorage.Events.Punch:FireServer(0, 0.1, 1)
        end
    end

    -- Mouse input handler: Only activates on left click
    local function onInputEnded(input, gameProcessed)
        if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 and getgenv().superrapidpunch then
            rapidPunch()
        end
    end

    -- Handle binding/unbinding
    if state then
        getgenv().superrapidpunch_conn = UserInputService.InputEnded:Connect(onInputEnded)
    else
        if getgenv().superrapidpunch_conn then
            getgenv().superrapidpunch_conn:Disconnect()
            getgenv().superrapidpunch_conn = nil
        end
    end
end)



-- NoClip Toggle State
local noClipEnabled = false

-- Setup NoClip Toggle
ASection:NewToggle("NoClip", "Walk through walls", function(state)
    noClipEnabled = state
end)

-- NoClip Loop - Very Stable
game:GetService("RunService").Stepped:Connect(function()
    if noClipEnabled then
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    part.CanCollide = false
                end
            end
        end
    end
end)


local teleportEnabled = false
local teleportPosition = Vector3.new(-379.5263366699219, 94.1015625, 70.03193664550781)
local player = game.Players.LocalPlayer

local function teleportPlayer()
    while teleportEnabled do
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoidRootPart then
            humanoidRootPart.CFrame = CFrame.new(teleportPosition)
            print("Teleported to location: " .. tostring(teleportPosition))
        else
            warn("HumanoidRootPart not found! Waiting for respawn...")
        end
        
        wait(0.1) -- Prevents lag and ensures smooth teleportation
    end
end

AutoSection:NewToggle("Farm at middle", "Toggle teleportation to a specific location.", function(state)
    teleportEnabled = state

    if teleportEnabled then
        print("Auto Teleport enabled.")
        
        spawn(function()
            teleportPlayer()
        end)

        -- Keep teleporting even after death
        player.CharacterAdded:Connect(function()
            if teleportEnabled then
                wait(0.5) -- Wait a moment to ensure character loads
                teleportPlayer()
            end
        end)
        
    else
        print("Auto Teleport disabled.")
    end
end)







-- Platform Spawn Function
function SpawnPlatform()
    local platform = Instance.new("Part")
    platform.Size = Vector3.new(50, 1, 50)
    platform.Position = Vector3.new(-86.5912628173821, 1000035, 14.80127811431848)
    platform.Anchored = true
    platform.Parent = workspace
    platform.Name = "CustomPlatform"
    platform.BrickColor = BrickColor.new("Pink")
end

-- Teleport Function
function TeleportToPlatform()
    if workspace:FindFirstChild("CustomPlatform") then
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(-86.5912628173821, 1000036, 14.80127811431848)
        end
    end
end

ASection:NewButton("Spawn Platform","", SpawnPlatform)
ASection:NewButton("Teleport to Platform","", TeleportToPlatform)







-----------------------------------------------------------------------------
ASection:NewToggle("Super Rapid Punch (Beta)", "", function(state)
    getgenv().superrapid = state
    local UserInputService = game:GetService("UserInputService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local PunchEvent = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("Punch")

    -- Make sure the event exists
    if not PunchEvent then
        warn("Punch event not found!")
        return
    end

    local punchCount = 10  -- Lower count per burst to prevent overload
    local punchDelay = 0.05 -- Slightly increased delay for stability
    local punching = false  -- Track if punching is active

    -- Function to execute rapid punches
    local function rapidPunch()
        punching = true
        while getgenv().superrapid and punching do
            for _ = 1, punchCount do
                if not punching then break end -- Stop mid-loop if necessary
                PunchEvent:FireServer(0, 0.1, 1)
                task.wait(0.005) -- Prevent instant overload
            end
            task.wait(punchDelay)
        end
    end

    -- Start punching on mouse press
    local function onInputBegan(input, gameProcessed)
        if not gameProcessed and getgenv().superrapid and input.UserInputType == Enum.UserInputType.MouseButton1 then
            if not punching then
                task.spawn(rapidPunch)
            end
        end
    end

    -- Stop punching on mouse release
    local function onInputEnded(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            punching = false
        end
    end

    -- Manage input connection for toggling
    if state then
        if not getgenv().inputConnection then
            getgenv().inputConnection = UserInputService.InputBegan:Connect(onInputBegan)
            getgenv().inputReleaseConnection = UserInputService.InputEnded:Connect(onInputEnded)
        end
    else
        getgenv().superrapid = false
        punching = false
        if getgenv().inputConnection then
            getgenv().inputConnection:Disconnect()
            getgenv().inputConnection = nil
        end
        if getgenv().inputReleaseConnection then
            getgenv().inputReleaseConnection:Disconnect()
            getgenv().inputReleaseConnection = nil
        end
    end
end)

ASection:NewButton("World Edit", "", function()
    -- Click to select a part. Press R for Move, T for Resize, Z or Y for Rotate, G to delete.
-- Press B to disable or enable Part manipulation tool!

-- Main Configurations
local DefaultMode = "Move"
local ROTATION_GRID = 15  -- Grid increment in degrees
local GRID_SIZE = 1  -- Size of the grid (in studs)
local MaxDragHandleAtOnce = 1

--Handle and other configurations

local HANDLE_RADIUS = 0.9
local INNER_HANDLE_RADIUS = 0.25
local HANDLE_TRANSPARENCY = 0
local HANDLE_OFFSET = 1.5
local RING_THICKNESS = 0.15
local MAX_SIZE_PER_AXIS = 2048  -- Maximum size per axis in studs for resize mode (Do not change above 2048)

--Script
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Constants
local HANDLE_COLORS = {
	[Enum.Axis.X] = Color3.new(0.870588, 0.0980392, 0.12549),
	[Enum.Axis.Y] = Color3.new(0.0705882, 0.780392, 0.105882),
	[Enum.Axis.Z] = Color3.new(0.0666667, 0.560784, 0.909804)
}

local HANDLE_ACTIVE_COLORS = {
	[Enum.Axis.X] = Color3.new(1, 0.113725, 0.145098),
	[Enum.Axis.Y] = Color3.new(0.0784314, 0.862745, 0.105882),
	[Enum.Axis.Z] = Color3.new(0.12549, 0.694118, 1)
}

local INNER_HANDLE_COLORS = {
	[Enum.Axis.X] = Color3.new(0.596078, 0.0666667, 0.0862745),
	[Enum.Axis.Y] = Color3.new(0.054902, 0.619608, 0.0666667),
	[Enum.Axis.Z] = Color3.new(0.0470588, 0.411765, 0.65098)
}

local NORMALS_TO_AXIS = {
	[Enum.NormalId.Left] = Enum.Axis.X,
	[Enum.NormalId.Right] = Enum.Axis.X,
	[Enum.NormalId.Top] = Enum.Axis.Y,
	[Enum.NormalId.Bottom] = Enum.Axis.Y,
	[Enum.NormalId.Back] = Enum.Axis.Z,
	[Enum.NormalId.Front] = Enum.Axis.Z
}

local INVERSE_NORMALS = {
	[Enum.NormalId.Left] = true,
	[Enum.NormalId.Bottom] = true,
	[Enum.NormalId.Back] = true
}

-- Global variables
local SelectedPart = nil
local CurrentMode = DefaultMode
local Handles = {}
local IsHoveringHandle = false
local RotationHandles = {}
local ActiveHandles = {}
local BuildingEnabled = true  -- New variable to track building state

-- Helper Functions
local function ApplySnap(value, isRotation)
	if isRotation then
		return math.rad(math.floor(math.deg(value) / ROTATION_GRID) * ROTATION_GRID)
	else
		return math.floor(value / GRID_SIZE) * GRID_SIZE
	end
end

local function CanActivateHandle()
	return #ActiveHandles < MaxDragHandleAtOnce
end

local function GetMousePositionOnAxis(axisVector, partCFrame)
    local UserInputService = game:GetService("UserInputService")
    local camera = workspace.CurrentCamera
    if not camera then return partCFrame.Position end

    -- Get mouse position and ensure axisVector is normalized
    local mouseLocation = UserInputService:GetMouseLocation()
    local normalizedAxisVector = axisVector.Unit
    
    -- Calculate world-space axis and position
    local worldAxisVector = partCFrame:VectorToWorldSpace(normalizedAxisVector)
    local partPosition = partCFrame.Position
    
    -- Create and normalize ray from camera through mouse position
    local rayOrigin = camera.CFrame.Position
    local rayDirection = camera:ScreenPointToRay(mouseLocation.X, mouseLocation.Y).Direction.Unit
    
    -- Calculate camera-aligned plane for intersection
    local planeNormal = camera.CFrame.LookVector
    local planeDot = planeNormal:Dot(rayDirection)
    
    -- Handle near-parallel cases and invalid conditions
    local MIN_DOT_THRESHOLD = 1e-4
    if math.abs(planeDot) < MIN_DOT_THRESHOLD then
        return partPosition
    end
    
    -- Calculate intersection with camera-aligned plane
    local vectorToPlane = partPosition - rayOrigin
    local intersectionDistance = planeNormal:Dot(vectorToPlane) / planeDot
    
    -- Validate intersection distance
    if intersectionDistance < 0 then
        return partPosition
    end
    
    -- Calculate final intersection point and project onto movement axis
    local planeIntersection = rayOrigin + rayDirection * intersectionDistance
    local vectorToIntersection = planeIntersection - partPosition
    local axisProjection = worldAxisVector:Dot(vectorToIntersection)
    local projectedPosition = partPosition + worldAxisVector * axisProjection
    
    return projectedPosition
end

local function GetOrCreateHandlesFolder()
	local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
	local HandlesFolder = PlayerGui:FindFirstChild("Handles")
	if not HandlesFolder then
		HandlesFolder = Instance.new("Folder")
		HandlesFolder.Name = "Handles"
		HandlesFolder.Parent = PlayerGui
	end
	return HandlesFolder
end

local function CreateMoveResizeHandle(Normal, Resize)
	if not SelectedPart then return nil end

	local NormalToAxis = NORMALS_TO_AXIS[Normal]
	local HANDLE_COLOR = HANDLE_COLORS[NormalToAxis]
	local INNER_HANDLE_COLOR = INNER_HANDLE_COLORS[NormalToAxis]
	local HandlesFolder = GetOrCreateHandlesFolder()
	local NormalVector = Vector3.fromNormalId(Normal)

	local HandleAdornment = nil
	if Resize then
		HandleAdornment = Instance.new("SphereHandleAdornment")
		HandleAdornment.Radius = HANDLE_RADIUS / 2
	else
		HandleAdornment = Instance.new("BoxHandleAdornment")
		HandleAdornment.Size = Vector3.new(HANDLE_RADIUS, HANDLE_RADIUS, HANDLE_RADIUS)
	end

	HandleAdornment.Adornee = SelectedPart
	HandleAdornment.Color3 = HANDLE_COLOR
	HandleAdornment.SizeRelativeOffset = NormalVector
	HandleAdornment.CFrame = CFrame.new(NormalVector * HANDLE_OFFSET)
	HandleAdornment.ZIndex = 1
	HandleAdornment.AlwaysOnTop = true
	HandleAdornment.Transparency = HANDLE_TRANSPARENCY
	HandleAdornment.Parent = HandlesFolder

	local InnerHandlePoint = nil
	if Resize then
		InnerHandlePoint = Instance.new("SphereHandleAdornment")
		InnerHandlePoint.Radius = INNER_HANDLE_RADIUS / 2
	else
		InnerHandlePoint = Instance.new("BoxHandleAdornment")
		InnerHandlePoint.Size = Vector3.new(INNER_HANDLE_RADIUS, INNER_HANDLE_RADIUS, INNER_HANDLE_RADIUS)
	end

	InnerHandlePoint.Adornee = SelectedPart
	InnerHandlePoint.Color3 = INNER_HANDLE_COLOR
	InnerHandlePoint.SizeRelativeOffset = NormalVector
	InnerHandlePoint.CFrame = CFrame.new(NormalVector * HANDLE_OFFSET)
	InnerHandlePoint.ZIndex = 2
	InnerHandlePoint.AlwaysOnTop = true
	InnerHandlePoint.Transparency = 0
	InnerHandlePoint.Parent = HandlesFolder

	HandleAdornment.MouseEnter:Connect(function()
		IsHoveringHandle = true
	end)

	HandleAdornment.MouseLeave:Connect(function()
		IsHoveringHandle = false
	end)

	return HandleAdornment
end

local function SetupHandleMoving(handle, Normal)
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local camera = workspace.CurrentCamera
    
    local moving = false
    local startMousePos = nil
    local axisVector = Vector3.fromNormalId(Normal)
    local startCFrame = nil
    local totalOffset = 0
    
    local function GetAxisMovement(startPos, currentPos, worldAxis)
        -- Convert world axis to screen axis
        local axisStart = camera:WorldToViewportPoint(startCFrame.Position)
        local axisEnd = camera:WorldToViewportPoint(startCFrame.Position + worldAxis)
        local screenAxis = Vector2.new(axisEnd.X - axisStart.X, axisEnd.Y - axisStart.Y).Unit
        
        -- Get screen movement delta
        local screenDelta = Vector2.new(currentPos.X - startPos.X, currentPos.Y - startPos.Y)
        
        -- Project screen movement onto axis
        local movement = screenDelta:Dot(screenAxis)
        
        -- Scale movement based on screen-to-world ratio
        local worldDistance = (startCFrame.Position - camera.CFrame.Position).Magnitude
        local screenScale = worldDistance / camera.ViewportSize.X
        
        return movement * screenScale
    end
    
    local function StartMoving()
        if not CanActivateHandle() then return end
        
        -- Set handle color
        local NormalToAxis = NORMALS_TO_AXIS[Normal]
        local HANDLE_ACTIVE_COLOR = HANDLE_ACTIVE_COLORS[NormalToAxis]
        handle.Color3 = HANDLE_ACTIVE_COLOR
        
        -- Initialize movement
        moving = true
        startCFrame = SelectedPart.CFrame
        startMousePos = UserInputService:GetMouseLocation()
        totalOffset = 0
        
        table.insert(ActiveHandles, handle)
        
        local worldAxis = startCFrame:VectorToWorldSpace(axisVector)
    end
    
    local function UpdatePosition()
        if not (moving and SelectedPart and startMousePos) then return end
        
        local currentMousePos = UserInputService:GetMouseLocation()
        local worldAxis = startCFrame:VectorToWorldSpace(axisVector)
        
        -- Calculate movement along axis
        local delta = GetAxisMovement(startMousePos, currentMousePos, worldAxis)
        local newOffset = ApplySnap(totalOffset + delta) - totalOffset
        
        if math.abs(newOffset) > 0.001 then
            -- Apply movement in world space
            SelectedPart.CFrame = startCFrame * CFrame.new(
                axisVector.X * newOffset,
                axisVector.Y * newOffset,
                axisVector.Z * newOffset
            )
            totalOffset = totalOffset + newOffset
        end
    end
    
    local function StopMoving()
        if not moving then return end
        
        moving = false
        startMousePos = nil
        startCFrame = nil
        totalOffset = 0
        
        -- Reset handle color
        local NormalToAxis = NORMALS_TO_AXIS[Normal]
        local HANDLE_COLOR = HANDLE_COLORS[NormalToAxis]
        handle.Color3 = HANDLE_COLOR
        
        -- Remove from active handles
        for i, activeHandle in ipairs(ActiveHandles) do
            if activeHandle == handle then
                table.remove(ActiveHandles, i)
                break
            end
        end
    end
    
    -- Connect events
    handle.MouseButton1Down:Connect(StartMoving)
    
    UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or 
            input.UserInputType == Enum.UserInputType.Touch) and moving then
            StopMoving()
        end
    end)
    
    RunService.Heartbeat:Connect(UpdatePosition)
end


local function CreateRotationRing(Axis)
	if not SelectedPart then return nil end

	local HandlesFolder = GetOrCreateHandlesFolder()
	local RING_RADIUS = (SelectedPart.Size.Magnitude / 2) + (HANDLE_OFFSET / 2)

	local RingAdornment = Instance.new("CylinderHandleAdornment")
	RingAdornment.Adornee = SelectedPart
	RingAdornment.Color3 = HANDLE_COLORS[Axis]
	RingAdornment.Height = RING_THICKNESS
	RingAdornment.Radius = RING_RADIUS
	RingAdornment.InnerRadius = RING_RADIUS - RING_THICKNESS
	RingAdornment.ZIndex = 1
	RingAdornment.AlwaysOnTop = false
	RingAdornment.Transparency = HANDLE_TRANSPARENCY
	RingAdornment.Parent = HandlesFolder

	if Axis == Enum.Axis.Z then
		RingAdornment.CFrame = CFrame.fromAxisAngle(Vector3.new(0, 0, 1), math.rad(90))
	elseif Axis == Enum.Axis.Y then
		RingAdornment.CFrame = CFrame.fromAxisAngle(Vector3.new(1, 0, 0), math.rad(90))
	elseif Axis == Enum.Axis.X then
		RingAdornment.CFrame = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), math.rad(90))
	end

	return RingAdornment
end

local function ScreenPointToPlane(camera, screenPoint, planePoint, planeNormal)
	local rayOrigin = camera.CFrame.Position
	local rayDirection = camera:ScreenPointToRay(screenPoint.X, screenPoint.Y).Unit.Direction

	local dot = planeNormal:Dot(rayDirection)

	if math.abs(dot) > 1e-6 then
		local t = (planeNormal:Dot(planePoint - rayOrigin)) / dot
		return rayOrigin + rayDirection * t
	end

	return nil
end

local function CreateRotationHandle(Axis, Direction)
	if not SelectedPart then return nil end

	local HANDLE_COLOR = HANDLE_COLORS[Axis]
	local INNER_HANDLE_COLOR = INNER_HANDLE_COLORS[Axis]
	local HandlesFolder = GetOrCreateHandlesFolder()

	local NormalVector = CFrame.identity

	if Axis == Enum.Axis.Z then
		NormalVector = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), math.rad(90))
	elseif Axis == Enum.Axis.X then
		NormalVector = CFrame.fromAxisAngle(Vector3.new(1, 0, 0), math.rad(-90))
	elseif Axis == Enum.Axis.Y then
		NormalVector = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), math.rad(0))
	end

	local RING_RADIUS = (SelectedPart.Size.Magnitude / 2) + (HANDLE_OFFSET / 2)

	local HandleAdornment = Instance.new("SphereHandleAdornment")
	HandleAdornment.Adornee = SelectedPart
	HandleAdornment.Color3 = HANDLE_COLOR
	HandleAdornment.CFrame = NormalVector * CFrame.new(0, 0, -RING_RADIUS * Direction)
	HandleAdornment.ZIndex = 2
	HandleAdornment.AlwaysOnTop = true
	HandleAdornment.Radius = HANDLE_RADIUS / 2
	HandleAdornment.Transparency = 0
	HandleAdornment.Parent = HandlesFolder

	local InnerHandlePoint = Instance.new("SphereHandleAdornment")
	InnerHandlePoint.Adornee = SelectedPart
	InnerHandlePoint.Color3 = INNER_HANDLE_COLOR
	InnerHandlePoint.CFrame = NormalVector * CFrame.new(0, 0, -RING_RADIUS * Direction)
	InnerHandlePoint.ZIndex = 3
	InnerHandlePoint.AlwaysOnTop = true
	InnerHandlePoint.Radius = INNER_HANDLE_RADIUS / 2
	InnerHandlePoint.Transparency = 0
	InnerHandlePoint.Parent = HandlesFolder

	HandleAdornment.MouseEnter:Connect(function()
		HandleAdornment.Color3 = HANDLE_ACTIVE_COLORS[Axis]
		IsHoveringHandle = true
	end)

	HandleAdornment.MouseLeave:Connect(function()
		HandleAdornment.Color3 = HANDLE_COLOR
		IsHoveringHandle = false
	end)

	return HandleAdornment
end

local function SetupRotationHandleDragging(handle, Axis, Direction)
	local dragging = false
	local lastMousePosition = nil
	local startCFrame = nil
	local accumulatedRotation = 0
	local totalRotation = 0
	local camera = workspace.CurrentCamera

	handle.MouseButton1Down:Connect(function()
		if not CanActivateHandle() then return end
		dragging = true
		lastMousePosition = UserInputService:GetMouseLocation()
		startCFrame = SelectedPart.CFrame
		accumulatedRotation = 0
		totalRotation = 0
		table.insert(ActiveHandles, handle)
	end)

	local function UpdateRotation()
		if not dragging or not SelectedPart then return end

		local currentMousePosition = UserInputService:GetMouseLocation()
		if lastMousePosition and startCFrame then
			local axisVector = Vector3.fromAxis(Axis)
			local worldAxisVector = startCFrame:VectorToWorldSpace(axisVector)

			-- Project mouse movement onto a plane perpendicular to the rotation axis
			local planeNormal = worldAxisVector
			local planePoint = startCFrame.Position
			local oldPoint = ScreenPointToPlane(camera, lastMousePosition, planePoint, planeNormal)
			local newPoint = ScreenPointToPlane(camera, currentMousePosition, planePoint, planeNormal)

			if oldPoint and newPoint then
				-- Calculate the angle between old and new points
				local centerToOld = (oldPoint - planePoint).Unit
				local centerToNew = (newPoint - planePoint).Unit
				local deltaAngle = math.atan2(centerToNew:Cross(centerToOld):Dot(planeNormal), centerToNew:Dot(centerToOld))

				-- Apply direction and sensitivity
				deltaAngle = deltaAngle * Direction * 1 -- Adjust sensitivity if needed

				accumulatedRotation = accumulatedRotation + deltaAngle

				local snappedRotation = ApplySnap(totalRotation + accumulatedRotation, true) - totalRotation

				if snappedRotation ~= 0 then
					local newCFrame = startCFrame * CFrame.fromAxisAngle(axisVector, totalRotation + snappedRotation)
					SelectedPart.CFrame = newCFrame
					totalRotation = totalRotation + snappedRotation
					accumulatedRotation = accumulatedRotation - snappedRotation
				end
			end

			lastMousePosition = currentMousePosition
		end
	end

	RunService.Heartbeat:Connect(UpdateRotation)

	UserInputService.InputEnded:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and dragging then
			dragging = false
			for i, activeHandle in ipairs(ActiveHandles) do
				if activeHandle == handle then
					table.remove(ActiveHandles, i)
					break
				end
			end
		end
	end)
end

local function SetupHandleResizing(handle, Normal)
	local resizing = false
	local lastPosition = nil
	local axisVector = Vector3.fromNormalId(Normal)
	local startSize = nil
	local startCFrame = nil
	local accumulatedDelta = 0
	local totalSizeDelta = 0

	handle.MouseButton1Down:Connect(function()
		if not CanActivateHandle() then return end
		local NormalToAxis = NORMALS_TO_AXIS[Normal]
		local HANDLE_ACTIVE_COLOR = HANDLE_ACTIVE_COLORS[NormalToAxis]
		handle.Color3 = HANDLE_ACTIVE_COLOR
		resizing = true
		lastPosition = GetMousePositionOnAxis(axisVector, SelectedPart.CFrame)
		startSize = SelectedPart.Size
		startCFrame = SelectedPart.CFrame
		accumulatedDelta = 0
		totalSizeDelta = 0
		table.insert(ActiveHandles, handle)
	end)

	local function UpdateSize()
		if not resizing or not SelectedPart then return end

		local currentPosition = GetMousePositionOnAxis(axisVector, SelectedPart.CFrame)
		if lastPosition and startSize and startCFrame then
			local worldDelta = (currentPosition - lastPosition):Dot(startCFrame.RightVector * axisVector.X + startCFrame.UpVector * axisVector.Y + startCFrame.LookVector * axisVector.Z)

			-- Invert the delta for Left, Bottom, and Front normals
			if INVERSE_NORMALS[Normal] then
				worldDelta = -worldDelta
			end

			accumulatedDelta = accumulatedDelta + worldDelta

			local sizeDelta = ApplySnap(totalSizeDelta + accumulatedDelta) - totalSizeDelta


			if sizeDelta ~= 0 then
				local newSize = SelectedPart.Size + (axisVector * sizeDelta)
				newSize = Vector3.new(
					math.clamp(newSize.X, GRID_SIZE, MAX_SIZE_PER_AXIS),
					math.clamp(newSize.Y, GRID_SIZE, MAX_SIZE_PER_AXIS),
					math.clamp(newSize.Z, GRID_SIZE, MAX_SIZE_PER_AXIS)
				)

				SelectedPart.Size = newSize

				-- Adjust position to keep the opposite face stationary
				local positionOffset = startCFrame:VectorToWorldSpace((newSize - startSize) * 0.5 * axisVector)
				SelectedPart.Position = startCFrame.Position + positionOffset

				totalSizeDelta = totalSizeDelta + sizeDelta
				accumulatedDelta = accumulatedDelta - sizeDelta
			end

			lastPosition = currentPosition
		end
	end

	RunService.Heartbeat:Connect(UpdateSize)

	UserInputService.InputEnded:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and resizing then
			resizing = false
			local NormalToAxis = NORMALS_TO_AXIS[Normal]
			local HANDLE_COLOR = HANDLE_COLORS[NormalToAxis]
			handle.Color3 = HANDLE_COLOR
			for i, activeHandle in ipairs(ActiveHandles) do
				if activeHandle == handle then
					table.remove(ActiveHandles, i)
					break
				end
			end
		end
	end)
end

local function CreateRotationHandlesAndRings()
	if not SelectedPart then return end

	for _, Axis in ipairs(Enum.Axis:GetEnumItems()) do
		local ring = CreateRotationRing(Axis)
		table.insert(RotationHandles, ring)
	end

	local AxisPairs = {
		{Enum.Axis.X, 1, -1},
		{Enum.Axis.Y, 1, -1},
		{Enum.Axis.Z, 1, -1}
	}

	for _, AxisPair in ipairs(AxisPairs) do
		local handle1 = CreateRotationHandle(AxisPair[1], AxisPair[2])  -- Create handle on positive side
		local handle2 = CreateRotationHandle(AxisPair[1], AxisPair[3])  -- Create handle on negative side
		if handle1 and handle2 then
			SetupRotationHandleDragging(handle1, AxisPair[1], AxisPair[2])
			SetupRotationHandleDragging(handle2, AxisPair[1], AxisPair[3])
			table.insert(RotationHandles, handle1)
			table.insert(RotationHandles, handle2)
		end
	end
end


local function SetupHandleManipulation(handle, Normal)
	if CurrentMode == "Move" then
		SetupHandleMoving(handle, Normal)
	elseif CurrentMode == "Resize" then
		SetupHandleResizing(handle, Normal)
	end
end

local function CreateHandles(Resize)
	if not SelectedPart then return end

	for _, Normal in ipairs(Enum.NormalId:GetEnumItems()) do
		local handle = CreateMoveResizeHandle(Normal, Resize)
		if handle then
			SetupHandleManipulation(handle, Normal)
			table.insert(Handles, handle)
		end
	end
end

local function ClearHandles()
	local HandlesFolder = GetOrCreateHandlesFolder()
	HandlesFolder:ClearAllChildren()
	Handles = {}
	RotationHandles = {}
end

local function UpdateHandles()
	ClearHandles()
	if SelectedPart then
		if CurrentMode == "Move" or CurrentMode == "Resize" then
			if CurrentMode == "Resize" then
				CreateHandles(true)
			else
				CreateHandles(false)
			end
		elseif CurrentMode == "Rotate" then
			CreateRotationHandlesAndRings()
		end
	end
end



local function SetMode(mode)
	if not BuildingEnabled then return end  -- Don't change mode if building is disabled

	CurrentMode = mode
	print("Set mode to:", mode)
	UpdateHandles()
end

local function DeselectPart()
	if IsHoveringHandle then return end  -- Prevent deselection if hovering over a handle
	SelectedPart = nil
	ClearHandles()
end

local function ToggleBuildMode()
	BuildingEnabled = not BuildingEnabled
	if not BuildingEnabled then
		-- Clean up when disabling build mode
		DeselectPart()
		ClearHandles()
		print("Building mode disabled")
	else
		print("Building mode enabled")
	end
end

local function SelectPart(part)
	if not BuildingEnabled then return end  -- Don't select if building is disabled

	if SelectedPart then
		DeselectPart()  -- Clean up the previously selected part
	end
	if part:IsA("BasePart") then
		SelectedPart = part
	end
	UpdateHandles()
end

-- Set up part selection
local function SetupPartSelection()
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed then
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				if not BuildingEnabled then return end  -- Don't process clicks if building is disabled
				if IsHoveringHandle then return end  -- Prevent deselection if hovering over a handle

				local mouse = Players.LocalPlayer:GetMouse()
				local target = mouse.Target
				if target and target:IsA("BasePart") then
					SelectPart(target)
				else
					DeselectPart()
				end
			elseif input.KeyCode == Enum.KeyCode.G and SelectedPart and BuildingEnabled then
				-- Delete functionality (only works if building is enabled)
				SelectedPart:Destroy()
				DeselectPart()
			elseif input.KeyCode == Enum.KeyCode.B then
				-- Toggle build mode
				ToggleBuildMode()
			end
		end
	end)
end


-- Set up mode switching using keyboard input
local function SetupModeSwitching()
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed and BuildingEnabled then  -- Only process if building is enabled
			if input.KeyCode == Enum.KeyCode.R then
				SetMode("Move")
			elseif input.KeyCode == Enum.KeyCode.T then
				SetMode("Resize")
			elseif input.KeyCode == Enum.KeyCode.Z or input.KeyCode == Enum.KeyCode.Y then
				SetMode("Rotate")
			end
		end
	end)
end


-- Main execution
SetupPartSelection()
SetupModeSwitching()

SetMode(DefaultMode)

print("Part manipulation tool initialized. Click to select a part. Press R for Move, T for Resize, Z or Y for Rotate, G to delete. Current mode: " .. DefaultMode)

print("Press B to disable or enable Part manipulation tool !")
end);
-----------------------------------------------------------------------------
ASection:NewToggle("Main Anti-Tele", "Activate ultimate protection against all grab effects!", function(state)
    -- Toggle the Anti-Grab functionality
    getgenv().AntiT = state

    -- Local references for efficiency
    local player = game.Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")

    -- Ensure the event path is correct
    local toggleTelekinesisEvent = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("ToggleTelekinesis")

    -- Directly protect the player from any grab attempt
    local function protectPlayer()
        if getgenv().AntiT and toggleTelekinesisEvent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            -- Invoke the event with the HumanoidRootPart's position (if needed)
            toggleTelekinesisEvent:InvokeServer(hrp.Position, false, player.Character)
        end
    end

    -- Frame-by-frame anti-grab functionality
    if state then
        if toggleTelekinesisEvent then
            -- Using RenderStepped for immediate, frame-by-frame protection
            getgenv().protectionConnection = RunService.RenderStepped:Connect(protectPlayer)
        else
            warn("[Anti-Tele] Warning: ToggleTelekinesis event not found! The script may not work.")
        end
    else
        -- Disconnect the protection when toggled off
        if getgenv().protectionConnection then
            getgenv().protectionConnection:Disconnect()
            getgenv().protectionConnection = nil
        end
        getgenv().AntiT = false
    end
end)

----------------------------------------------------------------

local isSpamming = false

-- Toggle for Extreme Lag Spam
ASection:NewToggle("Server Lag Spam", "Overloads the server with requests", function(state)
    isSpamming = state -- Toggle spam state

    if isSpamming then
        while isSpamming do
            for _ = 1, 100000 do  -- Sends 100,000 requests per tick (massive lag)
                game:GetService("ReplicatedStorage").Events.ToggleSpeed:FireServer(true)
                game:GetService("ReplicatedStorage").Events.UpgradeAbility:InvokeServer("Speed")
                game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(0,0,0), false)
            end
        end
    else
        game:GetService("ReplicatedStorage").Events.ToggleSpeed:FireServer(false) -- Stops spamming
    end
end)

local isSpamming = false

-- Toggle for Controlled Lag
ASection:NewToggle("Controlled Server Lag", "Slows down the server but avoids instant crash", function(state)
    isSpamming = state -- Toggle lag state

    if isSpamming then
        coroutine.wrap(function()
            while isSpamming do
                for _ = 1, 5000 do  -- Sends 5000 requests per tick (heavy lag, but not an instant crash)
                    game:GetService("ReplicatedStorage").Events.ToggleSpeed:FireServer(true)
                    game:GetService("ReplicatedStorage").Events.UpgradeAbility:InvokeServer("Speed")
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(0,0,0), false)
                end
                wait(0.05) -- Small delay to prevent complete freeze
            end
        end)()
    else
        game:GetService("ReplicatedStorage").Events.ToggleSpeed:FireServer(false) -- Stops spamming
    end
end)

---------------------------------------------------------------

-- Coordinates from your image
local teleportCoords = Vector3.new(-1742.1265869140625, 442.5755615234375, 1210.2801513671875)

-- Teleport Button
AutoSection:NewButton("Teleport to hidden location", "Click to teleport!", function()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportCoords)
    else
        warn("Teleport failed! Character not found.")
    end
end)

local function teleportPlayerTo(location)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(location)
        print("Teleported to custom location: " .. tostring(location))
    else
        warn("HumanoidRootPart not found!")
    end
end

AutoSection:NewButton("Teleport Chair", "Teleports you to the specified location", function()
    teleportPlayerTo(Vector3.new(-1295.6533203125, 196.8809356689453, 175.90008544921875)) 
end)




local function teleportPlayerTo(location)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(location)
        print("Teleported to custom location: " .. tostring(location))
    else
        warn("HumanoidRootPart not found!")
    end
end

AutoSection:NewButton("Teleport to middle corner", "Teleports you to the specified location", function()
    teleportPlayerTo(Vector3.new(-553.23, 94.34, 89.34)) 
end)



local function teleportPlayerTo(location)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(location) 
        print("Teleported to custom location: " .. tostring(location))
    else
        warn("HumanoidRootPart not found!")
    end
end

AutoSection:NewButton("Teleport to New Location", "Teleports you to the specified location", function()
    teleportPlayerTo(Vector3.new(-428.08, 110.59, 434.46)) 
end)






local function teleportPlayerTo(location)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(location)
        print("Teleported to custom location: " .. tostring(location))
    else
        warn("HumanoidRootPart not found!")
    end
end


AutoSection:NewButton("Teleport Middle bottom", "Teleports you to the specified location", function()
    teleportPlayerTo(Vector3.new(-386.02, 94.34, 430.05)) 
end)

local teleportPosition = Vector3.new(2810, 102, 2821)

local teleportEnabled = false

local function teleportPlayer()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(teleportPosition)
        print("Teleported to predefined location: " .. tostring(teleportPosition))
    else
        warn("HumanoidRootPart not found!")
    end
end


if teleportEnabled then
    teleportPlayer() 
end








local function teleportPlayerTo(location)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    humanoidRootPart.CFrame = CFrame.new(location)
end

AutoSection:NewButton("Teleport to Bar", "Teleports you to the location", function()
    teleportPlayerTo(Vector3.new(-1313, 197, 149))
end)

local teleportPosition = Vector3.new(2810, 102, 2821)

local teleportEnabled = false


local function teleportPlayer()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        print("Teleported to location: " .. tostring(teleportPosition))
    else
        warn("Character or HumanoidRootPart not found!")
    end
end


AutoSection:NewToggle("Corner-4", "Toggle teleportation to a specific location.", function(state)
    teleportEnabled = state
    if teleportEnabled then
        print("Auto Teleport enabled.")
        
        spawn(function()
            while teleportEnabled do
                teleportPlayer()
                wait(0.01)
            end
        end)
    else
        print("Auto Teleport disabled.")
    end
end)

local teleportPosition = Vector3.new(-3650, 97, 2764)


local teleportEnabled = false

local function teleportPlayer()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        print("Teleported to location: " .. tostring(teleportPosition))
    else
        warn("Character or HumanoidRootPart not found!")
    end
end


AutoSection:NewToggle("Corner-3", "Toggle teleportation to a specific location.", function(state)
    teleportEnabled = state
    if teleportEnabled then
        print("Auto Teleport enabled.")
        spawn(function()
            while teleportEnabled do
                teleportPlayer()
                wait(0.01)
            end
        end)
    else
        print("Auto Teleport disabled.")
    end
end)

local teleportPosition = Vector3.new(-3757, 97, -3801)


local teleportEnabled = false

local function teleportPlayer()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        print("Teleported to location: " .. tostring(teleportPosition))
    else
        warn("Character or HumanoidRootPart not found!")
    end
end


AutoSection:NewToggle("Corner-2", "Toggle teleportation to a specific location.", function(state)
    teleportEnabled = state
    if teleportEnabled then
        print("Auto Teleport enabled.")
        
        spawn(function()
            while teleportEnabled do
                teleportPlayer()
                wait(0.01)
            end
        end)
    else
        print("Auto Teleport disabled.")
    end
end)
local teleportPosition = Vector3.new(2773, 96, -4996)

local teleportEnabled = false

local function teleportPlayer()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        print("Teleported to location: " .. tostring(teleportPosition))
    else
        warn("Character or HumanoidRootPart not found!")
    end
end


AutoSection:NewToggle("Corner-1", "Toggle teleportation to a specific location.", function(state)
    teleportEnabled = state
    if teleportEnabled then
        print("Auto Teleport enabled.")
        
        spawn(function()
            while teleportEnabled do
                teleportPlayer()
                wait(0.01)
            end
        end)
    else
        print("Auto Teleport disabled.")
    end
end)

local targetPosition = Vector3.new(-1685.116, 128.436, -1405.940)

local function teleportPlayer()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
    end
end

AutoSection:NewButton("Teleport to Motel Sign", "Click to teleport to the top of the motel sign", function()
    teleportPlayer()
end)

---------------------------------------------------------------------------------------------------------------------------------------
GUISection:NewButton("Gravity", "", function()
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Zero-Gravity-28484"))()
end)

GUISection:NewButton("OP Powers UI", "", function()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/Fuck-KavoUI.lua"))()

local NeonPinkTheme = {
    SchemeColor = Color3.fromRGB(255, 20, 147),   -- Neon pink (deep pink with a neon glow)
    Background = Color3.fromRGB(18, 18, 22),       -- Dark background for contrast
    Header = Color3.fromRGB(34, 34, 41),           -- Darker background for header
    TextColor = Color3.fromRGB(255, 255, 255),     -- White text for readability
    ElementColor = Color3.fromRGB(38, 38, 46)      -- Slightly lighter background for UI elements
}

local Window = Library.CreateLib("OP Powers", NeonPinkTheme)
local PlayerTab = Window:NewTab("Main");
local PlayerSection = PlayerTab:NewSection("Main Tools");

PlayerSection:NewToggle("NPC Police Killaura", "Automatically attack nearby NPC Police.", function(state)
    local player = game.Players.LocalPlayer
    local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

    if state then
        -- Enable NPC Killaura
        getgenv().NPCPoliceKillaura = true
        spawn(function()
            while getgenv().NPCPoliceKillaura do
                pcall(function()
                    for _, npc in pairs(game.Workspace:GetChildren()) do
                        if npc:IsA("Model") and npc.Name == "Police" and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                            local npcRoot = npc:FindFirstChild("HumanoidRootPart")
                            if npcRoot and (rootPart.Position - npcRoot.Position).Magnitude <= 15 then
                                -- Attack the NPC Police
                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                            end
                        end
                    end
                end)
                wait(0.1) -- Check and attack every 0.1 seconds
            end
        end)
    else
        -- Disable NPC Killaura
        getgenv().NPCPoliceKillaura = false
    end
end)


PlayerSection:NewToggle("Thug Killaura", "Automatically attack nearby Thugs.", function(state)
    local player = game.Players.LocalPlayer
    local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

    if state then
        -- Enable Killaura
        getgenv().ThugKillaura = true
        spawn(function()
            while getgenv().ThugKillaura do
                pcall(function()
                    for _, thug in pairs(game.Workspace:GetChildren()) do
                        if thug:IsA("Model") and thug.Name == "Thug" and thug:FindFirstChild("Humanoid") and thug.Humanoid.Health > 0 then
                            -- Check distance between the player and the Thug
                            if (rootPart.Position - thug.HumanoidRootPart.Position).Magnitude <= 15 then
                                -- Attack the Thug
                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                            end
                        end
                    end
                end)
                wait(0.1) -- Check and attack every 0.1 seconds
            end
        end)
    else
        -- Disable Killaura
        getgenv().ThugKillaura = false
    end
end)

local mouse = game.Players.LocalPlayer:GetMouse()

PlayerSection:NewButton("Mouse Control", "", function()
    -- Toggle the control on and off
    if _G.CToggle == false then
        -- When Mouse Control is enabled
        spawn(function()
            getNearPlayer(99) -- Adjust range as necessary
            _G.CToggle = true
            getgenv().CarryP = true

            while getgenv().CarryP do
                -- Check every frame for movement
                wait(0.1)
                for _, v in pairs(plrlist) do
                    -- Ensure this doesn't affect the local player
                    if v ~= game.Players.LocalPlayer then
                        local targetPlayer = game.Players:FindFirstChild(v.Name)
                        if targetPlayer and targetPlayer.Character then
                            -- Move the player's HumanoidRootPart to the mouse position
                            local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.CFrame = CFrame.new(mouse.Hit.X, mouse.Hit.Y, mouse.Hit.Z)
                            end
                        end
                    end
                end
            end
        end)
    else
        -- When Mouse Control is disabled
        _G.CToggle = false
        plrlist = {}  -- Clear the player list
        getgenv().CarryP = false
    end
end)


-- Declare a variable to track the state of the tag disabler
local tagDisablerEnabled = false

-- Function to disable chat tags in real-time
local function disableTags()
    -- Access the chat service
    local ChatService = game:GetService("Chat")

    -- Listen for any chat messages and manipulate the content to remove tags
    for _, player in pairs(game.Players:GetPlayers()) do
        -- When the player chats, modify the message
        player.Chatted:Connect(function(message)
            if tagDisablerEnabled then
                -- Modify the message to remove the tag (username/group)
                message = message:gsub("%[.-%]", "")  -- Removes anything inside [brackets] (commonly used for tags)
                message = message:gsub("%b<>", "")  -- Removes anything inside angle brackets < > (another common format for tags)

                -- Send the message again without tags
                ChatService:Chat(player.Character, message)
            end
        end)
    end
end

-- Toggle to enable/disable tag disabler
PlayerSection:NewToggle("Disable Tags", "Toggle chat tags on or off", function(state)
    tagDisablerEnabled = state -- Update toggle state
    if state then
        disableTags()  -- Enable tag disabling
        print("Tag Disabler is now Enabled")
    else
        print("Tag Disabler is now Disabled")
    end
end)

-- Auto-disable tags for new players if enabled
game.Players.PlayerAdded:Connect(function(player)
    if tagDisablerEnabled then
        player.Chatted:Connect(function(message)
            if tagDisablerEnabled then
                -- Modify the message to remove the tag when new players chat
                message = message:gsub("%[.-%]", "")  -- Removes tags inside brackets
                message = message:gsub("%b<>", "")  -- Removes tags inside angle brackets

                -- Send the message again without tags
                ChatService:Chat(player.Character, message)
            end
        end)
    end
end)


-- Toggle for Shield Burst
PlayerSection:NewToggle("Shield Burst - Age Of Heroes", "Toggle Shield Burst effect", function(state)
    shieldBurstActive = state  -- Update the Shield Burst state

    -- Local variables
    local burstIntensity = 5  -- Customize the intensity of shield bursts
    local shieldWaitTime = 0.1 -- Time between each burst
    local maxBurstCount = 10  -- Maximum burst count before reset
    local pauseTime = 0.3 -- Time to wait after reaching max burst count for smoother performance

    if shieldBurstActive then
        -- Begin Shield Burst in a coroutine to prevent blocking the main thread
        coroutine.wrap(function()
            local burstCount = 0  -- Tracks number of activations

            while shieldBurstActive do
                -- Fire the shield activation event
                game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(true)

                burstCount = burstCount + 1  -- Increment the activation count

                -- If burst count reaches set intensity, reset or pause briefly
                if burstCount >= maxBurstCount then
                    burstCount = 0
                    wait(pauseTime)  -- Pause briefly after reaching max burst for smoother performance
                end

                -- Wait before firing the next burst to control the frequency
                wait(shieldWaitTime)  
            end

            -- Ensure shield is turned off when Shield Burst is deactivated
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false)
        end)()
    else
        -- Ensure shield is turned off immediately when Shield Burst toggle is deactivated
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false)
    end
end)

PlayerSection:NewToggle("Phantom Shield", "Activate ultimate protection against all grab effects!", function(state)
    -- Toggle the Anti-Grab functionality
    getgenv().AntiT = state

    -- Local references for efficiency
    local player = game.Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    
    -- Ensure the event path is correct
    local toggleTelekinesisEvent = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("ToggleTelekinesis")

    -- Directly protect the player from any grab attempt
    local function protectPlayer()
        if getgenv().AntiT and toggleTelekinesisEvent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Block any telekinesis effects in real-time
            toggleTelekinesisEvent:InvokeServer(Vector3.new(1, 1, 1), false, player.Character)
        end
    end

    -- Ultra-fast, frame-by-frame anti-grab functionality
    if state then
        -- Using RenderStepped for immediate, frame-by-frame protection (faster than Heartbeat)
        getgenv().protectionConnection = RunService.RenderStepped:Connect(protectPlayer)
    else
        -- Disconnect the protection when toggled off
        if getgenv().protectionConnection then
            getgenv().protectionConnection:Disconnect()
            getgenv().protectionConnection = nil
        end
        getgenv().AntiT = false
    end
end)

-- Local function to get the root of the player's character
local function getRoot(character)
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
end

-- Local function to trigger rapid punches
local function rapidPunch(count, delay)
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local punchEvent = replicatedStorage:FindFirstChild("Events") and replicatedStorage.Events:FindFirstChild("Punch")
    if not punchEvent then
        warn("Punch event not found!")
        return
    end

    -- Execute punches rapidly with specified delay
    for _ = 1, count do
        punchEvent:FireServer(0, 0.1, 1)  -- Modify arguments based on game mechanics
        task.wait(delay)  -- Smooth delay between each punch
    end
end

-- Function to apply the aura effect (rapid punches on nearby players)
local function applyAura(stateVariable, radius, punchCount, punchCooldown)
    while getgenv()[stateVariable] do
        local player = game.Players.LocalPlayer
        local playerCharacter = player.Character
        local playerRoot = playerCharacter and getRoot(playerCharacter)

        if playerRoot then
            -- Loop through all players in the game to find targets
            for _, targetPlayer in pairs(game.Players:GetPlayers()) do
                if targetPlayer ~= player and targetPlayer.Character then
                    local targetRoot = getRoot(targetPlayer.Character)
                    if targetRoot and (playerRoot.Position - targetRoot.Position).Magnitude <= radius then
                        -- Trigger rapid punches on nearby players
                        rapidPunch(punchCount, punchCooldown)  -- Adjust punch count and cooldown
                    end
                end
            end
        else
            warn("Player character or root part not found!")
        end

        task.wait(punchCooldown)  -- Smooth delay between aura pulses
    end
end

-- UI Toggle for "Thunderous Fist Frenzy"
PlayerSection:NewToggle("Thunderous Fist Frenzy", "Unleash rapid punches on nearby targets with lightning speed", function(state)
    getgenv().superRapidAura = state
    if state then
        -- Start the rapid punching aura with fast speed and strong effect
        spawn(function()
            -- Apply aura with specified parameters: radius 15, punch count 100, punch cooldown 0.03
            while getgenv().superRapidAura do
                applyAura("superRapidAura", 15, 100, 0.03)  -- Higher punch speed and intensity
            end
        end)
    else
        -- Disable the rapid punching aura when toggled off
        getgenv().superRapidAura = false
    end
end)
end)

GUISection:NewButton("useful tools", "", function()
local servizioTastiera = game:GetService("UserInputService");

-- age of heroes

local MainContainer = Instance.new("ScreenGui", game.CoreGui);
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local FunctionsFrame = Instance.new("ScrollingFrame")
local Layout = Instance.new("UIListLayout")
local CloseButtonMainFrame = Instance.new("TextButton")
local ReduceButtonMainFrame = Instance.new("TextButton")
local PlayerFrame = Instance.new("Frame")
local PlayerListLabel = Instance.new("TextLabel")
local ContainerFrame = Instance.new("ScrollingFrame")
local Layout_2 = Instance.new("UIListLayout")
local SelectedPlayerLabel = Instance.new("TextLabel")
local CloseButtonPlayerFrame = Instance.new("TextButton")
local DebugFrame = Instance.new("Frame")
local DebugLabel = Instance.new("TextLabel")
local StringsFrame = Instance.new("ScrollingFrame")
local Layout_3 = Instance.new("UIListLayout")
local CloseButtonDebugFrame = Instance.new("TextButton")

--[[
Genera l'interfaccia dello script
@param titoloInterfaccia as String, titolo da visualizzare sull'interfaccia
]]--
local function generaInterfaccia(titoloInterfaccia)	
	MainContainer.Name = "MainContainer"
	MainContainer.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	MainFrame.Name = "MainFrame"
	MainFrame.Parent = MainContainer
	MainFrame.Active = true
	MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	MainFrame.BackgroundTransparency = 0.200
	MainFrame.BorderColor3 = Color3.fromRGB(130, 203, 255)
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Position = UDim2.new(0.0755441561, 0, 0.176687121, 0)
	MainFrame.Selectable = true
	MainFrame.Size = UDim2.new(0, 500, 0, 300)

	TitleLabel.Name = "TitleLabel";
	TitleLabel.Parent = MainFrame
	TitleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	TitleLabel.BackgroundTransparency = 0.100
	TitleLabel.BorderSizePixel = 0
	TitleLabel.Selectable = true
	TitleLabel.Size = UDim2.new(1, 0, 0, 30)
	TitleLabel.Font = Enum.Font.Arcade
	TitleLabel.Text = titoloInterfaccia;
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.TextSize = 25.000

	FunctionsFrame.Name = "FunctionsFrame"
	FunctionsFrame.Parent = MainFrame
	FunctionsFrame.Active = true
	FunctionsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	FunctionsFrame.BackgroundTransparency = 1.000
	FunctionsFrame.Position = UDim2.new(0, 0, 0.100000001, 0)
	FunctionsFrame.Size = UDim2.new(1, 0, 0.899999976, 0)
	FunctionsFrame.ScrollBarThickness = 2

	Layout.Name = "Layout"
	Layout.Parent = FunctionsFrame

	CloseButtonMainFrame.Name = "CloseButtonMainFrame"
	CloseButtonMainFrame.Parent = TitleLabel
	CloseButtonMainFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	CloseButtonMainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
	CloseButtonMainFrame.BorderSizePixel = 0
	CloseButtonMainFrame.Position = UDim2.new(0.951333344, 0, 0.2, 0)
	CloseButtonMainFrame.Size = UDim2.new(0, 15, 0, 15)
	CloseButtonMainFrame.Font = Enum.Font.Arcade
	CloseButtonMainFrame.Text = "X"
	CloseButtonMainFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseButtonMainFrame.TextSize = 14.000

	ReduceButtonMainFrame.Name = "ReduceButtonMainFrame"
	ReduceButtonMainFrame.Parent = TitleLabel
	ReduceButtonMainFrame.BackgroundColor3 = Color3.fromRGB(255, 183, 0)
	ReduceButtonMainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
	ReduceButtonMainFrame.BorderSizePixel = 0
	ReduceButtonMainFrame.Position = UDim2.new(0.909333348, 0, 0.2, 0)
	ReduceButtonMainFrame.Size = UDim2.new(0, 15, 0, 15)
	ReduceButtonMainFrame.Font = Enum.Font.Arcade
	ReduceButtonMainFrame.Text = "-"
	ReduceButtonMainFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
	ReduceButtonMainFrame.TextSize = 14.000

	PlayerFrame.Name = "PlayerFrame"
	PlayerFrame.Parent = MainContainer
	PlayerFrame.Active = true
	PlayerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	PlayerFrame.BackgroundTransparency = 0.200
	PlayerFrame.BorderColor3 = Color3.fromRGB(130, 203, 255)
	PlayerFrame.BorderSizePixel = 0
	PlayerFrame.ClipsDescendants = true
	PlayerFrame.Position = UDim2.new(0.410371304, 0, 0.176687121, 0)
	PlayerFrame.Selectable = true
	PlayerFrame.Size = UDim2.new(0, 300, 0, 300)
	PlayerFrame.Visible = true

	PlayerListLabel.Name = "PlayerListLabel"
	PlayerListLabel.Parent = PlayerFrame
	PlayerListLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	PlayerListLabel.BackgroundTransparency = 0.100
	PlayerListLabel.BorderSizePixel = 0
	PlayerListLabel.Selectable = true
	PlayerListLabel.Size = UDim2.new(1, 0, 0.100000001, 0)
	PlayerListLabel.Font = Enum.Font.Arcade
	PlayerListLabel.Text = "Player list"
	PlayerListLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	PlayerListLabel.TextSize = 25.000

	ContainerFrame.Name = "ContainerFrame"
	ContainerFrame.Parent = PlayerFrame
	ContainerFrame.Active = true
	ContainerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ContainerFrame.BackgroundTransparency = 1.000
	ContainerFrame.BorderSizePixel = 0
	ContainerFrame.Position = UDim2.new(0.0250000004, 0, 0.100000001, 0)
	ContainerFrame.Size = UDim2.new(0.949999988, 0, 0.800000012, 0)
	ContainerFrame.ScrollBarThickness = 2

	Layout_2.Name = "Layout"
	Layout_2.Parent = ContainerFrame

	SelectedPlayerLabel.Name = "SelectedPlayerLabel"
	SelectedPlayerLabel.Parent = PlayerFrame
	SelectedPlayerLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	SelectedPlayerLabel.BackgroundTransparency = 0.100
	SelectedPlayerLabel.BorderSizePixel = 0
	SelectedPlayerLabel.Position = UDim2.new(-0, 0, 0.899999976, 0)
	SelectedPlayerLabel.Selectable = true
	SelectedPlayerLabel.Size = UDim2.new(1, 0, 0.100000001, 0)
	SelectedPlayerLabel.Font = Enum.Font.Arcade
	SelectedPlayerLabel.Text = "Selected: Player"
	SelectedPlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	SelectedPlayerLabel.TextSize = 15.000
	SelectedPlayerLabel.TextWrapped = true

	CloseButtonPlayerFrame.Name = "CloseButtonPlayerFrame"
	CloseButtonPlayerFrame.Parent = PlayerListLabel
	CloseButtonPlayerFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	CloseButtonPlayerFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
	CloseButtonPlayerFrame.BorderSizePixel = 0
	CloseButtonPlayerFrame.Position = UDim2.new(0.923333347, 0, 0.2, 0)
	CloseButtonPlayerFrame.Size = UDim2.new(0, 15, 0, 15)
	CloseButtonPlayerFrame.Font = Enum.Font.Arcade
	CloseButtonPlayerFrame.Text = "X"
	CloseButtonPlayerFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseButtonPlayerFrame.TextSize = 14.000

	DebugFrame.Name = "DebugFrame"
	DebugFrame.Parent = MainContainer
	DebugFrame.Active = true
	DebugFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	DebugFrame.BackgroundTransparency = 0.200
	DebugFrame.BorderColor3 = Color3.fromRGB(130, 203, 255)
	DebugFrame.BorderSizePixel = 0
	DebugFrame.ClipsDescendants = true
	DebugFrame.Position = UDim2.new(0.0755441561, 0, 0.576687098, 0)
	DebugFrame.Selectable = true
	DebugFrame.Size = UDim2.new(0, 500, 0, 300)
	DebugFrame.Visible = false

	DebugLabel.Name = "DebugLabel"
	DebugLabel.Parent = DebugFrame
	DebugLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	DebugLabel.BackgroundTransparency = 0.100
	DebugLabel.BorderSizePixel = 0
	DebugLabel.Selectable = true
	DebugLabel.Size = UDim2.new(1, 0, 0.100000001, 0)
	DebugLabel.Font = Enum.Font.Arcade
	DebugLabel.Text = "Debug console"
	DebugLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	DebugLabel.TextSize = 25.000

	StringsFrame.Name = "StringsFrame"
	StringsFrame.Parent = DebugFrame
	StringsFrame.Active = true
	StringsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	StringsFrame.BackgroundTransparency = 1.000
	StringsFrame.Position = UDim2.new(0, 0, 0.100000001, 0)
	StringsFrame.Size = UDim2.new(1, 0, 0.899999976, 0)
	StringsFrame.ScrollBarThickness = 2

	Layout_3.Name = "Layout"
	Layout_3.Parent = StringsFrame

	CloseButtonDebugFrame.Name = "CloseButtonDebugFrame"
	CloseButtonDebugFrame.Parent = DebugLabel
	CloseButtonDebugFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	CloseButtonDebugFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
	CloseButtonDebugFrame.BorderSizePixel = 0
	CloseButtonDebugFrame.Position = UDim2.new(0.951333344, 0, 0.2, 0)
	CloseButtonDebugFrame.Size = UDim2.new(0, 15, 0, 15)
	CloseButtonDebugFrame.Font = Enum.Font.Arcade
	CloseButtonDebugFrame.Text = "X"
	CloseButtonDebugFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseButtonDebugFrame.TextSize = 14.000
	
	--functions
	
	--Gestione del drag dei frame
	local dragFrame = nil;					--Indica il frame da spostare
	local dragControl = false;				--Indica se la funzione di spostamento ha dato esito positivo
	local mouseStartX = 0;					--Posizione di partenza del mouse X
	local mouseStartY = 0;					--Posizione di partenza del mouse Y
	local dragThread = nil;					--Thread di gestione del drag
	
	local function dragStart(i, gP)
		if not gP and i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragControl = true;
			local mouse = game.Players.LocalPlayer:GetMouse();
			mouseStartX = mouse.X;
			mouseStartY = mouse.Y;
			dragThread = coroutine.create(
				function()
					local mouse = game.Players.LocalPlayer:GetMouse();
					local camera = game.Workspace.Camera;
					while dragControl do						
						if dragFrame then
							dragFrame.Position = dragFrame.Position + UDim2.new((mouse.X - mouseStartX) / camera.ViewportSize.X, 0, (mouse.Y - mouseStartY) / camera.ViewportSize.Y, 0);
							mouseStartX = mouse.X;
							mouseStartY = mouse.Y;
						end
						
						wait();
					end
				end
			);
			coroutine.resume(dragThread);
		end
	end
	
	local function dragStop(i, gP)
		if not gP and i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragControl = false;
			dragFrame = nil;
		end
	end
	
	TitleLabel.InputBegan:Connect(
		function(i, gP)
			dragStart(i, gP);
			if dragControl then
				dragFrame = MainFrame;
			end
		end
	);
	
	TitleLabel.InputEnded:Connect(dragStop);
	
	PlayerListLabel.InputBegan:Connect(
		function(i, gP)
			dragStart(i, gP);
			if dragControl then
				dragFrame = PlayerFrame;
			end
		end
	);

	PlayerListLabel.InputEnded:Connect(dragStop);
	
	DebugLabel.InputBegan:Connect(
		function(i, gP)
			dragStart(i, gP);
			if dragControl then
				dragFrame = DebugFrame;
			end
		end
	);

	DebugLabel.InputEnded:Connect(dragStop);
	
	--Gestione della chiusura delle finestre
	CloseButtonPlayerFrame.MouseButton1Click:Connect(function() PlayerFrame.Visible = not PlayerFrame.Visible; end);
	CloseButtonDebugFrame.MouseButton1Click:Connect(function() DebugFrame.Visible = not DebugFrame.Visible; end);
	CloseButtonMainFrame.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible; end);
	ReduceButtonMainFrame.MouseButton1Click:Connect(
		function()   
			if MainFrame.Visible then
				if not MainFrame:GetAttribute("Reduced") then
					local oldSize = MainFrame.Size;
					MainFrame:SetAttribute("OldSize", oldSize);
					MainFrame:SetAttribute("Reduced", true);
					MainFrame.Size = UDim2.new(oldSize.Width, UDim.new(0, 30));
					FunctionsFrame.Visible = false;
				else
					local oldSize = MainFrame:GetAttribute("OldSize");
					MainFrame:SetAttribute("Reduced", false);
					MainFrame.Size = oldSize;
					FunctionsFrame.Visible = true;
				end
			end	
		end
	);
end

local functionCounterForOrder = 0;				--variabile usata per mantenere l'ordine nel layout  delle funzioni, NON CANCELLARE

--[[
Cambia la dimensione della canvas dello scrollFrame
@param scrollFrame as ScrollFrame: Frame da ridimensionare
]]--
local function changeScrollFrameCanvasSize(scrollFrame)	
	local children = scrollFrame:GetChildren();
	for i, v in pairs(scrollFrame:GetChildren()) do
		if v.ClassName ~= "UIListLayout" then
			local size = v.Size;
			scrollFrame.CanvasSize = UDim2.new(scrollFrame.CanvasSize.Width.Scale, 0, 0, #children * size.Height.Offset)
			break;
		end 
	end
end

--[[
Aggiunge un pulsante alla lista delle funzioni.
@param buttonName as String: nome del pulsante
@param buttonFunction as Function(button): funzione chiamata alla pressione del tasto
@param buttonText as String: Testo visualizzato sul pulsante
@param hasStatus as Boolean: Stato di attivazione del pulsante
@return as Button: Pulsante realizzato
]]--
local function addFunctionButton(buttonName, buttonFunction, buttonText, hasStatus)
	local functionEntry = Instance.new("TextButton")
  
  local realOrder = "";
  local i = 0;
  while i < functionCounterForOrder do
    realOrder = realOrder .. "a";
    i = i + 1;
  end
  
	functionEntry.Name = realOrder .. buttonName
	functionEntry.Text = buttonText
	functionEntry.Parent = FunctionsFrame
	functionEntry.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	functionEntry.BackgroundTransparency = 0.900
	functionEntry.BorderSizePixel = 0
	functionEntry.Size = UDim2.new(1, 0, 0, 30)
	functionEntry.Font = Enum.Font.Arcade
	functionEntry.TextColor3 = Color3.fromRGB(255, 255, 255)
	functionEntry.TextSize = 20.000	
	
	functionEntry:SetAttribute("BaseText", buttonText);
	
	if hasStatus then
		functionEntry:SetAttribute("HasStatus", true);
		functionEntry:SetAttribute("Status", false);
		functionEntry.Text = buttonText .. " [Disabled]";
	else
		functionEntry:SetAttribute("HasStatus", false);
	end
	
	functionEntry.MouseButton1Click:Connect(
		function()
			if functionEntry:GetAttribute("HasStatus") then
				local status = functionEntry:GetAttribute("Status");
				status = not status;
				if status then
					functionEntry.Text = functionEntry:GetAttribute("BaseText") .. " [Enabled]";
				else
					functionEntry.Text = functionEntry:GetAttribute("BaseText") .. " [Disabled]";
				end
				functionEntry:SetAttribute("Status", status);
			end
			if buttonFunction then
				buttonFunction(functionEntry);
			end
		end
	);
	
	functionCounterForOrder = functionCounterForOrder + 1;
	
	changeScrollFrameCanvasSize(FunctionsFrame);
	
	return functionEntry;
end

--[[
Aggiunge un giocatore alla lista dei giocatori
@param playerName as String: Nome del giocatore da inserire
@param targetChangeFunction as Function(playerName): Funzione chiamata alla pressione di un entry
@param additionalString as String: Informaziona aggiuntiva da inserire nell'entry
--]]
local function addPlayerEntry(playerName, targetChangeFunction, additionalString)
	local playerEntry = Instance.new("TextButton")
	
	playerEntry.Name = playerName
	playerEntry.Text = playerName .. " [" .. additionalString .. "]";
	playerEntry.Parent = ContainerFrame
	playerEntry.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	playerEntry.BackgroundTransparency = 0.900
	playerEntry.BorderColor3 = Color3.fromRGB(94, 150, 255)
	playerEntry.BorderSizePixel = 0
	playerEntry.Position = UDim2.new(0.0789473653, 0, 0.0777777806, 0)
	playerEntry.Size = UDim2.new(1, 0, 0, 20)
	playerEntry.Font = Enum.Font.Arcade
	playerEntry.TextColor3 = Color3.fromRGB(255, 255, 255)
	playerEntry.TextSize = 15.000
	playerEntry.TextXAlignment = Enum.TextXAlignment.Left
	
	playerEntry.MouseButton1Click:Connect(
		function()
			if targetChangeFunction then
				targetChangeFunction(playerEntry.Name);
			end
		end
	);
	
	changeScrollFrameCanvasSize(ContainerFrame);
end

--[[
Scrive un informazione nel debug
@param text as String: Testo da visualizzare
]]--
local function writeDebug(text)
	local debugEntry = Instance.new("TextLabel")
	
	debugEntry.Name = "DebugEntry"
	debugEntry.Text = os.date("%X", os.time()) .. "-> " .. text;
	debugEntry.Parent = StringsFrame
	debugEntry.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	debugEntry.BackgroundTransparency = 0.900
	debugEntry.BorderSizePixel = 0
	debugEntry.Size = UDim2.new(1, 0, 0, 30)
	debugEntry.Font = Enum.Font.Arcade
	debugEntry.TextColor3 = Color3.fromRGB(255, 255, 255)
	debugEntry.TextSize = 15.000
	debugEntry.TextXAlignment = Enum.TextXAlignment.Left
	
	StringsFrame.CanvasPosition = Vector2.new(0, StringsFrame.CanvasSize.Height.Offset - 30);
	
	changeScrollFrameCanvasSize(StringsFrame);
end

--Base information: don't delete here.

local mainThreadLoopFlag = true;				--Questo flag mantiene in loop i thread principali dello script, non cancellare

local targetPlayer = nil;						--Giocatore target selezionato
local function setTargetPlayer(playerName)
	targetPlayer = playerName;
	SelectedPlayerLabel.Text = "Selected: " .. playerName;
end

local playerFetchThread = coroutine.create(
	function()
	 writeDebug("PlayerFetchThread started!");
		while mainThreadLoopFlag do
			for i, v in pairs(ContainerFrame:GetChildren()) do
				if v.ClassName == "TextButton" then
					v:Destroy();
				end
			end
			for i, v in pairs(game.Players:GetChildren()) do
        pcall(
          function()
            local level = v.leaderstats.Level.Value;
            local reputation = v.leaderstats.Reputation.Value;
            
            addPlayerEntry(v.Name, setTargetPlayer, "lv: " .. level .. ", rep: " .. reputation);
          end
        );
			end
			
			wait(0.5);
		end
	end
);
coroutine.resume(playerFetchThread);

--
addFunctionButton(
	"ShowPlayerListButton", 
	function()
		if not PlayerFrame.Visible then
			PlayerFrame.Visible = true;
		end	
	end,
	"Show player window",
	false
);

addFunctionButton(
	"ShowDebugButton", 
	function()
		if not DebugFrame.Visible then
			DebugFrame.Visible = true;
		end	
	end,
	"Show debug window",
	false
);

--Servizio della tastiera
local functionTable = {};

--[[
Aggiunge una funzione da eseguire quando viene premuto un tasto
@param keyCode as Enum.KeyCode: Codice da associare alla funzione
@param keyFunction as Function(status): Funzione chiamata quando il tasto e premuto o rilasciato
]]--
local function addKeyFunction(keyCode, keyFunction)
	if keyFunction then
		functionTable[keyCode] = keyFunction;
	end
end

servizioTastiera.InputBegan:Connect(
	function (i, gP)
		if not gP then
			if functionTable[i.KeyCode] then
				functionTable[i.KeyCode](true);
			end
		end
	end
)

servizioTastiera.InputEnded:Connect(
	function (i, gP)
		if not gP then
			if functionTable[i.KeyCode] then
				functionTable[i.KeyCode](false);
			end
		end
	end
)
-------------------------

--Add your code here

--BaseData
local function segnalinoVariabili()end;       --Funzioni per l'ide in modo da trasportarmi facilmente alle variabili dello script

local teleportDistance = 8;                   --Variabile che contiene la distanza del teletrasporto
local speed = 15;                             --VelocitÃ  di volo posseduta
local utentiBloccatiTelecinesi = {};          --Contiene la lista di tutti i giocatori che sono stati bloccati dalla telecinesi

local modalitaTrasportoBloccati = 0;          --0 -> sposta solo il target, 1 -> sposta tutti i bloccati, 2 -> sposta tutti i bloccati in cerchio, 3 -> attacca al target 

local flyStatus = false;                      --Tiene traccia del fatto che sia stato attivata o meno la modalitÃ  di volo
local flyAnimator = nil;                      --Animator creato quando si avvia l'animazione del volo

local directionTable = {
  [Enum.KeyCode.W] = false,
  [Enum.KeyCode.S] = false,
  [Enum.KeyCode.A] = false,
  [Enum.KeyCode.D] = false,
  [Enum.KeyCode.Space] = false,
  [Enum.KeyCode.LeftControl] = false,
};                                            --Tabella di direzione per i movimenti aggiuntivi aggiunti dallo script
----------

--BaseFunctions

local function distruggiSessione()
  mainThreadLoopFlag = false;
  MainContainer:Destroy();
  Script:Destroy();
end
CloseButtonMainFrame.MouseButton1Click:Connect(function() distruggiSessione(); end);

--[[
Controlla se il character dell'utente passato è bloccato oppure no
@param characterUtente as Model: Modello del giocatore da controllare
@return as Boolean: Restituisce true se l'utente è bloccato, altrimenti restituisce false
]]--
local function isUtenteBloccato(characterUtente)
  local esito = false;
  
  for i, v in pairs(utentiBloccatiTelecinesi) do
    if v == characterUtente then
      esito = true;
      break;
    end
  end
  
  return esito;
end

--[[
Rimuove se possibile il character dell'utente bloccato
@param characterUtente as Model: Modello del giocatore da rimuovere
]]--
local function removeUtenteBloccato(characterUtente)
  for i, v in pairs(utentiBloccatiTelecinesi) do
    if v == characterUtente then
      table.remove(utentiBloccatiTelecinesi, i);
      break;
    end
  end
end

--[[
Esegue lo switch della camera e restituisce il risultato
@param playerName as String: Nome del giocatore su cui spostare la camera
@return as Boolean Restituisce true se lo switch ha avuto successo
]]--
local function switchCamera(playerName)
  local esito = false;
  
  local camera = game.Workspace.Camera;
  if playerName ~= nil then
    local player = game.Players:FindFirstChild(playerName);
    if player ~= nil then
      local playerCharacter = player.Character;
      if playerCharacter ~= nil and playerCharacter:FindFirstChild("Humanoid") ~= nil then
        camera.CameraSubject = playerCharacter.Humanoid;
        esito = true;
      end
    end
  end
  
  return esito;
end

--[[
Trasporta il giocatore locale dal target
@param teleportDistance as Float: Distanza di teletrasporto
]]--
local function teleport(teleportDistance)
  if targetPlayer and targetPlayer ~= "" then
    local target = game.Players:FindFirstChild(targetPlayer);
    
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
      local targetHumanoidRP = target.Character.HumanoidRootPart;
      local localCharacter = game.Players.LocalPlayer.Character;
      
      if localCharacter and localCharacter:FindFirstChild("HumanoidRootPart") then
        localCharacter.HumanoidRootPart.CFrame = targetHumanoidRP.CFrame * CFrame.new(0, 0, teleportDistance); 
      end
    
    end
  end
end

--[[
Fa tirare al personaggio un pugno
@param comboCounter as Integer: animazione di combattimento da eseguire
@return as Integer: Restituisce il nuovo valore del comboCounter
]]--
local function punch(comboCounter)
  local eventoPugno = game:GetService("ReplicatedStorage").Events.Punch;
  local ritardoPugno = { 0.1, 0.12, 0.15, 0.24, 0.18 };

  eventoPugno:FireServer(0, ritardoPugno[comboCounter], comboCounter);
  wait(ritardoPugno[comboCounter]);
  
  comboCounter = comboCounter + 1;
  if comboCounter > 5 then
    comboCounter = 1;
  end
  
  return comboCounter;
end

--[[
Scollega il corpo dalla root part del giocatore
]]--
local function removeBody()
	local character = g;
	
	if game.Players.LocalPlayer.Character then
		local lT = game.Players.LocalPlayer.Character:FindFirstChild("LowerTorso");
		
		if lT and lT:FindFirstChild("Root") then
			lT.Root:Destroy();
      writeDebug("Body removed");
		end

  end
end

--[[
Avvia l'animazione di volo e restituisce l'animation trak
@return as AnimationTrak: Restituisce l'animation trak generato, altrimenti nil in caso di problemi
]]--
local function startFlyAnimation()
  local esito = nil;
  
  local animation = game:GetService("ReplicatedStorage").Animations.flyLoop;
  local character = game.Players.LocalPlayer.Character;
  
  if character and character:FindFirstChild("Humanoid") then
    local animator = character.Humanoid.Animator;
    local animationTrak = animator:LoadAnimation(animation);
    
    if animationTrak then
      animationTrak.Looped = false;
      animationTrak:Play(0.1, 1, 0);
      esito = animationTrak;
    end
    
  end
  
  return esito;
end

--[[
Fa crashare completamente il server
]]--
local function crashServerFunction()
  game:GetService("ReplicatedStorage").Effects.Shield.Name = "Shields";
  local evento = game:GetService("ReplicatedStorage").Events.ToggleBlocking;
  
  writeDebug("Server will crash in 5 seconds");
  wait(1);
  writeDebug("4 seconds")
  wait(1);
  writeDebug("3 seconds")
  wait(1);
  writeDebug("2 seconds")
  wait(1);
  writeDebug("1 second")
  wait(1);
  writeDebug("0 seconds")
  
  local i = 0; 
  while i < 20000 do
    evento:FireServer(true);
    i = i + 1;
  end

  evento:FireServer(false);
  writeDebug("Done!");

end

--[[
Funzione da avviare come thread per implementare la funzionalita di volo
]]--
local function funzioneThreadVolo()
    writeDebug("FlyThread started");
    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart;
    local humanoid = game.Players.LocalPlayer.Character.Humanoid;
    while flyStatus do
      if not hrp:FindFirstChild("bp") then
        --Inserisce le componenti di volo
        local bp = Instance.new("BodyPosition", hrp);
        bp.Name = "bp";
        bp.MaxForce = Vector3.new(1000000, 1000000, 1000000);
        bp.Position = hrp.Position;
        bp.P = 1000000;
      end
      
      if not hrp:FindFirstChild("br") then
        --Inserisce le componenti di volo
        local br = Instance.new("BodyGyro", hrp);
        br.Name = "br";
        br.D = 100;
        br.P = 1000;
        br.MaxTorque = Vector3.new(1000000, 1000000, 1000000);
      end
      
      local bp = hrp.bp;
      local br = hrp.br;
      local cameraCFrame = game.Workspace.Camera.CFrame;
      
      --Orienta il giocatore
      humanoid.PlatformStand = true;
      br.CFrame = cameraCFrame;
      
      --Controlla lo stato dei comandi
      if directionTable[Enum.KeyCode.W] then
        bp.Position = bp.Position + cameraCFrame.LookVector * speed;
      end
      if directionTable[Enum.KeyCode.S] then
        bp.Position = bp.Position - cameraCFrame.LookVector * speed;
      end
      if directionTable[Enum.KeyCode.D] then
        bp.Position = bp.Position + cameraCFrame.RightVector * speed;
      end
      if directionTable[Enum.KeyCode.A] then
        bp.Position = bp.Position - cameraCFrame.RightVector * speed;
      end
      if directionTable[Enum.KeyCode.Space] then
        bp.Position = bp.Position + cameraCFrame.UpVector * speed;
      end
      if directionTable[Enum.KeyCode.LeftControl] then
        bp.Position = bp.Position - cameraCFrame.UpVector * speed;
      end
        
      wait();
    end
    
    writeDebug("FlyThread stopped");
    hrp = game.Players.LocalPlayer.Character.HumanoidRootPart;
    humanoid = game.Players.LocalPlayer.Character.Humanoid;
    --Elimina le caratteristiche del giocatore per il volo
    humanoid.PlatformStand = false;
    if hrp:FindFirstChild("bp") then
      hrp.bp:Destroy();
    end
    if hrp:FindFirstChild("br") then
      hrp.br:Destroy();
    end
    if flyAnimator then
      flyAnimator:Stop();
      flyAnimator = nil;
      writeDebug("FlyThread: animation stopped");
    end
end

--[[
Restituisce i giocatori vicini al player
@param maxDistance as Float: Distanza massima da accettare
@return as table: Lista dei nomi dei giocatori vicini
]]--
local function getNearPlayer(maxDistance)
  local esito = {};
  
  local player = game.Players.LocalPlayer;
  if player and player.Character then
    local playerLocation = player.Character.HumanoidRootPart.Position;
    for i, v in pairs(game.Players:GetChildren()) do
      if v.Character then
        local location = v.Character.HumanoidRootPart.Position;
        if (location - playerLocation).Magnitude <= maxDistance then
          table.insert(esito, v.Character);
        end
      end
    end
  end
  
  return esito;
end

--[[
Catturiamo un giocaotre usando un lookVector
@return as Model: Restituisce il character del giocatore catturato
]]--
local function catturaTelecinesi(lookVector)
  local esito = nil;
  
  local evento = game:GetService("ReplicatedStorage").Events.ToggleTelekinesis;
  local parteTelecinesi = evento:InvokeServer(lookVector, true);
  if parteTelecinesi then
    if game.Players:FindFirstChild(parteTelecinesi.Name) then
      if not isUtenteBloccato(parteTelecinesi) then
        table.insert(utentiBloccatiTelecinesi, parteTelecinesi);
        evento:InvokeServer(lookVector, false, nil);
        esito = parteTelecinesi;
        writeDebug("Captured " .. esito.Name);
      end
    else
      evento:InvokeServer(lookVector, false, parteTelecinesi);
    end
  end

  return esito;
end

--[[
Esegue un rilascio del character indicato
]]--
local function rilascioTelecinesi(character)
  local evento = game:GetService("ReplicatedStorage").Events.ToggleTelekinesis;
  evento:InvokeServer(game.Workspace.Camera.CFrame.LookVector, false, character);
  if isUtenteBloccato(character) then
    removeUtenteBloccato(character);
  end
  writeDebug("Released " .. character.Name);
end

--[[
Sposta il giocatore selezionato con la telecinesi
@param position as Vector3: Posizione di destinazione del giocatore
@param playerName as String: Nome del giocatore da spostare
]]--
local function movePlayerWithTelekinesis(position, playerName)
  if position and playerName then
    --Qua potrebbero verificarsi eccezzioni quando si muove il giocatore e questo muore
    pcall(
      function()
        local player = game.Players:FindFirstChild(playerName);
        if player and player.Character and isUtenteBloccato(player.Character) then
          player.Character.HumanoidRootPart.telekinesisPosition.Position = position;
        end
      end
    )
  end
end

--[[
Esegue il comando di telecinesi sul singolo giocatore inquadrato dalla telecamera
@param cattura as Boolean: Se impostato su true la funzione tenta di catturare l'utente, altrimenti rilascia il giocaotore segnalato dal nome
@param playerNameToRelease: Nome del giocatore da rilasciare se bloccato
]]--
local function telecinesiSingola(cattura, playerNameToRelease)
  if cattura then
    local character = catturaTelecinesi(game.Workspace.Camera.CFrame.LookVector);
    if character and modalitaTrasportoBloccati ~= 3 then
      SelectedPlayerLabel.Text = "Selected: " .. character.Name;
      targetPlayer = character.Name
    end
  else
    if playerNameToRelease and game.Players:FindFirstChild(playerNameToRelease) then
      local player = game.Players:FindFirstChild(playerNameToRelease);
      if player.Character then
        rilascioTelecinesi(player.Character);
      end
    end
  end
end

--[[
Esegue un meccanismo di telecinesi multipla catturando i giocatori vicini
]]--
local function telecinesiMultipla()
  local giocatoriVicini = getNearPlayer(30);
  local characterPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position;
  for i, v in pairs(giocatoriVicini) do
    local hrp = v.HumanoidRootPart;
    local cLookFrame = CFrame.new(characterPosition , hrp.CFrame.Position);
    catturaTelecinesi(cLookFrame.LookVector);
  end
end

--[[
Rilascia tutti i giocatori bloccati dalla telecinesi
]]--
local function rilascioTotale()
  local modelli = {};
  for i, v in pairs(utentiBloccatiTelecinesi) do
    table.insert(modelli, v);
  end
  
  for i, v in pairs(modelli) do
    rilascioTelecinesi(v);
  end
  utentiBloccatiTelecinesi = {};
  
  writeDebug("Each locked player released");
end

--[[
Uccide tutti i giocatori bloccati dalla telecinesi
]]--
local function killAll()
  for i, v in pairs(utentiBloccatiTelecinesi) do
    pcall(
      function() 
        if game.Players:FindFirstChild(v.Name) then
          v.Head.Neck:Destroy(); 
        end
      end
    );
    wait(0.1);
  end
  
  writeDebug("Each locked player killed");
  rilascioTotale();
end

--[[
Da i super poteri a tutti gli utenti bloccati
]]--
local function giveSuperPower()
  writeDebug("Super powered list:");
  for i, v in pairs(utentiBloccatiTelecinesi) do
    writeDebug(v.Name);
    pcall(
      function()
        writeDebug("start");
        v.Humanoid.JumpPower = 250;
        v.Humanoid.WalkSpeed = 200;
        v.Humanoid.PlatformStand = false;
        v.HumanoidRootPart.telekinesisPosition:Destroy();
        v.HumanoidRootPart.telekinesisGyro:Destroy();
        writeDebug(v.Name .. " has superpowers");
      end
    );
  end
  writeDebug("-----------------------");
end

addFunctionButton(
  "ControllTarget",
  function(button)
    if button:GetAttribute("HasStatus") then
      if button:GetAttribute("Status") then
        
        coroutine.resume(coroutine.create(
          function()
            writeDebug("ControlTarget started");
            while button:GetAttribute("Status") do
              pcall(
                function()
                  local characterModel = game.Players:FindFirstChild(targetPlayer).Character;
                  if characterModel.HumanoidRootPart:FindFirstChild("telekinesisPosition") then
                    characterModel.Humanoid.JumpPower = 200;
                    characterModel.Humanoid.WalkSpeed = 200;
                    characterModel.Humanoid.PlatformStand = false;
                    characterModel.HumanoidRootPart.telekinesisPosition:Destroy();
                    characterModel.HumanoidRootPart.telekinesisGyro:Destroy();
                  end
                  
                  switchCamera(targetPlayer);
                  
                  local yDir = 0;
                  local xDir = 0;
                  if directionTable[Enum.KeyCode.W] then
                    yDir = yDir - 1;
                  end
                  
                  if directionTable[Enum.KeyCode.S] then
                    yDir = yDir + 1;
                  end
                  
                  if directionTable[Enum.KeyCode.A] then
                    xDir = xDir - 1;
                  end
                  
                  if directionTable[Enum.KeyCode.D] then
                    xDir = xDir + 1;
                  end
                  
                  if directionTable[Enum.KeyCode.Space] then
                    characterModel.Humanoid.Jump = true;
                  else
                    characterModel.Humanoid.Jump = false;
                  end
                  
                  game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true;
                  characterModel.Humanoid:Move(Vector3.new(xDir, 0, yDir), true);
                end
              );
              
              wait();
            end
            switchCamera(game.Players.LocalPlayer.Name);
            game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false;
            writeDebug("ControlTarget stopped");
          end
        ));
        
      end
    end
  end,
  "Control the target",
  true
)

addFunctionButton(
  "TPTargetOrbs",
  function(button)
    if button:GetAttribute("HasStatus") then
      if button:GetAttribute("Status") then
        
        coroutine.resume(coroutine.create(
          function()
            writeDebug("Exp orbs cycle started");
            while button:GetAttribute("Status") do
              pcall(
                function()
                  local characterModel = game.Players:FindFirstChild(targetPlayer).Character;
                  local characterHRP = characterModel.HumanoidRootPart;
                  local characterTelekinesis = characterHRP.telekinesisPosition;
                  
                  for i, v in pairs(game:GetService("Workspace").ExperienceOrbs:GetChildren()) do
                    characterTelekinesis.Position = v.CFrame.Position;
                    characterHRP.CFrame = v.CFrame;
                    
                    wait(0.1);
                  end
                end
              );
              
              wait();
            end
            writeDebug("Exp orbs cycle stopped");
          end
        ));
        
      end
    end
  end,
  "TP target to orbs",
  true
)

addFunctionButton(
  "TPTargetOrbs2",
  function(button)
    if button:GetAttribute("HasStatus") then
      if button:GetAttribute("Status") then
        
        coroutine.resume(coroutine.create(
          function()
            writeDebug("Exp orbs cycle 2 started");
            while button:GetAttribute("Status") do
              pcall(
                function()
                  local character = game.Players:FindFirstChild(targetPlayer).Character;
                  for i, v in pairs(game:GetService("Workspace").ExperienceOrbs:GetChildren()) do
                      local hrp = character.HumanoidRootPart;
                      v.CFrame = hrp.CFrame;
                  end
                end
              );
              
              wait();
            end
            writeDebug("Exp orbs cycle 2 stopped");
          end
        ));
        
      end
    end
  end,
  "TP orbs to target",
  true
)

addFunctionButton(
  "TPTargetOrbs3",
  function(button)
    if button:GetAttribute("HasStatus") then
      if button:GetAttribute("Status") then
        
        coroutine.resume(coroutine.create(
          function()
            writeDebug("Exp orbs cycle 3 started");
            while button:GetAttribute("Status") do
              pcall(
                function()
                  local character = game.Players:FindFirstChild(targetPlayer).Character;
                  local orb = game:GetService("Workspace").ExperienceOrbs:FindFirstChild("experienceOrb");
                  local hrp = character.HumanoidRootPart;
                  orb.CFrame = hrp.CFrame;
                end
              );
              
              wait(0.2);
            end
            writeDebug("Exp orbs cycle 3 stopped");
          end
        ));
        
      end
    end
  end,
  "TP orbs to target with refield",
  true
)

addFunctionButton(
  "TPBlockedOrbs",
  function(button)
    if button:GetAttribute("HasStatus") then
      if button:GetAttribute("Status") then
        
        coroutine.resume(coroutine.create(
          function()
            writeDebug("Exp orbs cycle 4 started");
            while button:GetAttribute("Status") do
              pcall(
                function()
                  for i, v in pairs(utentiBloccatiTelecinesi) do
                    local character = v;
                    local orb = game:GetService("Workspace").ExperienceOrbs:FindFirstChild("experienceOrb");
                    local hrp = character.HumanoidRootPart;
                    orb.CFrame = hrp.CFrame;
                    wait(0.2);
                  end
                end
              );
              
              wait();
            end
            writeDebug("Exp orbs cycle 4 stopped");
          end
        ));
        
      end
    end
  end,
  "TP orbs to blocked players",
  true
)

----------------

addFunctionButton(
  "HideTitle",
  function (button)
    if button:GetAttribute("HasStatus") then
      if button:GetAttribute("Status") then
        
        coroutine.resume(coroutine.create(
          function()
            writeDebug("HideTitleThread started");
            while button:GetAttribute("Status") do
              if game.Players.LocalPlayer.Character then
                local rP = game.Players.LocalPlayer.Character.HumanoidRootPart;
                if rP and rP:FindFirstChild("titleGui") then
                  rP.titleGui:Destroy();
                end
              end
              wait();
            end
            writeDebug("HideTitleThread stopped");
          end
        ));
        
      end
    end
  end,
  "Hide title",
  true
);

addFunctionButton(
  "ChangeTelekinesisCarry",
  function(button)
    modalitaTrasportoBloccati = modalitaTrasportoBloccati + 1;
    if modalitaTrasportoBloccati > 3 then
      modalitaTrasportoBloccati = 0;
    end
    local messaggio = "";
    if modalitaTrasportoBloccati == 0 then
      messaggio = "move target";
    elseif modalitaTrasportoBloccati == 1 then
      messaggio = "move each locked";
    elseif modalitaTrasportoBloccati == 2 then
      messaggio = "move each around";
    else
      messaggio = "attach to target";
    end
    button.Text = button:GetAttribute("BaseText") .. " [" .. messaggio .. "]";
  end,
  "Telekinesis carry mode",
  false
);

addFunctionButton(
  "SpyTarget",
  function (button)
    if button:GetAttribute("HasStatus") then
      if button:GetAttribute("Status") then
        switchCamera(targetPlayer);
      else
        switchCamera(game.Players.LocalPlayer.Name);
      end
    end
  end,
  "Spy target",
  true
);

addFunctionButton(
  "InfiniteEnergy",
  function(button)
    if button:GetAttribute("HasStatus") then
      if button:GetAttribute("Status") then
        coroutine.resume(coroutine.create(function()
          writeDebug("InfEnergyThread started")
          
          -- Infinite energy loop
          while button:GetAttribute("Status") do
            getrenv()._G.energy = math.huge  -- Set energy to infinity
            button.Text = button:GetAttribute("BaseText") .. " [∞]"
            wait(0.1)  -- Wait a short period before looping again
          end
          
          writeDebug("InfEnergyThread stopped")
        end))
      end
    end
  end,
  "Enable infinite energy",
  true
);

addFunctionButton(
  "SafeFromTelekinesis",
  function(button)
    if button:GetAttribute("HasStatus") then
      if button:GetAttribute("Status") then
        coroutine.resume(coroutine.create(
          function()
            while(true) do
              local evento = game:GetService("ReplicatedStorage").Events.ToggleTelekinesis;
              if game.Players.LocalPlayer.Character then
                evento:InvokeServer(game.Workspace.Camera.CFrame.LookVector, false, game.Players.LocalPlayer.Character); 
              end
              wait();
            end
          end
        ));
      end
    end
  end,
  "Safe from telekinesis",
  true
);

addFunctionButton(
  "StartFly",
  function(button)
    --flyAnimator = startFlyAnimation();
    if button:GetAttribute("HasStatus") then
      flyStatus = button:GetAttribute("Status");
      if flyStatus then
        coroutine.resume(coroutine.create(funzioneThreadVolo));
      end
    end
  end,
  "Start fly",
  true
);

addFunctionButton(
  "IncrementDistance",
  function (button)
    teleportDistance = teleportDistance + 1;
    button.Text = button:GetAttribute("BaseText") .. " [" .. teleportDistance .. "]";
  end,
  "Increment teleport distance",
  false
);

addFunctionButton(
  "DecrementDistance",
  function (button)
    teleportDistance = teleportDistance - 1;
    if teleportDistance < 0 then
      teleportDistance = 0;
    end
    button.Text = button:GetAttribute("BaseText") .. " [" .. teleportDistance .. "]";
  end,
  "Decrement teleport distance",
  false
);

addFunctionButton(
  "Teleport",
  function (button)
      teleport(teleportDistance);
  end,
  "Teleport",
  false
);

addFunctionButton(
  "GiveSuperPower",
  giveSuperPower,
  "Give superpower",
  false
);

addFunctionButton(
  "IncrementSpeed",
  function (button)
    speed = speed + 1;
    button.Text = button:GetAttribute("BaseText") .. " [" .. speed .. "]";
  end,
  "Increment fly speed",
  false
);

addFunctionButton(
  "DecrementSpeed",
  function (button)
    speed = speed - 1;
    if speed < 0 then
      speed = 0;
    end
    button.Text = button:GetAttribute("BaseText") .. " [" .. speed .. "]";
  end,
  "Decrement fly speed",
  false
);

addFunctionButton(
  "FireEyes",
  function (button)
    if button:GetAttribute("HasStatus") then
      if button:GetAttribute("Status") then
        
        coroutine.resume(coroutine.create(
          function()
            writeDebug("FireEyesThread started");
            local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision;
            local part = event:InvokeServer(true);
            while button:GetAttribute("Status") and part and targetPlayer do
              local target = game.Players:FindFirstChild(targetPlayer);
              if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                part.Position = target.Character.HumanoidRootPart.Position;
              end
              wait();
            end
            event:InvokeServer(false);
            writeDebug("FireEyesThread ended");
          end
        ));
        
      end
    end
  end,
  "Fire eyes target",
  true
);

addFunctionButton(
  "FireEyesLocked",
  function (button)
    if button:GetAttribute("HasStatus") then
      if button:GetAttribute("Status") then
        
        coroutine.resume(coroutine.create(
          function()
            writeDebug("FireEyesLockedThread started");
            local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision;
            local part = event:InvokeServer(true);
            while button:GetAttribute("Status") and part do
              for i, v in pairs(utentiBloccatiTelecinesi) do
                part.Position = v.Character.HumanoidRootPart.Position;
                wait(0.1);
              end
              wait();
            end
            event:InvokeServer(false);
            writeDebug("FireEyesLockedThread ended");
          end
        ));
        
      end
    end
  end,
  "Fire locked players",
  true
);

addFunctionButton(
  "RemoveBody",
  function (button)
    removeBody();
  end,
  "Remove body [irreversible]",
  false
);


addFunctionButton(
  "SplitBody",
  function (button)
    pcall(
      function()
        game:GetService("Players").LocalPlayer.Character.UpperTorso.Waist:Destroy();
      end
    );
  end,
  "Split body [irreversible]",
  false
);

addFunctionButton(
  "DisableTelekinesis",
  function (button)
    if button:GetAttribute("HasStatus") then
      if button:GetAttribute("Status") then
        coroutine.resume(coroutine.create(
          function()
            writeDebug("DisableTelekinesisThread started");
            while button:GetAttribute("Status") do
              local evento = game:GetService("ReplicatedStorage").Events.ToggleTelekinesis;
              
              for i, v in pairs(game.Players:GetChildren()) do
                if v.Character and not isUtenteBloccato(v.Character) then
                  coroutine.resume(coroutine.create(
                    function() 
                      evento:InvokeServer(game.Workspace.Camera.CFrame.LookVector, false, v.Character); 
                    end
                  ));
                end
              end
              
              wait(0.1);
            end
            writeDebug("DisableTelekinesisThread stopped");
          end
        ));
      end
    end
  end,
  "Disable telekinesis",
  true
);

addFunctionButton(
  "CrashServer",
  function (button)
    if not DebugFrame.Visible then
      DebugFrame.Visible = true;
    end
    crashServerFunction();
  end,
  "Crash server, [Open the debug window]",
  false
);

--KeyFunctions

local function keyFunctionSegnalino()end;

addKeyFunction(
  Enum.KeyCode.K,
  function(status)
    if not status then
      teleport(teleportDistance);
    end
  end
);

addKeyFunction(
  Enum.KeyCode.P, 
  function(status)
    if not status then
      telecinesiSingola(true);
    end
  end
);

addKeyFunction(
  Enum.KeyCode.U, 
  function(status)
    if not status then
      telecinesiMultipla();
    end
  end
);

addKeyFunction(
  Enum.KeyCode.L, 
  function(status)
    if not status then
      telecinesiSingola(false, targetPlayer);
    end
  end
);

addKeyFunction(
  Enum.KeyCode.J, 
  function(status)
    if not status then
      rilascioTotale();
    end
  end
);

addKeyFunction(
  Enum.KeyCode.H, 
  function(status)
    if not status then
      killAll();
    end
  end
);

--Controllo pressione tasti
local function controlloPressioneTastiSegnalino()end;
  
addKeyFunction(
  Enum.KeyCode.W,
  function(status)
    directionTable[Enum.KeyCode.W] = status;
  end
);

addKeyFunction(
  Enum.KeyCode.S,
  function(status)
    directionTable[Enum.KeyCode.S] = status;
  end
);

addKeyFunction(
  Enum.KeyCode.A,
  function(status)
    directionTable[Enum.KeyCode.A] = status;
  end
);

addKeyFunction(
  Enum.KeyCode.D,
  function(status)
    directionTable[Enum.KeyCode.D] = status;
  end
);

addKeyFunction(
  Enum.KeyCode.Space,
  function(status)
    directionTable[Enum.KeyCode.Space] = status;
  end
);

addKeyFunction(
  Enum.KeyCode.LeftControl,
  function(status)
    directionTable[Enum.KeyCode.LeftControl] = status;
  end
);

--Routine di script
local function routineScriptSegnalino()end;

local threadControllo = coroutine.create(
  function()
    writeDebug("ControlThread started");
    while mainThreadLoopFlag do
      if not MainFrame.Visible then
        MainFrame.Visible = true;
      end
      wait(0.2);
    end
  end
);
coroutine.resume(threadControllo);

local threadTelekinesis = coroutine.create(
  function()
    writeDebug("TelekinesisThread started");
    local angoloRotazione = 90;          --Angolo di rotazione per posizionare i giocatori
    while mainThreadLoopFlag do
      --Per ora il pcall ci toglie molti problemi, ma in futuro rivedrÃ² la parte di controllo della telecinesi
      pcall(
        function()
          local localCharacter = game.Players.LocalPlayer.Character;
      
          if localCharacter then
            if modalitaTrasportoBloccati == 0 then
              movePlayerWithTelekinesis((localCharacter.HumanoidRootPart.CFrame * CFrame.new(0, 0, -teleportDistance)).Position, targetPlayer);
            end
            if modalitaTrasportoBloccati == 1 then
              angoloRotazione = 90;
              for i, v in pairs(utentiBloccatiTelecinesi) do
                local angle = angoloRotazione + (i * 10);
                local c = math.cos(angle);
                local s = math.sin(angle);
                local position = (localCharacter.HumanoidRootPart.CFrame * CFrame.new(teleportDistance * c, 0, teleportDistance * s)).Position;
                movePlayerWithTelekinesis(position, v.Name);
              end
            end
            if modalitaTrasportoBloccati == 2 then
              angoloRotazione = angoloRotazione + 0.05;
              for i, v in pairs(utentiBloccatiTelecinesi) do
                local angle = angoloRotazione + (i * 10);
                local c = math.cos(angle);
                local s = math.sin(angle);
                local position = (localCharacter.HumanoidRootPart.CFrame * CFrame.new(teleportDistance * c, 6, teleportDistance * s)).Position;
                movePlayerWithTelekinesis(position, v.Name);
              end
            end
            if modalitaTrasportoBloccati == 3 and targetPlayer and game.Players:FindFirstChild(targetPlayer) then
              local player = game.Players:FindFirstChild(targetPlayer);
              if player.Character and not isUtenteBloccato(player.Character) then
                angoloRotazione = angoloRotazione + 0.05;
                for i, v in pairs(utentiBloccatiTelecinesi) do
                  local angle = angoloRotazione + (i * 10);
                  local c = math.cos(angle);
                  local s = math.sin(angle);
                  local position = (player.Character.HumanoidRootPart.CFrame * CFrame.new(teleportDistance * c, 6, teleportDistance * s)).Position;
                  movePlayerWithTelekinesis(position, v.Name);
                end
              end
            end
          end
        end
      )
      
      wait();
    end
  end
);
coroutine.resume(threadTelekinesis);
--------------------


generaInterfaccia("age of heroes");
end);

GUISection:NewButton("Dex Explorer", "", function()
    loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()
end)




GUISection:NewButton("Auto Clicker UI", "", function()
    local library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ShaddowScripts/Main/main/Library"))()
local Main = library:CreateWindow("AutoClickers", "Deep Sea")

-- Create separate tabs for different key groups
local tabLetters = Main:CreateTab("Letters")
local tabNumbers = Main:CreateTab("Numbers")
local tabFunctions = Main:CreateTab("Functions")
local tabSpecials = Main:CreateTab("Special Keys")
local tabSettings = Main:CreateTab("Settings")

-- Group keys
local letterKeys = {
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
}
local numberKeys = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
local functionKeys = {"F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12"}
local specialKeys = {
    "Tab", "CapsLock", "Shift", "Ctrl", "Alt", "Escape", "Enter", "Space",
    "Backspace", "Delete", "Insert", "Home", "End", "PageUp", "PageDown",
    "Left", "Right", "Up", "Down",
    "-", "=", "[", "]", "\\", ";", "'", ",", ".", "/", "`"
}

-- Default settings
getgenv().ClickSpeed = 0.001 -- Default click speed in seconds
getgenv().WalkSpeed = 16 -- Default walk speed (normal Roblox speed)
getgenv().JumpPower = 50 -- Default jump height

-- Function to create an auto-clicker toggle for a specific key
local function createAutoClickToggle(tab, key)
    tab:CreateToggle("Auto '" .. key .. "'", function(state)
        getgenv()["auto" .. key] = state -- Dynamically set a global variable for each key's state

        if state then
            -- Start Auto Clicking
            task.spawn(function()
                local vim = game:GetService("VirtualInputManager")
                while getgenv()["auto" .. key] do
                    -- Simulate pressing and releasing the key
                    vim:SendKeyEvent(true, key, false, nil)  -- Press key
                    task.wait(getgenv().ClickSpeed)          -- User-defined click speed
                    vim:SendKeyEvent(false, key, false, nil) -- Release key
                    task.wait(getgenv().ClickSpeed)          -- Interval before the next key press
                end
            end)
        else
            -- Stop Auto Clicking when toggle is off
            getgenv()["autoClick" .. key] = false
        end
    end)
end

-- Create toggles for each group of keys
for _, key in ipairs(letterKeys) do
    createAutoClickToggle(tabLetters, key)
end
for _, key in ipairs(numberKeys) do
    createAutoClickToggle(tabNumbers, key)
end
for _, key in ipairs(functionKeys) do
    createAutoClickToggle(tabFunctions, key)
end
for _, key in ipairs(specialKeys) do
    createAutoClickToggle(tabSpecials, key)
end

-- Function to apply walk speed and jump power to the player's character
local function applyPlayerSettings()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = getgenv().WalkSpeed
        player.Character.Humanoid.JumpPower = getgenv().JumpPower
    end
end

-- Monitor for character changes (respawning, resetting)
local function monitorPlayerCharacter()
    local player = game.Players.LocalPlayer
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid") -- Ensure the Humanoid is present
        applyPlayerSettings() -- Reapply the settings when the character is added
    end)
end

-- Settings Tab for Click Speed, Walk Speed, and Jump Height
tabSettings:CreateSlider("Click Speed", 1, 500, getgenv().ClickSpeed * 1000, function(value)
    getgenv().ClickSpeed = value / 1000 -- Convert ms to seconds
end)

tabSettings:CreateSlider("Player Speed", 16, 100, getgenv().WalkSpeed, function(value)
    getgenv().WalkSpeed = value
    applyPlayerSettings() -- Apply settings dynamically
end)

tabSettings:CreateSlider("Jump Height", 50, 300, getgenv().JumpPower, function(value)
    getgenv().JumpPower = value
    applyPlayerSettings() -- Apply settings dynamically
end)

tabSettings:CreateLabel("Adjust your gameplay settings below:")
tabSettings:CreateLabel("Lower click speed = faster clicking.")
tabSettings:CreateLabel("Increase walk speed and jump height for faster movement.")

-- Initialize the script
applyPlayerSettings() -- Apply the settings initially
monitorPlayerCharacter() -- Start monitoring for character changes
end)



GUISection:NewButton("OP UI","", function(state)
    --[[ 
      ███████╗ ███████╗███╗   ██╗████████╗██╗███╗   ██╗███████╗██╗     
      ██╔════╝ ██╔════╝████╗  ██║╚══██╔══╝██║████╗  ██║██╔════╝██║     
      ███████╗ █████╗  ██╔██╗ ██║   ██║   ██║██╔██╗ ██║█████╗  ██║     
      ╚════██║ ██╔══╝  ██║╚██╗██║   ██║   ██║██║╚██╗██║██╔══╝  ██║     
      ███████║ ███████╗██║ ╚████║   ██║   ██║██║ ╚████║███████╗███████╗
      ╚══════╝ ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝
    
              💻 SYSTEM CORE INITIALIZED 💻         
       🔓 Advanced Level 10 Scripts for Elite Users 🔓 
    
    ]]
    
    -- 2025: Enhanced SendCustomNotification function
    local function SendCustomNotification(title, message, duration)
        -- Default values for customization
        title = title or "Level 10 Script"
        message = message or "This is a custom message for the game!"
        duration = duration or 5  -- Default duration set to 5 seconds
    
        -- Sending a notification to the player's screen
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = message,
            Duration = duration,
        })
    
        -- Debug message to console (optional)
        print(string.format("[Notification] %s: %s", title, message))
    end
    
    local library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ShaddowScripts/Main/main/Library"))()
    
    local Main = library:CreateWindow("🔐>ReconX<🔐 The Power Of Real Hackers","Deep Sea")
    
    local tab1 = Main:CreateTab("Main")
    local tab2 = Main:CreateTab("Auto Farm")
    local tab7 = Main:CreateTab("PowerTools")
    local tab4 = Main:CreateTab("Self Menu")
    local tab5 = Main:CreateTab("Target")
    local tab6 = Main:CreateTab("AutoStats")
    local tab8 = Main:CreateTab("Crashers")
    local tab3 = Main:CreateTab("Chat Spoofers")
    local tab9 = Main:CreateTab("Misc")
    
    
    tab7:CreateToggle("NPC ESP", function(a)
        -- Store the toggle state
        _G.NPCESP = a  -- a is the state passed into the toggle function
    
        -- Function to apply ESP to NPCs
        local function applyNPCESP(npc)
            local npcModels = {"Police", "Thug", "Citizen"}
            for _, npcModel in pairs(npcModels) do
                if npc.Name == npcModel then
                    -- Create ESP box or highlight with pink color
                    local box = Instance.new("Highlight", npc)
                    box.FillColor = Color3.fromRGB(255, 105, 180)  -- Pink box for NPCs
                end
            end
        end
    
        -- Monitoring new NPCs that are added to the workspace (e.g., respawned NPCs)
        if _G.NPCESP then
            -- Apply ESP to already existing NPCs
            for _, npc in pairs(workspace:GetChildren()) do
                if npc:IsA("Model") then  -- Ensure it's a model
                    applyNPCESP(npc)
                end
            end
    
            -- Monitor for new NPCs added to the workspace
            if not _G.npcAddedConnection then
                _G.npcAddedConnection = workspace.ChildAdded:Connect(function(child)
                    if child:IsA("Model") then
                        applyNPCESP(child)  -- Apply ESP to the newly added NPC
                    end
                end)
            end
        else
            -- Remove ESP from existing NPCs
            for _, npc in pairs(workspace:GetChildren()) do
                if npc:FindFirstChildOfClass("Highlight") then
                    npc:FindFirstChildOfClass("Highlight"):Destroy()  -- Destroy the Highlight
                end
            end
    
            -- Stop monitoring new NPCs by disconnecting the event
            if _G.npcAddedConnection then
                _G.npcAddedConnection:Disconnect()  -- Properly disconnect the ChildAdded event
                _G.npcAddedConnection = nil  -- Clear the reference
            end
        end
    end)
    tab4:CreateButton("Collect Orbs", function()
        spawn(function()
            pcall(function()
                local localPlayer = game.Players.LocalPlayer  -- Reference the local player
                if localPlayer and localPlayer.Character then
                    local torso = localPlayer.Character:FindFirstChild("UpperTorso") or localPlayer.Character:FindFirstChild("HumanoidRootPart")  -- Get the Torso or HumanoidRootPart
                    if torso then
                        local targetPosition = torso.Position  -- Store player's torso position
                        local orbs = game:GetService("Workspace").ExperienceOrbs:GetChildren()  -- Get all orbs
    
                        -- Loop through all orbs and move them to the player's torso position
                        for _, orb in ipairs(orbs) do
                            if orb:IsA("Part") and orb.Parent then
                                -- Move orb directly to the player's torso position
                                orb.CFrame = CFrame.new(targetPosition) * CFrame.new(0, 5, 0)  -- Hover above player
                            end
                        end
                    end
                end
            end)
        end)
    end)
    
    tab4:CreateToggle("Auto Orbs", function(state)
        spawn(function()
            getgenv().ORBGIVE = state  -- Update the global variable to track the toggle state
            local localPlayer = game.Players.LocalPlayer  -- Reference the local player
            
            while getgenv().ORBGIVE do
                pcall(function()
                    if localPlayer and localPlayer.Character then
                        local torso = localPlayer.Character:FindFirstChild("UpperTorso") or localPlayer.Character:FindFirstChild("HumanoidRootPart")  -- Get UpperTorso or HumanoidRootPart
                        if torso then
                            local targetPosition = torso.Position  -- Store player position
                            local orbs = game:GetService("Workspace").ExperienceOrbs:GetChildren()  -- Get all orbs
    
                            -- Loop through all orbs and move them to the player
                            for _, orb in ipairs(orbs) do
                                if orb:IsA("Part") and orb.Parent then
                                    -- Move orb directly to the player's torso position
                                    orb.CFrame = CFrame.new(targetPosition) * CFrame.new(0, 5, 0)  -- Hover above player
                                end
                            end
                        end
                    end
                end)
                task.wait(0.2)  -- Add a small delay to prevent server strain
            end
        end)
    end)
    tab7:CreateToggle("PoliceKillaura", function(state)
        local player = game.Players.LocalPlayer
        local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
        if state then
            -- Enable NPC Killaura
            getgenv().NPCPoliceKillaura = true
            spawn(function()
                while getgenv().NPCPoliceKillaura do
                    pcall(function()
                        -- Loop through all models in the workspace
                        for _, npc in pairs(game.Workspace:GetChildren()) do
                            -- Check if the npc is of the type "Police" and has a Humanoid
                            if npc:IsA("Model") and npc.Name == "Police" and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                                local npcRoot = npc:FindFirstChild("HumanoidRootPart")
                                if npcRoot and rootPart then
                                    -- Calculate the distance between the player and the NPC
                                    local distance = (rootPart.Position - npcRoot.Position).Magnitude
                                    if distance <= 15 then
                                        -- Attack the NPC Police (Firing a punch)
                                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                                    end
                                end
                            end
                        end
                    end)
                    wait(0.1)  -- Add a small delay between checks to avoid spamming requests
                end
            end)
        else
            -- Disable NPC Killaura
            getgenv().NPCPoliceKillaura = false
        end
    end)
    
    tab7:CreateToggle("ThugKillaura", function(state)
        local player = game.Players.LocalPlayer
        local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
        if state then
            -- Enable Killaura
            getgenv().ThugKillaura = true
            spawn(function()
                while getgenv().ThugKillaura do
                    pcall(function()
                        -- Loop through all models in the workspace
                        for _, thug in pairs(game.Workspace:GetChildren()) do
                            -- Check if the model is a "Thug" and has a valid Humanoid
                            if thug:IsA("Model") and thug.Name == "Thug" and thug:FindFirstChild("Humanoid") and thug.Humanoid.Health > 0 then
                                local thugRoot = thug:FindFirstChild("HumanoidRootPart")
                                if thugRoot and rootPart then
                                    -- Calculate the distance between the player and the thug
                                    local distance = (rootPart.Position - thugRoot.Position).Magnitude
                                    if distance <= 15 then
                                        -- Attack the Thug
                                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                                    end
                                end
                            end
                        end
                    end)
                    wait(0.1) -- Check every 0.1 seconds
                end
            end)
        else
            -- Disable Killaura
            getgenv().ThugKillaura = false
        end
    end)
    -- Ensure shieldBurstActive is defined before use
    local shieldBurstActive = false  -- Default state of the shield burst
    
    tab7:CreateToggle("Shield Burst", function(state)
        shieldBurstActive = state  -- Update the Shield Burst state with the toggle input
    
        -- Local variables
        local burstIntensity = 5  -- Customize the intensity of shield bursts
        local shieldWaitTime = 0.1 -- Time between each burst
        local maxBurstCount = 10  -- Maximum burst count before reset
        local pauseTime = 0.3 -- Time to wait after reaching max burst count for smoother performance
    
        if shieldBurstActive then
            -- Begin Shield Burst in a coroutine to prevent blocking the main thread
            coroutine.wrap(function()
                local burstCount = 0  -- Tracks number of activations
    
                while shieldBurstActive do
                    -- Fire the shield activation event
                    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(true)
    
                    burstCount = burstCount + 1  -- Increment the activation count
    
                    -- If burst count reaches set intensity, reset or pause briefly
                    if burstCount >= maxBurstCount then
                        burstCount = 0
                        task.wait(pauseTime)  -- Pause briefly after reaching max burst for smoother performance
                    end
    
                    -- Wait before firing the next burst to control the frequency
                    task.wait(shieldWaitTime)  
                end
    
                -- Ensure shield is turned off when Shield Burst is deactivated
                game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false)
            end)()
        else
            -- Ensure shield is turned off immediately when Shield Burst toggle is deactivated
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false)
        end
    end)
    tab4:CreateToggle("Anti Damage", function(state)
        -- Toggle the Anti Damage functionality
        getgenv().AntiDamage = state
    
        -- Local references for efficiency
        local player = game.Players.LocalPlayer
        local RunService = game:GetService("RunService")
    
        -- Function to block health changes
        local function preventDamage()
            if getgenv().AntiDamage and player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health < humanoid.MaxHealth then
                    -- Restore health to max if damaged
                    humanoid.Health = humanoid.MaxHealth
                end
            end
        end
    
        -- Manage the connection for RenderStepped
        if state then
            -- Real-time, frame-by-frame health protection
            getgenv().antiDamageConnection = RunService.RenderStepped:Connect(preventDamage)
        else
            -- Disconnect protection when toggled off
            if getgenv().antiDamageConnection then
                getgenv().antiDamageConnection:Disconnect()
                getgenv().antiDamageConnection = nil
            end
            getgenv().AntiDamage = false
        end
    end)
    
    tab4:CreateToggle("Anti Grab", function(state)
        -- Toggle the Anti-Grab functionality
        getgenv().AntiT = state
    
        -- Local references for efficiency
        local player = game.Players.LocalPlayer
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RunService = game:GetService("RunService")
        local toggleTelekinesisEvent = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("ToggleTelekinesis")
    
        -- Function to block telekinesis effects
        local function protectPlayer()
            if getgenv().AntiT and toggleTelekinesisEvent and player.Character then
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    toggleTelekinesisEvent:InvokeServer(Vector3.new(1, 1, 1), false, player.Character)
                end
            end
        end
    
        -- Manage the connection for RenderStepped
        if state then
            -- Fast, real-time anti-grab logic
            getgenv().protectionConnection = RunService.RenderStepped:Connect(protectPlayer)
        else
            -- Cleanly disconnect protection
            if getgenv().protectionConnection then
                getgenv().protectionConnection:Disconnect()
                getgenv().protectionConnection = nil
            end
            getgenv().AntiT = false
        end
    end)
    
    
    ---------------------------------------------------------------------
    -- Local function to get the root of the player's character
    local function getRoot(character)
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    end
    
    -- Local function to trigger rapid punches
    local function rapidPunch(count, delay)
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local punchEvent = replicatedStorage:FindFirstChild("Events") and replicatedStorage.Events:FindFirstChild("Punch")
        if not punchEvent then
            warn("Punch event not found!")
            return
        end
    
        -- Execute punches rapidly with specified delay
        for _ = 1, count do
            punchEvent:FireServer(0, 0.1, 1)  -- Modify arguments based on game mechanics
            task.wait(delay)  -- Smooth delay between each punch
        end
    end
    
    -- Function to apply the aura effect (rapid punches on nearby players)
    local function applyAura(stateVariable, radius, punchCount, punchCooldown)
        while getgenv()[stateVariable] do
            local player = game.Players.LocalPlayer
            local playerCharacter = player.Character
            local playerRoot = playerCharacter and getRoot(playerCharacter)
    
            if playerRoot then
                -- Loop through all players in the game to find targets
                for _, targetPlayer in pairs(game.Players:GetPlayers()) do
                    if targetPlayer ~= player and targetPlayer.Character then
                        local targetRoot = getRoot(targetPlayer.Character)
                        if targetRoot and (playerRoot.Position - targetRoot.Position).Magnitude <= radius then
                            -- Trigger rapid punches on nearby players
                            rapidPunch(punchCount, punchCooldown)  -- Adjust punch count and cooldown
                        end
                    end
                end
            else
                warn("Player character or root part not found!")
            end
    
            task.wait(punchCooldown)  -- Smooth delay between aura pulses
        end
    end
    
    tab7:CreateToggle("PlayerKillAura", function(state)
        getgenv().superRapidAura = state
        if state then
            -- Start the rapid punching aura with fast speed and strong effect
            task.spawn(function()
                -- Apply aura with specified parameters: radius 15, punch count 100, punch cooldown 0.03
                while getgenv().superRapidAura do
                    applyAura("superRapidAura", 15, 100, 0.03)  -- Higher punch speed and intensity
                end
            end)
        else
            -- Disable the rapid punching aura when toggled off
            getgenv().superRapidAura = false
        end
    end)
       -- Ensure shieldBurstActive is defined before use
    local shieldBurstActive = false  -- Default state of the shield burst
    
    tab7:CreateToggle("Shield Burst", function(state)
        shieldBurstActive = state  -- Update the Shield Burst state with the toggle input
    
        -- Local variables
        local burstIntensity = 5  -- Customize the intensity of shield bursts
        local shieldWaitTime = 0.1 -- Time between each burst
        local maxBurstCount = 10  -- Maximum burst count before reset
        local pauseTime = 0.3 -- Time to wait after reaching max burst count for smoother performance
    
        if shieldBurstActive then
            -- Begin Shield Burst in a coroutine to prevent blocking the main thread
            coroutine.wrap(function()
                local burstCount = 0  -- Tracks number of activations
    
                while shieldBurstActive do
                    -- Fire the shield activation event
                    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(true)
    
                    burstCount = burstCount + 1  -- Increment the activation count
    
                    -- If burst count reaches set intensity, reset or pause briefly
                    if burstCount >= maxBurstCount then
                        burstCount = 0
                        task.wait(pauseTime)  -- Pause briefly after reaching max burst for smoother performance
                    end
    
                    -- Wait before firing the next burst to control the frequency
                    task.wait(shieldWaitTime)  
                end
    
                -- Ensure shield is turned off when Shield Burst is deactivated
                game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false)
            end)()
        else
            -- Ensure shield is turned off immediately when Shield Burst toggle is deactivated
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false)
        end
    end)
    
    
    ---------------------------------------------------------------------
    -- Local function to get the root of the player's character
    local function getRoot(character)
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    end
    
    -- Local function to trigger rapid punches
    local function rapidPunch(count, delay)
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local punchEvent = replicatedStorage:FindFirstChild("Events") and replicatedStorage.Events:FindFirstChild("Punch")
        if not punchEvent then
            warn("Punch event not found!")
            return
        end
    
        -- Execute punches rapidly with specified delay
        for _ = 1, count do
            punchEvent:FireServer(0, 0.1, 1)  -- Modify arguments based on game mechanics
            task.wait(delay)  -- Smooth delay between each punch
        end
    end
    
    -- Function to apply the aura effect (rapid punches on nearby players)
    local function applyAura(stateVariable, radius, punchCount, punchCooldown)
        while getgenv()[stateVariable] do
            local player = game.Players.LocalPlayer
            local playerCharacter = player.Character
            local playerRoot = playerCharacter and getRoot(playerCharacter)
    
            if playerRoot then
                -- Loop through all players in the game to find targets
                for _, targetPlayer in pairs(game.Players:GetPlayers()) do
                    if targetPlayer ~= player and targetPlayer.Character then
                        local targetRoot = getRoot(targetPlayer.Character)
                        if targetRoot and (playerRoot.Position - targetRoot.Position).Magnitude <= radius then
                            -- Trigger rapid punches on nearby players
                            rapidPunch(punchCount, punchCooldown)  -- Adjust punch count and cooldown
                        end
                    end
                end
            else
                warn("Player character or root part not found!")
            end
    
            task.wait(punchCooldown)  -- Smooth delay between aura pulses
        end
    end
    
    tab7:CreateToggle("PlayerKillAura", function(state)
        getgenv().superRapidAura = state
        if state then
            -- Start the rapid punching aura with fast speed and strong effect
            task.spawn(function()
                -- Apply aura with specified parameters: radius 15, punch count 100, punch cooldown 0.03
                while getgenv().superRapidAura do
                    applyAura("superRapidAura", 15, 100, 0.03)  -- Higher punch speed and intensity
                end
            end)
        else
            -- Disable the rapid punching aura when toggled off
            getgenv().superRapidAura = false
        end
    end)
    
    --------------------------------------------------------------------------------------
    tab1:CreateButton("TP To Middle", function()
        local player = game.Players.LocalPlayer
        local teleportPosition = CFrame.new(-376, 94, 91)
    
        if _G.bring then
            -- Destroy telekinesis and teleport the specified target player
            local targetPlayer = game:GetService("Workspace")[_G.teleportplayer]
            if targetPlayer and targetPlayer:FindFirstChild("HumanoidRootPart") then
                -- Check if telekinesisPosition exists and destroy it
                local telekinesisPosition = targetPlayer.HumanoidRootPart:FindFirstChild("telekinesisPosition")
                if telekinesisPosition then
                    telekinesisPosition:Destroy()
                end
                -- Teleport the target player to the specified position
                targetPlayer.HumanoidRootPart.CFrame = teleportPosition
                -- Toggle telekinesis for the target player
                game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, targetPlayer)
            end
        else
            -- Teleport the local player
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = teleportPosition
            end
        end
    
        -- Call the breakvelocity function to handle any post-teleport adjustments
        breakvelocity()  -- Assuming this function is defined elsewhere
    end)
    
    tab4:CreateToggle("AutoClick'V'", function(state)
        getgenv().autoClickV = state -- Set a global variable to track the toggle state
    
        if state then
            -- Start Auto Clicking
            task.spawn(function()  -- Using task.spawn instead of spawn for better thread management
                while getgenv().autoClickV do
                    -- Simulate pressing the V key
                    local vim = game:GetService("VirtualInputManager")
                    vim:SendKeyEvent(true, "V", false, nil)  -- Press 'V'
                    vim:SendKeyEvent(false, "V", false, nil) -- Release 'V'
                    task.wait(0.01)  -- Reduced interval for faster clicking
                end
            end)
        else
            -- Stop Auto Clicking if toggle is switched off
            getgenv().autoClickV = false
        end
    end)
    tab1:CreateToggle("AutoClick'C'", function(state)
        getgenv().autoClickC = state -- Set a global variable to track the toggle state
    
        if state then
            -- Start Auto Clicking
            task.spawn(function()  -- Using task.spawn for better thread management
                while getgenv().autoClickC do
                    -- Simulate pressing the C key
                    local vim = game:GetService("VirtualInputManager")
                    vim:SendKeyEvent(true, "C", false, nil)  -- Press 'C'
                    task.wait(0.1)  -- Adjust the interval between clicks
                    vim:SendKeyEvent(false, "C", false, nil) -- Release 'C'
                    task.wait(0.1)  -- Interval before the next key press
                end
            end)
        else
            -- Ensure auto-clicking stops when state is false
            getgenv().autoClickC = false
        end
    end)
    tab4:CreateToggle("AutoClick'Z'", function(state)
        getgenv().autoClickZ = state -- Set a global variable to track the toggle state
    
        if state then
            -- Start Auto Clicking
            task.spawn(function()  -- Use task.spawn for better thread management
                local vim = game:GetService("VirtualInputManager")  -- Store the VirtualInputManager for efficiency
                while getgenv().autoClickZ do
                    -- Simulate pressing the Z key
                    vim:SendKeyEvent(true, Enum.KeyCode.Z, false, nil)  -- Press 'Z'
                    task.wait(0.1)  -- Adjust the interval between key presses
                    vim:SendKeyEvent(false, Enum.KeyCode.Z, false, nil)  -- Release 'Z'
                    task.wait(0.1)  -- Interval before the next key press
                end
            end)
        else
            -- Stop the auto clicker when the toggle is off
            getgenv().autoClickZ = false
        end
    end)
    ----------------------
    -- Variables for ESP settings
    getgenv().OutlineColor = Color3.new(1, 0, 1) -- Default color is pink
    getgenv().ESPEnabled = false
    
    -- Function to add ESP to a player
    local function addESP(player)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Create Highlight for outline ESP
            local highlight = Instance.new("Highlight")
            highlight.Parent = player.Character
            highlight.FillTransparency = 1 -- Fully transparent fill
            highlight.OutlineTransparency = 0 -- No transparency on outline
            highlight.OutlineColor = getgenv().OutlineColor -- Set outline color
    
            -- Create a BillboardGui for player name above the head
            local billboard = Instance.new("BillboardGui")
            billboard.Parent = player.Character:WaitForChild("Head")
            billboard.Size = UDim2.new(1, 0, 1, 0)
            billboard.Adornee = player.Character.Head
            billboard.SizeOffset = Vector2.new(0, 2) -- Adjust height offset
    
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Text = player.Name
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextColor3 = Color3.new(1, 1, 1) -- White text
            nameLabel.Font = Enum.Font.SourceSans
            nameLabel.TextSize = 14
            nameLabel.Parent = billboard
        end
    end
    
    -- Function to remove ESP from a player
    local function removeESP(player)
        if player.Character then
            -- Remove Highlight
            local highlight = player.Character:FindFirstChildOfClass("Highlight")
            if highlight then
                highlight:Destroy()
            end
            
            -- Remove BillboardGui
            local billboard = player.Character:FindFirstChildOfClass("BillboardGui")
            if billboard then
                billboard:Destroy()
            end
        end
    end
    
    -- Function to handle enabling/disabling ESP
    tab1:CreateToggle("Player ESP", function(state)
        getgenv().ESPEnabled = state
    
        if state then
            -- Add ESP to all players except the local player
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    addESP(player)
                end
            end
    
            -- Detect new players and add ESP
            game.Players.PlayerAdded:Connect(function(player)
                -- Only add ESP when the player is not the local player
                player.CharacterAdded:Connect(function(character)
                    if player ~= game.Players.LocalPlayer then
                        addESP(player)
                    end
                end)
            end)
    
        else
            -- Remove ESP from all players
            for _, player in pairs(game.Players:GetPlayers()) do
                removeESP(player)
            end
        end
    end)
    
    ------------------------
    -- Define the available stats in a table
    local stats = {
        "vitality", "healing", "strength", "energy", "flight", "speed", 
        "climbing", "swinging", "fireball", "frost", "lightning", 
        "power", "telekinesis", "shield", "laserVision", "metalSkin"
    }
    
    -- Create the dropdown for AutoStats
    tab6:CreateDropdown("AutoStats", stats, function(currentOption)
        selectedstat = currentOption -- Set the selected stat
    end)
    
    -- Create the button to toggle AutoStats
    tab6:CreateToggle("AutoStats", function()
        if not selectedstat then
            warn("No stat selected! Please select a stat from the dropdown.") -- Ensure a stat is selected
            return
        end
    
        getgenv().AutoStats = not getgenv().AutoStats -- Toggle the AutoStats variable
    
        if getgenv().AutoStats then
            coroutine.wrap(function()
                while getgenv().AutoStats do
                    wait(0.01) -- Set the delay to 0.01 seconds for better control over actions per second
                    pcall(function()
                        -- Upgrade the selected stat multiple times per tick
                        for _ = 1, 1000 do
                            game:GetService("ReplicatedStorage").Events.UpgradeAbility:InvokeServer(selectedstat)
                        end
                    end)
                end
            end)()
        else
            -- Disable AutoStats
            getgenv().AutoStats = false
        end
    end)
    
    tab6:CreateButton("Auto Select", function()
        local recommendedStat = "strength"  -- Default recommendation
        local player = game.Players.LocalPlayer
        local character = player.Character
    
        -- Ensure the character is loaded and has the "Role" attribute
        if character and character:FindFirstChild("Role") then
            local role = character.Role
    
            -- Check the role and recommend a stat based on it
            if role.Value == "Tank" then
                recommendedStat = "vitality"
            elseif role.Value == "DPS" then
                recommendedStat = "strength"
            elseif role.Value == "Healer" then
                recommendedStat = "healing"
            end
        end
    
        -- Set the recommended stat
        selectedstat = recommendedStat
    
        -- Provide feedback to the user
        print("Recommended stat selected:", recommendedStat)
        -- Optionally, you could also display a UI message here to notify the player visually
    end)
    tab6:CreateButton("Reset", function()
        local resetEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Events") and game:GetService("ReplicatedStorage").Events:FindFirstChild("ResetStats")
    
        -- Ensure the ResetStats event exists
        if resetEvent then
            pcall(function()
                -- Invoke the ResetStats event
                resetEvent:InvokeServer()
                print("Stats have been reset successfully!")  -- Log success in the output
                -- Optionally, display a UI message to the player here (e.g., through a Label)
            end)
        else
            -- Provide feedback if the ResetStats event is missing
            warn("ResetStats event not found!")
            -- Optionally, display an error message in the UI to notify the player
        end
    end)
    tab2:CreateToggle("Laser Civilian", function(state)
        if state then
            getgenv().LaserC = true
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)
                
                -- Ensure part is valid
                if not part or not part:IsA("BasePart") then
                    warn("Failed to get a valid part for Laser Vision!")
                    return
                end
                
                -- Set laser color and material (optional)
                part.Color = Color3.fromRGB(255, 255, 255)  -- White laser
                part.Material = Enum.Material.Neon  -- Neon material for visibility
    
                -- Main loop to track civilians
                while getgenv().LaserC do
                    local foundCivilian = false
                    
                    -- Loop through all models in the workspace to find Civilians
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Model") and v.Name == "Civilian" and v:FindFirstChild("Humanoid") then
                            local humanoid = v.Humanoid
                            -- If the humanoid is alive, update the laser position
                            if humanoid.Health > 0 then
                                part.Position = v.HumanoidRootPart.Position
                                foundCivilian = true
                                break  -- Stop the loop once we find one civilian to target
                            end
                        end
                    end
                    
                    -- Adjust wait times based on whether a civilian was found
                    if not foundCivilian then
                        wait(0.5)  -- Wait longer if no civilian is found
                    else
                        wait(0.1)  -- Shorter wait time if a civilian is found and the laser position is updated
                    end
                end
                
                -- Disable Laser Vision and cleanup
                event:InvokeServer(false)
            end)()
        else
            getgenv().LaserC = false
            -- Stop laser action and reset any necessary variables
            breakvelocity()  -- Make sure this function is defined in your game logic
        end
    end)
    tab2:CreateToggle("Laser Police", function(state)
        if state then
            getgenv().LaserV = true
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)
                
                -- Ensure part is valid
                if not part or not part:IsA("BasePart") then
                    warn("Failed to get a valid part for Laser Vision!")
                    return
                end
    
                -- Set laser color and material (optional for visibility)
                part.Color = Color3.fromRGB(255, 0, 0)  -- Red laser
                part.Material = Enum.Material.Neon  -- Neon material for better visibility
    
                -- Main loop to track police officers
                while getgenv().LaserV do
                    local foundPolice = false
                    
                    -- Loop through all models in the workspace to find Police models
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Model") and v.Name == "Police" and v:FindFirstChild("Humanoid") then
                            local humanoid = v.Humanoid
                            -- If the humanoid is alive, update the laser position
                            if humanoid.Health > 0 then
                                part.Position = v.HumanoidRootPart.Position
                                foundPolice = true
                                break  -- Stop the loop once we find one police officer to target
                            end
                        end
                    end
                    
                    -- Adjust wait times based on whether a police officer was found
                    if not foundPolice then
                        wait(0.5)  -- Wait longer if no police officer is found
                    else
                        wait(0.1)  -- Shorter wait time if a police officer is found and position is updated
                    end
                end
                
                -- Disable Laser Vision when stopping
                event:InvokeServer(false)
            end)()
        else
            getgenv().LaserV = false
            -- Stop laser action and reset any necessary variables
            breakvelocity()  -- Make sure breakvelocity is defined in your game logic
        end
    end)
    tab2:CreateToggle("Laser Thug", function(state)
        if state then
            getgenv().LaserH = true
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)
    
                -- Ensure the part is valid and set up laser color and material
                if part and part:IsA("BasePart") then
                    part.Color = Color3.fromRGB(255, 255, 255)  -- White laser color
                    part.Material = Enum.Material.Neon  -- Neon material for better visibility
                else
                    warn("Laser part is invalid or not a BasePart!")
                    return
                end
    
                -- Mute the laser sound if it exists
                local laserSound = part:FindFirstChild("LaserSound")
                if laserSound then
                    laserSound.Volume = 0  -- Mute the sound
                end
    
                -- Create a pink highlight for ESP effect (visual enhancement)
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 182, 193)  -- Light pink for fill
                highlight.OutlineColor = Color3.fromRGB(255, 105, 180)  -- Darker pink for outline
                highlight.FillTransparency = 0.7
                highlight.OutlineTransparency = 0
                highlight.Parent = game.CoreGui  -- Make sure it's visible through walls
    
                -- Main loop to track Thug models
                while getgenv().LaserH and part do
                    local thugFound = false
    
                    -- Loop through all models in the workspace
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Model") and v.Name == "Thug" and v:FindFirstChild("Humanoid") then
                            local humanoid = v.Humanoid
                            if humanoid.Health > 0 then
                                -- Set the laser to the Thug's position and update ESP
                                part.Position = v.HumanoidRootPart.Position
                                highlight.Adornee = v  -- Attach ESP to the Thug model
                                thugFound = true
                                break  -- Exit the loop once a Thug is found
                            end
                        end
                    end
    
                    -- Adjust the wait time depending on whether a Thug is found
                    if thugFound then
                        wait(0.1)  -- Shorter wait time if a Thug is found
                    else
                        wait(0.5)  -- Longer wait time if no Thug is found
                    end
                end
    
                -- Disable Laser Vision and clean up once done
                event:InvokeServer(false)
                highlight:Destroy()  -- Clean up the highlight
            end)()
        else
            getgenv().LaserH = false
            -- Additional cleanup logic can be added here if necessary
        end
    end)
    
    tab2:CreateToggle("Civilian Sky", function(state)
        local player = game.Players.LocalPlayer  -- Ensure we're working with the correct player
    
        if state then
            -- Safety check to ensure the character and HumanoidRootPart exist
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local orbPos = player.Character.HumanoidRootPart.Position
                -- Set position in the sky (X and Z stay the same, Y is set to 2500)
                player.Character.HumanoidRootPart.CFrame = CFrame.new(orbPos.X, 2500, orbPos.Z)
                getgenv().LaserC = true
                wait(0.2)  -- Small delay to ensure position is updated
                player.Character.HumanoidRootPart.Anchored = true  -- Anchor the character to keep it in place
    
                -- Coroutine to handle laser targeting civilians
                coroutine.wrap(function()
                    local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                    local part = event:InvokeServer(true)  -- Activate Laser Vision
                    
                    -- Main loop to track civilian positions and update laser part
                    while getgenv().LaserC and part do
                        local foundCivilian = false
                        -- Loop through all models in the workspace to find "Civilian" models
                        for _, v in pairs(game.Workspace:GetChildren()) do
                            if v:IsA("Model") and v.Name == "Civilian" and v:FindFirstChild("Humanoid") then
                                local humanoid = v.Humanoid
                                -- If the humanoid is alive, set the laser position
                                if humanoid.Health > 0 then
                                    part.Position = v.HumanoidRootPart.Position
                                    foundCivilian = true
                                    break  -- Exit the loop once a civilian is found
                                end
                            end
                        end
                        
                        -- If no civilian found, wait a little before checking again
                        if not foundCivilian then
                            wait(0.5)  -- Adjust wait time as needed for performance
                        else
                            wait(0.1)  -- Shorter wait time if civilian is found and laser position is updated
                        end
                    end
                    
                    -- Deactivate Laser Vision when the loop ends
                    event:InvokeServer(false)
                end)()
            else
                warn("HumanoidRootPart not found in character!")
            end
        else
            -- Reset the character's position and disable laser functionality when toggled off
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.Anchored = false  -- Unanchor the character
                getgenv().LaserC = false
                player.Character.HumanoidRootPart.CFrame = CFrame.new(orbPos)  -- Restore original position
                breakvelocity()  -- Call to break any velocity or stop other actions
            else
                warn("HumanoidRootPart not found in character when turning off!")
            end
        end
    end)
    tab2:CreateToggle("Thug fromsky", function(state)
        local player = game.Players.LocalPlayer  -- Ensure we're working with the correct player
    
        if state then
            -- Safety check to ensure the character and HumanoidRootPart exist
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local thugPos = player.Character.HumanoidRootPart.Position
                -- Set position in the sky (X and Z stay the same, Y is set to 2500)
                player.Character.HumanoidRootPart.CFrame = CFrame.new(thugPos.X, 2500, thugPos.Z)
                getgenv().LaserH = true
                wait(0.2)  -- Small delay to ensure position is updated
                player.Character.HumanoidRootPart.Anchored = true  -- Anchor the character to keep it in place
    
                -- Coroutine to handle laser targeting thugs
                coroutine.wrap(function()
                    local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                    local part = event:InvokeServer(true)  -- Activate Laser Vision
                    
                    -- Main loop to track thug positions and update laser part
                    while getgenv().LaserH and part do
                        local foundThug = false
                        -- Loop through all models in the workspace to find "Thug" models
                        for _, v in pairs(game.Workspace:GetChildren()) do
                            if v:IsA("Model") and v.Name == "Thug" and v:FindFirstChild("Humanoid") then
                                local humanoid = v.Humanoid
                                -- If the humanoid is alive, set the laser position
                                if humanoid.Health > 0 then
                                    part.Position = v.HumanoidRootPart.Position
                                    foundThug = true
                                    break  -- Exit the loop once a thug is found
                                end
                            end
                        end
                        
                        -- If no thug found, wait a little before checking again
                        if not foundThug then
                            wait(0.5)  -- Adjust wait time as needed for performance
                        else
                            wait(0.1)  -- Shorter wait time if thug is found and laser position is updated
                        end
                    end
                    
                    -- Deactivate Laser Vision when the loop ends
                    event:InvokeServer(false)
                end)()
            else
                warn("HumanoidRootPart not found in character!")
            end
        else
            -- Reset the character's position and disable laser functionality when toggled off
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.Anchored = false  -- Unanchor the character
                getgenv().LaserH = false
                player.Character.HumanoidRootPart.CFrame = CFrame.new(thugPos)  -- Restore original position
                breakvelocity()  -- Call to break any velocity or stop other actions
            else
                warn("HumanoidRootPart not found in character when turning off!")
            end
        end
    end)
    tab2:CreateToggle("Police Sky", function(state)
        local player = game.Players.LocalPlayer  -- Ensure we're working with the correct player
    
        if state then
            -- Safety check to ensure the character and HumanoidRootPart exist
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local orbPos = player.Character.HumanoidRootPart.Position
                -- Set position in the sky (X and Z stay the same, Y is set to 2500)
                player.Character.HumanoidRootPart.CFrame = CFrame.new(orbPos.X, 2500, orbPos.Z)
                getgenv().LaserV = true
                wait(0.2)  -- Small delay to ensure position is updated
                player.Character.HumanoidRootPart.Anchored = true  -- Anchor the character to keep it in place
    
                -- Coroutine to handle laser targeting police
                coroutine.wrap(function()
                    local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                    local part = event:InvokeServer(true)  -- Activate Laser Vision
                    
                    -- Main loop to track police positions and update laser part
                    while getgenv().LaserV and part do
                        local foundPolice = false
                        -- Loop through all models in the workspace to find "Police" models
                        for _, v in pairs(game.Workspace:GetChildren()) do
                            if v:IsA("Model") and v.Name == "Police" and v:FindFirstChild("Humanoid") then
                                local humanoid = v.Humanoid
                                -- If the humanoid is alive, set the laser position
                                if humanoid.Health > 0 then
                                    part.Position = v.HumanoidRootPart.Position
                                    foundPolice = true
                                    break  -- Exit the loop once a police officer is found
                                end
                            end
                        end
                        
                        -- If no police found, wait a little before checking again
                        if not foundPolice then
                            wait(0.5)  -- Adjust wait time as needed for performance
                        else
                            wait(0.1)  -- Shorter wait time if a police officer is found and laser position is updated
                        end
                    end
                    
                    -- Deactivate Laser Vision when the loop ends
                    event:InvokeServer(false)
                end)()
            else
                warn("HumanoidRootPart not found in character!")
            end
        else
            -- Reset the character's position and disable laser functionality when toggled off
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.Anchored = false  -- Unanchor the character
                getgenv().LaserV = false
                player.Character.HumanoidRootPart.CFrame = CFrame.new(orbPos)  -- Restore original position
                breakvelocity()  -- Call to break any velocity or stop other actions
            else
                warn("HumanoidRootPart not found in character when turning off!")
            end
        end
    end)
    tab2:CreateToggle("Civilian Farm", function(state)
        local player = game.Players.LocalPlayer  -- Ensure we are working with the correct player
        
        -- Check if the player's character exists before proceeding
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Store original position
            local civilianPos = player.Character.HumanoidRootPart.CFrame
            getgenv().Civilian = state  -- Set the state globally to control the farming loop
    
            if state then
                -- Start farming loop
                coroutine.wrap(function()
                    while getgenv().Civilian do
                        wait(0.2)  -- Adjust the wait time as needed for performance
                        pcall(function()
                            -- Loop through all models in the workspace to find Civilian models
                            for _, v in pairs(game.Workspace:GetChildren()) do
                                -- Check if the model is a "Civilian" with a valid humanoid
                                if v:IsA("Model") and v.Name == "Civilian" and v:FindFirstChild("Humanoid") then
                                    local humanoid = v.Humanoid
                                    -- If the humanoid is alive, perform the punch and move towards the civilian
                                    if humanoid.Health > 0 then
                                        -- Fire the Punch event to damage the civilian
                                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                                        
                                        -- Move player towards the civilian's HumanoidRootPart with a small offset
                                        player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                                    end
                                end
                            end
                        end)
                    end
                end)()
    
                -- Store the return position so we can reset it when the toggle is turned off
                getgenv().CivilianReturnPos = civilianPos
            else
                -- Stop farming and return to the original position when toggled off
                getgenv().Civilian = false
                wait(0.2)  -- Slight delay to ensure the farming loop has time to stop
                if getgenv().CivilianReturnPos then
                    -- Reset the character's position to the stored original position
                    player.Character.HumanoidRootPart.CFrame = getgenv().CivilianReturnPos
                end
            end
        else
            warn("Player's character or HumanoidRootPart not found!")
        end
    end)
    tab2:CreateToggle("Police Farm", function(state)
        local player = game.Players.LocalPlayer  -- Ensure we are working with the correct player
        
        -- Check if the player's character exists before proceeding
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Store original position
            local policePos = player.Character.HumanoidRootPart.CFrame
            getgenv().Police = state  -- Set the state globally to control the farming loop
    
            if state then
                -- Start farming loop
                coroutine.wrap(function()
                    while getgenv().Police do
                        wait(0.2)  -- Adjust the wait time as needed for performance
                        pcall(function()
                            -- Loop through all models in the workspace to find Police models
                            for _, v in pairs(game.Workspace:GetChildren()) do
                                -- Check if the model is a "Police" with a valid humanoid
                                if v:IsA("Model") and v.Name == "Police" and v:FindFirstChild("Humanoid") then
                                    local humanoid = v.Humanoid
                                    -- If the humanoid is alive, perform the punch and move towards the police
                                    if humanoid.Health > 0 then
                                        -- Fire the Punch event to damage the police
                                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                                        
                                        -- Move player towards the police's HumanoidRootPart with a small offset
                                        player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                                    end
                                end
                            end
                        end)
                    end
                end)()
    
                -- Store the return position so we can reset it when the toggle is turned off
                getgenv().PoliceReturnPos = policePos
            else
                -- Stop farming and return to the original position when toggled off
                getgenv().Police = false
                wait(0.2)  -- Slight delay to ensure the farming loop has time to stop
                if getgenv().PoliceReturnPos then
                    -- Reset the character's position to the stored original position
                    player.Character.HumanoidRootPart.CFrame = getgenv().PoliceReturnPos
                end
            end
        else
            warn("Player's character or HumanoidRootPart not found!")
        end
    end)
    
    tab4:CreateButton("Spawn Point", function(state)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if state then
                getgenv().Deathcheck = true
                local spawnPosition = player.Character.HumanoidRootPart.Position  -- Use HumanoidRootPart instead of UpperTorso for consistency
                
                -- Coroutine for respawning at the saved position
                coroutine.wrap(function()
                    while getgenv().Deathcheck do
                        -- Ensure the player has a humanoid and check health
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health == 0 then
                            wait(6.5) -- Wait before teleporting to avoid instant respawn issues
                            -- Check if the player's character is still valid before teleporting
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                player.Character.HumanoidRootPart.CFrame = CFrame.new(spawnPosition) -- Teleport to saved position
                            end
                        end
                        wait(1) -- Check health every second
                    end
                end)()
            else
                getgenv().Deathcheck = false -- Stop respawn loop when toggled off
            end
        else
            warn("Player's character or HumanoidRootPart not found!")
        end
    end)
    tab1:CreateToggle("Rapid low", function(state)
        if state then
            -- Activate Rapid Punch
            getgenv().rapid = true
            local UserInputService = game:GetService("UserInputService")
            
            -- Function to handle input
            local function onInputEnded(inputObject, gameProcessedEvent)
                if gameProcessedEvent then return end -- Ignore if the input was processed by the game
                
                if getgenv().rapid and inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                    -- Fire the punch event multiple times rapidly (you can adjust this number)
                    for i = 1, 10 do
                        -- Ensure we are not overwhelming the server with too many requests at once
                        pcall(function() 
                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                        end)
                        wait(0.1)  -- Add a small delay between punches to prevent issues
                    end
                end
            end
            
            -- Store the connection so we can disconnect it later
            getgenv().RapidPunchConnection = UserInputService.InputEnded:Connect(onInputEnded)
        else
            -- Deactivate Rapid Punch
            getgenv().rapid = false
            
            -- Disconnect the connection to stop listening for input
            if getgenv().RapidPunchConnection then
                getgenv().RapidPunchConnection:Disconnect()
                getgenv().RapidPunchConnection = nil
            end
        end
    end)
    tab1:CreateToggle("Rapid Godly", function(state)
        if state then
            -- Activate Rapid Punch
            getgenv().rapid = true
            local UserInputService = game:GetService("UserInputService")
            
            -- Function to handle input
            local function onInputEnded(inputObject, gameProcessedEvent)
                if gameProcessedEvent then return end -- Ignore if the input was processed by the game
                
                if getgenv().rapid and inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                    -- Fire the punch event multiple times rapidly
                    for i = 1, 10 do
                        if not getgenv().rapid then break end -- Exit early if the toggle is turned off
                        pcall(function() 
                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.01, 1)
                        end)
                        wait(0.05)  -- Adjusted delay between punches
                    end
                end
            end
            
            -- Store the connection so we can disconnect it later
            getgenv().RapidPunchConnection = UserInputService.InputEnded:Connect(onInputEnded)
        else
            -- Deactivate Rapid Punch
            getgenv().rapid = false
            
            -- Disconnect the connection to stop listening for input
            if getgenv().RapidPunchConnection then
                getgenv().RapidPunchConnection:Disconnect()
                getgenv().RapidPunchConnection = nil
            end
        end
    end)
    getRoot = function(char)
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    end
    local UserInputService = game:GetService("UserInputService")
    local inputConnection = nil  -- Make the input connection global to persist across toggles
    
    tab1:CreateToggle("Super Rapid", function(state)
        if state then
            -- Activate Super Rapid Punch
            getgenv().superrapid = true
            
            local function onInputEnded(inputObject, gameProcessedEvent)
                if gameProcessedEvent or not getgenv().superrapid then return end
                
                if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                    spawn(function()
                        for _ = 1, 50 do -- Rapidly send 50 punches
                            if not getgenv().superrapid then break end
                            pcall(function()
                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                            end)
                            task.wait(0.05) -- Small delay between punches
                        end
                    end)
                end
            end
    
            -- Connect the input listener if it's not already connected
            if not inputConnection then
                inputConnection = UserInputService.InputEnded:Connect(onInputEnded)
            end
        else
            -- Deactivate Super Rapid Punch
            getgenv().superrapid = false
            
            -- Disconnect the input listener when the toggle is off
            if inputConnection then
                inputConnection:Disconnect()
                inputConnection = nil
            end
        end
    end)
    
    getRoot = function(char)
        local rootPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        return rootPart
    end
    
    Players = game:GetService("Players")
    local esp_settings = {textsize = 20}
    
    tab1:CreateToggle("Name Esp", function(state)
        if state then
            -- Create the BillboardGui template
            local function createESP(player)
                local gui = Instance.new("BillboardGui")
                local esp = Instance.new("TextLabel", gui)
    
                gui.Name = "esp"
                gui.ResetOnSpawn = false
                gui.AlwaysOnTop = true
                gui.LightInfluence = 0
                gui.Size = UDim2.new(1.75, 0, 1.75, 0)
    
                esp.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
                esp.Text = player.Name
                esp.Size = UDim2.new(0.0001, 0.00001, 0.0001, 0.00001)
                esp.BorderSizePixel = 4
                esp.BorderColor3 = Color3.new(0, 255, 255)
                esp.BorderSizePixel = 0
                esp.Font = Enum.Font.SourceSansSemibold
                esp.TextSize = esp_settings.textsize
                esp.TextColor3 = Color3.fromRGB(0, 255, 255)
    
                -- Parent the ESP to the character's Head (if it exists)
                if player.Character and player.Character:FindFirstChild("Head") then
                    gui.Parent = player.Character.Head
                end
            end
    
            -- Create ESP for all players in the game
            for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                if v ~= game.Players.LocalPlayer then
                    createESP(v)
                end
            end
    
            -- Update the ESP every frame to ensure the name is visible and not duplicated
            game:GetService("RunService").RenderStepped:Connect(function()
                for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                    if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                        local gui = v.Character.Head:FindFirstChild("esp")
                        if gui then
                            -- Update the player's name
                            gui.TextLabel.Text = "Name: " .. v.Name
                        else
                            -- If the ESP doesn't exist, create it
                            createESP(v)
                        end
                    end
                end
            end)
    
        else
            -- Remove all ESP when toggled off
            for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("Head") then
                    local espGui = v.Character.Head:FindFirstChild("esp")
                    if espGui then
                        espGui:Destroy()  -- Remove the ESP
                    end
                end
            end
        end
    end)
    local player = game.Players.LocalPlayer
    tab4:CreateButton("GodMode",function()
        if state then
            -- Save current position and humanoid state
            local currentPos = player.Character.HumanoidRootPart.CFrame
            local humanoid = player.Character:FindFirstChild("Humanoid")
            
            -- Disable movement and actions
            if humanoid then
                humanoid.PlatformStand = true  -- Disable movement and physics
                humanoid.Health = humanoid.Health  -- Prevent health changes or dying
            end
            
            -- Optionally, teleport to a GodMode location (can be customized)
            player.Character.HumanoidRootPart.CFrame = CFrame.new(2142, -195, -1925)
            
            wait(0.2)
            
            -- Optionally, destroy critical joints like Waist for "god-mode" effect (be cautious)
            local upperTorso = player.Character:FindFirstChild("UpperTorso")
            if upperTorso and upperTorso:FindFirstChild("Waist") then
                upperTorso.Waist:Destroy()
            end
            
            -- Anchor the Head or other parts to simulate invincibility or inability to move
            local head = player.Character:FindFirstChild("Head")
            if head then
                head.Anchored = true
            end
            
            wait(2)
            
            -- Return to the saved position (restore normal behavior)
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = currentPos
                if humanoid then
                    humanoid.PlatformStand = false  -- Re-enable normal movement and actions
                end
            end
    
        else
            -- When disabling GodMode, reset the character to a regular state
            local resetPos = player.Character.HumanoidRootPart.CFrame
            local humanoid = player.Character:FindFirstChild("Humanoid")
            
            if humanoid then
                humanoid.PlatformStand = false  -- Re-enable movement and actions
            end
            
            -- Optionally break joints to reset the character
            player.Character:BreakJoints()
            wait(6.5)
            
            -- Teleport back to the saved position after reset
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = resetPos
            end
        end
    end)
    local player = game.Players.LocalPlayer
    tab4:CreateToggle("Invisibility",function()
        if state then
            -- Save the current position
            local currentPos = player.Character.HumanoidRootPart.CFrame
            
            -- Make the character invisible by adjusting transparency and collision
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1  -- Make part invisible
                    part.CanCollide = false  -- Disable physical interaction
                end
            end
            
            -- Optionally, freeze the character in place to simulate invisibility
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = true  -- Prevent movement and actions
            end
            
            wait(2)  -- Invisible for 2 seconds, adjust as needed
            
            -- Return to the saved position and reset the character
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = currentPos
                -- Reset transparency and collision for all parts
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0  -- Make part visible again
                        part.CanCollide = true  -- Re-enable collision
                    end
                end
                
                -- Re-enable movement and actions
                if humanoid then
                    humanoid.PlatformStand = false  -- Re-enable movement
                end
            end
        else
            -- When toggling off, simply reset the character
            local resetPos = player.Character.HumanoidRootPart.CFrame
            -- Optionally, reset transparency and collision here if needed
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0  -- Make part visible
                    part.CanCollide = true  -- Re-enable collision
                end
            end
            -- Reset character position
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = resetPos
            end
        end
    end)
    tab4:CreateToggle("Auto MetalSkin", function()
        getgenv().metal = state  -- Directly set metal state based on the toggle
        
        if state then
            -- Start the loop only if it's not already running
            if not getgenv().metalLoop then
                getgenv().metalLoop = true  -- Prevent multiple loops from running
                spawn(function()  -- Start a new thread for the loop
                    while getgenv().metal do
                        -- Fire the server event to activate metal skin
                        game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", true)
                        wait(0.2)  -- Adjust delay if needed
                    end
                    getgenv().metalLoop = false  -- Reset the loop tracker
                end)
            end
        else
            -- Turn off MetalSkin once if the toggle is off
            game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", false)
        end
    end)
    
    local UserInputService = game:GetService("UserInputService")
    local jumpHeight = 100 -- The height of the super jump
    local defaultJumpHeight = game.Players.LocalPlayer.Character.Humanoid.JumpHeight -- Store default jump height
    
    tab9:CreateToggle("Super Jump",function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        local humanoid = character:WaitForChild("Humanoid")
        
        if state then
            -- When toggled on, set jump height to super high
            humanoid.JumpHeight = jumpHeight
            print("Super Jump Activated!")
        else
            -- When toggled off, revert jump height to normal
            humanoid.JumpHeight = defaultJumpHeight
            print("Super Jump Deactivated!")
        end
    end)
    
    -- Function to play jump effects (sound and particle)
    local function playJumpEffects()
        local character = game.Players.LocalPlayer.Character
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoidRootPart then
            -- Play jump sound
            local jumpSound = Instance.new("Sound")
            jumpSound.SoundId = "rbxassetid://123456789" -- Replace with your own sound ID
            jumpSound.Parent = humanoidRootPart
            jumpSound:Play()
    
            -- Create and play particle effect
            local particle = Instance.new("ParticleEmitter")
            particle.Parent = humanoidRootPart
            particle.Texture = "rbxassetid://123456789" -- Replace with your own particle texture
            particle:Emit(50) -- Emit particles during jump
            
            -- Clean up after particle effect is emitted
            game.Debris:AddItem(particle, 5) -- Automatically remove particle after 5 seconds
            game.Debris:AddItem(jumpSound, jumpSound.TimeLength) -- Automatically remove sound after it finishes playing
        end
    end
    
    -- Detect when the player jumps and trigger the effects if using super jump
    game.Players.LocalPlayer.Character.Humanoid.Jumping:Connect(function()
        if game.Players.LocalPlayer.Character.Humanoid.JumpHeight == jumpHeight then
            -- Only trigger the effect if using super jump
            playJumpEffects()
        end
    end)
    
    -- Reset the jump height if the character respawns or resets
    game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.JumpHeight = defaultJumpHeight
    end)
    
    
    tab9:CreateButton("MegaForcefield", function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        if state then
            -- Create forcefield around player
            print("Mega Forcefield Activated!")
            
            local forceField = Instance.new("Part")
            forceField.Shape = Enum.PartType.Ball
            forceField.Size = Vector3.new(20, 20, 20) -- Size of the forcefield
            forceField.Position = humanoidRootPart.Position
            forceField.Anchored = true
            forceField.CanCollide = false
            forceField.Transparency = 0.5
            forceField.BrickColor = BrickColor.new("Bright blue")
            forceField.Parent = game.Workspace
            
            -- Set the global flag to indicate that the forcefield is active
            getgenv().forceFieldActive = true
    
            -- Repel nearby players while the forcefield is active
            spawn(function()
                while getgenv().forceFieldActive do
                    for _, v in pairs(game.Players:GetChildren()) do
                        local targetCharacter = v.Character
                        if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
                            local targetHRP = targetCharacter.HumanoidRootPart
                            local direction = (targetHRP.Position - forceField.Position).unit
                            local force = direction * 50 -- Adjust force strength
                            targetHRP.Velocity = force
                        end
                    end
                    wait(0.2) -- Small wait to prevent performance issues
                end
            end)
        else
            -- Deactivate Mega Forcefield
            getgenv().forceFieldActive = false
            print("Mega Forcefield Deactivated!")
    
            -- Remove the forcefield from the workspace
            for _, part in pairs(game.Workspace:GetChildren()) do
                if part:IsA("Part") and part.Size == Vector3.new(20, 20, 20) and part.Transparency == 0.5 then
                    part:Destroy() -- Destroy the forcefield part
                end
            end
        end
    end)
    
    local UserInputService = game:GetService("UserInputService")
    local player = game.Players.LocalPlayer
    local isTelekinesisActive = false
    local telesauras = false -- Variable to control the space fling
    local pushForce = 20 -- Force applied to other players during telekinesis push
    
    -- Space Fling (Telekinesis with extreme coordinates)
    tab1:CreateToggle("Space Fling", function()
        if state then
            -- Activate Telekinesis Space Fling
            telesauras = true
            
            spawn(function()
                while telesauras do
                    task.wait(0.2) -- Prevent overloading the server
                    
                    pcall(function()
                        -- Invoke the telekinesis events with extreme coordinates
                        game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(999999, 999999, 999999), true)
                        game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(999999, 999999, 999999), false)
                    end)
                end
            end)
        else
            -- Deactivate Telekinesis Space Fling
            telesauras = false
        end
    end)
    
    -- Telekinesis Push (Pushing nearby players away)
    local function toggleTelekinesisPush()
        if not isTelekinesisActive then
            isTelekinesisActive = true
            
            spawn(function()
                while isTelekinesisActive do
                    task.wait(0.2) -- Prevent overloading the server
                    
                    pcall(function()
                        -- Get the player's character
                        local playerChar = player.Character
                        if playerChar and playerChar:FindFirstChild("HumanoidRootPart") then
                            local myPosition = playerChar.HumanoidRootPart.Position
                            
                            -- Find nearby players
                            for _, v in pairs(game.Players:GetChildren()) do
                                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                                    local target = v.Character
                                    if target ~= playerChar then
                                        local targetHRP = target.HumanoidRootPart
                                        
                                        -- Calculate direction to push the target away from the player
                                        local direction = (targetHRP.Position - myPosition).unit
                                        local force = direction * pushForce -- Adjust this for more/less force
                                        
                                        -- Apply the force to the target's humanoid root part
                                        targetHRP.Velocity = force
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        else
            isTelekinesisActive = false
        end
    end
    
    -- Listen for the E key press to toggle Telekinesis Push
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
    
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.E then
            toggleTelekinesisPush() -- Toggle telekinesis push on key press
        end
    end)
    tab1:CreateToggle("AntiKnockback", function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local PrimaryPart = character.PrimaryPart or character:WaitForChild("HumanoidRootPart")
        
        if state then
            -- Enable Anti-Knockback
            getgenv().AntiKnockback = true
            local LastPosition = PrimaryPart.CFrame -- Initial position
            
            -- Start the anti-knockback loop using Heartbeat for better frame rate independence
            game:GetService("RunService").Heartbeat:Connect(function()
                if not getgenv().AntiKnockback then return end
                
                if PrimaryPart then
                    -- Check for high velocity to cancel knockback
                    if (PrimaryPart.AssemblyLinearVelocity.Magnitude > 250 or PrimaryPart.AssemblyAngularVelocity.Magnitude > 250) then
                        PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        PrimaryPart.CFrame = LastPosition -- Reset the position to the last valid one
                    elseif (PrimaryPart.AssemblyLinearVelocity.Magnitude < 50 and PrimaryPart.AssemblyAngularVelocity.Magnitude < 50) then
                        -- Update LastPosition when velocity is low, indicating no knockback
                        LastPosition = PrimaryPart.CFrame
                    end
                end
            end)
        else
            -- Disable Anti-Knockback
            getgenv().AntiKnockback = false
        end
    end)
    -- Anti-Fling toggle: Anchors or unanchors the HumanoidRootPart
    tab9:CreateToggle("Anti-Fling", function()
        local character = game.Players.LocalPlayer.Character
        if state then
            character.HumanoidRootPart.Anchored = true
        else
            character.HumanoidRootPart.Anchored = false
        end
    end)
    
    -- Speed slider: Controls the walking speed
    tab9:CreateSlider("Speed", 200, 16, function(s)
        local humanoid = game.Players.LocalPlayer.Character.Humanoid
        humanoid.WalkSpeed = s
    end)
    
    -- Jump Power slider: Controls the jump power
    tab9:CreateSlider("Jump", 100, 50, function(s)
        local humanoid = game.Players.LocalPlayer.Character.Humanoid
        humanoid.JumpPower = s
    end)
    
    -- Infinite Jump Button: Allows the player to jump infinitely
    tab9:CreateButton("inf-jump", function()
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if humanoid:GetState() == Enum.HumanoidStateType.Seated then
                    return  -- Prevent jumping while seated (optional, you can adjust this behavior)
                end
                humanoid:ChangeState("Jumping")
            end)
        end
    end)
    tab9:CreateButton("Anti-Lag", function()
        local Terrain = workspace:FindFirstChildOfClass("Terrain")
        if Terrain then
            -- Disable water-related effects
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 0
        end
        
        -- Set rendering quality to low
        settings().Rendering.QualityLevel = 1
        
        -- Modify properties of parts and meshes
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("Decal") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Explosion") then
                v.BlastPressure = 1
                v.BlastRadius = 1
            end
        end
    
        -- Remove specific effects as they're added
        workspace.DescendantAdded:Connect(function(child)
            coroutine.wrap(function()
                if child:IsA("ForceField") or child:IsA("Sparkles") or child:IsA("Smoke") or child:IsA("Fire") then
                    child:Destroy()
                end
            end)()
        end)
    end)
    tab8:CreateButton("Crack lag",function()
        for i = 1, 1000 do
            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
        end
    end)
    tab8:CreateButton("Mini lag",function()
        for i = 1, 500 do
            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
        end
    end)
    tab8:CreateButton("MiniMinilag",function()
        for i = 1, 200 do
            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
        end
    end)
    tab8:CreateButton("Mini crash",function()
        local x = 0;
        repeat
            x += 1
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
        until x == 5000 
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
        wait();
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
    end)
    tab8:CreateButton("Crash Server",function()
        local x = 0;
        repeat
            x += 1
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
        until x == 20000 
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
        wait();
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
    end)
    tab5:CreateButton("Break Velocity",function()
        breakvelocity();
    end)
    tab5:CreateButton("Reset",function()
        player.Character:BreakJoints();
    end)
    tab5:CreateDropdown("Select Player", dropdown, function(state)
        -- Directly assign the selected option to `_G.tplayer`
        _G.tplayer = currentOption
    end)
    
    -- Utility function to refresh the player list
    local function GetList()
        dropdown = {}
        for _, player in pairs(game.Players:GetPlayers()) do
            table.insert(dropdown, player.Name) -- Populate the dropdown list with player names
        end
    end
    
    -- Refresh the dropdown menu
    tab5:CreateButton("Refresh Dropdown", function()
        GetList()
        -- Assuming your GUI library has a `Refresh` method for dropdowns:
        tab5:Refresh(dropdown) -- Replace `tab5` with the specific dropdown element object if needed
            spawn(function()
            GetList();
            slcplr:Refresh(dropdown);
        end);
    end)
    tab5:CreateButton("TP to Player",function()
        spawn(function()
            local p1 = game.Players.LocalPlayer.Character.HumanoidRootPart;
            p1.CFrame = game.Players[_G.tplayer].Character.HumanoidRootPart.CFrame;
            breakvelocity();
        end);
    end)
    tab5:CreateToggle("Spectate Player",function(state)
        -- Update watch state based on toggle
        getgenv().watch = state
        -- Define function to spectate the target player
        local function spectatePlayer()
            while getgenv().watch do
                local targetPlayer = game.Players:FindFirstChild(_G.tplayer)
                if targetPlayer and targetPlayer.Character then
                    workspace.CurrentCamera.CameraSubject = targetPlayer.Character
                end
                wait(0.01) -- Slight delay for smoother transitions
            end
        end
    end) 
    tab5:CreateToggle("Kill Player",function(state)
        local player = game.Players.LocalPlayer
        local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        
        -- Early exit if player doesn't have a valid root part
        if not rootPart then
            return
        end
    
        if state then
            -- Save original position for later use
            getgenv().originalPos = rootPart.CFrame  
    
            -- Activate the kill mode
            getgenv().killplr = true
            getgenv().breakv = true
    
            -- Loop to reset velocity continuously
            spawn(function()
                while getgenv().breakv do
                    pcall(function()
                        breakvelocity()  -- Ensure this function is defined elsewhere
                        game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", true)
                    end)
                    wait(0.01)  -- Reduced delay for faster updates
                end
            end)
    
            -- Main loop for targeting and attacking the player
            spawn(function()
                while getgenv().killplr do
                    local targetFound = false
                    for _, target in pairs(game.Workspace:GetChildren()) do
                        if target.Name == _G.tplayer and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
                            targetFound = true
                            
                            -- Move to target's position
                            pcall(function()
                                player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                            end)
                            
                            -- Perform multiple punches
                            for i = 1, 5 do
                                if not getgenv().killplr then break end
                                pcall(function()
                                    game:GetService("ReplicatedStorage").Events.Punch:FireServer(1, 0.02, 2)
                                end)
                                wait(0.01)  -- Reduced delay between punches
                            end
    
                            -- Use telekinesis quickly
                            local LookVector = game.Workspace.Camera.CFrame.LookVector
                            pcall(function()
                                game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, true)
                                game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, false)
                            end)
    
                            break  -- Exit loop after attacking the target
                        end
                    end
    
                    -- If no target found, wait briefly before checking again
                    if not targetFound then
                        wait(0.1)  -- Faster recheck for targets
                    end
                end
            end)
    
        else
            -- Deactivate kill mode
            getgenv().breakv = false
            getgenv().killplr = false
    
            -- Return the player to their original position if saved
            if getgenv().originalPos then
                pcall(function()
                    player.Character.HumanoidRootPart.CFrame = getgenv().originalPos
                end)
            end
    
            -- Reset velocity to normal
            pcall(function()
                breakvelocity()  -- Ensure this function is defined elsewhere
            end)
        end
    end)
    tab5:CreateToggle("Stick To Player",function()
        local player = game.Players.LocalPlayer
        local playerPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
    
        if not playerPos then return end -- Early exit if the player's position is not found
    
        if state then
            -- Enable the toggles for sticking functionality
            getgenv().loopgoto = true
            getgenv().breakv = true
    
            -- Break velocity continuously while sticking
            spawn(function()
                while getgenv().breakv do
                    pcall(function()
                        breakvelocity() -- Ensure this function is defined elsewhere
                    end)
                    wait(0.1) -- Prevent excessive CPU usage
                end
            end)
    
            -- Main loop for sticking to the target player
            spawn(function()
                while getgenv().loopgoto do
                    local targetPlayer = nil
    
                    -- Find the target player in Workspace
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v.Name == _G.tplayer and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            targetPlayer = v
                            break
                        end
                    end
    
                    if targetPlayer then
                        -- Move to the target player using CFrame
                        pcall(function()
                            player.Character.HumanoidRootPart.CFrame = targetPlayer.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        end)
                    end
    
                    wait(0.1) -- Prevent locking the thread and ensure responsiveness
                end
            end)
    
        else
            -- Disable the toggles for sticking functionality
            getgenv().breakv = false
            getgenv().loopgoto = false
    
            -- Reset the player's position to their original spot
            if playerPos then
                pcall(function()
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(playerPos.X, playerPos.Y, playerPos.Z)
                end)
            end
    
            -- Ensure velocity is reset when the state changes
            pcall(function()
                breakvelocity() -- Ensure this function is defined elsewhere
            end)
        end
    end)
    local platformSpawning = false  -- Flag to track if spawning is active
    local spawnInterval = 0.2  -- Time in seconds between platform spawns (faster spawning)
    local spawnHeight = 5  -- Height at which platforms will spawn above the character
    
    -- Function to spawn a platform at the player's position
    local function spawnPlatform(character)
        while platformSpawning do
            wait(spawnInterval)  -- Wait before spawning the next platform
            
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                -- Create a new part (platform) above the character
                local platform = Instance.new("Part")
                platform.Size = Vector3.new(10, 1, 10)  -- Size of the platform
                platform.Position = humanoidRootPart.Position + Vector3.new(0, spawnHeight, 0)  -- Position above the player
                platform.Anchored = true  -- Make sure the platform stays in place
                platform.CanCollide = true  -- Make the platform collide with other objects
                platform.Material = Enum.Material.SmoothPlastic  -- Platform material
                platform.Parent = workspace  -- Parent the platform to the workspace
                
                -- Optionally, you can add additional properties like color, transparency, etc.
                platform.BrickColor = BrickColor.new("Bright blue")
            end
        end
    end
    
    -- Button to toggle platform spawning
    tab9:CreateButton("Spawn Platform", function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        
        -- Toggle the spawning status
        platformSpawning = not platformSpawning
        
        -- If spawning is now active, start the loop
        if platformSpawning then
            -- Start spawning platforms
            spawnPlatform(character)
        end
    end)
    local player = game.Players.LocalPlayer
    tab5:CreateButton("Fling Player",function()
        if state then
            -- Activate Fling
            getgenv().fling = true
            local startPosition = player.Character.HumanoidRootPart.Position
            wait()
    
            local p1 = player.Character.HumanoidRootPart
    
            -- Update physical properties for all parts of the character
            for _, child in pairs(player.Character:GetDescendants()) do
                if child:IsA("BasePart") then
                    child.CustomPhysicalProperties = PhysicalProperties.new(math.huge, 0.3, 0.5)
                end
            end
    
            -- Add BodyAngularVelocity to the HumanoidRootPart
            local bambam = Instance.new("BodyAngularVelocity")
            bambam.Parent = p1
            bambam.AngularVelocity = Vector3.new(0, 1000, 0)
            bambam.MaxTorque = Vector3.new(0, math.huge, 0)
    
            -- Loop to manage the fling functionality
            spawn(function()
                while getgenv().fling do
                    task.wait(0.1)  -- Small wait to reduce CPU usage
                    pcall(function()
                        -- Check if target player exists and is alive
                        if _G.tplayer then
                            local targetPlayer = game.Players:FindFirstChild(_G.tplayer)
                            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                -- Fling the player towards the target
                                p1.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                            end
                        end
                    end)
    
                    -- Prevent the player from being affected by physics
                    for _, v in pairs(player.Character:GetChildren()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                            v.Massless = true
                            v.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end)
        else
            -- Deactivate Fling
            getgenv().fling = false
            wait(0.1)
    
            -- Reset character properties
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BodyAngularVelocity") then
                    v:Destroy()
                end
                if v:IsA("BasePart") or v:IsA("MeshPart") then
                    v.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
                    v.CanCollide = true
                    v.Massless = false
                end
            end
    
            -- Optional: Ensure velocity and physics reset
            if player.Character.HumanoidRootPart then
                player.Character.HumanoidRootPart.Velocity = Vector3.zero
            end
        end
    end)
    tab5:CreateToggle("Anti Tele", function(state)
        local playerName = _G.tplayer
        local targetPlayer = game:GetService("Players"):FindFirstChild(playerName)
        
        if not targetPlayer then
            warn("Player not found: " .. tostring(playerName))
            return
        end
    
        -- Manage the toggle state
        getgenv().antiTele = state
        
        if state then
            -- Start the anti-telekinesis loop
            spawn(function()
                while getgenv().antiTele do
                    pcall(function()
                        if targetPlayer.Character then
                            -- Disable telekinesis on the target
                            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(0, 0, 0), false, targetPlayer.Character)
                        else
                            warn("Character not found for player: " .. tostring(playerName))
                        end
                    end)
                    wait(0.1) -- Adjusted delay to reduce CPU/network usage
                end
            end)
        else
            -- Optionally, notify that the anti-telekinesis has been turned off
            print("Anti-Telekinesis disabled for: " .. tostring(playerName))
        end
    end)
    tab5:CreateToggle("Laser", function(state)
        local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
    
        -- Manage the toggle state
        getgenv().LaserL = state
    
        if state then
            -- Activate laser vision
            local part = event:InvokeServer(true)
    
            -- Ensure the laser part exists and track the target
            if part then
                spawn(function()
                    while getgenv().LaserL and _G.tplayer do
                        local targetPlayer = game.Players:FindFirstChild(_G.tplayer)
                        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            -- Update laser position to target
                            pcall(function()
                                part.Position = targetPlayer.Character.HumanoidRootPart.Position
                            end)
                        else
                            -- Optional: Log a warning if the target is not valid
                            warn("Target player or their HumanoidRootPart is missing")
                        end
                        wait(0.1) -- Adjust delay to optimize performance
                    end
    
                    -- Turn off laser vision if toggle is disabled
                    pcall(function()
                        event:InvokeServer(false)
                    end)
                end)
            else
                -- Log a warning if the laser part is not created
                warn("Laser part could not be initialized.")
            end
        else
            -- Disable laser vision
            pcall(function()
                event:InvokeServer(false)
            end)
        end
    end)
    tab5:CreateToggle("Laser From Sky", function(state)
        spawn(function()
            if state then
                -- Move the player's character high into the sky
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
                if not humanoidRootPart then
                    warn("HumanoidRootPart not found!")
                    return
                end
    
                -- Save current position and move to the sky
                local originalPosition = humanoidRootPart.CFrame
                humanoidRootPart.CFrame = CFrame.new(originalPosition.X, 5000, originalPosition.Z)
                wait(0.2)
                humanoidRootPart.Anchored = true
                getgenv().LaserL = true
    
                -- Laser vision loop
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local laserPart = event:InvokeServer(true)
    
                coroutine.wrap(function()
                    while getgenv().LaserL and laserPart and _G.tplayer do
                        task.wait()
                        local targetPlayer = game.Players:FindFirstChild(_G.tplayer)
                        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            -- Update laser part position to follow the target
                            laserPart.Position = targetPlayer.Character.HumanoidRootPart.Position
                        end
                    end
    
                    -- Turn off laser vision when toggled off
                    event:InvokeServer(false)
                end)()
            else
                -- Deactivate Laser From Sky
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
                if not humanoidRootPart then
                    warn("HumanoidRootPart not found!")
                    return
                end
    
                getgenv().LaserL = false
                humanoidRootPart.Anchored = false
                humanoidRootPart.CFrame = humanoidRootPart.CFrame - Vector3.new(0, 5000, 0)  -- Return to original position
                pcall(function()
                    breakvelocity() -- Ensure this function is defined
                end)
            end
        end)
    end)
    tab5:CreateToggle("Give Orbs", function(state)
        spawn(function()
            if state then
                getgenv().ORBGIVE = true
    
                while getgenv().ORBGIVE do
                    -- Ensure the target player and their character exist
                    local targetPlayer = game.Players:FindFirstChild(_G.tplayer)
                    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local targetHRP = targetPlayer.Character.HumanoidRootPart
                        
                        -- Move all orbs to the target player's HumanoidRootPart
                        for _, orb in pairs(game:GetService("Workspace").ExperienceOrbs:GetChildren()) do
                            if orb:IsA("BasePart") then
                                pcall(function()
                                    orb.CFrame = targetHRP.CFrame
                                end)
                            end
                        end
                    else
                        warn("Target player or their HumanoidRootPart not found!")
                    end
    
                    wait(0.1) -- Add a small delay to avoid excessive resource usage
                end
            else
                getgenv().ORBGIVE = false
            end
        end)
    end)
    tab5:CreateButton("Remove Gyro", function()
        -- Find the target player in the Workspace
        local targetPlayer = game:GetService("Workspace")[_G.tplayer]
        
        if targetPlayer and targetPlayer:FindFirstChild("HumanoidRootPart") and targetPlayer:FindFirstChild("Humanoid") then
            local hrp = targetPlayer.HumanoidRootPart
            local humanoid = targetPlayer.Humanoid
    
            -- Safely remove telekinesisGyro and telekinesisPosition if they exist
            pcall(function()
                if hrp:FindFirstChild("telekinesisGyro") then
                    hrp.telekinesisGyro:Destroy()
                end
                if hrp:FindFirstChild("telekinesisPosition") then
                    hrp.telekinesisPosition:Destroy()
                end
            end)
    
            -- Reset platform stand and adjust movement properties
            pcall(function()
                humanoid.PlatformStand = false
                humanoid.WalkSpeed = 200
                humanoid.JumpPower = 150
            end)
        else
            warn("Target player or required components not found!")
        end
    end)
    tab7:CreateToggle("Crack Aura", function(state)
        -- Toggle control
        getgenv().GroundCrackAuraActive = state
    
        -- Cooldown interval in seconds to manage event firing frequency
        local crackCooldown = 0.2
        local lastCrackTime = 0
    
        -- Function to activate Ground Crack with cooldown
        local function activateGroundCrack()
            if (tick() - lastCrackTime) >= crackCooldown then
                lastCrackTime = tick()
                pcall(function()
                    -- Fire GroundCrack event at a controlled rate
                    game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer()
                end)
            end
        end
    
        -- Manage aura activation with RunService Stepped
        if state then
            -- Enable aura
            getgenv().AuraConnection = game:GetService("RunService").Stepped:Connect(function()
                if getgenv().GroundCrackAuraActive then
                    activateGroundCrack()
                end
            end)
        else
            -- Disable the aura
            getgenv().GroundCrackAuraActive = false
            if getgenv().AuraConnection then
                getgenv().AuraConnection:Disconnect()
                getgenv().AuraConnection = nil
            end
        end
    end)
    tab7:CreateButton("Anti-Crash", function()
        -- Safe destroy function to handle potential errors
        local function safeDestroy(object)
            if object and object.Parent then
                object:Destroy()
            end
        end
    
        -- Attempt to destroy the shield effect in ClientStorage
        local clientStorage = game:FindFirstChild("ClientStorage")
        if clientStorage and clientStorage:FindFirstChild("Effects") then
            safeDestroy(clientStorage.Effects:FindFirstChild("Shield"))
        end
    
        -- Attempt to destroy the workspace effects
        local workspaceEffects = game.Workspace:FindFirstChild("Effects")
        safeDestroy(workspaceEffects)
    end)
    tab3:CreateButton("Infinite Yield",function()
        loadstring(game:HttpGet("https://pastebin.com/raw/aCmksbMy"))();
        end)
        tab3:CreateButton("Chat Spammer",function()
            loadstring(game:HttpGet(('https://raw.githubusercontent.com/ColdStep2/Chatdestroyer-Hub-V1/main/Chatdestroyer%20Hub%20V1'),true))()
        end)
        tab3:CreateButton("Chat Spoofer",function()
             loadstring(game:HttpGet(('https://pastebin.com/raw/djBfk8Li'),true))()
        end)
        -- Mild Crasher: Generates minimal lag, suitable for testing
    tab8:CreateButton("Mild Crash", function()
        for i = 1, 100 do
            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer()
        end
    end)
    
    -- Moderate Crasher: Slightly higher intensity
    tab8:CreateButton("Moderate Crash", function()
        for i = 1, 500 do
            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer()
        end
    end)
    
    -- Strong Crasher: Intense action that may cause noticeable lag
    tab8:CreateButton("Strong Crash", function()
        for i = 1, 1000 do
            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer()
        end
    end)
    
    -- Extreme Crasher: Likely to crash weaker devices or create significant lag
    tab8:CreateButton("Extreme Crash", function()
        for i = 1, 5000 do
            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer()
        end
    end)
    
    -- Devastating Crasher: Pushes the limits; may crash the server
    tab8:CreateButton("Devastating", function()
        for i = 1, 20000 do
            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer()
        end
    end)
    
    -- Server Killer: Very high intensity; likely to crash the server or freeze the client
    tab8:CreateButton("Server Killer", function()
        while true do
            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer()
        end
    end)
    tab2:CreateToggle("Thug Farm", function(state)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:FindFirstChild("HumanoidRootPart")
    
        if state then
            -- Save player's original position
            if rootPart then
                thugX, thugY, thugZ = rootPart.Position.X, rootPart.Position.Y, rootPart.Position.Z
            end
            getgenv().Thug = true
    
            -- Farming loop
            spawn(function()
                while getgenv().Thug and rootPart and character:FindFirstChild("Humanoid") do
                    pcall(function()
                        for _, thug in pairs(game.Workspace:GetChildren()) do
                            if thug:IsA("Model") and thug.Name == "Thug" 
                            and thug:FindFirstChild("Humanoid") and thug.Humanoid.Health > 0 
                            and thug:FindFirstChild("HumanoidRootPart") then
                                -- Move player near the Thug and punch
                                rootPart.CFrame = thug.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                                wait(0.3) -- Slight delay between punches
                            end
                        end
                    end)
                    wait(0.5) -- Wait to prevent excessive CPU usage
                end
            end)
        else
            -- Stop farming and return to original position
            getgenv().Thug = false
            spawn(function()
                wait(0.2)
                if rootPart then
                    rootPart.CFrame = CFrame.new(thugX, thugY, thugZ)
                end
            end)
        end
    end)
    tab2:CreateToggle("Police KillAura", function(state)
        local player = game.Players.LocalPlayer -- Ensure we are working with the correct player
        local character = player.Character or player.CharacterAdded:Wait() -- Get player's character
        
        -- Check if the player's character exists before proceeding
        if character and character:FindFirstChild("HumanoidRootPart") then
            getgenv().PoliceAura = state -- Set the state globally to control the kill aura loop
    
            if state then
                -- Start Kill Aura loop
                coroutine.wrap(function()
                    while getgenv().PoliceAura do
                        wait(0.2) -- Adjust the wait time for performance and responsiveness
                        pcall(function()
                            -- Loop through all models in the workspace to find "Police" models
                            for _, v in pairs(game.Workspace:GetChildren()) do
                                -- Check if the model is a "Police" with a valid humanoid
                                if v:IsA("Model") and v.Name == "Police" and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                                    local humanoid = v.Humanoid
                                    local policeHRP = v.HumanoidRootPart
                                    local playerHRP = character:FindFirstChild("HumanoidRootPart")
                                    
                                    -- Check if the humanoid is alive and if the police is within a certain range
                                    if humanoid.Health > 0 and (playerHRP.Position - policeHRP.Position).Magnitude <= 10 then
                                        -- Fire the Punch event to damage the police
                                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                                    end
                                end
                            end
                        end)
                    end
                end)()
            else
                -- Stop Kill Aura when toggled off
                getgenv().PoliceAura = false
            end
        else
            warn("Player's character or HumanoidRootPart not found!")
        end
    end)
    tab2:CreateToggle("Civilian KillAura", function(state)
        local player = game.Players.LocalPlayer -- Ensure we are working with the correct player
        local character = player.Character or player.CharacterAdded:Wait() -- Get player's character
    
        -- Check if the player's character exists before proceeding
        if character and character:FindFirstChild("HumanoidRootPart") then
            getgenv().CivilianAura = state -- Set the state globally to control the kill aura loop
    
            if state then
                -- Start Kill Aura loop
                coroutine.wrap(function()
                    while getgenv().CivilianAura do
                        wait(0.2) -- Adjust the wait time for performance and responsiveness
                        pcall(function()
                            -- Loop through all models in the workspace to find "Civilian" models
                            for _, v in pairs(game.Workspace:GetChildren()) do
                                -- Check if the model is a "Civilian" with a valid humanoid and HumanoidRootPart
                                if v:IsA("Model") and v.Name == "Civilian" and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                                    local humanoid = v.Humanoid
                                    local civilianHRP = v.HumanoidRootPart
                                    local playerHRP = character:FindFirstChild("HumanoidRootPart")
                                    
                                    -- Check if the humanoid is alive and if the civilian is within a certain range
                                    if humanoid.Health > 0 and (playerHRP.Position - civilianHRP.Position).Magnitude <= 10 then
                                        -- Fire the Punch event to damage the civilian
                                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                                    end
                                end
                            end
                        end)
                    end
                end)()
            else
                -- Stop Kill Aura when toggled off
                getgenv().CivilianAura = false
            end
        else
            warn("Player's character or HumanoidRootPart not found!")
        end
    end)
    tab2:CreateToggle("Thug Kill Aura", function(state)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:FindFirstChild("HumanoidRootPart")
    
        if state then
            getgenv().ThugAura = true -- Enable the kill aura
    
            -- Start the kill aura loop
            spawn(function()
                while getgenv().ThugAura and rootPart and character:FindFirstChild("Humanoid") do
                    pcall(function()
                        for _, thug in pairs(game.Workspace:GetChildren()) do
                            if thug:IsA("Model") and thug.Name == "Thug" 
                            and thug:FindFirstChild("Humanoid") and thug.Humanoid.Health > 0 
                            and thug:FindFirstChild("HumanoidRootPart") then
                                -- Check if the thug is within range
                                local thugHRP = thug.HumanoidRootPart
                                if (rootPart.Position - thugHRP.Position).Magnitude <= 10 then
                                    -- Attack the thug
                                    game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                                end
                            end
                        end
                    end)
                    wait(0.2) -- Slight delay to reduce CPU usage
                end
            end)
        else
            getgenv().ThugAura = false -- Disable the kill aura
        end
    end)
    
    tab9:CreateButton("Ban batdude", "Bans batdude17 from the server", function()
        -- Services
        local Players = game:GetService("Players")
    
        -- Target player to ban
        local targetName = "@batdude17" -- Replace with the exact username
    
        -- Function to ban the target player
        local function banPlayerByName(name)
            local targetPlayer = Players:FindFirstChild(name)
            if targetPlayer then
                targetPlayer:Kick("You have been banned from this server for exploiting the rules.")
                print("Player banned:", targetPlayer.Name)
            else
                warn("Player not found:", name)
            end
        end
    
        -- Ban the specified player
        banPlayerByName(targetName)
    end)
    tab9:CreateButton("WIIIITAYIIIW", "Bans @WIIIITAYIIIW from the server", function()
        -- Services
        local Players = game:GetService("Players")
    
        -- Target player to ban
        local targetName = "@WIIIITAYIIIW" -- Replace with the exact username
    
        -- Function to ban the target player
        local function banPlayerByName(name)
            local targetPlayer = Players:FindFirstChild(name)
            if targetPlayer then
                targetPlayer:Kick("You have been banned from this server for exploiting the rules.")
                print("Player banned:", targetPlayer.Name)
            else
                warn("Player not found:", name)
            end
        end
    
        -- Ban the specified player
        banPlayerByName(targetName)
    end)
    
    createDropdownMenu()
    tab:Show()
    end)


    GUISection:NewButton("Tools","", function(state)
        local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/mini%20tools.lua"))()
    end)
    GUISection:NewButton("Custom Executor","", function(state)
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
        TitleBar.Text = "Lua Executor (Shadow Recon)"
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
    end)



-----------------------------------------------------------------------------------------------------------------------

-- Add the Super Mega Crash Button and J Keybind
ASection:NewButton("Super Mega Crash J", "Activates the Super Mega Crash function", function()
    activateSuperMegaCrash()
end)

-- Bind the J Key to Activate the Super Mega Crash
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.J then
        activateSuperMegaCrash()
    end
end)

-- Super Mega Crash Function
function activateSuperMegaCrash()
    local maxIterations = 25000 -- Max iterations for the crash effect
    spawn(function()
        for i = 1, maxIterations do
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true")
        end
    end)

    spawn(function()
        for i = 1, maxIterations do
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true")
        end
    end)

    spawn(function()
        for i = 1, maxIterations do
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true")
        end
    end)

    -- Ensure the event is turned off after activation
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false)
    wait()
    game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false)
end


ASection:NewToggle("🌌 Psylock Annihilator 🌟", "Toggle a telekinesis aura that locks onto targets and kills them", function(state)
    getgenv().teleaura = state
    if state then
        -- Enable Telekinesis Lock Aura
        task.spawn(function()
            while getgenv().teleaura do
                -- Use minimal waiting to prevent lag
                local success, err = pcall(function()
                    local LookVector = game.Workspace.CurrentCamera.CFrame.LookVector
                    local replicatedStorage = game:GetService("ReplicatedStorage")
                    local toggleEvent = replicatedStorage:WaitForChild("Events"):WaitForChild("ToggleTelekinesis")

                    -- Trigger the telekinesis event
                    local result = toggleEvent:InvokeServer(LookVector, true)

                    -- Check if a target was grabbed
                    if result and result.Target and result.Target.Parent then
                        -- Attempt to kill the target
                        local targetCharacter = result.Target.Parent
                        local humanoid = targetCharacter:FindFirstChild("Humanoid")
                        
                        if humanoid then
                            humanoid.Health = 0 -- Instantly kill the target
                        end
                    end

                    toggleEvent:InvokeServer(LookVector, false)
                end)

                if not success then
                    warn("Error in Psychic Lock Aura: ", err)
                end

                task.wait(0.1) -- Wait to avoid overloading the system
            end
        end)
    else
        -- Disable Telekinesis Lock Aura
        getgenv().teleaura = false
    end
end)



ASection:NewToggle("Psychic Lock Aura", "Toggle a telekinesis aura that locks onto targets", function(state)
    getgenv().teleaura = state
    if state then
        -- Enable Telekinesis Lock Aura
        task.spawn(function()
            while getgenv().teleaura do
                -- Use minimal waiting to prevent lag
                local success, err = pcall(function()
                    local LookVector = game.Workspace.CurrentCamera.CFrame.LookVector
                    local replicatedStorage = game:GetService("ReplicatedStorage")
                    local toggleEvent = replicatedStorage:WaitForChild("Events"):WaitForChild("ToggleTelekinesis")

                    -- Trigger the telekinesis event
                    toggleEvent:InvokeServer(LookVector, true)
                    toggleEvent:InvokeServer(LookVector, false)
                end)

                if not success then
                    warn("Error in Psychic Lock Aura: ", err)
                end

                task.wait(0.1) -- Wait to avoid overloading the system
            end
        end)
    else
        -- Disable Telekinesis Lock Aura
        getgenv().teleaura = false
    end
end)







SSection:NewToggle("Infinite Super Rapid Punch", "Punches infinitely until disabled", function(state)
    if state then
        -- Activate Infinite Punch
        getgenv().superrapid = true

        spawn(function()
            while getgenv().superrapid do
                pcall(function()
                    game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                end)
                task.wait(0.01) -- Extremely fast punching
            end
        end)
    else
        -- Deactivate Infinite Punch
        getgenv().superrapid = false
    end
end)



local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PunchEvent = ReplicatedStorage.Events.Punch

-- Function to handle rapid punching
local function handleRapidPunch(toggleState, punchType, duration, power, repetitions)
    if toggleState then
        getgenv().rapidState = true
        local function onInputEnded(inputObject, gameProcessedEvent)
            if gameProcessedEvent then return end
            if getgenv().rapidState and inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                spawn(function()
                    for _ = 1, repetitions do
                        PunchEvent:FireServer(punchType, duration, power)
                        task.wait(0.05) -- Small delay between punches to reduce lag
                    end
                end)
            end
        end
        -- Connect the input event
        UserInputService.InputEnded:Connect(onInputEnded)
    else
        getgenv().rapidState = false
    end
end

-- Mini Rapid Punch Toggle
SSection:NewToggle("Mini Rapid Punch", "", function(state)
    handleRapidPunch(state, 2, 0.1, 4, 1)
end)

-- Rapid Punch Toggle
SSection:NewToggle("Rapid Punch", "", function(state)
    handleRapidPunch(state, 0, 0.2, 1, 7)
end)

-- Rapid Heavy Punch Toggle
SSection:NewToggle("Rapid Heavy Punch", "", function(state)
    handleRapidPunch(state, 0.4, 0.1, 1, 15)
end)

-- Godly Rapid Punch Toggle
SSection:NewToggle("Godly Rapid Punch", "", function(state)
    if state then
        getgenv().superrapid = true
        local function onInputEnded(inputObject, gameProcessedEvent)
            if gameProcessedEvent or not getgenv().superrapid then return end
            if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                spawn(function()
                    local punchEvent = game:GetService("ReplicatedStorage").Events.Punch
                    for i = 1, 100 do -- Adjust the number of punches here
                        punchEvent:FireServer(0, 0.1, 1)
                    end
                end)
            end
        end
        UserInputService.InputEnded:Connect(onInputEnded)
    else
        getgenv().superrapid = false
    end
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Define the levels for ground crack strength
local levels = {
    {name = "Light", delay = 0.5},
    {name = "Medium", delay = 0.3},
    {name = "Heavy", delay = 0.1},
    {name = "Insane", delay = 0.05}
}

local currentLevel = 1 -- Default to Light level
local crackLoop = nil -- Variable to store the coroutine
local isToggled = false -- Track the toggle state

-- Dropdown to select crack strength
ASection:NewDropdown("Crack Strength", "Select ground crack strength", {"Light", "Medium", "Heavy", "Insane"}, function(selected)
    for i, level in ipairs(levels) do
        if level.name == selected then
            currentLevel = i
            print("Strength set to:", levels[currentLevel].name)
            break
        end
    end
end)

-- Toggle to enable or disable ground crack effect
ASection:NewToggle("Ground Crack Effect", "Toggle annoying ground cracks", function(state)
    isToggled = state -- Update the toggle state

    if isToggled then
        -- Start the effect when toggled on
        if crackLoop == nil then
            crackLoop = coroutine.create(function()
                while isToggled do
                    local level = levels[currentLevel]
                    ReplicatedStorage.Events.GroundCrack:FireServer() -- Trigger ground crack effect
                    wait(level.delay) -- Wait based on the selected strength delay
                end
            end)
            coroutine.resume(crackLoop)
        end
    else
        -- Stop the effect when toggled off
        if crackLoop then
            -- Explicitly stop the coroutine
            crackLoop = nil -- Terminate the coroutine
        end
    end
end)
ASection:NewButton("Give Bomb", "", function(state)
    loadstring(game:HttpGet('https://pastebin.com/raw/861SQXj7'))()
end);

-- Variables
local tagDisablerEnabled = false -- Toggle state

-- Function to disable tags
local function disableTags()
    local Chat = game:GetService("Chat")
    -- Force disable chat tags for the player
    local chatModules = Chat:FindFirstChild("ClientChatModules")
    if chatModules then
        local tagHandler = chatModules:FindFirstChild("ChatSettings")
        if tagHandler then
            local settings = require(tagHandler)
            settings.PlayerDisplayNamesEnabled = not tagDisablerEnabled -- Toggle based on state
        end
    end
end

-- Declare a variable to track the state of the tag disabler
local tagDisablerEnabled = false

-- Function to disable chat tags in real-time
local function disableTags()
    -- Access the chat service
    local ChatService = game:GetService("Chat")
    
    -- Disable tags by overriding the default format or manipulating chat message text
    -- This intercepts the chat message and removes the tag
    hookfunction(ChatService.FilterStringForBroadcast, function(message, player)
        -- Remove any tags from the message by replacing it with plain text
        return message:match("%S+.*") -- This keeps the message without the tags (you can refine this regex if needed)
    end)
    
    -- Disable chat tags for all existing players (this will run for the current players)
    for _, player in pairs(game.Players:GetPlayers()) do
        -- Clear the tags from the player's chat
        player.Chatted:Connect(function(message)
            if tagDisablerEnabled then
                -- Modify the message to remove any tags (e.g., names, groups, etc.)
                message = message:gsub("tag_pattern", "")  -- Replace 'tag_pattern' with actual tag patterns you want to hide
            end
        end)
    end
end

ASection:NewButton("Teleport To Middle", "Click to teleport to the middle without using the keybind", function()
    if (_G.bring == true) then
        -- Destroy telekinesis and teleport the specified player
        local targetPlayer = game:GetService("Workspace")[_G.teleportplayer]
        if targetPlayer and targetPlayer:FindFirstChild("HumanoidRootPart") and targetPlayer.HumanoidRootPart:FindFirstChild("telekinesisPosition") then
            targetPlayer.HumanoidRootPart.telekinesisPosition:Destroy()
        end
        if targetPlayer and targetPlayer:FindFirstChild("HumanoidRootPart") then
            targetPlayer.HumanoidRootPart.CFrame = CFrame.new(-376, 94, 91)
        end
        wait(0.2)
        -- Toggle telekinesis for the target player
        game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[_G.teleportplayer].Character)
    else
        -- Teleport the local player
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-376, 94, 91)
        end
    end
    -- Call the breakvelocity function to handle any post-teleport adjustments
    breakvelocity()
end)

local mouse = game.Players.LocalPlayer:GetMouse()


-- Get VirtualInputManager
local vim = game:GetService("VirtualInputManager")

-- Create a table to store click delays for each key
local clickDelays = {
    V = 0.05,  -- Default delay (20 clicks per second)
    C = 0.1,   -- Default delay (10 clicks per second)
    Z = 0.2    -- Default delay (5 clicks per second)
}

-- Function to create an Auto Clicker toggle
local function createAutoClickToggle(key, displayName)
    ASection:NewToggle(displayName, "Automatically presses the " .. key .. " key repeatedly.", function(state)
        getgenv()["autoClick" .. key] = state  -- Store toggle state

        if state then
            print(displayName .. " activated.")  -- Notify user
            task.spawn(function()
                while getgenv()["autoClick" .. key] do
                    pcall(function()
                        vim:SendKeyEvent(true, Enum.KeyCode[key], false, game)  -- Press key
                        vim:SendKeyEvent(false, Enum.KeyCode[key], false, game) -- Release key
                    end)

                    task.wait(clickDelays[key])  -- Use the adjustable delay

                    -- Instantly stop if the toggle is turned off
                    if not getgenv()["autoClick" .. key] then break end
                end
            end)
        else
            print(displayName .. " deactivated.")  -- Notify user
        end
    end)

    -- Create a slider to adjust the click delay
    ASection:NewSlider("Click Speed: " .. key, "Adjust click delay for " .. key, 1, 100, clickDelays[key] * 100, function(value)
        clickDelays[key] = value / 100  -- Convert from slider value to seconds
    end)
end

-- Create Auto Clicker Toggles with Adjustable Speed
createAutoClickToggle("V", "Auto Clicker 'V'")  
createAutoClickToggle("C", "Auto Clicker 'C'")  
createAutoClickToggle("Z", "Auto Clicker 'Z'")  




-- Replace "ASection" with the actual section or object name in your script that defines this button

ASection:NewButton("Kick Cheater", "Kick XaoLingChopStick for cheating", function()
    local playerName = "XaoLingChopStick" -- The name of the player to kick

    -- Find the player with the specified name
    local player = game.Players:FindFirstChild(playerName)
    
    -- Check if the player exists and then kick them
    if player then
        player:Kick("You have been kicked for cheating and making the game unfair for others.")
        print(playerName .. " has been kicked for cheating.")
    else
        print("Player " .. playerName .. " not found.")
    end
end)
    
    ASection:NewToggle("Give Orbs (10k XP)", "", function(state)
        spawn(function()
            if state then
                getgenv().ORBGIVE = true
                local localPlayer = game.Players.LocalPlayer  -- Get the local player
        
                while getgenv().ORBGIVE do
                    if localPlayer and localPlayer.Character then
                        local hrp = localPlayer.Character:FindFirstChild("HumanoidRootPart")  -- Find the HumanoidRootPart of the local player
                        if hrp then
                            local targetPosition = hrp.Position  -- Store the target position
        
                            -- Move all orbs to the target position directly
                            local orbs = game:GetService("Workspace").ExperienceOrbs:GetChildren()
                            local orbCount = 0  -- To keep track of how many orbs are being "collected"
        
                            for _, orb in ipairs(orbs) do
                                if orb:IsA("Part") and orb.Parent then  -- Ensure it's a valid part and has a parent
                                    -- Move the orb above the player's position
                                    orb.CFrame = CFrame.new(targetPosition) * CFrame.new(0, 5, 0)  -- Adjust height if needed
                                    orbCount = orbCount + 1  -- Count how many orbs are moved
                                    
                                    -- Optionally simulate collection by triggering the orb's collection event
                                    -- This will depend on how the game handles orb collection
                                    pcall(function()
                                        -- Assuming the orb fires a Touched event or a custom event to grant XP
                                        if orb:FindFirstChild("Touched") then
                                            orb.Touched:Fire()  -- Trigger the Touched event (if applicable)
                                        end
                                        -- Or you could directly invoke an event related to XP gain, e.g.:
                                        -- game:GetService("ReplicatedStorage").Events.GiveXP:FireServer(1000)
                                    end)
        
                                    -- Optional: Break early if we are close to the 10k XP goal
                                    if orbCount >= 10 then
                                        break  -- Once we move 10 orbs, stop
                                    end
                                end
                            end
    
                            -- If we want to ensure 10k XP, we may simulate or create new orbs, depending on how the game works.
                            -- Adjust the orb collection logic or loop to simulate 10,000 XP.
    
                        end
                    end
                    task.wait(0.1)  -- Use a minimal wait to avoid overwhelming the server
                end
            else
                getgenv().ORBGIVE = false  -- Stop giving orbs
            end
        end)
    end)
    
-- Creating a fast toggle with a cool name
ASection:NewToggle("Teleport Shield", "Activate shield against teleport effects", function(state)
    -- Set the local player variable
    local player = game.Players.LocalPlayer

    -- Toggle anti-teleport functionality in a separate coroutine
    spawn(function()
        getgenv().antiTele = state
        while getgenv().antiTele do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                -- Activate the anti-teleport using the ReplicatedStorage event
                game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(0, 0, 0), false, player.Character)
            else
                warn("Character or HumanoidRootPart not found.")
            end
            wait(0.02) -- Reduced wait time for faster response
        end
    end)
end)
    
    -- Variables for ESP settings
    getgenv().OutlineColor = Color3.new(1, 0, 1) -- Default color is pink
    getgenv().ESPEnabled = false
    
    -- Function to add ESP to a player
    local function addESP(player)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Create Highlight for outline ESP
            local highlight = Instance.new("Highlight")
            highlight.Parent = player.Character
            highlight.FillTransparency = 1 -- Fully transparent fill
            highlight.OutlineTransparency = 0 -- No transparency on outline
            highlight.OutlineColor = getgenv().OutlineColor -- Set outline color
    
            -- Create a BillboardGui for player name above the head
            local billboard = Instance.new("BillboardGui")
            billboard.Parent = player.Character:WaitForChild("Head")
            billboard.Size = UDim2.new(1, 0, 1, 0)
            billboard.Adornee = player.Character.Head
            billboard.SizeOffset = Vector2.new(0, 2) -- Adjust height offset
    
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Text = player.Name
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextColor3 = Color3.new(1, 1, 1) -- White text
            nameLabel.Font = Enum.Font.SourceSans
            nameLabel.TextSize = 14
            nameLabel.Parent = billboard
        end
    end
    
    -- Function to remove ESP from a player
    local function removeESP(player)
        if player.Character then
            -- Remove Highlight
            local highlight = player.Character:FindFirstChildOfClass("Highlight")
            if highlight then
                highlight:Destroy()
            end
            
            -- Remove BillboardGui
            local billboard = player.Character:FindFirstChildOfClass("BillboardGui")
            if billboard then
                billboard:Destroy()
            end
        end
    end
    
    -- Toggle for displaying ESP
    ASection:NewToggle("Toggle Player ESP", "Display an outline around all players except yourself", function(state) 
        if state then
            getgenv().ESPEnabled = true
    
            -- Add ESP to all players except the local player
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    addESP(player)
                end
            end
    
            -- Detect new players and add ESP
            game.Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(character)
                    if player ~= game.Players.LocalPlayer then
                        addESP(player)
                    end
                end)
            end)
    
        else
            getgenv().ESPEnabled = false
    
            -- Remove ESP from all players
            for _, player in pairs(game.Players:GetPlayers()) do
                removeESP(player)
            end
        end
    end)
    
    -- Create a color picker for the ESP outline color
    ASection:NewColorPicker("Outline Color", "Pick the color for player outlines", Color3.new(1, 0, 1), function(color)
        getgenv().OutlineColor = color -- Set the new outline color
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local highlight = player.Character:FindFirstChildOfClass("Highlight")
                if highlight then
                    highlight.OutlineColor = getgenv().OutlineColor -- Update the outline color in real-time
                end
            end
        end
    end)
    
    -- Create additional effects toggle for ESP visibility through walls
    ASection:NewToggle("Show Through Walls", "Enable ESP visibility through walls", function(state)
        getgenv().ESPThroughWalls = state -- Set state for ESP through walls
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local highlight = player.Character:FindFirstChildOfClass("Highlight")
                if highlight then
                    highlight.Enabled = state -- Toggle visibility
                end
            end
        end
    end)
    
    -- Create a toggle to turn off all ESP
    ASection:NewToggle("Turn Off All ESP", "Disable ESP for all players", function(state) 
        if state then
            -- Remove ESP from all players
            for _, player in pairs(game.Players:GetPlayers()) do
                removeESP(player)
            end
            getgenv().ESPEnabled = false -- Ensure ESP is disabled
        end
    end)

    local player = game.Players.LocalPlayer
    
    local debounce = false -- Prevents spam activation
    
    local noclip = false
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Function to toggle noclip
local function toggleNoclip()
    noclip = not noclip
    print("Noclip:", noclip)

    while noclip do
        task.wait() -- Prevents freezing
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false -- Disables collisions
            end
        end
    end
end

-- Keybind setup (Kavo-style)
KSection:NewKeybind("Toggle Noclip", "", Enum.KeyCode.L, function()
    toggleNoclip()
end)

    KSection:NewKeybind("Toggle UI", "", Enum.KeyCode.Y, function()
        Library:ToggleUI();
    end);
   
    KSection:NewKeybind("Carry Player", "", Enum.KeyCode.H, function()
        if (_G.CToggle == false) then
            spawn(function()
                getNearPlayer(99);
                wait();
                _G.CToggle = true;
                getgenv().CarryP = true;
                while CarryP do
                    wait();
                    spawn(function()
                        for i, v in pairs(plrlist) do
                            if (v == player) then
                            else
                                Xt = player.Character.HumanoidRootPart.Position['X'];
                                Yt = player.Character.HumanoidRootPart.Position['Y'];
                                Zt = player.Character.HumanoidRootPart.Position['Z'];
                                game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition.Position = Vector3.new(Xt, Yt + 8, Zt + 5);
                            end
                        end
                    end);
                end
            end);
        else
            spawn(function()
                _G.CToggle = false;
                plrlist = {};
                getgenv().CarryP = false;
            end);
        end
    end);


    KSection:NewKeybind("Carry NPC", "", Enum.KeyCode['O'], function()
        local player = game.Players.LocalPlayer
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
        if (_G.CToggle == false) then
            task.spawn(function()
                getNearPlayer(99)
                task.wait()
                _G.CToggle = true
                getgenv().CarryP = true
    
                while CarryP and player and player.Character do
                    task.wait()
                    task.spawn(function()
                        for i, v in ipairs(plrlist) do
                            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                                local Xt = player.Character.HumanoidRootPart.Position.X
                                local Yt = player.Character.HumanoidRootPart.Position.Y
                                local Zt = player.Character.HumanoidRootPart.Position.Z
                                local targetRoot = v.Character:FindFirstChild("HumanoidRootPart")
                                if targetRoot then
                                    targetRoot.CFrame = CFrame.new(Vector3.new(Xt, Yt + 8, Zt + 5))
                                end
                            end
                        end
                    end)
                end
            end)
        else
            task.spawn(function()
                _G.CToggle = false
                plrlist = {}
                getgenv().CarryP = false
            end)
        end
    end)
    
    
    KSection:NewKeybind("Telekinesis Lock", "", Enum.KeyCode['T'], function()
        spawn(function()
            -- Define a Neon Part or UI element to change color
            local neonPart = game.Workspace:FindFirstChild("NeonPart")  -- Replace with your part's name
            local neonColors = {Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255)}
    
            -- Change the color of the NeonPart if it exists
            if neonPart then
                for _, color in ipairs(neonColors) do
                    neonPart.BrickColor = BrickColor.new(color)
                    neonPart.Material = Enum.Material.Neon
                    wait(0.1) -- Adjust the delay for a smoother transition
                end
            end
    
            -- Execute the original Telekinesis logic
            local LookVector = game.Workspace.Camera.CFrame.LookVector;
            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, true);
            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, false);
        end)
    end)
    
    KSection:NewKeybind("Enhanced Telekinesis Kill", "Targets nearby players and neutralizes them", Enum.KeyCode.G, function()
        spawn(function()
            -- Get players near 99 studs
            getNearPlayer(99)
            
            for _, targetPlayer in pairs(plrlist) do
                if targetPlayer ~= player then
                    spawn(function()
                        -- Attempt to destroy their Neck (critical hit)
                        local character = targetPlayer.Character
                        if character and character:FindFirstChild("Head") and character.Head:FindFirstChild("Neck") then
                            character.Head.Neck:Destroy()
                        end
                        
                        -- Additional: Forcefully immobilize
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0) -- Sends them far off the map
                        end
                        
                        -- Invoke Telekinesis with aggressive parameters
                        spawn(function()
                            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(
                                Vector3.new(999, 999, 999), -- High force vector
                                true, -- Enable telekinesis
                                character
                            )
                        end)
    
                        -- Final fallback: Attempt to remove Humanoid
                        wait(0.1) -- Minor delay for cleanup
                        if character and character:FindFirstChild("Humanoid") then
                            character.Humanoid:Destroy()
                        end
                    end)
                end
            end
            
            -- Clear player list after action
            plrlist = {}
        end)
    end)    
    KSection:NewKeybind("Toggle UI", "", Enum.KeyCode.Y, function()
        Library:ToggleUI();
    end);
    KSection:NewKeybind("Release Telekinesis", "", Enum.KeyCode['C'], function()
        plrlist = {};
        Players = game:GetService("Players");
        for i, player in pairs(Players:GetPlayers()) do
            spawn(function()
                game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[player.Name].Character);
            end);
        end
    end);
    KSection:NewKeybind("Teleport To Motel", "", Enum.KeyCode.Z, function()
      if (_G.bring == true) then
            game:GetService("Workspace")[_G.teleportplayer].HumanoidRootPart.telekinesisPosition:Destroy()
            game:GetService("Workspace")[_G.teleportplayer].HumanoidRootPart.CFrame = CFrame.new(-1745, 95, -1530);
            wait(0.2)
            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[_G.teleportplayer].Character);
        else
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1745, 95, -1530);
        end
        breakvelocity();
    end);
    KSection:NewKeybind("Teleport To Middle", "", Enum.KeyCode.V, function()
     if (_G.bring == true) then
            game:GetService("Workspace")[_G.teleportplayer].HumanoidRootPart.telekinesisPosition:Destroy()
            game:GetService("Workspace")[_G.teleportplayer].HumanoidRootPart.CFrame = CFrame.new(-376, 94, 91);
            wait(0.2)
            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[_G.teleportplayer].Character);
        else
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-376, 94, 91);
        end
        breakvelocity();
    end);
    GSection:NewToggle("Enable Orbit (Really funny to use)", "", function(state)
    getgenv().cua = state
    end);
    KSection:NewKeybind("Toggle Fly", "Press to toggle fly", Enum.KeyCode.J, function()
        fly()
    end)
    
KSection:NewKeybind("MetalSkin", "", Enum.KeyCode['LeftShift'], function()
	if (_G.metalskin == false) then
		game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", true);
		_G.metalskin = true;
	else
		game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", false);
		_G.metalskin = false;
	end
end);
KSection:NewKeybind("Telekinesis Lock", "", Enum.KeyCode['T'], function()
	spawn(function()
		local LookVector = game.Workspace.Camera.CFrame.LookVector;
		game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, true);
		game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, false);
	end);
end);
KSection:NewKeybind("Telekinesis kill", "", Enum.KeyCode['G'], function()
	spawn(function()
		getNearPlayer(99);
		for i, v in pairs(plrlist) do
			if (v == player) then
			else
				spawn(function()
					v.Head.Neck:Destroy();
					plrlist = {};
					wait(0.2);
					spawn(function()
						game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
					end);
				end);
			end
		end
	end);
end);
KSection:NewKeybind("Release Telekinesis", "", Enum.KeyCode['C'], function()
	plrlist = {};
	Players = game:GetService("Players");
	for i, player in pairs(Players:GetPlayers()) do
		spawn(function()
			game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[player.Name].Character);
		end);
	end
end);
    
    GSection:NewTextBox("Distance", "", function(txt)
      getgenv().size = txt
    end)
    
    GSection:NewTextBox("Heigh", "", function(txt)
        getgenv().heigh = txt
    end)
    GSection:NewButton("Infinite Yield", "", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end);
    GSection:NewButton("Chat Spammer", "", function()
        loadstring(game:HttpGet(('https://raw.githubusercontent.com/ColdStep2/Chatdestroyer-Hub-V1/main/Chatdestroyer%20Hub%20V1'),true))()
    end);
    GSection:NewButton("Dex/Explorer", "", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end);
    GSection:NewButton("Chat Spoofer", "", function()
        loadstring(game:HttpGet(('https://pastebin.com/raw/djBfk8Li'),true))()
    end);
    GSection:NewButton("Chat bypasser", "", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/synnyyy/synergy/additional/betterbypasser", true))()
    end)
    
    _G.CToggle = false;
    _G.metalskin = false;
    _G.LOCALPLAYER = game.Players.LocalPlayer.Name;
    _G.bring = false;
    player = game.Players.LocalPlayer;
    breakvelocity = function()
        spawn(function()
            local BeenASecond, V3 = false, Vector3.new(0, 0, 0);
            delay(1, function()
                BeenASecond = true;
            end);
            while not BeenASecond do
                for _, v in ipairs(player.Character:GetDescendants()) do
                    if v.IsA(v, "BasePart") then
                        v.Velocity, v.RotVelocity = V3, V3;
                    end
                end
                wait();
            end
        end);
    end;
    plrlist = {};
    plrnum = 0;
    getNearPlayer = function(maxDistance)
        pcall(function()
            if (player and player.Character) then
                local playerLocation = player.Character.HumanoidRootPart.Position;
                for i, v in pairs(game.Players:GetChildren()) do
                    if (v.Character and (v.Character.Health ~= 0)) then
                        local location = v.Character.HumanoidRootPart.Position;
                        if (((location - playerLocation).Magnitude <= maxDistance) and (v.Character.Health ~= 0)) then
                            pcall(function()
                                if (v == player) then
                                else
                                    local teleexist = game:GetService("Workspace")[v.Name].HumanoidRootPart;
                                    if (not teleexist:FindFirstChild("telekinesisPosition") and (v.Character.Health ~= 0)) then
                                    elseif (v ~= player) then
                                        plrnum += 1
                                        table.insert(plrlist, v.Character);
                                    end
                                end
                            end);
                        end
                    end
                end
            end
        end);
    end;
    GetList = function()
        x = 1;
        Plyr = game.Players:GetPlayers();
        dropdown = {};
        for value in pairs(Plyr) do
            PLR = Plyr[x].Name;
            x += 1
            table.insert(dropdown, PLR);
        end
    end;
    TSection:NewDropdown("Safezone Locations", "", {"Middle Corner","Bar","Building Park","City Square","Evil Lair","Feild","Hero HQ","Hero Lair","Motel","Mountain","Mountain-2","Park","Plains","Prison"}, function(currentOption)
        _G.selectedstat = currentOption;
    end);
    TSection:NewDropdown("Other Locations", "", {"Void","Contruction Building","Corner-1","Corner-2","Corner-3","Corner-4","Ignite Tower","Military Base","Mountain Hole","Police Department","Cave"}, function(currentOption)
        _G.selectedstat = currentOption;
    end);
    TSection:NewDropdown("Unfortunate Locations", "", {"Unfortunate Spot (Secret Area)","Unfortunate Spot (In Building)", "Unfortunate Spot (Trap)","Unfortunate Spot (Space)","Unfortunate Spot (Under Map)","Unfortunate Spot (Dead End)","Unfortunate Spot (Box)","Unfortunate Spot (Arena)","Unfortunate Spot (Backrooms)","Unfortunate Spot (Sex Dungeon)"}, function(currentOption)
        _G.selectedstat = currentOption;
    end);
    TSection:NewToggle("Teleport Player", "", function(state)
        if state then
            _G.bring = true;
        else
            _G.bring = false;
        end
    end);
    TSection:NewButton("Teleport", "", function()
        getNearPlayer(99);
        if (_G.selectedstat == "Bar") then
            if (_G.bring == true) then
                getNearPlayer(99);
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-1313, 197, 149);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1313, 197, 149);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Building Park") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-1751, 442, 1266);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1751, 442, 1266);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Void") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(116.0564193725586, 4.412579536437988, 734.1563110351562);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(116.0564193725586, 4.412579536437988, 734.1563110351562);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Middle Corner") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-553.23, 94.34, 89.34);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-553.23, 94.34, 89.34);
                breakvelocity();
            end
        elseif (_G.selectedstat == "City Square") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-385, 86, 256);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-385, 86, 256);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Evil Lair") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-905, 94, -1086);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-905, 94, -1086);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Feild") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(2355, 81, 4);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2355, 81, 4);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Hero HQ") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(259, 169, 2748);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(259, 169, 2748);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Hero Lair") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(2351, 39, -1855);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2351, 39, -1855);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Motel") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-1750, 94, -1349);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1750, 94, -1349);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Mountain") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-2206, 817, -2425);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2206, 817, -2425);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Mountain-2") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-2429, 762, -2363);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2429, 762, -2363);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Park") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(1399, 94, 1154);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1399, 94, 1154);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Plains") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-3683, 97, -144);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3683, 97, -144);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Prison") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-779, 269, -2594);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-779, 269, -2594);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Contruction Building") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(650, 779, 284);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(650, 779, 284);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Corner-1") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(2773, 96, -4996);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2773, 96, -4996);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Corner-2") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-3757, 97, -3801);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3757, 97, -3801);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Corner-3") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-3650, 97, 2764);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3650, 97, 2764);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Corner-4") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(2810, 102, 2821);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2810, 102, 2821);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Ignite Tower") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-70, 616, -247);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-70, 616, -247);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Military Base") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(259, 99, -4639);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(259, 99, -4639);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Mountain Hole") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-2732, 256, -1776);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2732, 256, -1776);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Police Department") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-62, 94, -480);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-62, 94, -480);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Cave") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(269, -59, 2729);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(269, -59, 2729);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Unfortunate Spot (Secret Area)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-1100, 61, -1169);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1100, 61, -1169);
                breakvelocity();
            end
            elseif (_G.selectedstat == "Unfortunate Spot (In Building)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-494, 96, -98);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-494, 96, -98);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Unfortunate Spot (Trap)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-790, 135, -2769);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-790, 135, -2769);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Unfortunate Spot (Space)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(0, 9999999, 0);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 9999999, 0);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Unfortunate Spot (Under Map)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(0, 0, 0);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 0, 0);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Unfortunate Spot (Dead End)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(1453, 98, -2506);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1453, 98, -2506);
                breakvelocity();
            end
        elseif (_G.selectedstat == "Unfortunate Spot (Box)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-1695, 94, -1309);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1695, 94, -1309);
            end
        elseif (_G.selectedstat == "Unfortunate Spot (Arena)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-1728, 94, -1188);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1728, 94, -1188);
            end
        elseif (_G.selectedstat == "Unfortunate Spot (Backrooms)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-1519, 95, -1072);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1519, 95, -1072);
            end
        elseif (_G.selectedstat == "Unfortunate Spot (Sex Dungeon)") then
            if (_G.bring == true) then
                for i, v in pairs(plrlist) do
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition:Destroy();
                    game:GetService("Workspace")[v.Name].HumanoidRootPart.CFrame = CFrame.new(-1585, 95, -1159);
                    wait(0.2);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character);
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1585, 95, -1159);
            end
        end
        plrlist = {};
    end);

   

    -- Dropdown for selecting a stat
StatSection:NewDropdown("AutoStats", "Select a stat to upgrade automatically", 
{
    "vitality", "healing", "strength", "energy", "flight", "speed", 
    "climbing", "swinging", "fireball", "frost", "lightning", 
    "power", "telekinesis", "shield", "laserVision", "metalSkin"
}, 
function(currentOption)
    selectedstat = currentOption
end
)
-- Variable to store delay in milliseconds
local AutoStatsDelay = 10  -- Default: 10ms (0.01s)

-- Slider to set the delay (in milliseconds)
StatSection:NewSlider("AutoStats Delay (ms)", "Set delay in milliseconds", 1, 1000, function(value)
AutoStatsDelay = value / 1000  -- Convert milliseconds to seconds
end)

-- Toggle for enabling/disabling AutoStats
StatSection:NewToggle("Toggle AutoStats", "Enable or disable AutoStats", function(state)
if state then
    -- Ensure a stat is selected before proceeding
    if not selectedstat then
        warn("No stat selected! Please select a stat from the dropdown.")
        return
    end

    getgenv().AutoStats = true
    coroutine.wrap(function()
        while getgenv().AutoStats do
            wait(AutoStatsDelay)  -- Wait using the user-set delay
            pcall(function()
                -- Upgrade the selected stat multiple times per tick
                for _ = 1, 1000 do
                    game:GetService("ReplicatedStorage").Events.UpgradeAbility:InvokeServer(selectedstat)
                end
            end)
        end
    end)()
else
    -- Disable AutoStats
    getgenv().AutoStats = false
end
end)

-- Additional Option: Reset Stats
StatSection:NewButton("Reset Stats", "Reset all stats to base level", function()
pcall(function()
    game:GetService("ReplicatedStorage").Events.ResetStats:InvokeServer()
    print("Stats have been reset successfully!")
end)
end)

-- Additional Option: Auto Select Most Important Stat
StatSection:NewButton("Auto Select Recommended Stat", "Automatically selects the best stat based on your character's role", function()
local recommendedStat = "strength" -- Default recommendation
local role = game.Players.LocalPlayer.Character:FindFirstChild("Role") -- Example role check (customize as needed)

if role then
    if role.Value == "Tank" then
        recommendedStat = "vitality"
    elseif role.Value == "DPS" then
        recommendedStat = "strength"
    elseif role.Value == "Healer" then
        recommendedStat = "healing"
    end
end

selectedstat = recommendedStat
print("Recommended stat selected:", recommendedStat)
end)


    -- Laser Civilian Farm Toggle
    MainSection:NewToggle("Laser Civilian Farm", "", function(state)
        if state then
            getgenv().LaserC = true
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)
                while getgenv().LaserC and part do
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Model") and v.Name == "Civilian" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            part.Position = v.HumanoidRootPart.Position
                        end
                    end
                    wait()
                end
                event:InvokeServer(false)
            end)()
        else
            getgenv().LaserC = false
            breakvelocity()
        end
    end)
    
    -- Laser Police Farm Toggle
    MainSection:NewToggle("Laser Police Farm", "", function(state)
        if state then
            getgenv().LaserV = true
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)
                while getgenv().LaserV and part do
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Model") and v.Name == "Police" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            part.Position = v.HumanoidRootPart.Position
                        end
                    end
                    wait()
                end
                event:InvokeServer(false)
            end)()
        else
            getgenv().LaserV = false
            breakvelocity()
        end
    end)
    
    MainSection:NewToggle("Laser Players", "", function(state)
        if state then
            getgenv().LaserV = true
            coroutine.wrap(function()
                local laserEvent = game:GetService("ReplicatedStorage").Events:FindFirstChild("ToggleLaserVision")
                local attackEvent = game:GetService("ReplicatedStorage").Events:FindFirstChild("AttackPlayer") -- Verify the correct name of your attack event
    
                if not laserEvent or not attackEvent then
                    warn("Laser or Attack event not found in ReplicatedStorage.")
                    return
                end
    
                -- Activate laser vision
                local laserPart = laserEvent:InvokeServer(true)
    
                -- Check if the part was created
                if not laserPart then
                    warn("Laser part could not be created.")
                    return
                end
    
                -- Continuously aim laser at other players
                while getgenv().LaserV do
                    for _, player in pairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and player.Character then
                            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                            local humanoid = player.Character:FindFirstChild("Humanoid")
                            
                            -- Only target players with health
                            if hrp and humanoid and humanoid.Health > 0 then
                                -- Position the laser part to aim at the player
                                laserPart.Position = hrp.Position
                                
                                -- Fire the attack event
                                attackEvent:FireServer(player)
                            end
                        end
                    end
                    wait(0.1) -- Adjust frequency as needed for performance
                end
    
                -- Deactivate laser vision when toggled off
                laserEvent:InvokeServer(false)
            end)()
        else
            getgenv().LaserV = false
        end
    end)
    
    -- Assuming you have a UI section for player input
    local playerNameInput = MainSection:NewTextBox("Target Player", "Enter the name of the player to laser", function(inputText)
        getgenv().targetPlayerName = inputText
    end)
    
    MainSection:NewToggle("Laser Selected Player", "", function(state)
        if state then
            getgenv().LaserV = true
            coroutine.wrap(function()
                local laserEvent = game:GetService("ReplicatedStorage").Events:FindFirstChild("ToggleLaserVision")
                local attackEvent = game:GetService("ReplicatedStorage").Events:FindFirstChild("AttackPlayer") -- Verify the correct name of your attack event
    
                if not laserEvent or not attackEvent then
                    warn("Laser or Attack event not found in ReplicatedStorage.")
                    return
                end
    
                -- Activate laser vision
                local laserPart = laserEvent:InvokeServer(true)
    
                -- Check if the part was created
                if not laserPart then
                    warn("Laser part could not be created.")
                    return
                end
    
                -- Continuously aim laser at specified player
                while getgenv().LaserV do
                    local targetPlayer = game.Players:FindFirstChild(getgenv().targetPlayerName)
                    
                    if targetPlayer and targetPlayer.Character then
                        local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                        
                        -- Only target players with health
                        if hrp and humanoid and humanoid.Health > 0 then
                            -- Position the laser part to aim at the player
                            laserPart.Position = hrp.Position
                            
                            -- Fire the attack event
                            attackEvent:FireServer(targetPlayer)
                        end
                    else
                        warn("Target player not found or has no character.")
                    end
                    
                    wait(0.1) -- Adjust frequency as needed for performance
                end
    
                -- Deactivate laser vision when toggled off
                laserEvent:InvokeServer(false)
            end)()
        else
            getgenv().LaserV = false
        end
    end)
    
    
    -- Toggle for Laser Thug Farm with Pink ESP and White Laser
    MainSection:NewToggle("Laser Thug Farm", "Shows laser ESP through walls for Thugs", function(state)
        if state then
            getgenv().LaserH = true
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)
                
                -- Set laser color to white (if applicable in game)
                if part:IsA("BasePart") then
                    part.Color = Color3.fromRGB(255, 255, 255) -- Set laser color to white
                    part.Material = Enum.Material.Neon -- Optional: Neon material for brightness
                end
                
                -- Mute the laser sound if there's a sound instance
                if part:FindFirstChild("LaserSound") then
                    part.LaserSound.Volume = 0 -- Assuming the sound is named "LaserSound"
                end
                
                -- Create a pink highlight for ESP effect
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 182, 193)  -- Light pink color for fill
                highlight.OutlineColor = Color3.fromRGB(255, 105, 180)  -- Darker pink outline
                highlight.FillTransparency = 0.7
                highlight.OutlineTransparency = 0
                highlight.Parent = game.CoreGui  -- Add to GUI to keep it visible through walls
    
                while getgenv().LaserH and part do
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Model") and v.Name == "Thug" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            -- Set the laser part to thug's position and enable ESP
                            part.Position = v.HumanoidRootPart.Position
                            highlight.Adornee = v -- Assign ESP to the thug model
                        end
                    end
                    wait() -- Repeat with each update
                end
    
                -- Disable laser and cleanup
                event:InvokeServer(false)
                highlight:Destroy()
            end)()
        else
            getgenv().LaserH = false
            -- Additional function cleanup if necessary
        end
    end)
    
    local player = game.Players.LocalPlayer
    local carryingThugs = false  -- Tracks whether carrying is enabled
    
    -----
    local player = game.Players.LocalPlayer
    
    MainSection:NewToggle("Teleport Thug's to player", "Teleports thugs directly to player", function(state)
        if state then
            getgenv().LaserH = true
            coroutine.wrap(function()
                -- Start looping to teleport thugs to the player
                while getgenv().LaserH do
                    for _, thug in pairs(game.Workspace:GetChildren()) do
                        if thug:IsA("Model") and thug.Name == "Thug" and thug:FindFirstChild("Humanoid") and thug.Humanoid.Health > 0 then
                            -- Teleport thug to the player's position, with slight offset for visibility
                            thug:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5))
                        end
                    end
                    wait(0.1) -- Wait briefly to avoid excessive resource use
                end
            end)()
        else
            -- Stop teleporting thugs
            getgenv().LaserH = false
        end
    end)
    
    
    
    -- Laser Civilian Farm From Sky Toggle
    MainSection:NewToggle("Laser Civilian Farm From Sky", "", function(state)
        if state then
            local orbPos = player.Character.HumanoidRootPart.Position
            player.Character.HumanoidRootPart.CFrame = CFrame.new(orbPos.X, 2500, orbPos.Z)
            getgenv().LaserC = true
            wait(0.2)
            player.Character.HumanoidRootPart.Anchored = true
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)
                while getgenv().LaserC and part do
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Model") and v.Name == "Civilian" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            part.Position = v.HumanoidRootPart.Position
                        end
                    end
                    wait()
                end
                event:InvokeServer(false)
            end)()
        else
            player.Character.HumanoidRootPart.Anchored = false
            getgenv().LaserC = false
            player.Character.HumanoidRootPart.CFrame = CFrame.new(orbPos)
            breakvelocity()
        end
    end)
    MainSection:NewToggle("Laser Thug Farm From Sky", "", function(state)
        if state then
            local thugPos = player.Character.HumanoidRootPart.Position
            player.Character.HumanoidRootPart.CFrame = CFrame.new(thugPos.X, 2500, thugPos.Z)
            getgenv().LaserH = true
            wait(0.2)
            player.Character.HumanoidRootPart.Anchored = true
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)
                while getgenv().LaserH and part do
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Model") and v.Name == "Thug" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            part.Position = v.HumanoidRootPart.Position
                        end
                    end
                    wait()
                end
                event:InvokeServer(false)
            end)()
        else
            player.Character.HumanoidRootPart.Anchored = false
            getgenv().LaserH = false
            player.Character.HumanoidRootPart.CFrame = CFrame.new(thugPos)
            breakvelocity()
        end
    end)
    -- Laser Police Farm From Sky Toggle
    MainSection:NewToggle("Laser Police Farm From Sky", "", function(state)
        if state then
            local orbPos = player.Character.HumanoidRootPart.Position
            player.Character.HumanoidRootPart.CFrame = CFrame.new(orbPos.X, 2500, orbPos.Z)
            getgenv().LaserV = true
            wait(0.2)
            player.Character.HumanoidRootPart.Anchored = true
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)
                while getgenv().LaserV and part do
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Model") and v.Name == "Police" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            part.Position = v.HumanoidRootPart.Position
                        end
                    end
                    wait()
                end
                event:InvokeServer(false)
            end)()
        else
            player.Character.HumanoidRootPart.Anchored = false
            getgenv().LaserV = false
            player.Character.HumanoidRootPart.CFrame = CFrame.new(orbPos)
            breakvelocity()
        end
    end)
    
    MainSection:NewToggle("Civilian Farm", "", function(state)
        if state then
            -- Store original position
            local civilianPos = player.Character.HumanoidRootPart.CFrame
            getgenv().Civilian = true
    
            -- Start farming loop
            coroutine.wrap(function()
                while getgenv().Civilian do
                    wait(0.2)
                    pcall(function()
                        for _, v in pairs(game.Workspace:GetChildren()) do
                            if v:IsA("Model") and v.Name == "Civilian" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                                player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                            end
                        end
                    end)
                end
            end)()
    
            -- Store position for reset when toggle is turned off
            getgenv().CivilianReturnPos = civilianPos
        else
            -- Stop the farm and return to saved position
            getgenv().Civilian = false
            wait(0.2)
            if getgenv().CivilianReturnPos then
                player.Character.HumanoidRootPart.CFrame = getgenv().CivilianReturnPos
            end
        end
    end)

    MainSection:NewToggle("Police Farm", "", function(state)
        if state then
            -- Store original position
            local policePos = player.Character.HumanoidRootPart.CFrame
            getgenv().Police = true
    
            -- Start farming loop
            coroutine.wrap(function()
                while getgenv().Police do
                    wait(0.2)
                    pcall(function()
                        for _, v in pairs(game.Workspace:GetChildren()) do
                            if v:IsA("Model") and v.Name == "Police" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                                player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                            end
                        end
                    end)
                end
            end)()
    
            -- Store position for reset when toggle is turned off
            getgenv().PoliceReturnPos = policePos
        else
            -- Stop the farm and return to saved position
            getgenv().Police = false
            wait(0.2)
            if getgenv().PoliceReturnPos then
                player.Character.HumanoidRootPart.CFrame = getgenv().PoliceReturnPos
            end
        end
    end)
    
    
    -- Toggle to start or stop Thug farming
    MainSection:NewToggle("Thug Farm V2", "", function(state)
        local player = game.Players.LocalPlayer
        local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
        if state then
            -- Save player's original position
            if rootPart then
                thugX, thugY, thugZ = rootPart.Position.X, rootPart.Position.Y, rootPart.Position.Z
            end
            getgenv().Thug = true
    
            -- Farming loop
            spawn(function()
                while getgenv().Thug do
                    wait(0.5) -- Increased wait time for slower farming
                    pcall(function()
                        for _, v in pairs(game.Workspace:GetChildren()) do
                            if v:IsA("Model") and v.Name == "Thug" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                -- Move player near the Thug and punch
                                rootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                                wait(0.2) -- Add a slight delay between punches
                            end
                        end
                    end)
                end
            end)
        else
            -- Stop farming and return to original position
            getgenv().Thug = false
            spawn(function()
                wait(0.2)
                if rootPart then
                    rootPart.CFrame = CFrame.new(thugX, thugY, thugZ)
                end
            end)
        end
    end)
    -- Toggle to start or stop Thug farming
    
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    
    local player = Players.LocalPlayer
    local respawnPosition = nil  -- Stores the saved spawn position
    local deathCheckEnabled = false  -- Toggle for checking death
    
    -- Function to set spawn point
    local function setSpawnPoint()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            respawnPosition = player.Character.HumanoidRootPart.Position
            deathCheckEnabled = true
        end
    end
    
    -- Function to teleport player to saved spawn
    local function teleportToSpawn()
        if respawnPosition and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(respawnPosition)
        end
    end
    
    -- Function to teleport after death
    local function onPlayerDied()
        if deathCheckEnabled and respawnPosition then
            wait(0.01)
            teleportToSpawn()
        end
    end
    
    -- Function to handle respawn teleport
    local function onPlayerRespawned()
        if respawnPosition then
            wait(0.1)
            teleportToSpawn()
        end
    end
    
    -- Monitor for player death
    local function monitorDeath()
        while deathCheckEnabled do
            if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                humanoid.Died:Connect(onPlayerDied)
            end
            wait(0.01)
        end
    end
    
    -- Keybind to teleport using F2
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.F2 then
            teleportToSpawn()
        end
    end)
    
    -- When character respawns
    player.CharacterAdded:Connect(function()
        onPlayerRespawned()
    end)
    
    -- UI Button to set spawn point
    SSection:NewButton("Set Spawn Point", "Sets your spawn point and teleports instantly on death", function()
        setSpawnPoint()
        spawn(monitorDeath)
    end)
    



    MainSection:NewToggle("Laser Player Farm From Sky", "", function(state)
        if state then
            local playerPos = player.Character.HumanoidRootPart.Position
            player.Character.HumanoidRootPart.CFrame = CFrame.new(playerPos.X, 2500, playerPos.Z)
            getgenv().LaserPlayer = true
            wait(0.2)
            player.Character.HumanoidRootPart.Anchored = true
            coroutine.wrap(function()
                local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision
                local part = event:InvokeServer(true)
                while getgenv().LaserPlayer and part do
                    for _, v in pairs(game.Players:GetPlayers()) do
                        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                            part.Position = v.Character.HumanoidRootPart.Position
                        end
                    end
                    wait()
                end
                event:InvokeServer(false)
            end)()
        else
            player.Character.HumanoidRootPart.Anchored = false
            getgenv().LaserPlayer = false
            player.Character.HumanoidRootPart.CFrame = CFrame.new(playerPos)
            breakvelocity()
        end
    end)
    
    
    SSection:NewToggle("Rapid Punch", "", function(state)
        if state then
            -- Activate Rapid Punch
            getgenv().rapid = true
            local UserInputService = game:GetService("UserInputService")
            
            -- Function to handle input
            local function onInputEnded(inputObject, gameProcessedEvent)
                if gameProcessedEvent then return end -- Ignore if the input was processed by the game
                
                if getgenv().rapid and inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                    -- Fire the punch event multiple times rapidly
                    for i = 1, 10 do -- Change the number to adjust how many punches per input
                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                    end
                end
            end
            
            -- Store the connection so we can disconnect it later
            getgenv().RapidPunchConnection = UserInputService.InputEnded:Connect(onInputEnded)
        else
            -- Deactivate Rapid Punch
            getgenv().rapid = false
            
            -- Disconnect the connection to stop listening for input
            if getgenv().RapidPunchConnection then
                getgenv().RapidPunchConnection:Disconnect()
                getgenv().RapidPunchConnection = nil
            end
        end
    end)
    
    SSection:NewToggle("Rapid Heavy Punch", "", function(state)
        if state then
            -- Activate Rapid Heavy Punch
            getgenv().Hrapid = true
            local UserInputService = game:GetService("UserInputService")
            
            -- Function to handle input
            local function onInputEnded(inputObject, gameProcessedEvent)
                if gameProcessedEvent then return end -- Ignore if the input was processed by the game
                
                if getgenv().Hrapid and inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                    -- Fire the punch event multiple times rapidly
                    for i = 1, 10 do -- Change the number to adjust how many punches per input
                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0.4, 0.1, 1)
                    end
                end
            end
            
            -- Store the connection so we can disconnect it later
            getgenv().RapidPunchConnection = UserInputService.InputEnded:Connect(onInputEnded)
        else
            -- Deactivate Rapid Heavy Punch
            getgenv().Hrapid = false
            
            -- Disconnect the connection to stop listening for input
            if getgenv().RapidPunchConnection then
                getgenv().RapidPunchConnection:Disconnect()
                getgenv().RapidPunchConnection = nil
            end
        end
    end)
    

ASection:NewToggle("Super Rapid Punch", "", function(state)
    -- Set toggle for super rapid punch
    getgenv().superrapid = state
    local UserInputService = game:GetService("UserInputService")

    -- Parameters for rapid punching
    local punchCount = 50  -- Number of punches per activation, adjust for more or fewer punches
    local punchCooldown = 0.1  -- Delay between activations for performance control

    -- Function to fire punches rapidly
    local function rapidPunch()
        for _ = 1, punchCount do
            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
        end
    end

    -- Function to detect mouse input and trigger punches
    local function onInputEnded(inputObject, gameProcessedEvent)
        if not gameProcessedEvent and getgenv().superrapid and inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
            rapidPunch()
        end
    end

    -- Manage input connection for toggling
    local inputConnection
    if state then
        -- Connect input detection when enabled
        inputConnection = UserInputService.InputEnded:Connect(onInputEnded)
    else
        -- Disconnect to stop rapid punch when disabled
        getgenv().superrapid = false
        if inputConnection then inputConnection:Disconnect() end
    end
end)

-- Function to get the player's root part
getRoot = function(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

SSection:NewToggle("Super Rapid Punch", "", function(state)
    local UserInputService = game:GetService("UserInputService")
    
    if state then
        -- Activate Super Rapid Punch
        getgenv().superrapid = true
        
        local function onInputEnded(inputObject, gameProcessedEvent)
            if gameProcessedEvent or not getgenv().superrapid then return end
            
            if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                spawn(function()
                    for _ = 1, 50 do -- Rapidly send 50 punches
                        if not getgenv().superrapid then break end
                        pcall(function()
                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1)
                        end)
                        task.wait(0.05) -- Small delay between punches
                    end
                end)
            end
        end
        
        -- Connect the input listener
        UserInputService.InputEnded:Connect(onInputEnded)
    else
        -- Deactivate Super Rapid Punch
        getgenv().superrapid = false
    end
end)

    getRoot = function(char)
        local rootPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso");
        return rootPart;
    end;
    Players = game:GetService("Players");
    SSection:NewButton("Name Esp", "", function()
        local esp_settings = {textsize=20};
        local gui = Instance.new("BillboardGui");
        local esp = Instance.new("TextLabel", gui);
        gui.Name = "esp";
        gui.ResetOnSpawn = false;
        gui.AlwaysOnTop = true;
        gui.LightInfluence = 0;
        gui.Size = UDim2.new(1.75, 0, 1.75, 0);
        esp.BackgroundColor3 = Color3.fromRGB(0, 255, 255);
        esp.Text = "";
        esp.Size = UDim2.new(0.0001, 0.00001, 0.0001, 0.00001);
        esp.BorderSizePixel = 4;
        esp.BorderColor3 = Color3.new(0, 255, 255);
        esp.BorderSizePixel = 0;
        esp.Font = "SourceSansSemibold";
        esp.TextSize = esp_settings.textsize;
        esp.TextColor3 = Color3.fromRGB(0, 255, 255);
        getgenv().esp = true;
        game:GetService("RunService").RenderStepped:Connect(function()
            for i, v in pairs(game:GetService("Players"):GetPlayers()) do
                if ((v ~= game:GetService("Players").LocalPlayer) and Players.LocalPlayer.Character and (v.Character.Head:FindFirstChild("esp") == nil)) then
                    esp.Text = "Name: " .. v.Name .. "";
                    gui:Clone().Parent = v.Character.Head;
                end
            end
        end);
    end);
    local player = game.Players.LocalPlayer
    
    SSection:NewToggle("GodMode", "", function(state)
        if state then
            -- Save current position
            local currentPos = player.Character.HumanoidRootPart.CFrame
            
            -- Teleport to a specific position for GodMode
            player.Character.HumanoidRootPart.CFrame = CFrame.new(2142, -195, -1925)
            wait(0.2)
            
            -- Destroy the Waist part to simulate GodMode
            local upperTorso = player.Character:FindFirstChild("UpperTorso")
            if upperTorso and upperTorso:FindFirstChild("Waist") then
                upperTorso.Waist:Destroy()
            end
            
            -- Anchor the Head to prevent movement
            local head = player.Character:FindFirstChild("Head")
            if head then
                head.Anchored = true
            end
            
            wait(2)
            
            -- Return to the saved position
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = currentPos
            end
    
        else
            -- Save the current position before breaking joints
            local resetPos = player.Character.HumanoidRootPart.CFrame
            
            -- Break joints to reset the character
            player.Character:BreakJoints()
            wait(6.5)
            
            -- Teleport character back to the saved position
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = resetPos
            end
        end
    end)
    
    
    SSection:NewToggle("Invisibility", "", function(state)
        if state then
            -- Save current position
            local currentPos = player.Character.HumanoidRootPart.CFrame
            -- Teleport to a specific position outside of visibility
            player.Character.HumanoidRootPart.CFrame = CFrame.new(-2711, 229, -1769)
            wait(0.2)
    
            -- Remove the LowerTorso to make character invisible
            local lowerTorso = player.Character:FindFirstChild("LowerTorso")
            if lowerTorso and lowerTorso:FindFirstChild("Root") then
                lowerTorso.Root:Destroy()
            end
    
            wait(2)
            -- Return to the saved position
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = currentPos
            end
    
        else
            -- Save the current position before resetting the character
            local resetPos = player.Character.HumanoidRootPart.CFrame
            -- Reset character by breaking joints, making them visible again
            player.Character:BreakJoints()
            wait(6.5)
    
            -- Teleport character back to saved position
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = resetPos
            end
        end
    end)
    
    local player = game.Players.LocalPlayer
    
    SSection:NewToggle("Invisibility With Godmode", "", function(state)
        if state then
            -- Save current position
            local currentPos = player.Character.HumanoidRootPart.CFrame
            
            -- Teleport to a specific position for invisibility
            player.Character.HumanoidRootPart.CFrame = CFrame.new(-320, 86, 271)
            wait(0.2)
            
            -- Remove the LowerTorso to make character invisible
            local lowerTorso = player.Character:FindFirstChild("LowerTorso")
            if lowerTorso and lowerTorso:FindFirstChild("Root") then
                lowerTorso.Root:Destroy()
            end
            
            wait(2)
            
            -- Return to the saved position
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = currentPos
            end
    
        else
            -- Save the current position before breaking joints
            local resetPos = player.Character.HumanoidRootPart.CFrame
            
            -- Break joints to enable godmode (can be enhanced for actual godmode)
            player.Character:BreakJoints()
            wait(6.5)
            
            -- Teleport character back to the saved position
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = resetPos
            end
        end
    end)
    
    local player = game.Players.LocalPlayer
    
    SSection:NewToggle("Hide Title Gui", "", function(state)
        if state then
            getgenv().hide = true
            while getgenv().hide do
                wait(0.1) -- Reduced wait time for more responsive checks
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local rP = player.Character.HumanoidRootPart
                    -- Check for titleGui in the character
                    if rP:FindFirstChild("titleGui") then
                        rP.titleGui:Destroy()
                    end
                end
            end
        else
            getgenv().hide = false -- Set hide to false when the toggle is off
        end
    end)
    
    local playerToProtect = game.Players.LocalPlayer
    
    
    SSection:NewToggle("Auto MetalSkin", "Auto Turns On MetalSkin", function(state)
        getgenv().metal = state -- Directly set metal state based on the toggle
    
        if state then
            spawn(function() -- Start a new thread for the loop
                while getgenv().metal do
                    game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", true)
                    wait(0.2) -- Wait time to prevent overloading
                end
            end)
        else
            -- Turn off MetalSkin once if the toggle is off
            game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", false)
        end
    end)
    
    
    SSection:NewToggle("Destroy ForceFeild", "Turns Of The Forcefeild Around You When You Die", function(state)
        if state then
            getgenv().ff = true;
            while ff do
                wait(0.2);
                spawn(function()
                    game:GetService("Workspace")[_G.LOCALPLAYER].ForceField:Destroy();
                end);
            end
        else
            spawn(function()
                getgenv().ff = false;
            end);
        end
    end);
    local UserInputService = game:GetService("UserInputService")
local jumpHeight = 100 -- The height of the super jump
local defaultJumpHeight = game.Players.LocalPlayer.Character.Humanoid.JumpHeight -- Store default jump height

SSection:NewToggle("Super Jump", "Toggle to enable super jumps", function(state)
    local player = game.Players.LocalPlayer
    local character = player.Character
    local humanoid = character:WaitForChild("Humanoid")
    
    if state then
        -- When toggled on, set jump height to super high
        humanoid.JumpHeight = jumpHeight
        print("Super Jump Activated!")
    else
        -- When toggled off, revert jump height to normal
        humanoid.JumpHeight = defaultJumpHeight
        print("Super Jump Deactivated!")
    end
end)

-- You can also add an effect to the jump like particles or sound when jumping
game.Players.LocalPlayer.Character.Humanoid.Jumping:Connect(function()
    if game.Players.LocalPlayer.Character.Humanoid.JumpHeight == jumpHeight then
        -- Play a fun sound or particle effect when the super jump is used
        local jumpSound = Instance.new("Sound")
        jumpSound.SoundId = "rbxassetid://123456789" -- Replace with your own sound ID
        jumpSound.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        jumpSound:Play()

        -- You can also add particle effects
        local particle = Instance.new("ParticleEmitter")
        particle.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        particle.Texture = "rbxassetid://123456789" -- Replace with your own particle texture
        particle:Emit(50) -- Emit particles during jump
    end
end)

    SSection:NewToggle("Telekinesis Lock Aura", "", function(state)
        if state then
            getgenv().teleaura = true;
            while teleaura do
                wait();
                spawn(function()
                    local LookVector = game.Workspace.Camera.CFrame.LookVector;
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, true);
                    game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, false);
                end);
            end
        else
            spawn(function()
                getgenv().teleaura = false;
            end);
        end
    end);
    SSection:NewToggle("Telekinesis Space Fling", "", function(state)
        if state then
            -- Activate Telekinesis Space Fling
            getgenv().telesauras = true
            
            spawn(function()
                while getgenv().telesauras do
                    task.wait(0.2) -- Wait to prevent overloading the server
                    
                    pcall(function()
                        -- Invoke the telekinesis events with extreme coordinates
                        game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(999999, 999999, 999999), true)
                        game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(999999, 999999, 999999), false)
                    end)
                end
            end)
        else
            -- Deactivate Telekinesis Space Fling
            getgenv().telesauras = false
        end
    end)
    local UserInputService = game:GetService("UserInputService")
    local isTelekinesisActive = false
    
    -- Function to toggle Telekinesis Push
    local function toggleTelekinesis()
        if not isTelekinesisActive then
            isTelekinesisActive = true
    
            spawn(function()
                while isTelekinesisActive do
                    task.wait(0.2) -- Wait to prevent overloading the server
    
                    pcall(function()
                        -- Get the player's character
                        local playerChar = game.Players.LocalPlayer.Character
                        if playerChar and playerChar:FindFirstChild("HumanoidRootPart") then
                            local myPosition = playerChar.HumanoidRootPart.Position
                            
                            -- Find nearby players (this could be improved to target only specific players if needed)
                            for _, v in pairs(game.Players:GetChildren()) do
                                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                                    local target = v.Character
                                    if target ~= playerChar then
                                        local targetHRP = target.HumanoidRootPart
                                        
                                        -- Calculate direction to push the target away from your character
                                        local direction = (targetHRP.Position - myPosition).unit -- Get the direction vector
                                        local pushForce = direction * 20 -- Adjust this number to control how much force is applied
                                        
                                        -- Apply the force to the target's humanoid root part
                                        targetHRP.Velocity = pushForce
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        else
            isTelekinesisActive = false
        end
    end
    
    -- Listen for the E key press to toggle Telekinesis
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
    
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.E then
            toggleTelekinesis() -- Toggle on key press
        end
    end)
    
    SSection:NewToggle("Safe Teleport", "", function(state)
        if state then
            -- Activate Safe Teleport
            local player = game.Players.LocalPlayer
            local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
            
            -- Ensure humanoid exists
            if not humanoid then
                warn("Humanoid not found! Safe Teleport cannot be enabled.")
                return
            end
    
            -- Calculate the health threshold
            local healthThreshold = humanoid.Health / 3
            getgenv().st = true
    
            -- Main loop for monitoring health and teleporting
            spawn(function()
                while getgenv().st do
                    task.wait()
                    if humanoid.Health < healthThreshold then
                        pcall(function()
                            -- Trigger telekinesis event
                            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, player.Character)
    
                            -- Teleport the player to the safe position
                            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                            if rootPart then
                                rootPart.CFrame = CFrame.new(-1368.27539, 195.429108, 195.75)
                            end
                        end)
                    end
                end
            end)
        else
            -- Deactivate Safe Teleport
            getgenv().st = false
        end
    end)
    
    SSection:NewToggle("Anti-Knockback", "", function(state)
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local PrimaryPart = character.PrimaryPart or character:WaitForChild("HumanoidRootPart")
        
        if state then
            getgenv().AntiKnockback = true
            local LastPosition = PrimaryPart.CFrame -- Initial position
    
            -- Start the anti-knockback loop
            while getgenv().AntiKnockback do
                task.wait()
                spawn(function()
                    if PrimaryPart then
                        -- Check for high velocity to cancel knockback
                        if (PrimaryPart.AssemblyLinearVelocity.Magnitude > 250 or PrimaryPart.AssemblyAngularVelocity.Magnitude > 250) then
                            PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                            PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            PrimaryPart.CFrame = LastPosition
                        elseif (PrimaryPart.AssemblyLinearVelocity.Magnitude < 50 and PrimaryPart.AssemblyAngularVelocity.Magnitude < 50) then
                            -- Update LastPosition when velocity is low, indicating no knockback
                            LastPosition = PrimaryPart.CFrame
                        end
                    end
                end)
            end
        else
            getgenv().AntiKnockback = false -- Stop the anti-knockback loop
        end
    end)
    
    SSection:NewToggle("Anti-Fling", "", function(state)
        if state then
            player.Character.HumanoidRootPart.Anchored = true;
        else
            player.Character.HumanoidRootPart.Anchored = false;
        end
    end);
    SSection:NewSlider("Speed", "", 2000, 16, function(s)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s;
    end);
    SSection:NewSlider("Jump", "", 700, 50, function(s)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = s;
    end);
    SSection:NewButton("Inf jump", "", function()
        game:GetService("UserInputService").JumpRequest:connect(function()
            game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping");
        end);
    end);
    -- Table to hold clones of objects that will be destroyed
    local destroyedObjects = {}
    
    -- Function to destroy the specified objects and store clones
    local function destroyObjects()
        local objectsToDestroy = {
            game:GetService("Workspace").City.Buildings,
            game:GetService("Workspace").City.Interactive.Bank.Model,
            game:GetService("Workspace").City.Interactive["Police Station"]:GetChildren()[28],
            game:GetService("Workspace").City.Interactive.Grove.WareHouse,
            game:GetService("Workspace").City.Interactive["Main Plaza"]:GetChildren()[38],
        }
        -- SafeZone barriers (assuming they are all the same part to simplify)
        for _, barrier in ipairs(game:GetService("Workspace").SafeZones:GetChildren()) do
            if barrier.Name == "Barrier" then
                table.insert(objectsToDestroy, barrier)
            end
        end
    
        -- Clone and destroy each object
        for _, obj in pairs(objectsToDestroy) do
            if obj and obj.Parent then
                table.insert(destroyedObjects, {clone = obj:Clone(), original = obj})
                obj:Destroy()
            end
        end
    end
    
    -- Function to restore the destroyed objects from their clones
    local function restoreObjects()
        for _, entry in pairs(destroyedObjects) do
            if entry.clone and entry.original.Parent == nil then
                entry.clone.Parent = entry.original.Parent -- Set back to original location
            end
        end
        destroyedObjects = {} -- Clear the table after restoring
    end
    
    -- Toggle function for Destroy Safezone & Parts
    SSection:NewButton("Safezone & Parts Destruction", "Destroy or restore safezone and specific parts", function(state)
        if state then
            destroyObjects() -- Destroy objects if toggle is ON
        else
            restoreObjects() -- Restore objects if toggle is OFF
        end
    end)
    
    SSection:NewButton("Anti-Lag", "", function()
        local Terrain = workspace:FindFirstChildOfClass("Terrain");
        Terrain.WaterWaveSize = 0;
        Terrain.WaterWaveSpeed = 0;
        Terrain.WaterReflectance = 0;
        Terrain.WaterTransparency = 0;
        settings().Rendering.QualityLevel = 1;
        for i, v in pairs(game:GetDescendants()) do
            if (v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart")) then
                v.Material = "Plastic";
                v.Reflectance = 0;
            elseif v:IsA("Decal") then
                v.Transparency = 1;
            elseif (v:IsA("ParticleEmitter") or v:IsA("Trail")) then
                v.Lifetime = NumberRange.new(0);
            elseif v:IsA("Explosion") then
                v.BlastPressure = 1;
                v.BlastRadius = 1;
            end
        end
        workspace.DescendantAdded:Connect(function(child)
            coroutine.wrap(function()
                if child:IsA("ForceField") then
                    RunService.Heartbeat:Wait();
                    child:Destroy();
                elseif child:IsA("Sparkles") then
                    RunService.Heartbeat:Wait();
                    child:Destroy();
                elseif (child:IsA("Smoke") or child:IsA("Fire")) then
                    RunService.Heartbeat:Wait();
                    child:Destroy();
                end
            end)();
        end);
    end);

    SSection:NewButton("Ground Crack Lag", "", function(state)
        for i = 1, 1000 do
            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
        end
    end);
    SSection:NewButton("Mini Ground Crack Lag", "", function(state)
        for i = 1, 500 do
            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
        end
    end);
    SSection:NewButton("Mini Mini Ground Crack Lag", "", function(state)
        for i = 1, 200 do
            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
        end
    end);
    SSection:NewButton("Mini Crash", "", function(state)
        local x = 0;
        repeat
            x += 1
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
        until x == 5000 
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
        wait();
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
    end);
    SSection:NewButton("Crash Server", "", function(state)
        local x = 0;
        repeat
            x += 1
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
        until x == 20000 
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
        wait();
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
    end);
    SSection:NewButton("Mini Crash Server + Mini ground crack lag", "", function(state)
        local x = 0;
        repeat
            x += 1
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
        until x == 4000
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
        wait();
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
    end);
    
    SSection:NewButton("Crash Server + ground crack lag", "", function(state)
        spawn(function ()
            local x = 0;
            repeat
                x += 1
                game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
                game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
                game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
            until x == 10000
        end)
        spawn(function ()
            local x = 0;
            repeat
                x += 1
                game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
                game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
            until x == 7500
        end)
        spawn(function ()
            local x = 0;
            repeat
                x += 1
                game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
            until x == 5000
        end)
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
        wait();
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
    end);
    SSection:NewButton("Break Velocity", "", function()
        breakvelocity();
    end);
    SSection:NewButton("Reset", "", function()
        player.Character:BreakJoints();
    end);

    ASection:NewButton("Spawn Platform", "Create a platform below you", function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local platformInterval = 0.2  -- Time between platform spawns
        local platformCount = 10  -- Number of platforms to spawn
    
        -- Spawn platforms sequentially
        spawn(function()
            for i = 1, platformCount do
                -- Create a platform below the player
                local platform = Instance.new("Part")
                platform.Size = Vector3.new(10, 1, 10)  -- Platform dimensions
                platform.Position = character.HumanoidRootPart.Position - Vector3.new(0, 3 + i, 0)  -- Stacked positions
                platform.Anchored = true
                platform.Parent = workspace
    
                -- Wait before spawning the next platform
                wait(platformInterval)
            end
        end)
    end)
    
local spawnInterval = 0.2  -- Time in seconds between ball spawns (faster spawning)

-- Toggle the ball spawning on/off
ASection:NewToggle("Spawn Balls Toggle", "Create balls below you", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    -- Toggle the spawning status
    platformSpawning = not platformSpawning
    
    -- If spawning is now active, start the loop
    if platformSpawning then
        -- Start spawning balls
        spawnBall(character)
    end
end)

-- Function to handle the ball spawning
function spawnBall(character)
    spawn(function()
        while platformSpawning do
            -- Create a new ball (spherical part)
            local ball = Instance.new("Part")
            ball.Shape = Enum.PartType.Ball  -- Set the shape to ball
            ball.Size = Vector3.new(4, 4, 4)  -- Size of the ball (adjustable)
            ball.Color = Color3.fromRGB(255, 0, 0)  -- Color of the ball (adjustable)
            ball.Position = character.HumanoidRootPart.Position - Vector3.new(0, 3, 0)  -- Position it below the player
            ball.Anchored = true  -- Anchor the ball to prevent it from falling
            ball.CanCollide = false  -- Make it non-collidable to avoid interaction
            ball.Parent = workspace  -- Parent the ball to the workspace
            
            -- Wait for the specified interval before creating the next ball
            wait(spawnInterval)
        end
    end)
end


    GetList();
    local slcplr = TargetSection:NewDropdown("Select Player", "", dropdown, function(currentOption)
        spawn(function()
            _G.tplayer = currentOption;
        end);
    end);
    TargetSection:NewButton("Refresh Dropdown", "", function()
        spawn(function()
            GetList();
            slcplr:Refresh(dropdown);
        end);
    end);
-- Teleportation Functionality
local function teleportToPlayer(targetPlayerName)
    local localPlayer = game.Players.LocalPlayer
    local targetPlayer = game.Players:FindFirstChild(targetPlayerName)

    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and
        localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        -- Teleport to the target player
        localPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        -- Optional: Reset velocity if needed (e.g., breakvelocity function)
        localPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    else
        warn("Target player not found or invalid!")
    end
end

-- Add a button in the UI for teleportation
TargetSection:NewButton("Teleport To Player", "", function()
    if _G.tplayer then
        teleportToPlayer(_G.tplayer)
    else
        warn("No target player set!")
    end
end)

-- Bind the U key to teleportation
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end -- Ignore inputs already processed by other systems

    if input.KeyCode == Enum.KeyCode.U then
        if _G.tplayer then
            teleportToPlayer(_G.tplayer)
        else
            warn("No target player set!")
        end
    end
end)

-- Toggle to Spectate a Player
TargetSection:NewToggle("Spectate Player", "", function(state)
    -- Update watch state based on toggle
    getgenv().watch = state

    -- Validate the target player
    local function getTargetPlayer()
        local targetPlayer = game.Players:FindFirstChild(_G.tplayer)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
            return targetPlayer
        end
        return nil -- Return nil if the target is invalid
    end

    -- Start or stop spectating based on toggle state
    if getgenv().watch then
        -- Start spectating
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            local targetPlayer = getTargetPlayer()
            if targetPlayer then
                workspace.CurrentCamera.CameraSubject = targetPlayer.Character:FindFirstChild("Humanoid")
            else
                warn("Target player is invalid or not available.")
                workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                if connection then
                    connection:Disconnect()
                end
            end
        end)

        -- Store the connection so it can be cleaned up later
        getgenv().spectateConnection = connection
    else
        -- Stop spectating and reset the camera
        if getgenv().spectateConnection then
            getgenv().spectateConnection:Disconnect()
            getgenv().spectateConnection = nil
        end
        workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    end
end)

TargetSection:NewToggle("Fling Player", "", function(state)
    local player = game.Players.LocalPlayer
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    if state then
        -- Activate Fling
        getgenv().fling = true
        local p1 = player.Character.HumanoidRootPart

        -- Update physical properties for all parts of the character
        for _, child in ipairs(player.Character:GetDescendants()) do
            if child:IsA("BasePart") then
                child.CustomPhysicalProperties = PhysicalProperties.new(math.huge, 0.3, 0.5)
            end
        end

        -- Add BodyAngularVelocity to the HumanoidRootPart
        local bambam = Instance.new("BodyAngularVelocity")
        bambam.Parent = p1
        bambam.AngularVelocity = Vector3.new(0, 1000, 0)
        bambam.MaxTorque = Vector3.new(0, math.huge, 0)
        bambam.P = 10000 -- Ensure stability

        -- Loop to manage the fling functionality
        task.spawn(function()
            while getgenv().fling and player and player.Character do
                task.wait()
                pcall(function()
                    for _, v in ipairs(game.Workspace:GetChildren()) do
                        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                            if v.Name == _G.tplayer then
                                p1.CFrame = v.HumanoidRootPart.CFrame
                            end
                        end
                    end
                end)

                -- Prevent the player from being affected by physics
                for _, v in ipairs(player.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                        v.Massless = true
                        v.Velocity = Vector3.zero
                    end
                end
            end
        end)
    else
        -- Deactivate Fling
        getgenv().fling = false
        task.wait(0.1)

        -- Reset character properties
        for _, v in ipairs(player.Character:GetDescendants()) do
            if v:IsA("BodyAngularVelocity") then
                v:Destroy()
            end
            if v:IsA("BasePart") or v:IsA("MeshPart") then
                v.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
                v.CanCollide = true
                v.Massless = false
            end
        end

        -- Ensure velocity and physics reset
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Velocity = Vector3.zero
        end
    end
end)

    TargetSection:NewButton("Allow Target To Crash", "", function()
        spawn(function()
            game.Players[_G.tplayer].Chatted:Connect(function(Message) 
                if string.lower(Message) == "crash" or string.lower(Message) == "crash server" or string.lower(Message) == "cs" then
                    for i = 1, 15000 do
                        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
                        game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
                    end
                end
            end);
        end);
    end);
    TargetSection:NewButton("Allow All Players To Crash", "", function()
        for i, v in pairs(game.Players:GetPlayers()) do
            v.Chatted:Connect(function(Message) 
                if string.lower(Message) == "crash" or string.lower(Message) == "crash server" or string.lower(Message) == "cs" then
                    for i = 1, 15000 do
                        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
                        game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
                    end
                end
            end);
        end
    end);
    TargetSection:NewButton("Allow Target to Kill Players (kill <username>)", "", function()
        local function GetPlayer(input)
            for _, Player in pairs(game:GetService("Players"):GetPlayers()) do
                if (string.lower(input) == string.sub(string.lower(Player.Name), 1, #input)) then
                    return Player;
                end
            end
        end
    
        spawn(function()
            game.Players[_G.tplayer].Chatted:Connect(function(Message)
                local KillingTime = 0
                local Chat = string.split(Message, " ")
                if string.lower(Chat[1]) == "kill" then
                    local varX = game.Players.LocalPlayer.Character.HumanoidRootPart.Position['X'];
                    local varY = game.Players.LocalPlayer.Character.HumanoidRootPart.Position['Y'];
                    local varZ = game.Players.LocalPlayer.Character.HumanoidRootPart.Position['Z'];
                    wait();
                    local p1 = game.Players.LocalPlayer.Character.HumanoidRootPart;
                    local pos = p1.CFrame;
                    getgenv().breakv = true;
                    game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", true);
                    spawn(function()
                        repeat KillingTime += 1
                            task.wait();
                            task.wait();
                            task.wait();
                            task.wait();
                            task.wait();
                            task.wait();
                            spawn(function()
                                pcall(function()
                                    for i, v in pairs(game.Workspace:GetChildren()) do
                                        if ((string.lower(v.Name) == string.lower(GetPlayer(Chat[2]).Character.Name)) and v:FindFirstChild("Humanoid") and (v.Humanoid.Health > 0)) then
                                            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1);
                                            spawn(function()
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            end)
                                            spawn(function()
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            end)
                                            spawn(function()
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            end)
                                            spawn(function()
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.1, 1);
                                            end)
                                            spawn(function()
                                                local LookVector = game.Workspace.Camera.CFrame.LookVector;
                                                game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, true);
                                                game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, false);
                                            end);	
                                        end
                                    end
                                end);
                            end);
                        until KillingTime == 40
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(varX, varY, varZ);
                        spawn(function()
                            getgenv().breakv = false;
                            wait(0.2);
                            breakvelocity();
                        end)
                    end)
                end
            end)
        end);
    end);
    

    TargetSection:NewButton("Farm", "", function()
        local player = game.Players[_G.tplayer]
        lplayer = game.Players.LocalPlayer
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("","All")
    
        player.Chatted:Connect(function(msg) 
            if msg == "reset" then
                lplayer.Character:BreakJoints()
            else if msg == "Reset" then
                    lplayer.Character:BreakJoints()
                else if msg == "Farm" then
                        spawn(function()
                            getgenv().lb = true
                            while lb do
                                game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin",true)
                                spawn(function()
                                    game:GetService("Workspace")[lplayer.Name].ForceField:Destroy()
                                end)
                                wait()
                                spawn(function()
                                    X = player.Character.HumanoidRootPart.Position.X
                                    Y = player.Character.HumanoidRootPart.Position.Y
                                    Z = player.Character.HumanoidRootPart.Position.Z
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(X,Y,Z + 3)
                                end)
                            end
                        end)
                    else if msg == "farm" then
                            spawn(function()
                                getgenv().lb = true
                                while lb do
                                    game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin",true)
                                    spawn(function()
                                        game:GetService("Workspace")[lplayer.Name].ForceField:Destroy()
                                    end)
                                    wait()
                                    spawn(function()
                                        X = player.Character.HumanoidRootPart.Position.X
                                        Y = player.Character.HumanoidRootPart.Position.Y
                                        Z = player.Character.HumanoidRootPart.Position.Z
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(X,Y,Z + 3)
                                    end)
                                end
                            end)
                        else if msg == "unfarm" then
                                getgenv().lb = false
                            else if msg == "Unfarm" then
                                    getgenv().lb = false
                                else if msg == "z" then
                                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1)
                                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) 
                                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) 
                                    else if msg == "Z" then
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1)
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) 
                                            game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) 
                                        else if msg == "kill" then
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1)
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) 
                                                game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1)  
                                            else if msg == "Kill" then
                                                    game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1)
                                                    game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) 
                                                    game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1) game:GetService("ReplicatedStorage").Events.Punch:FireServer(0,0.4,1)  
                                                else if msg == "help" then
                                                        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Commands: farm, unfarm, reset, kill","All")
                                                    else if msg == "Help" then
                                                            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Commands: farm, unfarm, reset, kill","All")
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end);
-- Kill Player Toggle
TargetSection:NewToggle("Kill Player", "Quickly teleports to and attacks target player", function(state)
    if state then
        -- Enable flags
        getgenv().killplr = true
        getgenv().breakv = true

        -- Validate target
        local function getTarget()
            local target = game.Players:FindFirstChild(_G.tplayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                return target
            else
                warn("[Kill] Invalid target:", _G.tplayer)
                return nil
            end
        end

        local targetPlayer = getTarget()
        if not targetPlayer then return end

        -- Break velocity spam loop
        task.spawn(function()
            while getgenv().breakv do
                pcall(function()
                    breakvelocity() -- Make sure breakvelocity() exists
                    game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", true)
                end)
                task.wait(0.25) -- Faster frequency
            end
        end)

        -- Kill loop
        task.spawn(function()
            local localPlayer = game.Players.LocalPlayer
            while getgenv().killplr do
                task.wait(0.1) -- Much faster

                pcall(function()
                    local target = getTarget()
                    if not target then return end

                    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
                    if targetHRP and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        localPlayer.Character.HumanoidRootPart.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 1)
                    end
                end)

                -- Spam punch rapidly
                pcall(function()
                    for _ = 1, 20 do
                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0, 0.05, 1)
                    end
                end)
            end
        end)
    else
        -- Disable everything
        getgenv().killplr = false
        getgenv().breakv = false
    end
end)


    
    TargetSection:NewToggle("Stick To Player", "", function(state)
        if state then
            getgenv().loopgoto = true;
            local varX = player.Character.HumanoidRootPart.Position['X'];
            local varY = player.Character.HumanoidRootPart.Position['Y'];
            local varZ = player.Character.HumanoidRootPart.Position['Z'];
            wait();
            local p1 = game.Players.LocalPlayer.Character.HumanoidRootPart;
            local pos = p1.CFrame;
            getgenv().breakv = true;
            spawn(function()
                while breakv do
                    wait(1);
                    breakvelocity();
                end
            end);
            while loopgoto do
                task.wait();
                spawn(function()
                    pcall(function()
                        for i, v in pairs(game.Workspace:GetChildren()) do
                            if ((v.Name == _G.tplayer) and v:FindFirstChild("Humanoid") and (v.Humanoid.Health > 0)) then
                                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4);
                            end
                        end
                    end);
                end);
                spawn(function()
                    if (loopgoto == false) then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(varX, varY, varZ);
                    end
                end);
            end
        else
            spawn(function()
                getgenv().breakv = false;
                wait(0.2);
                getgenv().loopgoto = false;
                wait(0.1);
                getgenv().loopgoto = true;
                breakvelocity();
            end);
        end
    end);
-- Anti-Telekinesis Toggle
TargetSection:NewToggle("Gives Player Anti-Tele", "Gives Assigned Player Anti Tele", function(state)
    -- Ensure the player variable is set correctly
    local playerName = _G.tplayer
    local player = game:GetService("Players"):FindFirstChild(playerName)
    
    if not player then
        warn("Player not found: " .. tostring(playerName))
        return
    end

    -- Activate or deactivate anti-telekinesis
    getgenv().at = state

    if state then
        -- Start the anti-telekinesis loop
        spawn(function()
            while getgenv().at do
                pcall(function()
                    -- Ensure the player's character exists
                    if player.Character then
                        -- Disable telekinesis for the player
                        game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(
                            Vector3.new(0, 0, 0), -- No specific position
                            false,               -- Disable telekinesis
                            player.Character     -- Target the player's character
                        )
                    end
                end)

                -- Wait briefly before the next check to avoid high CPU usage
                task.wait(0.1)
            end
        end)
    else
        -- Deactivate anti-telekinesis
        print("Anti-Telekinesis deactivated for " .. tostring(playerName))
    end
end)

-- TP Orbs to Players in Telekinesis Toggle
TargetSection:NewToggle("TP orbs to Players in telekinesis", "", function(state)
    function TpOrbs()
        if state then
            getNearPlayer(999999)
            getgenv().ORBGIVE = true
            while getgenv().ORBGIVE do
                for _, v in pairs(plrlist) do
                    if v ~= player then
                        local targetCharacter = game.Players[v.Name] and game.Players[v.Name].Character
                        if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
                            local hrp = targetCharacter.HumanoidRootPart
                            for _, orb in pairs(game:GetService("Workspace").ExperienceOrbs:GetChildren()) do
                                orb.CFrame = hrp.CFrame
                            end
                        end
                    end
                    wait()
                end
                wait()
            end
        else
            getgenv().ORBGIVE = false
        end
    end

    spawn(function()
        TpOrbs()
    end)
end)

    
TargetSection:NewToggle("Laser", "Toggle laser vision to target a player", function(state)
    spawn(function()
        -- Reference to the remote event
        local event = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ToggleLaserVision")

        if state then
            -- Enable Laser Logic
            getgenv().LaserL = true

            -- Invoke the server to activate laser and get the laser part
            local part = event:InvokeServer(true)

            if part and part:IsA("BasePart") then
                while getgenv().LaserL and task.wait() do
                    -- Get the target player
                    local targetPlayer = game.Players:FindFirstChild(_G.tplayer)

                    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        -- Set the laser part's position to the target's root
                        part.Position = targetPlayer.Character.HumanoidRootPart.Position
                    else
                        warn("[Laser Vision] Target player or their HumanoidRootPart not found.")
                    end
                end
                -- Deactivate laser when the loop ends
                event:InvokeServer(false)
            else
                warn("[Laser Vision] Failed to get a valid laser part from the server.")
            end
        else
            -- Disable Laser
            getgenv().LaserL = false
        end
    end)
end)


    TargetSection:NewToggle("Laser From Sky", "Laser Beams Assigned Player From Sky", function(state)
        spawn(function()
            if state then
                local orbX = player.Character.HumanoidRootPart.Position["X"];
                local orbY = player.Character.HumanoidRootPart.Position["Y"];
                local orbZ = player.Character.HumanoidRootPart.Position["Z"];
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(orbX, 5000, orbZ);
                getgenv().LaserL = true;
                wait(0.2);
                player.Character.HumanoidRootPart.Anchored = true;
                coroutine.resume(coroutine.create(function()
                    local event = game:GetService("ReplicatedStorage").Events.ToggleLaserVision;
                    local part = event:InvokeServer(true);
                    getgenv().LaserL = true;
                    while LaserL and part and _G.tplayer do
                        wait();
                        local target = game.Players:FindFirstChild(_G.tplayer);
                        if (target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")) then
                            part.Position = target.Character.HumanoidRootPart.Position;
                        end
                    end
                    event:InvokeServer(false);
                end));
            else
                player.Character.HumanoidRootPart.Anchored = false;
                spawn(function()
                    getgenv().LaserL = false;
                end);
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(orbX, orbY, orbZ);
                breakvelocity();
            end
        end);
    end);
    TargetSection:NewToggle("Give Orbs", "", function(state)
        spawn(function()
            if state then
                getgenv().ORBGIVE = true
                while ORBGIVE do
                    local targetPlayer = game.Players:FindFirstChild(_G.tplayer)
                    if targetPlayer and targetPlayer.Character then
                        local character = targetPlayer.Character
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        
                        if hrp then
                            for _, orb in pairs(game:GetService("Workspace").ExperienceOrbs:GetChildren()) do
                                -- Position the orb slightly above the player's head
                                local orbPosition = hrp.Position + Vector3.new(0, 5, 0) -- Adjust height as needed
                                orb.CFrame = CFrame.new(orbPosition)
                            end
                        end
                    end
                    wait()
                end
            else
                getgenv().ORBGIVE = false
            end
        end)
    end)
    
    TargetSection:NewButton("Remove Gyro", "", function()
        local targetPlayer = game:GetService("Workspace")[_G.tplayer]
        if targetPlayer then
            local hrp = targetPlayer:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp:FindFirstChild("telekinesisGyro"):Destroy()
                hrp:FindFirstChild("telekinesisPosition"):Destroy()
            end
    
            local humanoid = targetPlayer:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
                humanoid.WalkSpeed = 200
                humanoid.JumpPower = 150
            end
        end
    end)
    
    TargetSection:NewToggle("Disable Telekinesis", "", function(state)
        spawn(function()
            if state then
                getgenv().LToggle = true
                local Players = game:GetService("Players")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                
                for _, player in pairs(Players:GetPlayers()) do
                    spawn(function()
                        while getgenv().LToggle do
                            wait()
                            ReplicatedStorage.Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, player.Character)
                        end
                    end)
                end
            else
                getgenv().LToggle = false
            end
        end)
    end)


local shieldBurstIntensity = 1  -- Default intensity for shield activations
local shieldBurstActive = false  -- Tracks if Shield Burst is currently active

-- Slider to adjust Shield Burst intensity
ASection:NewSlider("Shield Burst Intensity", "Adjust the power of the Shield Burst", 99999999, 99999, 1, function(value)
    shieldBurstIntensity = value
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Shield Burst Intensity Set",
        Text = "Shield burst intensity set to: " .. shieldBurstIntensity,
        Duration = 3,
    })
end)

-- Toggle for Shield Burst
ASection:NewToggle("Shield Burst - Age Of Heroes", "Toggle Shield Burst effect", function(state)
    shieldBurstActive = state  -- Update the Shield Burst state

    if shieldBurstActive then
        -- Begin Shield Burst in a coroutine to prevent blocking the main thread
        coroutine.wrap(function()
            local burstCount = 0  -- Tracks number of activations
            
            while shieldBurstActive do
                -- Fire the shield activation event
                game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(true)

                burstCount = burstCount + 1  -- Increment the activation count
                
                -- If burst count reaches set intensity, reset or pause briefly
                if burstCount >= shieldBurstIntensity then
                    burstCount = 0
                    wait(0.3)  -- Pause briefly after reaching max burst for smoother performance
                end

                wait(0.1)  -- Control frequency of shield activations
            end

            -- Turn off shield when Shield Burst is deactivated
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false)
        end)()
    else
        -- Ensure shield is turned off when Shield Burst toggle is deactivated
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false)
    end
end)

-------------------------------------------------------------------------------------------
    
    -- Toggleable Aura Button for Controlled Ground Crack Activation
ASection:NewToggle("Ground Crack Aura", "", function(state)
    -- Toggle control
    getgenv().GroundCrackAuraActive = state

    -- Set cooldown interval in seconds to reduce frequency
    local crackCooldown = 0.2
    local lastCrackTime = 0

    -- Function to activate Ground Crack with cooldown
    local function activateGroundCrack()
        if (tick() - lastCrackTime) >= crackCooldown then
            lastCrackTime = tick()
            pcall(function()
                -- Fire GroundCrack event at a controlled rate
                game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer()
            end)
        end
    end

    -- Manage aura activation with RunService Stepped
    local auraConnection
    if state then
        -- Enable aura with interval checking to reduce lag
        auraConnection = game:GetService("RunService").Stepped:Connect(function()
            if getgenv().GroundCrackAuraActive then
                activateGroundCrack()
            else
                auraConnection:Disconnect()
            end
        end)
    else
        -- Disable the aura
        getgenv().GroundCrackAuraActive = false
        if auraConnection then auraConnection:Disconnect() end
    end
end)


    ASection:NewToggle("Anti-Grab --- Remastered", "", function(state)
        getgenv().AntiT = state  -- Directly set AntiT based on the button state
    
        -- Function to continuously protect the player from grabs
        local function protectPlayer()
            pcall(function()
                local playerToProtect = game.Players.LocalPlayer
                if playerToProtect and playerToProtect.Character then
                    x999999999999999999999999999999999.Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), true, playerToProtect.Character)
                end
            end)
        end
    
        -- Connection to continuously protect the player
        local stepConnection
        stepConnection = game:GetService("RunService").Stepped:Connect(function()
            if getgenv().AntiT then
                protectPlayer() 
            else
                if stepConnection then  -- Check if the connection is active before disconnecting
                    stepConnection:Disconnect()
                end
            end
        end)
    end)
    -- Variable to store the speed intensity from the slider
    local speedIntensity = 1  -- Default value
    local isSpamming = false   -- Variable to track if spamming is active
    
    -- Slider to adjust speed intensity
    ASection:NewSlider("Speed Intensity", "", 100, 1, 0, function(value)
        speedIntensity = value
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Speed Intensity Set",
            Text = "Speed intensity set to: " .. speedIntensity,
        })
    end)
    
    -- Toggle for Speed Spam
    ASection:NewToggle("Speed Spam - Age Of Heroes", "", function(state)
        isSpamming = state -- Update the spamming state
    
        if isSpamming then
            -- Continuously enable speed based on the set intensity
            while isSpamming do
                game:GetService("ReplicatedStorage").Events.ToggleSpeed:FireServer(true) -- Turn on speed
                wait(0.1)  -- Small wait to avoid overwhelming the client
            end
        else
            -- Ensure speed is disabled if spamming is stopped
            game:GetService("ReplicatedStorage").Events.ToggleSpeed:FireServer(false) -- Turn off speed
        end
    end)
    
    ----------------------------------------------------------------------------------------------
    
    -- Toggle for Telekinesis Action
    ASection:NewToggle("Telekinesis Action", "", function(state)
        if state then
            getgenv().LaserV = true -- Enable the telekinesis actions
            spawn(function()
                local LookVector = game.Workspace.Camera.CFrame.LookVector
                local player = game.Players.LocalPlayer
    
                -- Telekinesis Lock
                game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, true)
                wait(0.1) -- Brief wait before disabling
    
                -- Telekinesis Kill
                getNearPlayer(99)  -- Assuming this function populates plrlist
                for _, v in pairs(plrlist) do
                    if v ~= player then  -- Ensure not targeting self
                        spawn(function()
                            if v.Character and v.Character:FindFirstChild("Head") and v.Character.Head:FindFirstChild("Neck") then
                                v.Head.Neck:Destroy()  -- Kill the player
                            end
                            plrlist = {}  -- Clear the player list after action
                            wait(0.2)  -- Delay before the next action
                            spawn(function()
                                game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[v.Name].Character)
                            end)
                        end)
                    end
                end
                
                -- Disable Telekinesis after action
                game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(LookVector, false)
            end)
        else
            -- Disable any ongoing actions if the toggle is turned off
            getgenv().LaserV = false
        end
    end)
    ---------------------------------------------------------------------------------------------
    -- Toggle for Rapid Heavy Punch
    ASection:NewToggle("Rapid Heavy Punch", "", function(state)
        getgenv().Hrapid = state  -- Update the state of the rapid punching
    
        local UserInputService = game:GetService("UserInputService")
        
        if state then
            -- When the toggle is turned on
            local function onInputEnded(inputObject, gameProcessedEvent)
                if gameProcessedEvent then
                    return
                end
                if getgenv().Hrapid and (inputObject.UserInputType == Enum.UserInputType.MouseButton1) then
                    -- Loop to perform the punching action
                    for i = 1, 10 do  -- Number of punches
                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(0.4, 0.1, 1)
                        wait(0.1)  -- Small wait to avoid overwhelming the server
                    end
                end
            end
            UserInputService.InputEnded:Connect(onInputEnded)
        else
            -- When the toggle is turned off
            getgenv().Hrapid = false
        end
    end)
    

    ---------------------------------------------------------------------------------------------
    ASection:NewButton("Super Mega Crash", "", function(state)
        local totalIterations = 25000 -- Set total iterations
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local toggleBlockingEvent = replicatedStorage.Events.ToggleBlocking
    
        -- Function to fire the server event with a delay
        local function fireEvent(times)
            for i = 1, times do
                toggleBlockingEvent:FireServer("true")
                wait(0.01) -- Small delay to prevent server overload (adjust as needed)
            end
        end
    
        -- Spawn three threads to fire the event with dynamic counts
        spawn(function()
            fireEvent(math.ceil(totalIterations * 0.5)) -- 50% of total iterations
        end)
    
        spawn(function()
            fireEvent(math.ceil(totalIterations * 0.75)) -- 75% of total iterations
        end)
    
        spawn(function()
            fireEvent(totalIterations) -- 100% of total iterations
        end)
    
        -- Fire the toggleBlocking event with false after all events
        wait(totalIterations * 0.01 * 3) -- Adjust wait based on total calls (considering the delay)
        toggleBlockingEvent:FireServer(false)
    end)
    ------thug esp
    ASection:NewToggle("ESP Thugs Outline", "", function(state)
        if state then
            getgenv().ESPEnabled = true
            
            -- Function to add an outline to Thug models
            local function addOutline(thug)
                local highlight = Instance.new("Highlight") -- Create a new Highlight instance
                highlight.Parent = thug -- Parent it to the Thug model
                highlight.FillTransparency = 1 -- Make the center transparent
                highlight.OutlineTransparency = 0 -- Outline should be fully visible
                highlight.OutlineColor = Color3.fromRGB(255, 192, 203) -- Set outline color to pink
            end
            
            -- Apply outline to existing Thugs
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Model") and v.Name == "Thug" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    addOutline(v)
                end
            end
            
            -- Listen for new Thugs being added to the workspace
            workspace.ChildAdded:Connect(function(child)
                if child:IsA("Model") and child.Name == "Thug" and child:FindFirstChild("Humanoid") then
                    child:WaitForChild("Humanoid").Died:Connect(function()
                        -- Cleanup when Thug dies
                        if child:FindFirstChild("Highlight") then
                            child.Highlight:Destroy() -- Remove the Highlight
                        end
                    end)
                    addOutline(child) -- Add outline to the new Thug
                end
            end)
    
            -- Continuous update for outline effect
            while getgenv().ESPEnabled do
                for _, v in pairs(workspace:GetChildren()) do
                    if v:IsA("Model") and v.Name == "Thug" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        if not v:FindFirstChildOfClass("Highlight") then
                            addOutline(v) -- Add outline if it doesn't exist
                        end
                    end
                end
                wait(1) -- Check every second
            end
    
        else
            getgenv().ESPEnabled = false
            -- Cleanup: remove all outlines
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Model") and v.Name == "Thug" then
                    if v:FindFirstChild("Highlight") then
                        v.Highlight:Destroy() -- Remove the Highlight
                    end
                end
            end
        end
    end)
    
    --Police
    ASection:NewToggle("ESP Police Outline", "", function(state)
        if state then
            getgenv().ESPEnabled = true
            
            -- Function to add an outline to Police models
            local function addOutline(police)
                local highlight = Instance.new("Highlight") -- Create a new Highlight instance
                highlight.Parent = police -- Parent it to the Police model
                highlight.FillTransparency = 1 -- Make the center transparent
                highlight.OutlineTransparency = 0 -- Outline should be fully visible
                highlight.OutlineColor = Color3.fromRGB(0, 0, 255) -- Set outline color to blue
            end
            
            -- Apply outline to existing Police
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Model") and v.Name == "Police" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    addOutline(v)
                end
            end
            
            -- Listen for new Police being added to the workspace
            workspace.ChildAdded:Connect(function(child)
                if child:IsA("Model") and child.Name == "Police" and child:FindFirstChild("Humanoid") then
                    child:WaitForChild("Humanoid").Died:Connect(function()
                        -- Cleanup when Police dies
                        if child:FindFirstChild("Highlight") then
                            child.Highlight:Destroy() -- Remove the Highlight
                        end
                    end)
                    addOutline(child) -- Add outline to the new Police
                end
            end)
    
            -- Continuous update for outline effect
            while getgenv().ESPEnabled do
                for _, v in pairs(workspace:GetChildren()) do
                    if v:IsA("Model") and v.Name == "Police" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        if not v:FindFirstChildOfClass("Highlight") then
                            addOutline(v) -- Add outline if it doesn't exist
                        end
                    end
                end
                wait(1) -- Check every second
            end
    
        else
            getgenv().ESPEnabled = false
            -- Cleanup: remove all outlines
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Model") and v.Name == "Police" then
                    if v:FindFirstChild("Highlight") then
                        v.Highlight:Destroy() -- Remove the Highlight
                    end
                end
            end
        end
    end)
    --Civilians 
    ASection:NewToggle("ESP Civilians Outline", "", function(state)
        if state then
            getgenv().ESPEnabled = true
            
            -- Function to add an outline to Civilian models
            local function addOutline(civilian)
                local highlight = Instance.new("Highlight") -- Create a new Highlight instance
                highlight.Parent = civilian -- Parent it to the Civilian model
                highlight.FillTransparency = 1 -- Make the center transparent
                highlight.OutlineTransparency = 0 -- Outline should be fully visible
                highlight.OutlineColor = Color3.fromRGB(0, 255, 255) -- Set outline color to cyan
            end
            
            -- Apply outline to existing Civilians
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Model") and v.Name == "Civilian" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    addOutline(v)
                end
            end
            
            -- Listen for new Civilians being added to the workspace
            workspace.ChildAdded:Connect(function(child)
                if child:IsA("Model") and child.Name == "Civilian" and child:FindFirstChild("Humanoid") then
                    child:WaitForChild("Humanoid").Died:Connect(function()
                        -- Cleanup when Civilian dies
                        if child:FindFirstChild("Highlight") then
                            child.Highlight:Destroy() -- Remove the Highlight
                        end
                    end)
                    addOutline(child) -- Add outline to the new Civilian
                end
            end)
    
            -- Continuous update for outline effect
            while getgenv().ESPEnabled do
                for _, v in pairs(workspace:GetChildren()) do
                    if v:IsA("Model") and v.Name == "Civilian" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        if not v:FindFirstChildOfClass("Highlight") then
                            addOutline(v) -- Add outline if it doesn't exist
                        end
                    end
                end
                wait(1) -- Check every second
            end
    
        else
            getgenv().ESPEnabled = false
            -- Cleanup: remove all outlines
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Model") and v.Name == "Civilian" then
                    if v:FindFirstChild("Highlight") then
                        v.Highlight:Destroy() -- Remove the Highlight
                    end
                end
            end
        end
    end)
    
    -- Players
    ASection:NewToggle("ESP Players Galaxy Outline", "", function(state)
        if state then
            getgenv().ESPEnabled = true
    
            -- Function to create a cycling color effect for the galaxy outline
            local function addGalaxyOutline(playerModel)
                local highlight = Instance.new("Highlight")
                highlight.Parent = playerModel
                highlight.FillTransparency = 1
                highlight.OutlineTransparency = 0
    
                -- Cycle through colors to create a "galaxy" effect
                coroutine.wrap(function()
                    while getgenv().ESPEnabled and highlight.Parent do
                        for hue = 0, 1, 0.01 do
                            highlight.OutlineColor = Color3.fromHSV(hue, 0.8, 1) -- Bright, saturated colors
                            wait(0.1) -- Adjust speed of color change
                        end
                    end
                end)()
            end
    
            -- Apply galaxy outline to all players except the local player
            local localPlayer = game:GetService("Players").LocalPlayer
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    addGalaxyOutline(player.Character)
                end
            end
    
            -- Detect new players entering the game
            game:GetService("Players").PlayerAdded:Connect(function(player)
                if player ~= localPlayer then
                    player.CharacterAdded:Connect(function(character)
                        if character:FindFirstChild("Humanoid") then
                            addGalaxyOutline(character)
                        end
                    end)
                end
            end)
    
            -- Continuous check for player characters and add outline if missing
            while getgenv().ESPEnabled do
                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                        if not player.Character:FindFirstChildOfClass("Highlight") then
                            addGalaxyOutline(player.Character)
                        end
                    end
                end
                wait(1) -- Check every second
            end
    
        else
            getgenv().ESPEnabled = false
            -- Cleanup: remove all outlines
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player.Character and player.Character:FindFirstChildOfClass("Highlight") then
                    player.Character.Highlight:Destroy()
                end
            end
        end
    end)
    
    -- Add the Anti-AFK toggle to your ASection
    ASection:NewToggle("Anti AFK", "Prevents you from being marked as AFK", function(state)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
    
        -- Variable to track Anti-AFK status
        getgenv().AntiAFKEnabled = state
    
        if state then
            -- Create a connection to keep the player active
            if not getgenv().AntiAFKConnection then
                getgenv().AntiAFKConnection = RunService.Heartbeat:Connect(function()
                    if getgenv().AntiAFKEnabled then
                        local player = Players.LocalPlayer
                        if player and player.Character then
                            -- Simulate character movement to prevent AFK status
                            local humanoid = player.Character:FindFirstChild("Humanoid")
                            if humanoid then
                                humanoid:Move(Vector3.new(0, 0, 0), true) -- Refresh movement
                            end
                        end
                    end
                end)
            end
        else
            -- Disconnect the connection when Anti-AFK is disabled
            if getgenv().AntiAFKConnection then
                getgenv().AntiAFKConnection:Disconnect()
                getgenv().AntiAFKConnection = nil
            end
        end
    end)

    ----------------------------------------------------------------------------------------------
    ASection:NewButton("Anti-Lag", "", optimizePerformance)
    ASection:NewButton("Ground Crack Lag", "", function(state)
        for i = 1, 1000 do
            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
        end
    end);
    ASection:NewButton("Mini Ground Crack Lag", "", function(state)
        for i = 1, 500 do
            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
        end
    end);
    ASection:NewButton("Mini Mini Ground Crack Lag", "", function(state)
        for i = 1, 200 do
            game:GetService("ReplicatedStorage").Events.GroundCrack:FireServer();
        end
    end);
    ASection:NewButton("Mini Crash", "", function(state)
        local x = 0;
        repeat
            x += 1
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
        until x == 5000 
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
        wait();
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
     end);
   ASection:NewButton("Super Crash", "", function(state)
    local x = 0;
    local y = 0
    local z = 0
    spawn(function()
    repeat
        x += 1
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
    until x == 10000
    end)
    spawn(function()
    repeat
        y += 1
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
    until y == 10000 
    end)
    spawn(function()
    repeat
        z += 1
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
    until z == 10000 
    end)
    
    
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
        wait();
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
    end);
    ASection:NewButton("Haha crasher", "Initiates secure blocking actions.", function()
        -- Initialize counters
        local x, y, z = 0, 0, 0
    
        -- Helper function to safely fire the event with rate-limiting and validation
        local function safeFireServer(event, action, counter, max)
            if counter < max then
                event:FireServer(action)
                return counter + 1
            else
                warn("Maximum limit reached for firing this event.")
                return counter
            end
        end
    
        -- Function to execute repetitive actions securely
        local function executeSafeAction(maxCount, eventName, action)
            local counter = 0
            local event = game:GetService("ReplicatedStorage").Events[eventName]
    
            spawn(function()
                repeat
                    counter = safeFireServer(event, action, counter, maxCount)
                    task.wait(0.001) -- Add a short delay to reduce spam and avoid abuse
                until counter >= maxCount
            end)
        end
    
        -- Execute secure actions with proper limits
        executeSafeAction(25000, "ToggleBlocking", "true")
        executeSafeAction(25000, "ToggleBlocking", "true")
        executeSafeAction(25000, "ToggleBlocking", "true")
        executeSafeAction(25000, "ToggleBlocking", "true")
        executeSafeAction(25000, "ToggleBlocking", "true")
        executeSafeAction(25000, "ToggleBlocking", "true")
        executeSafeAction(25000, "ToggleBlocking", "true")
        executeSafeAction(25000, "ToggleBlocking", "true")

        -- Additional state changes (if required)
        local blockingEvent = game:GetService("ReplicatedStorage").Events.ToggleBlocking
        task.wait(0.5) -- Short delay to allow previous actions to settle
        blockingEvent:FireServer(false)
        task.wait(0.5)
        blockingEvent:FireServer(false)
    end)
    
    

    ASection:NewButton("Super Mega Crash", "", function(state)
    local x = 0;
    local y = 0
    local z = 0
    spawn(function()
    repeat
        x += 1
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
    until x == 25000
    end)
    spawn(function()
    repeat
        y += 1
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
    until y == 25000 
    end)
    spawn(function()
    repeat
        z += 1
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer("true");
    until z == 25000 
    end)
    
    
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
        wait();
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false);
    end);
    ASection:NewButton("Global Anti-Crash", "", function()
        -- Check and destroy the objects safely
        if game:FindFirstChild("ClientStorage") and game.ClientStorage:FindFirstChild("Effects") then
            if game.ClientStorage.Effects:FindFirstChild("Shield") then
                game.ClientStorage.Effects.Shield:Destroy()
            end
        end
        if game:FindFirstChild("Workspace") and game.Workspace:FindFirstChild("Effects") then
            game.Workspace.Effects:Destroy()
        end
    end)
    
    -- To make the button global, repeat it in other sections or centralize its functionality:
    local GlobalButton = function()
        if game:FindFirstChild("ClientStorage") and game.ClientStorage:FindFirstChild("Effects") then
            if game.ClientStorage.Effects:FindFirstChild("Shield") then
                game.ClientStorage.Effects.Shield:Destroy()
            end
        end
        if game:FindFirstChild("Workspace") and game.Workspace:FindFirstChild("Effects") then
            game.Workspace.Effects:Destroy()
        end
    end

    ASection:NewButton("Anti-Crash", "", function()
      game.ClientStorage.Effects.Shield:Destroy()
      game.Workspace.Effects:destroy() 
    end);
    GetList();
    ----
    -- Variable to store the crash intensity from the slider
    local webIntensity = 1  -- Default value for web ability
    local isWebSpamming = false  -- Variable to track if web spamming is active
    
    ------
    -- Variable to store the swinging intensity from the slider
    local swingIntensity = 1  -- Default value for swinging
    local isSwinging = false   -- Variable to track if swinging is active
    
    -- Slider to adjust swinging intensity
    ASection:NewSlider("Swinging Intensity", "", 100, 1, 0, function(value)
        swingIntensity = value
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Swinging Intensity Set",
            Text = "Swinging intensity set to: " .. swingIntensity,
        })
    end)

    local ASection = ATab:NewSection("Fly that has a KeyBind");
    -- Fly
    local FlyEnabled = false
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local flying = false
    
    local function fly()
        if not flying then
            flying = true
            local bg = Instance.new("BodyGyro", humanoidRootPart)
            local bv = Instance.new("BodyVelocity", humanoidRootPart)
            bg.P = 9e4
            bg.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
            bg.CFrame = workspace.CurrentCamera.CFrame
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.MaxForce = Vector3.new(9e4, 9e4, 9e4)
    
            game:GetService("RunService").RenderStepped:Connect(function()
                if flying then
                    bv.Velocity = (workspace.CurrentCamera.CFrame.LookVector * 50)
                    bg.CFrame = workspace.CurrentCamera.CFrame
                end
            end)
        else
            flying = false
            humanoidRootPart:FindFirstChild("BodyGyro"):Destroy()
            humanoidRootPart:FindFirstChild("BodyVelocity"):Destroy()
        end
    end
    
    ASection:NewToggle("Fly", "Enable Fly", function(state)
        fly()
    end)
    ----------------------------------------------------------------------------------------------
    
    KSection:NewKeybind("MetalSkin", "", Enum.KeyCode['LeftShift'], function()
        if (_G.metalskin == false) then
            game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", true);
            _G.metalskin = true;
        else
            game:GetService("ReplicatedStorage").Events.Transform:FireServer("metalSkin", false);
            _G.metalskin = false;
         end
    end);
    local player = game.Players.LocalPlayer
    local plrlist = {}
    
    KSection:NewKeybind("Carry Player", "", Enum.KeyCode.H, function()
        if (_G.CToggle == false) then
            spawn(function()
                getNearPlayer(99);
                wait();
                _G.CToggle = true;
                getgenv().CarryP = true;
                while CarryP do
                    wait();
                    spawn(function()
                        for i, v in pairs(plrlist) do
                            if (v == player) then
                            else
                                Xt = player.Character.HumanoidRootPart.Position['X'];
                                Yt = player.Character.HumanoidRootPart.Position['Y'];
                                Zt = player.Character.HumanoidRootPart.Position['Z'];
                                game:GetService("Workspace")[v.Name].HumanoidRootPart.telekinesisPosition.Position = Vector3.new(Xt, Yt + 8, Zt + 5);
                            end
                        end
                    end);
                end
            end);
        else
            spawn(function()
                _G.CToggle = false;
                plrlist = {};
                getgenv().CarryP = false;
            end);
        end
    end);


    KSection:NewKeybind("Telekinesis Lock", "", Enum.KeyCode['T'], function()
        spawn(function()
            local LookVector = game.Workspace.Camera.CFrame.LookVector
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
            -- Toggle Telekinesis On and Off
            local ToggleEvent = ReplicatedStorage.Events.ToggleTelekinesis
            ToggleEvent:InvokeServer(LookVector, true)
            ToggleEvent:InvokeServer(LookVector, false)
        end)
    end)
    
    KSection:NewKeybind("Telekinesis Kill", "", Enum.KeyCode['G'], function()
        spawn(function()
            getNearPlayer(99) -- Populates `plrlist` with nearby players
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local ToggleEvent = ReplicatedStorage.Events.ToggleTelekinesis
    
            for _, v in pairs(plrlist) do
                if v ~= player and v:FindFirstChild("Head") and v.Head:FindFirstChild("Neck") then
                    spawn(function()
                        -- Destroy Neck to simulate a "kill"
                        v.Head.Neck:Destroy()
    
                        -- Ensure the player is removed from the list after interaction
                        wait(0.2)
                        spawn(function()
                            if v and v.Character then
                                ToggleEvent:InvokeServer(Vector3.new(1, 1, 1), false, v.Character)
                            end
                        end)
                    end)
                end
            end
    
            -- Clear the player list after execution
            plrlist = {}
        end)
    end)

    KSection:NewKeybind("Telekinesis Kill (Target Only)", "Instant kill using Telekinesis on selected target", Enum.KeyCode.Seven, function()
      task.spawn(function()
        getNearPlayer(999999) -- Populate plrlist with all nearby players
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local ToggleEvent = ReplicatedStorage.Events.ToggleTelekinesis
        local targetPlayer = game.Players:FindFirstChild(_G.tplayer)

        -- Validate target
        if targetPlayer and targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
            local head = targetPlayer.Character.Head
            local neck = head:FindFirstChild("Neck")

            -- Destroy the neck to "kill"
            if neck then
                pcall(function()
                    neck:Destroy()
                end)
            end

            -- Trigger Telekinesis shortly after
            task.delay(0.15, function()
                pcall(function()
                    if targetPlayer and targetPlayer.Character then
                        ToggleEvent:InvokeServer(Vector3.new(1, 1, 1), false, targetPlayer.Character)
                    end
                end)
            end)
        else
            warn("[Telekinesis Kill] Target player not found or invalid: " .. tostring(_G.tplayer))
        end

        plrlist = {} -- Clean up
      end)
    end)

    KSection:NewKeybind("Teleport To Motel", "", Enum.KeyCode.Z, function()
      if (_G.bring == true) then
            game:GetService("Workspace")[_G.teleportplayer].HumanoidRootPart.telekinesisPosition:Destroy()
            game:GetService("Workspace")[_G.teleportplayer].HumanoidRootPart.CFrame = CFrame.new(-1745, 95, -1530);
            wait(0.2)
            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[_G.teleportplayer].Character);
        else
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1745, 95, -1530);
        end
        breakvelocity();
    end);
    KSection:NewKeybind("Teleport To Middle", "", Enum.KeyCode.V, function()
     if (_G.bring == true) then
            game:GetService("Workspace")[_G.teleportplayer].HumanoidRootPart.telekinesisPosition:Destroy()
            game:GetService("Workspace")[_G.teleportplayer].HumanoidRootPart.CFrame = CFrame.new(-376, 94, 91);
            wait(0.2)
            game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(Vector3.new(1, 1, 1), false, game.Players[_G.teleportplayer].Character);
        else
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-376, 94, 91);
        end
        breakvelocity();
    end);
    KSection:NewKeybind("Toggle UI", "", Enum.KeyCode.Y, function()
        Library:ToggleUI();
    end);
    GSection:NewButton("Infinite Yield", "", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end);
    GSection:NewButton("Chat Spammer", "", function()
        loadstring(game:HttpGet(('https://raw.githubusercontent.com/ColdStep2/Chatdestroyer-Hub-V1/main/Chatdestroyer%20Hub%20V1'),true))()
    end);
    GSection:NewButton("Dex/Explorer", "", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end);
    GSection:NewButton("Chat Spoofer", "", function()
        loadstring(game:HttpGet(('https://pastebin.com/raw/djBfk8Li'),true))()
    end);
    GSection:NewButton("Chat bypasser", "", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/synnyyy/synergy/additional/betterbypasser", true))()
    end)
