-- Load the enhanced library
local Library = loadstring(game:HttpGet("https://github.com/Turtlebug20/l/raw/refs/heads/main/ui.lua"))()

-- Get services
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

local localPlayer = Players.LocalPlayer
local username = localPlayer.Name
local originalWalkSpeed = 16
local TweenService = game:GetService("TweenService")

-- Remote references
local Communication = ReplicatedStorage:FindFirstChild("Communication")
local ContributeToExpand = Communication and Communication:FindFirstChild("ContributeToExpand")
local HitResource = Communication and Communication:FindFirstChild("HitResource")
local CraftRemote = Communication and Communication:FindFirstChild("Craft")
local BuyFromMerchant = Communication and Communication:FindFirstChild("BuyFromMerchant")

-- Create the main window
local Window = Library:Window({
    Name = "Abyss Hub [.gg/abyssfr]",
    Key = "abyssprotokey" -- Required key!
})

-- Simple function to add buttons directly to the main frame and hide original ones
local function addWindowControls()
    if not Library or not Library.mainframe then 
        print("✗ Mainframe not found")
        return 
    end
    
    -- Wait a bit for UI to load
    task.wait(0.5)
    
    print("✓ Mainframe found, adding buttons...")
    
    -- Try to find and hide the original minimize button if it exists
    local function hideOriginalButtons()
        -- Look for minimize button in various places
        local theholderdwbbg = Library.mainframe:FindFirstChild("theholderdwbbg")
        if theholderdwbbg then
            -- Check in sidebar
            local sidebarHolder = theholderdwbbg:FindFirstChild("SidebarHolder")
            if sidebarHolder then
                local anothersidebarholder = sidebarHolder:FindFirstChild("anothersidebarholder")
                if anothersidebarholder then
                    local buttonsholder = anothersidebarholder:FindFirstChild("Buttonsholder")
                    if buttonsholder then
                        local buttons = buttonsholder:FindFirstChild("Buttons")
                        if buttons then
                            -- Hide any minimize buttons in the buttons frame
                            for _, child in ipairs(buttons:GetChildren()) do
                                if child.Name:lower():find("minimize") or child.Name:lower():find("close") then
                                    child.Visible = false
                                end
                            end
                            
                            -- Also hide the title container if it's in the way
                            local titleContainer = buttons:FindFirstChild("TitleContainer")
                            if titleContainer then
                                -- Keep it but maybe adjust position
                            end
                        end
                    end
                end
            end
            
            -- Also check in content area
            local content = theholderdwbbg:FindFirstChild("content")
            if content then
                for _, child in ipairs(content:GetChildren()) do
                    if child.Name:lower():find("minimize") or child.Name:lower():find("close") or child.Name == "WindowControls" then
                        child:Destroy()
                    end
                end
            end
        end
        
        -- Look for any buttons directly in mainframe
        for _, child in ipairs(Library.mainframe:GetChildren()) do
            if child.Name:lower():find("minimize") or child.Name:lower():find("close") then
                child:Destroy()
            end
        end
    end
    
    -- Hide original buttons
    pcall(hideOriginalButtons)
    
    -- Remove any existing buttons we added
    if Library.mainframe:FindFirstChild("TopRightButtons") then
        Library.mainframe.TopRightButtons:Destroy()
    end
    
    -- Create a frame for buttons at the top right of mainframe
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = "TopRightButtons"
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Size = UDim2.new(0, 80, 0, 40)
    buttonFrame.Position = UDim2.new(1, -90, 0, 10) -- Position at top right
    buttonFrame.ZIndex = 1000 -- Very high zindex to be on top
    buttonFrame.Parent = Library.mainframe
    
    -- Layout for buttons
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 8)
    layout.Parent = buttonFrame
    
    -- Create minimize button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeButton"
    minimizeBtn.Text = ""
    minimizeBtn.Size = UDim2.fromOffset(30, 30)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    minimizeBtn.BackgroundTransparency = 0.3
    minimizeBtn.AutoButtonColor = false
    minimizeBtn.ZIndex = 1001
    minimizeBtn.Parent = buttonFrame
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 8)
    minimizeCorner.Parent = minimizeBtn
    
    local minimizeIcon = Instance.new("ImageLabel")
    minimizeIcon.Name = "MinimizeIcon"
    minimizeIcon.Image = "http://www.roblox.com/asset/?id=115894980866040" -- Down arrow
    minimizeIcon.ImageColor3 = Color3.fromRGB(200, 200, 210)
    minimizeIcon.BackgroundTransparency = 1
    minimizeIcon.Size = UDim2.fromOffset(16, 16)
    minimizeIcon.Position = UDim2.fromScale(0.5, 0.5)
    minimizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    minimizeIcon.ZIndex = 1002
    minimizeIcon.Parent = minimizeBtn
    
    -- Create close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Text = ""
    closeBtn.Size = UDim2.fromOffset(30, 30)
    closeBtn.BackgroundColor3 = Color3.fromRGB(45, 35, 35) -- Slightly red tint
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 1001
    closeBtn.Parent = buttonFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    local closeIcon = Instance.new("ImageLabel")
    closeIcon.Name = "CloseIcon"
    closeIcon.Image = "http://www.roblox.com/asset/?id=6031094677" -- X icon
    closeIcon.ImageColor3 = Color3.fromRGB(239, 68, 68) -- Red
    closeIcon.BackgroundTransparency = 1
    closeIcon.Size = UDim2.fromOffset(16, 16)
    closeIcon.Position = UDim2.fromScale(0.5, 0.5)
    closeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    closeIcon.ZIndex = 1002
    closeIcon.Parent = closeBtn
    
    -- Button functionality
    local isMinimized = false
    local originalSize = nil
    local originalPosition = nil
    local contentFrame = nil
    
    -- Find the content frame to hide/show
    local function findContentFrame()
        local theholderdwbbg = Library.mainframe:FindFirstChild("theholderdwbbg")
        if theholderdwbbg then
            return theholderdwbbg
        end
        return nil
    end
    
    minimizeBtn.MouseButton1Click:Connect(function()
        if not isMinimized then
            -- Store original size and position
            originalSize = Library.mainframe.Size
            originalPosition = Library.mainframe.Position
            
            -- Find and hide content
            contentFrame = findContentFrame()
            if contentFrame then
                contentFrame.Visible = false
            end
            
            -- Hide other UI elements but keep the top bar
            for _, child in ipairs(Library.mainframe:GetChildren()) do
                if child ~= buttonFrame and child ~= Library.mainframe:FindFirstChild("UIStroke") and child ~= Library.mainframe:FindFirstChild("UICorner") then
                    if child:IsA("Frame") and child.Name ~= "UIGradient" then
                        child.Visible = false
                    end
                end
            end
            
            -- Shrink to just the top bar
            TweenService:Create(Library.mainframe, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, Library.mainframe.AbsoluteSize.X, 0, 50),
                Position = UDim2.new(0.5, -Library.mainframe.AbsoluteSize.X/2, 0, 50)
            }):Play()
            
            minimizeIcon.Image = "http://www.roblox.com/asset/?id=6034813118" -- Maximize icon (square)
            isMinimized = true
            Library:Notification("Window minimized", 1, "info")
        else
            -- Restore to original size
            if contentFrame then
                contentFrame.Visible = true
            end
            
            -- Show all UI elements again
            for _, child in ipairs(Library.mainframe:GetChildren()) do
                if child ~= buttonFrame then
                    child.Visible = true
                end
            end
            
            TweenService:Create(Library.mainframe, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = originalSize or UDim2.new(0, 665, 0, 467),
                Position = originalPosition or UDim2.new(0.5, -332.5, 0.5, -233.5)
            }):Play()
            
            minimizeIcon.Image = "http://www.roblox.com/asset/?id=115894980866040" -- Down arrow
            isMinimized = false
            Library:Notification("Window restored", 1, "info")
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        Library:SetOpen(false)
        Library:Notification("Window closed - Press Insert to reopen", 2, "info")
    end)
    
    -- Hover effects
    minimizeBtn.MouseEnter:Connect(function()
        TweenService:Create(minimizeBtn, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.1,
            BackgroundColor3 = Color3.fromRGB(55, 55, 75)
        }):Play()
        TweenService:Create(minimizeIcon, TweenInfo.new(0.15), {
            ImageColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)
    
    minimizeBtn.MouseLeave:Connect(function()
        TweenService:Create(minimizeBtn, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.3,
            BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        }):Play()
        TweenService:Create(minimizeIcon, TweenInfo.new(0.15), {
            ImageColor3 = Color3.fromRGB(200, 200, 210)
        }):Play()
    end)
    
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.1,
            BackgroundColor3 = Color3.fromRGB(75, 45, 45)
        }):Play()
        TweenService:Create(closeIcon, TweenInfo.new(0.15), {
            ImageColor3 = Color3.fromRGB(255, 100, 100)
        }):Play()
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.3,
            BackgroundColor3 = Color3.fromRGB(45, 35, 35)
        }):Play()
        TweenService:Create(closeIcon, TweenInfo.new(0.15), {
            ImageColor3 = Color3.fromRGB(239, 68, 68)
        }):Play()
    end)
    
    print("✓ Top right buttons added successfully! Original buttons hidden.")
