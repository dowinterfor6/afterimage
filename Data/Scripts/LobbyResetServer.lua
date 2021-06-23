local state = require(script:GetCustomProperty("CustomApi"))

-- Handles resetting team scores when the game state switches to lobby
function OnGameStateChanged(oldState, newState, hasDuration, endTime)
	if (newState == state.GAME_STATE_LOBBY and oldState ~= state.GAME_STATE_LOBBY) or
	(newState ~= state.GAME_STATE_LOBBY and oldState == state.GAME_STATE_LOBBY) then
		for _, player in pairs(Game.GetPlayers()) do
			player.kills = 0
			player.deaths = 0
		end
	end
end

Events.Connect("GameStateChanged", OnGameStateChanged)
