local Library = loadstring(game:HttpGet("https://github.com/Turtlebug20/l/raw/refs/heads/main/ui.lua"))()

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local username = localPlayer.Name

local Window = Library:Window({
    Name = "Vast [.gg/vasthq]",
    Key = "abyssprotokey"
})

local function addWindowControls()
    if not Library or not Library.mainframe then 
        print("✗ Mainframe not found")
        return 
    end
    
    task.wait(0.5)
    print("✓ Mainframe found, adding buttons...")
    
    local function hideOriginalButtons()
        local theholderdwbbg = Library.mainframe:FindFirstChild("theholderdwbbg")
        if theholderdwbbg then
            local sidebarHolder = theholderdwbbg:FindFirstChild("SidebarHolder")
            if sidebarHolder then
                local anothersidebarholder = sidebarHolder:FindFirstChild("anothersidebarholder")
                if anothersidebarholder then
                    local buttonsholder = anothersidebarholder:FindFirstChild("Buttonsholder")
                    if buttonsholder then
                        local buttons = buttonsholder:FindFirstChild("Buttons")
                        if buttons then
                            for _, child in ipairs(buttons:GetChildren()) do
                                if child.Name:lower():find("minimize") or child.Name:lower():find("close") then
                                    child.Visible = false
                                end
                            end
                        end
                    end
                end
            end
            
            local content = theholderdwbbg:FindFirstChild("content")
            if content then
                for _, child in ipairs(content:GetChildren()) do
                    if child.Name:lower():find("minimize") or child.Name:lower():find("close") or child.Name == "WindowControls" then
                        child:Destroy()
                    end
                end
            end
        end
        
        for _, child in ipairs(Library.mainframe:GetChildren()) do
            if child.Name:lower():find("minimize") or child.Name:lower():find("close") then
                child:Destroy()
            end
        end
    end
    
    pcall(hideOriginalButtons)
    
    if Library.mainframe:FindFirstChild("TopRightButtons") then
        Library.mainframe.TopRightButtons:Destroy()
    end
    
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = "TopRightButtons"
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Size = UDim2.new(0, 80, 0, 40)
    buttonFrame.Position = UDim2.new(1, -90, 0, 10)
    buttonFrame.ZIndex = 1000
    buttonFrame.Parent = Library.mainframe
    
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 8)
    layout.Parent = buttonFrame
    
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
    minimizeIcon.Image = "http://www.roblox.com/asset/?id=115894980866040"
    minimizeIcon.ImageColor3 = Color3.fromRGB(200, 200, 210)
    minimizeIcon.BackgroundTransparency = 1
    minimizeIcon.Size = UDim2.fromOffset(16, 16)
    minimizeIcon.Position = UDim2.fromScale(0.5, 0.5)
    minimizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    minimizeIcon.ZIndex = 1002
    minimizeIcon.Parent = minimizeBtn
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Text = ""
    closeBtn.Size = UDim2.fromOffset(30, 30)
    closeBtn.BackgroundColor3 = Color3.fromRGB(45, 35, 35)
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 1001
    closeBtn.Parent = buttonFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    local closeIcon = Instance.new("ImageLabel")
    closeIcon.Name = "CloseIcon"
    closeIcon.Image = "http://www.roblox.com/asset/?id=6031094677"
    closeIcon.ImageColor3 = Color3.fromRGB(239, 68, 68)
    closeIcon.BackgroundTransparency = 1
    closeIcon.Size = UDim2.fromOffset(16, 16)
    closeIcon.Position = UDim2.fromScale(0.5, 0.5)
    closeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    closeIcon.ZIndex = 1002
    closeIcon.Parent = closeBtn
    
    local isMinimized = false
    local originalSize = nil
    local originalPosition = nil
    local contentFrame = nil
    
    local function findContentFrame()
        local theholderdwbbg = Library.mainframe:FindFirstChild("theholderdwbbg")
        if theholderdwbbg then
            return theholderdwbbg
        end
        return nil
    end
    
    minimizeBtn.MouseButton1Click:Connect(function()
        if not isMinimized then
            originalSize = Library.mainframe.Size
            originalPosition = Library.mainframe.Position
            
            contentFrame = findContentFrame()
            if contentFrame then
                contentFrame.Visible = false
            end
            
            for _, child in ipairs(Library.mainframe:GetChildren()) do
                if child ~= buttonFrame and child ~= Library.mainframe:FindFirstChild("UIStroke") and child ~= Library.mainframe:FindFirstChild("UICorner") then
                    if child:IsA("Frame") and child.Name ~= "UIGradient" then
                        child.Visible = false
                    end
                end
            end
            
            TweenService:Create(Library.mainframe, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, Library.mainframe.AbsoluteSize.X, 0, 50),
                Position = UDim2.new(0.5, -Library.mainframe.AbsoluteSize.X/2, 0, 50)
            }):Play()
            
            minimizeIcon.Image = "http://www.roblox.com/asset/?id=6034813118"
            isMinimized = true
            Library:Notification("Window minimized", 1, "info")
        else
            if contentFrame then
                contentFrame.Visible = true
            end
            
            for _, child in ipairs(Library.mainframe:GetChildren()) do
                if child ~= buttonFrame then
                    child.Visible = true
                end
            end
            
            TweenService:Create(Library.mainframe, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = originalSize or UDim2.new(0, 665, 0, 467),
                Position = originalPosition or UDim2.new(0.5, -332.5, 0.5, -233.5)
            }):Play()
            
            minimizeIcon.Image = "http://www.roblox.com/asset/?id=115894980866040"
            isMinimized = false
            Library:Notification("Window restored", 1, "info")
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        Library:SetOpen(false)
        Library:Notification("Window closed - Press Insert to reopen", 2, "info")
    end)
    
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