end

-- Create tabs
local MainTab = Library:Tab({
    Title = "Main",
    Icon = "rbxassetid://6023426926"
})

local PlayerTab = Library:Tab({
    Title = "Players",
    Icon = "rbxassetid://6031280882"
})

local MovementTab = Library:Tab({
    Title = "Movement",
    Icon = "rbxassetid://6031094665"
})

-- Add window controls after a delay to ensure UI is ready
task.spawn(function()
    task.wait(1) -- Wait 1 second for UI to fully load
    addWindowControls()
    
    -- Try again after another delay just in case
    task.wait(2)
    if Library.mainframe and not Library.mainframe:FindFirstChild("TopRightButtons") then
        print("Retrying button addition...")
        addWindowControls()
    end
end)

-- Variables
local expandParts = {}
local expandConnections = {}
local expandFireLoop = nil
local expandEnabled = false
local resourceEnabled = false
local resourceLoop = nil
local craftEnabled = false
local craftLoop = nil
local uiVisible = true
local resourceSpeed = 0.01
local merchantEnabled = false
local merchantLoop = nil
local selectedItem = "Corn Seeds"
local selectedPlayer = nil
local selectedTargetPlayers = {}
local teleportEnabled = false
local teleportLoop = nil
local infiniteJumpEnabled = false
local infiniteJumpConnection = nil
local farmOwnResources = true
local farmSelectedPlayers = false

