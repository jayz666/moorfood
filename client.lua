-- MoorFood - Standalone eating system
local isEating = false
local isDrinking = false
local currentProp = nil
local hunger = 100
local thirst = 100
local healthEffects = {}

-- Initialize
hunger = Config.DefaultHunger
thirst = Config.DefaultThirst

-- Eating/Drinking Functions
local function LoadAnimation(dict, anim)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

local function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
end

local function AttachPropToPlayer(prop, bone, offsetX, offsetY, offsetZ, rotX, rotY, rotZ)
    local ped = PlayerPedId()
    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, bone), offsetX, offsetY, offsetZ, rotX, rotY, rotZ, true, true, false, true, 1, true)
end

local function FinishEating(item)
    local foodItem = Config.FoodItems[item]
    if not foodItem then return end
    
    -- Update stats
    hunger = math.min(Config.MaxHunger, hunger + foodItem.hunger)
    thirst = math.max(0, thirst + foodItem.thirst)
    
    local ped = PlayerPedId()
    local currentHealth = GetEntityHealth(ped)
    SetEntityHealth(ped, math.min(200, currentHealth + foodItem.health))
    
    -- Apply effects
    if foodItem.effects then
        for effectName, effectData in pairs(foodItem.effects) do
            if effectName == 'speed_boost' then
                healthEffects.speed_boost = GetGameTimer() + effectData.duration
                TriggerEvent('chat:addMessage', {
                    color = { 0, 255, 0 },
                    multiline = false,
                    args = { 'MoorFood', '^2Energy boost activated!^7' }
                })
            end
        end
    end
    
    -- Clean up
    ClearPedTasks(PlayerPedId())
    if currentProp then
        DeleteEntity(currentProp)
        currentProp = nil
    end
    
    isEating = false
    
    -- Notification
    if Config.Notifications.showMessages then
        TriggerEvent('chat:addMessage', {
                    color = { 0, 255, 0 },
                    multiline = false,
                    args = { 'MoorFood', '^2You ate ' .. foodItem.name .. '!^7' }
                })
    end
    
    -- Server status update removed to avoid conflicts
end

local function FinishDrinking(item)
    local foodItem = Config.FoodItems[item]
    if not foodItem then return end
    
    -- Update stats
    hunger = math.max(0, hunger + foodItem.hunger)
    thirst = math.min(Config.MaxThirst, thirst + foodItem.thirst)
    
    local ped = PlayerPedId()
    local currentHealth = GetEntityHealth(ped)
    SetEntityHealth(ped, math.min(200, currentHealth + foodItem.health))
    
    -- Apply effects
    if foodItem.effects then
        for effectName, effectData in pairs(foodItem.effects) do
            if effectName == 'speed_boost' then
                healthEffects.speed_boost = GetGameTimer() + effectData.duration
                TriggerEvent('chat:addMessage', {
                    color = { 0, 255, 0 },
                    multiline = false,
                    args = { 'MoorFood', '^2Energy boost activated!^7' }
                })
            end
        end
    end
    
    -- Clean up
    ClearPedTasks(PlayerPedId())
    if currentProp then
        DeleteEntity(currentProp)
        currentProp = nil
    end
    
    isDrinking = false
    
    -- Notification
    if Config.Notifications.showMessages then
        TriggerEvent('chat:addMessage', {
                    color = { 0, 255, 0 },
                    multiline = false,
                    args = { 'MoorFood', '^2You drank ' .. foodItem.name .. '!^7' }
                })
    end
    
    -- Server status update removed to avoid conflicts
end

local function CancelEating()
    ClearPedTasks(PlayerPedId())
    if currentProp then
        DeleteEntity(currentProp)
        currentProp = nil
    end
    isEating = false
    TriggerEvent('chat:addMessage', {
        color = { 255, 255, 255 },
        multiline = false,
        args = { 'MoorFood', '^3Eating cancelled^7' }
    })
end

local function CancelDrinking()
    ClearPedTasks(PlayerPedId())
    if currentProp then
        DeleteEntity(currentProp)
        currentProp = nil
    end
    isDrinking = false
    TriggerEvent('chat:addMessage', {
        color = { 255, 255, 255 },
        multiline = false,
        args = { 'MoorFood', '^3Drinking cancelled^7' }
    })
