modified version of eclipse.wtf's esp, which fixes some stuff and adds a lot of new features.

loadstring
-
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/A1thernex/modified-esp/main/main.lua"))()
```

<details> <summary> current configurable settings </summary>
    
```lua
ESP = {
    Enabled = false,
    TeamCheck = true,
    MaxDistance = 200,
    FontSize = 11,
	RainbowSpeed = 1,
    FadeOut = {
        OnDistance = true,
        OnDeath = false,
        OnLeave = false,
    },
    Options = { 
        FriendCheck = true, FriendCheckRGB = Color3RGB(0, 255, 0),
        Highlight = false, HighlightRGB = Color3RGB(255, 0, 0),
    },
    Chams = {
        Enabled = false,
        Thermal = true,
        FillRGB = Color3RGB(119, 120, 255), RainbowFill = false,
        FillTransparency = 100,
        OutlineRGB = Color3RGB(119, 120, 255), RainbowOutline = false,
        OutlineTransparency = 100,
        VisibleCheck = true,
    },
    Names = {
        Enabled = false,
        NameType = "Regular", -- Regular, Display Name
        RGB = Color3RGB(255, 255, 255), Rainbow = false,
    },
    Distances = {
        Enabled = false, 
	Suffix = "m",
        Position = "Bottom", -- Text, Bottom
        RGB = Color3RGB(255, 255, 255), Rainbow = false,
    },
    Weapons = {
        Enabled = false, 
	RGB = Color3RGB(119, 120, 255), Rainbow = false,
	},
    HealthBar = {
        Enabled = false,
        RGB = Color3RGB(0, 255, 0), Rainbow = false,
        HealthText = false, Lerp = false, HealthTextPosition = "Left", HealthTextRGB = Color3RGB(255, 255, 255), RainbowText = false,
        Width = 2.5,
        Gradient = false, GradientRGB1 = Color3RGB(200, 0, 0), GradientRGB2 = Color3RGB(60, 60, 125), GradientRGB3 = Color3RGB(119, 120, 255), RainbowGradient = false,
    },
    Boxes = {
        Animate = false,
        RotationSpeed = 300,
        Gradient = false, GradientRGB1 = Color3RGB(119, 120, 255), GradientRGB2 = Color3RGB(0, 0, 0), 
        GradientFill = false, GradientFillRGB1 = Color3RGB(119, 120, 255), GradientFillRGB2 = Color3RGB(0, 0, 0), 
        
        Filled = {
            Enabled = false,
            Transparency = 0.75,
            RGB = Color3RGB(0, 0, 0), Rainbow = false,
        },
        Full = {
            Enabled = false,
            RGB = Color3RGB(255, 255, 255),
        },
        Corner = {
            Enabled = false,
            RGB = Color3RGB(255, 255, 255), Rainbow = false,
        },
    };
	Skeleton = {
	     Enabled = false,
	     RGB = Color3RGB(255, 255, 255), Rainbow = false,
	     Thickness = 1,
	     Transparency = 0,
	};
}
```
</details>

<details> <summary> credits </summary>

- original version of the esp: [click here](https://github.com/krampus-organization/releases/blob/main/ESP.lua)
- v3rm thread: [click here](https://v3rm.net/threads/release-eclipse-wtf-silentware-esp-library.9221/)
</details>
