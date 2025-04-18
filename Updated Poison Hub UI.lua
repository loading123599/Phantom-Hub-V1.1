-- Combined Script for Poison's Hub with workspace folder-based nametag system

-- First, load the BigBaseplate
print("Loading BigBaseplate...")
loadstring(game:HttpGet("https://raw.githubusercontent.com/loading123599/Poisons-Hub-V1.1/refs/heads/main/BigBaseplate.lua"))()
print("BigBaseplate loaded successfully!")

-- Wait to ensure BigBaseplate is fully loaded
wait(1)

-- Then load the Player Tags system with workspace folder-based detection
print("Loading Player Tags system...")

-- Modified Player Tag System for Poison's Hub (Only shows on script executors)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- Configuration
local CONFIG = {
    TAG_SIZE = UDim2.new(0, 0, 0, 32),  -- height only, width will be dynamic
    TAG_OFFSET = Vector3.new(0, 2.0, 0),
    MAX_DISTANCE = 200000,
    DISTANCE_THRESHOLD = 50,      -- when player backs away 50 studs, tag minimizes
    HYSTERESIS = 5,               -- only switch state when crossing 45 studs on the way back (50-5)
    CORNER_RADIUS = UDim.new(0, 10),
    PARTICLE_COUNT = 20,         -- increased particle count
    PARTICLE_SPEED = 2,
    GLOW_INTENSITY = 0.3,
    TELEPORT_DISTANCE = 5,
    TELEPORT_HEIGHT = 0.5,
    EXECUTOR_FOLDER_NAME = "PoisonHubExecutors" -- Folder in workspace to store executor data
}

-- Define founders/owners with their custom tags (keeping original names and roles)
local FounderTags = {
    ["GoodHelper12345"] = true,              -- Will get "Poison Owner" tag
    ["karez6"] = true,                       -- Will get "Poison Owner" tag
    ["nagerboyloading"] = true,              -- Will get "Poison Owner" tag
    ["1can3uss"] = true,                     -- Will get "Poison Owner" tag
    ["auralinker"] = "Poison Admin",         -- Will get "Poison Admin" tag
    ["Skyler_Saint"] = "Poison<3"            -- Will get "Poison<3" tag
}

-- Color scheme (Black and Purple)
local RankColors = {
    ["Poison Owner"] = {
        primary = Color3.fromRGB(20, 20, 20),   -- Black background
        accent = Color3.fromRGB(138, 43, 226),  -- Purple accent
        emoji = "👑"                            -- Crown emoji for owners
    },
    ["Poison User"] = {
        primary = Color3.fromRGB(20, 20, 20),   -- Black background
        accent = Color3.fromRGB(128, 0, 128),   -- Darker Purple accent
        emoji = "☠️"                            -- Poison symbol for regular users
    },
    ["Poison Admin"] = {
        primary = Color3.fromRGB(20, 20, 20),   -- Black background
        accent = Color3.fromRGB(255, 0, 0),     -- Red accent
        emoji = "⚡"                            -- Lightning emoji for admins
    },
    ["Poison VIP"] = {
        primary = Color3.fromRGB(20, 20, 20),   -- Black background
        accent = Color3.fromRGB(255, 215, 0),   -- Gold accent
        emoji = "💎"                            -- Diamond emoji for VIPs
    },
    ["Poison<3"] = {
        primary = Color3.fromRGB(20, 20, 20),   -- Black background
        accent = Color3.fromRGB(255, 105, 180), -- Pink accent
        emoji = "❤"                             -- Heart emoji for Poison<3
    }
}

-- Create or get the executors folder in workspace
local executorsFolder
if not workspace:FindFirstChild(CONFIG.EXECUTOR_FOLDER_NAME) then
    executorsFolder = Instance.new("Folder")
    executorsFolder.Name = CONFIG.EXECUTOR_FOLDER_NAME
    executorsFolder.Parent = workspace
