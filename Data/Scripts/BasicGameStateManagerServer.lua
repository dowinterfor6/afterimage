--[[
Copyright 2019 Manticore Games, Inc. 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

-- TODO: stop tracking things in ROUND_END, prevent movement in ROUND_START, free movement in GAME_END

-- Internal custom properties
local ABGS = require(script:GetCustomProperty("API"))
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()

-- User exposed properties
local LOBBY_HAS_DURATION = COMPONENT_ROOT:GetCustomProperty("LobbyHasDuration")
local LOBBY_DURATION = COMPONENT_ROOT:GetCustomProperty("LobbyDuration")
local ROUND_START_HAS_DURATION = COMPONENT_ROOT:GetCustomProperty("RoundStartHasDuration")
local ROUND_START_DURATION = COMPONENT_ROOT:GetCustomProperty("RoundStartDuration")
local ROUND_HAS_DURATION = COMPONENT_ROOT:GetCustomProperty("RoundHasDuration")
local ROUND_DURATION = COMPONENT_ROOT:GetCustomProperty("RoundDuration")
local ROUND_END_HAS_DURATION = COMPONENT_ROOT:GetCustomProperty("RoundEndHasDuration")
local ROUND_END_DURATION = COMPONENT_ROOT:GetCustomProperty("RoundEndDuration")
local GAME_END_HAS_DURATION = COMPONENT_ROOT:GetCustomProperty("GameEndHasDuration")
local GAME_END_DURATION = COMPONENT_ROOT:GetCustomProperty("GameEndDuration")

local scoreboard = {}
local deathRecordedInRound = false
local gameEnded = false
local round = 0

-- Check user properties
if LOBBY_DURATION < 0.0 then
    warn("LobbyDuration must be non-negative")
    LOBBY_DURATION = 0.0
end

if ROUND_DURATION < 0.0 then
    warn("RoundDuration must be non-negative")
    ROUND_DURATION = 0.0
end

if ROUND_END_DURATION < 0.0 then
    warn("RoundEndDuration must be non-negative")
    ROUND_END_DURATION = 0.0
end

-- int GetGameState()
-- Gets the current state. Passed to API
function GetGameState()
	return script:GetCustomProperty("State")
end

-- <float> GetTimeRemainingInState()
-- Gets time remaining in state, or nil. Passed to API
function GetTimeRemainingInState()
	if not script:GetCustomProperty("StateHasDuration") then
		return nil
	end

	local endTime = script:GetCustomProperty("StateEndTime")
	return math.max(endTime - time(), 0.0)
end

-- nil SetGameState()
-- Sets the state and configures timing. Passed to API
function SetGameState(newState)
	local stateHasduration
	local stateDuration

	-- Get new state duration information
	if newState == ABGS.GAME_STATE_LOBBY then
		stateHasduration = LOBBY_HAS_DURATION
		stateDuration = LOBBY_DURATION
	elseif newState == ABGS.GAME_STATE_ROUND_START then
		stateHasduration = ROUND_START_HAS_DURATION
		stateDuration = ROUND_START_DURATION
	elseif newState == ABGS.GAME_STATE_ROUND then
		stateHasduration = ROUND_HAS_DURATION
		stateDuration = ROUND_DURATION
	elseif newState == ABGS.GAME_STATE_ROUND_END then
		stateHasduration = ROUND_END_HAS_DURATION
		stateDuration = ROUND_END_DURATION
	elseif newState == ABGS.GAME_STATE_GAME_END then
		stateHasduration = GAME_END_HAS_DURATION
		stateDuration = GAME_END_DURATION
	else
		error("Tried to set game state to unknown state %d", newState)
	end

	local stateEndTime = 0.0
	if stateHasduration then
		stateEndTime = time() + stateDuration
	end

	local oldState = GetGameState()

	-- Broadcast built-in round events
	if oldState ~= ABGS.GAME_STATE_ROUND and newState == ABGS.GAME_STATE_ROUND then
		Game.StartRound()
	elseif oldState == ABGS.GAME_STATE_ROUND and newState ~= ABGS.GAME_STATE_ROUND then
		Game.EndRound()
	end

	-- Broadcast basic game state event
	Events.Broadcast("GameStateChanged", oldState, newState, stateHasDuration, stateEndTime)
	Events.BroadcastToAllPlayers("GameStateChanged", oldState, newState, stateHasDuration, stateEndTime)

	-- Set replicator fields
	script:SetNetworkedCustomProperty("State", newState)
	script:SetNetworkedCustomProperty("StateHasDuration", stateHasduration)
	script:SetNetworkedCustomProperty("StateEndTime", stateEndTime)
end

-- nil SetTimeRemainingInState(float)
-- Sets time remaining in state. Passed to API
function SetTimeRemainingInState(remainingTime)
	local stateEndTime = time() + remainingTime
	local currentState = GetGameState()

	-- We broadcast the event because the time changed, even though we are still in the same state
	Events.Broadcast("GameStateChanged", currentState, currentState, true, stateEndTime)
	Events.BroadcastToAllPlayers("GameStateChanged", currentState, currentState, true, stateEndTime)

	script:SetNetworkedCustomProperty("StateHasDuration", true)
	script:SetNetworkedCustomProperty("StateEndTime", stateEndTime)
end

-- nil Tick(float)
-- Handles condition when state timer ran out
function Tick(deltaTime)
	if GetTimeRemainingInState() == 0.0 and script:GetCustomProperty("StateHasDuration") then
		for _, player in pairs(Game.GetPlayers()) do
			if player.deaths >= 3 then
				gameEnded = true
				break
			end
		end

		local previousState = GetGameState()
		local nextState

		if previousState == ABGS.GAME_STATE_LOBBY then
			nextState = ABGS.GAME_STATE_ROUND_START
			round = round + 1
			Events.BroadcastToAllPlayers("RoundNumberChanged", round)
		elseif previousState == ABGS.GAME_STATE_ROUND_START then
			deathRecordedInRound = false
			nextState = ABGS.GAME_STATE_ROUND
		elseif previousState == ABGS.GAME_STATE_ROUND then
			-- TODO: Needs to not count kills/deaths during round end
			nextState = ABGS.GAME_STATE_ROUND_END
		elseif previousState == ABGS.GAME_STATE_ROUND_END and not gameEnded then
			nextState = ABGS.GAME_STATE_ROUND_START
			round = round + 1
			Events.BroadcastToAllPlayers("RoundNumberChanged", round)
		else
			nextState = ABGS.GAME_STATE_GAME_END

			local gameWinner
			local leastDeaths = 3

			for _, player in ipairs(Game.GetPlayers()) do
				local playerDeaths = scoreboard[player.id]

				if playerDeaths == nil then
					gameWinner = player
					break
				end

				if playerDeaths and playerDeaths < leastDeaths then
					gameWinner = player
					leastDeaths = playerDeaths
				end
			end

			Events.BroadcastToAllPlayers("GameEndWinner", gameWinner)
		end

		SetGameState(nextState)
	end

	local currState = GetGameState()
	local playerEnabled = currState == ABGS.GAME_STATE_ROUND or currState == ABGS.GAME_STATE_LOBBY

	-- TODO: This is honestly terrible but will do for now
	-- TODO: Disable jump is kinda temp
	for _, player in pairs(Game.GetPlayers()) do
		if playerEnabled then
			player.movementControlMode = MovementControlMode.LOOK_RELATIVE
			player.maxJumpCount = 1
		else
			player.movementControlMode = MovementControlMode.NONE
			player.maxJumpCount = 0
		end

		local abilities = player:GetAbilities()

		for _, ability in pairs(abilities) do
			ability.isEnabled = playerEnabled
		end
	end
end

-- TODO: Handle all round end conditions when transitioning rounds
-- e.g. kill, fall to death, timeout

function OnPlayerDied(player, damage)
	local currState = GetGameState()

	if currState == ABGS.GAME_STATE_ROUND and not deathRecordedInRound then
		if scoreboard[player.id] then
			scoreboard[player.id] = scoreboard[player.id] + 1
		else
			scoreboard[player.id] = 1
		end

		deathRecordedInRound = true
		SetGameState(ABGS.GAME_STATE_ROUND_END)
	end
end

function OnPlayerJoined(player)
	player.diedEvent:Connect(OnPlayerDied)
end

function OnPlayerLeft(player)
	SetGameState(ABGS.GAME_STATE_LOBBY)
	
	-- This reset needs to be for scoreboard and deaths, since headerUI uses deaths to calculate
	-- This should be refactored to just use scoreboard tbh

	scoreboard = {}
	gameEnded = false
	Events.BroadcastToAllPlayers("RoundNumberChanged", 0)
	Events.BroadcastToAllPlayers("ResetGame")
end

-- Initialize
SetGameState(ABGS.GAME_STATE_LOBBY)

ABGS.RegisterGameStateManagerServer(GetGameState, GetTimeRemainingInState, SetGameState, SetTimeRemainingInState)
Game.playerJoinedEvent:Connect(OnPlayerJoined)
Game.playerLeftEvent:Connect(OnPlayerLeft)
