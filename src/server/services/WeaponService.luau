--!strict
--[[
	WeaponService.luau — Server-authoritative weapon handling.
	Validates shots, applies damage, tracks ammo and fire rates.
	The server NEVER trusts the client — it always re-raycasts and validates.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared.Constants)
local WeaponDatabase = require(Shared.WeaponDatabase)
local Remotes = require(Shared.Remotes)
local RaycastUtil = require(Shared.utils.Raycast)

local WeaponService = {}

-- Per-player weapon state (in production this ties into InventoryService)
type PlayerWeaponState = {
	weaponId: string,
	currentAmmo: number,
	lastFireTime: number,
	condition: number,
}

local playerWeapons: { [Player]: PlayerWeaponState } = {}

------------------------------------------------------------
-- INTERNAL
------------------------------------------------------------

local function getCharacterHead(plr: Player): BasePart?
	local character = plr.Character
	if not character then
		return nil
	end
	return character:FindFirstChild("Head") :: BasePart?
end

local function validateFireRequest(plr: Player, data: any): boolean
	-- Must have weapon state
	local weaponState = playerWeapons[plr]
	if not weaponState then
		return false
	end

	-- Must have ammo
	if weaponState.currentAmmo <= 0 then
		return false
	end

	-- Fire rate check (with tolerance)
	local weaponDef = WeaponDatabase.get(weaponState.weaponId)
	if not weaponDef then
		return false
	end

	local now = tick()
	local fireInterval = 1.0 / weaponDef.fireRate
	local tolerantInterval = fireInterval / Constants.MAX_FIRE_RATE_TOLERANCE
	if now - weaponState.lastFireTime < tolerantInterval then
		return false
	end

	-- Validate payload structure
	if typeof(data) ~= "table" then
		return false
	end
	if typeof(data.origin) ~= "Vector3" or typeof(data.direction) ~= "Vector3" then
		return false
	end

	-- Validate origin is near the player's actual position (anti-teleport)
	local head = getCharacterHead(plr)
	if not head then
		return false
	end

	local distance = (data.origin - head.Position).Magnitude
	if distance > Constants.HIT_VALIDATION_TOLERANCE then
		warn("[WeaponService] Rejected shot from", plr.Name, "— origin too far from head:", distance)
		return false
	end

	return true
end

local function handleFire(plr: Player, data: any)
	if not validateFireRequest(plr, data) then
		return
	end

	local weaponState = playerWeapons[plr]
	if not weaponState then
		return
	end

	local weaponDef = WeaponDatabase.get(weaponState.weaponId)
	if not weaponDef then
		return
	end

	-- Update state
	weaponState.currentAmmo -= 1
	weaponState.lastFireTime = tick()

	-- Degrade condition
	weaponState.condition = math.max(0, weaponState.condition - weaponDef.conditionLossPerShot)

	-- Server raycast (authoritative)
	local character = plr.Character
	local ignoreList: { Instance } = {}
	if character then
		table.insert(ignoreList, character)
	end

	local _result, humanoid, hitZone = RaycastUtil.weaponCast(data.origin, data.direction, ignoreList)

	if humanoid and humanoid.Health > 0 then
		-- Calculate damage
		local damage = weaponDef.damage
		if hitZone == "head" then
			damage *= weaponDef.headshotMultiplier
		end

		-- Apply condition penalty (bad condition = less damage)
		if weaponState.condition < 0.5 then
			damage *= (0.5 + weaponState.condition) -- at 0 condition, 50% damage
		end

		-- Apply damage
		humanoid:TakeDamage(damage)

		-- Send hit marker to shooter
		local hitType = "body"
		if humanoid.Health <= 0 then
			hitType = "kill"
		elseif hitZone == "head" then
			hitType = "head"
		end

		Remotes.getEvent("HitMarker"):FireClient(plr, {
			hitType = hitType,
		})

		-- Send damage indicator to victim (if it's a player)
		local victimCharacter = humanoid.Parent
		if victimCharacter then
			local victimPlayer = Players:GetPlayerFromCharacter(victimCharacter :: Model)
			if victimPlayer then
				local direction = (data.origin - victimCharacter:GetPivot().Position).Unit
				Remotes.getEvent("DamageIndicator"):FireClient(victimPlayer, {
					direction = direction,
					amount = damage,
				})
			end
		end

		print(
			"[WeaponService]",
			plr.Name,
			"hit",
			if humanoid.Parent then humanoid.Parent.Name else "?",
			"for",
			math.floor(damage),
			"damage (" .. (hitZone or "?") .. ")"
		)
	end

	-- Send updated weapon state to client
	Remotes.getEvent("WeaponStateUpdated"):FireClient(plr, {
		currentAmmo = weaponState.currentAmmo,
		condition = weaponState.condition,
		isJammed = false,
	})
end

local function handleReload(plr: Player)
	local weaponState = playerWeapons[plr]
	if not weaponState then
		return
	end

	local weaponDef = WeaponDatabase.get(weaponState.weaponId)
	if not weaponDef then
		return
	end

	-- Server-side reload delay
	task.delay(weaponDef.reloadTime, function()
		-- Verify player still exists and has same weapon
		if not plr.Parent then
			return
		end
		local currentState = playerWeapons[plr]
		if not currentState or currentState.weaponId ~= weaponState.weaponId then
			return
		end

		currentState.currentAmmo = weaponDef.magazineSize

		Remotes.getEvent("WeaponStateUpdated"):FireClient(plr, {
			currentAmmo = currentState.currentAmmo,
			condition = currentState.condition,
			isJammed = false,
		})

		print("[WeaponService]", plr.Name, "reloaded", weaponDef.itemId)
	end)
end

------------------------------------------------------------
-- LIFECYCLE
------------------------------------------------------------

function WeaponService.Init()
	-- Give every player a hunting rifle by default (for testing)
	Players.PlayerAdded:Connect(function(plr: Player)
		playerWeapons[plr] = {
			weaponId = "rifle_hunting",
			currentAmmo = 5,
			lastFireTime = 0,
			condition = 1.0,
		}
		print("[WeaponService] Equipped", plr.Name, "with hunting rifle")
	end)

	-- Cleanup on leave
	Players.PlayerRemoving:Connect(function(plr: Player)
		playerWeapons[plr] = nil
	end)

	-- Handle existing players (in case script loads late)
	for _, plr in Players:GetPlayers() do
		if not playerWeapons[plr] then
			playerWeapons[plr] = {
				weaponId = "rifle_hunting",
				currentAmmo = 5,
				lastFireTime = 0,
				condition = 1.0,
			}
		end
	end

	print("[WeaponService] Initialized")
end

function WeaponService.Start()
	-- Listen for fire events
	Remotes.getEvent("FireWeapon").OnServerEvent:Connect(handleFire)

	-- Listen for reload events
	Remotes.getEvent("ReloadWeapon").OnServerEvent:Connect(handleReload)

	print("[WeaponService] Started — listening for weapon events")
end

return WeaponService
