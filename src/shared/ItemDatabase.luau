--!strict
--[[
	ItemDatabase.luau — Definitions for every item in the game.
	Items are identified by their unique `id` string.
]]

local Types = require(script.Parent.Types)

export type ItemDefMap = { [string]: Types.ItemDef }

local Items: ItemDefMap = {
	------------------------------------------------------------
	-- WEAPONS
	------------------------------------------------------------
	rifle_hunting = {
		id = "rifle_hunting",
		name = "Hunting Rifle",
		description = "A reliable bolt-action rifle. Great for long-range hunting.",
		category = "Weapon",
		maxStack = 1,
		weight = 3.5,
		icon = "rifle",
	},
	shotgun_pump = {
		id = "shotgun_pump",
		name = "Pump Shotgun",
		description = "Devastating at close range. Fires 8 pellets per shell.",
		category = "Weapon",
		maxStack = 1,
		weight = 3.8,
		icon = "shotgun",
	},
	pistol_9mm = {
		id = "pistol_9mm",
		name = "9mm Pistol",
		description = "Compact sidearm. Fast fire rate, moderate damage.",
		category = "Weapon",
		maxStack = 1,
		weight = 1.2,
		icon = "pistol",
	},

	------------------------------------------------------------
	-- AMMO
	------------------------------------------------------------
	ammo_rifle = {
		id = "ammo_rifle",
		name = "Rifle Bullets",
		description = "Standard rifle ammunition.",
		category = "Ammo",
		maxStack = 60,
		weight = 0.02,
		icon = "ammo_rifle",
	},
	ammo_shotgun = {
		id = "ammo_shotgun",
		name = "Shotgun Shells",
		description = "12-gauge shotgun shells.",
		category = "Ammo",
		maxStack = 30,
		weight = 0.04,
		icon = "ammo_shotgun",
	},
	ammo_pistol = {
		id = "ammo_pistol",
		name = "9mm Rounds",
		description = "Standard pistol ammunition.",
		category = "Ammo",
		maxStack = 60,
		weight = 0.01,
		icon = "ammo_pistol",
	},

	------------------------------------------------------------
	-- FOOD (RAW MEATS)
	------------------------------------------------------------
	meat_deer_raw = {
		id = "meat_deer_raw",
		name = "Raw Venison",
		description = "Raw deer meat. Cook it before eating.",
		category = "Food",
		maxStack = 5,
		weight = 1.5,
		icon = "meat_raw",
	},
	meat_deer_cooked = {
		id = "meat_deer_cooked",
		name = "Cooked Venison",
		description = "Grilled venison. Restores health and fills you up.",
		category = "Food",
		maxStack = 5,
		weight = 1.2,
		icon = "meat_cooked",
	},
	meat_moose_raw = {
		id = "meat_moose_raw",
		name = "Raw Moose Meat",
		description = "A large cut of moose meat. Needs cooking.",
		category = "Food",
		maxStack = 3,
		weight = 2.5,
		icon = "meat_raw",
	},
	meat_moose_cooked = {
		id = "meat_moose_cooked",
		name = "Cooked Moose Steak",
		description = "Hearty moose steak. Very filling.",
		category = "Food",
		maxStack = 3,
		weight = 2.0,
		icon = "meat_cooked",
	},
	fish_trout = {
		id = "fish_trout",
		name = "Trout",
		description = "A fresh trout. Can be cooked.",
		category = "Food",
		maxStack = 5,
		weight = 0.8,
		icon = "fish",
	},
	fish_bass = {
		id = "fish_bass",
		name = "Bass",
		description = "A largemouth bass. Good eating.",
		category = "Food",
		maxStack = 5,
		weight = 1.0,
		icon = "fish",
	},

	------------------------------------------------------------
	-- MATERIALS
	------------------------------------------------------------
	material_wood = {
		id = "material_wood",
		name = "Wood",
		description = "Gathered from trees. Used for crafting and campfires.",
		category = "Material",
		maxStack = 30,
		weight = 0.5,
		icon = "wood",
	},
	material_metal = {
		id = "material_metal",
		name = "Scrap Metal",
		description = "Found in abandoned structures. Used for weapon repair.",
		category = "Material",
		maxStack = 20,
		weight = 0.8,
		icon = "metal",
	},
	material_cloth = {
		id = "material_cloth",
		name = "Cloth",
		description = "Torn fabric. Used for bandages and crafting.",
		category = "Material",
		maxStack = 20,
		weight = 0.2,
		icon = "cloth",
	},
	material_hide = {
		id = "material_hide",
		name = "Animal Hide",
		description = "Leather from hunted animals.",
		category = "Material",
		maxStack = 10,
		weight = 1.0,
		icon = "hide",
	},

	------------------------------------------------------------
	-- MEDICAL
	------------------------------------------------------------
	bandage = {
		id = "bandage",
		name = "Bandage",
		description = "Restores 25 health over a few seconds.",
		category = "Medical",
		maxStack = 5,
		weight = 0.2,
		icon = "bandage",
	},

	------------------------------------------------------------
	-- TOOLS
	------------------------------------------------------------
	repair_kit = {
		id = "repair_kit",
		name = "Weapon Repair Kit",
		description = "Restores weapon condition by 50%.",
		category = "Tool",
		maxStack = 3,
		weight = 1.0,
		icon = "repair_kit",
	},
	fishing_rod = {
		id = "fishing_rod",
		name = "Fishing Rod",
		description = "Cast a line and catch some dinner.",
		category = "Tool",
		maxStack = 1,
		weight = 1.5,
		icon = "fishing_rod",
	},
	water_bottle = {
		id = "water_bottle",
		name = "Water Bottle",
		description = "Clean drinking water. Restores 40 thirst.",
		category = "Tool",
		maxStack = 5,
		weight = 0.5,
		icon = "water",
	},
}

local ItemDatabase = {}

function ItemDatabase.get(itemId: string): Types.ItemDef?
	return Items[itemId]
end

function ItemDatabase.getAll(): ItemDefMap
	return Items
end

function ItemDatabase.exists(itemId: string): boolean
	return Items[itemId] ~= nil
end

return ItemDatabase
