--!strict
--[[
	Types.luau — Master type definitions for the entire game.
	Every module imports from here. This is the single source of truth.
]]

------------------------------------------------------------
-- ENUMS
------------------------------------------------------------

export type ItemCategory = "Weapon" | "Ammo" | "Food" | "Material" | "Tool" | "Medical"

export type WeaponType = "Rifle" | "Shotgun" | "Pistol" | "Bow"

export type AmmoType = "RifleBullet" | "ShotgunShell" | "PistolBullet" | "Arrow"

export type AnimalType = "Deer" | "Moose" | "Bear" | "Rabbit"

export type FishType = "Trout" | "Bass" | "Salmon" | "Catfish" | "Perch"

export type FoodState = "Raw" | "Cooked" | "Spoiled"

export type WeaponModSlot = "Scope" | "Barrel" | "Grip" | "Stock" | "Magazine"

------------------------------------------------------------
-- ITEMS
------------------------------------------------------------

export type ItemDef = {
	id: string,
	name: string,
	description: string,
	category: ItemCategory,
	maxStack: number,
	weight: number,
	icon: string,
}

export type ItemStack = {
	itemId: string,
	quantity: number,
	metadata: ItemMetadata?,
}

export type ItemMetadata = WeaponMetadata | FoodMetadata

export type WeaponMetadata = {
	type: "Weapon",
	condition: number,
	currentAmmo: number,
	maxAmmo: number,
	mods: { [WeaponModSlot]: string? },
}

export type FoodMetadata = {
	type: "Food",
	foodState: FoodState,
	spoilTime: number,
}

------------------------------------------------------------
-- WEAPONS
------------------------------------------------------------

export type WeaponDef = {
	itemId: string,
	weaponType: WeaponType,
	ammoType: AmmoType,
	damage: number,
	fireRate: number,
	reloadTime: number,
	magazineSize: number,
	spread: number,
	recoilVertical: number,
	recoilHorizontal: number,
	range: number,
	conditionLossPerShot: number,
	headshotMultiplier: number,
	adsZoom: number,
	adsSpeed: number,
}

export type WeaponModDef = {
	itemId: string,
	slot: WeaponModSlot,
	compatibleWeapons: { string },
	statModifiers: {
		damage: number?,
		spread: number?,
		recoilVertical: number?,
		recoilHorizontal: number?,
		magazineSize: number?,
		adsZoom: number?,
		range: number?,
	},
}

------------------------------------------------------------
-- ANIMALS / WILDLIFE
------------------------------------------------------------

export type AnimalDef = {
	animalType: AnimalType,
	displayName: string,
	maxHealth: number,
	moveSpeed: number,
	fleeSpeed: number,
	detectionRange: number,
	fleeRange: number,
	lootTable: { LootEntry },
	hostile: boolean,
	attackDamage: number?,
	attackRange: number?,
	respawnTime: number,
}

export type LootEntry = {
	itemId: string,
	minQuantity: number,
	maxQuantity: number,
	chance: number,
}

------------------------------------------------------------
-- INVENTORY
------------------------------------------------------------

export type Inventory = {
	slots: { ItemStack? },
	maxSlots: number,
	maxWeight: number,
}

------------------------------------------------------------
-- VITALS
------------------------------------------------------------

export type Vitals = {
	health: number,
	maxHealth: number,
	thirst: number,
	maxThirst: number,
}

------------------------------------------------------------
-- PLAYER DATA (persisted)
------------------------------------------------------------

export type PlayerStats = {
	animalsHunted: number,
	fishCaught: number,
	shotsFired: number,
	distanceTraveled: number,
	deaths: number,
}

export type PlayerData = {
	displayName: string,
	joinedAt: number,
	inventory: Inventory,
	equippedWeaponSlot: number?,
	vitals: Vitals,
	stats: PlayerStats,
	lastPosition: { x: number, y: number, z: number }?,
	dataVersion: number,
}

------------------------------------------------------------
-- CRAFTING
------------------------------------------------------------

export type RecipeIngredient = {
	itemId: string,
	quantity: number,
}

export type Recipe = {
	id: string,
	resultItemId: string,
	resultQuantity: number,
	ingredients: { RecipeIngredient },
	craftTime: number,
}

------------------------------------------------------------
-- FISHING
------------------------------------------------------------

export type FishEntry = {
	fishItemId: string,
	weight: number,
	minSize: number,
	maxSize: number,
}

export type FishingSpot = {
	position: Vector3,
	radius: number,
	fishTable: { FishEntry },
}

------------------------------------------------------------
-- WORLD GENERATION
------------------------------------------------------------

export type BiomeType = "DenseForest" | "Clearing" | "Riverside" | "Rocky" | "Swamp"

export type WorldObject = {
	position: Vector3,
	rotation: number,
	scale: number,
	variant: string,
}

export type WorldChunk = {
	chunkX: number,
	chunkZ: number,
	biome: BiomeType,
	trees: { WorldObject },
	rocks: { WorldObject },
	structures: { WorldObject },
	lootSpawns: { Vector3 },
	animalSpawns: { Vector3 },
	fishingSpots: { FishingSpot },
}

------------------------------------------------------------
-- NETWORKING PAYLOADS
------------------------------------------------------------

export type FireWeaponPayload = {
	origin: Vector3,
	direction: Vector3,
}

export type PickupPayload = {
	targetId: string,
}

export type DropPayload = {
	slotIndex: number,
	quantity: number,
}

export type SwapSlotsPayload = {
	fromSlot: number,
	toSlot: number,
}

export type CraftPayload = {
	recipeId: string,
}

export type HitMarkerPayload = {
	hitType: "body" | "head" | "kill",
}

export type DamageIndicatorPayload = {
	direction: Vector3,
	amount: number,
}

return nil
