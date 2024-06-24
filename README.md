modified version of eclipse.wtf's esp, which fixes a lot of stuff and adds a couple of features (such as: unloading, enabling/disabling (why wasn't this a feature in the first place??)).

original: https://github.com/krampus-organization/releases/blob/main/ESP.lua

v3rm thread about it: https://v3rm.net/threads/release-eclipse-wtf-silentware-esp-library.9221/

loadstring
-
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/A1thernex/random/main/modified_esp.lua"))()
```

settings
-
```lua
ESP = {
    Enabled = false,
    TeamCheck = true,
    MaxDistance = 200,
    FontSize = 11,
    FadeOut = {
        OnDistance = true,
        OnDeath = false,
        OnLeave = false,
    },
    Options = { 
        FriendCheck = true, FriendCheckRGB = Color3.fromRGB(0, 255, 0),
        Highlight = false, HighlightRGB = Color3.fromRGB(255, 0, 0),
    },
    Chams = {
        Enabled = false,
        Thermal = true,
        FillRGB = Color3.fromRGB(119, 120, 255),
        FillTransparency = 100,
        OutlineRGB = Color3.fromRGB(119, 120, 255),
        OutlineTransparency = 100,
        VisibleCheck = true,
    },
    Names = {
        Enabled = false,
        RGB = Color3.fromRGB(255, 255, 255),
    },
    Flags = {
        Enabled = false,
    },
    Distances = {
        Enabled = false, 
        Position = "Text",
        RGB = Color3.fromRGB(255, 255, 255),
    },
    Weapons = { -- doesn't work for now, might be fixed later
        Enabled = false, WeaponTextRGB = Color3.fromRGB(119, 120, 255),
        Outlined = false,
        Gradient = false,
        GradientRGB1 = Color3.fromRGB(255, 255, 255), GradientRGB2 = Color3.fromRGB(119, 120, 255),
    },
    HealthBar = {
        Enabled = false,
        RGB = Color3.fromRGB(0, 255, 0),
        HealthText = false, Lerp = false, HealthTextRGB = Color3.fromRGB(255, 255, 255),
        Width = 2.5,
        Gradient = true, GradientRGB1 = Color3.fromRGB(200, 0, 0), GradientRGB2 = Color3.fromRGB(60, 60, 125), GradientRGB3 = Color3.fromRGB(119, 120, 255), 
    },
    Boxes = {
        Animate = true,
        RotationSpeed = 300,
        Gradient = false, GradientRGB1 = Color3.fromRGB(119, 120, 255), GradientRGB2 = Color3.fromRGB(0, 0, 0), 
        GradientFill = true, GradientFillRGB1 = Color3.fromRGB(119, 120, 255), GradientFillRGB2 = Color3.fromRGB(0, 0, 0), 
        
        Filled = {
            Enabled = true,
            Transparency = 0.75,
            RGB = Color3.fromRGB(0, 0, 0),
        },
        Full = {
            Enabled = false,
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Corner = {
            Enabled = false,
            RGB = Color3.fromRGB(255, 255, 255),
        },
    }
```
