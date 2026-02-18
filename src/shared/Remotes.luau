--!strict
-- Remote event and function definitions
-- Server creates these, client listens/fires them

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = {}

function Remotes.getOrCreate(name: string, className: string): Instance
	local existing = ReplicatedStorage:FindFirstChild(name)
	if existing then
		return existing
	end

	local new = Instance.new(className)
	new.Name = name
	new.Parent = ReplicatedStorage
	return new
end

return Remotes
