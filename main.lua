--[[
original: https://github.com/krampus-organization/releases/blob/main/ESP.lua
]]

local cloneref = cloneref or function(v)
    return v
end

local function gs(service)
    return game:GetService(service)
end

local Workspace, RunService, Players, CoreGui, Lighting = cloneref(gs("Workspace")), cloneref(gs("RunService")), cloneref(gs("Players")), gs("CoreGui"), cloneref(gs("Lighting"))
local Instancenew, Color3RGB = Instance.new, Color3.fromRGB
--[[local Tool = {}

for _,v in pairs(Players:GetPlayers()) do
    if v ~= Players.LocalPlayer then
        Tool[v.Name] = "n/a"
    end
end]]

getgenv().ESP = {}

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
        FriendCheck = true, FriendCheckRGB = Color3RGB(0, 255, 0),
        Highlight = false, HighlightRGB = Color3RGB(255, 0, 0),
    },
    Chams = {
        Enabled = false,
        Thermal = true,
        FillRGB = Color3RGB(119, 120, 255),
        FillTransparency = 100,
        OutlineRGB = Color3RGB(119, 120, 255),
        OutlineTransparency = 100,
        VisibleCheck = true,
    },
    Names = {
        Enabled = false,
        RGB = Color3RGB(255, 255, 255),
    },
    Flags = {
        Enabled = false,
    },
    Distances = {
        Enabled = false, 
        Position = "Text",
        RGB = Color3RGB(255, 255, 255),
    },
    Weapons = { -- doesn't work for now, might be fixed later
        Enabled = false, WeaponTextRGB = Color3RGB(119, 120, 255),
        Outlined = false,
        Gradient = false,
        GradientRGB1 = Color3RGB(255, 255, 255), GradientRGB2 = Color3RGB(119, 120, 255),
    },
    HealthBar = {
        Enabled = false,
        RGB = Color3.fromRGB(0, 255, 0),
        HealthText = false, Lerp = false, HealthTextRGB = Color3RGB(255, 255, 255),
        Width = 2.5,
        Gradient = true, GradientRGB1 = Color3RGB(200, 0, 0), GradientRGB2 = Color3RGB(60, 60, 125), GradientRGB3 = Color3RGB(119, 120, 255), 
    },
    Boxes = {
        Animate = false,
        RotationSpeed = 300,
        Gradient = false, GradientRGB1 = Color3RGB(119, 120, 255), GradientRGB2 = Color3RGB(0, 0, 0), 
        GradientFill = false, GradientFillRGB1 = Color3RGB(119, 120, 255), GradientFillRGB2 = Color3RGB(0, 0, 0), 
        
        Filled = {
            Enabled = false,
            Transparency = 0.75,
            RGB = Color3RGB(0, 0, 0),
        },
        Full = {
            Enabled = false,
            RGB = Color3RGB(255, 255, 255),
        },
        Corner = {
            Enabled = false,
            RGB = Color3RGB(255, 255, 255),
        },
    };
    Connections = {
        RunService = RunService;
    };
    Fonts = {};
}

-- Def & Vars
local Euphoria = ESP.Connections;
local lplayer = Players.LocalPlayer;
local camera = game.Workspace.CurrentCamera;
local Cam = Workspace.CurrentCamera;
local RotationAngle, Tick = -45, tick();

-- Weapon Images
local Weapon_Icons = {
    ["Wooden Bow"] = "http://www.roblox.com/asset/?id=17677465400",
    ["Crossbow"] = "http://www.roblox.com/asset/?id=17677473017",
    ["Salvaged SMG"] = "http://www.roblox.com/asset/?id=17677463033",
    ["Salvaged AK47"] = "http://www.roblox.com/asset/?id=17677455113",
    ["Salvaged AK74u"] = "http://www.roblox.com/asset/?id=17677442346",
    ["Salvaged M14"] = "http://www.roblox.com/asset/?id=17677444642",
    ["Salvaged Python"] = "http://www.roblox.com/asset/?id=17677451737",
    ["Military PKM"] = "http://www.roblox.com/asset/?id=17677449448",
    ["Military M4A1"] = "http://www.roblox.com/asset/?id=17677479536",
    ["Bruno's M4A1"] = "http://www.roblox.com/asset/?id=17677471185",
    ["Military Barrett"] = "http://www.roblox.com/asset/?id=17677482998",
    ["Salvaged Skorpion"] = "http://www.roblox.com/asset/?id=17677459658",
    ["Salvaged Pump Action"] = "http://www.roblox.com/asset/?id=17677457186",
    ["Military AA12"] = "http://www.roblox.com/asset/?id=17677475227",
    ["Salvaged Break Action"] = "http://www.roblox.com/asset/?id=17677468751",
    ["Salvaged Pipe Rifle"] = "http://www.roblox.com/asset/?id=17677468751",
    ["Salvaged P250"] = "http://www.roblox.com/asset/?id=17677447257",
    ["Nail Gun"] = "http://www.roblox.com/asset/?id=17677484756"
};

