--[[
original:
https://github.com/krampus-organization/releases/blob/main/ESP.lua
]]

local cloneref = not identifyexecutor() == "Celery" and cloneref or function(v)
    return v
end

local function gs(service)
    return game:GetService(service)
end

local Workspace, RunService, Players, HttpService, CoreGui, Lighting = cloneref(gs("Workspace")), cloneref(gs("RunService")), cloneref(gs("Players")), cloneref(gs("HttpService")), gs("CoreGui"), cloneref(gs("Lighting"))
local Instancenew, Wrap, Floor, Max, Color3RGB, Color3HSV, Vec2new, Vec3new, UDim2new, CSnew, CSKnew, Drawingnew = Instance.new, coroutine.wrap, math.floor, math.max, Color3.fromRGB, Color3.fromHSV, Vector2.new, Vector3.new, UDim2.new, ColorSequence.new, ColorSequenceKeypoint.new, Drawing.new

getgenv().ESP = {
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
    --[[Flags = { -- mostly useless
        Enabled = false,
    },]]
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
	--[[ -- will probably come soon
	Tracers = {
		Enabled = false,
		RGB = Color3RGB(255, 255, 255), Rainbow = false,
		Transparency = 0,
	};
	Arrows = {
		Enabled = false,
		RGB = Color3RGB(255, 255, 255), Rainbow = false,
		Radius = 100,
		Transparency = 0
	};
	ViewAngles = {
		Enabled = false,
		RGB = Color3RGB(255, 255, 255), Rainbow = false,
		Transparency = 0.2,
	};]]
    Connections = {
        RunService = RunService;
    };
	Coroutines = {};
    Fonts = {};
}

-- Def & Vars
local Euphoria = ESP.Connections;
local lplayer = Players.LocalPlayer;
local Cam = Workspace.CurrentCamera;
local RotationAngle, Tick = -45, tick();
local Folders = {};
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
        elseif element:IsA("Frame") and (element == HealthBar) then
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
        	if element:IsA("TextLabel") then
            	element.TextTransparency = 1 - transparency
        	elseif element:IsA("ImageLabel") then
            	element.ImageTransparency = 1 - transparency
        	elseif element:IsA("UIStroke") then
            	element.Transparency = 1 - transparency
        	elseif element:IsA("Frame") and (element == HealthBar) then
            	element.BackgroundTransparency = 1 - transparency
        	elseif element:IsA("Frame") then
           		element.BackgroundTransparency = 1 - transparency
        	elseif element:IsA("Highlight") then
            	element.FillTransparency = 1 - transparency
            	element.OutlineTransparency = 1 - transparency
        	end;
		until transparency == 1
    end;  
end;

