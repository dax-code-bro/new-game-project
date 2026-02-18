--!strict
--[[
	WeaponDatabase.luau — Stat definitions for all weapons.
	Weapons are referenced by itemId which must match ItemDatabase entries.
]]

local Types = require(script.Parent.Types)

export type WeaponDefMap = { [string]: Types.WeaponDef }

local Weapons: WeaponDefMap = {
	rifle_hunting = {
		itemId = "rifle_hunting",
		weaponType = "Rifle",
		ammoType = "RifleBullet",
		damage = 45,
		fireRate = 1.2, -- rounds per second (bolt action feel)
		reloadTime = 2.5,
		magazineSize = 5,
		spread = 0.3, -- degrees
		recoilVertical = 3.5,
		recoilHorizontal = 0.5,
		range = 500,
		conditionLossPerShot = 0.005,
		headshotMultiplier = 2.5,
		adsZoom = 0.5, -- FOV multiplier (lower = more zoom)
		adsSpeed = 0.3,
	},

	shotgun_pump = {
		itemId = "shotgun_pump",
		weaponType = "Shotgun",
		ammoType = "ShotgunShell",
		damage = 15, -- per pellet, 8 pellets = 120 max
		fireRate = 0.8,
		reloadTime = 3.0,
		magazineSize = 6,
		spread = 4.0,
		recoilVertical = 5.0,
		recoilHorizontal = 1.5,
		range = 80,
		conditionLossPerShot = 0.008,
		headshotMultiplier = 1.5,
		adsZoom = 0.75,
		adsSpeed = 0.25,
	},

	pistol_9mm = {
		itemId = "pistol_9mm",
		weaponType = "Pistol",
		ammoType = "PistolBullet",
		damage = 20,
		fireRate = 4.0,
		reloadTime = 1.5,
		magazineSize = 12,
		spread = 1.5,
		recoilVertical = 2.0,
		recoilHorizontal = 1.0,
		range = 150,
		conditionLossPerShot = 0.003,
		headshotMultiplier = 2.0,
		adsZoom = 0.8,
		adsSpeed = 0.15,
	},
}

local WeaponDatabase = {}

function WeaponDatabase.get(itemId: string): Types.WeaponDef?
	return Weapons[itemId]
end

function WeaponDatabase.getAll(): WeaponDefMap
	return Weapons
end

return WeaponDatabase
