-- Improved Flash Step Script for Poison's Hub
-- Features:
-- 1. Speed control slider
-- 2. On/Off toggle
-- 3. Improved UI with Poison's Hub branding
-- 4. Better performance and code organization

-- Initialize services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Get local player and character
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PoisonsHubFlashStep"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Try to parent to CoreGui for better persistence
pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game:GetService("CoreGui")
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = game:GetService("CoreGui")
    end
end)

-- If failed, parent to PlayerGui
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Create main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 180)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Add border glow
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(138, 43, 226) -- Purple
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Create title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(138, 43, 226) -- Purple
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

-- Add rounded corners to title bar
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

-- Fix title bar corners
local CornerFix = Instance.new("Frame")
CornerFix.Name = "CornerFix"
CornerFix.Size = UDim2.new(1, 0, 0.5, 0)
CornerFix.Position = UDim2.new(0, 0, 0.5, 0)
CornerFix.BackgroundColor3 = Color3.fromRGB(138, 43, 226) -- Purple
CornerFix.BorderSizePixel = 0
CornerFix.ZIndex = 0
CornerFix.Parent = TitleBar

-- Create title text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Poison's Hub"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 16
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Parent = TitleBar

-- Create subtitle text
local SubtitleText = Instance.new("TextLabel")
SubtitleText.Name = "SubtitleText"
SubtitleText.Size = UDim2.new(1, 0, 0, 20)
SubtitleText.Position = UDim2.new(0, 0, 0, 35)
SubtitleText.BackgroundTransparency = 1
SubtitleText.Text = "Flash Step Controller"
SubtitleText.Font = Enum.Font.Gotham
SubtitleText.TextSize = 14
SubtitleText.TextColor3 = Color3.fromRGB(200, 200, 200)
SubtitleText.Parent = MainFrame

-- Create status label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(0.5, -10, 0, 20)
StatusLabel.Position = UDim2.new(0, 10, 0, 65)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status:"
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

-- Create toggle button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 60, 0, 24)
ToggleButton.Position = UDim2.new(1, -70, 0, 63)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red (off)
ToggleButton.Text = "OFF"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 12
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Parent = MainFrame

-- Add rounded corners to toggle button
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 4)
ToggleCorner.Parent = ToggleButton

-- Create speed label
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(1, -20, 0, 20)
SpeedLabel.Position = UDim2.new(0, 10, 0, 95)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Flash Speed:"
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 14
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = MainFrame

-- Create speed value label
local SpeedValue = Instance.new("TextLabel")
SpeedValue.Name = "SpeedValue"
SpeedValue.Size = UDim2.new(0, 30, 0, 20)
SpeedValue.Position = UDim2.new(1, -40, 0, 95)
SpeedValue.BackgroundTransparency = 1
SpeedValue.Text = "5"
SpeedValue.Font = Enum.Font.GothamBold
SpeedValue.TextSize = 14
SpeedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedValue.TextXAlignment = Enum.TextXAlignment.Right
SpeedValue.Parent = MainFrame

-- Create slider background
local SliderBackground = Instance.new("Frame")
SliderBackground.Name = "SliderBackground"
SliderBackground.Size = UDim2.new(1, -20, 0, 6)
SliderBackground.Position = UDim2.new(0, 10, 0, 120)
SliderBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SliderBackground.BorderSizePixel = 0
SliderBackground.Parent = MainFrame

-- Add rounded corners to slider background
local SliderBGCorner = Instance.new("UICorner")
SliderBGCorner.CornerRadius = UDim.new(1, 0)
SliderBGCorner.Parent = SliderBackground

-- Create slider fill
local SliderFill = Instance.new("Frame")
SliderFill.Name = "SliderFill"
SliderFill.Size = UDim2.new(0.5, 0, 1, 0) -- 50% by default (5/10)
SliderFill.BackgroundColor3 = Color3.fromRGB(138, 43, 226) -- Purple
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBackground

-- Add rounded corners to slider fill
local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(1, 0)
SliderFillCorner.Parent = SliderFill