do -- Initalize

    local ScreenGui = Functions:Create("ScreenGui", {
        Parent = CoreGui,
        Name = "ESPHolder",
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
		-- copied from exunys
		return Color3HSV(tick() % ESP.RainbowSpeed / ESP.RainbowSpeed, 1, 1)
	end

	function ESP:Demo(state)
		ESP.Enabled = state
		ESP.Boxes.Full.Enabled = state
		ESP.Boxes.Corner.Enabled = state
		ESP.Names.Enabled = state
		ESP.Distances.Enabled = state
		ESP.HealthBar.Enabled = state
		ESP.HealthBar.HealthText = state
		ESP.Chams.Enabled = state
		ESP.Skeleton.Enabled = state
		ESP.Weapons.Enabled = state
	end

	-- broken, don't use
    function ESP:Unload()
        if ScreenGui then
            ScreenGui:Destroy()
            ESP = nil
			cleardrawcache()
			Folders = nil
			Connection:Disconnect()
			Connection = nil

			for _, cor in ESP.Coroutines do
				-- lolol idk how the fuck coroutines work
				coroutine.yield(cor)
			end
        end
    end

    local CreateESP = function(plr)
        local FolderCoroutine = Wrap(CreateFolder)(plr.Name)
		table.insert(ESP.Coroutines, FolderCoroutine)

        local Name = Functions:Create("TextLabel", {Name = "Name", Parent = ScreenGui[plr.Name], Text = plr.Name, Position = UDim2new(0.5, 0, 0, -11), Size = UDim2new(0, 100, 0, 20), AnchorPoint = Vec2new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3RGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3RGB(0, 0, 0), RichText = true})
        local Distance = Functions:Create("TextLabel", {Name = "Distance", Parent = ScreenGui[plr.Name], Position = UDim2new(0.5, 0, 0, 11), Size = UDim2new(0, 100, 0, 20), AnchorPoint = Vec2new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3RGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3RGB(0, 0, 0), RichText = true})
        local Weapon = Functions:Create("TextLabel", {Name = "Weapon", Parent = ScreenGui[plr.Name], Position = UDim2new(0.5, 0, 0, 31), Size = UDim2new(0, 100, 0, 20), AnchorPoint = Vec2new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3RGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3RGB(0, 0, 0), RichText = true})
        local Box = Functions:Create("Frame", {Name = "Box", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(0, 0, 0), BackgroundTransparency = 0.75, BorderSizePixel = 0})
        local Gradient1 = Functions:Create("UIGradient", {Name = "1stBoxGradient", Parent = Box, Enabled = ESP.Boxes.GradientFill, Color = CSnew{CSKnew(0, ESP.Boxes.GradientFillRGB1), CSKnew(1, ESP.Boxes.GradientFillRGB2)}})
        local Outline = Functions:Create("UIStroke", {Name = "BoxOutline", Parent = Box, Enabled = ESP.Boxes.Gradient, Transparency = 0, Color = Color3RGB(255, 255, 255), LineJoinMode = Enum.LineJoinMode.Miter})
        local Gradient2 = Functions:Create("UIGradient", {Name = "2ndBoxGradient", Parent = Outline, Enabled = ESP.Boxes.Gradient, Color = CSnew{CSKnew(0, ESP.Boxes.GradientRGB1), CSKnew(1, ESP.Boxes.GradientRGB2)}})
        local HealthBar = Functions:Create("Frame", {Name = "HealthBar", Parent = ScreenGui[plr.Name], ZIndex = 2, BackgroundColor3 = ESP.HealthBar.RGB, BackgroundTransparency = 0})
        local HealthBarGradient = Functions:Create("UIGradient", {Name = "HealthBarGradient", Parent = HealthBar, Rotation = -90, Color = CSnew{CSKnew(0, ESP.HealthBar.GradientRGB1), CSKnew(0.5, ESP.HealthBar.GradientRGB2), CSKnew(1, ESP.HealthBar.GradientRGB3)}})
        local HealthText = Functions:Create("TextLabel", {Name = "HealthText", Parent = ScreenGui[plr.Name], Position = UDim2new(0.5, 0, 0, 31), Size = UDim2new(0, 100, 0, 20), AnchorPoint = Vec2new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3RGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3RGB(0, 0, 0)})
        local Chams = Functions:Create("Highlight", {Name = "Chams", Parent = ScreenGui[plr.Name], FillTransparency = 1, OutlineTransparency = 0, OutlineColor = Color3RGB(119, 120, 255), DepthMode = "AlwaysOnTop"})
        local LeftTop = Functions:Create("Frame", {Name = "TopLeftBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.Corner.RGB, Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 0})
        local LeftSide = Functions:Create("Frame", {Name = "LeftSideBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.Corner.RGB, Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 0})
        local RightTop = Functions:Create("Frame", {Name = "TopRightBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.Corner.RGB, Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 0})
        local RightSide = Functions:Create("Frame", {Name = "RightSideBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.Corner.RGB, Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 0})
        local BottomSide = Functions:Create("Frame", {Name = "BottomSideBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.Corner.RGB, Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 0})
        local BottomDown = Functions:Create("Frame", {Name = "BottomDownBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.Corner.RGB, Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 0})
        local BottomRightSide = Functions:Create("Frame", {Name = "RightBottomSideBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.Corner.RGB, Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 0})
        local BottomRightDown = Functions:Create("Frame", {Name = "RightBottomDownBoxCorner", Parent = ScreenGui[plr.Name], BackgroundColor3 = ESP.Boxes.Corner.RGB, Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 0})
        local LeftTopOut = Functions:Create("Frame", {Name = "TopLeftBoxCornerOut", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(0, 0, 0), Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 1, ZIndex = -2})
        local LeftSideOut = Functions:Create("Frame", {Name = "LeftSideBoxCornerOut", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(0, 0, 0), Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 1, ZIndex = -2})
        local RightTopOut = Functions:Create("Frame", {Name = "TopRightBoxCornerOut", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(0, 0, 0), Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 1, ZIndex = -2})
        local RightSideOut = Functions:Create("Frame", {Name = "RightSideBoxCornerOut", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(0, 0, 0), Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 1, ZIndex = -2})
        local BottomSideOut = Functions:Create("Frame", {Name = "BottomSideBoxCornerOut", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(0, 0, 0), Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 1, ZIndex = -2})
        local BottomDownOut = Functions:Create("Frame", {Name = "BottomDownBoxCornerOut", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(0, 0, 0), Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 1, ZIndex = -2})
        local BottomRightSideOut = Functions:Create("Frame", {Name = "RightBottomSideBoxCornerOut", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(0, 0, 0), Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 1, ZIndex = -2})
        local BottomRightDownOut = Functions:Create("Frame", {Name = "RightBottomDownBoxCornerOut", Parent = ScreenGui[plr.Name], BackgroundColor3 = Color3RGB(0, 0, 0), Position = UDim2new(0, 0, 0, 0), BorderSizePixel = 1, ZIndex = -2})
		--[[local Tracer = Functions:createDrawing("Line", {Visible = ESP.Tracers.Enabled, Thickness = 2, Color = ESP.Tracers.RGB})
		local TracerOut = Functions:createDrawing("Line", {Visible = ESP.Tracers.Enabled, Thickness = 3, Color = Color3RGB(0, 0, 0), ZIndex = -1})
		local Flag1 = Functions:Create("TextLabel", {Name = "Flag1", Parent = ScreenGui[plr.Name], Position = UDim2new(1, 0, 0, 0), Size = UDim2new(0, 100, 0, 20), AnchorPoint = Vec2new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3RGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3RGB(0, 0, 0)})
        local Flag2 = Functions:Create("TextLabel", {Name = "Flag2", Parent = ScreenGui[plr.Name], Position = UDim2new(1, 0, 0, 0), Size = UDim2new(0, 100, 0, 20), AnchorPoint = Vec2new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3RGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3RGB(0, 0, 0)})
		]]
		local SkeletonLines = {}

		--
        local Updater = function()
            local Connection;
            local function HideESP()
				for _, element in ScreenGui[plr.Name]:GetChildren() do
					if element:IsA("Highlight") then
						element.Enabled = false
					else
						element.Visible = false
					end
				end

				--[[Tracer.Visible = false
				TracerOut.Visible = false]]

				for _, line in SkeletonLines do
					line.Visible = false
				end

                if not plr then
                    ScreenGui:Destroy();
                    Connection:Disconnect();
					Tracer:Remove()

					for _, line in SkeletonLines do
						line:Remove()
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

            Connection = Euphoria.RunService.RenderStepped:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local character = plr.Character
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
							for _, element in ScreenGui[plr.Name]:GetChildren() do
								Functions:FadeOutOnDist(element, Dist)
							end

							--[[for _, line in SkeletonLines do
								Functions:FadeOutOnDist(line, Dist)
							end]]
                        end

                        -- Teamcheck
                        if ESP.TeamCheck and plr ~= lplayer and ((lplayer.Team ~= plr.Team and plr.Team) or (not lplayer.Team and not plr.Team)) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") then
							do -- Skeleton
								local connections = bodyConnections[Humanoid.RigType.Name] or {}

            					for _, connection in ipairs(connections) do
                					local partA = character:FindFirstChild(connection[1])
                					local partB = character:FindFirstChild(connection[2])
                					if partA and partB then
                    					local line = SkeletonLines[connection[1] .. "-" .. connection[2]] or Functions:createDrawing("Line", {Thickness = 1, Color = Color3RGB(255, 255, 255)})
										local posA, onScreenA = Cam:WorldToViewportPoint(partA.Position)
                    					local posB, onScreenB = Cam:WorldToViewportPoint(partB.Position)
                    					if onScreenA and onScreenB then
                        					line.From = Vec2new(posA.X, posA.Y)
                        					line.To = Vec2new(posB.X, posB.Y)
                        					line.Visible = ESP.Skeleton.Enabled
                        					SkeletonLines[connection[1] .. "-" .. connection[2]] = line
                    					else
                        					line.Visible = false
                   						end

										line.Color = ESP.Skeleton.Rainbow and ESP:GetRainbow() or ESP.Skeleton.RGB
										line.Thickness = ESP.Skeleton.Thickness
										line.Transparency = 1 - ESP.Skeleton.Transparency
                					end
            					end
							end	
							
							--[[do -- Tracers
								Tracer.Visible = ESP.Tracers.Enabled
								Tracer.Color = ESP.Tracers.Rainbow and ESP:GetRainbow() or ESP.Tracers.RGB
								Tracer.From = Vec2new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y)
								Tracer.To = Vec2new(Pos.X, Pos.Y)

								TracerOut.Visible = ESP.Tracers.Enabled
								TracerOut.From = Tracer.From
								TracerOut.To = Tracer.To
							end]]
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
							do -- Box Sides (will be made soon...)
							end
							--
                            do -- Box Corners
                                LeftTop.Visible = ESP.Boxes.Corner.Enabled
                                LeftTop.Position = UDim2new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                LeftTop.Size = UDim2new(0, w / 5, 0, 1)
								LeftTop.BackgroundColor3 = ESP.Boxes.Corner.Rainbow and ESP:GetRainbow() or ESP.Boxes.Corner.RGB
                                
								LeftTopOut.Visible = ESP.Boxes.Corner.Enabled
                                LeftTopOut.Position = LeftTop.Position
                                LeftTopOut.Size = LeftTop.Size

                                LeftSide.Visible = ESP.Boxes.Corner.Enabled
                                LeftSide.Position = UDim2new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                LeftSide.Size = UDim2new(0, 1, 0, h / 5)
								LeftSide.BackgroundColor3 = ESP.Boxes.Corner.Rainbow and ESP:GetRainbow() or ESP.Boxes.Corner.RGB
                                
								LeftSideOut.Visible = ESP.Boxes.Corner.Enabled
                                LeftSideOut.Position = LeftSide.Position
                                LeftSideOut.Size = LeftSide.Size

                                BottomSide.Visible = ESP.Boxes.Corner.Enabled
                                BottomSide.Position = UDim2new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                BottomSide.Size = UDim2new(0, 1, 0, h / 5)
								--BottomSide.Size = UDim2new(0, 1, LeftSide.Size.Y)
                                BottomSide.AnchorPoint = Vec2new(0, 5)
								BottomSide.BackgroundColor3 = ESP.Boxes.Corner.Rainbow and ESP:GetRainbow() or ESP.Boxes.Corner.RGB
                                
								BottomSideOut.Visible = ESP.Boxes.Corner.Enabled
                                BottomSideOut.Position = BottomSide.Position
                                BottomSideOut.Size = BottomSide.Size
                                BottomSideOut.AnchorPoint = Vec2new(0, 5)

                                BottomDown.Visible = ESP.Boxes.Corner.Enabled
                                BottomDown.Position = UDim2new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                BottomDown.Size = UDim2new(0, w / 5, 0, 1)
                                BottomDown.AnchorPoint = Vec2new(0, 1)
                                BottomDown.BackgroundColor3 = ESP.Boxes.Corner.Rainbow and ESP:GetRainbow() or ESP.Boxes.Corner.RGB

								BottomDownOut.Visible = ESP.Boxes.Corner.Enabled
                                BottomDownOut.Position = BottomDown.Position
                                BottomDownOut.Size = BottomDown.Size
                                BottomDownOut.AnchorPoint = Vec2new(0, 1)

                                RightTop.Visible = ESP.Boxes.Corner.Enabled
                                RightTop.Position = UDim2new(0, Pos.X + w / 2, 0, Pos.Y - h / 2)
                                RightTop.Size = UDim2new(0, w / 5, 0, 1)
                                RightTop.AnchorPoint = Vec2new(1, 0)
                                RightTop.BackgroundColor3 = ESP.Boxes.Corner.Rainbow and ESP:GetRainbow() or ESP.Boxes.Corner.RGB

								RightTopOut.Visible = ESP.Boxes.Corner.Enabled
                                RightTopOut.Position = RightTop.Position
                                RightTopOut.Size = RightTop.Size
                                RightTopOut.AnchorPoint = Vec2new(1, 0)

                                RightSide.Visible = ESP.Boxes.Corner.Enabled
                                RightSide.Position = UDim2new(0, Pos.X + w / 2 - 1, 0, Pos.Y - h / 2)
                                RightSide.Size = UDim2new(0, 1, 0, h / 5)
                                RightSide.AnchorPoint = Vec2new(0, 0)
                                RightSide.BackgroundColor3 = ESP.Boxes.Corner.Rainbow and ESP:GetRainbow() or ESP.Boxes.Corner.RGB
							
								RightSideOut.Visible = ESP.Boxes.Corner.Enabled
                                RightSideOut.Position = RightSide.Position
                                RightSideOut.Size = RightSide.Size
                                RightSideOut.AnchorPoint = Vec2new(0, 0)

                                BottomRightSide.Visible = ESP.Boxes.Corner.Enabled
                                BottomRightSide.Position = UDim2new(0, Pos.X + w / 2, 0, Pos.Y + h / 2)
                                BottomRightSide.Size = UDim2new(0, 1, 0, h / 5)
                                BottomRightSide.AnchorPoint = Vec2new(1, 1)
                                BottomRightSide.BackgroundColor3 = ESP.Boxes.Corner.Rainbow and ESP:GetRainbow() or ESP.Boxes.Corner.RGB

								BottomRightSideOut.Visible = ESP.Boxes.Corner.Enabled
                                BottomRightSideOut.Position = BottomRightSide.Position
                                BottomRightSideOut.Size = BottomRightSide.Size
                                BottomRightSideOut.AnchorPoint = Vec2new(1, 1)

                                BottomRightDown.Visible = ESP.Boxes.Corner.Enabled
                                BottomRightDown.Position = UDim2new(0, Pos.X + w / 2, 0, Pos.Y + h / 2)
                                BottomRightDown.Size = UDim2new(0, w / 5, 0, 1)
                                BottomRightDown.AnchorPoint = Vec2new(1, 1) 
								BottomRightDown.BackgroundColor3 = ESP.Boxes.Corner.Rainbow and ESP:GetRainbow() or ESP.Boxes.Corner.RGB                                                           
                            
								BottomRightDownOut.Visible = ESP.Boxes.Corner.Enabled
                                BottomRightDownOut.Position = BottomRightDown.Position
                                BottomRightDownOut.Size = BottomRightDown.Size
                                BottomRightDownOut.AnchorPoint = Vec2new(1, 1) 
							
							end

                            do -- Boxes
                                Box.Position = UDim2new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                Box.Size = UDim2new(0, w, 0, h)
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
                                HealthBar.Position = UDim2new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2 + h * (1 - health))  
                                HealthBar.Size = UDim2new(0, ESP.HealthBar.Width, 0, h * health)
								if not ESP.HealthBar.Gradient then 
									HealthBar.BackgroundColor3 = ESP.HealthBar.Rainbow and ESP:GetRainbow() or ESP.HealthBar.RGB 
                                else
									HealthBar.BackgroundColor3 = Color3RGB(255, 255, 255)
								end
								--
                                HealthBarGradient.Enabled = ESP.HealthBar.Gradient
                                HealthBarGradient.Color = ESP.HealthBar.RainbowGradient and CSnew{CSKnew(0, ESP:GetRainbow()), CSKnew(0.5, ESP:GetRainbow() * Color3HSV(0.5, 0, 0)), CSKnew(1, ESP.HealthBar.GradientRGB3)} or CSnew{CSKnew(0, ESP.HealthBar.GradientRGB1), CSKnew(0.5, ESP.HealthBar.GradientRGB2), CSKnew(1, ESP.HealthBar.GradientRGB3)}
                                -- Health Text
                                do
                                    if ESP.HealthBar.HealthText then
                                        local healthPercentage = Floor(Humanoid.Health / Humanoid.MaxHealth * 100)
                                        HealthText.Position = ESP.HealthBar.HealthTextPosition == "Follow Bar" and UDim2new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2 + h * (1 - healthPercentage / 100) + 3) or UDim2new(-0.009, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2 + h / 100 + 3)
                                        HealthText.Text = tostring(healthPercentage) .. "hp"
                                        HealthText.Visible = true --Humanoid.Health < Humanoid.MaxHealth
                                        if ESP.HealthBar.Lerp then
                                            local color = health >= 0.75 and Color3RGB(0, 255, 0) or health >= 0.5 and Color3RGB(255, 255, 0) or health >= 0.25 and Color3RGB(255, 170, 0) or Color3RGB(255, 0, 0)
                                            HealthText.TextColor3 = color
                                        else
                                            HealthText.TextColor3 = ESP.HealthBar.RainbowText and ESP:GetRainbow() or ESP.HealthBar.HealthTextRGB
                                        end
									else
										HealthText.Visible = false
                                    end                        
                                end
                            end

                            do -- Names
								local plrName = ESP.Names.NameType == "Display Name" and plr.DisplayName or plr.Name

                                Name.Visible = ESP.Names.Enabled
								--[[if ESP.Flags.Enabled then
									if ESP.Options.FriendCheck and lplayer:IsFriendsWith(plr.UserId) then
                                    	Name.Text = string.format('(<font color="rgb(%d, %d, %d)">F</font>) %s', ESP.Options.FriendCheckRGB.R * 255, ESP.Options.FriendCheckRGB.G * 255, ESP.Options.FriendCheckRGB.B * 255, plrName)
                                	elseif ESP.Options.TeamCheck
                                    	Name.Text = string.format('(<font color="rgb(%d, %d, %d)">E</font>) %s', 255, 0, 0, plrName)
                                	end
								end]]
                                Name.Position = UDim2new(0, Pos.X, 0, Pos.Y - h / 2 - 9)
								Name.TextColor3 = ESP.Names.Rainbow and ESP:GetRainbow() or ESP.Names.RGB
                            end
                            
                            do -- Distance
                                if ESP.Distances.Enabled then
                                    if ESP.Distances.Position == "Bottom" then
                                        Weapon.Position = UDim2new(0, Pos.X, 0, Pos.Y + h / 2 + 18)
                                        Distance.Position = UDim2new(0, Pos.X, 0, Pos.Y + h / 2 + 7)
                                        Distance.Text = string.format("%d" .. ESP.Distances.Suffix, Floor(Dist))
                                        Distance.Visible = true
										Distance.TextColor3 = ESP.Distances.Rainbow and ESP:GetRainbow() or ESP.Distances.RGB
                                    elseif ESP.Distances.Position == "Text" then
                                        Weapon.Position = UDim2new(0, Pos.X, 0, Pos.Y + h / 2 + 8)
                                        Distance.Visible = false
                                        if ESP.Options.FriendCheck and lplayer:IsFriendsWith(plr.UserId) then
                                            Name.Text = string.format('(<font color="rgb(%d, %d, %d)">F</font>) %s [%d]', ESP.Options.FriendCheckRGB.R * 255, ESP.Options.FriendCheckRGB.G * 255, ESP.Options.FriendCheckRGB.B * 255, plr.Name, Floor(Dist))
                                        else
                                            Name.Text = string.format('(<font color="rgb(%d, %d, %d)">E</font>) %s [%d]', 255, 0, 0, plr.Name, Floor(Dist))
                                        end
                                        Name.Visible = ESP.Names.Enabled
                                    end
								else
									Distance.Visible = false
                                end
                            end

                            do -- Weapons
								local tool = character:FindFirstChildOfClass("Tool")
                                Weapon.Text = tool and tool.Name or "Nothing"
								Weapon.TextColor3 = ESP.Weapons.Rainbow and ESP:GetRainbow() or ESP.Weapons.RGB
                                Weapon.Visible = ESP.Weapons.Enabled
                            end

							if ESP.Boxes.GradientFill then
								Gradient1.Enabled = true
                    			Gradient1.Color = CSnew{CSKnew(0, ESP.Boxes.GradientFillRGB1), CSKnew(1, ESP.Boxes.GradientFillRGB2)}
                			else
								Gradient1.Enabled = false
                    			Gradient1.Color = CSnew{CSKnew(0, ESP.Boxes.Filled.RGB), CSKnew(1, ESP.Boxes.Filled.RGB)}
                			end
                			if ESP.Boxes.Gradient then
								Gradient2.Enabled = true
                    			Gradient2.Color = CSnew{CSKnew(0, ESP.Boxes.GradientRGB1), CSKnew(1, ESP.Boxes.GradientRGB2)}
                			else
								Gradient2.Enabled = false
                    			Gradient2.Color = CSnew{CSKnew(0, ESP.Boxes.Corner.RGB), CSKnew(1, ESP.Boxes.Corner.RGB)}
                			end
                         
                        else
                            HideESP();
                        end
                    else
                        HideESP();
                    end
                else
					--[[if ESP.FadeOut.OnDeath then
						print("Fading out on death...")
                        Functions:FadeOutOnDeath(Box)
                        Functions:FadeOutOnDeath(Outline)
                        Functions:FadeOutOnDeath(Name)
                        Functions:FadeOutOnDeath(Distance)
                        Functions:FadeOutOnDeath(Weapon)
                        Functions:FadeOutOnDeath(HealthBar)
                        Functions:FadeOutOnDeath(BehindHealthBar)
                        Functions:FadeOutOnDeath(HealthText)
                        Functions:FadeOutOnDeath(LeftTop)
                        Functions:FadeOutOnDeath(LeftSide)
                        Functions:FadeOutOnDeath(BottomSide)
                        Functions:FadeOutOnDeath(BottomDown)
                        Functions:FadeOutOnDeath(RightTop)
                        Functions:FadeOutOnDeath(RightSide)
                        Functions:FadeOutOnDeath(BottomRightSide)
						Functions:FadeOutOnDeath(BottomRightDown)
                        Functions:FadeOutOnDeath(Chams)
                        Functions:FadeOutOnDeath(Flag1)
                        Functions:FadeOutOnDeath(Flag2)
					else]]	
                    	HideESP();
					--end
                end
                IsEnabled();
            end)
        end
        local UpdateCoroutine = Wrap(Updater)();
		table.insert(ESP.Coroutines, UpdateCoroutine);
    end
    do -- Update ESP
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Name ~= lplayer.Name then
                local ESPCoroutine = Wrap(CreateESP)(v);
				table.insert(ESP.Coroutines, ESPCoroutine);
            end      
        end
        --
        game:GetService("Players").PlayerAdded:Connect(function(v)
            local ESPCoroutine = Wrap(CreateESP)(v);
			table.insert(ESP.Coroutines, ESPCoroutine);
        end);
    end;
end;

print("If you see this, it means the ESP has loaded correctly. Enjoy.")

return ESP
