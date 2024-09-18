--[[
original:
https://github.com/krampus-organization/releases/blob/main/ESP.lua

please ignore the weird looking code, github breaks indentation in scripts
]]

local cloneref = cloneref or function(v)
    return v
end

local function gs(service)
    return game:FindService(service) -- much faster than GetService
end

local Workspace, RunService, Players, HttpService, CoreGui, Lighting = cloneref(gs("Workspace")), cloneref(gs("RunService")), cloneref(gs("Players")), cloneref(gs("HttpService")), gs("CoreGui"), cloneref(gs("Lighting"))

local Instancenew, Vec2new, Vec3new, UDim2new, Drawingnew = Instance.new, Vector2.new, Vector3.new, UDim2.new, Drawing.new;
local Color3RGB, Color3HSV, CSnew, CSKnew = Color3.fromRGB, Color3.fromHSV, ColorSequence.new, ColorSequenceKeypoint.new;
local Floor, Max, Clamp, Huge = math.floor, math.max, math.clamp, math.huge;
local Tblfind, Tblinsert = table.find, table.insert;
local Wrap, Yield = coroutine.wrap, coroutine.yield;
local Format = string.format;
local Base64Dec = crypt.base64.decode

local Cam = workspace.CurrentCamera;
local VP, WTSP, WTVP = Cam.ViewportSize, Cam.WorldToScreenPoint, Cam.WorldToViewportPoint;
local FFC, FFCOC, WFC, IsA = game.FindFirstChild, game.FindFirstChildOfClass, game.WaitForChild, game.IsA

getgenv().ESP = {
    Demo = true,
    Enabled = false,
    TeamCheck = true,
    MaxDistance = 200,
	RainbowSpeed = 2,
    HighlightTeammates = false,
    Whitelist = {},
    FadeOut = {
        OnDistance = true,
        OnDeath = false,
        OnLeave = false,
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
        RGB = Color3RGB(255, 255, 255), TeamRGB = Color3RGB(255, 255, 255), Rainbow = false, TeamRainbow = false,
        Outline = true, OutlineRGB = Color3RGB(0, 0, 0), RainbowOutline = false,
        Font = "ProggyClean", TextSize = 11,
        NameType = "Regular", -- Regular, Display Name
        Brackets = "()",
    },
    Distances = {
        Enabled = false, 
        RGB = Color3RGB(255, 255, 255), TeamRGB = Color3RGB(255, 255, 255), Rainbow = false, TeamRainbow = false,
        Outline = true, OutlineRGB = Color3RGB(0, 0, 0), RainbowOutline = false,
        Font = "ProggyClean", TextSize = 11,
        Suffix = "m",
        Position = "Bottom", -- Text, Bottom
        Brackets = "None",
    },
    Weapons = {
        Enabled = false, 
		RGB = Color3RGB(119, 120, 255), TeamRGB = Color3RGB(255, 255, 255), Rainbow = false, TeamRainbow = false,
        Outline = true, OutlineRGB = Color3RGB(0, 0, 0), RainbowOutline = false,
        Font = "ProggyClean", TextSize = 11,
        Brackets = "{}",
	},
    HealthBar = {
        Enabled = false,
        RGB = Color3RGB(0, 255, 0), TeamRGB = Color3RGB(255, 255, 255), Rainbow = false, TeamRainbow = false,
        Outline = true, OutlineRGB = Color3RGB(0, 0, 0), RainbowOutline = false,
        HealthText = false, Font = "ProggyClean", TextSize = 11, Lerp = false, HealthTextPosition = "Left", HealthTextRGB = Color3RGB(0, 255, 0), TextTeamRGB = Color3RGB(0, 0, 255), RainbowText = false, TeamRainbowText = false,
        Width = 2.5,
        Gradient = false, GradientRGB1 = Color3RGB(200, 0, 0), GradientRGB2 = Color3RGB(60, 60, 125), GradientRGB3 = Color3RGB(119, 120, 255), RainbowGradient = false,
    },
    Boxes = {
		Enabled = false, 
        RGB = Color3RGB(255, 255, 255), TeamRGB = Color3RGB(255, 255, 255), Rainbow = false, TeamRainbow = false,
        Outline = true, OutlineRGB = Color3RGB(0, 0, 0), RainbowOutline = false,
        BoxType = "Full",
        RotationSpeed = 300,
        Gradient = false, GradientRGB1 = Color3RGB(119, 120, 255), GradientRGB2 = Color3RGB(0, 0, 0), 
        
        Filled = {
            Enabled = false,
            Transparency = 0.75,
            RGB = Color3RGB(0, 0, 0), TeamRGB = Color3RGB(255, 255, 255), Rainbow = false, TeamRainbow = false,
			Animate = false,
			GradientFill = false, GradientFillRGB1 = Color3RGB(119, 120, 255), GradientFillRGB2 = Color3RGB(0, 0, 0), 
        },
    };
	Skeleton = {
		Enabled = false,
		RGB = Color3RGB(255, 255, 255), TeamRGB = Color3RGB(255, 255, 255), Rainbow = false, TeamRainbow = false,
		Thickness = 1,
		Transparency = 0,
	};
    Connections = {
        RunService = RunService;
    };
	Coroutines = {};
    Loops = {};
    Fonts = {};
	Elements = {};
}