end

local function OpenFoodMenu()
    -- Simple chat-based menu to avoid NUI crashes
    local foodList = {}
    
    -- Categorize items
    local categories = {
        fastfood = "🍔 Fast Food",
        drinks = "🥤 Drinks", 
        healthy = "🥗 Healthy",
        gourmet = "🍽️ Gourmet",
        energy = "⚡ Energy"
    }
    
    for category, categoryName in pairs(categories) do
        table.insert(foodList, "\n^3" .. categoryName .. "^7")
        for itemId, itemData in pairs(Config.FoodItems) do
            if itemData.category == category then
                table.insert(foodList, string.format("  • %s - %s (H:%d T:%d HP:%d $%d)", 
                    itemId, itemData.name, itemData.hunger, itemData.thirst, itemData.health, itemData.price))
            end
        end
    end
    
    TriggerEvent('chat:addMessage', {
        color = { 255, 255, 255 },
        multiline = true,
        args = { '🍔 MoorFood Menu', "^7Available items:" .. table.concat(foodList, '\n') .. "\n\n^3Usage: /eat [item] or /drink [item]^7" }
    })
end

local function CloseFoodMenu()
    TriggerEvent('chat:addMessage', {
        color = { 255, 255, 255 },
        multiline = false,
        args = { 'MoorFood', '^3Menu closed^7' }
    })
end

-- Status Management
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- Check every minute
        
        local ped = PlayerPedId()
        if not IsEntityDead(ped) then
            -- Deplete hunger and thirst
            hunger = math.max(0, hunger - Config.HungerDepletionRate)
            thirst = math.max(0, thirst - Config.ThirstDepletionRate)
            
            -- Health effects
            if hunger <= 0 then
                SetEntityHealth(ped, GetEntityHealth(ped) - Config.HungerDamage)
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0 },
                    multiline = false,
                    args = { 'MoorFood', '^1You are starving!^7' }
                })
            end
            
            if thirst <= 0 then
                SetEntityHealth(ped, GetEntityHealth(ped) - Config.ThirstDamage)
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0 },
                    multiline = false,
                    args = { 'MoorFood', '^1You are severely dehydrated!^7' }
                })
            end
            
            -- Warning messages
            if hunger < Config.WarningThreshold and hunger > 0 then
                TriggerEvent('chat:addMessage', {
                    color = { 255, 165, 0 },
                    multiline = false,
                    args = { 'MoorFood', '^3You are getting hungry^7' }
                })
            end
            
            if thirst < Config.WarningThreshold and thirst > 0 then
                TriggerEvent('chat:addMessage', {
                    color = { 255, 165, 0 },
                    multiline = false,
                    args = { 'MoorFood', '^3You are getting thirsty^7' }
                })
            end
            
            -- Server update removed to avoid conflicts
        end
    end
end)