-- UI Elements for refreshing
local PlayerMultiDropdown = nil
local SelectedPlayersLabel = nil
local TeleportToggle = nil

-- Item list
local merchantItems = {
    "Corn Seeds", "Strawberry Seeds", "Tomato Seeds", "Blueberry Seeds",
    "Apple Seeds", "Watermelon Seeds", "Magic Durian Seeds", "Peach Seeds",
    "Pumpkin Seeds", "Cherry Seeds", "Starfruit Seeds", "Mango Seeds",
    "Goji Berry Seeds", "Dragonfruit Seeds", "Coconut Seeds", "Pineapple Seeds",
    "Coal Crate", "Honey Bee", "Magma Bee", "Growth Potion", "Resource Potion",
    "Strength Potion", "Busy Bee Potion", "Galaxy Potion", "Multicast Potion",
    "Autominer Mk 1", "Autochopper Mk 1"
}

-- Rainbow Island resources
local function getRainbowResources()
    local resources = {}
    local rainbowIsland = workspace:FindFirstChild("RainbowIsland")
    if rainbowIsland then
        local resourcesFolder = rainbowIsland:FindFirstChild("Resources")
        if resourcesFolder then
            for _, child in ipairs(resourcesFolder:GetChildren()) do
                if child:IsA("BasePart") or child:IsA("Model") then
                    table.insert(resources, child)
                end
            end
        end
    end
    return resources
end

-- Functions
local function getCharacter()
    return localPlayer.Character or localPlayer.CharacterAdded:Wait()
end

local function getHumanoid()
    local char = getCharacter()
    return char and char:FindFirstChild("Humanoid")
end

local function getHumanoidRootPart()
    local char = getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function setWalkSpeed(speed)
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end

local function resetWalkSpeed()
    setWalkSpeed(originalWalkSpeed)
end

