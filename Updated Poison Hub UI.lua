
print("Loading BigBaseplate...")
loadstring(game:HttpGet("https://raw.githubusercontent.com/loading123599/Poisons-Hub-V1.1/refs/heads/main/BigBaseplate.lua"))()
print("BigBaseplate loaded successfully!")

wait(1)

print("Loading Player Tags system with Cloudflare integration...")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local CLOUDFLARE_WORKER_URL = "https://poison-hub-tracker.mariapachucaluisa0.workers.dev"

-- Define founders/owners with their custom tags (keeping original names and roles)
local FounderTags = {
   ["GoodHelper12345"] = "Poison Owner",
   ["karez6"] = "Poison Owner",
   ["nagerboyloading"] = "Poison Owner",
   ["1can3uss"] = "Poison Owner",
   ["auralinker"] = "Poison Admin",
   ["Skyler_Saint"] = "Poison<3"
}

-- Color scheme (Black and Purple)
local RankColors = {
   ["Poison Owner"] = Color3.fromRGB(138, 43, 226),  -- Purple
   ["Poison User"] = Color3.fromRGB(128, 0, 128),    -- Darker Purple
   ["Poison Admin"] = Color3.fromRGB(255, 0, 0),     -- Red
   ["Poison VIP"] = Color3.fromRGB(255, 215, 0),     -- Gold
   ["Poison<3"] = Color3.fromRGB(255, 105, 180)      -- Pink
}

-- Emoji for each rank
local RankEmojis = {
   ["Poison Owner"] = "👑",
   ["Poison User"] = "☠️",
   ["Poison Admin"] = "⚡",
   ["Poison VIP"] = "💎",
   ["Poison<3"] = "❤"
}

-- Create a folder to track script executors
local executorsFolder = Instance.new("Folder")
executorsFolder.Name = "PoisonHubExecutors"
executorsFolder.Parent = workspace

-- Create a notification to show the script is working
local function showNotification(title, text, duration)
   local StarterGui = game:GetService("StarterGui")
   pcall(function()
       StarterGui:SetCore("SendNotification", {
           Title = title,
           Text = text,
           Duration = duration
       })
   end)
end

-- Function to make HTTP requests to the Cloudflare Worker
local function makeRequest(endpoint, method, data)
    local url = CLOUDFLARE_WORKER_URL .. endpoint
    
    local headers = {
        ["Content-Type"] = "application/json"
    }
    
    local options = {
        Url = url,
        Method = method,
        Headers = headers
    }
    
    if data then
        options.Body = HttpService:JSONEncode(data)
    end
    
    local success, response = pcall(function()
        return HttpService:RequestAsync(options)
    end)
    
    if success and response.Success then
        return true, HttpService:JSONDecode(response.Body)
    else
        warn("HTTP Request failed:", response and response.StatusMessage or "Unknown error")
        return false, response and response.StatusMessage or "Unknown error"
    end
end

