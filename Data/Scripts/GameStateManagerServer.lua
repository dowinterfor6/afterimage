local state = require(script:GetCustomProperty("CustomApi"))
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()

local LOBBY_HAS_DURATION = COMPONENT_ROOT:GetCustomProperty("LobbyHasDuration")
local LOBBY_DURATION = COMPONENT_ROOT:GetCustomProperty("LobbyDuration")
local ROUND_HAS_DURATION = COMPONENT_ROOT:GetCustomProperty("RoundHasDuration")
local ROUND_DURATION = COMPONENT_ROOT:GetCustomProperty("RoundDuration")
local ROUND_END_HAS_DURATION = COMPONENT_ROOT:GetCustomProperty("RoundEndHasDuration")
local ROUND_END_DURATION = COMPONENT_ROOT:GetCustomProperty("RoundEndDuration")
local GAME_END_HAS_DURATION = COMPONENT_ROOT:GetCustomProperty("GameEndHasDuration")
local GAME_END_DURATION = COMPONENT_ROOT:GetCustomProperty("GameEndDuration")

-- Networked property getters

function GetGameState()
  return script:GetCustomProperty("State")
end

function GetTimeRemainingInState()
  if not script:GetCustomProperty("StateHasDuration") then
		return nil
	end

	local endTime = script:GetCustomProperty("StateEndTime")
	return math.max(endTime - time(), 0.0)
end

function SetGameState(newState)
	local stateHasDuration
	local stateDuration

	if newState == state.GAME_STATE_LOBBY then
		stateHasDuration = LOBBY_HAS_DURATION
		stateDuration = LOBBY_DURATION
	elseif newState == state.GAME_STATE_ROUND then
		stateHasDuration = ROUND_HAS_DURATION
		stateDuration = ROUND_DURATION
	elseif newState == state.GAME_STATE_ROUND_END then
		stateHasDuration = ROUND_END_HAS_DURATION
		stateDuration = ROUND_END_DURATION
  elseif newState == state.GAME_STATE_GAME_END then
    stateHasDuration = GAME_END_HAS_DURATION
    stateDuration = GAME_END_DURATION
	else
		error("Tried to set game state to unknown state %d", newState)
	end

	local stateEndTime = 0.0
	if stateHasDuration then
		stateEndTime = time() + stateDuration
	end

	local oldState = GetGameState()

	-- Broadcast built-in round events
  -- TODO: Here, Fire all events attached to roundStartEvent, check what is listening
	if oldState ~= state.GAME_STATE_ROUND and newState == state.GAME_STATE_ROUND then
		Game.StartRound()
	elseif oldState == state.GAME_STATE_ROUND and newState ~= state.GAME_STATE_ROUND then
		Game.EndRound()
	end

	-- Broadcast basic game state event
	Events.Broadcast("GameStateChanged", oldState, newState, stateHasDuration, stateEndTime)
	Events.BroadcastToAllPlayers("GameStateChanged", oldState, newState, stateHasDuration, stateEndTime)

	-- Set networked property fields
	script:SetNetworkedCustomProperty("State", newState)
	script:SetNetworkedCustomProperty("StateHasDuration", stateHasDuration)
	script:SetNetworkedCustomProperty("StateEndTime", stateEndTime)
end

function SetTimeRemainingInState(remainingTime)
  local stateEndTime = time() + remainingTime
	local currentState = GetGameState()

	Events.Broadcast("GameStateChanged", currentState, currentState, true, stateEndTime)
	Events.BroadcastToAllPlayers("GameStateChanged", currentState, currentState, true, stateEndTime)

	script:SetNetworkedCustomProperty("StateHasDuration", true)
	script:SetNetworkedCustomProperty("StateEndTime", stateEndTime)
end

-- If state timer runs out
function Tick(deltaTime)
	if GetTimeRemainingInState() == 0.0 and script:GetCustomProperty("StateHasDuration") then
		local previousState = GetGameState()
		local nextState
		if previousState == state.GAME_STATE_LOBBY then
			nextState = state.GAME_STATE_ROUND
		elseif previousState == state.GAME_STATE_ROUND then
			nextState = state.GAME_STATE_ROUND_END
    -- TODO: Round logit
		elseif previousState == state.GAME_STATE_ROUND_END then
			nextState = state.GAME_STATE_GAME_END
		end

		SetGameState(nextState)
	end
end

SetGameState(state.GAME_STATE_LOBBY)

state.RegisterGameStateManagerServer(GetGameState, GetTimeRemainingInState, SetGameState, SetTimeRemainingInState)