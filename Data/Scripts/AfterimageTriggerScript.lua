local trigger = script.parent
local activePlayers = {}
local afterimageObject = trigger.parent

function OnBeginOverlap(theTrigger, player)
  if player and player:IsA("Player") then
    table.insert(activePlayers, player)
    afterimageObject.collision = Collision.FORCE_OFF
  end
end

-- TODO: Semi temp solution, will probably error out when 2 players overlap at the same time
--       but hopefully that never happens
-- TODO: This is a little buggy lol, if player collides quickly, it will have collision and "bounce"
--       if not, if slow enough, then they can pass through

function OnEndOverlap(theTrigger, player)
  if (not player or not player:IsA("Player")) then return end

  for i, p in ipairs(activePlayers) do
    if p == player then
      table.remove(activePlayers, i)
      afterimageObject.collision = Collision.FORCE_ON
      break
    end
  end
end

trigger.beginOverlapEvent:Connect(OnBeginOverlap)
trigger.endOverlapEvent:Connect(OnEndOverlap)