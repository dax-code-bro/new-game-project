--!strict
--[[
	CameraController.luau — First-person camera with mouse-look, head bob, and ADS.
	This is the most important controller for game feel.
	Runs on RenderStepped (before rendering) for zero-latency camera.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared.Constants)

local CameraController = {}

-- Internal state
local camera: Camera = workspace.CurrentCamera :: Camera
local player = Players.LocalPlayer :: Player

-- Look angles (accumulated from mouse input)
local yaw: number = 0 -- horizontal rotation (degrees)
local pitch: number = 0 -- vertical rotation (degrees), clamped

-- Head bob
local bobCycle: number = 0
local bobOffset: Vector3 = Vector3.zero

-- ADS
local currentFov: number = Constants.DEFAULT_FOV
local targetFov: number = Constants.DEFAULT_FOV
local isAds: boolean = false

-- Sway
local swayCycle: number = 0

-- Reference to InputController (set during Init)
local InputController: any = nil

function CameraController.isAds(): boolean
	return isAds
end

function CameraController.getCurrentFov(): number
	return currentFov
end

function CameraController.Init()
	-- Get InputController reference
	local clientScript = player:WaitForChild("PlayerScripts"):WaitForChild("Client")
	InputController = require(clientScript.controllers.InputController)

	-- Configure camera
	camera.CameraType = Enum.CameraType.Scriptable
	camera.FieldOfView = Constants.DEFAULT_FOV

	-- Hide character body from first-person view
	local character = player.Character or player.CharacterAdded:Wait()
	CameraController._hideFirstPersonBody(character)

	player.CharacterAdded:Connect(function(newCharacter: Model)
		CameraController._hideFirstPersonBody(newCharacter)
	end)

	print("[CameraController] Initialized")
end

function CameraController._hideFirstPersonBody(character: Model)
	-- Wait for character to fully load
	task.defer(function()
		character:WaitForChild("HumanoidRootPart", 10)
		for _, part in character:GetDescendants() do
			if part:IsA("BasePart") then
				part.LocalTransparencyModifier = 1
			end
		end

		-- Keep hiding parts as they update
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:GetPropertyChangedSignal("CameraOffset"):Connect(function()
				-- Roblox may reset transparency; re-hide
				for _, partInner in character:GetDescendants() do
					if partInner:IsA("BasePart") then
						partInner.LocalTransparencyModifier = 1
					end
				end
			end)
		end
	end)
end

function CameraController.Start()
	-- Lock mouse
	UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

	RunService.RenderStepped:Connect(function(dt: number)
		local character = player.Character
		if not character then
			return
		end

		local head = character:FindFirstChild("Head") :: BasePart?
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") :: BasePart?
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not head or not humanoidRootPart or not humanoid then
			return
		end

		-- Keep body hidden
		for _, part in character:GetDescendants() do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				part.LocalTransparencyModifier = 1
			end
		end

		-- Mouse look
		local mouseDelta = InputController.getMouseDelta()
		local sensitivity = Constants.MOUSE_SENSITIVITY

		yaw -= mouseDelta.X * sensitivity
		pitch = math.clamp(pitch - mouseDelta.Y * sensitivity, -80, 80)

		-- ADS handling
		isAds = InputController.isAdsHeld()
		if isAds then
			-- targetFov is set by WeaponController based on current weapon
			-- For now use a default zoom
			targetFov = Constants.DEFAULT_FOV * 0.6
		else
			targetFov = Constants.DEFAULT_FOV
		end

		-- Smooth FOV transition
		currentFov = currentFov + (targetFov - currentFov) * math.min(1, dt * Constants.ADS_TRANSITION_SPEED)
		camera.FieldOfView = currentFov

		-- Head bob (only when moving on ground)
		local isMoving = InputController.getMoveDirection().Magnitude > 0.1
		local isOnGround = humanoid.FloorMaterial ~= Enum.Material.Air

		if isMoving and isOnGround then
			local speed = if InputController.isSprinting() then 1.4 else 1.0
			bobCycle += dt * Constants.HEAD_BOB_SPEED * speed
			local bobY = math.sin(bobCycle * math.pi * 2) * Constants.HEAD_BOB_AMOUNT
			local bobX = math.cos(bobCycle * math.pi) * Constants.HEAD_BOB_AMOUNT * 0.5
			bobOffset = Vector3.new(bobX, bobY, 0)
		else
			-- Smoothly return to neutral
			bobOffset = bobOffset:Lerp(Vector3.zero, math.min(1, dt * 8))
			bobCycle = 0
		end

		-- Idle sway (subtle camera movement when standing still)
		swayCycle += dt * 0.5
		local swayX = math.sin(swayCycle * 1.3) * Constants.CAMERA_SWAY_AMOUNT * 0.1
		local swayY = math.cos(swayCycle * 0.9) * Constants.CAMERA_SWAY_AMOUNT * 0.1

		-- Build camera CFrame
		local headPos = head.Position + Vector3.new(0, 0.5, 0) -- slightly above head center
		local lookCFrame = CFrame.new(headPos)
			* CFrame.Angles(0, math.rad(yaw), 0)
			* CFrame.Angles(math.rad(pitch), 0, 0)

		-- Apply bob and sway as small offsets
		local finalCFrame = lookCFrame * CFrame.new(bobOffset + Vector3.new(swayX, swayY, 0))

		camera.CFrame = finalCFrame

		-- Move the character to face the camera direction (so the body follows where we look)
		humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position) * CFrame.Angles(0, math.rad(yaw), 0)

		-- Movement: apply move direction relative to camera yaw
		local moveDir = InputController.getMoveDirection()
		if moveDir.Magnitude > 0.1 then
			local worldDir = CFrame.Angles(0, math.rad(yaw), 0) * moveDir
			local speed = if InputController.isSprinting() then Constants.SPRINT_SPEED else Constants.WALK_SPEED
			humanoid.WalkSpeed = speed
			humanoid:Move(worldDir, false)
		else
			humanoid:Move(Vector3.zero, false)
		end
	end)

	print("[CameraController] Started — first-person camera active")
end

-- Called by WeaponController to set ADS FOV for current weapon
function CameraController.setAdsFov(_fovMultiplier: number)
	-- This will be used during ADS — the multiplier comes from WeaponDef.adsZoom
	-- Applied next frame in RenderStepped
end

-- Called by WeaponController to apply recoil kick
function CameraController.applyRecoil(verticalDeg: number, horizontalDeg: number)
	pitch = math.clamp(pitch + verticalDeg, -80, 80)
	yaw += horizontalDeg
end

return CameraController
