local afterimageObjectTemplate = script:GetCustomProperty("AfterimageObjectTemplate")
local afterimageAbility = script:GetCustomProperty("AfterimageAbility"):WaitForObject()
local recallAbility = script:GetCustomProperty("RecallAbility"):WaitForObject()
-- local afterimageEquipment = script.parent

local afterimagePosition
local afterimageObject

-- TODO: Check garbage collection efficiency in core

function OnAfterimageAbilityCast(ability)
  local owner = ability.owner

  if afterimageObject then
    afterimageObject:Destroy()
    afterimageObject = nil
  end
  
  afterimageObject = World.SpawnAsset(afterimageObjectTemplate)
  afterimagePosition = ability.owner:GetWorldPosition()
  afterimageObject:SetWorldPosition(afterimagePosition)
  afterimageObject:SetNetworkedCustomProperty("AfterimageObjectOwner", owner.id)
end

-- TODO: Need to start as disabled/grey
--       isEnabled not working because it needs to connect with the ability that the player has
--       actually i have no idea why it's not working right now

function OnRecallAbilityCast(ability)
  if afterimagePosition ~= nil and Object.IsValid(afterimageObject) then
    ability.owner:SetWorldPosition(afterimagePosition)
    afterimagePosition = nil
    afterimageObject:Destroy()
    afterimageObject = nil
  end
end

afterimageAbility.castEvent:Connect(OnAfterimageAbilityCast)
recallAbility.castEvent:Connect(OnRecallAbilityCast)

function OnGameStateChanged(oldState, newState, hasDuration, endTime)
  -- TODO: Ability becomes out of sync, disable abilities during ROUND_START and ROUND_END as a bandaid fix
  if afterimageObject and Object.IsValid(afterimageObject) then
    afterimageObject:Destroy()
  end
  afterimageObject = nil
  
end

Events.Connect("GameStateChanged", OnGameStateChanged)
