local state = require(script:GetCustomProperty("CustomApi"))
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()

local PERIOD = COMPONENT_ROOT:GetCustomProperty("Period")
local RESPAWN_ON_ROUND_START = COMPONENT_ROOT:GetCustomProperty("RespawnOnRoundStart")

if PERIOD < 0.0 then
  warn("Period must be positive")
  PERIOD = 0.0
end

-- Respawns players with a slight stagger
function RespawnPlayers()
	local numPlayers = #Game.GetPlayers()
	local perPlayerDelay = PERIOD / numPlayers
	for _, player in pairs(Game.GetPlayers()) do
		player:Spawn()

		Task.Wait(perPlayerDelay)
	end
end

-- nil OnGameStateChanged(int, int, bool, float)
-- Handles respawning players when the game state switches to or from lobby state
function OnGameStateChanged(oldState, newState, hasDuration, endTime)

  -- TODO: Respawn on round "start"
	if (newState == state.GAME_STATE_LOBBY and oldState ~= state.GAME_STATE_LOBBY) then
		RespawnPlayers()
	end

	if RESPAWN_ON_ROUND_START and
	newState ~= state.GAME_STATE_LOBBY and oldState == state.GAME_STATE_LOBBY then
		RespawnPlayers()
	end
end

-- Initialize
Events.Connect("GameStateChanged", OnGameStateChanged)
