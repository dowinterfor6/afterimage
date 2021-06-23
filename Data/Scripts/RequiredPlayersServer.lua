local state = require(script:GetCustomProperty("CustomApi"))
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()

local REQUIRED_PLAYERS = COMPONENT_ROOT:GetCustomProperty("RequiredPlayers")
local COUNTDOWN_TIME = COMPONENT_ROOT:GetCustomProperty("CountdownTime")

if REQUIRED_PLAYERS < 1 then
  warn("RequiredPlayers must be positive")
  REQUIRED_PLAYERS = 1
end

if COUNTDOWN_TIME < 0.0 then
  warn("CountdownTime must be non-negative")
  COUNTDOWN_TIME = 0.0
end

-- Handles setting a timer in the lobby game state when there are enough players in the game
function Tick(deltaTime)
	if not state.IsGameStateManagerRegistered() then
		return
	end

	if state.GetGameState() == state.GAME_STATE_LOBBY and state.GetTimeRemainingInState() == nil then
		local players = Game.GetPlayers()
		if #players >= REQUIRED_PLAYERS then
			state.SetTimeRemainingInState(COUNTDOWN_TIME)
		end
	end
end
