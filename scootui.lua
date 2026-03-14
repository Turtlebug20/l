if Library then
    Library:Unload()
end

local LoadTick = os.clock()

local Library do
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local TextService = game:GetService("TextService")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local Vector2New = Vector2.new

    local MathClamp = math.clamp
    local MathFloor = math.floor
    local MathAbs = math.abs
    local MathMin = math.min
    local MathMax = math.max
    local MathRound = math.round

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower
    local StringUpper = string.upper
    local StringSplit = string.split

    local InstanceNew = Instance.new
    local RectNew = Rect.new

    Library = {
        Theme = {
            Background = FromRGB(18, 18, 22),
            Surface = FromRGB(25, 25, 30),
            Element = FromRGB(35, 35, 42),
            ElementHover = FromRGB(45, 45, 52),
            ElementSelected = FromRGB(55, 55, 62),
            Text = FromRGB(245, 245, 250),
            TextSecondary = FromRGB(160, 160, 170),
            Accent = FromRGB(100, 120, 255),
            AccentHover = FromRGB(120, 140, 255),
            AccentSoft = FromRGB(100, 120, 255, 0.2),
            Danger = FromRGB(255, 80, 90),
            Success = FromRGB(70, 200, 120),
            Warning = FromRGB(255, 180, 60),
            Border = FromRGB(45, 45, 52),
            BorderLight = FromRGB(55, 55, 62),
            Shadow = FromRGB(0, 0, 0),
        },

        MenuKeybind = Enum.KeyCode.RightControl,
        Flags = {},

        Tween = {
            Time = 0.2,
            Style = Enum.EasingStyle.Quad,
            Direction = Enum.EasingDirection.Out
        },

        Images = {
            Logo = "rbxassetid://138198203269424",
        },

        Pages = {},
        Sections = {},
        Connections = {},
        Threads = {},
        OpenFrames = {},
        CurrentPage = nil,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        Font = Enum.Font.Gotham,

        BlurEnabled = true,
        RoundedCorners = true,
        CornerRadius = UDimNew(0, 8),
        SmallCornerRadius = UDimNew(0, 4),
        
        Windows = {},
    }

    -- Initialize UI
    function Library:Initialize()
        self.Holder = InstanceNew("ScreenGui")
        self.Holder.Name = "ModernUILibrary"
        self.Holder.Parent = gethui()
        self.Holder.ResetOnSpawn = false
        self.Holder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        self.Holder.DisplayOrder = 999
        self.Holder.IgnoreGuiInset = true

        if self.BlurEnabled then
            local blur = InstanceNew("BlurEffect")
            blur.Name = "UIBlur"
            blur.Size = 0
            blur.Parent = workspace.CurrentCamera or workspace
            self.Blur = blur
        end

        self.NotifHolder = InstanceNew("Frame")
        self.NotifHolder.Name = "NotificationHolder"
        self.NotifHolder.Size = UDim2New(0, 350, 1, -40)
        self.NotifHolder.Position = UDim2New(1, -370, 0, 20)
        self.NotifHolder.BackgroundTransparency = 1
        self.NotifHolder.Parent = self.Holder
    end

    -- Window Creation
    function Library:CreateWindow(title, size)
        if not self.Holder then self:Initialize() end

        local window = {}
        size = size or UDim2New(0, 900, 0, 550)

        -- Main frame
        local mainFrame = InstanceNew("Frame")
        mainFrame.Name = "Window"
        mainFrame.Size = size
        mainFrame.Position = UDim2New(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
        mainFrame.BackgroundColor3 = self.Theme.Background
        mainFrame.BorderSizePixel = 0
        mainFrame.ClipsDescendants = true
        mainFrame.Active = true
        mainFrame.Parent = self.Holder

        -- Shadow
        local shadow = InstanceNew("ImageLabel")
        shadow.Name = "Shadow"
        shadow.Size = UDim2New(1, 40, 1, 40)
        shadow.Position = UDim2New(0, -20, 0, -20)
        shadow.BackgroundTransparency = 1
        shadow.Image = "rbxassetid://1316045167"
        shadow.ImageColor3 = self.Theme.Shadow
        shadow.ImageTransparency = 0.7
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.SliceCenter = RectNew(10, 10, 10, 10)
        shadow.Parent = mainFrame
        shadow.ZIndex = -1
        shadow.Active = false

        if self.RoundedCorners then
            local corner = InstanceNew("UICorner")
            corner.CornerRadius = self.CornerRadius
            corner.Parent = mainFrame
        end

        -- Title bar - ONLY this is draggable
        local titleBar = InstanceNew("Frame")
        titleBar.Name = "TitleBar"
        titleBar.Size = UDim2New(1, 0, 0, 48)
        titleBar.BackgroundColor3 = self.Theme.Surface
        titleBar.BorderSizePixel = 0
        titleBar.Active = true
        titleBar.Parent = mainFrame

        if self.RoundedCorners then
            local titleCorner = InstanceNew("UICorner")
            titleCorner.CornerRadius = self.CornerRadius
            titleCorner.Parent = titleBar
        end

        -- Logo
        local logo = InstanceNew("ImageLabel")
        logo.Name = "Logo"
        logo.Size = UDim2New(0, 28, 0, 28)
        logo.Position = UDim2New(0, 12, 0.5, -14)
        logo.BackgroundTransparency = 1
        logo.Image = self.Images.Logo
        logo.ImageColor3 = self.Theme.Accent
        logo.Parent = titleBar
        logo.Active = false

        -- Title
        local titleLabel = InstanceNew("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2New(0, 200, 1, 0)
        titleLabel.Position = UDim2New(0, 48, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title or "UI Library"
        titleLabel.TextColor3 = self.Theme.Text
        titleLabel.Font = self.Font
        titleLabel.TextSize = 16
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = titleBar
        titleLabel.Active = false

        -- Window controls
        local buttonContainer = InstanceNew("Frame")
        buttonContainer.Name = "WindowControls"
        buttonContainer.Size = UDim2New(0, 88, 1, 0)
        buttonContainer.Position = UDim2New(1, -88, 0, 0)
        buttonContainer.BackgroundTransparency = 1
        buttonContainer.Parent = titleBar
        buttonContainer.Active = false

        -- Minimize button
        local minimizeButton = InstanceNew("TextButton")
        minimizeButton.Name = "Minimize"
        minimizeButton.Size = UDim2New(0, 32, 0, 32)
        minimizeButton.Position = UDim2New(0, 12, 0.5, -16)
        minimizeButton.BackgroundColor3 = self.Theme.Element
        minimizeButton.Text = "—"
        minimizeButton.TextColor3 = self.Theme.TextSecondary
        minimizeButton.Font = self.Font
        minimizeButton.TextSize = 20
        minimizeButton.Parent = buttonContainer
        minimizeButton.Active = true
        minimizeButton.AutoButtonColor = false

        -- Close button
        local closeButton = InstanceNew("TextButton")
        closeButton.Name = "Close"
        closeButton.Size = UDim2New(0, 32, 0, 32)
        closeButton.Position = UDim2New(0, 48, 0.5, -16)
        closeButton.BackgroundColor3 = self.Theme.Element
        closeButton.Text = "×"
        closeButton.TextColor3 = self.Theme.TextSecondary
        closeButton.Font = self.Font
        closeButton.TextSize = 24
        closeButton.Parent = buttonContainer
        closeButton.Active = true
        closeButton.AutoButtonColor = false

        if self.RoundedCorners then
            local minCorner = InstanceNew("UICorner")
            minCorner.CornerRadius = self.SmallCornerRadius
            minCorner.Parent = minimizeButton
            
            local closeCorner = InstanceNew("UICorner")
            closeCorner.CornerRadius = self.SmallCornerRadius
            closeCorner.Parent = closeButton
        end

        -- Hover effects
        minimizeButton.MouseEnter:Connect(function()
            TweenService:Create(minimizeButton, TweenInfo.new(0.15), {BackgroundColor3 = self.Theme.ElementHover}):Play()
        end)
        minimizeButton.MouseLeave:Connect(function()
            TweenService:Create(minimizeButton, TweenInfo.new(0.15), {BackgroundColor3 = self.Theme.Element}):Play()
        end)

        closeButton.MouseEnter:Connect(function()
            TweenService:Create(closeButton, TweenInfo.new(0.15), {BackgroundColor3 = self.Theme.Danger}):Play()
        end)
        closeButton.MouseLeave:Connect(function()
            TweenService:Create(closeButton, TweenInfo.new(0.15), {BackgroundColor3 = self.Theme.Element}):Play()
        end)

        -- Fixed minimize functionality
        local minimized = false
        local originalSize = size
        local contentFrames = {}

        minimizeButton.MouseButton1Click:Connect(function()
            minimized = not minimized
            
            -- Collect all content frames
            contentFrames = {}
            for _, child in pairs(mainFrame:GetChildren()) do
                if child ~= titleBar and child ~= shadow and child:IsA("Frame") then
                    TableInsert(contentFrames, child)
                end
            end

            if minimized then
                -- Hide content
                for _, frame in pairs(contentFrames) do
                    frame.Visible = false
                end
                
                -- Shrink window
                TweenService:Create(mainFrame, TweenInfo.new(0.25), {
                    Size = UDim2New(originalSize.X.Scale, originalSize.X.Offset, 0, 48)
                }):Play()
                
                minimizeButton.Text = "□"
            else
                -- Show window
                TweenService:Create(mainFrame, TweenInfo.new(0.25), {
                    Size = originalSize
                }):Play()
                
                -- Show content after a short delay
                task.wait(0.15)
                for _, frame in pairs(contentFrames) do
                    frame.Visible = true
                end
                
                minimizeButton.Text = "—"
            end
        end)

        -- Close functionality
        closeButton.MouseButton1Click:Connect(function()
            self:Unload()
        end)

        -- Sidebar
        local sidebar = InstanceNew("Frame")
        sidebar.Name = "Sidebar"
        sidebar.Size = UDim2New(0, 200, 1, -48)
        sidebar.Position = UDim2New(0, 0, 0, 48)
        sidebar.BackgroundColor3 = self.Theme.Surface
        sidebar.BorderSizePixel = 0
        sidebar.Parent = mainFrame
        sidebar.Active = false

        if self.RoundedCorners then
            local sidebarCorner = InstanceNew("UICorner")
            sidebarCorner.CornerRadius = self.CornerRadius
            sidebarCorner.Parent = sidebar
        end

        -- Sidebar title
        local sidebarTitle = InstanceNew("TextLabel")
        sidebarTitle.Name = "SidebarTitle"
        sidebarTitle.Size = UDim2New(1, -20, 0, 40)
        sidebarTitle.Position = UDim2New(0, 10, 0, 10)
        sidebarTitle.BackgroundTransparency = 1
        sidebarTitle.Text = "NAVIGATION"
        sidebarTitle.TextColor3 = self.Theme.TextSecondary
        sidebarTitle.Font = self.Font
        sidebarTitle.TextSize = 11
        sidebarTitle.TextXAlignment = Enum.TextXAlignment.Left
        sidebarTitle.Parent = sidebar
        sidebarTitle.Active = false

        -- Tab container (ScrollingFrame)
        local tabContainer = InstanceNew("ScrollingFrame")
        tabContainer.Name = "TabContainer"
        tabContainer.Size = UDim2New(1, 0, 1, -60)
        tabContainer.Position = UDim2New(0, 0, 0, 50)
        tabContainer.BackgroundTransparency = 1
        tabContainer.BorderSizePixel = 0
        tabContainer.ScrollBarThickness = 3
        tabContainer.ScrollBarImageColor3 = self.Theme.ElementHover
        tabContainer.CanvasSize = UDim2New(0, 0, 0, 0)
        tabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContainer.Parent = sidebar
        tabContainer.Active = true

        -- Content area
        local contentArea = InstanceNew("Frame")
        contentArea.Name = "ContentArea"
        contentArea.Size = UDim2New(1, -210, 1, -58)
        contentArea.Position = UDim2New(0, 205, 0, 53)
        contentArea.BackgroundColor3 = self.Theme.Background
        contentArea.BorderSizePixel = 0
        contentArea.Parent = mainFrame
        contentArea.Active = false

        if self.RoundedCorners then
            local contentCorner = InstanceNew("UICorner")
            contentCorner.CornerRadius = self.CornerRadius
            contentCorner.Parent = contentArea
        end

        -- FIXED Dragging - Only title bar triggers drag
        local dragging = false
        local dragInput
        local dragStart
        local startPos

        -- Only the title bar initiates dragging
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = mainFrame.Position
                
                -- Capture mouse to prevent losing drag
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

        -- Global input changed for dragging
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging and not minimized then
                local delta = input.Position - dragStart
                local newPos = UDim2New(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
                mainFrame.Position = newPos
            end
        end)

        -- Prevent drag when clicking on other elements
        mainFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                -- Stop propagation to prevent accidental dragging
                input:Block()
            end
        end)

        -- Window methods
        window.MainFrame = mainFrame
        window.Sidebar = sidebar
        window.TabContainer = tabContainer
        window.ContentArea = contentArea
        window.Tabs = {}
        window.TitleBar = titleBar

        -- FIXED: Add Tab method with proper functionality
        function window:AddTab(name, icon)
            local tabIndex = #self.Tabs + 1
            
            local tabButton = InstanceNew("TextButton")
            tabButton.Name = name.."Tab"
            tabButton.Size = UDim2New(1, -20, 0, 38)
            tabButton.Position = UDim2New(0, 10, 0, (tabIndex - 1) * 43)
            tabButton.BackgroundColor3 = Library.Theme.Element
            tabButton.BackgroundTransparency = 0.8
            tabButton.Text = ""
            tabButton.Parent = tabContainer
            tabButton.AutoButtonColor = false
            tabButton.Active = true

            -- Button text
            local buttonText = InstanceNew("TextLabel")
            buttonText.Name = "Text"
            buttonText.Size = UDim2New(1, -30, 1, 0)
            buttonText.Position = UDim2New(0, 12, 0, 0)
            buttonText.BackgroundTransparency = 1
            buttonText.Text = name
            buttonText.TextColor3 = Library.Theme.Text
            buttonText.Font = Library.Font
            buttonText.TextSize = 13
            buttonText.TextXAlignment = Enum.TextXAlignment.Left
            buttonText.Parent = tabButton
            buttonText.Active = false

            if Library.RoundedCorners then
                local btnCorner = InstanceNew("UICorner")
                btnCorner.CornerRadius = Library.SmallCornerRadius
                btnCorner.Parent = tabButton
            end

            -- Tab content container (ScrollingFrame)
            local tabContent = InstanceNew("ScrollingFrame")
            tabContent.Name = name.."Content"
            tabContent.Size = UDim2New(1, -20, 1, -20)
            tabContent.Position = UDim2New(0, 10, 0, 10)
            tabContent.BackgroundTransparency = 1
            tabContent.BorderSizePixel = 0
            tabContent.ScrollBarThickness = 4
            tabContent.ScrollBarImageColor3 = Library.Theme.ElementHover
            tabContent.CanvasSize = UDim2New(0, 0, 0, 0)
            tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
            tabContent.Visible = false
            tabContent.Parent = contentArea
            tabContent.Active = true

            -- Selection indicator
            local indicator = InstanceNew("Frame")
            indicator.Name = "Indicator"
            indicator.Size = UDim2New(0, 3, 1, -10)
            indicator.Position = UDim2New(0, 0, 0.5, 0)
            indicator.BackgroundColor3 = Library.Theme.Accent
            indicator.BorderSizePixel = 0
            indicator.Visible = false
            indicator.Parent = tabButton
            indicator.Active = false

            if Library.RoundedCorners then
                local indCorner = InstanceNew("UICorner")
                indCorner.CornerRadius = UDimNew(0, 2)
                indCorner.Parent = indicator
            end

            -- Set first tab as active
            if tabIndex == 1 then
                tabContent.Visible = true
                tabButton.BackgroundColor3 = Library.Theme.ElementHover
                tabButton.BackgroundTransparency = 0
                indicator.Visible = true
                Library.CurrentPage = tabContent
            end

            -- FIXED: Tab click handler
            tabButton.MouseButton1Click:Connect(function()
                -- Hide all tabs
                for _, otherTab in pairs(self.Tabs) do
                    otherTab.Content.Visible = false
                    otherTab.Button.BackgroundColor3 = Library.Theme.Element
                    otherTab.Button.BackgroundTransparency = 0.8
                    if otherTab.Indicator then
                        otherTab.Indicator.Visible = false
                    end
                end

                -- Show selected tab
                tabContent.Visible = true
                tabButton.BackgroundColor3 = Library.Theme.ElementHover
                tabButton.BackgroundTransparency = 0
                indicator.Visible = true
                Library.CurrentPage = tabContent
            end)

            -- Hover effects
            tabButton.MouseEnter:Connect(function()
                if tabContent.Visible then return end
                TweenService:Create(tabButton, TweenInfo.new(0.15), {
                    BackgroundColor3 = Library.Theme.ElementHover,
                    BackgroundTransparency = 0.4
                }):Play()
            end)

            tabButton.MouseLeave:Connect(function()
                if tabContent.Visible then return end
                TweenService:Create(tabButton, TweenInfo.new(0.15), {
                    BackgroundColor3 = Library.Theme.Element,
                    BackgroundTransparency = 0.8
                }):Play()
            end)

            -- Store tab
            local tab = {
                Name = name,
                Button = tabButton,
                Content = tabContent,
                Indicator = indicator,
                Index = tabIndex
            }

            TableInsert(self.Tabs, tab)
            
            -- Update container canvas size
            tabContainer.CanvasSize = UDim2New(0, 0, 0, (#self.Tabs * 43) + 10)
            
            return tab
        end

        TableInsert(self.Windows, window)
        return window
    end

    -- Section creation
    function Library:AddSection(tab, title)
        if not tab or not tab.Content then return nil end
        
        local sectionCount = self:GetSectionCount(tab)
        
        local section = InstanceNew("Frame")
        section.Name = title.."Section"
        section.Size = UDim2New(1, 0, 0, 100)
        section.Position = UDim2New(0, 0, 0, sectionCount * 120)
        section.BackgroundColor3 = self.Theme.Surface
        section.BorderSizePixel = 0
        section.Parent = tab.Content
        section.Active = false

        if self.RoundedCorners then
            local sectionCorner = InstanceNew("UICorner")
            sectionCorner.CornerRadius = self.CornerRadius
            sectionCorner.Parent = section
        end

        -- Header
        local header = InstanceNew("Frame")
        header.Name = "Header"
        header.Size = UDim2New(1, 0, 0, 38)
        header.BackgroundColor3 = self.Theme.Element
        header.BorderSizePixel = 0
        header.Parent = section
        header.Active = false

        if self.RoundedCorners then
            local headerCorner = InstanceNew("UICorner")
            headerCorner.CornerRadius = self.CornerRadius
            headerCorner.Parent = header
        end

        local titleLabel = InstanceNew("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2New(1, -20, 1, 0)
        titleLabel.Position = UDim2New(0, 10, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = StringUpper(title)
        titleLabel.TextColor3 = self.Theme.TextSecondary
        titleLabel.Font = self.Font
        titleLabel.TextSize = 12
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = header
        titleLabel.Active = false

        -- Content container
        local content = InstanceNew("Frame")
        content.Name = "Content"
        content.Size = UDim2New(1, -20, 1, -48)
        content.Position = UDim2New(0, 10, 0, 43)
        content.BackgroundTransparency = 1
        content.Parent = section
        content.Active = false

        return content
    end

    -- Button
    function Library:AddButton(section, text, callback)
        if not section then return nil end
        
        local button = InstanceNew("TextButton")
        button.Name = text.."Button"
        button.Size = UDim2New(1, 0, 0, 32)
        button.Position = UDim2New(0, 0, 0, self:GetElementsInSection(section) * 37)
        button.BackgroundColor3 = self.Theme.Element
        button.Text = ""
        button.Parent = section
        button.AutoButtonColor = false
        button.Active = true

        if self.RoundedCorners then
            local btnCorner = InstanceNew("UICorner")
            btnCorner.CornerRadius = self.SmallCornerRadius
            btnCorner.Parent = button
        end

        local buttonText = InstanceNew("TextLabel")
        buttonText.Name = "Text"
        buttonText.Size = UDim2New(1, -12, 1, 0)
        buttonText.Position = UDim2New(0, 12, 0, 0)
        buttonText.BackgroundTransparency = 1
        buttonText.Text = text
        buttonText.TextColor3 = self.Theme.Text
        buttonText.Font = self.Font
        buttonText.TextSize = 13
        buttonText.TextXAlignment = Enum.TextXAlignment.Left
        buttonText.Parent = button
        buttonText.Active = false

        button.MouseButton1Click:Connect(function()
            if callback then
                local success, err = pcall(callback)
                if not success then
                    warn("Button error:", err)
                end
            end
        end)

        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = self.Theme.ElementHover}):Play()
        end)

        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = self.Theme.Element}):Play()
        end)

        self:UpdateSectionSize(section.Parent)
        return button
    end

    -- Toggle
    function Library:AddToggle(section, text, default, callback)
        if not section then return nil end
        
        local toggle = InstanceNew("Frame")
        toggle.Name = text.."Toggle"
        toggle.Size = UDim2New(1, 0, 0, 32)
        toggle.Position = UDim2New(0, 0, 0, self:GetElementsInSection(section) * 37)
        toggle.BackgroundColor3 = self.Theme.Element
        toggle.BackgroundTransparency = 0.5
        toggle.Parent = section
        toggle.Active = true

        if self.RoundedCorners then
            local toggleCorner = InstanceNew("UICorner")
            toggleCorner.CornerRadius = self.SmallCornerRadius
            toggleCorner.Parent = toggle
        end

        local toggleLabel = InstanceNew("TextLabel")
        toggleLabel.Name = "Label"
        toggleLabel.Size = UDim2New(1, -60, 1, 0)
        toggleLabel.Position = UDim2New(0, 12, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = text
        toggleLabel.TextColor3 = self.Theme.Text
        toggleLabel.Font = self.Font
        toggleLabel.TextSize = 13
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggle
        toggleLabel.Active = false

        local toggleButton = InstanceNew("Frame")
        toggleButton.Name = "ToggleButton"
        toggleButton.Size = UDim2New(0, 44, 0, 22)
        toggleButton.Position = UDim2New(1, -54, 0.5, -11)
        toggleButton.BackgroundColor3 = self.Theme.ElementHover
        toggleButton.Parent = toggle
        toggleButton.Active = false

        if self.RoundedCorners then
            local btnCorner = InstanceNew("UICorner")
            btnCorner.CornerRadius = UDimNew(0, 11)
            btnCorner.Parent = toggleButton
        end

        local toggleIndicator = InstanceNew("Frame")
        toggleIndicator.Name = "Indicator"
        toggleIndicator.Size = UDim2New(0, 18, 0, 18)
        toggleIndicator.Position = UDim2New(0, 2, 0.5, -9)
        toggleIndicator.BackgroundColor3 = self.Theme.Text
        toggleIndicator.Parent = toggleButton
        toggleIndicator.Active = false

        if self.RoundedCorners then
            local indCorner = InstanceNew("UICorner")
            indCorner.CornerRadius = UDimNew(1, 0)
            indCorner.Parent = toggleIndicator
        end

        local state = default or false
        if state then
            toggleButton.BackgroundColor3 = self.Theme.Accent
            toggleIndicator.Position = UDim2New(0, 24, 0.5, -9)
        end

        local function updateToggle()
            state = not state
            if state then
                TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Accent}):Play()
                TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {Position = UDim2New(0, 24, 0.5, -9)}):Play()
            else
                TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.ElementHover}):Play()
                TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {Position = UDim2New(0, 2, 0.5, -9)}):Play()
            end

            if callback then
                pcall(function() callback(state) end)
            end
        end

        toggle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                updateToggle()
            end
        end)

        self:UpdateSectionSize(section.Parent)
        return toggle
    end

    -- Slider
    function Library:AddSlider(section, text, min, max, default, callback)
        if not section then return nil end
        
        min = min or 0
        max = max or 100
        default = default or min

        local slider = InstanceNew("Frame")
        slider.Name = text.."Slider"
        slider.Size = UDim2New(1, 0, 0, 45)
        slider.Position = UDim2New(0, 0, 0, self:GetElementsInSection(section) * 37)
        slider.BackgroundTransparency = 1
        slider.Parent = section
        slider.Active = true

        local sliderLabel = InstanceNew("TextLabel")
        sliderLabel.Name = "Label"
        sliderLabel.Size = UDim2New(0, 150, 0, 20)
        sliderLabel.Position = UDim2New(0, 0, 0, 0)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = text
        sliderLabel.TextColor3 = self.Theme.Text
        sliderLabel.Font = self.Font
        sliderLabel.TextSize = 13
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = slider
        sliderLabel.Active = false

        local valueLabel = InstanceNew("TextLabel")
        valueLabel.Name = "Value"
        valueLabel.Size = UDim2New(0, 50, 0, 20)
        valueLabel.Position = UDim2New(1, -50, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default)
        valueLabel.TextColor3 = self.Theme.Accent
        valueLabel.Font = self.Font
        valueLabel.TextSize = 13
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = slider
        valueLabel.Active = false

        -- Slider background
        local sliderBg = InstanceNew("Frame")
        sliderBg.Name = "Background"
        sliderBg.Size = UDim2New(1, 0, 0, 4)
        sliderBg.Position = UDim2New(0, 0, 0, 28)
        sliderBg.BackgroundColor3 = self.Theme.Element
        sliderBg.BorderSizePixel = 0
        sliderBg.Parent = slider
        sliderBg.Active = false

        if self.RoundedCorners then
            local bgCorner = InstanceNew("UICorner")
            bgCorner.CornerRadius = UDimNew(0, 2)
            bgCorner.Parent = sliderBg
        end

        -- Slider fill
        local sliderFill = InstanceNew("Frame")
        sliderFill.Name = "Fill"
        sliderFill.Size = UDim2New((default - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = self.Theme.Accent
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBg
        sliderFill.Active = false

        if self.RoundedCorners then
            local fillCorner = InstanceNew("UICorner")
            fillCorner.CornerRadius = UDimNew(0, 2)
            fillCorner.Parent = sliderFill
        end

        -- Slider button (draggable)
        local sliderButton = InstanceNew("TextButton")
        sliderButton.Name = "Button"
        sliderButton.Size = UDim2New(1, 0, 3, 0)
        sliderButton.Position = UDim2New(0, 0, 0, -1)
        sliderButton.BackgroundTransparency = 1
        sliderButton.Text = ""
        sliderButton.Parent = sliderBg
        sliderButton.Active = true
        sliderButton.AutoButtonColor = false

        local value = default
        local dragging = false

        local function updateSlider(inputPos)
            local relativePos = MathClamp(inputPos.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
            local percent = relativePos / sliderBg.AbsoluteSize.X
            value = min + (percent * (max - min))
            value = MathRound(value * 100) / 100
            
            sliderFill.Size = UDim2New(percent, 0, 1, 0)
            valueLabel.Text = tostring(value)

            if callback then
                pcall(function() callback(value) end)
            end
        end

        sliderButton.MouseButton1Down:Connect(function(input)
            dragging = true
            updateSlider(input)

            local connection
            connection = RunService.RenderStepped:Connect(function()
                if dragging then
                    updateSlider(UserInputService:GetMouseLocation())
                else
                    connection:Disconnect()
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
        end)

        self:UpdateSectionSize(section.Parent)
        return slider
    end

    -- Dropdown
    function Library:AddDropdown(section, text, options, default, callback)
        if not section then return nil end
        
        options = options or {"Option 1", "Option 2", "Option 3"}
        local selected = default or options[1]

        local dropdown = InstanceNew("Frame")
        dropdown.Name = text.."Dropdown"
        dropdown.Size = UDim2New(1, 0, 0, 32)
        dropdown.Position = UDim2New(0, 0, 0, self:GetElementsInSection(section) * 37)
        dropdown.BackgroundColor3 = self.Theme.Element
        dropdown.BackgroundTransparency = 0.5
        dropdown.ClipsDescendants = true
        dropdown.Parent = section
        dropdown.Active = true

        if self.RoundedCorners then
            local dropCorner = InstanceNew("UICorner")
            dropCorner.CornerRadius = self.SmallCornerRadius
            dropCorner.Parent = dropdown
        end

        local dropLabel = InstanceNew("TextLabel")
        dropLabel.Name = "Label"
        dropLabel.Size = UDim2New(1, -40, 1, 0)
        dropLabel.Position = UDim2New(0, 12, 0, 0)
        dropLabel.BackgroundTransparency = 1
        dropLabel.Text = text..": "..selected
        dropLabel.TextColor3 = self.Theme.Text
        dropLabel.Font = self.Font
        dropLabel.TextSize = 13
        dropLabel.TextXAlignment = Enum.TextXAlignment.Left
        dropLabel.Parent = dropdown
        dropLabel.Active = false

        local arrow = InstanceNew("TextLabel")
        arrow.Name = "Arrow"
        arrow.Size = UDim2New(0, 30, 1, 0)
        arrow.Position = UDim2New(1, -30, 0, 0)
        arrow.BackgroundTransparency = 1
        arrow.Text = "▼"
        arrow.TextColor3 = self.Theme.TextSecondary
        arrow.Font = self.Font
        arrow.TextSize = 12
        arrow.Parent = dropdown
        arrow.Active = false

        local dropContainer = InstanceNew("Frame")
        dropContainer.Name = "Container"
        dropContainer.Size = UDim2New(1, 0, 0, 0)
        dropContainer.Position = UDim2New(0, 0, 0, 32)
        dropContainer.BackgroundTransparency = 1
        dropContainer.ClipsDescendants = true
        dropContainer.Parent = dropdown
        dropContainer.Active = false

        local expanded = false

        local function createOptions()
            for i, option in pairs(options) do
                local optionBtn = InstanceNew("TextButton")
                optionBtn.Name = "Option"..i
                optionBtn.Size = UDim2New(1, 0, 0, 32)
                optionBtn.Position = UDim2New(0, 0, 0, (i-1) * 32)
                optionBtn.BackgroundColor3 = self.Theme.ElementHover
                optionBtn.Text = ""
                optionBtn.Parent = dropContainer
                optionBtn.Visible = false
                optionBtn.Active = true
                optionBtn.AutoButtonColor = false

                if self.RoundedCorners then
                    local optCorner = InstanceNew("UICorner")
                    optCorner.CornerRadius = self.SmallCornerRadius
                    optCorner.Parent = optionBtn
                end

                local optText = InstanceNew("TextLabel")
                optText.Size = UDim2New(1, -24, 1, 0)
                optText.Position = UDim2New(0, 12, 0, 0)
                optText.BackgroundTransparency = 1
                optText.Text = option
                optText.TextColor3 = self.Theme.Text
                optText.Font = self.Font
                optText.TextSize = 13
                optText.TextXAlignment = Enum.TextXAlignment.Left
                optText.Parent = optionBtn
                optText.Active = false

                optionBtn.MouseButton1Click:Connect(function()
                    selected = option
                    dropLabel.Text = text..": "..selected
                    if callback then
                        pcall(function() callback(selected) end)
                    end
                    updateDropdown()
                end)

                optionBtn.MouseEnter:Connect(function()
                    TweenService:Create(optionBtn, TweenInfo.new(0.15), {BackgroundColor3 = self.Theme.Element}):Play()
                end)

                optionBtn.MouseLeave:Connect(function()
                    TweenService:Create(optionBtn, TweenInfo.new(0.15), {BackgroundColor3 = self.Theme.ElementHover}):Play()
                end)
            end
        end

        local function updateDropdown()
            expanded = not expanded
            
            if expanded then
                if #dropContainer:GetChildren() == 0 then
                    createOptions()
                end

                for _, child in pairs(dropContainer:GetChildren()) do
                    child.Visible = true
                end

                local targetSize = UDim2New(1, 0, 0, 32 + (#options * 32))
                TweenService:Create(dropdown, TweenInfo.new(0.2), {Size = targetSize}):Play()
                arrow.Text = "▲"
            else
                for _, child in pairs(dropContainer:GetChildren()) do
                    child.Visible = false
                end

                TweenService:Create(dropdown, TweenInfo.new(0.2), {Size = UDim2New(1, 0, 0, 32)}):Play()
                arrow.Text = "▼"
            end
        end

        dropdown.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                updateDropdown()
            end
        end)

        self:UpdateSectionSize(section.Parent)
        return dropdown
    end

    -- Color Picker
    function Library:AddColorPicker(section, text, default, callback)
        if not section then return nil end
        
        local colorPicker = InstanceNew("Frame")
        colorPicker.Name = text.."ColorPicker"
        colorPicker.Size = UDim2New(1, 0, 0, 32)
        colorPicker.Position = UDim2New(0, 0, 0, self:GetElementsInSection(section) * 37)
        colorPicker.BackgroundColor3 = self.Theme.Element
        colorPicker.BackgroundTransparency = 0.5
        colorPicker.Parent = section
        colorPicker.Active = true

        if self.RoundedCorners then
            local pickerCorner = InstanceNew("UICorner")
            pickerCorner.CornerRadius = self.SmallCornerRadius
            pickerCorner.Parent = colorPicker
        end

        local pickerLabel = InstanceNew("TextLabel")
        pickerLabel.Name = "Label"
        pickerLabel.Size = UDim2New(1, -50, 1, 0)
        pickerLabel.Position = UDim2New(0, 12, 0, 0)
        pickerLabel.BackgroundTransparency = 1
        pickerLabel.Text = text
        pickerLabel.TextColor3 = self.Theme.Text
        pickerLabel.Font = self.Font
        pickerLabel.TextSize = 13
        pickerLabel.TextXAlignment = Enum.TextXAlignment.Left
        pickerLabel.Parent = colorPicker
        pickerLabel.Active = false

        local colorDisplay = InstanceNew("Frame")
        colorDisplay.Name = "Color"
        colorDisplay.Size = UDim2New(0, 24, 0, 24)
        colorDisplay.Position = UDim2New(1, -34, 0.5, -12)
        colorDisplay.BackgroundColor3 = default or self.Theme.Accent
        colorDisplay.Parent = colorPicker
        colorDisplay.Active = false

        if self.RoundedCorners then
            local displayCorner = InstanceNew("UICorner")
            displayCorner.CornerRadius = self.SmallCornerRadius
            displayCorner.Parent = colorDisplay
        end

        colorPicker.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local h, s, v = colorDisplay.BackgroundColor3:ToHSV()
                h = (h + 0.1) % 1
                local newColor = FromHSV(h, s, v)
                colorDisplay.BackgroundColor3 = newColor
                if callback then
                    pcall(function() callback(newColor) end)
                end
            end
        end)

        self:UpdateSectionSize(section.Parent)
        return colorPicker
    end

    -- Notification
    function Library:Notify(title, message, duration)
        duration = duration or 3

        local notification = InstanceNew("Frame")
        notification.Name = "Notification"
        notification.Size = UDim2New(1, 0, 0, 0)
        notification.BackgroundColor3 = self.Theme.Surface
        notification.BorderSizePixel = 0
        notification.ClipsDescendants = true
        notification.Parent = self.NotifHolder
        notification.Active = false

        if self.RoundedCorners then
            local notifCorner = InstanceNew("UICorner")
            notifCorner.CornerRadius = self.CornerRadius
            notifCorner.Parent = notification
        end

        local progress = InstanceNew("Frame")
        progress.Name = "Progress"
        progress.Size = UDim2New(1, 0, 0, 2)
        progress.Position = UDim2New(0, 0, 1, -2)
        progress.BackgroundColor3 = self.Theme.Accent
        progress.Parent = notification
        progress.Active = false

        local titleLabel = InstanceNew("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2New(1, -20, 0, 24)
        titleLabel.Position = UDim2New(0, 10, 0, 6)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = StringUpper(title)
        titleLabel.TextColor3 = self.Theme.Accent
        titleLabel.Font = self.Font
        titleLabel.TextSize = 12
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = notification
        titleLabel.Active = false

        local messageLabel = InstanceNew("TextLabel")
        messageLabel.Name = "Message"
        messageLabel.Size = UDim2New(1, -20, 0, 0)
        messageLabel.Position = UDim2New(0, 10, 0, 30)
        messageLabel.BackgroundTransparency = 1
        messageLabel.Text = message
        messageLabel.TextColor3 = self.Theme.Text
        messageLabel.Font = self.Font
        messageLabel.TextSize = 13
        messageLabel.TextWrapped = true
        messageLabel.TextXAlignment = Enum.TextXAlignment.Left
        messageLabel.TextYAlignment = Enum.TextYAlignment.Top
        messageLabel.Parent = notification
        messageLabel.Active = false

        local textSize = TextService:GetTextSize(message, 13, self.Font, Vector2New(330, math.huge))
        notification.Size = UDim2New(1, 0, 0, textSize.Y + 40)
        messageLabel.Size = UDim2New(1, -20, 0, textSize.Y)

        notification.Position = UDim2New(0, 0, 0, -notification.Size.Y.Offset)
        
        TweenService:Create(notification, TweenInfo.new(0.3), {
            Position = UDim2New(0, 0, 0, 0)
        }):Play()

        TweenService:Create(progress, TweenInfo.new(duration), {
            Size = UDim2New(0, 0, 0, 2)
        }):Play()

        task.delay(duration, function()
            TweenService:Create(notification, TweenInfo.new(0.3), {
                Position = UDim2New(0, 0, 0, -notification.Size.Y.Offset)
            }):Play()
            task.delay(0.3, function()
                if notification then
                    notification:Destroy()
                end
            end)
        end)
    end

    -- Helper functions
    function Library:GetSectionCount(tab)
        if not tab or not tab.Content then return 0 end
        local count = 0
        for _, child in pairs(tab.Content:GetChildren()) do
            if child:IsA("Frame") and child.Name:match("Section$") then
                count = count + 1
            end
        end
        return count
    end

    function Library:GetElementsInSection(section)
        if not section then return 0 end
        local count = 0
        for _, child in pairs(section:GetChildren()) do
            if child:IsA("TextButton") or 
               child.Name:match("Toggle$") or 
               child.Name:match("Slider$") or 
               child.Name:match("Dropdown$") or 
               child.Name:match("ColorPicker$") then
                count = count + 1
            end
        end
        return count
    end

    function Library:UpdateSectionSize(section)
        if not section then return end
        local elementCount = self:GetElementsInSection(section)
        local newHeight = 48 + (elementCount * 37)
        if section.Parent then
            section.Parent.Size = UDim2New(1, 0, 0, newHeight)
        end
    end

    function Library:Unload()
        if self.Holder then
            self.Holder:Destroy()
        end
        if self.Blur then
            self.Blur:Destroy()
        end
        Library = nil
    end

    -- Initialize
    Library:Initialize()
end

return Library
