local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

MySQL = module("vrp_mysql", "MySQL")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_showroom")

MySQL.createCommand("vRP/showroom_columns", [[
ALTER TABLE vrp_user_vehicles ADD IF NOT EXISTS veh_type varchar(255) NOT NULL DEFAULT 'default' ;
ALTER TABLE vrp_user_vehicles ADD IF NOT EXISTS vehicle_plate varchar(255) NOT NULL;
]])
MySQL.query("vRP/showroom_columns")
MySQL.createCommand("vRP/add_custom_vehicle","INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle,vehicle_plate,veh_type) VALUES(@user_id,@vehicle,@vehicle_plate,@veh_type)")

RegisterServerEvent('vrp:ControllaMoney')
AddEventHandler('vrp:ControllaMoney', function(vehicle, price ,veh_type)
	local source = source
	local user_id = vRP.getUserId({source})
	MySQL.query("vRP/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pvehicle, affected)
		if #pvehicle > 0 then
			vRPclient.notify(source,{"~w~You already have this vehicle."})
		else
			if vRP.tryFullPayment({user_id,price}) then
				vRP.getUserIdentity({user_id, function(identity)
					MySQL.query("vRP/add_custom_vehicle", {user_id = user_id, vehicle = vehicle, vehicle_plate = "P "..identity.registration, veh_type = veh_type})
				end})
				TriggerClientEvent('vrp:ChiudiMenu', player, vehicle, veh_type)
				vRPclient.notify(source,{"~w~You have paid ~g~"..price.."~w~$."})
			else
				vRPclient.notify(source,{"~w~You don't have enough money."})
			end
		end
	end)
end)

