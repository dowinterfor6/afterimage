local ABGS = require(script:GetCustomProperty("API"))
local winnerText = script:GetCustomProperty("WinnerText"):WaitForObject()
local rematchProgressBar = script:GetCustomProperty("RematchProgressBar"):WaitForObject()
local otherPlayerRematchText = script:GetCustomProperty("OtherPlayerRematchText"):WaitForObject()
local panelContainer = script:GetCustomProperty("PanelContainer"):WaitForObject()
local rematchKeybind = script:GetCustomProperty("RematchKeybind")
local progressAmount = script:GetCustomProperty("ProgressAmount")

local localPlayer = Game.GetLocalPlayer()

local progress = 0
local addProgress = false

function OnGameEndWinner(gameWinner)
  panelContainer.visibility = Visibility.INHERIT
  winnerText.text = gameWinner.name .. " won!"
  
  rematchProgressBar.visibility = Visibility.INHERIT
  otherPlayerRematchText.visibility = Visibility.INHERIT
end

function OnGameStateChanged(prevState, newState, _ , _)
  if newState ~= ABGS.GAME_STATE_GAME_END then
    panelContainer.visibility = Visibility.FORCE_OFF
    winnerText.text = ""
    rematchProgressBar.visibility = Visibility.FORCE_OFF
    otherPlayerRematchText.visibility = Visibility.FORCE_OFF
  end
end

function OnBindingPressed(player, bindingPressed)
  if ABGS.GetGameState() ~= ABGS.GAME_STATE_GAME_END then return end
  
  if bindingPressed == rematchKeybind then
    addProgress = true
  end
end

function OnBindingReleased(player, bindingReleased)
  if ABGS.GetGameState() ~= ABGS.GAME_STATE_GAME_END then return end
  
  if bindingReleased == rematchKeybind and progress < 100 then
    addProgress = false
    progress = 0
  end
end

function Tick(dt)
  if addProgress then
    progress = progress + progressAmount * dt
  end

  local fraction = progress / 100

  rematchProgressBar.progress = fraction
end

localPlayer.bindingPressedEvent:Connect(OnBindingPressed)
localPlayer.bindingReleasedEvent:Connect(OnBindingReleased)

Events.Connect("GameEndWinner", OnGameEndWinner)

panelContainer.visibility = Visibility.FORCE_OFF
-- TODO: R for rematch
-- TODO: Sounds

Events.Connect("GameStateChanged", OnGameStateChanged)