-- font initialization, taken from office
if writefile and isfile and Base64Dec then
	print("sd")
	if not isfile("Proggy.ttf") then
		writefile("Proggy.ttf", Base64Dec(game:HttpGet("https://raw.githubusercontent.com/OxygenClub/Random-LUAS/main/Proggy.txt")))
	end

	if not isfile("Proggy.json") then
		local Proggy = {
			name = "Proggy",
			faces = { 
				{
					name = "Regular",
					weight = 400,
					style = "normal",
					assetId = getcustomasset("Proggy.ttf")
				} 
			}
		}

		writefile("Proggy.json", HttpService:JSONEncode(Proggy))
	end

	if not isfile("Minecraftia.ttf") then
		writefile("Minecraftia.ttf", Base64Dec(game:HttpGet("https://raw.githubusercontent.com/OxygenClub/Random-LUAS/main/Minecraftia.txt")))
	end

	if not isfile("Minecraftia.json") then
		local Minecraftia = {
			name = "Minecraftia",
			faces = { 
				{
					name = "Regular",
					weight = 400,
					style = "normal",
					assetId = getcustomasset("Minecraftia.ttf")
				} 
			}
		}

		writefile("Minecraftia.json", HttpService:JSONEncode(Minecraftia))
	end

	if not isfile("SmallestPixel7.ttf") then
		writefile("SmallestPixel7.ttf", Base64Dec(game:HttpGet("https://raw.githubusercontent.com/OxygenClub/Random-LUAS/main/Smallest%20Pixel.txt")))
	end

	if not isfile("SmallestPixel7.json") then
		local SmallestPixel7 = {
			name = "SmallestPixel7",
			faces = { 
				{
					name = "Regular",
					weight = 400,
					style = "normal",
					assetId = getcustomasset("SmallestPixel7.ttf")
				} 
			}
		}

		writefile("SmallestPixel7.json", HttpService:JSONEncode(SmallestPixel7))
	end

	if not isfile("Verdana.ttf") then
		writefile("Verdana.ttf", Base64Dec(game:HttpGet("https://raw.githubusercontent.com/OxygenClub/Random-LUAS/main/Verdana.txt")))
	end

	if not isfile("Verdana.json") then
		local Verdana = {
			name = "Verdana",
			faces = { 
				{
					name = "Regular",
					weight = 400,
					style = "normal",
					assetId = getcustomasset("Verdana.ttf")
				} 
			}
		}

		writefile("Verdana.json", HttpService:JSONEncode(Verdana))
	end

	if not isfile("VerdanaBold.ttf") then
		writefile("VerdanaBold.ttf", Base64Dec(game:HttpGet("https://raw.githubusercontent.com/OxygenClub/Random-LUAS/main/Verdana%20Bold.txt")))
	end

	if not isfile("VerdanaBold.json") then
		local VerdanaBold = {
			name = "VerdanaBold",
			faces = { 
				{
					name = "Regular",
					weight = 400,
					style = "normal",
					assetId = getcustomasset("VerdanaBold.ttf")
				} 
			}
		}

		writefile("VerdanaBold.json", HttpService:JSONEncode(VerdanaBold))
	end

	if not isfile("Tahoma.ttf") then
		writefile("Tahoma.ttf", Base64Dec(game:HttpGet("https://raw.githubusercontent.com/OxygenClub/Random-LUAS/main/Tahoma.txt")))
	end

	if not isfile("Tahoma.json") then
		local Tahoma = {
			name = "Tahoma",
			faces = { 
				{
					name = "Regular",
					weight = 400,
					style = "normal",
					assetId = getcustomasset("Tahoma.ttf")
				} 
			}
		}

		writefile("Tahoma.json", HttpService:JSONEncode(Tahoma))
	end

	if not isfile("TahomaBold.ttf") then
		writefile("TahomaBold.ttf", Base64Dec(game:HttpGet("https://raw.githubusercontent.com/OxygenClub/Random-LUAS/main/Tahoma%20Bold.txt")))
	end

	if not isfile("TahomaBold.json") then
		local TahomaBold = {
			name = "TahomaBold",
			faces = { 
				{
					name = "Regular",
					weight = 400,
					style = "normal",
					assetId = getcustomasset("TahomaBold.ttf")
				} 
			}
		}

		writefile("TahomaBold.json", HttpService:JSONEncode(TahomaBold))
	end
end

local Fonts = {};

if isfile("Proggy.json") and isfile("SmallestPixel7.json") and isfile("Minecraftia.json") and isfile("Verdana.json") and isfile("VerdanaBold.json") and isfile("Tahoma.json") and isfile("TahomaBold.json") then
	Fonts = {
    	["ProggyClean"] = Font.new(getcustomasset("Proggy.json"), Enum.FontWeight.Regular),
    	["SmallestPixel"] = Font.new(getcustomasset("SmallestPixel7.json"), Enum.FontWeight.Regular),
		["Minecraftia"] = Font.new(getcustomasset("Minecraftia.json"), Enum.FontWeight.Regular),
    	["Verdana"] = Font.new(getcustomasset("Verdana.json"), Enum.FontWeight.Regular),
    	["VerdanaBold"] = Font.new(getcustomasset("VerdanaBold.json"), Enum.FontWeight.Regular),
    	["Tahoma"] = Font.new(getcustomasset("Tahoma.json"), Enum.FontWeight.Regular),
		["TahomaBold"] = Font.new(getcustomasset("TahomaBold.json"), Enum.FontWeight.Regular),
	}
else
	Fonts = {
    	["ProggyClean"] = Font.fromEnum(Enum.Font.Code),
    	["SmallestPixel"] = Font.fromEnum(Enum.Font.Code),
		["Minecraftia"] = Font.fromEnum(Enum.Font.Code),
    	["Verdana"] = Font.fromEnum(Enum.Font.Code),
    	["VerdanaBold"] = Font.fromEnum(Enum.Font.Code),
    	["Tahoma"] = Font.fromEnum(Enum.Font.Code),
		["TahomaBold"] = Font.fromEnum(Enum.Font.Code),
	}
end

-- Def & Vars
getgenv().SkeletonLines = {};
local Euphoria = ESP.Connections;
local lplayer = Players.LocalPlayer;
local RotationAngle, Tick = -45, tick();
local Folders = {};
local Color;
local bodyConnections = {
    R15 = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LowerTorso", "RightUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"},
        {"UpperTorso", "LeftUpperArm"},
        {"UpperTorso", "RightUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"}
    },
    R6 = {
        {"Head", "Torso"},
        {"Torso", "Left Arm"},
        {"Torso", "Right Arm"},
        {"Torso", "Left Leg"},
        {"Torso", "Right Leg"}
    }
};
local Brackets = {
    ["{}"] = {"{", "}"},
    ["[]"] = {"[", "]"},
    ["()"] = {"(", ")"},
    ["<>"] = {"<", ">"},
    ["[()]"] = {"[(", ")]"},
    ["{()}"] = {"{(", ")}"},
    ["-><-"] = {"->", "<-"},
}

