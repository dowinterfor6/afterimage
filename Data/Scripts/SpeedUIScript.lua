local speedValueObject = script:GetCustomProperty("SpeedValue"):WaitForObject()
local maxSpeedValueObject = script:GetCustomProperty("MaxSpeedValue"):WaitForObject()

local maxSpeed = 0.0

local LOCAL_PLAYER = Game.GetLocalPlayer()

function updateSpeed()
  -- print(LOCAL_PLAYER:GetVelocity().x)
  -- print(LOCAL_PLAYER:GetVelocity().y)
  -- print(LOCAL_PLAYER:GetVelocity().z)
  local velocity = LOCAL_PLAYER:GetVelocity()
  local xVel = velocity.x
  local yVel = velocity.y
  -- local zVel = velocity.z

  local speed = math.sqrt(xVel * xVel + yVel * yVel)

  if (speed > maxSpeed) then
    maxSpeed = speed
  end

  speedValueObject.text = string.format("%.1f", speed)
  maxSpeedValueObject.text = string.format("%.1f", maxSpeed)
end

function Tick(dt)
  updateSpeed()
end