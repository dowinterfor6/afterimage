local trigger = script.parent
local paravent = script.parent.parent

local propInteractSound = script:GetCustomProperty("InteractSound"):WaitForObject()


local isOpen = false

function OnBeginOverlap(whichTrigger, other)
	if other:IsA("Player") then
		print(whichTrigger.name .. ": Begin Trigger Overlap with " .. other.name)
	end
end

function OnEndOverlap(whichTrigger, other)
	if other:IsA("Player") then
		print(whichTrigger.name .. ": End Trigger Overlap with " .. other.name)
	end
end

function OnInteracted(whichTrigger, other)
	
	whichTrigger.isInteractable = false

	if other:IsA("Player") and isOpen == false then
		isOpen = true
		propInteractSound:Play()
		print(whichTrigger.name .. ": Trigger Interacted " .. other.name)
		paravent:MoveContinuous(Vector3.New(0, 120, 0), true)
		Task.Wait(1)
		paravent:StopMove()
		whichTrigger.isInteractable = true
		return
	end

	if other:IsA("Player") and isOpen == true then
		isOpen = false
		propInteractSound:Play()
		print(whichTrigger.name .. ": Trigger Interacted " .. other.name)
		paravent:MoveContinuous(Vector3.New(0, -120, 0), true)
		Task.Wait(1)
		paravent:StopMove()
		whichTrigger.isInteractable = true
		return
	end
end

trigger.beginOverlapEvent:Connect(OnBeginOverlap)
trigger.endOverlapEvent:Connect(OnEndOverlap)
trigger.interactedEvent:Connect(OnInteracted)