-- Functions
local Functions = {};
do

    function Functions:Create(Class, Properties)
        local _Instance = typeof(Class) == 'string' and Instancenew(Class) or Class
        for Property, Value in pairs(Properties) do
            _Instance[Property] = Value
        end
        return _Instance;
    end
	--
	function Functions:createDrawing(type, properties)
    	local drawing = Drawingnew(type)
    	for prop, val in pairs(properties) do
        	drawing[prop] = val
    	end
    	return drawing
	end
    --
    function Functions:FadeOutOnDist(element, distance)
        local transparency = Max(0.1, 1 - (distance / ESP.MaxDistance))
        if element:IsA("TextLabel") then
            element.TextTransparency = 1 - transparency
        elseif element:IsA("ImageLabel") then
            element.ImageTransparency = 1 - transparency
        elseif element:IsA("UIStroke") then
            element.Transparency = 1 - transparency
        elseif element:IsA("Frame") and (element == HealthBar or element == BehindHealthBar) then
            element.BackgroundTransparency = 1 - transparency
        elseif element:IsA("Frame") then
            element.BackgroundTransparency = 1 - transparency
        elseif element:IsA("Highlight") then
            element.FillTransparency = 1 - transparency
            element.OutlineTransparency = 1 - transparency
        end;
    end;

	function Functions:FadeOutOnDeath(element)
        local transparency = 0
		repeat
			transparency = transparency + 0.1
        	if IsA(element, "TextLabel") then
            	element.TextTransparency = 1 - transparency
        	elseif IsA(element, "ImageLabel") then
            	element.ImageTransparency = 1 - transparency
        	elseif IsA(element, "UIStroke") then
            	element.Transparency = 1 - transparency
        	elseif IsA(element, "Frame") and (element == HealthBar) then
            	element.BackgroundTransparency = 1 - transparency
        	elseif IsA(element, "Frame") then
           		element.BackgroundTransparency = 1 - transparency
        	elseif IsA(element, "Highlight") then
            	element.FillTransparency = 1 - transparency
            	element.OutlineTransparency = 1 - transparency
        	end;
		until transparency == 1
    end;  
end;

