--!strict
--[[
	WeaponController.luau — Client-side weapon handling.
	Manages the viewmodel (Parts-based gun attached to camera), shooting visuals,
	recoil, muzzle flash, impact effects, reload, and ammo display.

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
local currentWeaponDef: any = nil -- WeaponDef when equipped

local currentAmmo: number = 0
local isReloading: boolean = false
local lastFireTime: number = 0

-- Viewmodel
local viewmodelFolder: Folder? = nil

-- Forward declare
local startReload: () -> ()

------------------------------------------------------------
-- VIEWMODEL BUILDING (Parts-based gun shapes)
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

	-- Gun body (dark gray rectangular block)
	local body = Instance.new("Part")
	body.Name = "Body"
	body.Size = Vector3.new(0.15, 0.15, 1.8)
	body.Color = Color3.fromRGB(60, 60, 60)
	body.Material = Enum.Material.Metal
	body.Anchored = true
	body.CanCollide = false
	body.CastShadow = false
	body.Parent = folder

	-- Barrel (cylinder extending forward)
	local barrel = Instance.new("Part")
	barrel.Name = "Barrel"
	barrel.Shape = Enum.PartType.Cylinder
	barrel.Size = Vector3.new(0.8, 0.08, 0.08)
	barrel.Color = Color3.fromRGB(40, 40, 40)
	barrel.Material = Enum.Material.Metal
	barrel.Anchored = true
	barrel.CanCollide = false
	barrel.CastShadow = false
	barrel.Parent = folder

	-- Stock (brown wooden part)
	local stock = Instance.new("Part")
	stock.Name = "Stock"
	stock.Size = Vector3.new(0.12, 0.18, 0.6)
	stock.Color = Color3.fromRGB(100, 60, 30)
	stock.Material = Enum.Material.Wood
	stock.Anchored = true
	stock.CanCollide = false
	stock.CastShadow = false
	stock.Parent = folder

	-- Scope (small cylinder on top — for rifle)
	local scope = Instance.new("Part")
	scope.Name = "Scope"
	scope.Shape = Enum.PartType.Cylinder
	scope.Size = Vector3.new(0.4, 0.06, 0.06)
	scope.Color = Color3.fromRGB(30, 30, 30)
	scope.Material = Enum.Material.Metal
	scope.Anchored = true
	scope.CanCollide = false
	scope.CastShadow = false
	scope.Parent = folder

	-- Muzzle point (invisible, used for flash/raycast origin)
	local muzzle = Instance.new("Part")
	muzzle.Name = "Muzzle"
	muzzle.Size = Vector3.new(0.05, 0.05, 0.05)
	muzzle.Transparency = 1
	muzzle.Anchored = true
	muzzle.CanCollide = false
	muzzle.CastShadow = false
	muzzle.Parent = folder

	return folder
end

local function buildShotgunViewmodel(): Folder
	local folder = Instance.new("Folder")
	folder.Name = "Viewmodel_Shotgun"

	local body = Instance.new("Part")
	body.Name = "Body"
	body.Size = Vector3.new(0.16, 0.16, 1.6)
	body.Color = Color3.fromRGB(50, 50, 50)
	body.Material = Enum.Material.Metal
	body.Anchored = true
	body.CanCollide = false
	body.CastShadow = false
	body.Parent = folder

	local barrel = Instance.new("Part")
	barrel.Name = "Barrel"
	barrel.Shape = Enum.PartType.Cylinder
	barrel.Size = Vector3.new(0.7, 0.1, 0.1)
	barrel.Color = Color3.fromRGB(40, 40, 40)
	barrel.Material = Enum.Material.Metal
	barrel.Anchored = true
	barrel.CanCollide = false
	barrel.CastShadow = false
	barrel.Parent = folder

	local stock = Instance.new("Part")
	stock.Name = "Stock"
	stock.Size = Vector3.new(0.14, 0.2, 0.5)
	stock.Color = Color3.fromRGB(90, 55, 25)
	stock.Material = Enum.Material.Wood
	stock.Anchored = true
	stock.CanCollide = false
	stock.CastShadow = false
	stock.Parent = folder

	local pump = Instance.new("Part")
	pump.Name = "Pump"
	pump.Size = Vector3.new(0.14, 0.12, 0.3)
	pump.Color = Color3.fromRGB(80, 50, 20)
	pump.Material = Enum.Material.Wood
	pump.Anchored = true
	pump.CanCollide = false
	pump.CastShadow = false
	pump.Parent = folder

	local muzzle = Instance.new("Part")
	muzzle.Name = "Muzzle"
	muzzle.Size = Vector3.new(0.05, 0.05, 0.05)
	muzzle.Transparency = 1
	muzzle.Anchored = true
	muzzle.CanCollide = false
	muzzle.CastShadow = false
	muzzle.Parent = folder

	return folder
end

local function buildPistolViewmodel(): Folder
	local folder = Instance.new("Folder")
	folder.Name = "Viewmodel_Pistol"

	local body = Instance.new("Part")
	body.Name = "Body"
	body.Size = Vector3.new(0.1, 0.2, 0.4)
	body.Color = Color3.fromRGB(45, 45, 45)
	body.Material = Enum.Material.Metal
	body.Anchored = true
	body.CanCollide = false
	body.CastShadow = false
	body.Parent = folder

	local barrel = Instance.new("Part")
	barrel.Name = "Barrel"
	barrel.Shape = Enum.PartType.Cylinder
	barrel.Size = Vector3.new(0.35, 0.06, 0.06)
	barrel.Color = Color3.fromRGB(35, 35, 35)
	barrel.Material = Enum.Material.Metal
	barrel.Anchored = true
	barrel.CanCollide = false
	barrel.CastShadow = false
	barrel.Parent = folder

	local grip = Instance.new("Part")
	grip.Name = "Grip"
	grip.Size = Vector3.new(0.08, 0.22, 0.12)
	grip.Color = Color3.fromRGB(40, 40, 40)
	grip.Material = Enum.Material.SmoothPlastic
	grip.Anchored = true
	grip.CanCollide = false
	grip.CastShadow = false
	grip.Parent = folder

	local muzzle = Instance.new("Part")
	muzzle.Name = "Muzzle"
	muzzle.Size = Vector3.new(0.05, 0.05, 0.05)
	muzzle.Transparency = 1
	muzzle.Anchored = true
	muzzle.CanCollide = false
	muzzle.CastShadow = false
	muzzle.Parent = folder

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
-- VIEWMODEL POSITIONING
------------------------------------------------------------

local function positionViewmodel(folder: Folder, cameraCF: CFrame, weaponType: string, adsAmount: number)
	-- Base offset from camera (right hand position)
	local hipOffset: CFrame
	local adsOffset: CFrame

	if weaponType == "Rifle" then
		hipOffset = CFrame.new(0.5, -0.4, -1.2) * CFrame.Angles(0, math.rad(180), 0)
		adsOffset = CFrame.new(0, -0.25, -1.0) * CFrame.Angles(0, math.rad(180), 0)
	elseif weaponType == "Shotgun" then
		hipOffset = CFrame.new(0.5, -0.45, -1.1) * CFrame.Angles(0, math.rad(180), 0)
		adsOffset = CFrame.new(0, -0.25, -0.9) * CFrame.Angles(0, math.rad(180), 0)
	else -- Pistol
		hipOffset = CFrame.new(0.35, -0.35, -0.7) * CFrame.Angles(0, math.rad(180), 0)
		adsOffset = CFrame.new(0, -0.2, -0.6) * CFrame.Angles(0, math.rad(180), 0)
	end

	-- Lerp between hip and ADS
	local offset = hipOffset:Lerp(adsOffset, adsAmount)
	local baseCFrame = cameraCF * offset

	-- Position each part relative to the body
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

	if barrel and body then
		if weaponType == "Pistol" then
			barrel.CFrame = baseCFrame * CFrame.new(0, 0.05, 0.2) * CFrame.Angles(0, 0, math.rad(90))
		else
			barrel.CFrame = baseCFrame * CFrame.new(0, 0, 1.1) * CFrame.Angles(0, 0, math.rad(90))
		end
	end

	if stock and body then
		stock.CFrame = baseCFrame * CFrame.new(0, 0, -0.9)
	end

	if scope and body then
		scope.CFrame = baseCFrame * CFrame.new(0, 0.12, 0.2) * CFrame.Angles(0, 0, math.rad(90))
	end

	if pump and body then
		pump.CFrame = baseCFrame * CFrame.new(0, -0.1, 0.4)
	end

	if grip and body then
		grip.CFrame = baseCFrame * CFrame.new(0, -0.18, -0.1)
	end

	if muzzle then
		if weaponType == "Pistol" then
			muzzle.CFrame = baseCFrame * CFrame.new(0, 0.05, 0.55)
		else
			muzzle.CFrame = baseCFrame * CFrame.new(0, 0, 1.6)
		end
	end
end

------------------------------------------------------------
-- VISUAL EFFECTS
------------------------------------------------------------

local function createMuzzleFlash(muzzlePos: Vector3)
	local flash = Instance.new("Part")
	flash.Name = "MuzzleFlash"
	flash.Shape = Enum.PartType.Ball
	flash.Size = Vector3.new(0.4, 0.4, 0.4)
	flash.Color = Color3.fromRGB(255, 200, 50)
	flash.Material = Enum.Material.Neon
	flash.Transparency = 0.3
	flash.Anchored = true
	flash.CanCollide = false
	flash.CastShadow = false
	flash.Position = muzzlePos
	flash.Parent = workspace

	-- Quick point light
	local light = Instance.new("PointLight")
	light.Color = Color3.fromRGB(255, 180, 50)
	light.Brightness = 3
	light.Range = 15
	light.Parent = flash

	Debris:AddItem(flash, 0.06)
end

local function createImpactEffect(position: Vector3, normal: Vector3)
	-- Dust/spark particles at impact point
	local impact = Instance.new("Part")
	impact.Name = "Impact"
	impact.Shape = Enum.PartType.Ball
	impact.Size = Vector3.new(0.15, 0.15, 0.15)
	impact.Color = Color3.fromRGB(180, 160, 130)
	impact.Material = Enum.Material.Neon
	impact.Transparency = 0.5
	impact.Anchored = true
	impact.CanCollide = false
	impact.CastShadow = false
	impact.Position = position + normal * 0.05
	impact.Parent = workspace

	Debris:AddItem(impact, 0.3)

	-- Bullet hole (stays longer)
	local hole = Instance.new("Part")
	hole.Name = "BulletHole"
	hole.Size = Vector3.new(0.15, 0.15, 0.01)
	hole.Color = Color3.fromRGB(30, 30, 30)
	hole.Material = Enum.Material.SmoothPlastic
	hole.Transparency = 0.3
	hole.Anchored = true
	hole.CanCollide = false
	hole.CastShadow = false
	hole.CFrame = CFrame.lookAt(position + normal * 0.02, position + normal * 0.02 + normal)
	hole.Parent = workspace

	Debris:AddItem(hole, 10)
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

	-- Calculate spread
	local spreadRad = math.rad(weaponDef.spread)
	if CameraController and CameraController.isAds() then
		spreadRad *= 0.3 -- much tighter spread when ADS
	end

	local camCF = camera.CFrame
	local origin = camCF.Position
	local baseDirection = camCF.LookVector

	-- Apply spread
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

	-- Send to server for authoritative hit detection
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
	print("[Weapon] Reloading...")

	local reloadRemote = Remotes.waitForEvent("ReloadWeapon")
	reloadRemote:FireServer()

	-- Wait for reload time then restore ammo (server will validate)
	task.delay(currentWeaponDef.reloadTime, function()
		if currentWeaponDef then
			currentAmmo = currentWeaponDef.magazineSize
		end
		isReloading = false
		print("[Weapon] Reload complete!")
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
			-- TODO: Show hitmarker UI
		end
	end)

	print("[WeaponController] Initialized")
end

function WeaponController.Start()
	-- ADS amount for smooth transitions
	local adsAmount: number = 0

	RunService.RenderStepped:Connect(function(dt: number)
		-- Handle shooting
		if InputController.isFireHeld() then
			fireWeapon()
		end

		-- Handle reload
		if InputController.consumeReload() then
			startReload()
		end

		-- Update ADS amount
		local targetAds = if InputController.isAdsHeld() then 1.0 else 0.0
		adsAmount = adsAmount + (targetAds - adsAmount) * math.min(1, dt * 10)

		-- Position viewmodel
		if viewmodelFolder and currentWeaponDef then
			positionViewmodel(viewmodelFolder, camera.CFrame, currentWeaponDef.weaponType, adsAmount)
		end
	end)

	print("[WeaponController] Started — weapon system active")
end

function WeaponController.equipWeapon(weaponId: string)
	local weaponDef = WeaponDatabase.get(weaponId)
	if not weaponDef then
		warn("[WeaponController] Unknown weapon:", weaponId)
		return
	end

	-- Clean up old viewmodel
	clearViewmodel()

	-- Set state
	currentWeaponId = weaponId
	currentWeaponDef = weaponDef
	currentAmmo = weaponDef.magazineSize
	isReloading = false
	lastFireTime = 0

	-- Build new viewmodel
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
