local state = require(script:GetCustomProperty("CustomApi"))
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()

local SHOW_LOBBY_MESSAGE = COMPONENT_ROOT:GetCustomProperty("ShowLobbyMessage")
local LOBBY_MESSAGE = COMPONENT_ROOT:GetCustomProperty("LobbyMessage")
local SHOW_ROUND_MESSAGE = COMPONENT_ROOT:GetCustomProperty("ShowRoundMessage")
local ROUND_MESSAGE = COMPONENT_ROOT:GetCustomProperty("RoundMessage")

function OnGameStateChanged(oldState, newState, stateHasDuration, stateEndTime)
  -- if newState == state.GAME_STATE_LOBBY and oldState ~= state.GAME_STATE_LOBBY then
  if newState == state.GAME_STATE_LOBBY then
    if SHOW_LOBBY_MESSAGE then
      Events.BroadcastToAllPlayers("BannerMessage", LOBBY_MESSAGE)
    end
  elseif newState == state.GAME_STATE_ROUND and oldState ~= state.GAME_STATE_ROUND then
    if SHOW_ROUND_MESSAGE then
      Events.BroadcastToAllPlayers("BannerMessage", ROUND_MESSAGE)
    end
  end
  -- TODO: Game/round end message
end

-- Initialize
Events.Connect("GameStateChanged", OnGameStateChanged)