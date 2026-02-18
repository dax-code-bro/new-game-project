--!strict
-- Client entry point
-- All client-side controllers are initialized here

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

print("[Client] Game client started for " .. player.Name)

-- Controllers will be loaded here as we build them
