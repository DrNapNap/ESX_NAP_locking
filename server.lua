local vehicleOwners = {}

RegisterServerEvent("NAPCOPEN_Locking:GiveKeys")
AddEventHandler("NAPCOPEN_Locking:GiveKeys", function(vehNet, plate)
    local cid = source
    local plate = string.upper(plate)
    table.insert(vehicleOwners, {owner = cid, netid = vehNet, plate = plate})
end)

RegisterServerEvent("NAPCOPEN_Locking:TjekEjerskab")
AddEventHandler("NAPCOPEN_Locking:TjekEjerskab", function(vehNet, plate)
    local cid = source
    local plate = string.upper(plate)
    for i = 1, #vehicleOwners do
        if vehicleOwners[i].netid == vehNet then
            if vehicleOwners[i].owner == cid then
                if vehicleOwners[i].plate == plate then
                    TriggerClientEvent("NAPCOPEN_Locking:ToggleOutsideLock", cid, vehNet, true)
                end
            end
        end
    end
    TriggerClientEvent("NAPCOPEN_Locking:ToggleOutsideLock", cid, vehNet, false)
end)

RegisterServerEvent("NAPCOPEN:GiveKeys")
AddEventHandler("NAPCOPEN:GiveKeys", function(player, vehNet, plate)
    local cid = source
    local plate = string.upper(plate)

    for i = 1, #vehicleOwners do
        if vehicleOwners[i].netid == vehNet then
            if vehicleOwners[i].owner == cid then
                if vehicleOwners[i].plate == plate then
                    for i = 1, #vehicleOwners do
                        if vehicleOwners[i].owner == cid then
                            table.remove(vehicleOwners, i)
                            break
                        end
                    end

                    table.insert(vehicleOwners, {owner = player, netid = vehNet, plate = plate})
                    TriggerClientEvent("NAP:ESX_Notification", cid, "You have given your vehicle keys of vehicle plate - " .. string.upper(plate) .. " to the nearest player")
                    TriggerClientEvent("NAP:ESX_Notification", player, "You have recieved the keys of the vehicle plate - " .. string.upper(plate) .. " from the nearest player")
                end
            else
                TriggerClientEvent("NAP:ESX_Notification", cid, "~r~Du har ikke nøglerne til dette køretøj!")
            end
        end
    end
end)