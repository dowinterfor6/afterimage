local state = require(script:GetCustomProperty("CustomApi"))
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()

local KILL_LIMIT = COMPONENT_ROOT:GetCustomProperty("KillLimit")

if KILL_LIMIT <= 0 then
    warn("TeamScoreLimit must be positive")
    KILL_LIMIT = 20
end

-- Watches for a team hitting the maximum score and ends the round
function Tick(deltaTime)
	if not state.IsGameStateManagerRegistered() then
		return
	end

	if state.GetGameState() == state.GAME_STATE_ROUND then
		local winner = nil

		for _, player in pairs(Game.GetPlayers()) do
			if player.kills >= KILL_LIMIT then
				if winner then
					Events.Broadcast("TieVictory")
					state.SetGameState(state.GAME_STATE_ROUND_END)
					return
				else
					winner = player
				end
			end
		end

		if winner then
			Events.Broadcast("PlayerVictory", winner)
			state.SetGameState(state.GAME_STATE_ROUND_END)
		end
	end
end
