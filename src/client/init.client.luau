--!strict
--[[
	Client Entry Point
	Boots all client controllers in two phases:
	  1. Init — set up internal state, wait for remotes
	  2. Start — begin gameplay loops, cross-controller calls safe
]]

local Players = game:GetService("Players")

local player = Players.LocalPlayer
assert(player, "[Client] LocalPlayer not found")

print("[Client] Game client starting for " .. player.Name)

-- Require all controllers (order matters for dependencies)
type Controller = {
	Init: (() -> ())?,
	Start: (() -> ())?,
}

local controllers: { Controller } = {
	require(script.controllers.InputController),
	require(script.controllers.CameraController),
	require(script.controllers.WeaponController),
}

-- Phase 1: Init all controllers
for _, controller in controllers do
	if controller.Init then
		(controller.Init :: () -> ())()
	end
end

print("[Client] All controllers initialized")

-- Phase 2: Start all controllers
for _, controller in controllers do
	if controller.Start then
		(controller.Start :: () -> ())()
	end
end

print("[Client] All controllers started — ready to play!")
