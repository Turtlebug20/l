-- UI Library Module for Executors
local UILibrary = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Texture IDs
local CLOSE_TEXTURE = "rbxassetid://132261474823036"
local MINIMIZE_TEXTURE = "rbxassetid://133107278165982"

-- Initialize GUI holder
function UILibrary:CreateScreen()
    -- Check if GUI already exists
    local existingGui = player:FindFirstChild("PlayerGui"):FindFirstChild("UILibrary")
    if existingGui then
        existingGui:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UILibrary"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main frame container
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Add shadow/drop shadow effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045167" -- Drop shadow image
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 10, 10)
    shadow.Parent = mainFrame
    
    return screenGui, mainFrame
end

-- Create window
function UILibrary:CreateWindow(title, size)
    local screenGui, mainFrame = self:CreateScreen()
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    -- Title text
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "UI Library"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 16
    titleLabel.Parent = titleBar
    
    -- Button container for window controls
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Size = UDim2.new(0, 70, 1, 0)
    buttonContainer.Position = UDim2.new(1, -70, 0, 0)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = titleBar
    
    -- Minimize button
    local minimizeButton = Instance.new("ImageButton")
    minimizeButton.Name = "Minimize"
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(0, 5, 0.5, -15)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    minimizeButton.BackgroundTransparency = 0.3
    minimizeButton.Image = MINIMIZE_TEXTURE
    minimizeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.ScaleType = Enum.ScaleType.Fit
    minimizeButton.Parent = buttonContainer
    
    -- Close button
    local closeButton = Instance.new("ImageButton")
    closeButton.Name = "Close"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(0, 35, 0.5, -15)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.BackgroundTransparency = 0.3
    closeButton.Image = CLOSE_TEXTURE
    closeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.ScaleType = Enum.ScaleType.Fit
    closeButton.Parent = buttonContainer
    
    -- Hover effects for buttons
    minimizeButton.MouseEnter:Connect(function()
        TweenService:Create(minimizeButton, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)
    
    minimizeButton.MouseLeave:Connect(function()
        TweenService:Create(minimizeButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
    end)
    
    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
    end)
    
    -- Minimize functionality
    local minimized = false
    local originalSize = mainFrame.Size
    local originalContentVisible = true
    
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        
        if minimized then
            -- Store content visibility state
            for _, child in pairs(mainFrame:GetChildren()) do
                if child.Name ~= "TitleBar" and child.Name ~= "Shadow" then
                    child.Visible = false
                end
            end
            -- Shrink window
            TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 35)}):Play()
        else
            -- Restore content visibility
            for _, child in pairs(mainFrame:GetChildren()) do
                if child.Name ~= "TitleBar" and child.Name ~= "Shadow" then
                    child.Visible = true
                end
            end
            -- Restore window size
            TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = originalSize}):Play()
        end
    end)
    
    -- Close functionality
    closeButton.MouseButton1Click:Connect(function()
        -- Fade out animation
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        wait(0.3)
        screenGui:Destroy()
    end)
    
    -- Tabs container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, 0, 0, 35)
    tabContainer.Position = UDim2.new(0, 0, 0, 35)
    tabContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame
    
    -- Content area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "Content"
    contentArea.Size = UDim2.new(1, -20, 1, -90)
    contentArea.Position = UDim2.new(0, 10, 0, 75)
    contentArea.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    contentArea.BorderSizePixel = 0
    contentArea.Parent = mainFrame
    
    -- Dragging functionality
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Return methods
    local window = {}
    window.Tabs = {}
    window.ScreenGui = screenGui
    window.MainFrame = mainFrame
    window.TabContainer = tabContainer
    window.ContentArea = contentArea
    window.Minimized = false
    
    function window:AddTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name.."Tab"
        tabButton.Size = UDim2.new(0, 100, 1, -4)
        tabButton.Position = UDim2.new(0, (#self.Tabs * 100) + 4, 0, 2)
        tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        tabButton.Text = name
        tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14
        tabButton.Parent = self.TabContainer
        
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = name.."Content"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 6
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.Visible = false
        tabContent.Parent = self.ContentArea
        
        if #self.Tabs == 0 then
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end
        
        tabButton.MouseButton1Click:Connect(function()
            for _, otherTab in pairs(self.Tabs) do
                otherTab.Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                otherTab.Content.Visible = false
            end
            
            TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
            tabContent.Visible = true
        end)
        
        -- Hover effect
        tabButton.MouseEnter:Connect(function()
            if tabButton.BackgroundColor3 ~= Color3.fromRGB(80, 80, 80) then
                TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if tabButton.BackgroundColor3 ~= Color3.fromRGB(80, 80, 80) then
                TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            end
        end)
        
        local tab = {
            Name = name,
            Button = tabButton,
            Content = tabContent
        }
        
        table.insert(self.Tabs, tab)
        return tab
    end
    
    return window
end

-- Add elements to tabs
function UILibrary:AddSection(tab, title)
    local section = Instance.new("Frame")
    section.Name = title.."Section"
    section.Size = UDim2.new(1, -20, 0, 100)
    section.Position = UDim2.new(0, 10, 0, 10 + (self:GetSectionCount(tab) * 110))
    section.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    section.BorderSizePixel = 0
    section.Parent = tab.Content
    
    -- Section title
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Size = UDim2.new(1, 0, 0, 30)
    sectionTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sectionTitle.Text = title
    sectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionTitle.Font = Enum.Font.GothamSemibold
    sectionTitle.TextSize = 14
    sectionTitle.Parent = section
    
    -- Content holder for section elements
    local sectionContent = Instance.new("Frame")
    sectionContent.Name = "Content"
    sectionContent.Size = UDim2.new(1, 0, 1, -30)
    sectionContent.Position = UDim2.new(0, 0, 0, 30)
    sectionContent.BackgroundTransparency = 1
    sectionContent.Parent = section
    
    return sectionContent
end

function UILibrary:AddButton(section, text, callback)
    local button = Instance.new("TextButton")
    button.Name = text.."Button"
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, 5 + (self:GetElementsInSection(section) * 35))
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = section
    
    button.MouseButton1Click:Connect(function()
        if callback then
            local success, err = pcall(callback)
            if not success then
                warn("Error in button callback:", err)
            end
        end
    end)
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 90, 90)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
    end)
    
    -- Update canvas size for scrolling
    if section.Parent and section.Parent.Parent then
        local scrollingFrame = section.Parent.Parent
        if scrollingFrame:IsA("ScrollingFrame") then
            local totalHeight = 0
            for _, child in pairs(scrollingFrame:GetChildren()) do
                if child:IsA("Frame") then
                    totalHeight = totalHeight + child.Size.Y.Offset + 10
                end
            end
            scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
        end
    end
    
    return button
