# 🍔 MoorFood - The Ultimate Eating System for FiveM

The most advanced and immersive eating and drinking system ever created for FiveM. MoorFood brings realistic food consumption with animations, effects, and a beautiful interface to your server.

---

## 🌟 Features

### 🍽️ **15+ Food & Drink Items**
- **Fast Food:** Burgers, Pizza, Hot Dogs
- **Healthy Options:** Salads, Apples, Bananas  
- **Gourmet Meals:** Grilled Steak, Pasta
- **Beverages:** Water, Soda, Coffee
- **Energy Drinks:** Speed boost effects

### 🎬 **Immersive Animations**
- Realistic eating/drinking animations
- 3D props (burgers, bottles, etc.)
- Smooth character movements
- Cancelable actions

### ⚡ **Advanced Effects**
- **Energy Boosts:** Vehicle speed multipliers
- **Health Restoration:** Different foods heal different amounts
- **Status Management:** Hunger & thirst tracking
- **Warning System:** Notifications when getting low

### 🎨 **Beautiful Interface**
- Modern chat-based menu system
- Organized by categories
- Real-time status information
- Clean, responsive design

### 🔧 **Developer Friendly**
- Standalone system (no framework dependencies)
- Export functions for other resources
- Easy to configure and extend
- Optimized performance

---

## 📋 Installation

1. **Copy the `moorfood` folder** to your `resources` directory
2. **Add to server.cfg:**
   ```
   ensure moorfood
   ```
3. **Restart your server** or `refresh` and `ensure moorfood`

---

## 🎮 Commands

### Basic Commands
```bash
/foodmenu          # Show all available food items
/eat [item]         # Eat food (default: burger)
/drink [item]       # Drink beverage (default: water)
/closefood          # Close menu (shows confirmation)
/foodstatus         # Check current hunger/thirst levels
```

### Examples
```bash
/eat burger         # Eat a classic burger
/eat pizza           # Eat pizza slice
/eat steak           # Eat grilled steak
/drink water         # Drink bottled water
/drink energydrink   # Energy drink with speed boost
/drink coffee        # Drink coffee
```

---

## 🍕 Food Items

### 🍔 Fast Food
- **burger** - Classic Burger (+25 Hunger, +5 Health)
- **pizza** - Pizza Slice (+35 Hunger, +8 Health)  
- **hotdog** - Hot Dog (+20 Hunger, +3 Health)

### 🥤 Drinks
- **water** - Bottled Water (+30 Thirst, +2 Health)
- **soda** - Soda Can (+25 Thirst, +1 Health)
- **coffee** - Coffee Cup (+20 Thirst, +5 Hunger, +3 Health)

### 🥗 Healthy
- **salad** - Fresh Salad (+15 Hunger, +10 Thirst, +10 Health)
- **apple** - Apple (+10 Hunger, +5 Thirst, +5 Health)
- **banana** - Banana (+12 Hunger, +8 Thirst, +6 Health)

### 🍽️ Gourmet
- **steak** - Grilled Steak (+40 Hunger, +15 Health)
- **pasta** - Pasta Dish (+35 Hunger, +12 Health)

### ⚡ Energy
- **energydrink** - Energy Drink (+20 Thirst, +Speed Boost)

---

## ⚙️ Configuration

Edit `config.lua` to customize the system:

```lua
-- Food & Drink Settings
Config.DefaultHunger = 100
Config.DefaultThirst = 100
Config.MaxHunger = 100
Config.MaxThirst = 100

-- Depletion Rates (per minute)
Config.HungerDepletionRate = 0.5
Config.ThirstDepletionRate = 0.8

-- Animation Settings
Config.EatAnimationTime = 5000
Config.DrinkAnimationTime = 3000
Config.UseProps = true

-- Notification Settings
Config.Notifications = {
    showProgress = true,
    showMessages = true,
    position = 'top-right'
}
```

---

## 🔌 Developer Exports

Use these exports in other resources:

```lua
-- Get current status
local hunger = exports['moorfood']:GetHunger()
local thirst = exports['moorfood']:GetThirst()

-- Set status values
exports['moorfood']:SetHunger(80)
exports['moorfood']:SetThirst(60)

-- Trigger eating/drinking
exports['moorfood']:Eat('burger')
exports['moorfood']:Drink('water')
```

---

## 🎯 Effects System

### Speed Boost
Energy drinks provide temporary vehicle speed boosts:
- **Duration:** 30 seconds
- **Multiplier:** 1.2x speed
- **Notification:** Visual feedback when activated/expired

### Health Effects
- **Starving:** -2 HP per minute when hunger = 0
- **Dehydrated:** -3 HP per minute when thirst = 0
- **Warning Messages:** Alerts at 25% hunger/thirst

---

## 🛠️ Customization

### Adding New Food Items

Edit `config.lua` and add to `Config.FoodItems`:

```lua
['youritem'] = {
    name = 'Your Item Name',
    hunger = 20,
    thirst = 10,
    health = 5,
    animation = 'eat_burger',
    prop = 'prop_cs_burger_01',
    prop_bone = 18905,
    category = 'fastfood',
    price = 100
}
```

### Custom Animations

Add new animations to `Config.Animations`:

```lua
['custom_eat'] = { 
    dict = 'mp_player_inteat@burger', 
    anim = 'mp_player_int_eat_burger' 
}
```

---

## 🐛 Troubleshooting

### Common Issues

**Commands not working:**
- Ensure `moorfood` is started: `ensure moorfood`
- Check for script errors in console
- Verify command spelling

**Menu not showing:**
- Check chat output for food list
- Ensure no other chat systems are interfering
- Try `/foodmenu` again

**Animations not playing:**
- Ensure `Config.UseProps = true` in config
- Check if player is in a state that blocks animations
- Verify animation dictionaries exist

**Performance issues:**
- Reduce depletion rates in config
- Disable props if not needed: `Config.UseProps = false`

---

## 📝 Version History

### **v1.0.0** - Initial Release
- ✅ 15+ food and drink items
- ✅ Immersive animations with props
- ✅ Energy boost effects
- ✅ Chat-based menu system
- ✅ Health and status management
- ✅ Developer exports
- ✅ Standalone (no framework dependencies)

---

## 🤝 Support

Created with ❤️ for the FiveM community.

**Need help?** Check the troubleshooting section or review the configuration options.

---

## 📄 License

This project is open source and available for use in any FiveM server.

---

**MoorFood** - Because your players deserve the best dining experience! 🍔✨
