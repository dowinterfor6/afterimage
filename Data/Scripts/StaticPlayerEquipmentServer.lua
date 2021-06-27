--[[
Copyright 2019 Manticore Games, Inc. 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

--[[
Gives a specific equipment to every player on spawn, and handles destroying them when unneeded. Also optionally
replaces each equipment on respawn to reset the state.
--]]

-- Internal custom properties
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()

-- User exposed properties
local EQUIPMENT_TEMPLATE = COMPONENT_ROOT:GetCustomProperty("EquipmentTemplate")
local AFTERIMAGE_EQUIPMENT = COMPONENT_ROOT:GetCustomProperty("AfterimageEquipment")
-- TODO: Figure out weapon swapping, might need to do in playercontroller instead
local KATANA_EQUIPMENT = COMPONENT_ROOT:GetCustomProperty("AdvancedDualKatana")
local RIFLE_EQUIPMENT = COMPONENT_ROOT:GetCustomProperty("RifleTemplate")

local weapon1Binding = script:GetCustomProperty("Weapon1Binding")
local weapon2Binding = script:GetCustomProperty("Weapon2Binding")

local TEAM = COMPONENT_ROOT:GetCustomProperty("Team")
local REPLACE_ON_EACH_RESPAWN = COMPONENT_ROOT:GetCustomProperty("ReplaceOnEachRespawn")

-- Check user properties
-- Check AFTERIMAGE_EQUIPMENT too
if not EQUIPMENT_TEMPLATE then
	error("StaticPlayerEquipment needs an equipment template to function")
end

if TEAM < 0 or TEAM > 4 then
    warn("Team must be a valid team number (1-4) or 0")
    TEAM = 0
end
-- Variables
local playerTeams = {}			-- We use this to detect team changes

local equipment2 = {}

-- bool AppliesToPlayersTeam(Player)
-- Returns whether this player should get equipment given the team setting
function AppliesToPlayersTeam(player)
	if TEAM == 0 then
		return true
	end

	return TEAM == player.team
end

function GivePlayerEquipment2(player)
	local afterimageEquipment = World.SpawnAsset(AFTERIMAGE_EQUIPMENT)

	local equipmentArray = {
		World.SpawnAsset(RIFLE_EQUIPMENT),
		World.SpawnAsset(KATANA_EQUIPMENT),
		afterimageEquipment
	}

	equipment2[player] = {
		equipment = equipmentArray,
		currentWeapon = 1
	}
	
	if player then
		equipment2[player].equipment[1]:Equip(player)
		afterimageEquipment:Equip(player)
	end
end

function RemovePlayerEquipment2(player)
	local playerEquipment = equipment2[player].equipment

	if not playerEquipment then return end
	
	for _, equipment in ipairs(playerEquipment) do
		if equipment:IsValid() then
			equipment:Unequip()
		end

		if equipment:IsValid() then
			equipment:Destroy()
		end
	end

	equipment2[player] = {}
end

-- nil OnPlayerRespawned(Player)
-- Replace the equipment if ReplaceOnEachRespawn
function OnPlayerRespawned(player)
	RemovePlayerEquipment2(player)

	if AppliesToPlayersTeam(player) then
		GivePlayerEquipment2(player)
	end
end

-- nil OnPlayerJoined(Player)
-- Gives original equipment
function OnPlayerJoined(player)
	if TEAM ~= 0 then
		playerTeams[player] = player.team
	end

	if REPLACE_ON_EACH_RESPAWN then
		player.spawnedEvent:Connect(OnPlayerRespawned)
	end

	if AppliesToPlayersTeam(player) then
		GivePlayerEquipment2(player)
	end

	player.bindingPressedEvent:Connect(OnBindingPressed)
end

-- nil OnPlayerLeft(Player)
-- Removes equipment
function OnPlayerLeft(player)
	-- TODO: Set game state end
	RemovePlayerEquipment2(player)
end

function OnBindingPressed(player, bindingPressed)
	if bindingPressed == weapon1Binding or bindingPressed == weapon2Binding then
		local playerEquipment = equipment2[player]

		
		if bindingPressed == weapon1Binding and playerEquipment.currentWeapon ~= 1 then
			playerEquipment.equipment[2]:Unequip(player)
			playerEquipment.equipment[2].isEnabled = false
			playerEquipment.equipment[2].visibility = Visibility.FORCE_OFF
			playerEquipment.equipment[1]:Equip(player)
			playerEquipment.equipment[1].isEnabled = true
			playerEquipment.equipment[1].visibility = Visibility.INHERIT
			playerEquipment.currentWeapon = 1
		elseif bindingPressed == weapon2Binding and playerEquipment.currentWeapon ~= 2 then
			playerEquipment.equipment[1]:Unequip(player)
			playerEquipment.equipment[1].isEnabled = false
			playerEquipment.equipment[1].visibility = Visibility.FORCE_OFF
			playerEquipment.equipment[2]:Equip(player)
			playerEquipment.equipment[2].isEnabled = true
			playerEquipment.equipment[2].visibility = Visibility.INHERIT
			playerEquipment.currentWeapon = 2
		end

		Events.BroadcastToPlayer(player, "WeaponChanged", playerEquipment.currentWeapon)
	end
end

-- Initialize
Game.playerJoinedEvent:Connect(OnPlayerJoined)
Game.playerLeftEvent:Connect(OnPlayerLeft)
