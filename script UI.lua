local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "Poison's Hub ",
   Icon = 0,
   LoadingTitle = "Welcome. To Poison's Hub",
   LoadingSubtitle = "by Alex and Co Dev & 9'9",
   Theme = {
           TextColor = Color3.fromRGB(0, 0, 0),
           Background = Color3.fromRGB(5, 5, 5),
           Topbar = Color3.fromRGB(138, 43, 226),
           Shadow = Color3.fromRGB(138, 43, 226),

           NotificationBackground = Color3.fromRGB(138, 43, 226),
           NotificationActionsBackground = Color3.fromRGB(138, 43, 226),

           TabBackground = Color3.fromRGB(138, 43, 226),
           TabStroke = Color3.fromRGB(138, 43, 226),
           TabBackgroundSelected = Color3.fromRGB(138, 43, 226),
           TabTextColor = Color3.fromRGB(0, 0, 0),

           SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
           ElementBackground = Color3.fromRGB(138, 43, 226),
           ElementBackgroundHover = Color3.fromRGB(138, 43, 226),
           SecondaryElementBackground = Color3.fromRGB(138, 43, 226),
           ElementStroke = Color3.fromRGB(0, 0, 0),
           SecondaryElementStroke = Color3.fromRGB(138, 43, 226),

           SliderBackground = Color3.fromRGB(5, 5, 5),
           SliderProgress = Color3.fromRGB(138, 43, 226),
           SliderStroke = Color3.fromRGB(138, 43, 226),

           ToggleBackground = Color3.fromRGB(138, 43, 226),
           ToggleEnabled = Color3.fromRGB(138, 43, 226),
           ToggleDisabled = Color3.fromRGB(0, 0, 0),
           ToggleEnabledStroke = Color3.fromRGB(138, 43, 226),
           ToggleDisabledStroke = Color3.fromRGB(0, 0, 0),
           ToggleEnabledOuterStroke = Color3.fromRGB(138, 43, 226),
           ToggleDisabledOuterStroke = Color3.fromRGB(138, 43, 226),

           DropdownSelected = Color3.fromRGB(5, 5, 5),
           DropdownUnselected = Color3.fromRGB(0, 0, 0),

           InputBackground = Color3.fromRGB(0, 0, 0),
           InputStroke = Color3.fromRGB(138, 43, 226),
           PlaceholderColor = Color3.fromRGB(138, 43, 226)
       },
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Poison's Hub"
   },

   Discord = {
      Enabled = true, 
      Invite = "nil", 
      RememberJoins = false
   },

   KeySystem = true,
   KeySettings = {
      Title = "Enter Key Below",
      Subtitle = "Key System",
      Note = "key is poison", 
      FileName = "Key", 
      SaveKey = true,
      GrabKeyFromSite = false,  
      Key = {"poison"}
   }
})

local Tab = Window:CreateTab("Main", "home")
local Slider = Tab:CreateSlider({
   Name = "WalkSpeed",
   Range = {0, 210},
   Increment = 10,
   Suffix = "speed",
   CurrentValue = 10,
   Flag = "speed",
   Callback = function(Value)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value    
   end,
})



local Divider = Tab:CreateDivider()

local Tab = Window:CreateTab("Universal", "rewind")
local Button = Tab:CreateButton({
Name = "Infinite Yield",
Callback = function()
   loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end,
})
local Button = Tab:CreateButton({
Name = "Vc Unban",
Callback = function()
         loadstring(game:HttpGet("https://raw.githubusercontent.com/platinumicy/unsuspend/refs/heads/main/unsuspend"))()
end,
})

local Button = Tab:CreateButton({
Name = "System Broken",
Callback = function()
         loadstring(game:HttpGet('https://raw.githubusercontent.com/H20CalibreYT/SystemBroken/main/script'))()
end,
})

local Button = Tab:CreateButton({
Name = "Flash Step",
Callback = function()
         loadstring(game:HttpGet("https://raw.githubusercontent.com/0Ben1/fe/main/obf_11l7Y131YqJjZ31QmV5L8pI23V02b3191sEg26E75472Wl78Vi8870jRv5txZyL1.lua.txt"))()
end,
})

local Button = Tab:CreateButton({
Name = "Jerk Off Tool",
Callback = function()
         loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
end,
})
   local Button = Tab:CreateButton({
Name = "Face Fuck",
Callback = function()
         loadstring(game:HttpGet('https://raw.githubusercontent.com/EnterpriseExperience/bruhlolw/refs/heads/main/face_bang_script.lua'))()
end,
})

         local Button = Tab:CreateButton({
            Name = "Tp Tool",
            Callback = function()
     local player = game.Players.LocalPlayer 
     local mouse = player:GetMouse() 

     local tool = Instance.new("Tool") 
     tool.Name = "Teleport Tool" 
     tool.RequiresHandle = false 
     tool.Parent = player.Backpack 

     local function teleportToClick() 
         local character = player.Character or player.CharacterAdded:Wait() 
         local rootPart = character:FindFirstChild("HumanoidRootPart") 

         if rootPart and mouse.Target then 
             local targetPosition = mouse.Hit.Position 
             rootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 3, 0)) 
         end
     end

     tool.Activated:Connect(teleportToClick) 
 end 
}) 

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local TeleportEnabled = false
local PhaseEnabled = false
local PointTeleportIndicatorEnabled = true
local TeleportIndicator = nil
local PhaseObjects = {}
local TeleportConnection = nil

