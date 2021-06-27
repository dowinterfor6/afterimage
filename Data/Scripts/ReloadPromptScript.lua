local reloadPrompt = script:GetCustomProperty("ReloadPrompt"):WaitForObject()
local ammoValue = script:GetCustomProperty("AmmoValue")

local LOCAL_PLAYER = Game.GetLocalPlayer()

function GetWeapon(player)
	for i,v in ipairs(player:GetEquipment()) do
		if v:IsA("Weapon") then
			return v
		end
	end
end

function Tick(deltaTime)
  local player = LOCAL_PLAYER

  if player then
    local weapon = GetWeapon(player)
    if weapon ~= nil and weapon.currentAmmo <= ammoValue then
      reloadPrompt.visibility = Visibility.INHERIT
    else
      reloadPrompt.visibility = Visibility.FORCE_OFF
    end
  end
end