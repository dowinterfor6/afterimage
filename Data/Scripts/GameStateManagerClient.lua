local state = require(script:GetCustomProperty("CustomApi"))
local gameStateManagerServer = script:GetCustomProperty("GameStateManagerServer"):WaitForObject()

function GetGameState()
  gameStateManagerServer:GetCustomProperty("State")
end

function GetTimeRemainingInState()
  if not gameStateManagerServer:GetCustomProperty("StateHasDuration") then
		return nil
	end

	local endTime = gameStateManagerServer:GetCustomProperty("StateEndTime")
	return math.max(endTime - time(), 0.0)
end

state.RegisterGameStateManagerClient(GetGameState, GetTimeRemainingInState)