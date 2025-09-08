-- client.lua
local pedModel = `cs_bankman`
local pedCoords = vector3(-540.10, -218.94, 37.65)
local pedHeading = 3

-- Spawn ped
CreateThread(function()
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do Wait(0) end

    local ped = CreatePed(0, pedModel, pedCoords.x, pedCoords.y, pedCoords.z - 1, pedHeading, false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)

    -- ox_target interaction
    exports.ox_target:addLocalEntity(ped, {
        {
            name = 'city_info',
            icon = 'fa-solid fa-circle-info',
            label = 'City Guide',
            onSelect = function()
                SetNuiFocus(true, true)
                SendNUIMessage({ action = "open" })
            end
        }
    })
end)

-- NUI callbacks
RegisterNUICallback("close", function(_, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("selectOption", function(data, cb)
    local option = data.option
    local header, content = "", ""

    if option == "jobs" then
        header = "Jobs in Storm Systems"
        content = [[
- Legal jobs: Police, EMS, Mechanic, Transit, Window Cleaning, Trucking, Mining, Fishing
- Illegal jobs: Drugs, Robberies, Boosting, Heists
]]
    elseif option == "services" then
        header = "Emergency Services"
        content = [[
- Melbourne Police: Protect & enforce law
- Ambulance Melbourne: Save lives
- Both are fully player-run, apply in the city!
]]
    elseif option == "business" then
        header = "Businesses"
        content = [[
- Mechanic shops, Dealerships, Gas Stations
- Run by players, jobs always hiring
- You can start your own business too!
]]
    elseif option == "activities" then
        header = "Things to Do"
        content = [[
- Car Meets, Street Racing, Hunting
- Diving & Treasure Hunts
- Social Clubs, Gangs, Events & more
]]
    elseif option == "starter" then
        -- Starter pack logic
        local hasClaimed = lib.callback.await('starterpack:check', false)
        if hasClaimed then
            lib.notify({title = "Starter Pack", description = "You have already claimed your starter pack!", type = "error"})
        else
            TriggerServerEvent('starterpack:claim')
        end
        cb("ok")
        return
    end

    -- Send content to NUI
    SendNUIMessage({
        action = "showContent",
        header = header,
        content = content
    })
    cb("ok")
end)

-- Create blip
local blip = AddBlipForCoord(pedCoords.x, pedCoords.y, pedCoords.z)
SetBlipSprite(blip, 280)
SetBlipDisplay(blip, 4)
SetBlipScale(blip, 1.0)
SetBlipColour(blip, 2)
SetBlipAsShortRange(blip, true)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString("City Guide")
EndTextCommandSetBlipName(blip)
