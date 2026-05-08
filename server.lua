-- MoorFood - Standalone eating system

-- Player Status Storage
local playerStatus = {}

-- Initialize Player
AddEventHandler('playerConnecting', function()
    local source = source
    playerStatus[source] = {
        hunger = Config.DefaultHunger,
        thirst = Config.DefaultThirst,
        lastUpdate = GetGameTimer()
    }
end)

-- Clean up on disconnect
AddEventHandler('playerDropped', function()
    local source = source
    playerStatus[source] = nil
end)

-- Update Player Status
RegisterNetEvent('moorfood:server:UpdateStatus')
AddEventHandler('moorfood:server:UpdateStatus', function(hunger, thirst)
    local source = source
    if playerStatus[source] then
        playerStatus[source].hunger = hunger
        playerStatus[source].thirst = thirst
        playerStatus[source].lastUpdate = GetGameTimer()
        
        -- Save to database (if needed)
        -- This would integrate with your framework's data system
    end
end)

-- Initialize Player Status
RegisterNetEvent('moorfood:server:InitializePlayer')
AddEventHandler('moorfood:server:InitializePlayer', function()
    local source = source
    if not playerStatus[source] then
        playerStatus[source] = {
            hunger = Config.DefaultHunger,
            thirst = Config.DefaultThirst,
            lastUpdate = GetGameTimer()
        }
    end
end)

-- Get Player Status
exports('GetPlayerStatus', function(source)
    return playerStatus[source] or { hunger = Config.DefaultHunger, thirst = Config.DefaultThirst }
end)

-- Set Player Status
exports('SetPlayerStatus', function(source, hunger, thirst)
    if playerStatus[source] then
        playerStatus[source].hunger = hunger or playerStatus[source].hunger
        playerStatus[source].thirst = thirst or playerStatus[source].thirst
        TriggerClientEvent('moorfood:client:UpdateStatus', source, playerStatus[source].hunger, playerStatus[source].thirst)
    end
end)

-- Food Item Management
exports('GetFoodItem', function(itemName)
    return Config.FoodItems[itemName]
end)

exports('GetAllFoodItems', function()
    return Config.FoodItems
end)

exports('GetFoodByCategory', function(category)
    local items = {}
    for itemId, itemData in pairs(Config.FoodItems) do
        if itemData.category == category then
            items[itemId] = itemData
        end
    end
    return items
end)

-- Admin Commands
RegisterCommand('sethunger', function(source, args, rawCommand)
    if source == 0 then -- Console only
        local targetId = tonumber(args[1])
        local amount = tonumber(args[2])
        
        if targetId and amount then
            if playerStatus[targetId] then
                playerStatus[targetId].hunger = math.min(Config.MaxHunger, math.max(0, amount))
                TriggerClientEvent('moorfood:client:UpdateStatus', targetId, playerStatus[targetId].hunger, playerStatus[targetId].thirst)
                
                local message = string.format('Set hunger for player %d to %d', targetId, amount)
                if source == 0 then
                    print(message)
                else
                    print('[MoorFood] ' .. message)
                end
            else
                local errorMsg = 'Player not found'
                if source == 0 then
                    print(errorMsg)
                else
                    print('[MoorFood] ' .. errorMsg)
                end
            end
        else
            local usage = 'Usage: /sethunger [playerId] [amount]'
            if source == 0 then
                print(usage)
            else
                print('[MoorFood] ' .. usage)
            end
        end
    end
end, false)

RegisterCommand('setthirst', function(source, args, rawCommand)
    if source == 0 then -- Console only
        local targetId = tonumber(args[1])
        local amount = tonumber(args[2])
        
        if targetId and amount then
            if playerStatus[targetId] then
                playerStatus[targetId].thirst = math.min(Config.MaxThirst, math.max(0, amount))
                TriggerClientEvent('moorfood:client:UpdateStatus', targetId, playerStatus[targetId].hunger, playerStatus[targetId].thirst)
                
                local message = string.format('Set thirst for player %d to %d', targetId, amount)
                if source == 0 then
                    print(message)
                else
                    print('[MoorFood] ' .. message)
                end
            else
                local errorMsg = 'Player not found'
                if source == 0 then
                    print(errorMsg)
                else
                    print('[MoorFood] ' .. errorMsg)
                end
            end
        else
            local usage = 'Usage: /setthirst [playerId] [amount]'
            if source == 0 then
                print(usage)
            else
                print('[MoorFood] ' .. usage)
            end
        end
    end
end, false)

RegisterCommand('foodstatus', function(source, args, rawCommand)
    local targetId = tonumber(args[1]) or source
    
    if playerStatus[targetId] then
        local status = playerStatus[targetId]
        local message = string.format('Player %d - Hunger: %d%%, Thirst: %d%%', 
            targetId, math.floor(status.hunger), math.floor(status.thirst))
        
        if source == 0 then
            print(message)
        else
            print('[MoorFood] ' .. message)
        end
    else
        local errorMsg = 'Player not found'
        if source == 0 then
            print(errorMsg)
        else
            print('[MoorFood] ' .. errorMsg)
        end
    end
end, false)

-- Status Sync (for other resources)
exports('SyncStatusToHUD', function(source)
    if playerStatus[source] then
        -- This would sync with premium_hud or other HUD systems
        local statusData = {
            hunger = playerStatus[source].hunger,
            thirst = playerStatus[source].thirst
        }
        
        -- Trigger HUD update events
        TriggerClientEvent('esx_status:load', source, statusData)
        
        return statusData
    end
    return nil
end)

-- Periodic Status Save (optional)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000) -- Save every 5 minutes
        
        for source, status in pairs(playerStatus) do
            -- Save player status to database
            -- This would integrate with your framework's data persistence
            if Config.Debug then
                print(string.format('Saving status for player %d: H:%d T:%d', 
                    source, math.floor(status.hunger), math.floor(status.thirst)))
            end
        end
    end
end)
