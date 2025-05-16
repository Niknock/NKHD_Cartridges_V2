local Framework = nil
local FrameworkName = nil
local ESX, QBCore = nil, nil

local function DetectFramework()
    
    local esxSuccess = pcall(function() 
        if GetResourceState('es_extended') == 'started' then
            ESX = exports["es_extended"]:getSharedObject()
            return true
        end
        return false
    end)

RegisterServerEvent('checkTaserCartridgesCount')
AddEventHandler('checkTaserCartridgesCount', function()
    local src = source
    local availableCartridges = 0
    
    if not FrameworkName then
        TriggerClientEvent('updateTaserCartridgesCount', src, 0)
        return
    end
    
    if FrameworkName == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            local cartridgeItem = xPlayer.getInventoryItem(Config.ESXItemName)
            if cartridgeItem then
                availableCartridges = cartridgeItem.count
            end
        end
    elseif FrameworkName == 'QBCore' then
        local qbPlayer = QBCore.Functions.GetPlayer(src)
        if qbPlayer then
            local cartridgeItem = qbPlayer.Functions.GetItemByName(Config.QBCoreItemName)
            if cartridgeItem then
                availableCartridges = cartridgeItem.amount
            end
        end
    end
    
    TriggerClientEvent('updateTaserCartridgesCount', src, availableCartridges)
end)

    local qbSuccess = pcall(function()
        if GetResourceState('qb-core') == 'started' then
            QBCore = exports['qb-core']:GetCoreObject()
            return true
        end
        return false
    end)

    if esxSuccess and ESX then
        Framework = ESX
        FrameworkName = 'ESX'
        return true
    elseif qbSuccess and QBCore then
        Framework = QBCore
        FrameworkName = 'QBCore'
        return true
    end
    
    return false
end

if Config.Framework == 'auto' then
    if DetectFramework() then
        print('[NKHD Cartridges] Framework: ' .. FrameworkName)
    else
        print('[NKHD Cartridges] No Framework was Found!')
    end
elseif Config.Framework == 'ESX' then
    ESX = exports["es_extended"]:getSharedObject()
    Framework = ESX
    FrameworkName = 'ESX'
elseif Config.Framework == 'QBCore' then
    QBCore = exports['qb-core']:GetCoreObject()
    Framework = QBCore
    FrameworkName = 'QBCore'
else
    print('[NKHD Cartridges] No Framework was Found!')
end

RegisterServerEvent('checkTaserCartridges')
AddEventHandler('checkTaserCartridges', function()
    local src = source
    local hasCartridge = false

    if not FrameworkName then
        print('[NKHD Cartridges] No Framework was Found!')
        TriggerClientEvent('reloadTaser', src, false)
        return
    end

    if FrameworkName == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            local cartridgeItem = xPlayer.getInventoryItem(Config.ESXItemName)
            if cartridgeItem and cartridgeItem.count > 0 then
                xPlayer.removeInventoryItem(Config.ESXItemName, 1)
                hasCartridge = true
            end
        end
    elseif FrameworkName == 'QBCore' then
        local qbPlayer = QBCore.Functions.GetPlayer(src)
        if qbPlayer then
            local cartridgeItem = qbPlayer.Functions.GetItemByName(Config.QBCoreItemName)
            if cartridgeItem and cartridgeItem.amount > 0 then
                qbPlayer.Functions.RemoveItem(Config.QBCoreItemName, 1)
                hasCartridge = true
            end
        end
    end

    local availableCartridges = 0
    
    if FrameworkName == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            local cartridgeItem = xPlayer.getInventoryItem(Config.ESXItemName)
            if cartridgeItem then
                availableCartridges = cartridgeItem.count
            end
        end
    elseif FrameworkName == 'QBCore' then
        local qbPlayer = QBCore.Functions.GetPlayer(src)
        if qbPlayer then
            local cartridgeItem = qbPlayer.Functions.GetItemByName(Config.QBCoreItemName)
            if cartridgeItem then
                availableCartridges = cartridgeItem.amount
            end
        end
    end
    
    TriggerClientEvent('reloadTaser', src, hasCartridge, availableCartridges)
end)