local MainTab = Library:Tab({
    Title = "Fishing",
    Icon = "rbxassetid://6023426926"
})

local SettingsTab = Library:Tab({
    Title = "Settings",
    Icon = "rbxassetid://6031094665"
})

task.spawn(function()
    task.wait(1)
    addWindowControls()
    
    task.wait(2)
    if Library.mainframe and not Library.mainframe:FindFirstChild("TopRightButtons") then
        print("Retrying button addition...")
        addWindowControls()
    end
end)

local config = {
    mythicalZones = true,
    autoCast = false,
    autoReel = false,
}

local reelConnection = nil
local castConnection = nil
local lastReelTime = 0
local lastCastTime = 0
local reelCooldown = 0.05
local castCooldown = 2.5

local function applyMythicalZones()
    local count = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and (obj.Material == Enum.Material.Water or obj.Name:lower():find("water")) then
            CollectionService:AddTag(obj, "River")
            
            local config = obj:FindFirstChild("Configuration")
            if not config then
                config = Instance.new("Folder")
                config.Name = "Configuration"
                config.Parent = obj
            end
            
            local fishingZone = config:FindFirstChild("FishingZone")
            if not fishingZone then
                fishingZone = Instance.new("StringValue")
                fishingZone.Name = "FishingZone"
                fishingZone.Parent = config
            end
            fishingZone.Value = "MythicalWaters"
            count = count + 1
        end
    end
    Library:Notification("✨ Made " .. count .. " water zones Mythical!", 3, "success")
end

local function getFishingUI()
    local pages = localPlayer.PlayerGui:FindFirstChild("Pages")
    if not pages then return nil end
    
    local fishGame = pages:FindFirstChild("FishGame")
    if not fishGame or not fishGame.Enabled then return nil end
    
    local frame = fishGame:FindFirstChild("Frame")
    if not frame then return nil end
    
    local buttonFrame = frame:FindFirstChild("buttonframe")
    if not buttonFrame then return nil end
    
    local fishButton = buttonFrame:FindFirstChild("FishButton")
    if not fishButton then return nil end
    
    local backframe = frame:FindFirstChild("backframe")
    if not backframe then return nil end
    
    local backgroundbar = backframe:FindFirstChild("backgroundbar")
    if not backgroundbar then return nil end
    
    local fillbar = backgroundbar:FindFirstChild("fillbar")
    if not fillbar then return nil end
    
    return {
        fishButton = fishButton,
        fillbar = fillbar,
        fishGame = fishGame,
        frame = frame,
        backframe = backframe,
        buttonFrame = buttonFrame
    }
