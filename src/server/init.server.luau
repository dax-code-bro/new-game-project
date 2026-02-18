--!strict
--[[
	Server Entry Point
	Boots all server services in two phases:
	  1. Init — set up internal state, register remotes
	  2. Start — begin gameplay loops, cross-service calls safe
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Setup remotes first (before any services try to use them)
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = require(Shared.Remotes)
Remotes.setup()

print("[Server] Remotes created")

-- Require all services (order matters for dependencies)
type Service = {
	Init: (() -> ())?,
	Start: (() -> ())?,
}

local services: { Service } = {
	require(script.services.WeaponService),
}

-- Phase 1: Init all services
for _, service in services do
	if service.Init then
		(service.Init :: () -> ())()
	end
end

print("[Server] All services initialized")

-- Phase 2: Start all services
for _, service in services do
	if service.Start then
		(service.Start :: () -> ())()
	end
end

print("[Server] All services started — game is live!")