-- Infinite Jump
local function toggleInfiniteJump(value)
    if value then
        if infiniteJumpEnabled then return end
        infiniteJumpEnabled = true
        
        infiniteJumpConnection = RunService.Heartbeat:Connect(function()
            if infiniteJumpEnabled then
                local humanoid = getHumanoid()
                if humanoid and (humanoid:GetState() == Enum.HumanoidStateType.Landed or 
                   humanoid:GetState() == Enum.HumanoidStateType.Running) then
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end)
        
        UserInputService.JumpRequest:Connect(function()
            if infiniteJumpEnabled then
                local humanoid = getHumanoid()
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        infiniteJumpEnabled = false
        if infiniteJumpConnection then
            infiniteJumpConnection:Disconnect()
            infiniteJumpConnection = nil
        end
    end
end

local function getOtherPlayers()
    local players = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            table.insert(players, player.Name)
        end
    end
    table.sort(players)
    return players
end

local function teleportToPlayer()
    if not selectedPlayer or selectedPlayer == "No other players" then return end
    local targetPlayer = Players:FindFirstChild(selectedPlayer)
    if not targetPlayer then return end
    local targetChar = targetPlayer.Character
    if not targetChar then return end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    local localRoot = getHumanoidRootPart()
    if not localRoot then return end
    localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 3, 0)
end

local function toggleTeleport(value)
    if value then
        if not selectedPlayer or selectedPlayer == "No other players" then 
            Library:Notification("Select a player first!", 2, "warning")
            if TeleportToggle then TeleportToggle:Set(false) end
            return 
        end
        teleportEnabled = true
        teleportLoop = task.spawn(function()
            while teleportEnabled do
                pcall(teleportToPlayer)
                task.wait(0.1)
            end
        end)
        Library:Notification("Auto Follow enabled for " .. selectedPlayer, 2, "success")
    else
        teleportEnabled = false
        if teleportLoop then
            task.cancel(teleportLoop)
            teleportLoop = nil
        end
        Library:Notification("Auto Follow disabled", 2, "info")
    end
end

-- Expand functions
local function getAllExpandParts()
    local parts = {}
    local function addParts(container)
        for _, obj in ipairs(container:GetChildren()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("expand") or CollectionService:HasTag(obj, "expand")) then
                table.insert(parts, obj)
            end
            if #obj:GetChildren() > 0 then
                addParts(obj)
            end
        end
    end
    addParts(workspace)
    return parts
end

local function makePartPlatform(part)
    pcall(function()
        if part and part:IsA("BasePart") then
            part.Transparency = 1
            part.CanCollide = false
            part.CanQuery = false
            part.CanTouch = false
        end
    end)
end

local function restorePart(part)
    pcall(function()
        if part and part:IsA("BasePart") then
            part.Transparency = 0
            part.CanCollide = true
            part.CanQuery = true
            part.CanTouch = true
        end
    end)
end

local function stackPartsAtFeet(parts, footPos)
    for i, part in ipairs(parts) do
        if part and part.Parent then
            pcall(function()
                part.CFrame = CFrame.new(footPos + Vector3.new(0, i * 2, 0))
            end)
        end
    end
end

local function refreshPartsAtFeet()
    if not expandEnabled then return end
    local rootPart = getHumanoidRootPart()
    if not rootPart then return end
    
    local currentParts = getAllExpandParts()
    if #currentParts ~= #expandParts then
        expandParts = currentParts
        for _, part in ipairs(expandParts) do
            makePartPlatform(part)
        end
    end
    
    local footPos = Vector3.new(rootPart.Position.X, rootPart.Position.Y - 3, rootPart.Position.Z)
    stackPartsAtFeet(expandParts, footPos)
end

