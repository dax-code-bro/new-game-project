--!strict
--[[
	Constants.luau — All tuning values for the game.
	No magic numbers in game code. Everything lives here.
]]

local Constants = {}

------------------------------------------------------------
-- PLAYER MOVEMENT
------------------------------------------------------------

Constants.WALK_SPEED = 16
Constants.SPRINT_SPEED = 28
Constants.SPRINT_THIRST_MULTIPLIER = 2.0 -- thirst drains faster while sprinting

------------------------------------------------------------
-- CAMERA
------------------------------------------------------------

Constants.MOUSE_SENSITIVITY = 0.3
Constants.DEFAULT_FOV = 70
Constants.ADS_TRANSITION_SPEED = 8 -- speed of FOV lerp when aiming
Constants.HEAD_BOB_SPEED = 8 -- cycles per second while walking
Constants.HEAD_BOB_AMOUNT = 0.03 -- studs of vertical bob
Constants.CAMERA_SWAY_AMOUNT = 0.5 -- degrees of idle sway

------------------------------------------------------------
-- VITALS
------------------------------------------------------------

Constants.DEFAULT_HEALTH = 100
Constants.DEFAULT_MAX_HEALTH = 100
Constants.DEFAULT_THIRST = 100
Constants.DEFAULT_MAX_THIRST = 100

Constants.THIRST_DRAIN_RATE = 0.15 -- points per second
Constants.LOW_THIRST_THRESHOLD = 25 -- below this, debuffs kick in
Constants.THIRST_HEALTH_DRAIN = 0.5 -- health loss per second at 0 thirst
Constants.HEALTH_REGEN_RATE = 0.3 -- health per second when thirst > 50
Constants.HEALTH_REGEN_THIRST_MIN = 50

------------------------------------------------------------
-- INVENTORY
------------------------------------------------------------

Constants.DEFAULT_MAX_SLOTS = 20
Constants.DEFAULT_MAX_WEIGHT = 50.0 -- kg
Constants.OVERWEIGHT_SPEED_MULTIPLIER = 0.5

------------------------------------------------------------
-- WEAPONS (general)
------------------------------------------------------------

Constants.WEAPON_CONDITION_JAM_THRESHOLD = 0.15 -- below this, weapon can jam
Constants.WEAPON_JAM_CHANCE_PER_SHOT = 0.3 -- chance to jam when below threshold
Constants.WEAPON_JAM_CLEAR_TIME = 1.5 -- seconds to unjam

Constants.HIT_VALIDATION_TOLERANCE = 15 -- studs of distance tolerance for anti-cheat
Constants.MAX_FIRE_RATE_TOLERANCE = 1.2 -- 20% tolerance on fire rate checks

------------------------------------------------------------
-- WORLD GENERATION
------------------------------------------------------------

Constants.WORLD_SIZE = 512 -- studs in each direction from center
Constants.TERRAIN_HEIGHT_SCALE = 30 -- max terrain height variation
Constants.TREE_DENSITY = 0.04 -- trees per square stud (approximate)
Constants.ROCK_DENSITY = 0.005
Constants.WATER_LEVEL = 5 -- terrain height for water

------------------------------------------------------------
-- WILDLIFE
------------------------------------------------------------

Constants.ANIMAL_UPDATE_RATE = 0.5 -- seconds between AI updates
Constants.ANIMAL_WANDER_RADIUS = 40 -- studs from spawn point
Constants.MAX_ANIMALS_PER_SERVER = 30

------------------------------------------------------------
-- INTERACTION
------------------------------------------------------------

Constants.PICKUP_RANGE = 10 -- studs
Constants.INTERACTION_RANGE = 8
Constants.INTERACTION_KEY = Enum.KeyCode.E

------------------------------------------------------------
-- RESPAWN
------------------------------------------------------------

Constants.RESPAWN_TIME = 5 -- seconds on death screen before can respawn

------------------------------------------------------------
-- DATA
------------------------------------------------------------

Constants.DATA_VERSION = 1
Constants.AUTOSAVE_INTERVAL = 60 -- seconds

return Constants
