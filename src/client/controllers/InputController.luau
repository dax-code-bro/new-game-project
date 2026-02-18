--!strict
--[[
	InputController.luau — Unified input handling.
	Collects raw input and exposes clean state that other controllers read.
	Other controllers should NEVER listen to UserInputService directly.
]]

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local InputController = {}

-- Current input state (read by other controllers)
local state = {
	-- Movement
	moveDirection = Vector3.zero, -- normalized WASD direction in world space
	isSprinting = false,

	-- Mouse
	mouseDelta = Vector2.zero, -- raw mouse movement this frame
	isMouseButton1Down = false, -- left click (fire)
	isMouseButton2Down = false, -- right click (ADS)

	-- Actions (single-frame pulses, reset each frame)
	reloadPressed = false,
	interactPressed = false,
	inventoryPressed = false,
	jumpPressed = false,

	-- Raw key states
	keysDown = {} :: { [Enum.KeyCode]: boolean },
}

-- Expose read-only access
function InputController.getMoveDirection(): Vector3
	return state.moveDirection
end

function InputController.isSprinting(): boolean
	return state.isSprinting
end

function InputController.getMouseDelta(): Vector2
	return state.mouseDelta
end

function InputController.isFireHeld(): boolean
	return state.isMouseButton1Down
end

function InputController.isAdsHeld(): boolean
	return state.isMouseButton2Down
end

function InputController.consumeReload(): boolean
	if state.reloadPressed then
		state.reloadPressed = false
		return true
	end
	return false
end

function InputController.consumeInteract(): boolean
	if state.interactPressed then
		state.interactPressed = false
		return true
	end
	return false
end

function InputController.consumeInventory(): boolean
	if state.inventoryPressed then
		state.inventoryPressed = false
		return true
	end
	return false
end

function InputController.isKeyDown(key: Enum.KeyCode): boolean
	return state.keysDown[key] == true
end

function InputController.Init()
	-- Lock mouse to center of screen for FPS
	UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

	-- Key down
	UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
		if gameProcessed then
			return
		end

		if input.UserInputType == Enum.UserInputType.Keyboard then
			state.keysDown[input.KeyCode] = true

			if input.KeyCode == Enum.KeyCode.R then
				state.reloadPressed = true
			elseif input.KeyCode == Enum.KeyCode.E then
				state.interactPressed = true
			elseif input.KeyCode == Enum.KeyCode.Tab then
				state.inventoryPressed = true
			elseif input.KeyCode == Enum.KeyCode.Space then
				state.jumpPressed = true
			end
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			state.isMouseButton1Down = true
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			state.isMouseButton2Down = true
		end
	end)

	-- Key up
	UserInputService.InputEnded:Connect(function(input: InputObject, _gameProcessed: boolean)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			state.keysDown[input.KeyCode] = false
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			state.isMouseButton1Down = false
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			state.isMouseButton2Down = false
		end
	end)

	print("[InputController] Initialized")
end

function InputController.Start()
	-- Update movement direction and mouse delta each frame
	RunService.RenderStepped:Connect(function(_dt: number)
		-- Mouse delta
		state.mouseDelta = UserInputService:GetMouseDelta()

		-- Sprint state
		state.isSprinting = state.keysDown[Enum.KeyCode.LeftShift] == true

		-- Calculate movement direction from WASD
		local moveX = 0
		local moveZ = 0

		if state.keysDown[Enum.KeyCode.W] then
			moveZ -= 1
		end
		if state.keysDown[Enum.KeyCode.S] then
			moveZ += 1
		end
		if state.keysDown[Enum.KeyCode.A] then
			moveX -= 1
		end
		if state.keysDown[Enum.KeyCode.D] then
			moveX += 1
		end

		local raw = Vector3.new(moveX, 0, moveZ)
		if raw.Magnitude > 0 then
			state.moveDirection = raw.Unit
		else
			state.moveDirection = Vector3.zero
		end
	end)

	print("[InputController] Started")
end

return InputController
