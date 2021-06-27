local localPlayer = Game.GetLocalPlayer()
local overrideCamera = script.parent

function OnCameraSwap(isOverrideCamera)
  if isOverrideCamera then
    localPlayer:SetOverrideCamera(overrideCamera, 0.5)
  else
    localPlayer:ClearOverrideCamera(0)
  end
end

Events.Connect("swapToOverrideCamera", OnCameraSwap)