end

local function clickFishButton(button)
    if not button then return false end
    
    local success = false
    
    pcall(function()
        button.Activated:Fire()
        success = true
    end)
    
    pcall(function()
        if button.MouseButton1Click then
            button.MouseButton1Click:Fire()
            success = true
        end
    end)
    
    pcall(function()
        for _, connection in pairs(getconnections(button.Activated)) do
            connection:Fire()
            success = true
        end
    end)
    
    pcall(function()
        local absPos = button.AbsolutePosition
        local absSize = button.AbsoluteSize
        
        if absPos.X > 0 and absPos.Y > 0 then
            local clickX = absPos.X + (absSize.X / 2)
            local clickY = absPos.Y + (absSize.Y / 2)
            
            VirtualInputManager:SendMouseMoveEvent(clickX, clickY, true)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, true, {}, 0)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, false, {}, 0)
            success = true
        end
    end)
    
    return success
end

local function startAutoReel()
    if reelConnection then reelConnection:Disconnect() end
    
    reelConnection = RunService.Heartbeat:Connect(function()
        if not config.autoReel then return end
        
        local now = tick()
        if now - lastReelTime < reelCooldown then return end
        
        local ui = getFishingUI()
        if not ui then return end
        
        if ui.fillbar.Visible and ui.fillbar.Size.X.Scale < 1 then
            if clickFishButton(ui.fishButton) then
                lastReelTime = now
            end
            
            local percent = math.floor(ui.fillbar.Size.X.Scale * 100)
            print("⚡ Reeling:", percent, "%")
            
            if ui.fillbar.Size.X.Scale > 0.9 then
                for i = 1, 3 do
                    task.wait(0.02)
                    clickFishButton(ui.fishButton)
                end
            end
        end
    end)
end

local function startAutoCast()
    if castConnection then castConnection:Disconnect() end
    
    castConnection = RunService.Heartbeat:Connect(function()
        if not config.autoCast then return end
        
        local now = tick()
        if now - lastCastTime < castCooldown then return end
        
        local ui = getFishingUI()
        if not ui then return end
        
        if not ui.fillbar.Visible then
            if clickFishButton(ui.fishButton) then
                lastCastTime = now
                print("🔄 Casting rod...")
            end
        end
    end)
end

local function stopAllFeatures()
    config.autoReel = false
    config.autoCast = false
    if reelConnection then
        reelConnection:Disconnect()
        reelConnection = nil
    end
    if castConnection then
        castConnection:Disconnect()
        castConnection = nil
    end
end

local FishingSection = MainTab:Section({ Name = "Fishing Controls" })

local MythicalToggle = FishingSection:Toggle({
    Name = "Mythical Zones",
    Default = config.mythicalZones,
    Callback = function(value)
        config.mythicalZones = value
        if value then
            applyMythicalZones()
            workspace.DescendantAdded:Connect(function(obj)
                task.wait(0.5)
                if config.mythicalZones and obj:IsA("Part") and (obj.Material == Enum.Material.Water or obj.Name:lower():find("water")) then
                    CollectionService:AddTag(obj, "River")
                    local config = obj:FindFirstChild("Configuration") or Instance.new("Folder", obj)
                    config.Name = "Configuration"
                    local fishingZone = config:FindFirstChild("FishingZone") or Instance.new("StringValue", config)
                    fishingZone.Name = "FishingZone"
                    fishingZone.Value = "MythicalWaters"
                end
            end)
        end
    end
})