-- Functions
local Functions = {}
do
    function Functions:Create(Class, Properties)
        local _Instance = typeof(Class) == 'string' and Instancenew(Class) or Class
        for Property, Value in pairs(Properties) do
            _Instance[Property] = Value
        end
        return _Instance;
    end
    --
    function Functions:FadeOutOnDist(element, distance)
        local transparency = math.max(0.1, 1 - (distance / ESP.MaxDistance))
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
end;

do -- Initalize
    local ScreenGui = Functions:Create("ScreenGui", {
        Parent = CoreGui,
        Name = "ESPHolder",
    });

    local function CreateFolder(name)
        if not ScreenGui:FindFirstChild(name) then
            local Folder = Functions:Create("Folder", {Name = name, Parent = ScreenGui})
        end
    end
    
    --[[local function CheckForPlayers()
        local plrtbl = {}
        --local plrstr = ""
        for _,v in pairs(Players:GetPlayers()) do
            if v ~= lplayer then
                table.insert(plrtbl, v.Name)
            end
        end
        
        for _,v in pairs(plrtbl) do
            if not ScreenGui:FindFirstChild(v) then
                CreateFolder(v)
            end
        end
        --[[plrstr = table.concat(plrtbl, " ")
        print(plrstr)]]
        
        

        --[[for _,v in pairs(ScreenGui:GetChildren()) do
            if not string.find(plrstr, v.Name) then
                v:Destroy()
            end
        end
    end]]

    for _,v in pairs(Players:GetPlayers()) do
        if v ~= lplayer then
            CreateFolder(v.Name)
        end
    end

    function ESP:Unload()
        if ScreenGui then
            ScreenGui:Destroy()
            ESP = nil
        end
    end

    --[[local function AddSignal(plr)

        game.Players[plr.Name].Backpack.ChildAdded:Connect(function(v)
            if v:IsA("Tool") then
                print(plr.Name .. " has unequipped " .. v.Name)
                Tool[plr.Name] = "none"
            end
        end)

        game.Players[plr.Name].Backpack.ChildRemoved:Connect(function(v)
            if v:IsA("Tool") and not v.Name == "Tool" then
                print(plr.Name .. " has equipped " .. v.Name)
                Tool[plr.Name] = v.Name
            end
        end)
    end

    for _,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer then
            AddSignal(v)
        end
    end

    game.Players.PlayerAdded:Connect(function(v)
        AddSignal(v)
    end)]]

    local ESP = function(plr)
        print(plr.Name)
        coroutine.wrap(CreateFolder)(plr.Name)
        --coroutine.wrap(DupeCheck)(plr) -- Dupecheck
        local Name = Functions:Create("TextLabel", {Name = "Name", Parent = ScreenGui[plr.Name], Position = UDim2.new(0.5, 0, 0, -11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3RGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3RGB(0, 0, 0), RichText = true})
        local Distance = Functions:Create("TextLabel", {Name = "Distance", Parent = ScreenGui[plr.Name], Position = UDim2.new(0.5, 0, 0, 11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3RGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3RGB(0, 0, 0), RichText = true})
        local Weapon = Functions:Create("TextLabel", {Name = "Weapon", Parent = ScreenGui[plr.Name], Position = UDim2.new(0.5, 0, 0, 31), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3RGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3RGB(0, 0, 0), RichText = true})
        local Box = Functions:Create("Frame", {Name = "Box", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(0, 0, 0), BackgroundTransparency = 0.75, BorderSizePixel = 0})
        local Gradient1 = Functions:Create("UIGradient", {Name = "1stBoxGradient", Parent = Box, Enabled = ESP.Boxes.GradientFill, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Boxes.GradientFillRGB1), ColorSequenceKeypoint.new(1, ESP.Boxes.GradientFillRGB2)}})
        local Outline = Functions:Create("UIStroke", {Name = "BoxOutline", Parent = Box, Enabled = ESP.Boxes.Gradient, Transparency = 0, Color = Color3RGB(255, 255, 255), LineJoinMode = Enum.LineJoinMode.Miter})
        local Gradient2 = Functions:Create("UIGradient", {Name = "2ndBoxGradient", Parent = Outline, Enabled = ESP.Boxes.Gradient, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Boxes.GradientRGB1), ColorSequenceKeypoint.new(1, ESP.Boxes.GradientRGB2)}})
        local HealthBar = Functions:Create("Frame", {Name = "HealthBar", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(255, 255, 255), BackgroundTransparency = 0})
        local BehindHealthBar = Functions:Create("Frame", {Name = "BehindHealthBar", Parent = ScreenGui[plr.Name], ZIndex = -1, BackgroundColor3 = Color3RGB(0, 0, 0), BackgroundTransparency = 0})
        local HealthBarGradient = Functions:Create("UIGradient", {Name = "HealthBarGradient", Parent = HealthBar, Enabled = ESP.HealthBar.Gradient, Rotation = -90, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.HealthBar.GradientRGB1), ColorSequenceKeypoint.new(0.5, ESP.HealthBar.GradientRGB2), ColorSequenceKeypoint.new(1, ESP.HealthBar.GradientRGB3)}})
        local HealthText = Functions:Create("TextLabel", {Name = "HealthText", Parent = ScreenGui[plr.Name], Position = UDim2.new(0.5, 0, 0, 31), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3RGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3RGB(0, 0, 0)})
        local Chams = Functions:Create("Highlight", {Name = "Chams", Parent = ScreenGui[plr.Name], FillTransparency = 1, OutlineTransparency = 0, OutlineColor = Color3RGB(119, 120, 255), DepthMode = "AlwaysOnTop"})
        local WeaponIcon = Functions:Create("ImageLabel", {Name = "WeaponIcon", Parent = ScreenGui[plr.Name], BackgroundTransparency = 1, BorderColor3 = Color3RGB(0, 0, 0), BorderSizePixel = 0, Size = UDim2.new(0, 40, 0, 40)})
        local Gradient3 = Functions:Create("UIGradient", {Name = "3rdBoxGradient", Parent = WeaponIcon, Rotation = -90, Enabled = ESP.Weapons.Gradient, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Weapons.GradientRGB1), ColorSequenceKeypoint.new(1, ESP.Weapons.GradientRGB2)}})
        local LeftTop = Functions:Create("Frame", {Name = "TopLeftBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local LeftSide = Functions:Create("Frame", {Name = "LeftSideBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local RightTop = Functions:Create("Frame", {Name = "TopRightBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local RightSide = Functions:Create("Frame", {Name = "RightSideBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomSide = Functions:Create("Frame", {Name = "BottomSideBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomDown = Functions:Create("Frame", {Name = "BottomDownBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomRightSide = Functions:Create("Frame", {Name = "RightBottomSideBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomRightDown = Functions:Create("Frame", {Name = "RightBottomDownBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local Flag1 = Functions:Create("TextLabel", {Name = "Flag1", Parent = ScreenGui[plr.Name], Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3RGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3RGB(0, 0, 0)})
        local Flag2 = Functions:Create("TextLabel", {Name = "Flag2", Parent = ScreenGui[plr.Name], Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3RGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3RGB(0, 0, 0)})
        --local DroppedItems = Functions:Create("TextLabel", {Parent = ScreenGui[plr.Name], AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3RGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3RGB(0, 0, 0)})
        --
        local Updater = function()
            local Connection;
            local function HideESP()
                --if bool then
                    Box.Visible = false;
                    Name.Visible = false;
                    Distance.Visible = false;
                    Weapon.Visible = false;
                    HealthBar.Visible = false;
                    BehindHealthBar.Visible = false;
                    HealthText.Visible = false;
                    WeaponIcon.Visible = false;
                    LeftTop.Visible = false;
                    LeftSide.Visible = false;
                    BottomSide.Visible = false;
                    BottomDown.Visible = false;
                    RightTop.Visible = false;
                    RightSide.Visible = false;
                    BottomRightSide.Visible = false;
                    BottomRightDown.Visible = false;
                    Flag1.Visible = false;
                    Chams.Enabled = false;
                    Flag2.Visible = false;
                    if not plr then
                        ScreenGui:Destroy();
                        Connection:Disconnect();
                    end
                --[[else
                    Box.Visible = ESP.Boxes.Full.Enabled;
                    Name.Visible = ESP.Names.Enabled;
                    Distance.Visible = ESP.Distances.Enabled;
                    Weapon.Visible = ESP.Weapons.Enabled;
                    HealthBar.Visible = ESP.HealthBar.Enabled;
                    BehindHealthBar.Visible = ESP.HealthBar.Enabled;
                    HealthText.Visible = ESP.HealthBar.HealthText;
                    WeaponIcon.Visible = ESP.Weapons.Enabled;
                    LeftTop.Visible = ESP.Boxes.Corner.Enabled;
                    LeftSide.Visible = ESP.Boxes.Corner.Enabled;
                    BottomSide.Visible = ESP.Boxes.Corner.Enabled;
                    BottomDown.Visible = ESP.Boxes.Corner.Enabled;
                    RightTop.Visible = ESP.Boxes.Corner.Enabled;
                    RightSide.Visible = ESP.Boxes.Corner.Enabled;
                    BottomRightSide.Visible = ESP.Boxes.Corner.Enabled;
                    BottomRightDown.Visible = ESP.Boxes.Corner.Enabled;
                    Flag1.Visible = ESP.Flags.Enabled;
                    Chams.Enabled = ESP.Chams.Enabled;
                    Flag2.Visible = ESP.Flags.Enabled;
                    if not plr then
                        ScreenGui[plr.Name]:Destroy();
                        Connection:Disconnect();
                    end
                end]]
            end

            local function IsEnabled()
                if not ESP.Enabled then
                    ScreenGui.Enabled = false
                else
                    ScreenGui.Enabled = true
                end
            end

            local function UpdateGradients()
                if ESP.Boxes.GradientFill then
                    Gradient1.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Boxes.GradientFillRGB1), ColorSequenceKeypoint.new(1, ESP.Boxes.GradientFillRGB2)}
                else
                    Gradient1.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Boxes.Filled.RGB), ColorSequenceKeypoint.new(1, ESP.Boxes.Filled.RGB)}
                end
                if ESP.Boxes.Gradient then
                    Gradient2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Boxes.GradientRGB1), ColorSequenceKeypoint.new(1, ESP.Boxes.GradientRGB2)}
                else
                    Gradient2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Boxes.Corner.RGB), ColorSequenceKeypoint.new(1, ESP.Boxes.Corner.RGB)}
                end
                if ESP.HealthBar.Gradient then
                    HealthBarGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.HealthBar.GradientRGB1), ColorSequenceKeypoint.new(0.5, ESP.HealthBar.GradientRGB2), ColorSequenceKeypoint.new(1, ESP.HealthBar.GradientRGB3)}
                else
                    HealthBarGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.HealthBar.RGB), ColorSequenceKeypoint.new(0.5, ESP.HealthBar.RGB), ColorSequenceKeypoint.new(1, ESP.HealthBar.RGB)}
                end
            end
            
            Connection = Euphoria.RunService.RenderStepped:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local HRP = plr.Character.HumanoidRootPart
                    local Humanoid = plr.Character:WaitForChild("Humanoid");
                    local Pos, OnScreen = Cam:WorldToScreenPoint(HRP.Position)
                    local Dist = (Cam.CFrame.Position - HRP.Position).Magnitude / 3.5714285714
                    
                    if OnScreen and Dist <= ESP.MaxDistance then
                        local Size = HRP.Size.Y
                        local scaleFactor = (Size * Cam.ViewportSize.Y) / (Pos.Z * 2)
                        local w, h = 3 * scaleFactor, 4.5 * scaleFactor

                        -- Fade-out effect --
                        if ESP.FadeOut.OnDistance then
                            Functions:FadeOutOnDist(Box, Dist)
                            Functions:FadeOutOnDist(Outline, Dist)
                            Functions:FadeOutOnDist(Name, Dist)
                            Functions:FadeOutOnDist(Distance, Dist)
                            Functions:FadeOutOnDist(Weapon, Dist)
                            Functions:FadeOutOnDist(HealthBar, Dist)
                            Functions:FadeOutOnDist(BehindHealthBar, Dist)
                            Functions:FadeOutOnDist(HealthText, Dist)
                            Functions:FadeOutOnDist(WeaponIcon, Dist)
                            Functions:FadeOutOnDist(LeftTop, Dist)
                            Functions:FadeOutOnDist(LeftSide, Dist)
                            Functions:FadeOutOnDist(BottomSide, Dist)
                            Functions:FadeOutOnDist(BottomDown, Dist)
                            Functions:FadeOutOnDist(RightTop, Dist)
                            Functions:FadeOutOnDist(RightSide, Dist)
                            Functions:FadeOutOnDist(BottomRightSide, Dist)
                            Functions:FadeOutOnDist(BottomRightDown, Dist)
                            Functions:FadeOutOnDist(Chams, Dist)
                            Functions:FadeOutOnDist(Flag1, Dist)
                            Functions:FadeOutOnDist(Flag2, Dist)
                        end

                        -- Teamcheck
                        if ESP.TeamCheck and plr ~= lplayer and ((lplayer.Team ~= plr.Team and plr.Team) or (not lplayer.Team and not plr.Team)) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") then

                            do -- Chams
                                Chams.Adornee = plr.Character
                                Chams.Enabled = ESP.Chams.Enabled
                                Chams.FillColor = ESP.Chams.FillRGB
                                Chams.OutlineColor = ESP.Chams.OutlineRGB
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

                            do -- Corner Boxes
                                LeftTop.Visible = ESP.Boxes.Corner.Enabled
                                LeftTop.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                LeftTop.Size = UDim2.new(0, w / 5, 0, 1)
                                
                                LeftSide.Visible = ESP.Boxes.Corner.Enabled
                                LeftSide.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                LeftSide.Size = UDim2.new(0, 1, 0, h / 5)
                                
                                BottomSide.Visible = ESP.Boxes.Corner.Enabled
                                BottomSide.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                BottomSide.Size = UDim2.new(0, 1, 0, h / 5)
                                BottomSide.AnchorPoint = Vector2.new(0, 5)
                                
                                BottomDown.Visible = ESP.Boxes.Corner.Enabled
                                BottomDown.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                BottomDown.Size = UDim2.new(0, w / 5, 0, 1)
                                BottomDown.AnchorPoint = Vector2.new(0, 1)
                                
                                RightTop.Visible = ESP.Boxes.Corner.Enabled
                                RightTop.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y - h / 2)
                                RightTop.Size = UDim2.new(0, w / 5, 0, 1)
                                RightTop.AnchorPoint = Vector2.new(1, 0)
                                
                                RightSide.Visible = ESP.Boxes.Corner.Enabled
                                RightSide.Position = UDim2.new(0, Pos.X + w / 2 - 1, 0, Pos.Y - h / 2)
                                RightSide.Size = UDim2.new(0, 1, 0, h / 5)
                                RightSide.AnchorPoint = Vector2.new(0, 0)
                                
                                BottomRightSide.Visible = ESP.Boxes.Corner.Enabled
                                BottomRightSide.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y + h / 2)
                                BottomRightSide.Size = UDim2.new(0, 1, 0, h / 5)
                                BottomRightSide.AnchorPoint = Vector2.new(1, 1)
                                
                                BottomRightDown.Visible = ESP.Boxes.Corner.Enabled
                                BottomRightDown.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y + h / 2)
                                BottomRightDown.Size = UDim2.new(0, w / 5, 0, 1)
                                BottomRightDown.AnchorPoint = Vector2.new(1, 1)                                                            
                            end

                            do -- Boxes
                                Box.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                Box.Size = UDim2.new(0, w, 0, h)
                                Box.Visible = ESP.Boxes.Full.Enabled;

                                -- Gradient
                                if ESP.Boxes.Filled.Enabled then
                                    Box.BackgroundColor3 = Color3RGB(255, 255, 255)
                                    if ESP.Boxes.GradientFill then
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
                                if ESP.Boxes.Animate then
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
                                local health = Humanoid.Health / Humanoid.MaxHealth;
                                HealthBar.Visible = ESP.HealthBar.Enabled;
                                HealthBar.Position = UDim2.new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2 + h * (1 - health))  
                                HealthBar.Size = UDim2.new(0, ESP.HealthBar.Width, 0, h * health)  
                                --
                                BehindHealthBar.Visible = ESP.HealthBar.Enabled;
                                BehindHealthBar.Position = UDim2.new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2)  
                                BehindHealthBar.Size = UDim2.new(0, ESP.HealthBar.Width, 0, h)
                                -- Health Text
                                do
                                    if ESP.HealthBar.HealthText then
                                        local healthPercentage = math.floor(Humanoid.Health / Humanoid.MaxHealth * 100)
                                        HealthText.Position = UDim2.new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2 + h * (1 - healthPercentage / 100) + 3)
                                        HealthText.Text = tostring(healthPercentage)
                                        HealthText.Visible = Humanoid.Health < Humanoid.MaxHealth
                                        if ESP.HealthBar.Lerp then
                                            local color = health >= 0.75 and Color3RGB(0, 255, 0) or health >= 0.5 and Color3RGB(255, 255, 0) or health >= 0.25 and Color3RGB(255, 170, 0) or Color3RGB(255, 0, 0)
                                            HealthText.TextColor3 = color
                                        else
                                            HealthText.TextColor3 = ESP.HealthBar.HealthTextRGB
                                        end
                                    end                        
                                end
                            end

                            do -- Names
                                Name.Visible = ESP.Names.Enabled
                                if ESP.Options.FriendCheck and lplayer:IsFriendsWith(plr.UserId) then
                                    Name.Text = string.format('(<font color="rgb(%d, %d, %d)">F</font>) %s', ESP.Options.FriendCheckRGB.R * 255, ESP.Options.FriendCheckRGB.G * 255, ESP.Options.FriendCheckRGB.B * 255, plr.Name)
                                else
                                    Name.Text = string.format('(<font color="rgb(%d, %d, %d)">E</font>) %s', 255, 0, 0, plr.Name)
                                end
                                Name.Position = UDim2.new(0, Pos.X, 0, Pos.Y - h / 2 - 9)
                            end
                            
                            do -- Distance
                                if ESP.Distances.Enabled then
                                    if ESP.Distances.Position == "Bottom" then
                                        Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 18)
                                        WeaponIcon.Position = UDim2.new(0, Pos.X - 21, 0, Pos.Y + h / 2 + 15);
                                        Distance.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 7)
                                        Distance.Text = string.format("%d meters", math.floor(Dist))
                                        Distance.Visible = true
                                    elseif ESP.Distances.Position == "Text" then
                                        Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 8)
                                        WeaponIcon.Position = UDim2.new(0, Pos.X - 21, 0, Pos.Y + h / 2 + 5);
                                        Distance.Visible = false
                                        if ESP.Options.FriendCheck and lplayer:IsFriendsWith(plr.UserId) then
                                            Name.Text = string.format('(<font color="rgb(%d, %d, %d)">F</font>) %s [%d]', ESP.Options.FriendCheckRGB.R * 255, ESP.Options.FriendCheckRGB.G * 255, ESP.Options.FriendCheckRGB.B * 255, plr.Name, math.floor(Dist))
                                        else
                                            Name.Text = string.format('(<font color="rgb(%d, %d, %d)">E</font>) %s [%d]', 255, 0, 0, plr.Name, math.floor(Dist))
                                        end
                                        Name.Visible = ESP.Names.Enabled
                                    end
                                end
                            end

                            do -- Weapons
                                Weapon.Text = "" --Tool[plr.Name]
                                --Weapon.Visible = ESP.Weapons.Enabled
                            end                            
                        else
                            HideESP();
                        end
                    else
                        HideESP();
                    end
                else
                    HideESP();
                end
                IsEnabled();
                UpdateGradients();
                --CheckForPlayers();
            end)
        end
        coroutine.wrap(Updater)();
    end
    do -- Update ESP
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Name ~= lplayer.Name then
                coroutine.wrap(ESP)(v)
            end      
        end
        --
        game:GetService("Players").PlayerAdded:Connect(function(v)
            print("New player: ".. v.Name)
            coroutine.wrap(ESP)(v)
        end);
    end;
end;

return ESP
