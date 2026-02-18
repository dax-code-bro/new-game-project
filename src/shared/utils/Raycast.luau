--!strict
--[[
	Raycast.luau — Shared raycast utility with ignore filtering.
	Used by both client (visual) and server (authoritative).
]]

local Raycast = {}

export type RaycastResult = {
	hit: boolean,
	instance: Instance?,
	position: Vector3,
	normal: Vector3,
	distance: number,
	material: Enum.Material?,
}

function Raycast.cast(origin: Vector3, direction: Vector3, ignoreList: { Instance }?): RaycastResult
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	if ignoreList then
		params.FilterDescendantsInstances = ignoreList
	end
	params.IgnoreWater = true

	local result = workspace:Raycast(origin, direction, params)

	if result then
		return {
			hit = true,
			instance = result.Instance,
			position = result.Position,
			normal = result.Normal,
			distance = result.Distance,
			material = result.Material,
		}
	end

	return {
		hit = false,
		instance = nil,
		position = origin + direction,
		normal = Vector3.yAxis,
		distance = direction.Magnitude,
		material = nil,
	}
end

-- Specialized raycast for weapon shots (checks for humanoids in ancestors)
function Raycast.weaponCast(
	origin: Vector3,
	direction: Vector3,
	ignoreList: { Instance }?
): (RaycastResult, Humanoid?, string?)
	local result = Raycast.cast(origin, direction, ignoreList)

	if not result.hit or not result.instance then
		return result, nil, nil
	end

	-- Walk up the tree to find a Humanoid (indicates we hit a character or animal)
	local current: Instance? = result.instance
	while current and current ~= workspace do
		local humanoid = (current :: Instance):FindFirstChildOfClass("Humanoid")
		if humanoid then
			-- Determine if headshot
			local hitPart = result.instance
			local hitName = if hitPart then hitPart.Name else ""
			local isHeadshot = hitName == "Head"
			return result, humanoid :: Humanoid, if isHeadshot then "head" else "body"
		end
		current = (current :: Instance).Parent
	end

	return result, nil, nil
end

return Raycast