-- Function to create and apply nametag
local function applyNameTag(player)
   -- Only apply tags to players who are in the executorsFolder
   if not executorsFolder:FindFirstChild(player.Name) and player ~= Players.LocalPlayer then return end
   
   -- Determine player's rank
   local rankText = "Poison User" -- Default rank
   if FounderTags[player.Name] then
      rankText = FounderTags[player.Name]
   end
   
   local rankColor = RankColors[rankText] or RankColors["Poison User"]
   local rankEmoji = RankEmojis[rankText] or RankEmojis["Poison User"]
   
   local function attachTagToCharacter(character)
      task.wait(0.5) -- Wait for character to fully load
      
      local head = character:FindFirstChild("Head")
      if not head then return end
      
      -- Remove existing tag if present
      local existingTag = head:FindFirstChild("PoisonTag")
      if existingTag then existingTag:Destroy() end
      
      -- Disable default Roblox nametag
      local humanoid = character:FindFirstChildOfClass("Humanoid")
      if humanoid then
         humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
      end
      
      -- Create new tag
      local tag = Instance.new("BillboardGui")
      tag.Name = "PoisonTag"
      tag.Size = UDim2.new(0, 200, 0, 50)
      tag.MaxDistance = 100
      tag.LightInfluence = 0
      tag.StudsOffset = Vector3.new(0, 2.5, 0)
      tag.AlwaysOnTop = true
      tag.Parent = head
      
      -- Background frame
      local background = Instance.new("Frame")
      background.Size = UDim2.new(1, 0, 1, 0)
      background.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Black background
      background.BackgroundTransparency = 0.2
      background.BorderSizePixel = 0
      background.Parent = tag
      
      -- Rounded corners
      local corner = Instance.new("UICorner")
      corner.CornerRadius = UDim.new(0.3, 0)
      corner.Parent = background
      
      -- Add border
      local border = Instance.new("UIStroke")
      border.Color = rankColor
      border.Thickness = 2
      border.Transparency = 0.2
      border.Parent = background
      
      -- Emoji label
      local emojiLabel = Instance.new("TextLabel")
      emojiLabel.Size = UDim2.new(0, 30, 0, 30)
      emojiLabel.Position = UDim2.new(0, 10, 0.5, -15)
      emojiLabel.BackgroundTransparency = 1
      emojiLabel.Text = rankEmoji
      emojiLabel.TextSize = 24
      emojiLabel.Font = Enum.Font.GothamBold
      emojiLabel.TextColor3 = Color3.new(1, 1, 1)
      emojiLabel.ZIndex = 2
      emojiLabel.Parent = background
      
      -- Animate emoji with heartbeat effect
      local heartbeatTweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
      local heartbeatTween = TweenService:Create(emojiLabel, heartbeatTweenInfo, {TextSize = 20})
      heartbeatTween:Play()
      
      -- Rank text
      local rankLabel = Instance.new("TextLabel")
      rankLabel.Size = UDim2.new(1, -50, 0.5, 0)
      rankLabel.Position = UDim2.new(0, 45, 0, 5)
      rankLabel.BackgroundTransparency = 1
      rankLabel.Text = rankText
      rankLabel.TextColor3 = rankColor
      rankLabel.TextSize = 16
      rankLabel.Font = Enum.Font.GothamBold
      rankLabel.TextXAlignment = Enum.TextXAlignment.Left
      rankLabel.TextStrokeTransparency = 0.7
      rankLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
      rankLabel.Parent = background
      
      -- Username text
      local userLabel = Instance.new("TextLabel")
      userLabel.Size = UDim2.new(1, -50, 0.5, 0)
      userLabel.Position = UDim2.new(0, 45, 0.5, 0)
      userLabel.BackgroundTransparency = 1
      userLabel.Text = "@" .. player.Name
      userLabel.TextColor3 = Color3.new(1, 1, 1)
      userLabel.TextSize = 14
      userLabel.Font = Enum.Font.GothamBold
      userLabel.TextXAlignment = Enum.TextXAlignment.Left
      userLabel.TextStrokeTransparency = 0.7
      userLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
      userLabel.Parent = background
      
      -- Add click functionality for teleporting
      if player ~= Players.LocalPlayer then
         local clickButton = Instance.new("TextButton")
         clickButton.Size = UDim2.new(1, 0, 1, 0)
         clickButton.BackgroundTransparency = 1
         clickButton.Text = ""
         clickButton.ZIndex = 10
         clickButton.Parent = background
         
         clickButton.MouseButton1Click:Connect(function()
            local localChar = Players.LocalPlayer.Character
            local targetChar = player.Character
            
            if localChar and targetChar then
               local localHRP = localChar:FindFirstChild("HumanoidRootPart")
               local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
               
               if localHRP and targetHRP then
                  -- Create teleport effect
                  local effect = Instance.new("Part")
                  effect.Size = Vector3.new(1, 1, 1)
                  effect.Anchored = true
                  effect.CanCollide = false
                  effect.Material = Enum.Material.Neon
                  effect.Color = rankColor
                  effect.CFrame = localHRP.CFrame
                  effect.Transparency = 0.5
                  effect.Shape = Enum.PartType.Ball
                  effect.Parent = workspace
                  
                  -- Teleport with offset
                  localHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
                  
                  -- Clean up effect
                  game:GetService("Debris"):AddItem(effect, 1)
               end
            end
         end)
         
         -- Hover effects
         clickButton.MouseEnter:Connect(function()
            TweenService:Create(background, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
         end)
         
         clickButton.MouseLeave:Connect(function()
            TweenService:Create(background, TweenInfo.new(0.3), {BackgroundTransparency = 0.2}):Play()
         end)
      end
      
      -- Add particles
      local particlesContainer = Instance.new("Frame")
      particlesContainer.Size = UDim2.new(1, 0, 1, 0)
      particlesContainer.BackgroundTransparency = 1
      particlesContainer.ZIndex = 1
      particlesContainer.ClipsDescendants = true
      particlesContainer.Parent = background
      
      -- Create particles
      for i = 1, 15 do
         spawn(function()
            while tag and tag.Parent do
               local particle = Instance.new("Frame")
               particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
               particle.Position = UDim2.new(math.random(), 0, 1, 0)
               particle.BackgroundColor3 = rankColor
               particle.BackgroundTransparency = math.random(0, 0.5)
               particle.BorderSizePixel = 0
               particle.ZIndex = 1
               
               local particleCorner = Instance.new("UICorner")
               particleCorner.CornerRadius = UDim.new(1, 0)
               particleCorner.Parent = particle
               
               particle.Parent = particlesContainer
               
               local tweenInfo = TweenInfo.new(math.random(10, 20)/10, Enum.EasingStyle.Linear)
               local tween = TweenService:Create(particle, tweenInfo, {
                  Position = UDim2.new(particle.Position.X.Scale, 0, -0.5, 0),
                  BackgroundTransparency = 1,
                  Size = UDim2.new(0, 0, 0, 0)
               })
               
               tween:Play()
               tween.Completed:Connect(function()
                  particle:Destroy()
               end)
               
               task.wait(math.random(5, 15)/10)
            end
         end)
      end
   end
   
   if player.Character then
      attachTagToCharacter(player.Character)
   end
   
   player.CharacterAdded:Connect(attachTagToCharacter)
end

-- Function to refresh all nametags
local function refreshAllTags()
   for _, player in ipairs(Players:GetPlayers()) do
      applyNameTag(player)
   end
end

-- Function to add a custom tag for a specific player
local function addCustomTag(playerName, tagType)
   FounderTags[playerName] = tagType
   
   -- Update tag if player is in game
   local player = Players:FindFirstChild(playerName)
   if player then
      applyNameTag(player)
   end
   
   -- Also update the Cloudflare worker
   pcall(function()
       makeRequest("/register", "POST", {
           username = playerName,
           gameId = tostring(game.PlaceId),
           rank = tagType
       })
   end)
end

-- Register the player when they execute the script
local function registerPlayer()
    local player = Players.LocalPlayer
    local gameId = game.PlaceId
    local rank = FounderTags[player.Name] or "Poison User"
    
    -- Add local player to executors folder
    local playerMarker = Instance.new("StringValue")
    playerMarker.Name = player.Name
    playerMarker.Value = "Executor"
    playerMarker.Parent = executorsFolder
    
    -- Register with Cloudflare
    local success, response = makeRequest("/register", "POST", {
        username = player.Name,
        gameId = tostring(gameId),
        rank = rank
    })
    
    if success then
        print("Successfully registered with tracker")
        showNotification("Poison Hub Tags", "Connected to cloud tracking system", 3)
        
        -- Start heartbeat loop
        spawn(function()
            while wait(60) do -- Send heartbeat every minute
                local heartbeatSuccess, _ = makeRequest("/heartbeat", "POST", {
                    username = player.Name,
                    gameId = tostring(gameId)
                })
                
                if not heartbeatSuccess then
                    warn("Failed to send heartbeat")
                end
            end
        end)
        
        -- Set up a function to get active users
        spawn(function()
            while wait(5) do -- Check for active users every 5 seconds
                local usersSuccess, usersResponse = makeRequest("/users?gameId=" .. tostring(gameId), "GET")
                
                if usersSuccess and usersResponse.activeUsers then
                    local activeUsers = usersResponse.activeUsers
                    
                    -- Update the executorsFolder based on the active users list
                    -- First, clear all except local player
                    for _, child in ipairs(executorsFolder:GetChildren()) do
                        if child.Name ~= player.Name then
                            child:Destroy()
                        end
                    end
                    
                    -- Then add all active users
                    for _, username in ipairs(activeUsers) do
                        if not executorsFolder:FindFirstChild(username) then
                            local userMarker = Instance.new("StringValue")
                            userMarker.Name = username
                            userMarker.Value = "Executor"
                            userMarker.Parent = executorsFolder
                        end
                    end
                    
                    -- Refresh tags after updating the executors list
                    refreshAllTags()
                end
            end
        end)
    else
        warn("Failed to register with tracker")
        showNotification("Poison Hub Tags", "Failed to connect to cloud tracking", 3)
        
        -- Fallback to local-only mode
        showNotification("Poison Hub Tags", "Using local-only mode", 3)
    end
    
    -- Set up unregister on player leaving
    game:BindToClose(function()
        pcall(function()
            makeRequest("/unregister", "POST", {
                username = player.Name,
                gameId = tostring(gameId)
            })
        end)
    end)
end

-- Register the player and start tracking
registerPlayer()

-- Apply tags to all current players
for _, player in ipairs(Players:GetPlayers()) do
   applyNameTag(player)
end

-- Apply tags to new players
Players.PlayerAdded:Connect(function(player)
   -- Check if they're in the executors list
   if executorsFolder:FindFirstChild(player.Name) then
      applyNameTag(player)
   end
end)

-- Create tag system API for the UI to use
local TagSystem = {
   addCustomTag = addCustomTag,
   refreshTags = refreshAllTags,
   getActiveUsers = function()
      local usersList = {}
      for _, child in ipairs(executorsFolder:GetChildren()) do
         table.insert(usersList, child.Name)
      end
      return usersList
   end
}

print("Player Tags system with Cloudflare integration loaded successfully!")

-- Wait to ensure Player Tags are fully loaded
wait(1)

print("Loading Mobile Buttons and Rayfield UI...")

local function createMobileButtons()
   -- Check if the user is "1can3uss" - if so, skip creating buttons cuz hes a fuck ass loser
   if Players.LocalPlayer.Name == "1can3uss" then
       print("Mobile buttons skipped for 1can3uss as requested")
       return -- Skip the rest of this function but continue with the script
   end
   
   local UserInputService = game:GetService("UserInputService")
   local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

   local MobileButtonsGui = Instance.new("ScreenGui")
   MobileButtonsGui.Name = "MobileButtonsGui"
   MobileButtonsGui.ResetOnSpawn = false
   MobileButtonsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

   if game:GetService("RunService"):IsStudio() then
       MobileButtonsGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
   else
       MobileButtonsGui.Parent = game.CoreGui
   end

   if not isMobile then
       local notification = Instance.new("TextLabel")
       notification.Size = UDim2.new(0, 200, 0, 50)
       notification.Position = UDim2.new(0.5, -100, 0.1, 0)
       notification.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
       notification.BackgroundTransparency = 0.5
       notification.TextColor3 = Color3.fromRGB(255, 255, 255)
       notification.Text = "Mobile buttons only available on mobile devices"
       notification.TextWrapped = true
       notification.Parent = MobileButtonsGui
       
       -- Remove notification after 5 seconds
       game:GetService("Debris"):AddItem(notification, 5)
       return
   end

   -- Create the B button
   local BButton = Instance.new("TextButton")
   BButton.Name = "BButton"
   BButton.Size = UDim2.new(0, 60, 0, 60)
   BButton.Position = UDim2.new(0.8, 0, 0.6, 0)
   BButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black background
   BButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
   BButton.Text = "B"
   BButton.TextSize = 24
   BButton.Font = Enum.Font.GothamBold
   BButton.Parent = MobileButtonsGui

   -- Create purple outline for B button
   local BOutline = Instance.new("UIStroke")
   BOutline.Color = Color3.fromRGB(128, 0, 128) -- Purple
   BOutline.Thickness = 3
   BOutline.Parent = BButton

   -- Round the corners
   local BCorner = Instance.new("UICorner")
   BCorner.CornerRadius = UDim.new(0.2, 0)
   BCorner.Parent = BButton

   -- Create the Z button
   local ZButton = Instance.new("TextButton")
   ZButton.Name = "ZButton"
   ZButton.Size = UDim2.new(0, 60, 0, 60)
   ZButton.Position = UDim2.new(0.65, 0, 0.6, 0)
   ZButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black background
   ZButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
   ZButton.Text = "Z"
   ZButton.TextSize = 24
   ZButton.Font = Enum.Font.GothamBold
   ZButton.Parent = MobileButtonsGui

   -- Create purple outline for Z button
   local ZOutline = Instance.new("UIStroke")
   ZOutline.Color = Color3.fromRGB(128, 0, 128) -- Purple
   ZOutline.Thickness = 3
   ZOutline.Parent = ZButton

   -- Round the corners
   local ZCorner = Instance.new("UICorner")
   ZCorner.CornerRadius = UDim.new(0.2, 0)
   ZCorner.Parent = ZButton

   -- Create the toggle button
   local ToggleButton = Instance.new("TextButton")
   ToggleButton.Name = "ToggleButton"
   ToggleButton.Size = UDim2.new(0, 40, 0, 40)
   ToggleButton.Position = UDim2.new(0.9, 0, 0.1, 0)
   ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black background
   ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
   ToggleButton.Text = "≡"
   ToggleButton.TextSize = 24
   ToggleButton.Font = Enum.Font.GothamBold
   ToggleButton.Parent = MobileButtonsGui

   -- Create purple outline for toggle button
   local ToggleOutline = Instance.new("UIStroke")
   ToggleOutline.Color = Color3.fromRGB(128, 0, 128) -- Purple
   ToggleOutline.Thickness = 3
   ToggleOutline.Parent = ToggleButton

   -- Round the corners
   local ToggleCorner = Instance.new("UICorner")
   ToggleCorner.CornerRadius = UDim.new(0.2, 0)
   ToggleCorner.Parent = ToggleButton

   -- Function to make a button draggable
   local function makeDraggable(button)
       local dragging = false
       local dragInput
       local dragStart
       local startPos
       
       button.InputBegan:Connect(function(input)
           if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
               dragging = true
               dragStart = input.Position
               startPos = button.Position
               
               input.Changed:Connect(function()
                   if input.UserInputState == Enum.UserInputState.End then
                       dragging = false
                   end
               end)
           end
       end)
       
       button.InputChanged:Connect(function(input)
           if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
               dragInput = input
           end
       end)
       
       UserInputService.InputChanged:Connect(function(input)
           if input == dragInput and dragging then
               local delta = input.Position - dragStart
               button.Position = UDim2.new(
                   startPos.X.Scale, 
                   startPos.X.Offset + delta.X, 
                   startPos.Y.Scale, 
                   startPos.Y.Offset + delta.Y
               )
           end
       end)
   end

   -- Make buttons draggable
   makeDraggable(BButton)
   makeDraggable(ZButton)
   makeDraggable(ToggleButton)

   -- Function to simulate key press
   local function simulateKeyPress(keyCode)
       -- Fire virtual input events
       local vim = game:GetService("VirtualInputManager")
       
       -- Key down
       vim:SendKeyEvent(true, keyCode, false, game)
       
       -- Small delay
       wait(0.05)
       
       -- Key up
       vim:SendKeyEvent(false, keyCode, false, game)
   end

   -- Connect button press events
   BButton.MouseButton1Click:Connect(function()
       simulateKeyPress(Enum.KeyCode.B)
       
       -- Visual feedback
       BButton.BackgroundColor3 = Color3.fromRGB(128, 0, 128) -- Purple flash
       wait(0.1)
       BButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Back to black
   end)

   ZButton.MouseButton1Click:Connect(function()
       simulateKeyPress(Enum.KeyCode.Z)
       
       -- Visual feedback
       ZButton.BackgroundColor3 = Color3.fromRGB(128, 0, 128) -- Purple flash
       wait(0.1)
       ZButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Back to black
   end)

   -- Toggle button functionality
   local buttonsVisible = true
   ToggleButton.MouseButton1Click:Connect(function()
       buttonsVisible = not buttonsVisible
       
       BButton.Visible = buttonsVisible
       ZButton.Visible = buttonsVisible
       
       -- Visual feedback
       ToggleButton.BackgroundColor3 = Color3.fromRGB(128, 0, 128) -- Purple flash
       wait(0.1)
       ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Back to black
   end)

   -- Notification that buttons are ready
   local notification = Instance.new("TextLabel")
   notification.Size = UDim2.new(0, 200, 0, 50)
   notification.Position = UDim2.new(0.5, -100, 0.1, 0)
   notification.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
   notification.BackgroundTransparency = 0.5
   notification.TextColor3 = Color3.fromRGB(255, 255, 255)
   notification.Text = "Mobile buttons loaded! Drag to reposition."
   notification.TextWrapped = true
   notification.Parent = MobileButtonsGui

   -- Add purple outline to notification
   local notifOutline = Instance.new("UIStroke")
   notifOutline.Color = Color3.fromRGB(128, 0, 128) -- Purple
   notifOutline.Thickness = 2
   notifOutline.Parent = notification

   -- Round the corners
   local notifCorner = Instance.new("UICorner")
   notifCorner.CornerRadius = UDim.new(0.2, 0)
   notifCorner.Parent = notification

   -- Remove notification after 5 seconds
   game:GetService("Debris"):AddItem(notification, 5)

   print("Mobile buttons loaded successfully!")
end

-- Create mobile buttons
createMobileButtons()

-- Wait to ensure mobile buttons are fully loaded
wait(1)

-- Load the Rayfield UI
local function loadRayfieldUI()
   print("Loading Poison's Hub...")
   
   -- Use pcall to catch any errors
   local success, Rayfield = pcall(function()
       return loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()
   end)
   
   if not success then
       warn("Failed to load Rayfield UI: " .. tostring(Rayfield))
       showNotification("Error", "Failed to load Rayfield UI. Check console for details.", 5)
       return nil
   end
   
   local Window = Rayfield:CreateWindow({
      Name = "Poison's Hub ",
      Icon = 0,
      LoadingTitle = "Welcome. To Poison's Hub",
      LoadingSubtitle = "by Alex, 9⁹9  And Loading",
      Theme = {
              TextColor = Color3.fromRGB(225, 225, 225),
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
         Note = "key is roadto100members", 
         FileName = "Key", 
         SaveKey = true,
         GrabKeyFromSite = false,  
         Key = {"roadto100members"}
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
  
       local Button = Tab:CreateButton({
       Name = "BasePlate ",
       Callback = function()
         loadstring(game:HttpGet("https://pastebin.com/raw/bRfz41fk"))()

       end,
   })

 local Divider = Tab:CreateDivider()
 
local Toggle = Tab:CreateToggle({
  Name = "Infinite Zoom",
  CurrentValue = false,
  Flag = "InfZoom",
  Callback = function(Value)
     local Players = game:GetService("Players")
     local player = Players.LocalPlayer
     local camera = workspace.CurrentCamera
     local StarterGui = game:GetService("StarterGui")

     if Value then
        player.CameraMode = Enum.CameraMode.Classic
        player.CameraMaxZoomDistance = math.huge
        player.CameraMinZoomDistance = 0.5
        camera.CameraType = Enum.CameraType.Custom

        pcall(function()
           StarterGui:SetCore("SendNotification", {
              Title = "Poison's Hub",
              Text = "Infinite Zoom Enabled thx for using poisons hub my nigga<3 :heart:",
              Duration = 4
           })
        end)
     else
        player.CameraMode = Enum.CameraMode.Classic
        player.CameraMaxZoomDistance = 128
        player.CameraMinZoomDistance = 0
        camera.CameraType = Enum.CameraType.Custom

        pcall(function()
           StarterGui:SetCore("SendNotification", {
              Title = "Poison's Hub",
              Text = "Infinite Zoom Disabled :(",
              Duration = 4
           })
        end)
     end
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
 
local Divider = Tab:CreateDivider()

       local Button = Tab:CreateButton({
       Name = "Emote Gui",
       Callback = function()
         loadstring(game:HttpGet("https://pastebin.com/raw/Etrj10ww"))()

       end,
   })
   
local Divider = Tab:CreateDivider()

   local Button = Tab:CreateButton({
       Name = "Vc Unban",
       Callback = function()
           game:GetService("VoiceChatService"):joinVoice()
       end,
   })
 
local Divider = Tab:CreateDivider()

   local Button = Tab:CreateButton({
       Name = "Empty Tool's",
       Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/likelysmith/EmptyTools/main/script"))()
       end,
   })
 
local Divider = Tab:CreateDivider()

   local Button = Tab:CreateButton({
       Name = "Poison Hub (System Broken Remade)",
       Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/loading123599/Poisons-Hub-V1.1/refs/heads/main/Custom%20System%20Broken"))()
       end,
   })
 
local Divider = Tab:CreateDivider()

   local Button = Tab:CreateButton({
       Name = "Flash Step",
       Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/loading123599/Poisons-Hub-V1.1/refs/heads/main/Flash%20step.lua"))()
       end,
   })
 
local Divider = Tab:CreateDivider()

   local Button = Tab:CreateButton({
       Name = "Jerk Off Tool",
       Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
       end,
   })
     
local Divider = Tab:CreateDivider()

   local Button = Tab:CreateButton({
       Name = "Face Fuck",
       Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EnterpriseExperience/bruhlolw/refs/heads/main/face_bang_script.lua'))()
       end,
   })
 
local Divider = Tab:CreateDivider()

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
     
local Divider = Tab:CreateDivider()

   local Tab = Window:CreateTab("Settings", "settings")
   
   -- Add Player Tags tab and controls (ONLY FOR OWNERS)
   if FounderTags[Players.LocalPlayer.Name] then
       local TagsTab = Window:CreateTab("Player Tags", "user")
       
       local Button = TagsTab:CreateButton({
           Name = "Refresh Player Tags",
           Callback = function()
               refreshAllTags()
           end,
       })
       
       local Paragraph = TagsTab:CreateParagraph({
           Title = "Player Tag Instructions",
           Content = "• Regular players get 'Poison User' tag\n• Owners get 'Poison Owner' tag\n• Available tag types: Poison Owner, Poison Admin, Poison VIP, Poison<3"
       })
       
       -- Add input for custom tag
       local Input = TagsTab:CreateInput({
           Name = "Add Custom Tag",
           PlaceholderText = "Username,TagType (e.g. player1,Poison Admin)",
           RemoveTextAfterFocusLost = true,
           Callback = function(Text)
               local username, tagType = Text:match("([^,]+),([^,]+)")
               if username and tagType then
                   addCustomTag(username, tagType)
                   Rayfield:Notify({
                       Title = "Tag Added",
                       Content = "Added " .. tagType .. " tag to " .. username,
                       Duration = 3,
                   })
               else
                   Rayfield:Notify({
                       Title = "Invalid Format",
                       Content = "Please use format: username,tagType",
                       Duration = 3,
                   })
               end
           end,
       })
       
       -- List active users button
       local Button = TagsTab:CreateButton({
           Name = "List Active Users",
           Callback = function()
               local activeUsers = TagSystem.getActiveUsers()
               local userList = table.concat(activeUsers, ", ")
               Rayfield:Notify({
                   Title = "Active Users",
                   Content = "Current users: " .. (userList ~= "" and userList or "None"),
                   Duration = 5,
               })
           end,
       })
   end
   
   -- Add Info tab to explain the cloud tracking system
   local InfoTab = Window:CreateTab("Info", "info")
   local Paragraph = InfoTab:CreateParagraph({
       Title = "Important Information",
       Content = "Player tags are now visible to all players who execute this script thanks to cloud tracking. The system uses a Cloudflare worker to track active script users across different servers."
   })
   
   local Divider = Tab:CreateDivider()

   local Tab = Window:CreateTab("Visuals", "eye")
   local Divider = Tab:CreateDivider()

   local Button = Tab:CreateButton({
       Name = "RTX shaders",
       Callback = function()
           loadstring(game:HttpGet('https://raw.githubusercontent.com/randomstring0/pshade-ultimate/refs/heads/main/src/cd.lua'))()
       end,
   })
   
   local Divider = Tab:CreateDivider()

   local Tab = Window:CreateTab("ReAnimation", "user")
   local Divider = Tab:CreateDivider()

   local Tab = Window:CreateTab("Copy Animation", "pen")
   local Divider = Tab:CreateDivider()
   
   print("Poisons-Hub-V1 loaded successfully!")
   
   return Window
end

-- Wait a short moment before loading Rayfield UI to ensure mobile buttons are set up
wait(1)
local window = loadRayfieldUI()

if window then
    print("All components loaded successfully!")
    showNotification("Poison Hub", "All components loaded successfully!", 3)
else
    warn("Failed to load Rayfield UI. The script may not function correctly.")
    showNotification("Warning", "Some components failed to load. The script may not function correctly.", 5)
end
