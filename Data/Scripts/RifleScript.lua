local damageToAfterimage = script:GetCustomProperty("DamageToAfterimage")
local headshotDamage = script:GetCustomProperty("HeadshotDamage")
local shotDamage = script:GetCustomProperty("Damage")
local weapon = script.parent

function OnTargetImpactedEvent(weapon, impactData)
	local target = impactData.targetObject

  if not Object.IsValid(target) then return end

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

  if target:IsA("Player") then
    local weaponOwner = impactData.weaponOwner
    local numberOfHits = #impactData:GetHitResults()

    local damageDealt = shotDamage
    if impactData.isHeadshot then
      damageDealt = headshotDamage
    end

    local additionalDamageInfo = Damage.New(damageDealt * numberOfHits)
    additionalDamageInfo.reason = DamageReason.COMBAT
    additionalDamageInfo.sourceAbility = impactData.sourceAbility
    additionalDamageInfo.sourcePlayer = weaponOwner

    target:ApplyDamage(additionalDamageInfo)
  end
end

weapon.targetImpactedEvent:Connect(OnTargetImpactedEvent)