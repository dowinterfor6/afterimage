local afterimageObjectTemplate = script:GetCustomProperty("AfterimageObjectTemplate")
local afterimageAbility = script:GetCustomProperty("AfterimageAbility"):WaitForObject()
local recallAbility = script:GetCustomProperty("RecallAbility"):WaitForObject()
-- local afterimageEquipment = script.parent

local afterimagePosition
local afterimageObject

-- TODO: Check garbage collection efficiency in core

function OnAfterimageAbilityCast(ability)
  local owner = ability.owner

  afterimageObject = World.SpawnAsset(afterimageObjectTemplate)
  afterimagePosition = ability.owner:GetWorldPosition()
  afterimageObject:SetWorldPosition(afterimagePosition)
  afterimageObject:SetNetworkedCustomProperty("AfterimageObjectOwner", owner.id)
end

function OnRecallAbilityCast(ability)
  if afterimagePosition ~= nil and Object.IsValid(afterimageObject) then
    ability.owner:SetWorldPosition(afterimagePosition)
    afterimagePosition = nil
    afterimageObject:Destroy()
    afterimageObject = nil
    -- TODO: Need to start as disabled/grey
    -- ability.isEnabled = false
  end
end

-- TODO: Toggle isEnabled, probably via tick event, based on if
--       afterimageObject is present or not

afterimageAbility.castEvent:Connect(OnAfterimageAbilityCast)
recallAbility.castEvent:Connect(OnRecallAbilityCast)