else
    executorsFolder = workspace:FindFirstChild(CONFIG.EXECUTOR_FOLDER_NAME)
end

-- Function to mark a player as a script executor
local function markAsExecutor(player)
    local playerName = player.Name
    
    -- Check if this player already has a marker
    if not executorsFolder:FindFirstChild(playerName) then
        -- Create a StringValue to mark this player as a script executor
        local marker = Instance.new("StringValue")
        marker.Name = playerName
        marker.Value = "Executor"
        marker.Parent = executorsFolder
        
        print("Marked " .. playerName .. " as a script executor")
    end
end

-- Function to check if a player is a script executor
local function isExecutor(player)
    if player then
        return executorsFolder:FindFirstChild(player.Name) ~= nil
    end
    return false
end

-- Function to check if a player is an owner
local function isOwner(playerName)
    return FounderTags[playerName] ~= nil
end

-- Create basic particle frames
local function createParticles(tag, parent, accentColor)
    for i = 1, CONFIG.PARTICLE_COUNT do
        local particle = Instance.new("Frame")
        particle.Name = "Particle_" .. i
        -- Randomize initial size more
        particle.Size = UDim2.new(0, math.random(1, 6), 0, math.random(1, 6))
        -- Randomize starting position across entire width and add some random offset
        particle.Position = UDim2.new(math.random(), math.random(-10, 10), 1 + math.random() * 0.5, 0)
        particle.BackgroundColor3 = accentColor
        particle.BackgroundTransparency = math.random(0, 0.4)  -- Random initial transparency
        particle.BorderSizePixel = 0
        local pCorner = Instance.new("UICorner")
        pCorner.CornerRadius = UDim.new(1, 0)
        pCorner.Parent = particle
        particle.Parent = parent

        spawn(function()
            while tag and tag.Parent do
                -- More random starting positions
                local startX = math.random()
                local startOffsetX = math.random(-10, 10)
                particle.Position = UDim2.new(startX, startOffsetX, 1 + math.random() * 0.5, 0)
                particle.Size = UDim2.new(0, math.random(1, 6), 0, math.random(1, 6))
                particle.BackgroundTransparency = math.random(0, 0.4)
                
                -- Randomize particle movement
                local duration = math.random(10, 40) / (CONFIG.PARTICLE_SPEED * 10)
                local endX = startX + (math.random() - 0.5) * 0.3  -- Random horizontal drift
                local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
                
                local tween = TweenService:Create(particle, tweenInfo, {
                    Position = UDim2.new(endX, startOffsetX, -0.5, math.random(-20, 20)),  -- Random end offset
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 0)
                })
                tween:Play()
                -- Random delay between spawns
                task.wait(math.random(20, 40) / (CONFIG.PARTICLE_SPEED * 10))
            end
        end)
    end
end