-- Create slider knob
local SliderKnob = Instance.new("Frame")
SliderKnob.Name = "SliderKnob"
SliderKnob.Size = UDim2.new(0, 16, 0, 16)
SliderKnob.Position = UDim2.new(0.5, -8, 0.5, -8)
SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderKnob.BorderSizePixel = 0
SliderKnob.ZIndex = 2
SliderKnob.Parent = SliderFill

-- Add rounded corners to slider knob
local SliderKnobCorner = Instance.new("UICorner")
SliderKnobCorner.CornerRadius = UDim.new(1, 0)
SliderKnobCorner.Parent = SliderKnob

-- Create min label
local MinLabel = Instance.new("TextLabel")
MinLabel.Name = "MinLabel"
MinLabel.Size = UDim2.new(0, 30, 0, 20)
MinLabel.Position = UDim2.new(0, 10, 0, 130)
MinLabel.BackgroundTransparency = 1
MinLabel.Text = "Slow"
MinLabel.Font = Enum.Font.Gotham
MinLabel.TextSize = 12
MinLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
MinLabel.TextXAlignment = Enum.TextXAlignment.Left
MinLabel.Parent = MainFrame

-- Create max label
local MaxLabel = Instance.new("TextLabel")
MaxLabel.Name = "MaxLabel"
MaxLabel.Size = UDim2.new(0, 30, 0, 20)
MaxLabel.Position = UDim2.new(1, -40, 0, 130)
MaxLabel.BackgroundTransparency = 1
MaxLabel.Text = "Fast"
MaxLabel.Font = Enum.Font.Gotham
MaxLabel.TextSize = 12
MaxLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
MaxLabel.TextXAlignment = Enum.TextXAlignment.Right
MaxLabel.Parent = MainFrame

-- Create flash step button
local FlashButton = Instance.new("TextButton")
FlashButton.Name = "FlashButton"
FlashButton.Size = UDim2.new(1, -20, 0, 30)
FlashButton.Position = UDim2.new(0, 10, 1, -40)
FlashButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226) -- Purple
FlashButton.Text = "ACTIVATE FLASH STEP"
FlashButton.Font = Enum.Font.GothamBold
FlashButton.TextSize = 14
FlashButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlashButton.Parent = MainFrame

-- Add rounded corners to flash button
local FlashButtonCorner = Instance.new("UICorner")
FlashButtonCorner.CornerRadius = UDim.new(0, 4)
FlashButtonCorner.Parent = FlashButton

-- Variables
local IsEnabled = false
local FlashSpeed = 5 -- Default speed (1-10)
local IsFlashing = false
local Connection = nil

-- Function to update slider visuals
local function UpdateSlider(value)
    FlashSpeed = value
    SpeedValue.Text = tostring(value)
    SliderFill.Size = UDim2.new(value / 10, 0, 1, 0)
end

-- Make slider draggable
local IsDraggingSlider = false
SliderBackground.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        IsDraggingSlider = true
        
        -- Calculate position and update
        local relativeX = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
        local value = math.floor(relativeX * 10) + 1
        value = math.clamp(value, 1, 10)
        UpdateSlider(value)
    end
end)

SliderBackground.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        IsDraggingSlider = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if IsDraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        -- Calculate position and update
        local relativeX = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
        local value = math.floor(relativeX * 10) + 1
        value = math.clamp(value, 1, 10)
        UpdateSlider(value)
    end
end)

-- Toggle button functionality
ToggleButton.MouseButton1Click:Connect(function()
    IsEnabled = not IsEnabled
    
    if IsEnabled then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green (on)
        ToggleButton.Text = "ON"
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red (off)
        ToggleButton.Text = "OFF"
        
        -- Stop flashing if it's active
        if IsFlashing then
            IsFlashing = false
            if Connection then
                Connection:Disconnect()
                Connection = nil
            end
            Camera.CameraType = Enum.CameraType.Custom
        end
    end
end)

