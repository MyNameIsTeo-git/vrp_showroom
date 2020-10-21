vRP = Proxy.getInterface("vRP")
vRPg = Proxy.getInterface("vRP_garages")

local vehshop = Config.Listino
local fakecar = {model = '', car = nil}
local boughtcar = false
local backlock = false

Citizen.CreateThread(function()
	local last_dir
	while true do
		Citizen.Wait(1)
		if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
			DrawMarker(1,-41.254013061523,-1099.2563476563,26.422361373901-1, 0, 0, 0, 0, 0, 0, 1.25, 1.25, 0.5001, 0, 125, 255, 125, 0, 0, 0, 0)
			if Vdist(GetEntityCoords(GetPlayerPed(-1)),-41.254013061523,-1099.2563476563,26.422361373901) <= 0.8 then
				if not vehshop.opened then
					DisegnaScritteBelle("~w~Press ~INPUT_CELLPHONE_SELECT~ to open the price list.")
					if IsControlJustPressed(1,201) then
						if not vehshop.opened then
							ApriMenu()
						else
							ChiudiMenu("","")
						end
					end
				end
			end
		end
		if vehshop.opened then
			local ped = GetPlayerPed(-1)
			local menu = vehshop.menu[vehshop.currentmenu]
			DisegnaTitoloMenu("<b><i>Price list  "..vehshop.selectedbutton.."/"..CosaFantasticosa(menu.buttons), vehshop.menu.x,vehshop.menu.y + 0.08)
			local y = vehshop.menu.y + 0.12
			buttoncount = CosaFantasticosa(menu.buttons)
			local selected = false
			for i,button in pairs(menu.buttons) do
				if i >= vehshop.menu.from and i <= vehshop.menu.to then
					if i == vehshop.selectedbutton then
						selected = true
					else
						selected = false
					end
					DisegnaMenu(button,vehshop.menu.x,y,selected)
					if button.costs ~= nil then
						if vehshop.currentmenu == "• Compacts" or vehshop.currentmenu == "• Coupes" or vehshop.currentmenu == "• Sedands" or vehshop.currentmenu == "• Sports" or vehshop.currentmenu == "• Classic Sports" or vehshop.currentmenu == "• Supers" or vehshop.currentmenu == "• Muscle" or vehshop.currentmenu == "• Offroad" or vehshop.currentmenu == "• Suvs" or vehshop.currentmenu == "• Vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "• Motorbikes" then
							DisegnaTesto3D(-43.412292480469,-1094.7661132813,26.422361373901+0.35, "~w~Price: ~g~"..button.costs.."~w~$", 0.8, 7,selected)
						else
							DisegnaMenu(button,vehshop.menu.x,y,selected)
						end
					end
					y = y + 0.04
					if vehshop.currentmenu == "• Compacts" or vehshop.currentmenu == "• Coupes" or vehshop.currentmenu == "• Sedands" or vehshop.currentmenu == "• Sports" or vehshop.currentmenu == "• Classic Sports" or vehshop.currentmenu == "• Supers" or vehshop.currentmenu == "• Muscle" or vehshop.currentmenu == "• Offroad" or vehshop.currentmenu == "• Suvs" or vehshop.currentmenu == "• Vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "• Motorbikes" then
						if selected then
							if fakecar.model ~= button.model then
								if DoesEntityExist(fakecar.car) then
									Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
								end
								local hash = GetHashKey(button.model)
								RequestModel(hash)
								local timer = 0
								while not HasModelLoaded(hash) and timer < 255 do
									Citizen.Wait(1)
									RequestModel(hash)
									timer = timer + 1
								end
								if timer < 255 then
									local veh = CreateVehicle(hash,-43.412292480469,-1094.7661132813,26.422361373901-0.81,136.54,true,false)
									vehtodelete = veh
									local primarycolor = tonumber(vehicle_colorprimary)
									local secondarycolor = tonumber(vehicle_colorsecondary)
									local pearlescentcolor = vehicle_pearlescentcolor
									SetVehicleNumberPlateTextIndex(veh, 0)
									SetVehicleColours(veh, primarycolor, secondarycolor)
									SetVehicleExtraColours(veh, tonumber(pearlescentcolor), tonumber(wheelcolor))
									SetVehicleNumberPlateText(veh, "")
									while not DoesEntityExist(veh) do
										Citizen.Wait(1)
									end
									FreezeEntityPosition(veh,true)
									SetEntityInvincible(veh,true)
									SetVehicleDoorsLocked(veh,4)
									Citizen.CreateThread(function()
										while DoesEntityExist(veh) do
											Citizen.Wait(25)
											SetEntityHeading(veh, GetEntityHeading(veh)+1 %360)
										end
									end)
									for i = 0,24 do
										SetVehicleModKit(veh,0)
										RemoveVehicleMod(veh,i)
									end
									fakecar = { model = button.model, car = veh}
								else
									timer = 0
									while timer < 50 do
										Citizen.Wait(1)
										timer = timer + 1
									end
									if last_dir then
										if vehshop.selectedbutton < buttoncount then
											vehshop.selectedbutton = vehshop.selectedbutton +1
											if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
												vehshop.menu.to = vehshop.menu.to + 1
												vehshop.menu.from = vehshop.menu.from + 1
											end
										else
											last_dir = false
											vehshop.selectedbutton = vehshop.selectedbutton -1
											if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
												vehshop.menu.from = vehshop.menu.from -1
												vehshop.menu.to = vehshop.menu.to - 1
											end
										end
									else
										if vehshop.selectedbutton > 1 then
											vehshop.selectedbutton = vehshop.selectedbutton -1
											if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
												vehshop.menu.from = vehshop.menu.from -1
												vehshop.menu.to = vehshop.menu.to - 1
											end
										else
											last_dir = true
											vehshop.selectedbutton = vehshop.selectedbutton +1
											if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
												vehshop.menu.to = vehshop.menu.to + 1
												vehshop.menu.from = vehshop.menu.from + 1
											end
										end
									end
								end
							end
						end
					end
					if selected and IsControlJustPressed(1,201) then
						DisegnaBottoneSelezionato(button)
					end
				end
			end
			if IsControlJustPressed(1,202) then
				IndietroMenu()
				DelittaDue(vehtodelete)
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				last_dir = false
				if vehshop.selectedbutton > 1 then
					vehshop.selectedbutton = vehshop.selectedbutton -1
					if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
						vehshop.menu.from = vehshop.menu.from -1
						vehshop.menu.to = vehshop.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				last_dir = true
				if vehshop.selectedbutton < buttoncount then
					vehshop.selectedbutton = vehshop.selectedbutton +1
					if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
						vehshop.menu.to = vehshop.menu.to + 1
						vehshop.menu.from = vehshop.menu.from + 1
					end
				end
			end
		end
	end
end)

