local ABGS = require(script:GetCustomProperty("API"))
local stateNameText = script:GetCustomProperty("StateNameText"):WaitForObject()
local stateTimeText = script:GetCustomProperty("StateTimeText"):WaitForObject()
local profileIcon = script:GetCustomProperty("ProfileIcon"):WaitForObject()
local playerNameText = script:GetCustomProperty("PlayerName"):WaitForObject()
local p2ProfileIcon = script:GetCustomProperty("P2ProfileIcon"):WaitForObject()
local p2PlayerName = script:GetCustomProperty("P2PlayerName"):WaitForObject()

local win1 = script:GetCustomProperty("Win3"):WaitForObject()
local win2 = script:GetCustomProperty("Win2"):WaitForObject()
local win3 = script:GetCustomProperty("Win1"):WaitForObject()

local p2Win1 = script:GetCustomProperty("P2Win3"):WaitForObject()
local p2Win2 = script:GetCustomProperty("P2Win2"):WaitForObject()
local p2Win3 = script:GetCustomProperty("P2Win1"):WaitForObject()

local p1WinIndicators = {
  win1,
  win2,
  win3
}

local p2WinIndicators = {
  p2Win1,
  p2Win2,
  p2Win3
}

local localPlayer = Game.GetLocalPlayer()

profileIcon:SetPlayerProfile(localPlayer)
playerNameText.text = localPlayer.name
playerNameText.visibility = Visibility.INHERIT

local otherPlayer

local round

-- TODO: Visibility off before these values are loaded

-- win1.visibility = Visibility.FORCE_OFF
-- win2.visibility = Visibility.FORCE_OFF
-- win3.visibility = Visibility.FORCE_OFF
-- p2Win1.visibility = Visibility.FORCE_OFF
-- p2Win2.visibility = Visibility.FORCE_OFF
-- p2Win3.visibility = Visibility.FORCE_OFF

function UpdateTimeRemaining(remainingTime)
  if remainingTime then
    stateTimeText.visibility = Visibility.INHERIT
    local minutes = math.ceil(remainingTime) // 60 % 60
    local seconds = math.ceil(remainingTime) % 60
    if minutes == 0 and seconds < 10 then
      if seconds == 0 then
        stateTimeText.text = ""
      else
        stateTimeText.text = string.format("%01d", seconds)
      end
    else
      stateTimeText.text = string.format("%02d:%02d", minutes, seconds)
    end
  end
end

function ResetOtherPlayer()
  otherPlayer = nil
  p2PlayerName.text = "Waiting..."
  p2PlayerName.visibility = Visibility.INHERIT
  p2ProfileIcon.visibility = Visibility.FORCE_OFF
end

function Tick(deltaTime)
  if not otherPlayer then
    for _, player in pairs(Game.GetPlayers()) do
      if player ~= localPlayer then
        otherPlayer = player
        p2ProfileIcon:SetPlayerProfile(otherPlayer)
        p2ProfileIcon.visibility = Visibility.INHERIT
        p2PlayerName.text = otherPlayer.name
        break
      end
    end

  end

  if ABGS.IsGameStateManagerRegistered() then
      -- Hide things by default, let specific logic show it when needed
      stateNameText.text = ""
      stateNameText.visibility = Visibility.INHERIT
      stateTimeText.visibility = Visibility.FORCE_OFF
      local currentState = ABGS.GetGameState()
      local remainingTime = ABGS.GetTimeRemainingInState()

      if currentState == ABGS.GAME_STATE_LOBBY then
        stateNameText.text = "Lobby"
        UpdateTimeRemaining(remainingTime)
      end

      if 
        currentState == ABGS.GAME_STATE_ROUND
        or
        currentState == ABGS.GAME_STATE_ROUND_START
      then
        stateNameText.text = "Round " .. string.format(round)
        UpdateTimeRemaining(remainingTime)
      end

      if currentState == ABGS.GAME_STATE_ROUND_END then
        stateNameText.text = "Round End"
        UpdateTimeRemaining(remainingTime)
      end

      
      if currentState == ABGS.GAME_STATE_GAME_END then
        stateNameText.text = "Game End"
        UpdateTimeRemaining(remainingTime)
      end

      -- TODO: This is also inefficient, but will do for now, should listen to event
      if currentState == ABGS.GAME_STATE_ROUND_END then
        local currPlayerKills = 0
        local otherPlayerKills = 0

        for _, player in pairs(Game.GetPlayers()) do
          if player == localPlayer then
            otherPlayerKills = player.deaths
          elseif player == otherPlayer then
            currPlayerKills = player.deaths
          end
        end

        -- In case of edge case bug
        if currPlayerKills > 3 then
          currPlayerKills = 3
        end

        if otherPlayerKills == 3 then
          otherPlayerKills = 3
        end
        
        for i = 1, currPlayerKills do
          p1WinIndicators[i].visibility = Visibility.INHERIT
        end
        
        for i = 1, otherPlayerKills do
          p2WinIndicators[i].visibility = Visibility.INHERIT
        end
      end
  end
end

function OnRoundNumberChange(newRound)
  round = newRound
end

function OnResetGame()
  ResetOtherPlayer()

  for i = 1, 3 do
    p1WinIndicators[i].visibility = Visibility.FORCE_OFF
  end
  
  for i = 1, 3 do
    p2WinIndicators[i].visibility = Visibility.FORCE_OFF
  end
end

Events.Connect("RoundNumberChanged", OnRoundNumberChange)
Events.Connect("ResetGame", OnResetGame)

stateNameText.visibility = Visibility.FORCE_OFF
ResetOtherPlayer()
