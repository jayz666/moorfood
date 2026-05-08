Config = {}

-- MoorFood Configuration
Config.Debug = false

-- Food & Drink Settings
Config.DefaultHunger = 100
Config.DefaultThirst = 100
Config.MaxHunger = 100
Config.MaxThirst = 100

-- Depletion Rates (per minute)
Config.HungerDepletionRate = 0.5
Config.ThirstDepletionRate = 0.8

-- Health Effects
Config.HungerDamage = 2
Config.ThirstDamage = 3
Config.WarningThreshold = 25

-- Animation Settings
Config.EatAnimationTime = 5000
Config.DrinkAnimationTime = 3000
Config.UseProps = true

-- Food Items
Config.FoodItems = {
    -- Fast Food
    ['burger'] = {
        name = 'Classic Burger',
        hunger = 25,
        thirst = -5,
        health = 5,
        animation = 'eat_burger',
        prop = 'prop_cs_burger_01',
        prop_bone = 18905,
        category = 'fastfood',
        price = 150
    },
    ['pizza'] = {
        name = 'Pizza Slice',
        hunger = 35,
        thirst = -10,
        health = 8,
        animation = 'eat_pizza',
        prop = 'prop_pizza_01',
        prop_bone = 18905,
        category = 'fastfood',
        price = 200
    },
    ['hotdog'] = {
        name = 'Hot Dog',
        hunger = 20,
        thirst = -5,
        health = 3,
        animation = 'eat_hotdog',
        prop = 'prop_cs_hotdog_01',
        prop_bone = 18905,
        category = 'fastfood',
        price = 100
    },
    
    -- Drinks
    ['water'] = {
        name = 'Bottled Water',
        hunger = 0,
        thirst = 30,
        health = 2,
        animation = 'drink_bottle',
        prop = 'prop_ld_bottle_01',
        prop_bone = 28422,
        category = 'drinks',
        price = 50
    },
    ['soda'] = {
        name = 'Soda Can',
        hunger = -5,
        thirst = 25,
        health = 1,
        animation = 'drink_can',
        prop = 'prop_ecola_can',
        prop_bone = 28422,
        category = 'drinks',
        price = 75
    },
    ['coffee'] = {
        name = 'Coffee Cup',
        hunger = 5,
        thirst = 20,
        health = 3,
        animation = 'drink_coffee',
        prop = 'prop_fib_coffee',
        prop_bone = 28422,
        category = 'drinks',
        price = 80
    },
    
    -- Healthy Options
    ['salad'] = {
        name = 'Fresh Salad',
        hunger = 15,
        thirst = 10,
        health = 10,
        animation = 'eat_salad',
        prop = 'prop_plate_food_01',
        prop_bone = 18905,
        category = 'healthy',
        price = 120
    },
    ['apple'] = {
        name = 'Apple',
        hunger = 10,
        thirst = 5,
        health = 5,
        animation = 'eat_fruit',
        prop = 'prop_apple_01',
        prop_bone = 18905,
        category = 'healthy',
        price = 40
    },
    ['banana'] = {
        name = 'Banana',
        hunger = 12,
        thirst = 8,
        health = 6,
        animation = 'eat_fruit',
        prop = 'prop_banana',
        prop_bone = 18905,
        category = 'healthy',
        price = 35
    },
    
    -- Gourmet
    ['steak'] = {
        name = 'Grilled Steak',
        hunger = 40,
        thirst = -15,
        health = 15,
        animation = 'eat_steak',
        prop = 'prop_cs_steak',
        prop_bone = 18905,
        category = 'gourmet',
        price = 350
    },
    ['pasta'] = {
        name = 'Pasta Dish',
        hunger = 35,
        thirst = -5,
        health = 12,
        animation = 'eat_pasta',
        prop = 'prop_plate_food_01',
        prop_bone = 18905,
        category = 'gourmet',
        price = 280
    },
    
    -- Snacks
    ['chips'] = {
        name = 'Potato Chips',
        hunger = 8,
        thirst = -3,
        health = 1,
        animation = 'eat_chips',
        prop = 'v_ret_ml_chips2',
        prop_bone = 18905,
        category = 'snacks',
        price = 30
    },
    ['candy'] = {
        name = 'Candy Bar',
        hunger = 5,
        thirst = -2,
        health = 2,
        animation = 'eat_candy',
        prop = 'prop_choc_ego',
        prop_bone = 18905,
        category = 'snacks',
        price = 25
    },
    
    -- Energy
    ['energydrink'] = {
        name = 'Energy Drink',
        hunger = -10,
        thirst = 20,
        health = 0,
        animation = 'drink_can',
        prop = 'prop_energy_drink',
        prop_bone = 28422,
        category = 'energy',
        price = 90,
        effects = {
            speed_boost = 1.2,
            duration = 30000
        }
    }
}

-- Animations Dictionary
Config.Animations = {
    ['eat_burger'] = { dict = 'mp_player_inteat@burger', anim = 'mp_player_int_eat_burger' },
    ['eat_pizza'] = { dict = 'mp_player_inteat@pizza', anim = 'mp_player_int_eat_pizza' },
    ['eat_hotdog'] = { dict = 'mp_player_inteat@hotdog', anim = 'mp_player_int_eat_hotdog' },
    ['drink_bottle'] = { dict = 'amb@world_human_drinking@coffee@male@idle_a', anim = 'idle_c' },
    ['drink_can'] = { dict = 'amb@world_human_drinking@coffee@male@idle_a', anim = 'idle_c' },
    ['drink_coffee'] = { dict = 'amb@world_human_drinking@coffee@male@idle_a', anim = 'idle_c' },
    ['eat_salad'] = { dict = 'mp_player_inteat@burger', anim = 'mp_player_int_eat_burger_fp' },
    ['eat_fruit'] = { dict = 'mp_player_inteat@burger', anim = 'mp_player_int_eat_burger' },
    ['eat_steak'] = { dict = 'amb@world_human_aa_smoke@male@idle_a', anim = 'idle_c' },
    ['eat_pasta'] = { dict = 'mp_player_inteat@burger', anim = 'mp_player_int_eat_burger' },
    ['eat_chips'] = { dict = 'amb@world_human_drinking@coffee@male@idle_a', anim = 'idle_c' },
    ['eat_candy'] = { dict = 'mp_player_inteat@burger', anim = 'mp_player_int_eat_burger' }
}

-- Effects
Config.Effects = {
    ['speed_boost'] = {
        duration = 30000,
        multiplier = 1.2
    }
}

-- Notification Settings
Config.Notifications = {
    showProgress = true,
    showMessages = true,
    position = 'top-right'
}