RegisterNetEvent('vrp:ChiudiMenu')
AddEventHandler('vrp:ChiudiMenu', function(vehicle, veh_type)
	boughtcar = true
	ChiudiMenu(vehicle,veh_type)
end)

function ApriMenu()
	gameplaycam = GetRenderingCam()
	SetEntityCoords(GetPlayerPed(-1), -41.254013061523,-1099.2563476563,26.422361373901-1)
	SetEntityHeading(GetPlayerPed(-1), 30.99)
	TriggerServerEvent("vrp:AnimazioneListino")
	FreezeEntityPosition(GetPlayerPed(-1),true)
	Citizen.Wait(500)
	StartFade()
	Citizen.Wait(500)
	SetupInsideCam()
	EndFade()
	boughtcar = false
	vehshop.currentmenu = "• Menu"
	vehshop.opened = true
	vehshop.selectedbutton = 0
end

function ApriSubMenu(menu)
	fakecar = {model = '', car = nil}
	vehshop.lastmenu = vehshop.currentmenu
	if menu == "• Cars" then
		vehshop.lastmenu = "• Menu"
	elseif menu == "• Motorbikes"  then
		vehshop.lastmenu = "• Menu"
	elseif menu == 'race_create_objects' then
		vehshop.lastmenu = "• Menu"
	elseif menu == "race_create_objects_spawn" then
		vehshop.lastmenu = "race_create_objects"
	end
	vehshop.menu.from = 1
	vehshop.menu.to = 10
	vehshop.selectedbutton = 0
	vehshop.currentmenu = menu	
end

function IndietroMenu()
	if backlock then
		return
	end
	backlock = true
	if vehshop.currentmenu == "• Menu" then
		ChiudiMenu("","")
	elseif vehshop.currentmenu == "Sports" or vehshop.currentmenu == "normali" or vehshop.currentmenu == "• Sedands" or vehshop.currentmenu == "• Sports" or vehshop.currentmenu == "• Classic Sports" or vehshop.currentmenu == "• Supers" or vehshop.currentmenu == "• Muscle" or vehshop.currentmenu == "• Offroad" or vehshop.currentmenu == "• Suvs" or vehshop.currentmenu == "• Vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "• Motorbikes" then
		if DoesEntityExist(fakecar.car) then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
		end
		fakecar = {model = '', car = nil}
		ApriSubMenu(vehshop.lastmenu)
	else
		ApriSubMenu(vehshop.lastmenu)
	end
