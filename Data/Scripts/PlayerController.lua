-- Disable/visibility off afterimage objects after round over
-- TODO: Each player has 2 ability equipment lol
-- TODO: Players are given a new weapon on state change
-- TODO: Current implementation of simply moving the object instead of creating
--       and destroying is making a trail when the shadow moves
-- TODO: Player sometimes collides with the afterimage

local afterimageAbilityKeyBinding = script:GetCustomProperty("AfterimageAbilityKeyBinding")
local afterimageReturnAbilityKeyBinding = script:GetCustomProperty("AfterimageReturnAbilityKeyBinding")
local afterimageObjectTemplate = script:GetCustomProperty("AfterimageObjectTemplate")
local dashKeybind = script:GetCustomProperty("DashKeybind")
local forwardKeybind = script:GetCustomProperty("ForwardKeybind")
local backwardKeybind = script:GetCustomProperty("BackwardKeybind")
local leftKeybind = script:GetCustomProperty("LeftKeybind")
local rightKeybind = script:GetCustomProperty("RightKeybind")
local doubleTapWindow = script:GetCustomProperty("DoubleTapWindow")

-- TODO: SetLookWorldRotation is clientside

local playersInfo = {}

-- TODO: Hacky, is changed per player join, but should be same based on server settings
-- local originalMaxWalkSpeed

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
	-- TODO: Not the most elegant, but it works
	-- if
	-- 	bindingPressed ~= afterimageAbilityKeyBinding
	-- 	and
	-- 	bindingPressed ~= afterimageReturnAbilityKeyBinding
	-- 	and
	-- 	bindingPressed ~= dashKeybind
	-- then return end

	local playerInfo = playersInfo[player.id]

	-- TODO: Controller?
	if
		bindingPressed == afterimageAbilityKeyBinding
		and
		playerInfo.afterimageAbility:GetCurrentPhase() == AbilityPhase.READY
	then
		playerInfo.afterimagePosition = player:GetWorldPosition()
		playerInfo.afterimageReturnAbility.isEnabled = true

		playerInfo.afterimageObject.isEnabled = true
		playerInfo.afterimageObject.visibility = Visibility.FORCE_ON
		playerInfo.afterimageObject:SetWorldPosition(playerInfo.afterimagePosition)
	elseif
		bindingPressed == afterimageReturnAbilityKeyBinding
		and
		playerInfo.afterimagePosition ~= nil
		and
		playerInfo.afterimageReturnAbility.isEnabled
	then
		player:SetWorldPosition(playerInfo.afterimagePosition)
		playerInfo.afterimagePosition = nil
		playerInfo.afterimageReturnAbility.isEnabled = false

		playerInfo.afterimageObject.isEnabled = false
		playerInfo.afterimageObject.visibility = Visibility.FORCE_OFF
	end

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
		if player.isGrounded then return end
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

function OnBindingReleased(player, bindingReleased)

end

-- TODO: Check hit on afterimage, deal damage and put on CD
-- TODO: Differentiate between self and enemy afterimage?
-- TODO: Camera clips into ground when dying
--       switch to third person camera on death
function OnTargetImpactedEvent(weapon, impactData)
	local target = impactData.targetObject

	if target then

		local targetPlayerInfo
		for _, playerInfo in pairs(playersInfo) do
			if target == playerInfo.afterimageObject then
				targetPlayerInfo = playerInfo
				break
			end
		end

		if targetPlayerInfo then
			local damageInfo = Damage.New(50)
			damageInfo.reason = DamageReason.COMBAT
			-- TODO: damageInfo.sourceAbility as afterimage ability for killfeed
			damageInfo.sourcePlayer = impactData.weaponOwner
			targetPlayerInfo.player:ApplyDamage(damageInfo)

			targetPlayerInfo.afterimageObject.isEnabled = false
			targetPlayerInfo.afterimageObject.visibility = Visibility.FORCE_OFF
			targetPlayerInfo.afterimageReturnAbility.isEnabled = false
		end
	end
end

function OnPlayerJoined(player)
	local afterimageAbility
	local afterimageReturnAbility
	local afterimagePosition

	-- originalMaxWalkSpeed = player.maxWalkSpeed

	-- TODO: This could do some refactoring
	local abilities = player:GetAbilities()
	for _, ability in pairs(abilities) do
		if ability.actionBinding == afterimageAbilityKeyBinding then
			afterimageAbility = ability
		elseif ability.actionBinding == afterimageReturnAbilityKeyBinding then
			afterimageReturnAbility = ability
		elseif ability.actionBinding == dashKeybind then
			dashAbility = ability
		end
	end

	afterimageReturnAbility.isEnabled = false

	local afterimageObject = World.SpawnAsset(afterimageObjectTemplate)
	afterimageObject.isEnabled = false
	afterimageObject.visibility = Visibility.FORCE_OFF

	local playerInputs = {
		forwardLastPressed = -1,
		backwardLastPressed = -1,
		leftLastPressed = -1,
		rightLastPressed = -1,
	}

	local playerInfo = {
		player = player,
		afterimageObject = afterimageObject,
		afterimageAbility = afterimageAbility,
		afterimageReturnAbility = afterimageReturnAbility,
		afterimagePosition = afterimagePosition,
		dashAbility = dashAbility,
		playerInputs = playerInputs
	}

	playersInfo[player.id] = playerInfo

	-- TODO: Not sure if there will be a race condition, weapon is given to player in StaticPlayerEquipmentServer.lua
	local weapon = player:GetEquipment()[1];

	-- TODO: Temp (or just use given settings)
	-- playerInfo.player.maxWalkSpeed = 640

	weapon.targetImpactedEvent:Connect(OnTargetImpactedEvent)
	player.bindingPressedEvent:Connect(OnBindingPressed)
	player.bindingReleasedEvent:Connect(OnBindingReleased)
end

-- TODO: Expensive, see if there's a better way later
function Tick(dt)
	-- TODO: ~142 times a second? could probably debounce this and lower to almost single digits depending on performance
	-- TODO: Add forward keybind speed limit as well maybe

	-- for _, playerInfo in pairs(playersInfo) do
	-- 	if playerInfo.player.isGrounded then
	-- 		-- TODO: Make var
	-- 		-- TODO: Is lua optimized to not reassign unecessarily?
	-- 		playerInfo.player.maxWalkSpeed = 640
	-- 	else
	-- 		playerInfo.player.maxWalkSpeed = originalMaxWalkSpeed
	-- 	end
	-- end
end

Game.playerJoinedEvent:Connect(OnPlayerJoined)
