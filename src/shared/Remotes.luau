--!strict
--[[
	Remotes.luau — Central registry for all RemoteEvents and RemoteFunctions.
	Server calls Remotes.setup() on startup to create all remotes.
	Client calls Remotes.waitFor() to get references.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = {}

-- Folder to hold all remotes
local FOLDER_NAME = "GameRemotes"

-- All remote event names
local REMOTE_EVENTS = {
	-- Client -> Server
	"FireWeapon",
	"ReloadWeapon",
	"RequestPickup",
	"RequestDrop",
	"SwapInventorySlots",
	"UseConsumable",
	"RequestCraft",
	"RequestFishCast",
	"RequestFishReel",
	"RequestRepairWeapon",
	"RequestApplyMod",
	"RequestRespawn",

	-- Server -> Client
	"InventoryUpdated",
	"VitalsUpdated",
	"WeaponStateUpdated",
	"HitMarker",
	"DamageIndicator",
	"PlayerDied",
	"AnimalSpawned",
	"AnimalDied",
	"AnimalMoved",
	"FishingBite",
	"FishingResult",
}

-- All remote function names
local REMOTE_FUNCTIONS = {
	"GetPlayerData",
	"GetRecipes",
}

-- Server calls this once on startup to create all remotes
function Remotes.setup(): Folder
	local folder = Instance.new("Folder")
	folder.Name = FOLDER_NAME

	for _, name in REMOTE_EVENTS do
		local remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = folder
	end

	for _, name in REMOTE_FUNCTIONS do
		local remote = Instance.new("RemoteFunction")
		remote.Name = name
		remote.Parent = folder
	end

	folder.Parent = ReplicatedStorage
	print("[Remotes] Created", #REMOTE_EVENTS, "events and", #REMOTE_FUNCTIONS, "functions")
	return folder
end

-- Get the remotes folder (server-side, already exists)
function Remotes.getFolder(): Folder
	local folder = ReplicatedStorage:FindFirstChild(FOLDER_NAME)
	assert(folder, "[Remotes] Folder not found — did the server call Remotes.setup()?")
	return folder :: Folder
end

-- Client calls this to wait for a specific remote event
function Remotes.waitForEvent(name: string): RemoteEvent
	local folder = ReplicatedStorage:WaitForChild(FOLDER_NAME, 10)
	assert(folder, "[Remotes] Timed out waiting for remotes folder")
	local remote = folder:WaitForChild(name, 10)
	assert(remote, "[Remotes] Timed out waiting for remote event: " .. name)
	return remote :: RemoteEvent
end

-- Client calls this to wait for a specific remote function
function Remotes.waitForFunction(name: string): RemoteFunction
	local folder = ReplicatedStorage:WaitForChild(FOLDER_NAME, 10)
	assert(folder, "[Remotes] Timed out waiting for remotes folder")
	local remote = folder:WaitForChild(name, 10)
	assert(remote, "[Remotes] Timed out waiting for remote function: " .. name)
	return remote :: RemoteFunction
end

-- Quick access: get an event from the folder (server-side, no wait)
function Remotes.getEvent(name: string): RemoteEvent
	local folder = Remotes.getFolder()
	local remote = folder:FindFirstChild(name)
	assert(remote, "[Remotes] Event not found: " .. name)
	return remote :: RemoteEvent
end

-- Quick access: get a function from the folder (server-side, no wait)
function Remotes.getFunction(name: string): RemoteFunction
	local folder = Remotes.getFolder()
	local remote = folder:FindFirstChild(name)
	assert(remote, "[Remotes] Function not found: " .. name)
	return remote :: RemoteFunction
end

return Remotes