local function CreateTeleportIndicator()
 local indicator = Instance.new("Part")
 indicator.Name = "TeleportIndicator"
 indicator.Anchored = true
 indicator.CanCollide = false
 indicator.Size = Vector3.new(1, 0.1, 1)
 indicator.Transparency = 1
 indicator.Parent = workspace

 local surfaceGui = Instance.new("SurfaceGui")
 surfaceGui.Face = Enum.NormalId.Top
 surfaceGui.AlwaysOnTop = false
 surfaceGui.LightInfluence = 0
 surfaceGui.Parent = indicator

     local function createRipple()
         local ripple = Instance.new("Frame")
         ripple.AnchorPoint = Vector2.new(0.5, 0.5)
         ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
         ripple.Size = UDim2.new(0, 100, 0, 100)
         ripple.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
         ripple.BackgroundTransparency = 0.2
         ripple.BorderSizePixel = 0
         ripple.ZIndex = 10
         ripple.Parent = surfaceGui

         local uiCorner = Instance.new("UICorner", ripple)
         uiCorner.CornerRadius = UDim.new(1, 0)

         local TweenService = game:GetService("TweenService")
         local info = TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
         local tween = TweenService:Create(ripple, info, {
             Size = UDim2.new(3, 0, 3, 0),
             BackgroundTransparency = 1
         })
         tween:Play()

         tween.Completed:Connect(function()
             ripple:Destroy()
         end)
     end

     task.spawn(function()
         while indicator and indicator.Parent do
             createRipple()
             task.wait(0.6)
         end
     end)

     return indicator
 end

 local RunService = game:GetService("RunService")
 local LocalPlayer = game.Players.LocalPlayer
 local Mouse = LocalPlayer:GetMouse()


 local TeleportEnabled = false
 local TeleportConnection = nil
 local TeleportIndicator = nil
 local PhaseObjects = {} 
 local PointTeleportIndicatorEnabled = true 

 local function CreateTeleportIndicator()
     local indicator = Instance.new("Part")
     indicator.Size = Vector3.new(2, 0.2, 2)
     indicator.Anchored = true
     indicator.CanCollide = false
     indicator.Transparency = 0.5
     indicator.BrickColor = BrickColor.new("Bright blue")
     indicator.Parent = workspace
     return indicator
 end

 local Toggle = Tab1:CreateToggle({
     Name = "Point Teleport",
     Default = false,
     Description = "Click anywhere to teleport there.",
     Callback = function(enabled)
         TeleportEnabled = enabled

         if enabled then
             for _, PhaseObj in pairs(PhaseObjects) do
                 if PhaseObj:FindFirstChild("PhaseHighlight") then
                     PhaseObj.PhaseHighlight:Destroy()
                     PhaseObj.CanCollide = true
                 end
             end

             if PointTeleportIndicatorEnabled and not TeleportIndicator then
                 TeleportIndicator = CreateTeleportIndicator()
             end

             Mouse.TargetFilter = TeleportIndicator
             RunService:BindToRenderStep("TeleportIndicatorUpdate", Enum.RenderPriority.Last.Value, function()
                 if TeleportIndicator and TeleportEnabled then
                     local ray = workspace:Raycast(Mouse.UnitRay.Origin, Mouse.UnitRay.Direction * 500, RaycastParams.new())
                     if ray and ray.Position then
                         TeleportIndicator.Position = ray.Position
                     end
                 end
             end)

             TeleportConnection = Mouse.Button1Down:Connect(function()
                 if not TeleportEnabled then return end
                 local ray = workspace:Raycast(Mouse.UnitRay.Origin, Mouse.UnitRay.Direction * 500, RaycastParams.new())
                 if ray and ray.Position then
                     local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                     local hrp = char:FindFirstChild("HumanoidRootPart")
                     if hrp then
                         hrp.CFrame = CFrame.new(ray.Position + Vector3.new(0, 5, 0)) -- Slightly above the ground
                     end
                 end
             end)

             print("Teleport Enabled!")
         else
             TeleportEnabled = false

             if TeleportConnection then
                 TeleportConnection:Disconnect()
                 TeleportConnection = nil
             end

             RunService:UnbindFromRenderStep("TeleportIndicatorUpdate")

             if TeleportIndicator then
                 TeleportIndicator:Destroy()
                 TeleportIndicator = nil
             end

             Mouse.TargetFilter = nil

             print("Teleport Disabled!")
         end
   end,
}) 

local Divider = Tab:CreateDivider()

local Tab = Window:CreateTab("Visuals", "eye")



local Divider = Tab:CreateDivider()

local Tab = Window:CreateTab("ReAnimation", "user")



local Divider = Tab:CreateDivider()

local Tab = Window:CreateTab("Settings", "settings")



local Divider = Tab:CreateDivider()

local Tab = Window:CreateTab("Copy Animation", "pen")



local Divider = Tab:CreateDivider()