end

function UILibrary:AddToggle(section, text, default, callback)
    local toggle = Instance.new("Frame")
    toggle.Name = text.."Toggle"
    toggle.Size = UDim2.new(1, -20, 0, 30)
    toggle.Position = UDim2.new(0, 10, 0, 5 + (self:GetElementsInSection(section) * 35))
    toggle.BackgroundTransparency = 1
    toggle.Parent = section
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(0, 150, 1, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = text
    toggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextSize = 14
    toggleLabel.Parent = toggle
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 40, 0, 20)
    toggleButton.Position = UDim2.new(1, -40, 0.5, -10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleButton.Parent = toggle
    
    -- Rounded corners
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleButton
    
    local toggleIndicator = Instance.new("Frame")
    toggleIndicator.Name = "Indicator"
    toggleIndicator.Size = UDim2.new(0, 16, 0, 16)
    toggleIndicator.Position = UDim2.new(0, 2, 0.5, -8)
    toggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleIndicator.Parent = toggleButton
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = toggleIndicator
    
    local state = default or false
    if state then
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        toggleIndicator.Position = UDim2.new(0, 22, 0.5, -8)
    end
    
    local function updateToggle()
        state = not state
        if state then
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
            TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 22, 0.5, -8)}):Play()
        else
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
            TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
        end
        
        if callback then
            local success, err = pcall(function() callback(state) end)
            if not success then
                warn("Error in toggle callback:", err)
            end
        end
    end
    
    -- Make the entire toggle clickable
    toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateToggle()
        end
    end)
    
    -- Update canvas size for scrolling
    if section.Parent and section.Parent.Parent then
        local scrollingFrame = section.Parent.Parent
        if scrollingFrame:IsA("ScrollingFrame") then
            local totalHeight = 0
            for _, child in pairs(scrollingFrame:GetChildren()) do
                if child:IsA("Frame") then
                    totalHeight = totalHeight + child.Size.Y.Offset + 10
                end
            end
            scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
        end
    end
    
    return toggle
end

-- Helper functions
function UILibrary:GetSectionCount(tab)
    local count = 0
    if tab and tab.Content then
        for _, child in pairs(tab.Content:GetChildren()) do
            if child:IsA("Frame") and child.Name:match("Section$") then
                count = count + 1
            end
        end
    end
    return count
end

function UILibrary:GetElementsInSection(section)
    local count = 0
    for _, child in pairs(section:GetChildren()) do
        if child:IsA("TextButton") or child.Name:match("Toggle$") then
            count = count + 1
        end
    end
    return count
end

return UILibrary
