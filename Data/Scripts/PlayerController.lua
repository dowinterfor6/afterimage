local ABGS = require(script:GetCustomProperty("API"))

-- Disable/visibility off afterimage objects after round over

local forwardKeybind = script:GetCustomProperty("ForwardKeybind")
local backwardKeybind = script:GetCustomProperty("BackwardKeybind")
local leftKeybind = script:GetCustomProperty("LeftKeybind")
local rightKeybind = script:GetCustomProperty("RightKeybind")
local doubleTapWindow = script:GetCustomProperty("DoubleTapWindow")

-- TODO: SetLookWorldRotation is clientside

local playersInfo = {}

local keybindToLastPressedKeyMap = {
	[forwardKeybind] = "forwardLastPressed",
	[backwardKeybind] = "backwardLastPressed",
	[leftKeybind] = "leftLastPressed",
	[rightKeybind] = "rightLastPressed",
}

local rotationOffsetMap = {
	[forwardKeybind] = 0,
	[backwardKeybind] = math.rad(180),
	[leftKeybind] = math.rad(270),
	[rightKeybind] = math.rad(90),
}

function OnBindingPressed(player, bindingPressed)
	local currState = ABGS:GetGameState()
	local playerEnabled = currState == ABGS.GAME_STATE_ROUND or currState == ABGS.GAME_STATE_LOBBY
	if not playerEnabled then return end

	local playerInfo = playersInfo[player.id]

	if
		bindingPressed == forwardKeybind
		or
		bindingPressed == backwardKeybind
		or
		bindingPressed == leftKeybind
		or
		bindingPressed == rightKeybind
	then
		local player = playerInfo.player
		-- if player.isGrounded then return end
		local playerInputs = playerInfo.playerInputs
		local playerInputKey = keybindToLastPressedKeyMap[bindingPressed]
		local playerLastInput = playerInputs[playerInputKey]
		local currTime = time()

		if playerLastInput == -1 or currTime - playerLastInput > doubleTapWindow then
			-- playerLastInput is a reference to the number instead of the value i guess
			playerInputs[playerInputKey] = currTime
			return
		end

		local playerRotation = player:GetWorldRotation()
		local rotationRad = math.rad(playerRotation.z)
		local rotationOffset = rotationOffsetMap[bindingPressed]

		local directionVector = {
			x = math.cos(rotationRad + rotationOffset),
			y = math.sin(rotationRad + rotationOffset),
			z = 0
		}

		local dashCoefficient = 2500
		local rotationVector = Vector3.New(directionVector.x, directionVector.y, directionVector.z)

		local resultingVelocity = rotationVector * dashCoefficient

		player:SetVelocity(resultingVelocity)
	end
end

function OnPlayerJoined(player)

	local playerInputs = {
		forwardLastPressed = -1,
		backwardLastPressed = -1,
		leftLastPressed = -1,
		rightLastPressed = -1,
	}

	local playerInfo = {
		player = player,
		playerInputs = playerInputs
	}

	playersInfo[player.id] = playerInfo

	player.bindingPressedEvent:Connect(OnBindingPressed)
end

Game.playerJoinedEvent:Connect(OnPlayerJoined)
