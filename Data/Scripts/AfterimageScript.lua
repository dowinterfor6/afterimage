local ability = script.parent

local abilityReturnPosition

function OnCast(ability)
  local playerPosition = ability.owner:GetWorldPosition()
  -- abilityReturnPosition = playerPosition
  print(playerPosition)
end

ability.castEvent:Connect(OnCast)