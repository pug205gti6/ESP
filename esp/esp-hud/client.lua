local QBCore = exports['qb-core']:GetCoreObject()
local ESPEnabled = true -- Default ESP state

-- Function to send the TCS status to the NUI HUD
function UpdateESPHUD(enabled)
    SendNUIMessage({
        action = 'updateESPStatus',
        display = IsPedInAnyVehicle(PlayerPedId(), false), -- Only display when in a vehicle
        espStatus = enabled -- Current status of ESP
    })
end

-- Command to toggle ESP
RegisterCommand('toggletraction', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle and GetPedInVehicleSeat(vehicle, -1) == playerPed then
        espEnabled = not espEnabled -- Toggle the state
        UpdateESPHUD(espEnabled) -- Update HUD
        QBCore.Functions.Notify("Traction Control " .. (espEnabled and "Enabled" or "Disabled"), "primary")
    else
        QBCore.Functions.Notify("You must be in a vehicle to toggle traction control.", "error")
    end
end, false)

CreateThread(function()
    while true do
        Wait(500) -- Update every 0.5 seconds to reduce computation
        local display = IsPedInAnyVehicle(PlayerPedId(), false)
        UpdateESPHUD(display and espEnabled)
    end
end)