-- Start Eating Function
local function StartEating(item, animationTime)
    if isEating or isDrinking then
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0 },
            multiline = false,
            args = { 'MoorFood', '^1You are already eating or drinking!^7' }
        })
        return false
    end
    
    local foodItem = Config.FoodItems[item]
    if not foodItem then
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0 },
            multiline = false,
            args = { 'MoorFood', '^1Invalid food item!^7' }
        })
        return false
    end
    
    isEating = true
    
    -- Load animation
    local animData = Config.Animations[foodItem.animation]
    if animData then
        LoadAnimation(animData.dict, animData.anim)
        TaskPlayAnim(PlayerPedId(), animData.dict, animData.anim, 8.0, -8.0, animationTime / 1000, 49, 0, false, false, false)
    end
    
    -- Create and attach prop
    if Config.UseProps and foodItem.prop then
        LoadModel(foodItem.prop)
        currentProp = CreateObject(foodItem.prop, 0.0, 0.0, 0.0, true, true, true)
        AttachPropToPlayer(currentProp, foodItem.prop_bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    end
    
    -- Simple progress notification
    TriggerEvent('chat:addMessage', {
        color = { 255, 255, 255 },
        multiline = false,
        args = { 'MoorFood', '^3Eating ' .. foodItem.name .. '...^7' }
    })
    
    Wait(animationTime)
    FinishEating(item)
    
    return true
end

-- Start Drinking Function
local function StartDrinking(item, animationTime)
    if isEating or isDrinking then
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0 },
            multiline = false,
            args = { 'MoorFood', '^1You are already eating or drinking!^7' }
        })
        return false
    end
    
    local foodItem = Config.FoodItems[item]
    if not foodItem then
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0 },
            multiline = false,
            args = { 'MoorFood', '^1Invalid drink item!^7' }
        })
        return false
    end
    
    isDrinking = true
    
    -- Load animation
    local animData = Config.Animations[foodItem.animation]
    if animData then
        LoadAnimation(animData.dict, animData.anim)
        TaskPlayAnim(PlayerPedId(), animData.dict, animData.anim, 8.0, -8.0, animationTime / 1000, 49, 0, false, false, false)
    end
    
    -- Create and attach prop
    if Config.UseProps and foodItem.prop then
        LoadModel(foodItem.prop)
        currentProp = CreateObject(foodItem.prop, 0.0, 0.0, 0.0, true, true, true)
        AttachPropToPlayer(currentProp, foodItem.prop_bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    end
    
    -- Simple progress notification
    TriggerEvent('chat:addMessage', {
        color = { 255, 255, 255 },
        multiline = false,
        args = { 'MoorFood', '^3Drinking ' .. foodItem.name .. '...^7' }
    })
    
    Wait(animationTime)
    FinishDrinking(item)
    
    return true
end

-- ESC Key Handler to close menu
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 177) then -- ESC key
            CloseFoodMenu()
        end
    end
end)

-- Speed Boost Effect
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        
        local ped = PlayerPedId()
        if healthEffects.speed_boost and GetGameTimer() < healthEffects.speed_boost then
            if IsPedInAnyVehicle(ped, false) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                SetVehicleEnginePowerMultiplier(vehicle, 1.2)
            end
        elseif healthEffects.speed_boost and GetGameTimer() >= healthEffects.speed_boost then
            healthEffects.speed_boost = nil
            if IsPedInAnyVehicle(ped, false) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                SetVehicleEnginePowerMultiplier(vehicle, 1.0)
            end
            TriggerEvent('chat:addMessage', {
            color = { 255, 255, 255 },
            multiline = false,
            args = { 'MoorFood', '^3Energy boost wore off^7' }
        })
        end
    end
end)

-- Commands
RegisterCommand('eat', function(source, args)
    local item = args[1] or 'burger'
    StartEating(item, Config.EatAnimationTime)
end, false)

RegisterCommand('drink', function(source, args)
    local item = args[1] or 'water'
    StartDrinking(item, Config.DrinkAnimationTime)
end, false)

RegisterCommand('foodmenu', function()
    OpenFoodMenu()
end, false)

RegisterCommand('closefood', function()
    CloseFoodMenu()
end, false)

-- Exports for other resources
exports('GetHunger', function() return hunger end)
exports('GetThirst', function() return thirst end)
exports('SetHunger', function(value) hunger = math.min(Config.MaxHunger, math.max(0, value)) end)
exports('SetThirst', function(value) thirst = math.min(Config.MaxThirst, math.max(0, value)) end)
exports('Eat', function(item) return StartEating(item, Config.EatAnimationTime) end)
exports('Drink', function(item) return StartDrinking(item, Config.DrinkAnimationTime) end)

-- NUI Callbacks
RegisterNUICallback('closeMenu', function(data, cb)
    CloseFoodMenu()
    cb('ok')
end)

RegisterNUICallback('eatItem', function(data, cb)
    CloseFoodMenu()
    StartEating(data.item, Config.EatAnimationTime)
    cb('ok')
end)

RegisterNUICallback('drinkItem', function(data, cb)
    CloseFoodMenu()
    StartDrinking(data.item, Config.DrinkAnimationTime)
    cb('ok')
end)

-- Status Update from Server
RegisterNetEvent('moorfood:client:UpdateStatus')
AddEventHandler('moorfood:client:UpdateStatus', function(newHunger, newThirst)
    hunger = newHunger
    thirst = newThirst
end)
