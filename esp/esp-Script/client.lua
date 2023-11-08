-- client.lua
local QBCore = exports['qb-core']:GetCoreObject()

-- Function to set the traction control to enabled
local function SetTractionControlEnabled(vehicle)
    -- Set traction control properties for enabled state
    SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMax', 2.0) -- Default grip level
    SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDriveInertia', 1.0) -- Default weight distribution
    SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSteeringLock', 35.0) -- Default wheel angle
    QBCore.Functions.Notify("Traction Control Enabled", "primary")
end

-- Function to toggle traction control
local function ToggleTractionControl(vehicle, enable)
    if enable then
        -- Enable traction control
        SetTractionControlEnabled(vehicle)
    else
        -- Disable traction control and modify vehicle handling for disabled state
        SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMax', 0.5) -- Reduced grip level
        SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDriveInertia', 0.5) -- Simulate less weight at the back
        SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSteeringLock', 50.0) -- Increased wheel angle
        QBCore.Functions.Notify("Traction Control Disabled", "primary")
    end
end

-- Command to toggle traction control
RegisterCommand('toggletraction', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1) == ped then
        local vehicle = GetVehiclePedIsIn(ped, false)
        local tractionControlEnabled = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMax') > 1.0
        ToggleTractionControl(vehicle, not tractionControlEnabled)
    else
        QBCore.Functions.Notify("You must be in a vehicle and be the driver to toggle traction control.", "error")
    end
end, false)

-- Event when a player enters a vehicle
RegisterNetEvent('baseevents:enteredVehicle')
AddEventHandler('baseevents:enteredVehicle', function(vehicle, seat, vehicleDisplayName)
    if seat == -1 then -- Check if the player is the driver
        SetTractionControlEnabled(vehicle)
    end
end)

-- Binding the command to the 'G' key
RegisterKeyMapping('toggletraction', 'Toggle Traction Control', 'keyboard', 'g')

-- Inside your client.lua, add a function to send the ESP status to the HUD
function UpdateTCSHUD(enabled)
    SendNUIMessage({
        action = 'updateTCSStatus',
        tcsStatus = enabled
    })
end
-- Call this function whenever the ESP is toggled
UpdateTCSHUD(true);  -- To turn on the ESP
UpdateTCSHUD(false); -- To turn off the ESP