end

function ChiudiMenu(vehicle,veh_type,button)
	FreezeEntityPosition(GetPlayerPed(-1),false)
	ClearPedTasks(PlayerPedId())
	Citizen.CreateThread(function()
	local ped = GetPlayerPed(-1)
		if boughtcar then
			DisegnaNotifica("Go to the garage and pick up your new vehicle.")
		end
		StartFade()
		SetCamCoord(cam,GetGameplayCamCoords())
		SetCamRot(cam, GetGameplayCamRot(2), 2)
		RenderScriptCams( 1, 1, 0, 0, 0)
		RenderScriptCams( 0, 1, 1000, 0, 0)
		SetCamActive(gameplaycam, true)
		EnableGameplayCam(true)
		SetCamActive(cam, false)
		Citizen.Wait(500)
		EndFade()
		vehshop.opened = false
		vehshop.menu.from = 1
		vehshop.menu.to = 10
	end)
end

function DisegnaTitoloMenu(txt,x,y)
	local menu = vehshop.menu
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function DisegnaMenu(button,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function DisegnaBottoneSelezionato(button)
	local ped = GetPlayerPed(-1)
	local this = vehshop.currentmenu
	local btn = button.name
	if this == "• Menu" then
		if btn == "• Cars" then
			ApriSubMenu('• Cars')
		elseif btn == "• Motorbikes" then
			ApriSubMenu('• Motorbikes')
		end
	elseif this == "• Cars" then
		if btn == "• Sports" then
			ApriSubMenu('• Sports')
		elseif btn == "• Sedands" then
			ApriSubMenu('• Sedands')
		elseif btn == "• Compacts" then
			ApriSubMenu('• Compacts')
		elseif btn == "• Coupes" then
			ApriSubMenu('• Coupes')
		elseif btn == "• Classic Sports" then
			ApriSubMenu("• Classic Sports")
		elseif btn == "• Supers" then
			ApriSubMenu('• Supers')
		elseif btn == "• Muscle" then
			ApriSubMenu('• Muscle')
		elseif btn == "• Offroad" then
			ApriSubMenu('• Offroad')
		elseif btn == "• Suvs" then
			ApriSubMenu('• Suvs')
		elseif btn == "• Vans" then
			ApriSubMenu('• Vans')
		end
	elseif this == "• Compacts" or this == "• Coupes" or this == "• Sedands" or this == "• Sports" or this == "• Classic Sports" or this == "• Supers" or this == "• Muscle" or this == "• Offroad" or this == "• Suvs" or this == "• Vans" or this == "industrial" then
		TriggerServerEvent('vrp:ControllaMoney',button.model,button.costs, "car")
    elseif this == "• Motorbikes" then
		TriggerServerEvent('vrp:ControllaMoney',button.model,button.costs, "bike")
	end
end

function DisegnaTesto3D(x,y,z, text, scl, font, selected) 
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
	local scale = (1/dist)*scl
	local fov = (1/GetGameplayCamFov())*100
	local scale = scale*fov
	if onScreen then
		if selected then
			SetTextScale(0.0*scale, 1.1*scale)
			SetTextFont(font)
			SetTextProportional(1)
			SetTextColour(255, 255, 255, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(2, 0, 0, 0, 150)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			SetTextCentre(1)
			AddTextComponentString(text)
			DrawText(_x,_y)
		end
	end
end

function DisegnaScritteBelle(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DisegnaNotifica(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function DelittaDue(entity)
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(entity))
end

function CosaFantasticosa(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

function SetupInsideCam()
	local ped = GetPlayerPed(-1)
	cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",true,2)
	SetCamCoord(cam, -41.254013061523,-1099.2563476563,26.422361373901 + 1.0)
	PointCamAtCoord(cam, -43.412292480469,-1094.7661132813,26.422361373901)
	SetCamActive(cam, true)
	RenderScriptCams( 1, 0, cam, 0, 0)
end

function StartFade()
	Citizen.CreateThread(function()
		DoScreenFadeOut(0)
		while IsScreenFadingOut() do
			Citizen.Wait(0)
		end
	end)
end

function EndFade()
	Citizen.CreateThread(function()
		ShutdownLoadingScreen()
        DoScreenFadeIn(500)
        while IsScreenFadingIn() do
            Citizen.Wait(0)
        end
	end)
end
