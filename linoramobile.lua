
local Players = game:GetService("Players")

local function GetESPColorFromTeam(player)
    local isFriend = Players.LocalPlayer:IsFriendsWith(player.UserId)
    if isFriend and getgenv().ESP_Config.Options.Friendcheck then
        return getgenv().ESP_Config.Options.FriendcheckRGB
    end
    if getgenv().ESP_Config.TeamCheck and player.Team == Players.LocalPlayer.Team then
        return getgenv().ESP_Config.Options.TeamcheckRGB
    end
    return getgenv().ESP_Config.Drawing.Names.RGB
end
Config.ESP.Fonts = Fonts

local Players_ESP = {}
getgenv().ESPModule = {
local RefreshAllElements = function()
    for i,v in pairs(Players_ESP) do
        if v and v.RefreshElements then
            v.RefreshElements()
        end
    end 
end

do
    local Workspace, RunService, Players, CoreGui = Services.Workspace, Services.RunService, Services.Players, Services.CoreGui

    local Euphoria = Config.ESP.Connections;
    local lplayer = Players.LocalPlayer;
    local Cam = Workspace.CurrentCamera;
    local RotationAngle, Tick = -45, tick();

    local Functions = {}
    do
        function Functions:Create(Class, Properties)
            local _Instance = typeof(Class) == 'string' and Instance.new(Class) or Class
            for Property, Value in pairs(Properties) do
                _Instance[Property] = Value
            end
            return _Instance;
        end
        
        function Functions.FadeOutOnDist(element, distance)
            local transparency = math.max(0.1, 1 - (distance / Config.ESP.MaxDistance))
            if element:IsA("TextLabel") then
                element.TextTransparency = 1 - transparency
            elseif element:IsA("ImageLabel") then
                element.ImageTransparency = 1 - transparency
            elseif element:IsA("UIStroke") then
                element.Transparency = 1 - transparency
            elseif element:IsA("Frame") then
                element.BackgroundTransparency = 1 - transparency
            elseif element:IsA("Highlight") then
                element.FillTransparency = 1 - transparency
                element.OutlineTransparency = 1 - transparency
            end;
        end  

        Functions.AddOutline = function(Frame, Thickness)     
            Functions:Create("Frame", {
                Parent = Frame,
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.new(0, 0, 0),
                Position = UDim2.new(0, -Thickness, 0, -Thickness),
                Size = UDim2.new(1, Thickness * 2, 0, Thickness),
                ZIndex = Frame.ZIndex - 1
            })
        
            Functions:Create("Frame", {
                Parent = Frame,
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.new(0, 0, 0),
                Position = UDim2.new(0, -Thickness, 1, 0),
                Size = UDim2.new(1, Thickness * 2, 0, Thickness),
                ZIndex = Frame.ZIndex - 1
            })
        
            Functions:Create("Frame", {
                Parent = Frame,
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.new(0, 0, 0),
                Position = UDim2.new(0, -Thickness, 0, 0),
                Size = UDim2.new(0, Thickness, 1, 0),
                ZIndex = Frame.ZIndex - 1
            })
        
            Functions:Create("Frame", {
                Parent = Frame,
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.new(0, 0, 0),
                Position = UDim2.new(1, 0, 0, 0),
                Size = UDim2.new(0, Thickness, 1, 0),
                ZIndex = Frame.ZIndex - 1
            })
        end
    end;

    do 
        local ScreenGui = Functions:Create("ScreenGui", {
            Parent = CoreGui,
            Name = "ESPHolder",
            ResetOnSpawn = false,
        });

        local DupeCheck = function(plr)
            if ScreenGui:FindFirstChild(plr.Name) then
                ScreenGui[plr.Name]:Destroy()
            end
        end

        local getHealthColor = function(currentHealth, maxHealth)    
            return Config.ESP.Drawing.Healthbar.GradientRGB1:Lerp(Config.ESP.Drawing.Healthbar.GradientRGB2, (currentHealth / maxHealth))
        end

        local ESP = function(plr)
            task.spawn(function()
            if plr == lplayer then return end

            coroutine.wrap(DupeCheck)(plr)
            local Name = Functions:Create("TextLabel", {Visible = false,Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, -11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = Config.ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
            local Distance = Functions:Create("TextLabel", {Visible = false,Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = Config.ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
            local Weapon = Functions:Create("TextLabel", {Visible = false,Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 31), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = Config.ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true, Text = "None"})
            local Box = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.75, BorderSizePixel = 0})
            local Gradient1 = Functions:Create("UIGradient", {Parent = Box, Enabled = Config.ESP.Drawing.Boxes.GradientFill, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Config.ESP.Drawing.Boxes.GradientFillRGB1), ColorSequenceKeypoint.new(1, Config.ESP.Drawing.Boxes.GradientFillRGB2)}})
            local Outline = Functions:Create("UIStroke", {Parent = Box, Enabled = Config.ESP.Drawing.Boxes.Gradient, Transparency = 0, Color = Color3.fromRGB(255, 255, 255), LineJoinMode = Enum.LineJoinMode.Miter})
            local Gradient2 = Functions:Create("UIGradient", {Parent = Outline, Enabled = Config.ESP.Drawing.Boxes.Gradient, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Config.ESP.Drawing.Boxes.GradientRGB1), ColorSequenceKeypoint.new(1, Config.ESP.Drawing.Boxes.GradientRGB2)}})
            local Healthbar = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0})
            local BehindHealthbar = Functions:Create("Frame", {BorderColor3 = Color3.fromRGB(0, 0, 0), Parent = ScreenGui, ZIndex = -1, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0})
            local HealthbarGradient = Functions:Create("UIGradient", {Parent = Healthbar, Enabled = Config.ESP.Drawing.Healthbar.Gradient, Rotation = -90, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Config.ESP.Drawing.Healthbar.GradientRGB1), ColorSequenceKeypoint.new(1, Config.ESP.Drawing.Healthbar.GradientRGB2)}})
            local HealthText = Functions:Create("TextLabel", {Visible = false,Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 31), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = Config.ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), ZIndex = 500})
            local Chams = Functions:Create("Highlight", {Parent = ScreenGui, FillTransparency = 1, OutlineTransparency = 0, OutlineColor = Color3.fromRGB(119, 120, 255), DepthMode = "AlwaysOnTop"})
            local WeaponIcon = Functions:Create("ImageLabel", {Parent = ScreenGui, BackgroundTransparency = 1, BorderColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Size = UDim2.new(0, 40, 0, 40)})
            local Gradient3 = Functions:Create("UIGradient", {Parent = WeaponIcon, Rotation = -90, Enabled = Config.ESP.Drawing.Weapons.Gradient, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Config.ESP.Drawing.Weapons.GradientRGB1), ColorSequenceKeypoint.new(1, Config.ESP.Drawing.Weapons.GradientRGB2)}})
            local LeftTop = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, BorderColor3 = Color3.new(0,0,0)})
            local LeftSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, BorderColor3 = Color3.new(0,0,0)})
            local RightTop = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, BorderColor3 = Color3.new(0,0,0)})
            local RightSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, BorderColor3 = Color3.new(0,0,0)})
            local BottomSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, BorderColor3 = Color3.new(0,0,0)})
            local BottomDown = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, BorderColor3 = Color3.new(0,0,0)})
            local BottomRightSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, BorderColor3 = Color3.new(0,0,0)})
            local BottomRightDown = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, BorderColor3 = Color3.new(0,0,0)})
            local Flag1 = Functions:Create("TextLabel", {Visible = false,Parent = ScreenGui, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = Config.ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
            local Flag2 = Functions:Create("TextLabel", {Visible = false,Parent = ScreenGui, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = Config.ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
            
            Functions.AddOutline(LeftTop, 1); Functions.AddOutline(LeftSide, 1); Functions.AddOutline(LeftSide, 1); Functions.AddOutline(RightTop, 1); Functions.AddOutline(RightSide, 1); Functions.AddOutline(BottomSide, 1); Functions.AddOutline(BottomDown, 1); Functions.AddOutline(BottomRightSide, 1); Functions.AddOutline(BottomRightDown, 1); 
            
            if not plr.Character then plr.CharacterAdded:Wait() end
            local Humanoid, HRP = plr.Character:WaitForChild("Humanoid"), plr.Character:WaitForChild("HumanoidRootPart")

            local Pos, OnScreen = Cam:WorldToScreenPoint(HRP.Position)
            local Dist = (Cam.CFrame.Position - HRP.Position).Magnitude
                            
            local Size = HRP.Size.Y

            if DefaultPlayerSettings[plr.Name] and DefaultPlayerSettings[plr.Name].RootSettings and DefaultPlayerSettings[plr.Name].RootSettings.Size then
                Size = DefaultPlayerSettings[plr.Name].RootSettings.Size.Y
            end

            local health_clamped = math.clamp(Humanoid.Health, 0, Humanoid.MaxHealth)
            local health = health_clamped / Humanoid.MaxHealth;
            
            local scaleFactor = (Size * Cam.ViewportSize.Y) / (Pos.Z * 2)
            
            local w, h = 3 * scaleFactor, 4.5 * scaleFactor

            if not Players_ESP[plr.Name] then
                Players_ESP[plr.Name] = {}
                Players_ESP[plr.Name].RefreshElements = function()
                    task.spawn(function()
                        if Config.ESP.Font == Fonts["Plex"] or Config.ESP.Font == Fonts["Pixel"] or Config.ESP.Font == Fonts["Minecraftia"] or Config.ESP.Font == Fonts["Verdana"] then
                            HealthText.FontFace = Config.ESP.Font
                            Name.FontFace = Config.ESP.Font
                            Distance.FontFace = Config.ESP.Font
                            Weapon.FontFace = Config.ESP.Font
                        else
                            HealthText.Font = Config.ESP.Font
                            Name.Font = Config.ESP.Font
                            Distance.Font = Config.ESP.Font
                            Weapon.Font = Config.ESP.Font
                        end

                        do 
                            Box.Visible = Config.ESP.Drawing.Boxes.Full.Enabled
                            if Config.ESP.Drawing.Boxes.Filled.Enabled then
                                Box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                if Config.ESP.Drawing.Boxes.GradientFill then
                                    Box.BackgroundTransparency = Config.ESP.Drawing.Boxes.Filled.Transparency;
                                else
                                    Box.BackgroundTransparency = 1
                                end
                                Box.BorderSizePixel = 1
                            else
                                Box.BackgroundTransparency = 1
                            end

                            if not Config.ESP.Drawing.Boxes.Bounding.Enabled or (Config.ESP.Drawing.Boxes.Corner.Enabled and Config.ESP.Drawing.Boxes.Bounding.Enabled) then
                                LeftTop.Transparency = Config.ESP.Drawing.Boxes.Corner.Transparency
                                LeftTop.BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB

                                LeftSide.Transparency = Config.ESP.Drawing.Boxes.Corner.Transparency
                                LeftSide.BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB

                                BottomSide.Transparency = Config.ESP.Drawing.Boxes.Corner.Transparency
                                BottomSide.BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB

                                BottomDown.Transparency = Config.ESP.Drawing.Boxes.Corner.Transparency
                                BottomDown.BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB

                                RightTop.Transparency = Config.ESP.Drawing.Boxes.Corner.Transparency
                                RightTop.BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB

                                RightSide.Transparency = Config.ESP.Drawing.Boxes.Corner.Transparency
                                RightSide.BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB

                                BottomRightSide.Transparency = Config.ESP.Drawing.Boxes.Corner.Transparency
                                BottomRightSide.BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB

                                BottomRightDown.Transparency = Config.ESP.Drawing.Boxes.Corner.Transparency
                                BottomRightDown.BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB
                            end

                            if not Config.ESP.Drawing.Boxes.Corner.Enabled then
                                LeftTop.Transparency = Config.ESP.Drawing.Boxes.Bounding.Transparency
                                LeftSide.Transparency = Config.ESP.Drawing.Boxes.Bounding.Transparency
                                BottomSide.Transparency = Config.ESP.Drawing.Boxes.Bounding.Transparency
                                RightSide.Transparency = Config.ESP.Drawing.Boxes.Bounding.Transparency

                                LeftTop.BackgroundColor3 = Config.ESP.Drawing.Boxes.Bounding.RGB
                                LeftSide.BackgroundColor3 = Config.ESP.Drawing.Boxes.Bounding.RGB
                                BottomSide.BackgroundColor3 = Config.ESP.Drawing.Boxes.Bounding.RGB
                                RightSide.BackgroundColor3 = Config.ESP.Drawing.Boxes.Bounding.RGB
                            end

                            BottomSide.AnchorPoint = Vector2.new(0, 5)
                            BottomDown.AnchorPoint = Vector2.new(0, 1)
                            RightTop.AnchorPoint = Vector2.new(1, 0)
                            RightSide.AnchorPoint = Vector2.new(0, 0)
                            BottomRightSide.AnchorPoint = Vector2.new(1, 1)
                            BottomRightDown.AnchorPoint = Vector2.new(1, 1)

                            if not Config.ESP.Drawing.Boxes.Animate then
                                Gradient1.Rotation = -45
                                Gradient2.Rotation = -45
                            end

                            Gradient1.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Config.ESP.Drawing.Boxes.GradientFillRGB1), ColorSequenceKeypoint.new(1, Config.ESP.Drawing.Boxes.GradientFillRGB2)}
                            Gradient2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Config.ESP.Drawing.Boxes.GradientRGB1), ColorSequenceKeypoint.new(1, Config.ESP.Drawing.Boxes.GradientRGB2)}
                        end
                        
                        do
                            Name.TextSize = Config.ESP.FontSize
                            Name.TextColor3 = Config.ESP.Drawing.Names.RGB
                            Name.TextStrokeTransparency = Config.ESP.Drawing.Names.Transparency
                        end

                        do 
                            if Config.ESP.Drawing.Chams.VisibleCheck then
                                Chams.DepthMode = "Occluded"
                            else
                                Chams.DepthMode = "AlwaysOnTop"
                            end

                            Chams.FillColor = Config.ESP.Drawing.Chams.FillRGB
                            Chams.OutlineColor = Config.ESP.Drawing.Chams.OutlineRGB

                            if not Config.ESP.Drawing.Chams.Thermal then 
                                Chams.OutlineTransparency = Config.ESP.Drawing.Chams.Outline_Transparency / 100
                                Chams.FillTransparency = Config.ESP.Drawing.Chams.Fill_Transparency / 100
                            end
                        end

                        do 
                            Distance.TextStrokeTransparency = Config.ESP.Drawing.Distances.Transparency
                            Distance.TextSize = Config.ESP.FontSize
                            Distance.TextColor3 = Config.ESP.Drawing.Distances.RGB
                            Weapon.TextStrokeTransparency = Config.ESP.Drawing.Weapons.Transparency
                            Weapon.TextSize = Config.ESP.FontSize
                            Weapon.TextColor3 = Config.ESP.Drawing.Weapons.WeaponTextRGB
                        end
                    end)
                end

                Players_ESP[plr.Name].Health_Changed = function()
                    health_clamped = math.clamp(Humanoid.Health, 0, Humanoid.MaxHealth)
                    health = health_clamped / Humanoid.MaxHealth;
                end

                Players_ESP[plr.Name].Health_Changed()

                Players_ESP[plr.Name].Child_Added = function(Item)
                    if not Item:IsA("Tool") then 
                        return
                    end 

                    local name = plr.Character:FindFirstChild(Item.Name) and Item.Name or "None"

                    Weapon.Text = name
                end

                Players_ESP[plr.Name].ToolConnection_Added = plr.Character.ChildAdded:Connect(Players_ESP[plr.Name].Child_Added)
                Players_ESP[plr.Name].ToolConnection_Removed = plr.Character.ChildRemoved:Connect(Players_ESP[plr.Name].Child_Added)

                Players_ESP[plr.Name].HumanoidConnection = Humanoid.HealthChanged:Connect(Players_ESP[plr.Name].Health_Changed)

                Players_ESP[plr.Name].CharacterAdded = plr.CharacterAdded:Connect(function(Character)
                    Humanoid = Character:WaitForChild("Humanoid")
                    HRP = Character:WaitForChild("HumanoidRootPart")
                    Players_ESP[plr.Name].ToolConnection_Added:Disconnect()
                    Players_ESP[plr.Name].ToolConnection_Removed:Disconnect()

                    Players_ESP[plr.Name].ToolConnection_Removed = nil
                    Players_ESP[plr.Name].ToolConnection_Added = nil

                    Players_ESP[plr.Name].ToolConnection_Added = plr.Character.ChildAdded:Connect(Players_ESP[plr.Name].Child_Added)
                    Players_ESP[plr.Name].ToolConnection_Removed = plr.Character.ChildRemoved:Connect(Players_ESP[plr.Name].Child_Added)

                    Players_ESP[plr.Name].HumanoidConnection:Disconnect()
                    Players_ESP[plr.Name].HumanoidConnection = Humanoid.HealthChanged:Connect(Players_ESP[plr.Name].Health_Changed)
                    Players_ESP[plr.Name].Health_Changed()
                    Players_ESP[plr.Name].RefreshElements()
                end)

                Players_ESP[plr.Name].RefreshElements()
            end

            local Updater = function()
                local Connection;
                local HideESP = function()
                    Box.Visible = false;
                    Name.Visible = false;
                    Distance.Visible = false;
                    Weapon.Visible = false;
                    Healthbar.Visible = false;
                    BehindHealthbar.Visible = false;
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
                end
                
                Connection = Euphoria.RunService.RenderStepped:Connect(function()
                    if plr.Character and lplayer.Character and Config.ESP.Enabled then
                        if Humanoid and HRP then
                            Pos, OnScreen = Cam:WorldToScreenPoint(HRP.Position)
                            Dist = (Cam.CFrame.Position - HRP.Position).Magnitude
                            
                            if OnScreen and Dist <= Config.ESP.MaxDistance then
                                Size = HRP.Size.Y

                                if DefaultPlayerSettings[plr.Name] and DefaultPlayerSettings[plr.Name].RootSettings and DefaultPlayerSettings[plr.Name].RootSettings.Size then
                                    Size = DefaultPlayerSettings[plr.Name].RootSettings.Size.Y
                                end
                                
                                scaleFactor = (Size * Cam.ViewportSize.Y) / (Pos.Z * 2)
                                
                                w, h = 3 * scaleFactor, 4.5 * scaleFactor

                                if Config.ESP.FadeOut.OnDistance then
                                    Functions.FadeOutOnDist(Box, Dist)
                                    Functions.FadeOutOnDist(Outline, Dist)
                                    Functions.FadeOutOnDist(Name, Dist)
                                    Functions.FadeOutOnDist(Distance, Dist)
                                    Functions.FadeOutOnDist(Weapon, Dist)
                                    Functions.FadeOutOnDist(Healthbar, Dist)
                                    Functions.FadeOutOnDist(BehindHealthbar, Dist)
                                    Functions.FadeOutOnDist(HealthText, Dist)
                                    Functions.FadeOutOnDist(WeaponIcon, Dist)
                                    Functions.FadeOutOnDist(LeftTop, Dist)
                                    Functions.FadeOutOnDist(LeftSide, Dist)
                                    Functions.FadeOutOnDist(BottomSide, Dist)
                                    Functions.FadeOutOnDist(BottomDown, Dist)
                                    Functions.FadeOutOnDist(RightTop, Dist)
                                    Functions.FadeOutOnDist(RightSide, Dist)
                                    Functions.FadeOutOnDist(BottomRightSide, Dist)
                                    Functions.FadeOutOnDist(BottomRightDown, Dist)
                                    Functions.FadeOutOnDist(Chams, Dist)
                                    Functions.FadeOutOnDist(Flag1, Dist)
                                    Functions.FadeOutOnDist(Flag2, Dist)
                                end
                                
                                if HRP and Humanoid then
                                    do 
                                        Chams.Adornee = plr.Character
                                        Chams.Enabled = Config.ESP.Drawing.Chams.Enabled
                                        do
                                            if Config.ESP.Drawing.Chams.Thermal then
                                                local breathe_effect = math.atan(math.sin(tick() * 2)) * 2 / math.pi
                                                Chams.FillTransparency = Config.ESP.Drawing.Chams.Fill_Transparency * breathe_effect * 0.01
                                                Chams.OutlineTransparency = Config.ESP.Drawing.Chams.Outline_Transparency * breathe_effect * 0.01
                                            end
                                        end
                                    end;

                                    do 
                                        if not Config.ESP.Drawing.Boxes.Bounding.Enabled or (Config.ESP.Drawing.Boxes.Corner.Enabled and Config.ESP.Drawing.Boxes.Bounding.Enabled) then
                                            LeftTop.Visible = Config.ESP.Drawing.Boxes.Corner.Enabled
                                            LeftTop.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                            LeftTop.Size = UDim2.new(0, w / 5, 0, 1)

                                            LeftSide.Visible = Config.ESP.Drawing.Boxes.Corner.Enabled
                                            LeftSide.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                            LeftSide.Size = UDim2.new(0, 1, 0, h / 5)

                                            BottomSide.Visible = Config.ESP.Drawing.Boxes.Corner.Enabled
                                            BottomSide.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                            BottomSide.Size = UDim2.new(0, 1, 0, h / 5)

                                            BottomDown.Visible = Config.ESP.Drawing.Boxes.Corner.Enabled
                                            BottomDown.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                            BottomDown.Size = UDim2.new(0, w / 5, 0, 1)


                                            RightTop.Visible = Config.ESP.Drawing.Boxes.Corner.Enabled
                                            RightTop.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y - h / 2)
                                            RightTop.Size = UDim2.new(0, w / 5, 0, 1)

                                            RightSide.Visible = Config.ESP.Drawing.Boxes.Corner.Enabled
                                            RightSide.Position = UDim2.new(0, Pos.X + w / 2 - 1, 0, Pos.Y - h / 2)
                                            RightSide.Size = UDim2.new(0, 1, 0, h / 5)

                                            BottomRightSide.Visible = Config.ESP.Drawing.Boxes.Corner.Enabled
                                            BottomRightSide.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y + h / 2)
                                            BottomRightSide.Size = UDim2.new(0, 1, 0, h / 5)

                                            BottomRightDown.Visible = Config.ESP.Drawing.Boxes.Corner.Enabled
                                            BottomRightDown.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y + h / 2)
                                            BottomRightDown.Size = UDim2.new(0, w / 5, 0, 1)
                                        end
                                    end

                                    do 
                                        if not Config.ESP.Drawing.Boxes.Corner.Enabled then
                                            LeftTop.Visible = Config.ESP.Drawing.Boxes.Bounding.Enabled
                                            LeftTop.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                            LeftTop.Size = UDim2.new(0, w, 0, 1)


                                            LeftSide.Visible = Config.ESP.Drawing.Boxes.Bounding.Enabled
                                            LeftSide.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                            LeftSide.Size = UDim2.new(0, 1, 0, h)


                                            BottomSide.Visible = Config.ESP.Drawing.Boxes.Bounding.Enabled
                                            BottomSide.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                            BottomSide.Size = UDim2.new(0, w, 0, 1) 


                                            RightSide.Visible = Config.ESP.Drawing.Boxes.Bounding.Enabled 
                                            RightSide.Position = UDim2.new(0, Pos.X + w / 2 - 1, 0, Pos.Y - h / 2)
                                            RightSide.Size = UDim2.new(0, 1, 0, h) 

                                            BottomRightSide.Visible = false
                                            BottomRightDown.Visible = false
                                            BottomDown.Visible = false
                                            RightTop.Visible = false
                                        end
                                    end

                                    do 
                                        Box.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                        Box.Size = UDim2.new(0, w, 0, h)
                                        Box.Visible = Config.ESP.Drawing.Boxes.Full.Enabled

                                        if Config.ESP.Drawing.Boxes.Animate then
                                            RotationAngle = RotationAngle + (tick() - Tick) * Config.ESP.Drawing.Boxes.RotationSpeed * math.cos(math.pi / 4 * tick() - math.pi / 2)
                                            Gradient1.Rotation = RotationAngle
                                            Gradient2.Rotation = RotationAngle
                                        end

                                        
                                        Tick = tick()
                                    end

                                    do  
                                        local is_inf = false

                                        if Humanoid.Health ~= Humanoid.Health then
                                            health = 1;
                                            is_inf = true;
                                        end

                                        Healthbar.Position = UDim2.new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2 + h * (1 - health))
                                        Healthbar.Size = UDim2.new(0, Config.ESP.Drawing.Healthbar.Width, 0, h * health)

                                        Healthbar.BackgroundTransparency = Config.ESP.Drawing.Healthbar.Transparency

                                        BehindHealthbar.Position = UDim2.new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2) 
                                        BehindHealthbar.Size = UDim2.new(0, Config.ESP.Drawing.Healthbar.Width, 0, h) 
                                        BehindHealthbar.BackgroundTransparency = Config.ESP.Drawing.Healthbar.Transparency


                                        HealthbarGradient.Enabled = Config.ESP.Drawing.Healthbar.Gradient
                                        HealthbarGradient.Color = ColorSequence.new{
                                            ColorSequenceKeypoint.new(0, Config.ESP.Drawing.Healthbar.GradientRGB1),
                                            ColorSequenceKeypoint.new(1, Config.ESP.Drawing.Healthbar.GradientRGB2)
                                        }

                                        HealthbarGradient.Offset = Vector2.new(0, health - 1)

                                        local color = getHealthColor(health_clamped , Humanoid.MaxHealth)
                                        local healthtexttext = tostring(math.floor(health_clamped))

                                        if is_inf then
                                            healthtexttext = "inf"
                                            color = getHealthColor(Humanoid.MaxHealth, Humanoid.MaxHealth)
                                        end

                                        Healthbar.BackgroundColor3 = not Config.ESP.Drawing.Healthbar.Gradient and color or Color3.new(1,1,1)

                                        Healthbar.Visible = Config.ESP.Drawing.Healthbar.Enabled
                                        BehindHealthbar.Visible = Config.ESP.Drawing.Healthbar.Enabled

                                        do
                                            if Config.ESP.Drawing.Healthbar.HealthText then
                                                local healthPercentage = math.floor(health_clamped / Humanoid.MaxHealth * 100)

                                                if is_inf then
                                                    healthPercentage = 100
                                                end

                                                HealthText.Position = UDim2.new(0, Pos.X - w / 2 - 18, 0, Pos.Y - h / 2 + h * (1 - healthPercentage / 100) + 3)
                                                HealthText.Text = healthtexttext
                                                HealthText.TextSize = Config.ESP.FontSize
                                                HealthText.Visible = Config.ESP.Drawing.Healthbar.HealthText
                                                HealthText.TextStrokeTransparency = Config.ESP.Drawing.Healthbar.HealthTextTransparency
                                                if Config.ESP.Drawing.Healthbar.Lerp then
                                                    HealthText.TextColor3 = color
                                                else
                                                    HealthText.TextColor3 = Config.ESP.Drawing.Healthbar.HealthTextRGB
                                                end
                                            else
                                                HealthText.Visible = false
                                            end
                                        end
                                    end

                                    do 
                                        Name.Visible = Config.ESP.Drawing.Names.Enabled
                                        Name.Text = plr.Name
                                        if Config.ESP.Options.Friendcheck and lplayer:IsFriendsWith(plr.UserId) then
                                            Name.Text = string.format('(<font color="rgb(%d, %d, %d)">F</font>) %s', Config.ESP.Options.FriendcheckRGB.R * 255, Config.ESP.Options.FriendcheckRGB.G * 255, Config.ESP.Options.FriendcheckRGB.B * 255, plr.Name)
                                        end
                                        Name.Position = UDim2.new(0, Pos.X, 0, Pos.Y - h / 2 - 9)
                                    end
                                    
                                    do 
                                        if Config.ESP.Drawing.Distances.Enabled then
                                            Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 7)
                                            Distance.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + (Weapon.Visible and 18 or 7))
                                            Distance.Text = string.format("%d Studs", math.floor(Dist))

                                            Distance.Visible = true
                                        else
                                            Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 8)
                                            Distance.Visible = false;
                                        end
                                    end

                                    do 
                                        Weapon.Visible = Config.ESP.Drawing.Weapons.Enabled
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
                    else
                        HideESP();
                    end
                end)
            end
            coroutine.wrap(Updater)();
            end)
        end
        
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= lplayer then
                coroutine.wrap(ESP)(v)
            end
        end
        
        Players.PlayerAdded:Connect(function(v)
            coroutine.wrap(ESP)(v)
        end);

        Players.PlayerRemoving:Connect(function(v)
            if Players_ESP[v.Name] then
                if Players_ESP[v.Name].CharacterAdded then
                    Players_ESP[v.Name].CharacterAdded:Disconnect()
                end
                if Players_ESP[v.Name].ToolConnection_Added then
                    Players_ESP[v.Name].ToolConnection_Added:Disconnect()
                end
                if Players_ESP[v.Name].ToolConnection_Removed then
                    Players_ESP[v.Name].ToolConnection_Removed:Disconnect()
                end
                if Players_ESP[v.Name].HumanoidConnection then
                    Players_ESP[v.Name].HumanoidConnection:Disconnect()
                end
                Players_ESP[v.Name] = nil
            end 
        end)
    end;
end
}