-- Function to teleport to a player
local function teleportToPlayer(targetPlayer)
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character
    local targetCharacter = targetPlayer.Character
    if not (character and targetCharacter) then return end
    local humanoid = character:FindFirstChild("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not (humanoid and hrp and targetHRP) then return end
    local targetCFrame = targetHRP.CFrame
    local teleportPosition = targetCFrame.Position - (targetCFrame.LookVector * CONFIG.TELEPORT_DISTANCE)
    teleportPosition = teleportPosition + Vector3.new(0, CONFIG.TELEPORT_HEIGHT, 0)
    local particlepart = Instance.new("Part", workspace)
    particlepart.Transparency = 1
    particlepart.Anchored = true
    particlepart.CanCollide = false
    particlepart.Position = hrp.Position
    local transmitter1 = Instance.new("ParticleEmitter")
    transmitter1.Texture = "http://www.roblox.com/asset/?id=89296104222585"
    transmitter1.Size = NumberSequence.new(4)
    transmitter1.Lifetime = NumberRange.new(0.15, 0.15)
    transmitter1.Rate = 100
    transmitter1.TimeScale = 0.25
    transmitter1.VelocityInheritance = 1
    transmitter1.Drag = 5
    transmitter1.Parent = particlepart
    local particlepart2 = Instance.new("Part", workspace)
    particlepart2.Transparency = 1
    particlepart2.Anchored = true
    particlepart2.CanCollide = false
    particlepart2.Position = teleportPosition
    local transmitter2 = Instance.new("ParticleEmitter")
    transmitter2.Texture = "http://www.roblox.com/asset/?id=89296104222585"
    transmitter2.Size = NumberSequence.new(4)
    transmitter2.Lifetime = NumberRange.new(0.15, 0.15)
    transmitter2.Rate = 100
    transmitter2.TimeScale = 0.25
    transmitter2.VelocityInheritance = 1
    transmitter2.Drag = 5
    transmitter2.Parent = particlepart2
    local fadeTime = 0.1
    local tweenInfo = TweenInfo.new(fadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local meshParts = {}
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("MeshPart") then
            table.insert(meshParts, part)
        end
    end
    for _, part in ipairs(meshParts) do
        local tween = TweenService:Create(part, tweenInfo, {Transparency = 1})
        tween:Play()
    end
    task.wait(fadeTime)
    hrp.CFrame = CFrame.new(teleportPosition, targetHRP.Position)
    local teleportSound = Instance.new("Sound")
    teleportSound.SoundId = "rbxassetid://5066021887"
    local head = character:FindFirstChild("Head")
    if head then
        teleportSound.Parent = head
    else
        teleportSound.Parent = hrp
    end
    teleportSound.Volume = 0.5
    teleportSound:Play()
    for _, part in ipairs(meshParts) do
        local tween = TweenService:Create(part, tweenInfo, {Transparency = 0})
        tween:Play()
    end
    task.wait(1)
    particlepart:Destroy()
    particlepart2:Destroy()
end

-- Function to attach tag to player's head
local function attachTagToHead(character, player, rankText)
    local head = character:WaitForChild("Head", 5)
    if not head then return end

    -- Remove existing tag if present
    local existingTag = head:FindFirstChild("PoisonTag")
    if existingTag then existingTag:Destroy() end

    -- Disable default Roblox nametag
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end

    local rankData = RankColors[rankText] or RankColors["Poison User"]

    -- Create new tag
    local tag = Instance.new("BillboardGui")
    tag.Adornee = head
    tag.Active = true
    tag.Name = "PoisonTag"
    tag.Size = UDim2.new(0, 0, 0, CONFIG.TAG_SIZE.Y.Offset)
    tag.StudsOffset = CONFIG.TAG_OFFSET
    tag.AlwaysOnTop = true
    tag.MaxDistance = CONFIG.MAX_DISTANCE
    tag.LightInfluence = 0
    tag.ResetOnSpawn = false

    -- Main container
    local container = Instance.new("Frame")
    container.Name = "TagContainer"
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundColor3 = rankData.primary
    container.BackgroundTransparency = 0.15
    container.BorderSizePixel = 0
    container.ClipsDescendants = true
    container.Parent = tag

    -- Create UICorner for container
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = CONFIG.CORNER_RADIUS
    containerCorner.Parent = container

    -- Add border
    local border = Instance.new("UIStroke")
    border.Color = rankData.accent
    border.Thickness = 2
    border.Transparency = 0.2
    border.Parent = container

    -- Add click button
    local clickButton = Instance.new("TextButton")
    clickButton.Name = "ClickButton"
    clickButton.Size = UDim2.new(1, 0, 1, 0)
    clickButton.BackgroundTransparency = 1
    clickButton.Text = ""
    clickButton.ZIndex = 10
    clickButton.AutoButtonColor = false
    clickButton.Active = true
    clickButton.Parent = container

    if player ~= Players.LocalPlayer then
        clickButton.MouseButton1Click:Connect(function()
            teleportToPlayer(player)
        end)
        clickButton.MouseEnter:Connect(function()
            TweenService:Create(container, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        end)
        clickButton.MouseLeave:Connect(function()
            TweenService:Create(container, TweenInfo.new(0.3), {BackgroundTransparency = 0.15}):Play()
        end)
    end

    -- Add particles container
    local particlesContainer = Instance.new("Frame")
    particlesContainer.Name = "ParticlesContainer"
    particlesContainer.Size = UDim2.new(1, 0, 1, 0)
    particlesContainer.BackgroundTransparency = 1
    particlesContainer.ZIndex = 2
    particlesContainer.ClipsDescendants = true
    particlesContainer.Parent = container
    
    local pContainerCorner = Instance.new("UICorner")
    pContainerCorner.CornerRadius = UDim.new(1, 0)
    pContainerCorner.Parent = particlesContainer
    
    createParticles(tag, particlesContainer, rankData.accent)

    -- Add emoji label
    local emojiLabel = Instance.new("TextLabel")
    emojiLabel.Name = "EmojiLabel"
    emojiLabel.Size = UDim2.new(0, 30, 0, 30)
    emojiLabel.Position = UDim2.new(0, 8, 0.5, -15)
    emojiLabel.BackgroundTransparency = 1
    emojiLabel.Text = rankData.emoji
    emojiLabel.TextSize = 22
    emojiLabel.Font = Enum.Font.GothamBold
    emojiLabel.TextColor3 = Color3.new(1, 1, 1)
    emojiLabel.ZIndex = 5
    emojiLabel.Parent = container

    -- Calculate text widths for dynamic sizing
    local function getTextWidth(text, font, textSize)
        local textService = game:GetService("TextService")
        local result = textService:GetTextSize(text, textSize, font, Vector2.new(1000, 16))
        return result.X
    end

    -- DisplayName label
    local displayNameLabel = Instance.new("TextLabel")
    displayNameLabel.Name = "DisplayNameLabel"
    displayNameLabel.BackgroundTransparency = 1
    
    -- Get the display name and prepend "@"
    local shortDisplayName = player.DisplayName or player.Name
    -- If the username exceeds 10 characters, truncate and append "…"
    if #shortDisplayName > 10 then
        shortDisplayName = string.sub(shortDisplayName, 1, 10) .. "…"
    end
    displayNameLabel.Text = "@" .. shortDisplayName
    
    -- Make the username a bit smaller by using a smaller text size
    displayNameLabel.TextSize = 10
    displayNameLabel.Font = Enum.Font.GothamBold
    
    -- Set the display name color to the accent color
    displayNameLabel.TextColor3 = rankData.accent  
    displayNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    displayNameLabel.ZIndex = 5

    -- Rank label
    local rankLabel = Instance.new("TextLabel")
    rankLabel.Name = "RankLabel"
    rankLabel.BackgroundTransparency = 1
    
    -- Truncate rankText to max 12 characters if necessary
    local shortRankText = rankText
    if #shortRankText > 12 then
        shortRankText = string.sub(shortRankText, 1, 12) .. "…"
    end
    rankLabel.Text = shortRankText
    rankLabel.TextSize = 14
    rankLabel.Font = Enum.Font.GothamBold
    rankLabel.TextColor3 = rankData.accent
    rankLabel.TextXAlignment = Enum.TextXAlignment.Left
    rankLabel.ZIndex = 5

    local sidePadding = 16 -- Increased side padding
    local emojiWidth = 36 -- 30px emoji + 6px left margin
    local textService = game:GetService("TextService")
    local rankWidth = getTextWidth(rankLabel.Text, Enum.Font.GothamBold, 14)
    local totalWidth = emojiWidth + rankWidth + (sidePadding * 2) -- Add padding on both sides

    tag.Size = UDim2.new(0, totalWidth, 0, CONFIG.TAG_SIZE.Y.Offset)
    container.Size = UDim2.new(1, 0, 1, 0)

    -- Layout: emoji | rank (top) | displayName (bottom)
    emojiLabel.Position = UDim2.new(0, sidePadding, 0.5, -15)
    emojiLabel.Size = UDim2.new(0, 30, 0, 30)

    rankLabel.Size = UDim2.new(1, -(emojiWidth + sidePadding * 2), 0, 16)
    rankLabel.Position = UDim2.new(0, emojiWidth + sidePadding, 0, 3)
    rankLabel.Parent = container

    displayNameLabel.Size = UDim2.new(1, -(emojiWidth + sidePadding * 2), 0, 16)
    displayNameLabel.Position = UDim2.new(0, emojiWidth + sidePadding, 0, 17)
    displayNameLabel.Parent = container

    -- Revised minimized configuration
    local isMinimized = false
    local FULL_SIZE = UDim2.new(0, totalWidth, 0, CONFIG.TAG_SIZE.Y.Offset)
    local MINI_SIZE = UDim2.new(0, 40, 0, 40)
    local MINI_OFFSET = Vector3.new(0, 1.0, 0)
    local activeTween = true
    
    spawn(function()
        while activeTween do
            if character and head and head.Parent and Players.LocalPlayer and Players.LocalPlayer.Character then
                local localHead = Players.LocalPlayer.Character:FindFirstChild("Head")
                if localHead then
                    local distance = (head.Position - localHead.Position).Magnitude
                    if distance > (CONFIG.DISTANCE_THRESHOLD + CONFIG.HYSTERESIS) and not isMinimized then
                        isMinimized = true
                        TweenService:Create(tag, TweenInfo.new(0.5), { Size = MINI_SIZE, StudsOffset = MINI_OFFSET }):Play()
                        TweenService:Create(rankLabel, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
                        TweenService:Create(displayNameLabel, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
                        TweenService:Create(emojiLabel, TweenInfo.new(0.5), { Position = UDim2.new(0.5, -15, 0.5, -15), Size = UDim2.new(0, 30, 0, 30), TextSize = 26 }):Play()
                        TweenService:Create(containerCorner, TweenInfo.new(0.5), { CornerRadius = UDim.new(1, 0) }):Play()
                    elseif distance < (CONFIG.DISTANCE_THRESHOLD - CONFIG.HYSTERESIS) and isMinimized then
                        isMinimized = false
                        TweenService:Create(tag, TweenInfo.new(0.5), { Size = FULL_SIZE, StudsOffset = CONFIG.TAG_OFFSET }):Play()
                        TweenService:Create(rankLabel, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()
                        TweenService:Create(displayNameLabel, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()
                        TweenService:Create(emojiLabel, TweenInfo.new(0.5), { Position = UDim2.new(0, 8, 0.5, -15), Size = UDim2.new(0, 30, 0, 30), TextSize = 22 }):Play()
                        TweenService:Create(containerCorner, TweenInfo.new(0.5), { CornerRadius = CONFIG.CORNER_RADIUS }):Play()
                    end
                end
            end
            task.wait(0.2)
        end
    end)
    
    tag.AncestryChanged:Connect(function(_, parent)
        if not parent then
            activeTween = false
        end
    end)
    
    Players.PlayerRemoving:Connect(function(removedPlayer)
        if removedPlayer == player then
            if tag and tag.Parent then
                tag:Destroy()
            end
            activeTween = false
        end
    end)
    
    -- Parent the tag to the head
    tag.Parent = head
    
    return tag
}

-- Function to apply the appropriate tag to each player
local function applyPlayerTag(player)
    -- Only apply tags to players who have executed the script
    if not isExecutor(player) then
        return
    end
    
    -- Default tag for everyone
    local tagText = "Poison User"
    
    -- Check if player is in the FounderTags list
    if FounderTags[player.Name] then
        -- If the value is a string, use that as the custom tag
        if type(FounderTags[player.Name]) == "string" then
            tagText = FounderTags[player.Name]
        else
            -- Otherwise use the default owner tag
            tagText = "Poison Owner"
        end
    end
    
    -- Apply the tag to the player
    if player.Character then
        attachTagToHead(player.Character, player, tagText)
    end
    
    -- Apply tag when player respawns
    player.CharacterAdded:Connect(function(character)
        -- Check again in case the player's executor status changed
        if isExecutor(player) then
            attachTagToHead(character, player, tagText)
        end
    end)
}

-- Mark the local player as an executor
markAsExecutor(Players.LocalPlayer)

-- Function to check for executor markers in the workspace folder
local function checkAllPlayersForExecutorMarker()
    for _, player in ipairs(Players:GetPlayers()) do
        if executorsFolder:FindFirstChild(player.Name) then
            applyPlayerTag(player)
        end
    end
end

-- Set up a loop to continuously check for executor markers
local function startExecutorCheckLoop()
    spawn(function()
        while wait(1) do -- Check every second
            checkAllPlayersForExecutorMarker()
        end
    end)
end

-- Start the executor check loop
startExecutorCheckLoop()

-- Set up for new players
Players.PlayerAdded:Connect(function(player)
    -- Check if they're an executor
    if executorsFolder:FindFirstChild(player.Name) then
        applyPlayerTag(player)
    end
end)

-- Function to add a custom tag for a specific player
local function addCustomTag(playerName, tagType)
    if tagType then
        -- Add with custom tag type
        FounderTags[playerName] = tagType
    else
        -- Add as regular owner
        FounderTags[playerName] = true
    end
    
    -- Update tag if player is in game and has executed the script
    local player = Players:FindFirstChild(playerName)
    if player and isExecutor(player) then
        applyPlayerTag(player)
    end
end

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

showNotification("Poison Hub Tags", "Tag system loaded - only showing on script executors", 5)

-- Create tag system API
local TagSystem = {
    addCustomTag = addCustomTag,
    refreshTags = function()
        checkAllPlayersForExecutorMarker()
    end,
    getExecutorsList = function()
        local executorsList = {}
        for _, child in ipairs(executorsFolder:GetChildren()) do
            table.insert(executorsList, child.Name)
        end
        return executorsList
    end
}

print("Player Tags system loaded successfully!")

-- Wait to ensure Player Tags are fully loaded
wait(1)

-- Finally, load the Mobile Buttons and Rayfield UI
print("Loading Mobile Buttons and Rayfield UI...")

-- Create the mobile buttons
local function createMobileButtons()
    -- Check if the user is "1can3uss" - if so, skip creating buttons
    if Players.LocalPlayer.Name == "1can3uss" then
        print("Mobile buttons skipped for 1can3uss as requested")
        return -- Skip the rest of this function but continue with the script
    end
    
    -- Check if the user is on mobile
    local UserInputService = game:GetService("UserInputService")
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    -- Create the GUI
    local MobileButtonsGui = Instance.new("ScreenGui")
    MobileButtonsGui.Name = "MobileButtonsGui"
    MobileButtonsGui.ResetOnSpawn = false
    MobileButtonsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Parent the GUI to the appropriate location
    if game:GetService("RunService"):IsStudio() then
        MobileButtonsGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    else
        MobileButtonsGui.Parent = game.CoreGui
    end

    -- Only show for mobile users
    if not isMobile then
        -- Create a notification for non-mobile users
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
    
    local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

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
    if isOwner(Players.LocalPlayer.Name) then
        local TagsTab = Window:CreateTab("Player Tags", "user")
        
        local Button = TagsTab:CreateButton({
            Name = "Refresh Player Tags",
            Callback = function()
                TagSystem.refreshTags()
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
        
        -- List executors button
        local Button = TagsTab:CreateButton({
            Name = "List Script Executors",
            Callback = function()
                local executors = TagSystem.getExecutorsList()
                local executorList = table.concat(executors, ", ")
                Rayfield:Notify({
                    Title = "Script Executors",
                    Content = "Current executors: " .. executorList,
                    Duration = 5,
                })
            end,
        })
    end
    
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
loadRayfieldUI()

print("All components loaded successfully!")
