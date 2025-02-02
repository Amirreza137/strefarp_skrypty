local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local isCarry 				  = false
local IsCarrying = false
local BeingCarrying = false
local wait = 5000
ESX                     = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)		

function LoadAnimationDictionary(animationD)
	while not HasAnimDictLoaded(animationD) do
		RequestAnimDict(animationD)
		Citizen.Wait(100)
	end
end

RegisterNetEvent('esx_barbie_lyftupp:upplyft')
AddEventHandler('esx_barbie_lyftupp:upplyft', function(target)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	local lPed = GetPlayerPed(-1)
	local dict = "amb@code_human_in_car_idles@low@ps@"
	if isCarry == false then
		LoadAnimationDictionary("amb@code_human_in_car_idles@generic@ps@base")
		TaskPlayAnim(lPed, "amb@code_human_in_car_idles@generic@ps@base", "base", 8.0, -8, -1, 33, 0, 0, 40, 0)
		AttachEntityToEntity(GetPlayerPed(-1), targetPed, 9816, 0.015, 0.38, 0.11, 0.9, 0.30, 90.0, false, false, false, false, 2, false)
		isCarry = true
		BeingCarrying = true
		wait = 100
	else
		DetachEntity(GetPlayerPed(-1), true, false)
		ClearPedTasksImmediately(targetPed)
		ClearPedTasksImmediately(GetPlayerPed(-1))
		isCarry = false
		BeingCarrying = false
		wait = 5000
	end
end)

RegisterCommand("podnies",function(source, args)
	local closestPlayer, distance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= nil and closestPlayer ~= -1 and distance < 3.0 then
		ESX.ShowNotification('~r~Podnosisz~w~ osobę')
		TriggerServerEvent('esx_barbie_lyftupp:lyfteruppn', GetPlayerServerId(closestPlayer))
		Citizen.Wait(1100)
		local dict = "anim@heists@box_carry@"
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(100)
		end
		if distance ~= -1 and distance <= 3.0 then
			TriggerServerEvent('esx_barbie_lyftupp:lyfter', GetPlayerServerId(closestPlayer))		
			TaskPlayAnim(GetPlayerPed(-1), dict, "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
			isCarry = true
			IsCarrying = true
			wait = 100
		else
			ESX.ShowNotification("~r~Brak osób w pobliżu")
			IsCarrying = false
			wait = 5000
		end
	else
		ESX.ShowNotification("~r~Brak osób w pobliżu")
		IsCarrying = false
		wait = 5000
	end
end, false)	

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if BeingCarrying then
			if not IsEntityPlayingAnim(PlayerPedId(), "amb@code_human_in_car_idles@generic@ps@base", "base", 3) then
				LoadAnimationDictionary("amb@code_human_in_car_idles@generic@ps@base")
				TaskPlayAnim(PlayerPedId(), "amb@code_human_in_car_idles@generic@ps@base", "base", 8.0, -8, -1, 33, 0, 0, 40, 0)
			elseif not IsEntityPlayingAnim(PlayerPedId(), "amb@code_human_in_car_idles@generic@ps@base", "base", 3) then
				LoadAnimationDictionary("anim@heists@box_carry@")
				TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
			end
		DisableControlAction(0, 142, true) -- MeleeAttackAlternate
		DisableControlAction(0, 24,  true) -- Shoot 
		DisableControlAction(0, 92,  true) -- Shoot in car
		DisableControlAction(0, 24,  true)
		DisableControlAction(0, 25,  true)
		DisableControlAction(0, 45,  true)
		DisableControlAction(0, 76,  true)
		DisableControlAction(0, 102,  true)
		DisableControlAction(0, 278,  true)
		DisableControlAction(0, 279,  true)
		DisableControlAction(0, 280,  true)
		DisableControlAction(0, 281,  true)
		DisableControlAction(0, 140, true) -- Attack
		DisableControlAction(0, 24, true) -- Attack
		DisableControlAction(0, 25, true) -- Attack
		DisableControlAction(2, 24, true) -- Attack
		DisableControlAction(2, 257, true) -- Attack 2
		DisableControlAction(2, 25, true) -- Aim
		DisableControlAction(2, 263, true) -- Melee Attack 1
		else
		Citizen.Wait(500)
		end
	end
end)