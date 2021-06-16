local ability = script.parent

function OnExecute(ability)
  local player = ability.owner
  -- TODO: Use binding input rather than camera input
  -- TODO: Pretty sure i have to put this back in player controller to use keybind input for direction
  -- 0 and 180, x = +- 1, use cos
  -- 90 and 270, y = += 1, use sin
  
  local playerRotation = player:GetWorldRotation()
  local rotationRad = math.rad(playerRotation.z)
  local directionVector = {
    x = math.cos(rotationRad),
    y = math.sin(rotationRad),
    z = 0.01
  }

  local dashCoefficient = 10000
  local rotationVector = Vector3.New(directionVector.x, directionVector.y, directionVector.z)
  -- player:AddImpulse(rotationVector * dashCoefficient)

  print("dash")
  player:SetVelocity(rotationVector * dashCoefficient)
end

function OnRecovery(ability)
  local player = ability.owner
  player:ResetVelocity()
  print("stop dash")
end

ability.executeEvent:Connect(OnExecute)
ability.recoveryEvent:Connect(OnRecovery)