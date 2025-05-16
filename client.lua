local cartridges = Config.MaxCartridges
local cartridgesin = true
local NoCartgridgesMessage = false
local SpamCooldownPressed = false
local isTaserEquipped = false
local playerPed = nil
local availableCartridges = 0
local displayUI = false

local TASER_HASH = GetHashKey('WEAPON_STUNGUN')

function ShowNotification(text)
    if Config.EnableUI == false then
        SetNotificationTextEntry("STRING")
        AddTextComponentString(text)
        DrawNotification(false, false)
    end
end

function UpdateTaserUI()
    SendNUIMessage({
        type = 'updateTaserUI',
        currentCartridges = cartridges,
        maxCartridges = Config.MaxCartridges,
        availableCartridges = availableCartridges
    })
    displayUI = true
end

function HideTaserUI()
    if displayUI then
        SendNUIMessage({
            type = 'hideTaserUI'
        })
        displayUI = false
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.UIRefreshRate)
        
        if Config.EnableUI and isTaserEquipped then
            UpdateTaserUI()
        elseif displayUI then
            HideTaserUI()
        end
    end
end)

RegisterNetEvent('spam')
AddEventHandler('spam', function()
    Citizen.SetTimeout(Config.SpamCooldown, function()
        SpamCooldownPressed = false
        if Config.Debug then
            print('Spam Protection Deactivated')
        end
    end)
end)

RegisterNetEvent('updateTaserCartridgesCount')
AddEventHandler('updateTaserCartridgesCount', function(cartridgesCount)
    availableCartridges = cartridgesCount

    if Config.EnableUI and isTaserEquipped then
        UpdateTaserUI()
    end
end)

RegisterNetEvent('reloadTaser')
AddEventHandler('reloadTaser', function(hasCartridge, cartridgesAvailable)
    if hasCartridge then
        cartridgesin = true
        cartridges = Config.MaxCartridges
        ShowNotification('~g~Taser Reloaded')
        NoCartgridgesMessage = false
    else
        ShowNotification('~r~There are no Cartridges left.')
    end

    if cartridgesAvailable ~= nil then
        availableCartridges = cartridgesAvailable
    end

    if Config.EnableUI and isTaserEquipped then
        UpdateTaserUI()
    end
    
    TriggerEvent('spam')
end)

Citizen.CreateThread(function()
    while true do
        playerPed = PlayerPedId() 
        local currentWeapon = GetSelectedPedWeapon(playerPed)
        local wasTaserEquipped = isTaserEquipped
     
        isTaserEquipped = (currentWeapon == TASER_HASH)

        if isTaserEquipped and not wasTaserEquipped then
            TriggerServerEvent('checkTaserCartridgesCount')
        end

        if isTaserEquipped then
            if cartridges <= 0 then
                DisableControlAction(0, 24, true)   
                DisableControlAction(0, 257, true)     
                DisableControlAction(0, 142, true)    
                SetPedInfiniteAmmo(playerPed, false, TASER_HASH)

                if not NoCartgridgesMessage then
                    cartridgesin = false
                    NoCartgridgesMessage = true
                    ShowNotification('~r~Out of cartridges! Press R to reload.')
                end
            end

            if not cartridgesin and IsControlJustReleased(0, Config.ReloadKey) and not SpamCooldownPressed then
                SpamCooldownPressed = true
                if Config.Debug then
                    print('Debug Pressed R')
                end
                TriggerServerEvent('checkTaserCartridges')
            end

            if IsPedShooting(playerPed) and cartridges > 0 then
                cartridges = cartridges - 1

                if Config.EnableUI then
                    UpdateTaserUI()
                end
                
                if cartridges <= 0 and not NoCartgridgesMessage then
                    cartridgesin = false
                    NoCartgridgesMessage = true
                    ShowNotification('~r~Out of cartridges! Press R to reload.')
                end
            end
            
            Citizen.Wait(0) 
        else

            if wasTaserEquipped then
            end
            
            Citizen.Wait(500) 
        end
    end
end)