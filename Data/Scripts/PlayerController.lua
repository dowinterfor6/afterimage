-- Disable/visibility off afterimage objects after round over
-- TODO: Each player has 2 ability equipment lol
-- TODO: Players are given a new weapon on state change
-- TODO: Current implementation of simply moving the object instead of creating
--       and destroying is making a trail when the shadow moves
-- TODO: Player sometimes collides with the afterimage

local afterimageAbilityKeyBinding = script:GetCustomProperty("AfterimageAbilityKeyBinding")
local afterimageReturnAbilityKeyBinding = script:GetCustomProperty("AfterimageReturnAbilityKeyBinding")
local afterimageObjectTemplate = script:GetCustomProperty("AfterimageObjectTemplate")

-- TODO: SetLookWorldRotation is clientside

local playersInfo = {}

function OnBindingPressed(player, bindingPressed)
	-- TODO: Not the most elegant, but it works
	if
		bindingPressed ~= afterimageAbilityKeyBinding
		and
		bindingPressed ~= afterimageReturnAbilityKeyBinding
	then return end

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

	-- TODO: Could make a helper function (is this still needed?)
	local abilities = player:GetAbilities()
	for _, ability in pairs(abilities) do
		if ability.actionBinding == afterimageAbilityKeyBinding then
			afterimageAbility = ability
		elseif ability.actionBinding == afterimageReturnAbilityKeyBinding then
			afterimageReturnAbility = ability
		end
	end

	afterimageReturnAbility.isEnabled = false

	local afterimageObject = World.SpawnAsset(afterimageObjectTemplate)
	afterimageObject.isEnabled = false
	afterimageObject.visibility = Visibility.FORCE_OFF

	local playerInfo = {
		player = player,
		afterimageObject = afterimageObject,
		afterimageAbility = afterimageAbility,
		afterimageReturnAbility = afterimageReturnAbility,
		afterimagePosition = afterimagePosition,
	}

	playersInfo[player.id] = playerInfo

	-- TODO: Not sure if there will be a race condition, weapon is given to player in StaticPlayerEquipmentServer.lua
	local weapon = player:GetEquipment()[1];

	weapon.targetImpactedEvent:Connect(OnTargetImpactedEvent)
	player.bindingPressedEvent:Connect(OnBindingPressed)
	player.bindingReleasedEvent:Connect(OnBindingReleased)
end

Game.playerJoinedEvent:Connect(OnPlayerJoined)
