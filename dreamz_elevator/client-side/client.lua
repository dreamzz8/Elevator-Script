local menuactive = false
function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		SendNUIMessage({ showmenu = true })
		TriggerEvent("hideHud")
	else
		SetNuiFocus(false)
		SendNUIMessage({ hidemenu = true })
		TriggerEvent("showHud")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
--[ BUTTON ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick",function(data,cb)
	local ped = PlayerPedId()
	if data == "0floor" then
		DoScreenFadeOut(1000)
		ToggleActionMenu()
		SetTimeout(1400,function()
			SetEntityCoords(ped,345.81,-582.73,28.8,0,0,0,0)
			SetEntityHeading(ped,253.71)
			DoScreenFadeIn(1000)
		end)

	elseif data == "1floor" then
		DoScreenFadeOut(1000)
		ToggleActionMenu()
		SetTimeout(1400,function()
			SetEntityCoords(ped,330.25,-601.08,43.28,0,0,0,0)
			SetEntityHeading(ped,73.19)
			DoScreenFadeIn(1000)
		end)

	elseif data == "morgue" then
		DoScreenFadeOut(1000)
		ToggleActionMenu()
		SetTimeout(1400,function()
			SetEntityCoords(ped,279.4,-1349.53,24.54,0,0,0,0)
			SetEntityHeading(ped,319.59)
			DoScreenFadeIn(1000)
		end)

	elseif data == "heli" then
		DoScreenFadeOut(1000)
		ToggleActionMenu()
		SetTimeout(1400,function()
			SetEntityCoords(ped,338.69,-583.79,74.16,0,0,0,0)
			SetEntityHeading(ped,257.53)
			DoScreenFadeIn(1000)
		end)
		
	elseif data == "nothing" then
		exports['mythic_notify']:SendAlert('inform', 'Broken Button')
	elseif data == "close" then
		ToggleActionMenu()
	
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ LOCAIS ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local elevator = {
	{ ['x'] = 345.79, ['y'] = -582.6, ['z'] = 28.8 }, -- 0

	{ ['x'] = 330.13, ['y'] = -601.14, ['z'] = 43.28 }, -- 1

	{ ['x'] = 279.41, ['y'] = -1349.67, ['z'] = 24.54 }, -- Morgue

	{ ['x'] = 338.57, ['y'] = -583.94, ['z'] = 74.16 }, -- Down
}
-----------------------------------------------------------------------------------------------------------------------------------------
--[ MENU ]-------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		local sleep = 1000

		for k,v in pairs(elevator) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			local elevator = elevator[k]

			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), elevator.x, elevator.y, elevator.z, true ) <= 2 then
				sleep = 5
				DrawText3D(elevator.x, elevator.y, elevator.z, "~g~[E]~s~ use elevator")
			end
			
			if distance <= 15 then
				sleep = 5
				--DrawMarker(30, elevator.x, elevator.y, elevator.z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,0,140,255,90,0,0,0,1)
				if distance <= 2.3 then
					if IsControlJustPressed(0,38) then
						ToggleActionMenu()
						openDoorAnim()
					end
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ FUNÇÃO ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------


function openDoorAnim()
	if not IsPedInAnyVehicle(PlayerPedId()) then
    	loadAnimDict("mini@sprunk") 
    	TaskPlayAnim( GetPlayerPed(-1), "mini@sprunk", "plyr_buy_drink_pt1", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
		SetTimeout(600, function()
			ClearPedTasks(GetPlayerPed(-1))
		end)
	end
end


function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end


function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)

    local scale = 0.3

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(6)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end