--!strict
--[[
	WeaponController.luau — Client-side weapon handling with full animations.

	Features:
	- First-person arms (blocky forearms + hands) holding the gun
	- Mouse sway — weapon follows mouse movement with lag
	- Shooting kick-back animation
	- Reload dip animation
	- Walking bob on the weapon
	- Idle breathing motion
	- Smooth ADS transitions

	The client does NOT decide if shots hit — it fires visuals for responsiveness,
	then the server validates and applies damage.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local WeaponDatabase = require(Shared.WeaponDatabase)
local Remotes = require(Shared.Remotes)
local RaycastUtil = require(Shared.utils.Raycast)

local WeaponController = {}

-- References to other controllers (set during Init)
local InputController: any = nil
local CameraController: any = nil

-- State
local player = Players.LocalPlayer :: Player
local camera: Camera = workspace.CurrentCamera :: Camera

local currentWeaponId: string? = nil
local currentWeaponDef: any = nil

local currentAmmo: number = 0
local isReloading: boolean = false
local lastFireTime: number = 0

-- Viewmodel
local viewmodelFolder: Folder? = nil

-- Forward declare
local startReload: () -> ()

-- Animation state (all smoothly interpolated each frame)
local swayOffset: Vector2 = Vector2.zero -- mouse sway
local shootKick: number = 0 -- 0 = resting, 1 = fully kicked
local reloadDip: number = 0 -- 0 = normal, 1 = fully dipped
local walkBobCycle: number = 0
local breathCycle: number = 0
local adsAmount: number = 0

-- Skin color for arms
local ARM_COLOR = Color3.fromRGB(204, 163, 121)

------------------------------------------------------------
-- HELPER: create a Part with common defaults
------------------------------------------------------------

local function makePart(name: string, size: Vector3, color: Color3, material: Enum.Material): Part
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Color = color
	p.Material = material
	p.Anchored = true
	p.CanCollide = false
	p.CastShadow = false
	return p
end

------------------------------------------------------------
-- ARM BUILDING
------------------------------------------------------------

local function buildArms(folder: Folder)
	-- RIGHT ARM (trigger hand)
	local rightForearm = makePart("RightForearm", Vector3.new(0.18, 0.18, 0.55), ARM_COLOR, Enum.Material.SmoothPlastic)
	rightForearm.Parent = folder

	local rightHand = makePart("RightHand", Vector3.new(0.16, 0.14, 0.18), ARM_COLOR, Enum.Material.SmoothPlastic)
	rightHand.Parent = folder

	-- LEFT ARM (support hand)
	local leftForearm = makePart("LeftForearm", Vector3.new(0.18, 0.18, 0.55), ARM_COLOR, Enum.Material.SmoothPlastic)
	leftForearm.Parent = folder

	local leftHand = makePart("LeftHand", Vector3.new(0.16, 0.14, 0.18), ARM_COLOR, Enum.Material.SmoothPlastic)
	leftHand.Parent = folder

	-- Sleeve cuffs (dark, like a jacket)
	local rightSleeve =
		makePart("RightSleeve", Vector3.new(0.2, 0.2, 0.2), Color3.fromRGB(50, 55, 45), Enum.Material.Fabric)
	rightSleeve.Parent = folder

	local leftSleeve =
		makePart("LeftSleeve", Vector3.new(0.2, 0.2, 0.2), Color3.fromRGB(50, 55, 45), Enum.Material.Fabric)
	leftSleeve.Parent = folder
end

------------------------------------------------------------
-- VIEWMODEL BUILDING (gun + arms)
------------------------------------------------------------

local function clearViewmodel()
	if viewmodelFolder then
		viewmodelFolder:Destroy()
		viewmodelFolder = nil
	end
end

local function buildRifleViewmodel(): Folder
	local folder = Instance.new("Folder")
	folder.Name = "Viewmodel_Rifle"

	local body = makePart("Body", Vector3.new(0.15, 0.15, 1.8), Color3.fromRGB(60, 60, 60), Enum.Material.Metal)
	body.Parent = folder

	local barrel = makePart("Barrel", Vector3.new(0.8, 0.08, 0.08), Color3.fromRGB(40, 40, 40), Enum.Material.Metal)
	barrel.Shape = Enum.PartType.Cylinder
	barrel.Parent = folder

	local stock = makePart("Stock", Vector3.new(0.12, 0.18, 0.6), Color3.fromRGB(100, 60, 30), Enum.Material.Wood)
	stock.Parent = folder

	local scope = makePart("Scope", Vector3.new(0.4, 0.06, 0.06), Color3.fromRGB(30, 30, 30), Enum.Material.Metal)
	scope.Shape = Enum.PartType.Cylinder
	scope.Parent = folder

	local muzzle = makePart("Muzzle", Vector3.new(0.05, 0.05, 0.05), Color3.fromRGB(0, 0, 0), Enum.Material.Metal)
	muzzle.Transparency = 1
	muzzle.Parent = folder

	buildArms(folder)
	return folder
end

local function buildShotgunViewmodel(): Folder
	local folder = Instance.new("Folder")
	folder.Name = "Viewmodel_Shotgun"

	local body = makePart("Body", Vector3.new(0.16, 0.16, 1.6), Color3.fromRGB(50, 50, 50), Enum.Material.Metal)
	body.Parent = folder

	local barrel = makePart("Barrel", Vector3.new(0.7, 0.1, 0.1), Color3.fromRGB(40, 40, 40), Enum.Material.Metal)
	barrel.Shape = Enum.PartType.Cylinder
	barrel.Parent = folder

	local stock = makePart("Stock", Vector3.new(0.14, 0.2, 0.5), Color3.fromRGB(90, 55, 25), Enum.Material.Wood)
	stock.Parent = folder

	local pump = makePart("Pump", Vector3.new(0.14, 0.12, 0.3), Color3.fromRGB(80, 50, 20), Enum.Material.Wood)
	pump.Parent = folder

	local muzzle = makePart("Muzzle", Vector3.new(0.05, 0.05, 0.05), Color3.fromRGB(0, 0, 0), Enum.Material.Metal)
	muzzle.Transparency = 1
	muzzle.Parent = folder

	buildArms(folder)
	return folder
end

local function buildPistolViewmodel(): Folder
	local folder = Instance.new("Folder")
	folder.Name = "Viewmodel_Pistol"

	local body = makePart("Body", Vector3.new(0.1, 0.2, 0.4), Color3.fromRGB(45, 45, 45), Enum.Material.Metal)
	body.Parent = folder

	local barrel = makePart("Barrel", Vector3.new(0.35, 0.06, 0.06), Color3.fromRGB(35, 35, 35), Enum.Material.Metal)
	barrel.Shape = Enum.PartType.Cylinder
	barrel.Parent = folder

	local grip =
		makePart("Grip", Vector3.new(0.08, 0.22, 0.12), Color3.fromRGB(40, 40, 40), Enum.Material.SmoothPlastic)
	grip.Parent = folder

	local muzzle = makePart("Muzzle", Vector3.new(0.05, 0.05, 0.05), Color3.fromRGB(0, 0, 0), Enum.Material.Metal)
	muzzle.Transparency = 1
	muzzle.Parent = folder

	buildArms(folder)
	return folder
end

local function buildViewmodel(weaponType: string): Folder
	if weaponType == "Rifle" then
		return buildRifleViewmodel()
	elseif weaponType == "Shotgun" then
		return buildShotgunViewmodel()
	else
		return buildPistolViewmodel()
	end
end

------------------------------------------------------------
-- VIEWMODEL POSITIONING (with all animations)
------------------------------------------------------------

local function positionViewmodel(folder: Folder, cameraCF: CFrame, weaponType: string)
	-- Base offsets
	local hipOffset: CFrame
	local adsOffset: CFrame
	local rightArmHip: CFrame -- right arm relative to gun body
	local leftArmHip: CFrame -- left arm relative to gun body

	if weaponType == "Rifle" then
		hipOffset = CFrame.new(0.5, -0.4, -1.2) * CFrame.Angles(0, math.rad(180), 0)
		adsOffset = CFrame.new(0, -0.25, -1.0) * CFrame.Angles(0, math.rad(180), 0)
		rightArmHip = CFrame.new(0.15, -0.15, -0.6) -- near trigger
		leftArmHip = CFrame.new(-0.15, -0.1, 0.5) -- supporting barrel
	elseif weaponType == "Shotgun" then
		hipOffset = CFrame.new(0.5, -0.45, -1.1) * CFrame.Angles(0, math.rad(180), 0)
		adsOffset = CFrame.new(0, -0.25, -0.9) * CFrame.Angles(0, math.rad(180), 0)
		rightArmHip = CFrame.new(0.15, -0.15, -0.5)
		leftArmHip = CFrame.new(-0.15, -0.12, 0.35)
	else -- Pistol
		hipOffset = CFrame.new(0.35, -0.35, -0.7) * CFrame.Angles(0, math.rad(180), 0)
		adsOffset = CFrame.new(0, -0.2, -0.6) * CFrame.Angles(0, math.rad(180), 0)
		rightArmHip = CFrame.new(0.12, -0.18, -0.15)
		leftArmHip = CFrame.new(-0.12, -0.1, 0.1) -- cupping hand
	end

	-- Lerp between hip and ADS
	local baseOffset = hipOffset:Lerp(adsOffset, adsAmount)

	-- Apply mouse sway (weapon lags behind mouse)
	local swayScale = (1.0 - adsAmount * 0.7) -- reduce sway when ADS
	local swayCF = CFrame.new(swayOffset.X * 0.015 * swayScale, swayOffset.Y * 0.01 * swayScale, 0)
		* CFrame.Angles(swayOffset.Y * 0.002 * swayScale, -swayOffset.X * 0.003 * swayScale, 0)

	-- Apply shooting kick (recoil animation on the gun)
	local kickBack = shootKick * 0.12
	local kickUp = shootKick * 0.04
	local kickRotate = shootKick * math.rad(8)
	local kickCF = CFrame.new(0, kickUp, kickBack) * CFrame.Angles(-kickRotate, 0, 0)

	-- Apply reload dip (gun dips down and rotates during reload)
	local dipDown = reloadDip * 0.35
	local dipRotate = reloadDip * math.rad(25)
	local dipCF = CFrame.new(0, -dipDown, 0.1 * reloadDip) * CFrame.Angles(dipRotate, 0, reloadDip * math.rad(10))

	-- Apply walking bob (weapon bobs with footsteps)
	local bobX = math.cos(walkBobCycle * math.pi) * 0.02 * (1.0 - adsAmount * 0.8)
	local bobY = math.sin(walkBobCycle * math.pi * 2) * 0.015 * (1.0 - adsAmount * 0.8)
	local bobCF = CFrame.new(bobX, bobY, 0) * CFrame.Angles(0, 0, -bobX * 2)

	-- Apply idle breathing
	local breathY = math.sin(breathCycle) * 0.005
	local breathRotate = math.sin(breathCycle * 0.7) * math.rad(0.3)
	local breathCF = CFrame.new(0, breathY, 0) * CFrame.Angles(breathRotate, 0, 0)

	-- Combine all transforms
	local finalOffset = baseOffset * swayCF * kickCF * dipCF * bobCF * breathCF
	local baseCFrame = cameraCF * finalOffset

	-- Position gun parts
	local body = folder:FindFirstChild("Body") :: BasePart?
	local barrel = folder:FindFirstChild("Barrel") :: BasePart?
	local stock = folder:FindFirstChild("Stock") :: BasePart?
	local muzzle = folder:FindFirstChild("Muzzle") :: BasePart?
	local scope = folder:FindFirstChild("Scope") :: BasePart?
	local pump = folder:FindFirstChild("Pump") :: BasePart?
	local grip = folder:FindFirstChild("Grip") :: BasePart?

	if body then
		body.CFrame = baseCFrame
	end

	if barrel then
		if weaponType == "Pistol" then
			barrel.CFrame = baseCFrame * CFrame.new(0, 0.05, 0.2) * CFrame.Angles(0, 0, math.rad(90))
		else
			barrel.CFrame = baseCFrame * CFrame.new(0, 0, 1.1) * CFrame.Angles(0, 0, math.rad(90))
		end
	end

	if stock then
		stock.CFrame = baseCFrame * CFrame.new(0, 0, -0.9)
	end

	if scope then
		scope.CFrame = baseCFrame * CFrame.new(0, 0.12, 0.2) * CFrame.Angles(0, 0, math.rad(90))
	end

	if pump then
		pump.CFrame = baseCFrame * CFrame.new(0, -0.1, 0.4)
	end

	if grip then
		grip.CFrame = baseCFrame * CFrame.new(0, -0.18, -0.1)
	end

	if muzzle then
		if weaponType == "Pistol" then
			muzzle.CFrame = baseCFrame * CFrame.new(0, 0.05, 0.55)
		else
			muzzle.CFrame = baseCFrame * CFrame.new(0, 0, 1.6)
		end
	end

	-- Position arms
	local rightForearm = folder:FindFirstChild("RightForearm") :: BasePart?
	local rightHand = folder:FindFirstChild("RightHand") :: BasePart?
	local leftForearm = folder:FindFirstChild("LeftForearm") :: BasePart?
	local leftHand = folder:FindFirstChild("LeftHand") :: BasePart?
	local rightSleeve = folder:FindFirstChild("RightSleeve") :: BasePart?
	local leftSleeve = folder:FindFirstChild("LeftSleeve") :: BasePart?

	-- Right arm: near trigger/grip area
	local rightGripCF = baseCFrame * rightArmHip
	if rightHand then
		rightHand.CFrame = rightGripCF
	end
	if rightForearm then
		-- Forearm extends back and down from the hand
		rightForearm.CFrame = rightGripCF
			* CFrame.new(0.08, -0.05, -0.32)
			* CFrame.Angles(math.rad(-15), math.rad(5), 0)
	end
	if rightSleeve then
		rightSleeve.CFrame = rightGripCF * CFrame.new(0.08, -0.05, -0.58) * CFrame.Angles(math.rad(-15), math.rad(5), 0)
	end

	-- Left arm: supporting front of weapon
	local leftGripCF = baseCFrame * leftArmHip
	if leftHand then
		leftHand.CFrame = leftGripCF
	end
	if leftForearm then
		leftForearm.CFrame = leftGripCF
			* CFrame.new(-0.08, -0.05, -0.32)
			* CFrame.Angles(math.rad(-10), math.rad(-5), 0)
	end
	if leftSleeve then
		leftSleeve.CFrame = leftGripCF * CFrame.new(-0.08, -0.05, -0.58) * CFrame.Angles(math.rad(-10), math.rad(-5), 0)
	end
end

------------------------------------------------------------
-- VISUAL EFFECTS
------------------------------------------------------------

local function createMuzzleFlash(muzzlePos: Vector3)
	local flash = Instance.new("Part")
	flash.Name = "MuzzleFlash"
	flash.Shape = Enum.PartType.Ball
	flash.Size = Vector3.new(0.5, 0.5, 0.5)
	flash.Color = Color3.fromRGB(255, 200, 50)
	flash.Material = Enum.Material.Neon
	flash.Transparency = 0.2
	flash.Anchored = true
	flash.CanCollide = false
	flash.CastShadow = false
	flash.Position = muzzlePos
	flash.Parent = workspace

	local light = Instance.new("PointLight")
	light.Color = Color3.fromRGB(255, 180, 50)
	light.Brightness = 4
	light.Range = 20
	light.Parent = flash

	Debris:AddItem(flash, 0.05)
end

local function createImpactEffect(position: Vector3, normal: Vector3)
	-- Impact spark
	local impact = Instance.new("Part")
	impact.Name = "Impact"
	impact.Shape = Enum.PartType.Ball
	impact.Size = Vector3.new(0.2, 0.2, 0.2)
	impact.Color = Color3.fromRGB(255, 220, 150)
	impact.Material = Enum.Material.Neon
	impact.Transparency = 0.3
	impact.Anchored = true
	impact.CanCollide = false
	impact.CastShadow = false
	impact.Position = position + normal * 0.05
	impact.Parent = workspace
	Debris:AddItem(impact, 0.15)

	-- Debris particles (small chunks flying out)
	for i = 1, 3 do
		local chip = Instance.new("Part")
		chip.Name = "Debris" .. tostring(i)
		chip.Size = Vector3.new(0.06, 0.06, 0.06)
		chip.Color = Color3.fromRGB(140, 130, 110)
		chip.Material = Enum.Material.Slate
		chip.Anchored = false
		chip.CanCollide = true
		chip.CastShadow = false
		chip.Position = position + normal * 0.1
		chip.Parent = workspace

		-- Fling outward
		local scatter = Vector3.new((math.random() - 0.5) * 8, math.random() * 10, (math.random() - 0.5) * 8)
		chip:ApplyImpulse(scatter * chip:GetMass())

		Debris:AddItem(chip, 1.5)
	end

	-- Bullet hole
	local hole = Instance.new("Part")
	hole.Name = "BulletHole"
	hole.Size = Vector3.new(0.18, 0.18, 0.01)
	hole.Color = Color3.fromRGB(20, 20, 20)
	hole.Material = Enum.Material.SmoothPlastic
	hole.Transparency = 0.2
	hole.Anchored = true
	hole.CanCollide = false
	hole.CastShadow = false
	hole.CFrame = CFrame.lookAt(position + normal * 0.02, position + normal * 0.02 + normal)
	hole.Parent = workspace
	Debris:AddItem(hole, 15)
end

------------------------------------------------------------
-- SHOOTING LOGIC
------------------------------------------------------------

local function canFire(): boolean
	if currentWeaponDef == nil then
		return false
	end
	if isReloading then
		return false
	end
	if currentAmmo <= 0 then
		return false
	end

	local now = tick()
	local fireInterval = 1.0 / currentWeaponDef.fireRate
	if now - lastFireTime < fireInterval then
		return false
	end

	return true
end

local function fireWeapon()
	if not canFire() then
		return
	end

	local weaponDef = currentWeaponDef
	if not weaponDef then
		return
	end

	lastFireTime = tick()
	currentAmmo -= 1

	-- ANIMATION: trigger shoot kick (will be smoothed in update loop)
	shootKick = 1.0

	-- Calculate spread
	local spreadRad = math.rad(weaponDef.spread)
	if CameraController and CameraController.isAds() then
		spreadRad *= 0.3
	end

	local camCF = camera.CFrame
	local origin = camCF.Position
	local baseDirection = camCF.LookVector

	local spreadX = (math.random() - 0.5) * 2 * spreadRad
	local spreadY = (math.random() - 0.5) * 2 * spreadRad
	local spreadCF = CFrame.Angles(spreadY, spreadX, 0)
	local finalDirection = (CFrame.new(Vector3.zero, baseDirection) * spreadCF).LookVector * weaponDef.range

	-- Client-side raycast for visuals
	local character = player.Character
	local ignoreList: { Instance } = {}
	if character then
		table.insert(ignoreList, character)
	end
	if viewmodelFolder then
		table.insert(ignoreList, viewmodelFolder)
	end

	local result = RaycastUtil.cast(origin, finalDirection, ignoreList)

	-- Visual effects
	if viewmodelFolder then
		local muzzle = viewmodelFolder:FindFirstChild("Muzzle") :: BasePart?
		if muzzle then
			createMuzzleFlash(muzzle.Position)
		end
	end

	if result.hit then
		createImpactEffect(result.position, result.normal)
	end

	-- Apply recoil to camera
	if CameraController then
		local recoilV = weaponDef.recoilVertical * (if CameraController.isAds() then 0.5 else 1.0)
		local recoilH = (math.random() - 0.5) * 2 * weaponDef.recoilHorizontal
		CameraController.applyRecoil(recoilV, recoilH)
	end

	-- Send to server
	local fireWeaponRemote = Remotes.waitForEvent("FireWeapon")
	fireWeaponRemote:FireServer({
		origin = origin,
		direction = finalDirection,
	})

	-- Auto-reload if empty
	if currentAmmo <= 0 and weaponDef then
		task.delay(0.3, function()
			startReload()
		end)
	end
end

startReload = function()
	if isReloading then
		return
	end
	if currentWeaponDef == nil then
		return
	end
	if currentAmmo >= currentWeaponDef.magazineSize then
		return
	end

	isReloading = true

	-- ANIMATION: trigger reload dip
	reloadDip = 0 -- will animate up in the update loop

	local reloadRemote = Remotes.waitForEvent("ReloadWeapon")
	reloadRemote:FireServer()

	task.delay(currentWeaponDef.reloadTime, function()
		if currentWeaponDef then
			currentAmmo = currentWeaponDef.magazineSize
		end
		isReloading = false
	end)
end

------------------------------------------------------------
-- PUBLIC API
------------------------------------------------------------

function WeaponController.Init()
	local clientScript = player:WaitForChild("PlayerScripts"):WaitForChild("Client")
	InputController = require(clientScript.controllers.InputController)
	CameraController = require(clientScript.controllers.CameraController)

	-- Start with hunting rifle equipped for testing
	WeaponController.equipWeapon("rifle_hunting")

	-- Listen for weapon state updates from server
	local weaponStateRemote = Remotes.waitForEvent("WeaponStateUpdated")
	weaponStateRemote.OnClientEvent:Connect(function(data: any)
		if data and typeof(data) == "table" then
			if data.currentAmmo ~= nil then
				currentAmmo = data.currentAmmo
			end
		end
	end)

	-- Listen for hit markers from server
	local hitMarkerRemote = Remotes.waitForEvent("HitMarker")
	hitMarkerRemote.OnClientEvent:Connect(function(data: any)
		if data and data.hitType then
			print("[Weapon] HIT! Type:", data.hitType)
		end
	end)

	print("[WeaponController] Initialized")
end

function WeaponController.Start()
	local lastMouseDelta = Vector2.zero

	RunService.RenderStepped:Connect(function(dt: number)
		-- Handle shooting
		if InputController.isFireHeld() then
			fireWeapon()
		end

		-- Handle reload
		if InputController.consumeReload() then
			startReload()
		end

		-- Update ADS amount (smooth)
		local targetAds = if InputController.isAdsHeld() then 1.0 else 0.0
		adsAmount = adsAmount + (targetAds - adsAmount) * math.min(1, dt * 10)

		-- Update mouse sway (weapon follows mouse with delay)
		local mouseDelta = InputController.getMouseDelta()
		-- Smooth the mouse delta
		lastMouseDelta = lastMouseDelta:Lerp(mouseDelta, math.min(1, dt * 15))
		-- Accumulate sway with decay
		swayOffset = Vector2.new(swayOffset.X + lastMouseDelta.X * 0.15, swayOffset.Y + lastMouseDelta.Y * 0.15)
		-- Decay sway back to center
		swayOffset = swayOffset:Lerp(Vector2.zero, math.min(1, dt * 6))
		-- Clamp so it doesn't go crazy
		local maxSway = 4
		swayOffset =
			Vector2.new(math.clamp(swayOffset.X, -maxSway, maxSway), math.clamp(swayOffset.Y, -maxSway, maxSway))

		-- Update shoot kick (decays quickly after firing)
		shootKick = shootKick * math.max(0, 1.0 - dt * 12)
		if shootKick < 0.01 then
			shootKick = 0
		end

		-- Update reload dip animation
		if isReloading then
			-- Animate up to 1.0 while reloading
			reloadDip = reloadDip + (1.0 - reloadDip) * math.min(1, dt * 5)
		else
			-- Animate back to 0 when done
			reloadDip = reloadDip * math.max(0, 1.0 - dt * 6)
			if reloadDip < 0.01 then
				reloadDip = 0
			end
		end

		-- Update walking bob
		local isMoving = InputController.getMoveDirection().Magnitude > 0.1
		if isMoving then
			local bobSpeed = if InputController.isSprinting() then 10 else 7
			walkBobCycle = walkBobCycle + dt * bobSpeed
		else
			-- Smoothly stop bobbing
			walkBobCycle = walkBobCycle * math.max(0, 1.0 - dt * 4)
		end

		-- Update idle breathing (always running)
		breathCycle = breathCycle + dt * 1.8

		-- Position the viewmodel with all animations applied
		if viewmodelFolder and currentWeaponDef then
			positionViewmodel(viewmodelFolder, camera.CFrame, currentWeaponDef.weaponType)
		end
	end)

	print("[WeaponController] Started — weapon system active with animations")
end

function WeaponController.equipWeapon(weaponId: string)
	local weaponDef = WeaponDatabase.get(weaponId)
	if not weaponDef then
		warn("[WeaponController] Unknown weapon:", weaponId)
		return
	end

	clearViewmodel()

	currentWeaponId = weaponId
	currentWeaponDef = weaponDef
	currentAmmo = weaponDef.magazineSize
	isReloading = false
	lastFireTime = 0

	-- Reset animation state
	swayOffset = Vector2.zero
	shootKick = 0
	reloadDip = 0
	walkBobCycle = 0

	viewmodelFolder = buildViewmodel(weaponDef.weaponType)
	viewmodelFolder.Parent = camera

	print("[WeaponController] Equipped:", weaponDef.itemId)
end

function WeaponController.unequipWeapon()
	clearViewmodel()
	currentWeaponId = nil
	currentWeaponDef = nil
	currentAmmo = 0
	isReloading = false
end

function WeaponController.getCurrentAmmo(): number
	return currentAmmo
end

function WeaponController.isReloading(): boolean
	return isReloading
end

function WeaponController.getCurrentWeaponId(): string?
	return currentWeaponId
end

return WeaponController
