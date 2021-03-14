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
  
  ESX               = nil
  
  Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)
  
  local Melee = { -1569615261, 1737195953, 1317494643, -1786099057, 1141786504, -2067956739, -868994466 }
  local Knife = { -1716189206, 1223143800, -1955384325, -1833087301, 910830060, }
  local Bullet = { 453432689, 1593441988, 584646201, -1716589765, 324215364, 736523883, -270015777, -1074790547, -2084633992, -1357824103, -1660422300, 2144741730, 487013001, 2017895192, -494615257, -1654528753, 100416529, 205991906, 1119849093 }
  local Animal = { -100946242, 148160082 }
  local FallDamage = { -842959696 }
  local Explosion = { -1568386805, 1305664598, -1312131151, 375527679, 324506233, 1752584910, -1813897027, 741814745, -37975472, 539292904, 341774354, -1090665087 }
  local Gas = { -1600701090 }
  local Burn = { 615608432, 883325847, -544306709 }
  local Drown = { -10959621, 1936677264 }
  local Car = { 133987706, -1553120962 }
  
  function checkArray (array, val)
	  for name, value in ipairs(array) do
		  if value == val then
			  return true
		  end
	  end
  
	  return false
  end
  
  Citizen.CreateThread(function()
	  Citizen.Wait(1000)
		while true do
		  local sleep = 3000
  
		  if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
  
			  local player, distance = ESX.Game.GetClosestPlayer()
  
			  if distance ~= -1 and distance < 10.0 then
  
				  if distance ~= -1 and distance <= 2.0 then	
					  if IsPedDeadOrDying(GetPlayerPed(player)) then
						  Start(GetPlayerPed(player))
					  end
				  end
  
			  else
				  sleep = sleep / 100 * distance 
			  end
  
		  end
  
		  Citizen.Wait(sleep)
  
	  end
  end)
  
  function Start(ped)
	  checking = true
  
	  while checking do
		  Citizen.Wait(5)
  
		  local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(ped))
  
		  local x,y,z = table.unpack(GetEntityCoords(ped))
		  if PlayerData.job.name ~= nil and PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'police' then
		  if distance < 0.5 then
			  DrawText3D(x,y,z, 'Nacisnij [~g~E~s~] aby  sprawdzić co się stało', 0.3)
			  
			  if IsControlPressed(0,  Keys['E']) then
				  OpenDeathMenu(ped)
			  end
		  end
		end
		  if distance > 7.5 or not IsPedDeadOrDying(ped) then
			  checking = false
		  end
  
	end
  
end
  
  function Notification(x,y,z)
	  local timestamp = GetGameTimer()
  
	  while (timestamp + 4500) > GetGameTimer() do
		  Citizen.Wait(0)
		  ESX.ShowNotification("Nie można określić gdzie znajdują się rany")
		  checking = false
	  end
  end
  
  function OpenDeathMenu(player)
  
	  loadAnimDict('amb@medic@standing@kneel@base')
	  loadAnimDict('anim@gangops@facility@servers@bodysearch@')
  
	  
			  local d = GetPedCauseOfDeath(player)		
			  local playerPed = GetPlayerPed(-1)
  
			  --starts animation
  
			  TaskPlayAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
			  TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
  
			  Citizen.Wait(5000)
  
			  --exits animation			
  
			  ClearPedTasksImmediately(playerPed)
  
			  if checkArray(Melee, d) then
				  Notify(_U('hardmeele'))
			  elseif checkArray(Bullet, d) then
				  
					
				local msg = {
					'Rana postrzałowa w lewym udzie',
					'Rana postrzałowa w prawy bark',
					'Rana postrzałowa w okolicach klatki piersiowej',
					'Dwie rany postrzalowe ktore przeszly na wylot w okolicach klatki piersiowej',
					'Rana postrzalowa na nodze, wokol rany widac zakarzenie',
					'Jedna rana postrzalowa na ramieniu, kula znajduje sie w ciele',
					'Wiele ran postrzalowych na ciele',
					'Rana postrzalowa stopy',
					'Trzy rany postrzalowe w okolicach klatki piersiowej',
					'Przestrzelony palec',	
				}
			
				
				local obr = msg[math.random(1, #msg)]

				--ESX.ShowNotification('Rany postrzałowe: ' .. obr)
			 TriggerEvent("pNotify:SendNotification", {
			 	text = obr,
				type = "notifyStrefa",
			 	queue = "global",
			 	timeout = 7000,
			 	layout = "notifySRP",
			 	theme = "gta"
			 })

			  elseif checkArray(Knife, d) then
				  Notify(_U('knifes'))
			  elseif checkArray(Animal, d) then
				  Notify(_U('bitten'))
			  elseif checkArray(FallDamage, d) then
				  Notify(_U('brokenlegs'))
			  elseif checkArray(Explosion, d) then
				  Notify(_U('explosive'))
			  elseif checkArray(Gas, d) then
				  Notify(_U('gas'))
			  elseif checkArray(Burn, d) then
				  Notify(_U('fire'))
			  elseif checkArray(Drown, d) then
				  Notify(_U('drown'))
			  elseif checkArray(Car, d) then
				  Notify(_U('caraccident'))
			  else
				  Notify(_U('unknown'))
			  end
		  end
  
  function loadAnimDict(dict)
	  while (not HasAnimDictLoaded(dict)) do
		  RequestAnimDict(dict)
		  
		  Citizen.Wait(1)
	  end
  end
  
  function Notify(message)
	  ESX.ShowNotification(message)
  end
  
  function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 90)
end