do -- Initalize

    local ScreenGui = Functions:Create("ScreenGui", {
        Parent = CoreGui,
        Name = "secret",
    });

    local function CreateFolder(name)
        if not ScreenGui:FindFirstChild(name) and not Folders[name] then
            local Folder = Functions:Create("Folder", {Name = name, Parent = ScreenGui})
			Folders[name] = true
		end
    end

    for _,v in pairs(Players:GetPlayers()) do
        if v ~= lplayer then
            CreateFolder(v.Name)
        end
    end

	function ESP:GetRainbow()
        -- from exunys
		return Color3HSV(tick() % ESP.RainbowSpeed / ESP.RainbowSpeed, 1, 1)
	end

	function ESP:GetRainbowClr(type)
        -- a bit of rework by ai, because i'm too stupid to figure out how to make it animate smoothly
        local direction = 1
        local origcalc = (tick() % ESP.RainbowSpeed / ESP.RainbowSpeed) * direction

        if origcalc >= 1 then
            direction = -1
            origcalc = 1
        elseif origcalc <= 0 then
            direction = 1
            origcalc = 0
        end

        if type == "first" then
            return Color3HSV(origcalc, 1, 1)
        elseif type == "second" then
            local calc = origcalc + 0.1

            if calc > 1 then
                calc = calc - 1
            elseif calc < 0 then
                calc = calc + 1
            end

            return Color3HSV(calc, 1, 1)
        elseif type == "third" then
            local calc2 = origcalc + 0.25

            if calc2 > 1 then
                calc2 = calc2 - 1
            elseif calc2 < 0 then
                calc2 = calc2 + 1
            end

            return Color3HSV(calc2, 1, 1)
        end
    end

	function ESP:Demo(state)
		ESP.Enabled = state
		ESP.Boxes.Enabled = state
		ESP.Names.Enabled = state
		ESP.Distances.Enabled = state
		ESP.HealthBar.Enabled = state
		ESP.HealthBar.HealthText = state
		ESP.Chams.Enabled = state
		ESP.Skeleton.Enabled = state
		ESP.Weapons.Enabled = state
	end

	function ESP:Unload()
        if ScreenGui then
            ScreenGui:Destroy()
            cleardrawcache()
            Coroutines = ESP.Coroutines
            Connections = ESP.Loops
            Folders = nil
            ESP = nil

			for _, connection in Connections do
                connection:Disconnect()
            end

			for _, cor in Coroutines do
			    Yield(cor)
            end
        end
    end

    local CreateESP = function(plr)
        local FolderCoroutine = Wrap(CreateFolder)(plr.Name)
		if ESP.Elements[plr.Name] == nil then
			ESP.Elements[plr.Name] = {}
		end
		if ESP.Coroutines[plr.Name] == nil then
			ESP.Coroutines[plr.Name] = {}
		end
		if not Tblfind(ESP.Coroutines[plr.Name], FolderCoroutine) then
			Tblinsert(ESP.Coroutines[plr.Name], FolderCoroutine)
		end

		local Name = Functions:Create("TextLabel", {Name = "Name", Parent = ScreenGui[plr.Name], Text = plr.Name, Position = UDim2new(0.5, 0, 0, -11), Size = UDim2new(0, 100, 0, 20), AnchorPoint = Vec2new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3RGB(255, 255, 255), FontFace = Fonts[ESP.Names.Font], TextSize = ESP.Names.TextSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3RGB(0, 0, 0), RichText = true})
		local Distance = Functions:Create("TextLabel", {Name = "Distance", Parent = ScreenGui[plr.Name], Position = UDim2new(0.5, 0, 0, 11), Size = UDim2new(0, 100, 0, 20), AnchorPoint = Vec2new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3RGB(255, 255, 255), FontFace = Fonts[ESP.Distances.Font], TextSize = ESP.Distances.TextSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3RGB(0, 0, 0), RichText = true})
		local Weapon = Functions:Create("TextLabel", {Name = "Weapon", Parent = ScreenGui[plr.Name], Position = UDim2new(0.5, 0, 0, 31), Size = UDim2new(0, 100, 0, 20), AnchorPoint = Vec2new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3RGB(255, 255, 255), FontFace = Fonts[ESP.Weapons.Font], TextSize = ESP.Weapons.TextSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3RGB(0, 0, 0), RichText = true})
		local Box = Functions:Create("Frame", {Name = "Box", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(0, 0, 0), BackgroundTransparency = 0.75, BorderSizePixel = 0})
		local Gradient1 = Functions:Create("UIGradient", {Name = "1stBoxGradient", Parent = Box, Enabled = ESP.Boxes.Filled.GradientFill, Color = CSnew{CSKnew(0, ESP.Boxes.Filled.GradientFillRGB1), CSKnew(1, ESP.Boxes.Filled.GradientFillRGB2)}})
		local Outline = Functions:Create("UIStroke", {Name = "BoxOutline", Parent = Box, Enabled = ESP.Boxes.Gradient, Transparency = 0, Color = Color3RGB(255, 255, 255), LineJoinMode = Enum.LineJoinMode.Miter})
		local Gradient2 = Functions:Create("UIGradient", {Name = "2ndBoxGradient", Parent = Outline, Enabled = ESP.Boxes.Gradient, Color = CSnew{CSKnew(0, ESP.Boxes.GradientRGB1), CSKnew(1, ESP.Boxes.GradientRGB2)}})
		local HealthBar = Functions:Create("Frame", {Name = "HealthBar", Parent = ScreenGui[plr.Name], ZIndex = 2, BackgroundColor3 = ESP.HealthBar.RGB, BackgroundTransparency = 0})
		local BehindHealthBar = Functions:Create("Frame", {Name = "BehindHealthBar", Parent = ScreenGui[plr.Name], ZIndex = -1, BackgroundColor3 = Color3RGB(0, 0, 0), BackgroundTransparency = 0})
		local HealthBarGradient = Functions:Create("UIGradient", {Name = "HealthBarGradient", Parent = HealthBar, Rotation = -90, Color = CSnew{CSKnew(0, ESP.HealthBar.GradientRGB1), CSKnew(0.5, ESP.HealthBar.GradientRGB2), CSKnew(1, ESP.HealthBar.GradientRGB3)}})
		local HealthText = Functions:Create("TextLabel", {Name = "HealthText", Parent = ScreenGui[plr.Name], Position = UDim2new(0.5, 0, 0, 31), Size = UDim2new(0, 100, 0, 20), AnchorPoint = Vec2new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3RGB(255, 255, 255), FontFace = Fonts[ESP.HealthBar.Font], TextSize = ESP.HealthBar.TextSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3RGB(0, 0, 0)})
		local Chams = Functions:Create("Highlight", {Name = "Chams", Parent = ScreenGui[plr.Name], FillTransparency = 1, OutlineTransparency = 0, OutlineColor = Color3RGB(119, 120, 255), DepthMode = "AlwaysOnTop"})
		local LeftTop = Functions:Create("Frame", {Name = "TopLeftBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.RGB, Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 0})
		local LeftSide = Functions:Create("Frame", {Name = "LeftSideBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.RGB, Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 0})
		local RightTop = Functions:Create("Frame", {Name = "TopRightBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.RGB, Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 0})
		local RightSide = Functions:Create("Frame", {Name = "RightSideBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.RGB, Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 0})
		local BottomSide = Functions:Create("Frame", {Name = "BottomSideBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.RGB, Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 0})
		local BottomDown = Functions:Create("Frame", {Name = "BottomDownBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.RGB, Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 0})
		local BottomRightSide = Functions:Create("Frame", {Name = "RightBottomSideBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.RGB, Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 0})
		local BottomRightDown = Functions:Create("Frame", {Name = "RightBottomDownBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.RGB, Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 0})
		local LeftTopOut = Functions:Create("Frame", {Name = "TopLeftBoxCornerOut", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(0, 0, 0), Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 1, ZIndex = -2})
		local LeftSideOut = Functions:Create("Frame", {Name = "LeftSideBoxCornerOut", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(0, 0, 0), Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 1, ZIndex = -2})
		local RightTopOut = Functions:Create("Frame", {Name = "TopRightBoxCornerOut", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(0, 0, 0), Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 1, ZIndex = -2})
		local RightSideOut = Functions:Create("Frame", {Name = "RightSideBoxCornerOut", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(0, 0, 0), Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 1, ZIndex = -2})
		local BottomSideOut = Functions:Create("Frame", {Name = "BottomSideBoxCornerOut", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(0, 0, 0), Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 1, ZIndex = -2})
		local BottomDownOut = Functions:Create("Frame", {Name = "BottomDownBoxCornerOut", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(0, 0, 0), Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 1, ZIndex = -2})
		local BottomRightSideOut = Functions:Create("Frame", {Name = "RightBottomSideBoxCornerOut", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(0, 0, 0), Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 1, ZIndex = -2})
		local BottomRightDownOut = Functions:Create("Frame", {Name = "RightBottomDownBoxCornerOut", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(0, 0, 0), Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 1, ZIndex = -2})
		--[[local Flag1 = Functions:Create("TextLabel", {Name = "Flag1", Parent = ScreenGui[plr.Name], Position = UDim2new(1, 0, 0, 0), Size = UDim2new(0, 100, 0, 20), AnchorPoint = Vec2new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3RGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3RGB(0, 0, 0)})
		local Flag2 = Functions:Create("TextLabel", {Name = "Flag2", Parent = ScreenGui[plr.Name], Position = UDim2new(1, 0, 0, 0), Size = UDim2new(0, 100, 0, 20), AnchorPoint = Vec2new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3RGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3RGB(0, 0, 0)})
		]]
		--
        local Updater = function()
			print("updater got to player: " .. plr.Name)
            local Connection;
            local function HideESP()
                if not plr then
                    ScreenGui[plr.Name]:Destroy();
                    Connection:Disconnect();

					for _, line in SkeletonLines[plr.Name] do
						line:Remove()
					end
					
					for _, coroutine in ESP.Coroutines[plr.Name] do
						Yield(coroutine)
					end
                else
                    if ScreenGui:FindFirstChild(plr.Name) then
				        for _, element in ScreenGui[plr.Name]:GetChildren() do
					        if IsA(element, "Highlight") then
						        element.Enabled = false
					        else
						        element.Visible = false
					        end
				        end

                        if SkeletonLines[plr.Name] ~= nil then
                            for _, line in SkeletonLines[plr.Name] do
					            line.Visible = false
                            end
                        end
                    end
                end
            end

            local function IsEnabled()
                if not ESP.Enabled then
                    ScreenGui.Enabled = false
                else
                    ScreenGui.Enabled = true
                end
            end
			
            Connection = Euphoria.RunService.RenderStepped:Connect(function(dt)
                if plr.Character and FFC(plr.Character, "HumanoidRootPart") then
                    local character = plr.Character
					local HRP = character.HumanoidRootPart
                    local Humanoid, Head = WFC(character, "Humanoid"), WFC(character, "Head");
                    local Pos, OnScreen = WTSP(Cam, HRP.Position)
                    local Dist = (Cam.CFrame.Position - HRP.Position).Magnitude / 3.5714285714

                    if OnScreen and Dist <= ESP.MaxDistance then
                        local Size = HRP.Size.Y
                        local scaleFactor = (Size * VP.Y) / (Pos.Z * 2)
                        local w, h = 3 * scaleFactor, 4.5 * scaleFactor

                        -- Fade-out effect --
                        if ESP.FadeOut.OnDistance and ScreenGui:FindFirstChild(plr.Name) then
							for _, element in ScreenGui[plr.Name]:GetChildren() do
                                if not IsA(element, "Highlight") then
								    Functions:FadeOutOnDist(element, Dist)
                                end
							end

							--[[for _, line in SkeletonLines do
								Functions:FadeOutOnDist(line, Dist)
							end]]
                        end

                        -- Teamcheck and whitelist check
                        --[[if Tblfind(ESP.Whitelist, plr.Name) or Tblfind(ESP.Whitelist, plr.DisplayName) or ESP.TeamCheck and not ESP.HighlightTeammates and plr ~= lplayer and ((lplayer.Team ~= plr.Team and plr.Team) or (not lplayer.Team and not plr.Team)) and character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then]]
						if Tblfind(ESP.Whitelist, plr.Name) or Tblfind(ESP.Whitelist, ESP.DisplayName) or ESP.TeamCheck and not ESP.HighlightTeammates and plr ~= lplayer and lplayer.Team == plr.Team then
                            HideESP();
                        else
                                do -- Skeleton
								    local connections = bodyConnections[Humanoid.RigType.Name] or {}

            					    for _, connection in ipairs(connections) do
                					    local partA = FFC(character, connection[1])
                					    local partB = FFC(character, connection[2])
                					    if partA and partB then
                                            if SkeletonLines[plr.Name] == nil then
                                                SkeletonLines[plr.Name] = {}
                                            end
                    					    local line = SkeletonLines[plr.Name][connection[1] .. "-" .. connection[2]] or Functions:createDrawing("Line", {Thickness = 1, Color = Color3RGB(255, 255, 255)})
										    local posA, onScreenA = WTVP(Cam, partA.Position)
                    					    local posB, onScreenB = WTVP(Cam, partB.Position)
                    					    if onScreenA and onScreenB then
                        					    line.From = Vec2new(posA.X, posA.Y)
                        					    line.To = Vec2new(posB.X, posB.Y)
                        					    line.Visible = ESP.Skeleton.Enabled
                        					    SkeletonLines[plr.Name][connection[1] .. "-" .. connection[2]] = line
                    					    else
                        					    line.Visible = false
                   						    end

                                            if ESP.HighlightTeammates then
                                                Color = ESP.Skeleton.TeamRainbow and ESP:GetRainbow() or ESP.Skeleton.TeamRGB
                                            else
                                                Color = ESP.Skeleton.Rainbow and ESP:GetRainbow() or ESP.Skeleton.RGB
                                            end

										    line.Color = Color
										    line.Thickness = ESP.Skeleton.Thickness
										    line.Transparency = 1 - ESP.Skeleton.Transparency
                					    end
            					    end
							    end
							    --
                                do -- Chams
                                    Chams.Adornee = plr.Character
                                    Chams.Enabled = ESP.Chams.Enabled
                                    Chams.FillColor = ESP.Chams.RainbowFill and ESP:GetRainbow() or ESP.Chams.FillRGB
                                    Chams.OutlineColor = ESP.Chams.RainbowOutline and ESP:GetRainbow() or ESP.Chams.OutlineRGB
                                    do -- Breathe
                                        if ESP.Chams.Thermal then
                                            local breathe_effect = math.atan(math.sin(tick() * 2)) * 2 / math.pi
                                            Chams.FillTransparency = ESP.Chams.FillTransparency * breathe_effect * 0.01
                                            Chams.OutlineTransparency = ESP.Chams.OutlineTransparency * breathe_effect * 0.01
                                        end
                                    end
                                    if ESP.Chams.VisibleCheck then
                                        Chams.DepthMode = "Occluded"
                                    else
                                        Chams.DepthMode = "AlwaysOnTop"
                                    end
                                end;
							    --
                                do -- Box
                                    if ESP.HighlightTeammates then
                                        Color = ESP.Boxes.TeamRainbow and ESP:GetRainbow() or ESP.Boxes.TeamRGB
                                    else
                                        Color = ESP.Boxes.Rainbow and ESP:GetRainbow() or ESP.Boxes.RGB
                                    end

								    if ESP.Boxes.BoxType == "Corner" then
                                	    LeftTop.Visible = true
                                	    LeftTop.Position = UDim2new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                	    LeftTop.Size = UDim2new(0, w / 5, 0, 1)
									    LeftTop.BackgroundColor3 = Color
                                
									    LeftTopOut.Visible = ESP.Boxes.Outline and true or false
                                        LeftTopOut.BackgroundColor3 = ESP.Boxes.RainbowOutline and ESP:GetRainbow() or ESP.Boxes.OutlineRGB
                                	    LeftTopOut.Position = LeftTop.Position
                                	    LeftTopOut.Size = LeftTop.Size

                                	    LeftSide.Visible = true
                                	    LeftSide.Position = UDim2new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                	    LeftSide.Size = UDim2new(0, 1, 0, h / 5)
									    LeftSide.BackgroundColor3 = Color
                                
									    LeftSideOut.Visible = ESP.Boxes.Outline and true or false
                                        LeftSideOut.BackgroundColor3 = ESP.Boxes.RainbowOutline and ESP:GetRainbow() or ESP.Boxes.OutlineRGB
                                	    LeftSideOut.Position = LeftSide.Position
                                	    LeftSideOut.Size = LeftSide.Size

                                	    BottomSide.Visible = true
                                	    BottomSide.Position = UDim2new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                	    BottomSide.Size = UDim2new(0, 1, 0, h / 5)
                                	    BottomSide.AnchorPoint = Vec2new(0, 5)
									    BottomSide.BackgroundColor3 = Color
                                
									    BottomSideOut.Visible = ESP.Boxes.Outline and true or false
                                        BottomSideOut.BackgroundColor3 = ESP.Boxes.RainbowOutline and ESP:GetRainbow() or ESP.Boxes.OutlineRGB
                                	    BottomSideOut.Position = BottomSide.Position
                                	    BottomSideOut.Size = BottomSide.Size
                                	    BottomSideOut.AnchorPoint = Vec2new(0, 5)

                                	    BottomDown.Visible = true
                                	    BottomDown.Position = UDim2new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                	    BottomDown.Size = UDim2new(0, w / 5, 0, 1)
                                	    BottomDown.AnchorPoint = Vec2new(0, 1)
                                	    BottomDown.BackgroundColor3 = Color

									    BottomDownOut.Visible = ESP.Boxes.Outline and true or false
                                        BottomDownOut.BackgroundColor3 = ESP.Boxes.RainbowOutline and ESP:GetRainbow() or ESP.Boxes.OutlineRGB
                                	    BottomDownOut.Position = BottomDown.Position
                                	    BottomDownOut.Size = BottomDown.Size
                                	    BottomDownOut.AnchorPoint = Vec2new(0, 1)

                                	    RightTop.Visible = true
                                	    RightTop.Position = UDim2new(0, Pos.X + w / 2, 0, Pos.Y - h / 2)
                                	    RightTop.Size = UDim2new(0, w / 5, 0, 1)
                                	    RightTop.AnchorPoint = Vec2new(1, 0)
                                	    RightTop.BackgroundColor3 = Color

									    RightTopOut.Visible = ESP.Boxes.Outline and true or false
                                        RightTopOut.BackgroundColor3 = ESP.Boxes.RainbowOutline and ESP:GetRainbow() or ESP.Boxes.OutlineRGB
                                	    RightTopOut.Position = RightTop.Position
                                	    RightTopOut.Size = RightTop.Size
                                	    RightTopOut.AnchorPoint = Vec2new(1, 0)

                                	    RightSide.Visible = true
                                	    RightSide.Position = UDim2new(0, Pos.X + w / 2 - 1, 0, Pos.Y - h / 2)
                                	    RightSide.Size = UDim2new(0, 1, 0, h / 5)
                                	    RightSide.AnchorPoint = Vec2new(0, 0)
                               		    RightSide.BackgroundColor3 = Color
							
									    RightSideOut.Visible = ESP.Boxes.Outline and true or false
                                        RightSideOut.BackgroundColor3 = ESP.Boxes.RainbowOutline and ESP:GetRainbow() or ESP.Boxes.OutlineRGB
                                	    RightSideOut.Position = RightSide.Position
                                	    RightSideOut.Size = RightSide.Size
                                	    RightSideOut.AnchorPoint = Vec2new(0, 0)

                                	    BottomRightSide.Visible = true
                                	    BottomRightSide.Position = UDim2new(0, Pos.X + w / 2, 0, Pos.Y + h / 2)
                                	    BottomRightSide.Size = UDim2new(0, 1, 0, h / 5)
                                	    BottomRightSide.AnchorPoint = Vec2new(1, 1)
                                	    BottomRightSide.BackgroundColor3 = Color

									    BottomRightSideOut.Visible = ESP.Boxes.Outline and true or false
                                        BottomRightSideOut.BackgroundColor3 = ESP.Boxes.RainbowOutline and ESP:GetRainbow() or ESP.Boxes.OutlineRGB
                                	    BottomRightSideOut.Position = BottomRightSide.Position
                                	    BottomRightSideOut.Size = BottomRightSide.Size
                                	    BottomRightSideOut.AnchorPoint = Vec2new(1, 1)

                                	    BottomRightDown.Visible = true
                                	    BottomRightDown.Position = UDim2new(0, Pos.X + w / 2, 0, Pos.Y + h / 2)
                                	    BottomRightDown.Size = UDim2new(0, w / 5, 0, 1)
                                	    BottomRightDown.AnchorPoint = Vec2new(1, 1) 
									    BottomRightDown.BackgroundColor3 = Color
                            
									    BottomRightDownOut.Visible = ESP.Boxes.Outline and true or false
                                        BottomRightDownOut.BackgroundColor3 = ESP.Boxes.RainbowOutline and ESP:GetRainbow() or ESP.Boxes.OutlineRGB
                                	    BottomRightDownOut.Position = BottomRightDown.Position
                                	    BottomRightDownOut.Size = BottomRightDown.Size
                                	    BottomRightDownOut.AnchorPoint = Vec2new(1, 1) 
								    elseif ESP.Boxes.BoxType == "Full" then
									    -- it works tho :shrug:
									    LeftSide.Visible = false
									    LeftSideOut.Visible = false
									    BottomRightDown.Visible = false
									    BottomRightDownOut.Visible = false
									    RightSide.Visible = false
									    RightSideOut.Visible = false
									    RightTop.Visible = false
									    RightTopOut.Visible = false

									    LeftTop.Visible = true
									    LeftTop.Position = UDim2new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                	    LeftTop.Size = UDim2new(0, w, 0, 1)
									    LeftTop.BackgroundColor3 = Color

                                	    LeftTopOut.Visible = ESP.Boxes.Outline and true or false
                                        LeftTopOut.BackgroundColor3 = ESP.Boxes.RainbowOutline and ESP:GetRainbow() or ESP.Boxes.OutlineRGB
									    LeftTopOut.Position = LeftTop.Position
                                	    LeftTopOut.Size = LeftTop.Size

									    BottomSide.Visible = true
									    BottomSide.Position = UDim2new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                	    BottomSide.Size = UDim2new(0, 1, 0, h)
                                	    BottomSide.AnchorPoint = Vec2new(0, 5)
									    BottomSide.BackgroundColor3 = Color
                                
                                	    BottomSideOut.Visible = ESP.Boxes.Outline and true or false
                                        BottomSideOut.BackgroundColor3 = ESP.Boxes.RainbowOutline and ESP:GetRainbow() or ESP.Boxes.OutlineRGB
									    BottomSideOut.Position = BottomSide.Position
                                	    BottomSideOut.Size = BottomSide.Size
                                	    BottomSideOut.AnchorPoint = Vec2new(0, 5)

                                	    BottomDown.Visible = true
									    BottomDown.Position = UDim2new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                	    BottomDown.Size = UDim2new(0, w, 0, 1)
                                	    BottomDown.AnchorPoint = Vec2new(0, 1)
                                	    BottomDown.BackgroundColor3 = Color

                                	    BottomDownOut.Visible = ESP.Boxes.Outline and true or false
                                        BottomDownOut.BackgroundColor3 = ESP.Boxes.RainbowOutline and ESP:GetRainbow() or ESP.Boxes.OutlineRGB
									    BottomDownOut.Position = BottomDown.Position
                                	    BottomDownOut.Size = BottomDown.Size
                                	    BottomDownOut.AnchorPoint = Vec2new(0, 1)

                                	    BottomRightSide.Visible = true
									    BottomRightSide.Position = UDim2new(0, Pos.X + w / 2, 0, Pos.Y + h / 2)
                                	    BottomRightSide.Size = UDim2new(0, 1, 0, h)
                                	    BottomRightSide.AnchorPoint = Vec2new(1, 1)
                                	    BottomRightSide.BackgroundColor3 = Color

                                	    BottomRightSideOut.Visible = ESP.Boxes.Outline and true or false
                                        BottomRightSideOut.BackgroundColor3 = ESP.Boxes.RainbowOutline and ESP:GetRainbow() or ESP.Boxes.OutlineRGB
									    BottomRightSideOut.Position = BottomRightSide.Position
                                	    BottomRightSideOut.Size = BottomRightSide.Size
                                	    BottomRightSideOut.AnchorPoint = Vec2new(1, 1)
								    end
							    end

                                do -- Boxes
                                    Box.Position = UDim2new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                    Box.Size = UDim2new(0, w, 0, h)
                                    Box.Visible = ESP.Boxes.Enabled;

                                    -- Gradient
                                    if ESP.Boxes.Filled.Enabled then
                                        Box.BackgroundColor3 = Color3RGB(255, 255, 255)
                                        if ESP.Boxes.Filled.GradientFill then
                                            Box.BackgroundTransparency = ESP.Boxes.Filled.Transparency;
                                        else
                                            Box.BackgroundTransparency = 1
                                        end
                                        Box.BorderSizePixel = 1
                                    else
                                        Box.BackgroundTransparency = 1
                                    end
                                    -- Animation
                                    RotationAngle = RotationAngle + (tick() - Tick) * ESP.Boxes.RotationSpeed * math.cos(math.pi / 4 * tick() - math.pi / 2)
                                    if ESP.Boxes.Filled.Animate then
                                        Gradient1.Rotation = RotationAngle
                                        Gradient2.Rotation = RotationAngle
                                    else
                                        Gradient1.Rotation = -45
                                        Gradient2.Rotation = -45
                                    end
                                    Tick = tick()
                                end

                                -- HealthBar
                                do  
                                    if ESP.HighlightTeammates then
                                        Color = ESP.HealthBar.TeamRainbow and ESP:GetRainbow() or ESP.HealthBar.TeamRGB
                                    else
                                        Color = ESP.HealthBar.Rainbow and ESP:GetRainbow() or ESP.HealthBar.RGB
                                    end

                                    local health = Humanoid.Health / Humanoid.MaxHealth;
								    HealthBar.Visible = ESP.HealthBar.Enabled;
                                    HealthBar.Position = UDim2new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2 + h * (1 - health))  
                                    HealthBar.Size = UDim2new(0, ESP.HealthBar.Width, 0, h * health)
								    --
								    BehindHealthBar.Visible = ESP.HealthBar.Enabled;
                                    BehindHealthBar.Position = UDim2new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2)  
                                    BehindHealthBar.Size = UDim2new(0, ESP.HealthBar.Width, 0, h)

								    if not ESP.HealthBar.Gradient then 
									    HealthBar.BackgroundColor3 = Color
                                    else
									    HealthBar.BackgroundColor3 = Color3RGB(255, 255, 255)
								    end
								    --
                                    HealthBarGradient.Enabled = ESP.HealthBar.Gradient
                                    HealthBarGradient.Color = ESP.HealthBar.RainbowGradient and CSnew({CSKnew(0, ESP:GetRainbowClr("first")), CSKnew(0.5, ESP:GetRainbowClr("second")), CSKnew(1, ESP:GetRainbowClr("third"))}) or CSnew({CSKnew(0, ESP.HealthBar.GradientRGB1), CSKnew(0.5, ESP.HealthBar.GradientRGB2), CSKnew(1, ESP.HealthBar.GradientRGB3)})
                                    -- Health Text
                                    do
                                        if ESP.HighlightTeammates then
                                            Color = ESP.HealthBar.TeamRainbowText and ESP:GetRainbow() or ESP.HealthBar.TextTeamRGB
                                        else
                                            Color = ESP.HealthBar.RainbowText and ESP:GetRainbow() or ESP.HealthBar.HealthTextRGB
                                        end

                                        if ESP.HealthBar.HealthText then
                                            local healthPercentage = Floor(Humanoid.Health / Humanoid.MaxHealth * 100)
                                            HealthText.Position = ESP.HealthBar.HealthTextPosition == "Follow Bar" and UDim2new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2 + h * (1 - healthPercentage / 100) + 3) or UDim2new(-0.006, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2 + h / 100 + 3)
                                            HealthText.Text = tostring(healthPercentage)
                                            HealthText.FontFace = Fonts[ESP.HealthBar.Font]
                                            HealthText.TextSize = ESP.HealthBar.TextSize
                                            HealthText.Visible = true --Humanoid.Health < Humanoid.MaxHealth
                                            if ESP.HealthBar.Lerp then
                                                local color = health >= 0.75 and Color3RGB(0, 255, 0) or health >= 0.5 and Color3RGB(255, 255, 0) or health >= 0.25 and Color3RGB(255, 170, 0) or Color3RGB(255, 0, 0)
                                                HealthText.TextColor3 = color
                                            else
                                                HealthText.TextColor3 = Color
                                            end
									    else
										    HealthText.Visible = false
                                        end                        
                                    end
                                end

                                do -- Names
                                    if ESP.HighlightTeammates then
                                        Color = ESP.Names.TeamRainbow and ESP:GetRainbow() or ESP.Names.TeamRGB
                                    else
                                        Color = ESP.Names.Rainbow and ESP:GetRainbow() or ESP.Names.RGB
                                    end

								    local plrName = ESP.Names.NameType == "Display Name" and plr.DisplayName or plr.Name
                                    --plrBracName = not ESP.Names.Brackets == "None" and Brackets[ESP.Names.Brackets][1] .. plrName .. Brackets[ESP.Names.Brackets][2] or plrName
                                    if not ESP.Names.Brackets == "None" then
                                        plrBracName = Brackets[ESP.Names.Brackets][1] .. plrName .. Brackets[ESP.Names.Brackets][2] 
                                    else 
                                        plrBracName = plrName
                                    end
                                    --print(plrName)

                                    Name.Visible = ESP.Names.Enabled
                                    Name.FontFace = Fonts[ESP.Names.Font]
                                    Name.TextSize = ESP.Names.TextSize
                                    Name.Position = UDim2new(0, Pos.X, 0, Pos.Y - h / 2 - 9)
								    Name.TextColor3 = Color
                                end
                            
                                do -- Distance
                                    if ESP.Distances.Enabled then
                                        if ESP.HighlightTeammates then
                                            Color = ESP.Distances.TeamRainbow and ESP:GetRainbow() or ESP.Distances.TeamRGB
                                        else
                                            Color = ESP.Distances.Rainbow and ESP:GetRainbow() or ESP.Distances.RGB
                                        end

                                        --[[local plrName = ESP.Names.NameType == "Display Name" and plr.DisplayName or plr.Name
                                        local plrBracName = not ESP.Names.Brackets == "None" and Brackets[ESP.Names.Brackets][1] .. plrName .. Brackets[ESP.Names.Brackets][2] or plrName
                                        if not ESP.Names.Brackets == "None" then
                                            local plrBracName = Brackets[ESP.Names.Brackets][1] .. plrName .. Brackets[ESP.Names.Brackets][2] 
                                        else 
                                            plrBracName = plrName
                                        end]]

                                        if ESP.Distances.Position == "Bottom" then
                                            local DistanceNum = not ESP.Distances.Brackets == "None" and Brackets[ESP.Distances.Brackets][1] .. Floor(Dist) .. Brackets[ESP.Distances.Brackets][2] 

                                            Weapon.Position = UDim2new(0, Pos.X, 0, Pos.Y + h / 2 + 18)
                                            Distance.Position = UDim2new(0, Pos.X, 0, Pos.Y + h / 2 + 7)
                                            Distance.FontFace = Fonts[ESP.Distances.Font]
                                            Distance.TextSize = ESP.Distances.TextSize
                                            Distance.Text = Format("%d" .. ESP.Distances.Suffix, Floor(Dist))
                                            Distance.Visible = true
										    Distance.TextColor3 = Color
                                        elseif ESP.Distances.Position == "Text" then
                                            Weapon.Position = UDim2new(0, Pos.X, 0, Pos.Y + h / 2 + 8)
                                            Distance.Visible = false
                                            Name.Text = Format('%s [%d]', 255, 0, 0, plrBracName, Floor(Dist))
                                            Name.Visible = ESP.Names.Enabled
                                        end
								    else
									    Distance.Visible = false
                                    end
                                end

                                do -- Weapons
								    local tool = FFCOC(character, "Tool")
                                    if tool then
                                        if not ESP.Weapons.Brackets == "None" then
                                            ToolName = Brackets[ESP.Weapons.Brackets][1] .. tool.Name .. Brackets[ESP.Weapons.Brackets][2]
                                        else
                                            ToolName = tool.Name
                                        end
                                    else
                                        ToolName = "Nothing"
                                    end

                                    if ESP.HighlightTeammates then
                                        Color = ESP.Weapons.TeamRainbow and ESP:GetRainbow() or ESP.Weapons.TeamRGB
                                    else
                                        Color = ESP.Weapons.Rainbow and ESP:GetRainbow() or ESP.Weapons.RGB
                                    end

                                    Weapon.Text = ToolName
								    Weapon.TextColor3 = Color
                                    Weapon.FontFace = Fonts[ESP.Weapons.Font]
                                    Weapon.TextSize = ESP.Weapons.TextSize
                                    Weapon.Visible = ESP.Weapons.Enabled
                                end

							    if ESP.Boxes.Filled.GradientFill then
								    Gradient1.Enabled = true
                    			    Gradient1.Color = CSnew{CSKnew(0, ESP.Boxes.Filled.GradientFillRGB1), CSKnew(1, ESP.Boxes.Filled.GradientFillRGB2)}
                			    else
								    Gradient1.Enabled = false
                    			    Gradient1.Color = CSnew{CSKnew(0, ESP.Boxes.Filled.RGB), CSKnew(1, ESP.Boxes.Filled.RGB)}
                			    end
                			    if ESP.Boxes.Gradient then
								    Gradient2.Enabled = true
                    			    Gradient2.Color = CSnew{CSKnew(0, ESP.Boxes.GradientRGB1), CSKnew(1, ESP.Boxes.GradientRGB2)}
                			    else
								    Gradient2.Enabled = false
                    			    Gradient2.Color = CSnew{CSKnew(0, ESP.Boxes.RGB), CSKnew(1, ESP.Boxes.RGB)}
                			    end
                            end
                        else
                            HideESP();
                        end
                    end
                    --[[ man i am so bad at coding... don't know how to get this working bc of the code
                    else
                        if ESP.FadeOut.OnDeath then
						    print("Fading out on death...")
                            for _, element in ScreenGui[plr.Name]:GetChildren() do
                                if not element:IsA("Highlight") then
                                    ESP:FadeOutOnDeath(element)
                                end
                            end
					    else
                    	    HideESP();
                        end
                    end]]
                IsEnabled();
            end)
            if not Tblfind(ESP.Loops, Connection) then
                Tblinsert(ESP.Loops, Connection)
            end
        end
        local UpdateCoroutine = Wrap(Updater)();
        if not Tblfind(ESP.Coroutines, UpdateCoroutine) then
		    Tblinsert(ESP.Coroutines, UpdateCoroutine);
        end
    end
    do -- Update ESP
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Name ~= lplayer.Name then
                local ESPCoroutine = Wrap(CreateESP)(v);
				if not ESP.Coroutines[v.Name] then
					ESP.Coroutines[v.Name] = {}
				end
                if not Tblfind(ESP.Coroutines[v.Name], ESPCoroutine) then
				    Tblinsert(ESP.Coroutines[v.Name], ESPCoroutine);
                end
            end      
        end
        --
        game:GetService("Players").PlayerAdded:Connect(function(plr)
            local ESPCoroutine = Wrap(CreateESP)(plr);
            if not ESP.Coroutines[plr.Name] then
				ESP.Coroutines[plr.Name] = {}
			end
            if not Tblfind(ESP.Coroutines[plr.Name], ESPCoroutine) then
				Tblinsert(ESP.Coroutines[plr.Name], ESPCoroutine);
            end
        end);
        --
		game:GetService("Players").PlayerRemoving:Connect(function(v)
            --ESP:RemoveESP(v)
			for _, coroutine in ESP.Coroutines[v.Name] do
				Yield(coroutine)
			end;
            --
            if ScreenGui then
                ScreenGui[v.Name]:Destroy()
            end;
            --
            if SkeletonLines[v.Name] ~= nil then
                for _, lines in SkeletonLines[v.Name] do
                    lines:Destroy()
                end
            end
        end)
    end;
end;

print("If you see this, it means the ESP has loaded correctly. Enjoy.")

if ESP.Demo then
    ESP:Demo(true)
    ESP.TeamCheck = false
    ESP.HealthBar.Gradient = true
    ESP.HealthBar.RainbowGradient = true
end

return ESP
