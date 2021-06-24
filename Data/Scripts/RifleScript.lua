local damageToAfterimage = script:GetCustomProperty("DamageToAfterimage")
local weapon = script.parent

function OnTargetImpactedEvent(weapon, impactData)
	local target = impactData.targetObject

	if target.parent ~= nil and target.parent:GetCustomProperty("IsAfterimage") then
		local targetPlayerId = target.parent:GetCustomProperty("AfterimageObjectOwner")
    local targetPlayer
    local allPlayers = Game.GetPlayers()
    
    -- TODO: Prevent damage to own afterimage?
    for _, player in ipairs(allPlayers) do
      if player.id == targetPlayerId then
        targetPlayer = player
        break
      end
    end
    
    if targetPlayer == impactData.weaponOwner then return end
    
    local damageInfo = Damage.New(damageToAfterimage)
    damageInfo.reason = DamageReason.COMBAT
    damageInfo.sourcePlayer = impactData.weaponOwner
		targetPlayer:ApplyDamage(damageInfo)		

    target.parent:Destroy()
	end
end

weapon.targetImpactedEvent:Connect(OnTargetImpactedEvent)