-- Flash step functionality
local function PerformFlashStep()
    if not IsEnabled or IsFlashing or not Character or not Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    IsFlashing = true
    local HRP = Character:FindFirstChild("HumanoidRootPart")
    local OriginalCameraType = Camera.CameraType
    
    -- Calculate flash intensity based on speed
    local flashDistance = 10 + (FlashSpeed * 2) -- 12-30 units
    local flashDelay = 0.1 - (FlashSpeed * 0.008) -- 0.092-0.02 seconds
    
    -- Set up flash step loop
    local flashCount = 0
    local maxFlashes = 10 + FlashSpeed -- More flashes at higher speeds
    
    Connection = RunService.Heartbeat:Connect(function()
        if not IsEnabled or not IsFlashing or not Character or not Character:FindFirstChild("HumanoidRootPart") or flashCount >= maxFlashes then
            IsFlashing = false
            Connection:Disconnect()
            Connection = nil
            Camera.CameraType = OriginalCameraType
            return
        end
        
        -- Update camera
        local cameraPosition = Camera.CFrame.Position
        Camera.CameraType = Enum.CameraType.Scriptable
        Camera.CFrame = CFrame.new(
            cameraPosition:Lerp(
                (HRP.Position - (HRP.CFrame.lookVector * 15)) + Vector3.new(0, 5, 0), 
                0.1
            ), 
            HRP.Position
        )
        
        -- Flash step movement
        HRP.CFrame = HRP.CFrame * CFrame.new(flashDistance, 0, 0)
        task.wait(flashDelay)
        HRP.CFrame = HRP.CFrame * CFrame.new(-flashDistance * 2, 0, 0)
        task.wait(flashDelay)
        HRP.CFrame = HRP.CFrame * CFrame.new(flashDistance, 0, 0)
        
        flashCount = flashCount + 1
    end)
end

-- Flash button functionality
FlashButton.MouseButton1Click:Connect(function()
    if IsEnabled and not IsFlashing then
        PerformFlashStep()
    end
end)

-- Handle character respawn
LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
    
    -- Reset flashing state if character dies
    if IsFlashing then
        IsFlashing = false
        if Connection then
            Connection:Disconnect()
            Connection = nil
        end
        Camera.CameraType = Enum.CameraType.Custom
    end
    
    -- Connect death event
    Humanoid.Died:Connect(function()
        if IsFlashing then
            IsFlashing = false
            if Connection then
                Connection:Disconnect()
                Connection = nil
            end
            Camera.CameraType = Enum.CameraType.Custom
        end
    end)
end)

-- Connect death event for initial character
Humanoid.Died:Connect(function()
    if IsFlashing then
        IsFlashing = false
        if Connection then
            Connection:Disconnect()
            Connection = nil
        end
        Camera.CameraType = Enum.CameraType.Custom
    end
end)

-- Initialize slider
UpdateSlider(FlashSpeed)

-- Notification
local function CreateNotification(text, duration)
    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.Size = UDim2.new(0, 250, 0, 60)
    Notification.Position = UDim2.new(0.5, -125, 0, -70)
    Notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Notification.BorderSizePixel = 0
    Notification.Parent = ScreenGui
    
    -- Add rounded corners
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = Notification
    
    -- Add border
    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(138, 43, 226) -- Purple
    NotifStroke.Thickness = 2
    NotifStroke.Parent = Notification
    
    -- Add text
    local NotifText = Instance.new("TextLabel")
    NotifText.Name = "NotifText"
    NotifText.Size = UDim2.new(1, -20, 1, 0)
    NotifText.Position = UDim2.new(0, 10, 0, 0)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = text
    NotifText.Font = Enum.Font.Gotham
    NotifText.TextSize = 14
    NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifText.TextWrapped = true
    NotifText.Parent = Notification
    
    -- Animate in
    Notification:TweenPosition(UDim2.new(0.5, -125, 0, 20), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
    
    -- Remove after duration
    task.delay(duration, function()
        -- Animate out
        Notification:TweenPosition(UDim2.new(0.5, -125, 0, -70), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.5, true, function()
            Notification:Destroy()
        end)
    end)
end

-- Show welcome notification
CreateNotification("Poison's Hub Flash Step loaded successfully! Press the ACTIVATE button to use.", 5)

-- Return the main GUI (for potential future reference)
return ScreenGui