local CastToggle = FishingSection:Toggle({
    Name = "Auto Cast",
    Default = config.autoCast,
    Callback = function(value)
        config.autoCast = value
        if value then
            startAutoCast()
            Library:Notification("Auto Cast enabled", 2, "success")
        else
            if castConnection then
                castConnection:Disconnect()
                castConnection = nil
            end
            Library:Notification("Auto Cast disabled", 2, "info")
        end
    end
})

local ReelToggle = FishingSection:Toggle({
    Name = "Auto Reel",
    Default = config.autoReel,
    Callback = function(value)
        config.autoReel = value
        if value then
            startAutoReel()
            Library:Notification("Auto Reel enabled", 2, "success")
        else
            if reelConnection then
                reelConnection:Disconnect()
                reelConnection = nil
            end
            Library:Notification("Auto Reel disabled", 2, "info")
        end
    end
})

local CastDelaySlider = FishingSection:Slider({
    Name = "Cast Delay",
    Min = 0.5,
    Max = 5,
    Default = 2.5,
    Decimals = 1,
    Suffix = "s",
    Callback = function(value)
        castCooldown = value
    end
})

local ReelSpeedSlider = FishingSection:Slider({
    Name = "Reel Speed",
    Min = 0.01,
    Max = 0.2,
    Default = 0.05,
    Decimals = 2,
    Suffix = "s",
    Callback = function(value)
        reelCooldown = value
    end
})

FishingSection:Button({
    Name = "Manual Cast",
    Callback = function()
        local ui = getFishingUI()
        if ui and not ui.fillbar.Visible then
            clickFishButton(ui.fishButton)
            Library:Notification("Cast!", 1, "success")
        else
            Library:Notification("Already fishing!", 1, "warning")
        end
    end
})

local StatusSection = MainTab:Section({ Name = "Status" })

local StatusLabel = StatusSection:Paragraph({
    Title = "Current Status",
    Description = "Idle"
})

task.spawn(function()
    while true do
        task.wait(0.5)
        local ui = getFishingUI()
        if ui and ui.fillbar.Visible then
            local percent = math.floor(ui.fillbar.Size.X.Scale * 100)
            StatusLabel:Set("Status", string.format("Fishing: %d%%", percent))
        elseif ui then
            StatusLabel:Set("Status", "Ready to cast")
        else
            StatusLabel:Set("Status", "No rod equipped?")
        end
    end
end)

local SettingsSection = SettingsTab:Section({ Name = "Settings" })

SettingsSection:Button({
    Name = "Reapply Mythical Zones",
    Callback = function()
        applyMythicalZones()
    end
})

SettingsSection:Button({
    Name = "Stop All Features",
    Callback = function()
        stopAllFeatures()
        CastToggle:Set(false)
        ReelToggle:Set(false)
        Library:Notification("All features stopped", 2, "info")
    end
})

SettingsSection:Button({
    Name = "Toggle UI (Right Control)",
    Callback = function()
        if Library and Library.mainframe then
            Library.mainframe.Visible = not Library.mainframe.Visible
        end
    end
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        if Library and Library.mainframe then
            Library.mainframe.Visible = not Library.mainframe.Visible
            Library:Notification("UI " .. (Library.mainframe.Visible and "shown" or "hidden"), 1, "info")
        end
    end
end)

local function cleanup()
    stopAllFeatures()
    Library:Notification("Fishing Bot stopped", 2, "info")
end

_G.cleanup = cleanup

local scriptConnection
scriptConnection = game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child == script.Parent then
        cleanup()
        if scriptConnection then
            scriptConnection:Disconnect()
        end
    end
end)

Library:Notification("Fishing Bot Loaded! Press Right Control to toggle UI", 5, "success")

print("✓ Fishing Bot UI Loaded Successfully!")
print("⚡ Auto Reel: Ready")
print("🔄 Auto Cast: Ready")
print("🔮 Mythical Zones: Ready")
