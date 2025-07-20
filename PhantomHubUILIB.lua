--[[
    PhantomHubV2 - Mobile Optimized UI Library
    With Local Asset Management
--]]

-- FOLDER SETUP
if not isfolder("PhantomHubV2") then 
    makefolder("PhantomHubV2") 
end
if not isfolder("PhantomHubV2/Icons") then 
    makefolder("PhantomHubV2/Icons") 
end
if not isfolder("PhantomHubV2/Assets") then 
    makefolder("PhantomHubV2/Assets") 
end

-- UNIVERSAL REQUEST FUNCTION
local req = (syn and syn.request) or (http and http.request) or (request) or (fluxus and fluxus.request) or (http_request)

-- DOWNLOAD PHANTOM HUB LOGO
local function downloadLogo()
    if not isfile("PhantomHubV2/Icons/phantom_logo.png") then
        local logoReq = req({
            Url = "https://raw.githubusercontent.com/Justanewplayer19/PhantomHubReactIcons/refs/heads/main/IMG_2405.png", 
            Method = "GET"
        })
        if logoReq and logoReq.Body then
            writefile("PhantomHubV2/Icons/phantom_logo.png", logoReq.Body)
            print("✅ PhantomHub logo downloaded successfully!")
        else
            print("❌ Failed to download PhantomHub logo")
        end
    end
end

-- Download logo on startup
pcall(downloadLogo)

-- Clean up any existing PhantomHub instances
pcall(function()
    game:GetService('CoreGui'):FindFirstChild('PhantomHubV2'):Remove()
end)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Library = {}