local function toggleExpand(value)
    if value then
        expandParts = getAllExpandParts()
        for _, part in ipairs(expandParts) do
            makePartPlatform(part)
        end
        
        local connection = RunService.Heartbeat:Connect(refreshPartsAtFeet)
        table.insert(expandConnections, connection)
        
        expandFireLoop = task.spawn(function()
            while expandEnabled do
                pcall(function()
                    if ContributeToExpand then
                        for _, part in ipairs(expandParts) do
                            ContributeToExpand:FireServer(part)
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
        
        expandEnabled = true
        Library:Notification("Expand Farm enabled", 2, "success")
    else
        expandEnabled = false
        if expandFireLoop then
            task.cancel(expandFireLoop)
            expandFireLoop = nil
        end
        for _, conn in ipairs(expandConnections) do
            conn:Disconnect()
        end
        expandConnections = {}
        for _, part in ipairs(expandParts) do
            restorePart(part)
        end
        expandParts = {}
        Library:Notification("Expand Farm disabled", 2, "info")
    end
end

-- Resource functions
local function getOwnResources()
    local resources = {}
    local playerPlot = Workspace.Plots:FindFirstChild(username)
    if playerPlot then
        local resourcesFolder = playerPlot:FindFirstChild("Resources")
        if resourcesFolder then
            for _, v in ipairs(resourcesFolder:GetChildren()) do
                if v:IsA("BasePart") or v:IsA("Model") then
                    table.insert(resources, {
                        resource = v,
                        playerName = username,
                        source = "own"
                    })
                end
            end
        end
    end
    return resources
end

local function getPlayerResources(playerName)
    local resources = {}
    if playerName and playerName ~= "None" and playerName ~= "Self" then
        local playerPlot = Workspace.Plots:FindFirstChild(playerName)
        if playerPlot then
            local resourcesFolder = playerPlot:FindFirstChild("Resources")
            if resourcesFolder then
                for _, v in ipairs(resourcesFolder:GetChildren()) do
                    if v:IsA("BasePart") or v:IsA("Model") then
                        table.insert(resources, {
                            resource = v,
                            playerName = playerName,
                            source = "other"
                        })
                    end
                end
            end
        end
    end
    return resources
end

local function getAllTargetResources()
    local resources = {}
    
    if farmOwnResources then
        local ownResources = getOwnResources()
        for _, res in ipairs(ownResources) do
            table.insert(resources, res)
        end
    end
    
    if farmSelectedPlayers and #selectedTargetPlayers > 0 then
        for _, playerName in ipairs(selectedTargetPlayers) do
            local playerResources = getPlayerResources(playerName)
            for _, res in ipairs(playerResources) do
                table.insert(resources, res)
            end
        end
    end
    
    local rainbowResources = getRainbowResources()
    for _, resource in ipairs(rainbowResources) do
        if resource and resource.Parent then
            table.insert(resources, {
                resource = resource,
                playerName = "RainbowIsland",
                source = "rainbow"
            })
        end
    end
    
    return resources
end

local function updateSelectedPlayersDisplay()
    if SelectedPlayersLabel then
        if #selectedTargetPlayers > 0 then
            SelectedPlayersLabel:Set("Selected: " .. table.concat(selectedTargetPlayers, ", "))
        else
            SelectedPlayersLabel:Set("Selected: None")
        end
    end
end

local function refreshPlayerDropdown()
    if PlayerMultiDropdown then
        local players = getOtherPlayers()
        if #players > 0 then
            PlayerMultiDropdown:Refresh(players)
        else
            PlayerMultiDropdown:Refresh({"None"})
        end
    end
end

local function toggleResources(value)
    if value then
        if not HitResource then 
            Library:Notification("HitResource remote not found!", 3, "error")
            return 
        end
        
        resourceEnabled = true
        resourceLoop = task.spawn(function()
            while resourceEnabled do
                local resources = getAllTargetResources()
                if #resources > 0 then
                    for _, resourceData in ipairs(resources) do
                        if not resourceEnabled then break end
                        pcall(function() HitResource:FireServer(resourceData.resource) end)
                        task.wait(resourceSpeed)
                    end
                end
                task.wait(0.1)
            end
        end)
        Library:Notification("Auto Resources enabled", 2, "success")
    else
        resourceEnabled = false
        if resourceLoop then
            task.cancel(resourceLoop)
            resourceLoop = nil
        end
        Library:Notification("Auto Resources disabled", 2, "info")
    end
end

local function getAllCrafters()
    local crafters = {}
    local tagged = CollectionService:GetTagged("Crafter")
    for _, crafter in ipairs(tagged) do
        table.insert(crafters, crafter)
    end
    local plot = Workspace.Plots:FindFirstChild(username)
    if plot and plot:FindFirstChild("Land") then
        local function findInLand(parent)
            for _, child in ipairs(parent:GetChildren()) do
                if child:FindFirstChild("UI") and not table.find(crafters, child) then
                    table.insert(crafters, child)
                end
                if #child:GetChildren() > 0 then
                    findInLand(child)
                end
            end
        end
        findInLand(plot.Land)
    end
    return crafters
end

local function craftAll()
    local crafters = getAllCrafters()
    for _, crafter in ipairs(crafters) do
        pcall(function() CraftRemote:FireServer(crafter) end)
        task.wait(0.05)
    end
end

local function toggleCraft(value)
    if value then
        if not CraftRemote then 
            Library:Notification("Craft remote not found!", 3, "error")
            return 
        end
        
        craftEnabled = true
        craftLoop = task.spawn(function()
            while craftEnabled do
                craftAll()
                task.wait(1)
            end
        end)
        Library:Notification("Auto Craft enabled", 2, "success")
    else
        craftEnabled = false
        if craftLoop then
            task.cancel(craftLoop)
            craftLoop = nil
        end
        Library:Notification("Auto Craft disabled", 2, "info")
    end
end

local function toggleMerchant(value)
    if value then
        if not BuyFromMerchant then 
            Library:Notification("Merchant remote not found!", 3, "error")
            return 
        end
        
        merchantEnabled = true
        merchantLoop = task.spawn(function()
            while merchantEnabled do
                pcall(function() BuyFromMerchant:FireServer(selectedItem) end)
                task.wait(1)
            end
        end)
        Library:Notification("Auto Buy enabled", 2, "success")
    else
        merchantEnabled = false
        if merchantLoop then
            task.cancel(merchantLoop)
            merchantLoop = nil
        end
        Library:Notification("Auto Buy disabled", 2, "info")
    end
end

-- === MAIN TAB ===
local MainSection = MainTab:Section({ Name = "Resources" })

local ResourceToggle = MainSection:Toggle({ 
    Name = "Auto Resources", 
    Default = false, 
    Callback = toggleResources 
})

local ResourceSpeedSlider = MainSection:Slider({ 
    Name = "Speed", 
    Min = 0.01, 
    Max = 2, 
    Default = 0.01, 
    Decimals = 2, 
    Suffix = "s", 
    Callback = function(v) 
        resourceSpeed = v 
    end 
})

MainSection:Separator({ Name = "Resource Sources" })

local FarmOwnToggle = MainSection:Toggle({ 
    Name = "Farm Own Resources", 
    Default = true, 
    Callback = function(v) 
        farmOwnResources = v 
    end 
})

local FarmSelectedToggle = MainSection:Toggle({ 
    Name = "Farm Selected Players", 
    Default = false, 
    Callback = function(v) 
        farmSelectedPlayers = v 
    end 
})

SelectedPlayersLabel = MainSection:Paragraph({ 
    Title = "Selected Players", 
    Description = "Selected: None" 
})

-- Multi-select dropdown for players
PlayerMultiDropdown = MainSection:Dropdown({ 
    Name = "Select Players", 
    Options = getOtherPlayers(), 
    Max = 10,
    Searchable = true,
    Callback = function(selected)
        if type(selected) == "table" then
            selectedTargetPlayers = selected
        else
            selectedTargetPlayers = selected and selected ~= "None" and {selected} or {}
        end
        updateSelectedPlayersDisplay()
    end
})

MainSection:Button({ 
    Name = "Refresh Player List", 
    Callback = function()
        refreshPlayerDropdown()
        updateSelectedPlayersDisplay()
        Library:Notification("Player list refreshed", 1.5, "success")
    end
})

MainSection:Separator({ Name = "Crafting & Merchant" })

local CraftSection = MainTab:Section({ Name = "Crafting" })
local CraftToggle = CraftSection:Toggle({ 
    Name = "Auto Craft", 
    Default = false, 
    Callback = toggleCraft 
})

local MerchantSection = MainTab:Section({ Name = "Merchant" })

local ItemDropdown = MerchantSection:Dropdown({ 
    Name = "Select Item", 
    Options = merchantItems, 
    Default = "Corn Seeds", 
    Searchable = true,
    Callback = function(v) 
        selectedItem = v 
    end 
})

local MerchantToggle = MerchantSection:Toggle({ 
    Name = "Auto Buy", 
    Default = false, 
    Callback = toggleMerchant 
})

-- === PLAYER TAB ===
local PlayerSection = PlayerTab:Section({ Name = "Teleport" })

local PlayerDropdown = PlayerSection:Dropdown({ 
    Name = "Target Player", 
    Options = getOtherPlayers(), 
    Default = #getOtherPlayers() > 0 and getOtherPlayers()[1] or "None", 
    Searchable = true,
    Callback = function(v) 
        selectedPlayer = v 
        if teleportEnabled then
            toggleTeleport(false)
            if TeleportToggle then TeleportToggle:Set(false) end
        end
    end 
})

PlayerSection:Button({ 
    Name = "Refresh Player List", 
    Callback = function()
        local players = getOtherPlayers()
        if #players > 0 then
            PlayerDropdown:Refresh(players)
            if not selectedPlayer or not table.find(players, selectedPlayer) then
                selectedPlayer = players[1]
            end
        else
            PlayerDropdown:Refresh({"None"})
            selectedPlayer = "None"
        end
        Library:Notification("Player list refreshed", 1.5, "success")
    end
})

PlayerSection:Button({ 
    Name = "Teleport Once", 
    Callback = function()
        teleportToPlayer()
        Library:Notification("Teleported to " .. (selectedPlayer or "player"), 1.5, "success")
    end
})

TeleportToggle = PlayerSection:Toggle({ 
    Name = "Auto Follow", 
    Default = false, 
    Callback = toggleTeleport 
})

PlayerSection:Separator({ Name = "Expand Farm" })

local ExpandSection = PlayerTab:Section({ Name = "Expand Farm" })

local ExpandToggle = ExpandSection:Toggle({ 
    Name = "Auto Expand", 
    Default = false, 
    Callback = toggleExpand 
})

-- Auto-update player list
task.spawn(function()
    while true do
        task.wait(10)
        local players = getOtherPlayers()
        if #players > 0 then
            PlayerDropdown:Refresh(players)
            if not selectedPlayer or not table.find(players, selectedPlayer) then
                selectedPlayer = players[1]
            end
        else
            PlayerDropdown:Refresh({"None"})
            selectedPlayer = "None"
        end
        refreshPlayerDropdown()
    end
end)

-- === MOVEMENT TAB ===
local MovementSection = MovementTab:Section({ Name = "Walk Speed" })

local WalkSpeedSlider = MovementSection:Slider({ 
    Name = "Walk Speed", 
    Min = 16, 
    Max = 250, 
    Default = 16, 
    Callback = function(v) 
        setWalkSpeed(v) 
    end 
})

MovementSection:Button({ 
    Name = "Apply Walk Speed", 
    Callback = function() 
        setWalkSpeed(WalkSpeedSlider:GetValue())
        Library:Notification("Walk Speed set to " .. WalkSpeedSlider:GetValue(), 1.5, "success")
    end 
})

MovementSection:Button({ 
    Name = "Reset Walk Speed", 
    Callback = function()
        resetWalkSpeed()
        WalkSpeedSlider:Set(16)
        Library:Notification("Walk Speed reset to 16", 1.5, "info")
    end 
})

MovementSection:Separator({ Name = "Jump" })

local InfiniteJumpToggle = MovementSection:Toggle({ 
    Name = "Infinite Jump", 
    Default = false, 
    Callback = toggleInfiniteJump 
})

-- Right Control to toggle UI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        uiVisible = not uiVisible
        if Library and Library.mainframe then
            Library.mainframe.Visible = uiVisible
            Library:Notification("UI " .. (uiVisible and "shown" or "hidden"), 1, "info")
        end
    end
end)

-- Cleanup function
local function cleanup()
    if expandEnabled then toggleExpand(false) end
    if resourceEnabled then toggleResources(false) end
    if craftEnabled then toggleCraft(false) end
    if merchantEnabled then toggleMerchant(false) end
    if teleportEnabled then toggleTeleport(false) end
    if infiniteJumpEnabled then toggleInfiniteJump(false) end
    resetWalkSpeed()
    Library:Notification("All features disabled", 2, "info")
end

_G.cleanup = cleanup

-- Auto-cleanup
local scriptConnection
scriptConnection = game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child == script.Parent then
        cleanup()
        if scriptConnection then
            scriptConnection:Disconnect()
        end
    end
end)

-- Welcome notification
Library:Notification("Welcome to Abyss Hub! Press Right Control to toggle UI", 5, "info")

print("✓ Abyss Hub UI Loaded Successfully!")
