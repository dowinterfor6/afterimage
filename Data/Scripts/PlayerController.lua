local afterimageAbilityKeyBinding = script:GetCustomProperty("AfterimageAbilityKeyBinding")
local afterimageReturnAbilityKeyBinding = script:GetCustomProperty("AfterimageReturnAbilityKeyBinding")

local afterimagePosition
-- TODO: SetLookWorldRotation is clientside

local afterimageAbility
local afterimageReturnAbility

function OnBindingPressed(player, bindingPressed)
	if bindingPressed == afterimageAbilityKeyBinding and afterimageAbility:GetCurrentPhase() == AbilityPhase.READY then
		afterimagePosition = player:GetWorldPosition()
		afterimageReturnAbility.isEnabled = true
	elseif bindingPressed == afterimageReturnAbilityKeyBinding and afterimagePosition ~= nil then
		player:SetWorldPosition(afterimagePosition)
		afterimagePosition = nil
		afterimageReturnAbility.isEnabled = false
	end
end

function OnBindingReleased(player, bindingReleased)

end

function OnPlayerJoined(player)
	local abilities = player:GetAbilities()
	for _, ability in pairs(abilities) do
		if ability.actionBinding == afterimageAbilityKeyBinding then
			afterimageAbility = ability
		elseif ability.actionBinding == afterimageReturnAbilityKeyBinding then
			afterimageReturnAbility = ability
		end
	end

	afterimageReturnAbility.isEnabled = false

	player.bindingPressedEvent:Connect(OnBindingPressed)
	player.bindingReleasedEvent:Connect(OnBindingReleased)
end

Game.playerJoinedEvent:Connect(OnPlayerJoined)