function Library:Window(title)
    local ui = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local UICorner_9 = Instance.new("UICorner")
    local Shadow = Instance.new("ImageLabel")
    local tabs = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local Cover = Instance.new("Frame")
    local TabsList = Instance.new("UIListLayout")
    local Top = Instance.new("Frame")
    local UICorner_5 = Instance.new("UICorner")
    local Cover_2 = Instance.new("Frame")
    local Line = Instance.new("Frame")
    local Logo = Instance.new("ImageLabel")
    local Close = Instance.new("ImageButton")
    local GameName = Instance.new("TextLabel")
    local Pages = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local UICorner = Instance.new("UICorner")
    local TabsContainer = Instance.new("Frame")
    local TabsList = Instance.new("UIListLayout")
    local UIPadding = Instance.new("UIPadding")
    local tabs = Instance.new("Frame")
    local Resize = Instance.new("ImageButton")
    local Cover = Instance.new("Frame")
    local MobileToggle = Instance.new("ImageButton")
    
    -- Mobile detection
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    
    ui.Name = "PhantomHubV2"
    ui.Parent = game.CoreGui
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ui.ResetOnSpawn = false

    -- Responsive sizing based on device
    local mainSize = isMobile and UDim2.new(0, math.min(400, workspace.CurrentCamera.ViewportSize.X * 0.9), 0, math.min(300, workspace.CurrentCamera.ViewportSize.Y * 0.7)) or UDim2.new(0, 470, 0, 283)
    local mainPosition = isMobile and UDim2.new(0.5, -mainSize.X.Offset/2, 0.5, -mainSize.Y.Offset/2) or UDim2.new(0.377, 0, 0.368, 0)

    Main.Name = "Main"
    Main.Parent = ui
    Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Main.BorderSizePixel = 0
    Main.Position = mainPosition
    Main.Size = mainSize
    Main.Active = true
    Main.Selectable = true
    Main.Draggable = not isMobile -- Disable dragging on mobile

    UICorner_9.CornerRadius = UDim.new(0, 8)
    UICorner_9.Parent = Main

    Shadow.Name = "Shadow"
    Shadow.Parent = Main
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Shadow.BackgroundTransparency = 1.000
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = 0
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)

    -- Mobile sidebar toggle
    local sidebarVisible = true
    
    tabs.Name = "tabs"
    tabs.Parent = Main
    tabs.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    tabs.BorderSizePixel = 0
    tabs.Position = UDim2.new(0, 0, 0, 35)
    tabs.Size = isMobile and UDim2.new(0, 100, 1, -35) or UDim2.new(0, 122, 1, -35)

    UICorner_2.CornerRadius = UDim.new(0, 8)
    UICorner_2.Parent = tabs

    Cover.Name = "Cover"
    Cover.Parent = tabs
    Cover.AnchorPoint = Vector2.new(1, 0.5)
    Cover.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    Cover.BorderSizePixel = 0
    Cover.Position = UDim2.new(1, 0, 0.5, 0)
    Cover.Size = UDim2.new(0, 5, 1, 0)

    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    Top.BorderSizePixel = 0
    Top.Size = UDim2.new(1, 0, 0, 34)

    UICorner_5.CornerRadius = UDim.new(0, 8)
    UICorner_5.Parent = Top

    Cover_2.Name = "Cover"
    Cover_2.Parent = Top
    Cover_2.AnchorPoint = Vector2.new(0.5, 1)
    Cover_2.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    Cover_2.BorderSizePixel = 0
    Cover_2.Position = UDim2.new(0.5, 0, 1, 0)
    Cover_2.Size = UDim2.new(1, 0, 0, 4)

    Line.Name = "Line"
    Line.Parent = Top
    Line.AnchorPoint = Vector2.new(0.5, 1)
    Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Line.BackgroundTransparency = 0.920
    Line.Position = UDim2.new(0.5, 0, 1, 1)
    Line.Size = UDim2.new(1, 0, 0, 1)

    -- Logo with local file support and fallback
    Logo.Name = "Logo"
    Logo.Parent = Top
    Logo.AnchorPoint = Vector2.new(0, 0.5)
    Logo.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    Logo.BackgroundTransparency = 0.000
    Logo.Position = UDim2.new(0, 4, 0.5, 0)
    Logo.Size = UDim2.new(0, 26, 0, 26)
    
    -- Try to load local logo first, then fallback
    local logoLoaded = false
    if isfile("PhantomHubV2/Icons/phantom_logo.png") then
        pcall(function()
            Logo.Image = getcustomasset("PhantomHubV2/Icons/phantom_logo.png")
            Logo.ImageColor3 = Color3.fromRGB(138, 43, 226) -- Apply purple tint
            logoLoaded = true
        end)
    end
    
    -- Add corner radius to logo
    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 6)
    LogoCorner.Parent = Logo
    
    -- Add "P" text as fallback if logo didn't load
    if not logoLoaded then
        local LogoText = Instance.new("TextLabel")
        LogoText.Name = "LogoText"
        LogoText.Parent = Logo
        LogoText.BackgroundTransparency = 1.000
        LogoText.Size = UDim2.new(1, 0, 1, 0)
        LogoText.Font = Enum.Font.GothamBold
        LogoText.Text = "P"
        LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
        LogoText.TextSize = 16
        LogoText.TextScaled = true
    end

    -- Mobile sidebar toggle button
    if isMobile then
        MobileToggle.Name = "MobileToggle"
        MobileToggle.Parent = Top
        MobileToggle.AnchorPoint = Vector2.new(0, 0.5)
        MobileToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        MobileToggle.BackgroundTransparency = 1.000
        MobileToggle.Position = UDim2.new(0, 35, 0.5, 0)
        MobileToggle.Size = UDim2.new(0, 20, 0, 20)
        MobileToggle.Image = "rbxassetid://3926307971"
        MobileToggle.ImageColor3 = Color3.fromRGB(138, 43, 226)
        MobileToggle.ImageRectOffset = Vector2.new(4, 4)
        MobileToggle.ImageRectSize = Vector2.new(36, 36)
        
        MobileToggle.MouseButton1Click:Connect(function()
            sidebarVisible = not sidebarVisible
            local targetSize = sidebarVisible and UDim2.new(0, 100, 1, -35) or UDim2.new(0, 0, 1, -35)
            local targetPagesPos = sidebarVisible and UDim2.new(0, 108, 0, 42) or UDim2.new(0, 8, 0, 42)
            local targetPagesSize = sidebarVisible and UDim2.new(1, -116, 1, -50) or UDim2.new(1, -16, 1, -50)
            
            TweenService:Create(tabs, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
            TweenService:Create(Pages, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPagesPos, Size = targetPagesSize}):Play()
            TweenService:Create(MobileToggle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = sidebarVisible and 0 or 180}):Play()
        end)
    end

    Close.Name = "Close"
    Close.Parent = Top
    Close.AnchorPoint = Vector2.new(1, 0.5)
    Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Close.BackgroundTransparency = 1.000
    Close.Position = UDim2.new(1, -6, 0.5, 0)
    Close.Size = isMobile and UDim2.new(0, 24, 0, 24) or UDim2.new(0, 20, 0, 20)
    Close.Image = "http://www.roblox.com/asset/?id=7755372427"
    Close.ImageColor3 = Color3.fromRGB(199, 199, 199)
    Close.ScaleType = Enum.ScaleType.Crop
    
    Close.MouseButton1Click:Connect(function()
        ui:Destroy()
    end)
    
    Close.MouseEnter:Connect(function()
        TweenService:Create(Close, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(255,255,255)}):Play()
    end)
    
    Close.MouseLeave:Connect(function()
        TweenService:Create(Close, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(166, 166, 166)}):Play()
    end)

    -- Hide resize button on mobile
    if not isMobile then
        Resize.Name = "Resize"
        Resize.Parent = Main
        Resize.AnchorPoint = Vector2.new(1, 1)
        Resize.BackgroundTransparency = 1.000
        Resize.Position = UDim2.new(1, -4, 1, -4)
        Resize.Size = UDim2.new(0, 16, 0, 16)
        Resize.ZIndex = 2
        Resize.Image = "rbxassetid://3926307971"
        Resize.ImageColor3 = Color3.fromRGB(138, 43, 226)
        Resize.ImageRectOffset = Vector2.new(204, 364)
        Resize.ImageRectSize = Vector2.new(36, 36)
    end

    GameName.Name = "GameName"
    GameName.Parent = Top
    GameName.AnchorPoint = Vector2.new(0, 0.5)
    GameName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GameName.BackgroundTransparency = 1.000
    GameName.Position = isMobile and UDim2.new(0, 60, 0.5, 0) or UDim2.new(0, 36, 0.5, 0)
    GameName.Size = isMobile and UDim2.new(0, 120, 0, 22) or UDim2.new(0, 165, 0, 22)
    GameName.Font = Enum.Font.GothamBold
    GameName.Text = title or "Phantom Hub V2"
    GameName.TextColor3 = Color3.fromRGB(138, 43, 226)
    GameName.TextSize = isMobile and 12 or 14
    GameName.TextXAlignment = Enum.TextXAlignment.Left
    GameName.TextScaled = isMobile

    Pages.Name = "Pages"
    Pages.Parent = Main
    Pages.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Pages.BorderSizePixel = 0
    Pages.Position = isMobile and UDim2.new(0, 108, 0, 42) or UDim2.new(0, 130, 0, 42)
    Pages.Size = isMobile and UDim2.new(1, -116, 1, -50) or UDim2.new(1, -138, 1, -50)

    TabsContainer.Name = "TabsContainer"
    TabsContainer.Parent = tabs
    TabsContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabsContainer.BackgroundTransparency = 1.000
    TabsContainer.Size = UDim2.new(1, 0, 1, 0)

    TabsList.Name = "TabsList"
    TabsList.Parent = TabsContainer
    TabsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabsList.SortOrder = Enum.SortOrder.LayoutOrder
    TabsList.Padding = UDim.new(0, 5)

    UIPadding.Parent = TabsContainer
    UIPadding.PaddingTop = UDim.new(0, 5)
    
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = tabs

    Cover.Name = "Cover"
    Cover.Parent = tabs
    Cover.AnchorPoint = Vector2.new(1, 0.5)
    Cover.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    Cover.BorderSizePixel = 0
    Cover.Position = UDim2.new(1, 0, 0.5, 0)
    Cover.Size = UDim2.new(0, 5, 1, 0)

    -- Resize functionality (desktop only)
    if not isMobile then
        local function setupResize()
            local mouse = Players.LocalPlayer:GetMouse()
            local input = UserInputService
            
            local locationX = input:GetMouseLocation().X
            local locationY = input:GetMouseLocation().Y
            
            local defaultX = 470
            local defaultY = 283
            
            Resize.MouseButton1Down:Connect(function()
                locationX = input:GetMouseLocation().X
                locationY = input:GetMouseLocation().Y
                local moveConnection
                local releaseConnection
                
                moveConnection = mouse.Move:Connect(function()
                    local DeltaX = input:GetMouseLocation().X - locationX
                    local DeltaY = input:GetMouseLocation().Y - locationY
                    
                    Main.Size = Main.Size + UDim2.new(0, DeltaX, 0, DeltaY)
                    locationX = input:GetMouseLocation().X
                    locationY = input:GetMouseLocation().Y
                end)
                
                releaseConnection = input.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        moveConnection:Disconnect()
                        releaseConnection:Disconnect()
                    end
                end)
            end)
            
            Main.Changed:Connect(function()
                if Main.Size.X.Offset < defaultX then
                    Main.Size = UDim2.new(0, defaultX, 0, Main.Size.Y.Offset)
                end
                if Main.Size.Y.Offset < defaultY then
                    Main.Size = UDim2.new(0, Main.Size.X.Offset, 0, defaultY)
                end
            end)
        end
        
        coroutine.wrap(setupResize)()
    end

    -- Mobile orientation handling
    if isMobile then
        local function handleOrientationChange()
            local viewportSize = workspace.CurrentCamera.ViewportSize
            local newSize = UDim2.new(0, math.min(400, viewportSize.X * 0.9), 0, math.min(300, viewportSize.Y * 0.7))
            local newPosition = UDim2.new(0.5, -newSize.X.Offset/2, 0.5, -newSize.Y.Offset/2)
            
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = newSize,
                Position = newPosition
            }):Play()
        end
        
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(handleOrientationChange)
    end

    local Tabs = {}
    function Tabs:Tab(title)
        local UIListLayout = Instance.new('UIListLayout')
        local UIPadding = Instance.new("UIPadding")
        local Page = Instance.new("ScrollingFrame")
        local UICorner = Instance.new("UICorner")
        local TabButton = Instance.new("TextButton")

        TabButton.Name = "TabButton"
        TabButton.Parent = TabsContainer
        TabButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        TabButton.BackgroundTransparency = 1
        TabButton.Size = isMobile and UDim2.new(1, -8, 0, 28) or UDim2.new(1, -12, 0, 30)
        TabButton.AutoButtonColor = false
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Text = title or 'Home'
        TabButton.TextColor3 = Color3.fromRGB(72, 72, 72)
        TabButton.TextSize = isMobile and 12 or 14
        TabButton.TextScaled = isMobile

        UICorner.CornerRadius = UDim.new(0, 6)
        UICorner.Parent = TabButton

        Page.Name = "Page"
        Page.Visible = false
        Page.Parent = Pages
        Page.Active = true
        Page.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Page.BackgroundTransparency = 1.000
        Page.BorderSizePixel = 0
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.CanvasPosition = Vector2.new(0, 0)
        Page.ScrollBarThickness = isMobile and 4 or 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
        Page.ScrollingEnabled = true
        Page.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable

        UIListLayout.Parent = Page
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 6)

        UIPadding.Parent = Page
        UIPadding.PaddingTop = UDim.new(0, 5)

        UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
        end)

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            Page.Visible = true

            for _, v in pairs(TabsContainer:GetChildren()) do
                if v.Name == 'TabButton' then
                    TweenService:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(72, 72, 72)}):Play()
                end
            end
            TweenService:Create(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.6}):Play()
            TweenService:Create(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)

        local TabFunctions = {}
        
        function TabFunctions:Button(title, callback)
            callback = callback or function() end
            local Button = Instance.new("TextButton")
            local UICorner = Instance.new("UICorner")

            Button.Name = "Button"
            Button.Text = title or 'Button'
            Button.Parent = Page
            Button.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            Button.BorderSizePixel = 0
            Button.Size = isMobile and UDim2.new(1, -6, 0, 38) or UDim2.new(1, -6, 0, 34)
            Button.AutoButtonColor = false
            Button.Font = Enum.Font.GothamMedium
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = isMobile and 13 or 14
            Button.TextScaled = isMobile

            UICorner.CornerRadius = UDim.new(0, 8)
            UICorner.Parent = Button

            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(160, 60, 240)}):Play()
            end)

            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(138, 43, 226)}):Play()
            end)

            Button.MouseButton1Click:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Button.Size - UDim2.new(0, 2, 0, 2)}):Play()
                wait(0.1)
                TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Button.Size + UDim2.new(0, 2, 0, 2)}):Play()
                callback()
            end)
        end

        function TabFunctions:Toggle(title, value, callback)
            local Toggle = Instance.new("TextButton")
            local UICorner = Instance.new("UICorner")
            local Title = Instance.new("TextLabel")
            local Toggle_2 = Instance.new("Frame")
            local Stroke = Instance.new('UIStroke')
            local Checked = Instance.new("ImageLabel")
            value = value or false
            callback = callback or function() end

            Toggle.Name = "Toggle"
            Toggle.Parent = Page
            Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Toggle.Size = isMobile and UDim2.new(1, -6, 0, 38) or UDim2.new(1, -6, 0, 34)
            Toggle.AutoButtonColor = false
            Toggle.Font = Enum.Font.SourceSans
            Toggle.Text = ""
            Toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
            Toggle.TextSize = 14.000

            UICorner.CornerRadius = UDim.new(0, 8)
            UICorner.Parent = Toggle

            Title.Name = "Title"
            Title.Parent = Toggle
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1.000
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Size = UDim2.new(1, -6, 1, 0)
            Title.Font = Enum.Font.GothamMedium
            Title.Text = title or "Toggle"
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = isMobile and 13 or 14
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.TextScaled = isMobile

            Toggle_2.Name = "Toggle"
            Toggle_2.Parent = Toggle
            Toggle_2.AnchorPoint = Vector2.new(1, 0.5)
            Toggle_2.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            Toggle_2.BackgroundTransparency = 1.000
            Toggle_2.BorderSizePixel = 0
            Toggle_2.Position = UDim2.new(1, -8, 0.5, 0)
            Toggle_2.Size = isMobile and UDim2.new(0, 16, 0, 16) or UDim2.new(0, 14, 0, 14)

            Checked.Name = "Checked"
            Checked.Parent = Toggle_2
            Checked.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Checked.BackgroundTransparency = 1.000
            Checked.Position = UDim2.new(-0.214285731, 0, -0.214285731, 0)
            Checked.Size = UDim2.new(0, 20, 0, 20)
            Checked.Image = "http://www.roblox.com/asset/?id=7812909048"
            Checked.ImageTransparency = 1
            Checked.ScaleType = Enum.ScaleType.Fit

            Stroke.Parent = Toggle_2
            Stroke.LineJoinMode = Enum.LineJoinMode.Round
            Stroke.Thickness = 2
            Stroke.Color = Color3.fromRGB(138, 43, 226)
            
            Toggle.MouseEnter:Connect(function()
                TweenService:Create(Toggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            end)

            Toggle.MouseLeave:Connect(function()
                TweenService:Create(Toggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
            end)

            local toggled = value
            if toggled then
                TweenService:Create(Toggle_2, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
                TweenService:Create(Checked, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
                callback(toggled)
            end

            Toggle.MouseButton1Click:Connect(function()
                if toggled then
                    toggled = false
                    TweenService:Create(Toggle_2, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(Checked, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
                else
                    toggled = true
                    TweenService:Create(Toggle_2, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
                    TweenService:Create(Checked, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
                end
                callback(toggled)
            end)
        end

        function TabFunctions:Label(labeltext)
            local TextLabel = Instance.new("TextLabel")
            local UICorner_6 = Instance.new("UICorner")

            TextLabel.Parent = Page
            TextLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            TextLabel.BorderSizePixel = 0
            TextLabel.Size = isMobile and UDim2.new(1, -6, 0, 38) or UDim2.new(1, -6, 0, 34)
            TextLabel.Font = Enum.Font.GothamMedium
            TextLabel.Text = "  " .. (labeltext or "Label")
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = isMobile and 13 or 14
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.TextScaled = isMobile

            UICorner_6.CornerRadius = UDim.new(0, 8)
            UICorner_6.Parent = TextLabel
        end

        function TabFunctions:Slider(title, min, max, def, callback)
            local dragging = false
            local Slider = Instance.new("Frame")
            local UICorner = Instance.new("UICorner")
            local Title = Instance.new("TextLabel")
            local SliderClick = Instance.new("TextButton")
            local UICorner_2 = Instance.new("UICorner")
            local SliderDrag = Instance.new("Frame")
            local UICorner_3 = Instance.new("UICorner")
            local Value = Instance.new("TextLabel")
            callback = callback or function() end

            Slider.Name = "Slider"
            Slider.Parent = Page
            Slider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Slider.Size = isMobile and UDim2.new(1, -6, 0, 52) or UDim2.new(1, -6, 0, 48)

            UICorner.CornerRadius = UDim.new(0, 8)
            UICorner.Parent = Slider

            Title.Name = "Title"
            Title.Parent = Slider
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1.000
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Size = UDim2.new(1, -6, 0, isMobile and 36 or 34)
            Title.Font = Enum.Font.GothamMedium
            Title.Text = title or "Slider"
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = isMobile and 13 or 14
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.TextScaled = isMobile

            SliderClick.Name = "SliderClick"
            SliderClick.Parent = Slider
            SliderClick.AnchorPoint = Vector2.new(0.5, 1)
            SliderClick.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
            SliderClick.Position = UDim2.new(0.5, 0, 1, -8)
            SliderClick.Size = UDim2.new(1, -12, 0, isMobile and 8 or 6)
            SliderClick.AutoButtonColor = false
            SliderClick.Text = ''

            UICorner_2.CornerRadius = UDim.new(0, 8)
            UICorner_2.Parent = SliderClick

            SliderDrag.Name = "SliderDrag"
            SliderDrag.Parent = SliderClick
            SliderDrag.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            SliderDrag.Size = UDim2.new(math.clamp(def / max, 0, 1), 0, 1, 0)

            UICorner_3.CornerRadius = UDim.new(0, 8)
            UICorner_3.Parent = SliderDrag

            Value.Name = "Value"
            Value.Parent = Slider
            Value.AnchorPoint = Vector2.new(1, 0)
            Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Value.BackgroundTransparency = 1.000
            Value.Position = UDim2.new(1, -10, 0, 0)
            Value.Size = UDim2.new(1, 0, 0, isMobile and 36 or 34)
            Value.Font = Enum.Font.GothamMedium
            Value.Text = tostring(def)
            Value.TextColor3 = Color3.fromRGB(255, 255, 255)
            Value.TextSize = isMobile and 13 or 14
            Value.TextXAlignment = Enum.TextXAlignment.Right
            Value.TextScaled = isMobile

            local function slide(input)
                local pos = UDim2.new(
                    math.clamp((input.Position.X - SliderClick.AbsolutePosition.X) / SliderClick.AbsoluteSize.X, 0, 1),
                    0, 1, 0
                )
                SliderDrag:TweenSize(pos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
                local s = math.floor(((pos.X.Scale * max) / max) * (max - min) + min)
                Value.Text = tostring(s)
                callback(s)
            end

            SliderClick.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    slide(input)
                    dragging = true
                end
            end)

            SliderClick.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    slide(input)
                end
            end)
        end

        function TabFunctions:KeyBind(text, keypreset, callback)
            local binding = false
            callback = callback or function() end
            local Key = keypreset and keypreset.Name or "None"
            local KeyBind = Instance.new("TextButton")
            local UICorner_7 = Instance.new("UICorner")
            local Title = Instance.new("TextLabel")
            local CurrentKey = Instance.new("TextLabel")
            local UICorner_8 = Instance.new("UICorner")

            KeyBind.Name = "KeyBind"
            KeyBind.Parent = Page
            KeyBind.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            KeyBind.Size = isMobile and UDim2.new(1, -6, 0, 38) or UDim2.new(1, -6, 0, 34)
            KeyBind.AutoButtonColor = false
            KeyBind.Font = Enum.Font.SourceSans
            KeyBind.Text = ""
            KeyBind.TextColor3 = Color3.fromRGB(0, 0, 0)
            KeyBind.TextSize = 14.000

            UICorner_7.CornerRadius = UDim.new(0, 8)
            UICorner_7.Parent = KeyBind

            Title.Name = "Title"
            Title.Parent = KeyBind
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1.000
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Size = UDim2.new(1, -6, 1, 0)
            Title.Font = Enum.Font.GothamMedium
            Title.Text = text or "KeyBind"
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = isMobile and 13 or 14
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.TextScaled = isMobile

            CurrentKey.Name = "CurrentKey"
            CurrentKey.Parent = KeyBind
            CurrentKey.AnchorPoint = Vector2.new(1, 0.5)
            CurrentKey.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
            CurrentKey.Position = UDim2.new(1, -6, 0.5, 0)
            CurrentKey.Size = UDim2.new(0, isMobile and 50 or 46, 0, isMobile and 26 or 24)
            CurrentKey.Font = Enum.Font.GothamMedium
            CurrentKey.Text = Key or "None"
            CurrentKey.TextColor3 = Color3.fromRGB(255, 255, 255)
            CurrentKey.TextSize = isMobile and 12 or 14
            CurrentKey.TextScaled = isMobile

            UICorner_8.CornerRadius = UDim.new(0, 6)
            UICorner_8.Parent = CurrentKey

            KeyBind.MouseButton1Click:Connect(function()
                CurrentKey.Text = "..."
                local connection
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if not gameProcessed then
                        if input.KeyCode.Name ~= "Unknown" then
                            CurrentKey.Text = input.KeyCode.Name
                            Key = input.KeyCode.Name
                            connection:Disconnect()
                        end
                    end
                end)
            end)

            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed then
                    if input.KeyCode.Name == Key then
                        callback(Key)
                    end
                end
            end)
        end

        function TabFunctions:Dropdown(title, list, callback)
            list = list or {}
            callback = callback or function() end
            local Dropdown = Instance.new("Frame")
            local UIListLayout_69 = Instance.new("UIListLayout")
            local Choose = Instance.new("Frame")
            local UICorner = Instance.new("UICorner")
            local Title = Instance.new("TextLabel")
            local arrow = Instance.new("ImageButton")
            local OptionHolder = Instance.new("Frame")
            local UICorner_2 = Instance.new("UICorner")
            local OptionList = Instance.new("UIListLayout")
            local UIPadding = Instance.new("UIPadding")

            Dropdown.Name = "Dropdown"
            Dropdown.Parent = Page
            Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Dropdown.BackgroundTransparency = 1.000
            Dropdown.BorderColor3 = Color3.fromRGB(27, 42, 53)
            Dropdown.BorderSizePixel = 0
            Dropdown.ClipsDescendants = true
            Dropdown.Size = isMobile and UDim2.new(1, -6, 0, 38) or UDim2.new(1, -6, 0, 34)

            UIListLayout_69.Parent = Dropdown
            UIListLayout_69.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout_69.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout_69.Padding = UDim.new(0, 5)

            local dropped = false
            Choose.Name = "Choose"
            Choose.Parent = Dropdown
            Choose.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Choose.BorderSizePixel = 0
            Choose.Size = UDim2.new(1, 0, 0, isMobile and 38 or 34)

            UICorner.CornerRadius = UDim.new(0, 8)
            UICorner.Parent = Choose

            Title.Name = "Title"
            Title.Parent = Choose
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1.000
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Size = UDim2.new(1, -6, 1, 0)
            Title.Font = Enum.Font.GothamMedium
            Title.Text = title or "Dropdown"
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = isMobile and 13 or 14
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.TextScaled = isMobile

            arrow.Name = "arrow"
            arrow.Parent = Choose
            arrow.AnchorPoint = Vector2.new(1, 0.5)
            arrow.BackgroundTransparency = 1.000
            arrow.LayoutOrder = 10
            arrow.Position = UDim2.new(1, -2, 0.5, 0)
            arrow.Size = UDim2.new(0, isMobile and 30 or 28, 0, isMobile and 30 or 28)
            arrow.ZIndex = 2
            arrow.Image = "rbxassetid://3926307971"
            arrow.ImageColor3 = Color3.fromRGB(138, 43, 226)
            arrow.ImageRectOffset = Vector2.new(324, 524)
            arrow.ImageRectSize = Vector2.new(36, 36)
            arrow.ScaleType = Enum.ScaleType.Crop

            OptionHolder.Name = "OptionHolder"
            OptionHolder.Parent = Dropdown
            OptionHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            OptionHolder.BorderSizePixel = 0
            OptionHolder.Size = UDim2.new(1, 0, 1, isMobile and -42 or -38)

            UICorner_2.CornerRadius = UDim.new(0, 8)
            UICorner_2.Parent = OptionHolder

            OptionList.Name = "OptionList"
            OptionList.Parent = OptionHolder
            OptionList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            OptionList.SortOrder = Enum.SortOrder.LayoutOrder
            OptionList.Padding = UDim.new(0, 5)

            UIPadding.Parent = OptionHolder
            UIPadding.PaddingTop = UDim.new(0, 8)

            Choose.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    if not dropped then
                        Dropdown:TweenSize(UDim2.new(1, -7, 0, UIListLayout_69.AbsoluteContentSize.Y), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .15, true)
                        TweenService:Create(arrow, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 180}):Play()
                        dropped = true
                    else
                        TweenService:Create(arrow, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
                        Dropdown:TweenSize(UDim2.new(1, -7, 0, isMobile and 38 or 34), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .12)
                        dropped = false
                    end
                end
            end)

            for i, v in pairs(list) do
                local Option = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")

                Option.Name = "Option"
                Option.Parent = OptionHolder
                Option.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
                Option.BorderSizePixel = 0
                Option.Size = UDim2.new(1, -16, 0, isMobile and 32 or 30)
                Option.AutoButtonColor = false
                Option.Font = Enum.Font.GothamMedium
                Option.Text = v
                Option.TextColor3 = Color3.fromRGB(255, 255, 255)
                Option.TextSize = isMobile and 13 or 14
                Option.TextScaled = isMobile

                UICorner.CornerRadius = UDim.new(0, 8)
                UICorner.Parent = Option

                Option.MouseButton1Click:Connect(function()
                    callback(v)
                    dropped = false
                    TweenService:Create(arrow, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
                    Dropdown:TweenSize(UDim2.new(1, -5, 0, isMobile and 38 or 34), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .15, true)
                    Title.Text = title .. ": " .. v
                end)
                
                OptionHolder:TweenSize(UDim2.new(1, 0, 0, OptionList.AbsoluteContentSize.Y + 15), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .15, true)
            end

            local DropdownFunc = {}
            function DropdownFunc:RefreshDropdown(newlist)
                dropped = false
                TweenService:Create(arrow, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
                Dropdown:TweenSize(UDim2.new(1, -5, 0, isMobile and 38 or 34), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.15, true)

                local newlist = newlist or {}
                for i, v in pairs(OptionHolder:GetChildren()) do
                    if v:IsA("TextButton") then
                        v:Destroy()
                    end
                end

                for i, v in pairs(newlist) do
                    local Option = Instance.new("TextButton")
                    local UICorner = Instance.new("UICorner")

                    Option.Name = "Option"
                    Option.Parent = OptionHolder
                    Option.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
                    Option.BorderSizePixel = 0
                    Option.Size = UDim2.new(1, -16, 0, isMobile and 32 or 30)
                    Option.AutoButtonColor = false
                    Option.Font = Enum.Font.GothamMedium
                    Option.Text = v
                    Option.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Option.TextSize = isMobile and 13 or 14
                    Option.TextScaled = isMobile

                    UICorner.CornerRadius = UDim.new(0, 8)
                    UICorner.Parent = Option

                    Option.MouseButton1Click:Connect(function()
                        callback(v)
                        dropped = false
                        TweenService:Create(arrow, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
                        Dropdown:TweenSize(UDim2.new(1, -5, 0, isMobile and 38 or 34), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
                        Title.Text = title .. ": " .. v
                    end)
                end

                OptionHolder:TweenSize(UDim2.new(1, 0, 0, OptionList.AbsoluteContentSize.Y + 15), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .15, true)
            end
            return DropdownFunc
        end

        return TabFunctions
    end
    return Tabs
end

return Library
