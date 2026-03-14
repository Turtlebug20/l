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

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new
    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local Vector2New = Vector2.new

    local MathClamp = math.clamp
    local MathFloor = math.floor
    local MathAbs = math.abs
    local MathSin = math.sin
    local MathRad = math.rad
    local MathCos = math.cos

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone
    local TableUnpack = table.unpack

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower
    local StringLen = string.len
    local StringSub = string.sub
    local StringUpper = string.upper

    local InstanceNew = Instance.new

    local RectNew = Rect.new

    Library = {
        Theme = {
            Background = FromRGB(20, 20, 25),
            Surface = FromRGB(30, 30, 35),
            Element = FromRGB(40, 40, 45),
            ElementHover = FromRGB(50, 50, 55),
            ElementSelected = FromRGB(60, 60, 65),
            Text = FromRGB(255, 255, 255),
            TextSecondary = FromRGB(180, 180, 185),
            Accent = FromRGB(100, 150, 255),
            AccentHover = FromRGB(120, 170, 255),
            Danger = FromRGB(255, 80, 80),
            Success = FromRGB(80, 200, 120),
            Warning = FromRGB(255, 200, 80),
            Border = FromRGB(50, 50, 55),
            Shadow = FromRGB(0, 0, 0),
        },

        MenuKeybind = tostring(Enum.KeyCode.RightControl),
        Flags = {},

        Tween = {
            Time = 0.2,
            Style = Enum.EasingStyle.Quad,
            Direction = Enum.EasingDirection.Out
        },

        FadeSpeed = 0.2,

        Folders = {
            Directory = "vast",
            Configs = "vast/Configs",
            Assets = "vast/Assets",
        },

        Images = {
            ["Saturation"] = {"Saturation.png", "https://github.com/sametexe001/images/blob/main/saturation.png?raw=true"},
            ["Value"] = {"Value.png", "https://github.com/sametexe001/images/blob/main/value.png?raw=true"},
            ["Hue"] = {"Hue.png", "https://github.com/sametexe001/images/blob/main/horizontalhue.png?raw=true"},
            ["Checkers"] = {"Checkers.png", "https://github.com/sametexe001/images/blob/main/checkers.png?raw=true"},
            ["Logo"] = {"rbxassetid://138198203269424"}, -- Logo texture
        },

        Pages = {},
        Sections = {},

        Connections = {},
        Threads = {},

        ThemeMap = {},
        ThemeItems = {},

        CopiedColor = nil,

        OpenFrames = {},

        CurrentPage = nil,

        SearchItems = {},

        SetFlags = {},

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,
        Font = nil,
        KeyList = nil,

        Colorpickers = {},
        
        -- Modern UI additions
        BlurEnabled = true,
        MicaEnabled = true,
        RoundedCorners = true,
        CornerRadius = UDim.new(0, 8),
        SmallCornerRadius = UDim.new(0, 4),
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    -- Initialize UI
    function Library:Initialize()
        -- Create holders
        self.Holder = InstanceNew("ScreenGui")
        self.Holder.Name = "VastUILibrary"
        self.Holder.Parent = gethui()
        self.Holder.ResetOnSpawn = false
        self.Holder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        self.Holder.DisplayOrder = 999

        -- Create blur effect if supported
        if self.BlurEnabled then
            local blur = InstanceNew("BlurEffect")
            blur.Name = "UIBlur"
            blur.Size = 0
            blur.Parent = workspace.CurrentCamera or workspace
            self.Blur = blur
        end

        -- Notification holder
        self.NotifHolder = InstanceNew("Frame")
        self.NotifHolder.Name = "NotificationHolder"
        self.NotifHolder.Size = UDim2New(0, 350, 1, -40)
        self.NotifHolder.Position = UDim2New(1, -370, 0, 20)
        self.NotifHolder.BackgroundTransparency = 1
        self.NotifHolder.Parent = self.Holder

        -- Keybind list
        self.KeyList = InstanceNew("Frame")
        self.KeyList.Name = "KeybindList"
        self.KeyList.Size = UDim2New(0, 200, 0, 200)
        self.KeyList.Position = UDim2New(0, 10, 0, 10)
        self.KeyList.BackgroundTransparency = 1
        self.KeyList.Parent = self.Holder
        self.KeyList.Visible = false

        -- Load font
        self.Font = Enum.Font.Gotham
    end

    -- Modern window creation
    function Library:CreateWindow(title, size)
        if not self.Holder then
            self:Initialize()
        end

        local window = {}
        window.__index = window

        -- Main frame with modern design
        local mainFrame = InstanceNew("Frame")
        mainFrame.Name = "Window"
        mainFrame.Size = size or UDim2New(0, 800, 0, 500)
        mainFrame.Position = UDim2New(0.5, -400, 0.5, -250)
        mainFrame.BackgroundColor3 = self.Theme.Background
        mainFrame.BorderSizePixel = 0
        mainFrame.Parent = self.Holder
        
        -- Shadow
        local shadow = InstanceNew("ImageLabel")
        shadow.Name = "Shadow"
        shadow.Size = UDim2New(1, 40, 1, 40)
        shadow.Position = UDim2New(0, -20, 0, -20)
        shadow.BackgroundTransparency = 1
        shadow.Image = "rbxassetid://1316045167" -- Shadow texture
        shadow.ImageColor3 = self.Theme.Shadow
        shadow.ImageTransparency = 0.7
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.SliceCenter = RectNew(10, 10, 10, 10)
        shadow.Parent = mainFrame
        shadow.ZIndex = -1

        -- Modern rounded corners
        if self.RoundedCorners then
            local corner = InstanceNew("UICorner")
            corner.CornerRadius = self.CornerRadius
            corner.Parent = mainFrame
            
            local shadowCorner = InstanceNew("UICorner")
            shadowCorner.CornerRadius = self.CornerRadius + UDimNew(0, 20)
            shadowCorner.Parent = shadow
        end

        -- Title bar
        local titleBar = InstanceNew("Frame")
        titleBar.Name = "TitleBar"
        titleBar.Size = UDim2New(1, 0, 0, 50)
        titleBar.BackgroundColor3 = self.Theme.Surface
        titleBar.BorderSizePixel = 0
        titleBar.Parent = mainFrame

        if self.RoundedCorners then
            local titleCorner = InstanceNew("UICorner")
            titleCorner.CornerRadius = self.CornerRadius
            titleCorner.Parent = titleBar
            
            -- Only round top corners
            local titlePadding = InstanceNew("UIPadding")
            titlePadding.PaddingTop = UDimNew(0, 0)
            titlePadding.PaddingBottom = UDimNew(0, 0)
            titlePadding.PaddingLeft = UDimNew(0, 0)
            titlePadding.PaddingRight = UDimNew(0, 0)
        end

        -- Logo
        local logo = InstanceNew("ImageLabel")
        logo.Name = "Logo"
        logo.Size = UDim2New(0, 32, 0, 32)
        logo.Position = UDim2New(0, 12, 0.5, -16)
        logo.BackgroundTransparency = 1
        logo.Image = self.Images.Logo[1]
        logo.ImageColor3 = self.Theme.Accent
        logo.Parent = titleBar

        -- Title
        local titleLabel = InstanceNew("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2New(0, 200, 1, 0)
        titleLabel.Position = UDim2New(0, 50, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title or "UI Library"
        titleLabel.TextColor3 = self.Theme.Text
        titleLabel.Font = self.Font
        titleLabel.TextSize = 18
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = titleBar

        -- Window controls
        local buttonContainer = InstanceNew("Frame")
        buttonContainer.Name = "WindowControls"
        buttonContainer.Size = UDim2New(0, 100, 1, 0)
        buttonContainer.Position = UDim2New(1, -100, 0, 0)
        buttonContainer.BackgroundTransparency = 1
        buttonContainer.Parent = titleBar

        -- Minimize button
        local minimizeButton = InstanceNew("TextButton")
        minimizeButton.Name = "Minimize"
        minimizeButton.Size = UDim2New(0, 30, 0, 30)
        minimizeButton.Position = UDim2New(0, 20, 0.5, -15)
        minimizeButton.BackgroundColor3 = self.Theme.Element
        minimizeButton.Text = "—"
        minimizeButton.TextColor3 = self.Theme.TextSecondary
        minimizeButton.Font = self.Font
        minimizeButton.TextSize = 20
        minimizeButton.Parent = buttonContainer

        -- Close button
        local closeButton = InstanceNew("TextButton")
        closeButton.Name = "Close"
        closeButton.Size = UDim2New(0, 30, 0, 30)
        closeButton.Position = UDim2New(0, 55, 0.5, -15)
        closeButton.BackgroundColor3 = self.Theme.Element
        closeButton.Text = "×"
        closeButton.TextColor3 = self.Theme.TextSecondary
        closeButton.Font = self.Font
        closeButton.TextSize = 24
        closeButton.Parent = buttonContainer

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
            TweenService:Create(minimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.ElementHover}):Play()
        end)
        
        minimizeButton.MouseLeave:Connect(function()
            TweenService:Create(minimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Element}):Play()
        end)

        closeButton.MouseEnter:Connect(function()
            TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Danger}):Play()
            TweenService:Create(closeButton, TweenInfo.new(0.2), {TextColor3 = self.Theme.Text}):Play()
        end)
        
        closeButton.MouseLeave:Connect(function()
            TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Element}):Play()
            TweenService:Create(closeButton, TweenInfo.new(0.2), {TextColor3 = self.Theme.TextSecondary}):Play()
        end)

        -- Minimize functionality
        local minimized = false
        minimizeButton.MouseButton1Click:Connect(function()
            minimized = not minimized
            local targetSize = minimized and UDim2New(1, 0, 0, 50) or size
            local targetTransparency = minimized and 1 or 0
            
            TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = targetSize}):Play()
            
            for _, child in pairs(mainFrame:GetChildren()) do
                if child ~= titleBar and child ~= shadow then
                    TweenService:Create(child, TweenInfo.new(0.2), {BackgroundTransparency = targetTransparency}):Play()
                end
            end
        end)

        -- Close functionality
        closeButton.MouseButton1Click:Connect(function()
            self:Unload()
        end)

        -- Sidebar
        local sidebar = InstanceNew("Frame")
        sidebar.Name = "Sidebar"
        sidebar.Size = UDim2New(0, 200, 1, -50)
        sidebar.Position = UDim2New(0, 0, 0, 50)
        sidebar.BackgroundColor3 = self.Theme.Surface
        sidebar.BorderSizePixel = 0
        sidebar.Parent = mainFrame

        if self.RoundedCorners then
            local sidebarCorner = InstanceNew("UICorner")
            sidebarCorner.CornerRadius = self.CornerRadius
            sidebarCorner.Parent = sidebar
            
            -- Only round top-left and bottom-left corners
            local sidebarPadding = InstanceNew("UIPadding")
            sidebarPadding.PaddingRight = UDimNew(0, -self.CornerRadius.Offset)
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
        sidebarTitle.TextSize = 12
        sidebarTitle.TextXAlignment = Enum.TextXAlignment.Left
        sidebarTitle.Parent = sidebar

        -- Tab container (sidebar buttons)
        local tabContainer = InstanceNew("Frame")
        tabContainer.Name = "TabContainer"
        tabContainer.Size = UDim2New(1, 0, 1, -60)
        tabContainer.Position = UDim2New(0, 0, 0, 50)
        tabContainer.BackgroundTransparency = 1
        tabContainer.Parent = sidebar

        -- Content area
        local contentArea = InstanceNew("Frame")
        contentArea.Name = "ContentArea"
        contentArea.Size = UDim2New(1, -200, 1, -50)
        contentArea.Position = UDim2New(0, 200, 0, 50)
        contentArea.BackgroundColor3 = self.Theme.Background
        contentArea.BorderSizePixel = 0
        contentArea.Parent = mainFrame

        if self.RoundedCorners then
            local contentCorner = InstanceNew("UICorner")
            contentCorner.CornerRadius = self.CornerRadius
            contentCorner.Parent = contentArea
        end

        -- Dragging
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
                mainFrame.Position = UDim2New(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)

        -- Window methods
        window.MainFrame = mainFrame
        window.Sidebar = sidebar
        window.TabContainer = tabContainer
        window.ContentArea = contentArea
        window.Tabs = {}
        window.Minimized = false

        function window:AddTab(name, icon)
            local tabButton = InstanceNew("TextButton")
            tabButton.Name = name.."Tab"
            tabButton.Size = UDim2New(1, -20, 0, 40)
            tabButton.Position = UDim2New(0, 10, 0, (#self.Tabs * 45))
            tabButton.BackgroundColor3 = Library.Theme.Element
            tabButton.BackgroundTransparency = 0.8
            tabButton.Text = ""
            tabButton.Parent = tabContainer

            -- Button content
            local buttonText = InstanceNew("TextLabel")
            buttonText.Name = "Text"
            buttonText.Size = UDim2New(1, -10, 1, 0)
            buttonText.Position = UDim2New(0, 10, 0, 0)
            buttonText.BackgroundTransparency = 1
            buttonText.Text = name
            buttonText.TextColor3 = Library.Theme.Text
            buttonText.Font = Library.Font
            buttonText.TextSize = 14
            buttonText.TextXAlignment = Enum.TextXAlignment.Left
            buttonText.Parent = tabButton

            if icon then
                -- Add icon if provided
            end

            if Library.RoundedCorners then
                local btnCorner = InstanceNew("UICorner")
                btnCorner.CornerRadius = Library.SmallCornerRadius
                btnCorner.Parent = tabButton
            end

            local tabContent = InstanceNew("ScrollingFrame")
            tabContent.Name = name.."Content"
            tabContent.Size = UDim2New(1, -30, 1, -20)
            tabContent.Position = UDim2New(0, 15, 0, 10)
            tabContent.BackgroundTransparency = 1
            tabContent.BorderSizePixel = 0
            tabContent.ScrollBarThickness = 4
            tabContent.ScrollBarImageColor3 = Library.Theme.ElementHover
            tabContent.CanvasSize = UDim2New(0, 0, 0, 0)
            tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
            tabContent.Visible = false
            tabContent.Parent = contentArea

            -- Selection indicator
            local indicator = InstanceNew("Frame")
            indicator.Name = "Indicator"
            indicator.Size = UDim2New(0, 3, 1, -10)
            indicator.Position = UDim2New(0, 0, 0.5, 0)
            indicator.BackgroundColor3 = Library.Theme.Accent
            indicator.BorderSizePixel = 0
            indicator.Visible = false
            indicator.Parent = tabButton

            if Library.RoundedCorners then
                local indCorner = InstanceNew("UICorner")
                indCorner.CornerRadius = UDimNew(0, 2)
                indCorner.Parent = indicator
            end

            if #self.Tabs == 0 then
                tabContent.Visible = true
                tabButton.BackgroundColor3 = Library.Theme.ElementHover
                tabButton.BackgroundTransparency = 0
                indicator.Visible = true
                Library.CurrentPage = tabContent
            end

            tabButton.MouseButton1Click:Connect(function()
                for _, otherTab in pairs(self.Tabs) do
                    otherTab.Content.Visible = false
                    TweenService:Create(otherTab.Button, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.Element, BackgroundTransparency = 0.8}):Play()
                    if otherTab.Indicator then
                        otherTab.Indicator.Visible = false
                    end
                end

                TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.ElementHover, BackgroundTransparency = 0}):Play()
                indicator.Visible = true
                tabContent.Visible = true
                Library.CurrentPage = tabContent
            end)

            -- Hover effect
            tabButton.MouseEnter:Connect(function()
                if tabContent.Visible then return end
                TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.ElementHover, BackgroundTransparency = 0.3}):Play()
            end)

            tabButton.MouseLeave:Connect(function()
                if tabContent.Visible then return end
                TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.Element, BackgroundTransparency = 0.8}):Play()
            end)

            local tab = {
                Name = name,
                Button = tabButton,
                Content = tabContent,
                Indicator = indicator
            }

            TableInsert(self.Tabs, tab)
            return tab
        end

        return window
    end

    -- Modern section creation
    function Library:AddSection(tab, title)
        local section = InstanceNew("Frame")
        section.Name = title.."Section"
        section.Size = UDim2New(1, 0, 0, 100)
        section.Position = UDim2New(0, 0, 0, self:GetSectionCount(tab) * 120)
        section.BackgroundColor3 = self.Theme.Surface
        section.BorderSizePixel = 0
        section.Parent = tab.Content

        if self.RoundedCorners then
            local sectionCorner = InstanceNew("UICorner")
            sectionCorner.CornerRadius = self.CornerRadius
            sectionCorner.Parent = section
        end

        -- Section header
        local header = InstanceNew("Frame")
        header.Name = "Header"
        header.Size = UDim2New(1, 0, 0, 40)
        header.BackgroundColor3 = self.Theme.Element
        header.BorderSizePixel = 0
        header.Parent = section

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
        titleLabel.TextColor3 = self.Theme.Text
        titleLabel.Font = self.Font
        titleLabel.TextSize = 14
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = header

        -- Content container
        local content = InstanceNew("Frame")
        content.Name = "Content"
        content.Size = UDim2New(1, -20, 1, -50)
        content.Position = UDim2New(0, 10, 0, 45)
        content.BackgroundTransparency = 1
        content.Parent = section

        -- Update section size based on content
        local function updateSectionSize()
            local elementCount = self:GetElementsInSection(content)
            local newHeight = 50 + (elementCount * 35)
            section.Size = UDim2New(1, 0, 0, newHeight)
        end

        return content, updateSectionSize
    end

    -- Modern button
    function Library:AddButton(section, text, callback, icon)
        local button = InstanceNew("TextButton")
        button.Name = text.."Button"
        button.Size = UDim2New(1, 0, 0, 30)
        button.Position = UDim2New(0, 0, 0, self:GetElementsInSection(section) * 35)
        button.BackgroundColor3 = self.Theme.Element
        button.Text = ""
        button.Parent = section

        if self.RoundedCorners then
            local btnCorner = InstanceNew("UICorner")
            btnCorner.CornerRadius = self.SmallCornerRadius
            btnCorner.Parent = button
        end

        local buttonText = InstanceNew("TextLabel")
        buttonText.Name = "Text"
        buttonText.Size = UDim2New(1, -10, 1, 0)
        buttonText.Position = UDim2New(0, 10, 0, 0)
        buttonText.BackgroundTransparency = 1
        buttonText.Text = text
        buttonText.TextColor3 = self.Theme.Text
        buttonText.Font = self.Font
        buttonText.TextSize = 13
        buttonText.TextXAlignment = Enum.TextXAlignment.Left
        buttonText.Parent = button

        if icon then
            -- Add icon if provided
        end

        button.MouseButton1Click:Connect(function()
            if callback then
                local success, err = pcall(callback)
                if not success then
                    warn("Button callback error:", err)
                end
            end
        end)

        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.ElementHover}):Play()
        end)

        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Element}):Play()
        end)

        return button
    end

    -- Modern toggle
    function Library:AddToggle(section, text, default, callback)
        local toggle = InstanceNew("Frame")
        toggle.Name = text.."Toggle"
        toggle.Size = UDim2New(1, 0, 0, 30)
        toggle.Position = UDim2New(0, 0, 0, self:GetElementsInSection(section) * 35)
        toggle.BackgroundColor3 = self.Theme.Element
        toggle.BackgroundTransparency = 0.5
        toggle.Parent = section

        if self.RoundedCorners then
            local toggleCorner = InstanceNew("UICorner")
            toggleCorner.CornerRadius = self.SmallCornerRadius
            toggleCorner.Parent = toggle
        end

        local toggleLabel = InstanceNew("TextLabel")
        toggleLabel.Name = "Label"
        toggleLabel.Size = UDim2New(1, -60, 1, 0)
        toggleLabel.Position = UDim2New(0, 10, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = text
        toggleLabel.TextColor3 = self.Theme.Text
        toggleLabel.Font = self.Font
        toggleLabel.TextSize = 13
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggle

        local toggleButton = InstanceNew("Frame")
        toggleButton.Name = "ToggleButton"
        toggleButton.Size = UDim2New(0, 40, 0, 20)
        toggleButton.Position = UDim2New(1, -45, 0.5, -10)
        toggleButton.BackgroundColor3 = self.Theme.ElementHover
        toggleButton.Parent = toggle

        if self.RoundedCorners then
            local btnCorner = InstanceNew("UICorner")
            btnCorner.CornerRadius = UDimNew(0, 10)
            btnCorner.Parent = toggleButton
        end

        local toggleIndicator = InstanceNew("Frame")
        toggleIndicator.Name = "Indicator"
        toggleIndicator.Size = UDim2New(0, 16, 0, 16)
        toggleIndicator.Position = UDim2New(0, 2, 0.5, -8)
        toggleIndicator.BackgroundColor3 = self.Theme.Text
        toggleIndicator.Parent = toggleButton

        if self.RoundedCorners then
            local indCorner = InstanceNew("UICorner")
            indCorner.CornerRadius = UDimNew(1, 0)
            indCorner.Parent = toggleIndicator
        end

        local state = default or false
        if state then
            toggleButton.BackgroundColor3 = self.Theme.Accent
            toggleIndicator.Position = UDim2New(0, 22, 0.5, -8)
        end

        local function updateToggle()
            state = not state
            if state then
                TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Accent}):Play()
                TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {Position = UDim2New(0, 22, 0.5, -8)}):Play()
            else
                TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.ElementHover}):Play()
                TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {Position = UDim2New(0, 2, 0.5, -8)}):Play()
            end

            if callback then
                local success, err = pcall(function() callback(state) end)
                if not success then
                    warn("Toggle callback error:", err)
                end
            end
        end

        toggle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                updateToggle()
            end
        end)

        return toggle
    end

    -- Modern slider
    function Library:AddSlider(section, text, min, max, default, callback)
        local slider = InstanceNew("Frame")
        slider.Name = text.."Slider"
        slider.Size = UDim2New(1, 0, 0, 40)
        slider.Position = UDim2New(0, 0, 0, self:GetElementsInSection(section) * 40)
        slider.BackgroundTransparency = 1
        slider.Parent = section

        local sliderLabel = InstanceNew("TextLabel")
        sliderLabel.Name = "Label"
        sliderLabel.Size = UDim2New(0, 100, 0, 20)
        sliderLabel.Position = UDim2New(0, 0, 0, 0)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = text
        sliderLabel.TextColor3 = self.Theme.Text
        sliderLabel.Font = self.Font
        sliderLabel.TextSize = 13
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = slider

        local valueLabel = InstanceNew("TextLabel")
        valueLabel.Name = "Value"
        valueLabel.Size = UDim2New(0, 50, 0, 20)
        valueLabel.Position = UDim2New(1, -50, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default or min)
        valueLabel.TextColor3 = self.Theme.Accent
        valueLabel.Font = self.Font
        valueLabel.TextSize = 13
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = slider

        local sliderBar = InstanceNew("Frame")
        sliderBar.Name = "Bar"
        sliderBar.Size = UDim2New(1, 0, 0, 4)
        sliderBar.Position = UDim2New(0, 0, 0, 30)
        sliderBar.BackgroundColor3 = self.Theme.Element
        sliderBar.Parent = slider

        if self.RoundedCorners then
            local barCorner = InstanceNew("UICorner")
            barCorner.CornerRadius = UDimNew(0, 2)
            barCorner.Parent = sliderBar
        end

        local sliderFill = InstanceNew("Frame")
        sliderFill.Name = "Fill"
        sliderFill.Size = UDim2New((default - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = self.Theme.Accent
        sliderFill.Parent = sliderBar

        if self.RoundedCorners then
            local fillCorner = InstanceNew("UICorner")
            fillCorner.CornerRadius = UDimNew(0, 2)
            fillCorner.Parent = sliderFill
        end

        local sliderButton = InstanceNew("TextButton")
        sliderButton.Name = "Button"
        sliderButton.Size = UDim2New(1, 0, 1, 0)
        sliderButton.BackgroundTransparency = 1
        sliderButton.Text = ""
        sliderButton.Parent = sliderBar

        local value = default or min

        local function updateSlider(input)
            local pos = UDim2New(0, MathClamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X), 0.5, -2)
            local percent = pos.X.Offset / sliderBar.AbsoluteSize.X
            value = min + (percent * (max - min))
            value = MathFloor(value * 100) / 100
            
            sliderFill.Size = UDim2New(percent, 0, 1, 0)
            valueLabel.Text = tostring(value)

            if callback then
                callback(value)
            end
        end

        sliderButton.MouseButton1Down:Connect(function()
            local connection
            connection = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    connection:Disconnect()
                end
            end)
        end)

        return slider
    end

    -- Modern dropdown
    function Library:AddDropdown(section, text, options, default, callback)
        local dropdown = InstanceNew("Frame")
        dropdown.Name = text.."Dropdown"
        dropdown.Size = UDim2New(1, 0, 0, 30)
        dropdown.Position = UDim2New(0, 0, 0, self:GetElementsInSection(section) * 35)
        dropdown.BackgroundColor3 = self.Theme.Element
        dropdown.BackgroundTransparency = 0.5
        dropdown.Parent = section
        dropdown.ClipsDescendants = true

        if self.RoundedCorners then
            local dropCorner = InstanceNew("UICorner")
            dropCorner.CornerRadius = self.SmallCornerRadius
            dropCorner.Parent = dropdown
        end

        local dropLabel = InstanceNew("TextLabel")
        dropLabel.Name = "Label"
        dropLabel.Size = UDim2New(1, -30, 1, 0)
        dropLabel.Position = UDim2New(0, 10, 0, 0)
        dropLabel.BackgroundTransparency = 1
        dropLabel.Text = text..": "..(default or options[1] or "None")
        dropLabel.TextColor3 = self.Theme.Text
        dropLabel.Font = self.Font
        dropLabel.TextSize = 13
        dropLabel.TextXAlignment = Enum.TextXAlignment.Left
        dropLabel.Parent = dropdown

        local arrow = InstanceNew("TextLabel")
        arrow.Name = "Arrow"
        arrow.Size = UDim2New(0, 20, 1, 0)
        arrow.Position = UDim2New(1, -25, 0, 0)
        arrow.BackgroundTransparency = 1
        arrow.Text = "▼"
        arrow.TextColor3 = self.Theme.TextSecondary
        arrow.Font = self.Font
        arrow.TextSize = 12
        arrow.Parent = dropdown

        local dropContainer = InstanceNew("Frame")
        dropContainer.Name = "Container"
        dropContainer.Size = UDim2New(1, 0, 0, 0)
        dropContainer.Position = UDim2New(0, 0, 0, 30)
        dropContainer.BackgroundTransparency = 1
        dropContainer.Parent = dropdown
        dropContainer.Visible = false

        local expanded = false

        local function updateDropdown()
            expanded = not expanded
            
            local targetSize = expanded and UDim2New(1, 0, 0, 30 + (#options * 30)) or UDim2New(1, 0, 0, 30)
            local targetArrow = expanded and "▲" or "▼"
            
            TweenService:Create(dropdown, TweenInfo.new(0.2), {Size = targetSize}):Play()
            arrow.Text = targetArrow
            
            if expanded then
                dropContainer.Visible = true
                for i, option in pairs(options) do
                    if not dropContainer:FindFirstChild("Option"..i) then
                        local optionBtn = InstanceNew("TextButton")
                        optionBtn.Name = "Option"..i
                        optionBtn.Size = UDim2New(1, 0, 0, 30)
                        optionBtn.Position = UDim2New(0, 0, 0, (i-1) * 30)
                        optionBtn.BackgroundColor3 = self.Theme.ElementHover
                        optionBtn.Text = ""
                        optionBtn.Parent = dropContainer

                        if self.RoundedCorners then
                            local optCorner = InstanceNew("UICorner")
                            optCorner.CornerRadius = self.SmallCornerRadius
                            optCorner.Parent = optionBtn
                        end

                        local optText = InstanceNew("TextLabel")
                        optText.Size = UDim2New(1, -10, 1, 0)
                        optText.Position = UDim2New(0, 10, 0, 0)
                        optText.BackgroundTransparency = 1
                        optText.Text = option
                        optText.TextColor3 = self.Theme.Text
                        optText.Font = self.Font
                        optText.TextSize = 13
                        optText.TextXAlignment = Enum.TextXAlignment.Left
                        optText.Parent = optionBtn

                        optionBtn.MouseButton1Click:Connect(function()
                            dropLabel.Text = text..": "..option
                            if callback then
                                callback(option)
                            end
                            updateDropdown()
                        end)

                        optionBtn.MouseEnter:Connect(function()
                            TweenService:Create(optionBtn, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Element}):Play()
                        end)

                        optionBtn.MouseLeave:Connect(function()
                            TweenService:Create(optionBtn, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.ElementHover}):Play()
                        end)
                    end
                end
            else
                dropContainer.Visible = false
            end
        end

        dropdown.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                updateDropdown()
            end
        end)

        return dropdown
    end

    -- Modern color picker
    function Library:AddColorPicker(section, text, default, callback)
        local colorPicker = InstanceNew("Frame")
        colorPicker.Name = text.."ColorPicker"
        colorPicker.Size = UDim2New(1, 0, 0, 30)
        colorPicker.Position = UDim2New(0, 0, 0, self:GetElementsInSection(section) * 35)
        colorPicker.BackgroundColor3 = self.Theme.Element
        colorPicker.BackgroundTransparency = 0.5
        colorPicker.Parent = section

        if self.RoundedCorners then
            local pickerCorner = InstanceNew("UICorner")
            pickerCorner.CornerRadius = self.SmallCornerRadius
            pickerCorner.Parent = colorPicker
        end

        local pickerLabel = InstanceNew("TextLabel")
        pickerLabel.Name = "Label"
        pickerLabel.Size = UDim2New(1, -40, 1, 0)
        pickerLabel.Position = UDim2New(0, 10, 0, 0)
        pickerLabel.BackgroundTransparency = 1
        pickerLabel.Text = text
        pickerLabel.TextColor3 = self.Theme.Text
        pickerLabel.Font = self.Font
        pickerLabel.TextSize = 13
        pickerLabel.TextXAlignment = Enum.TextXAlignment.Left
        pickerLabel.Parent = colorPicker

        local colorDisplay = InstanceNew("Frame")
        colorDisplay.Name = "Color"
        colorDisplay.Size = UDim2New(0, 20, 0, 20)
        colorDisplay.Position = UDim2New(1, -25, 0.5, -10)
        colorDisplay.BackgroundColor3 = default or self.Theme.Accent
        colorDisplay.Parent = colorPicker

        if self.RoundedCorners then
            local displayCorner = InstanceNew("UICorner")
            displayCorner.CornerRadius = self.SmallCornerRadius
            displayCorner.Parent = colorDisplay
        end

        -- Simple color picker popup (you can expand this)
        colorPicker.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                -- Create color picker popup here
                -- For now, just cycle through colors
                local h, s, v = colorDisplay.BackgroundColor3:ToHSV()
                h = (h + 0.1) % 1
                local newColor = FromHSV(h, s, v)
                colorDisplay.BackgroundColor3 = newColor
                if callback then
                    callback(newColor)
                end
            end
        end)

        return colorPicker
    end

    -- Notification system
    function Library:Notify(title, message, duration)
        duration = duration or 5

        local notification = InstanceNew("Frame")
        notification.Name = "Notification"
        notification.Size = UDim2New(1, 0, 0, 0)
        notification.BackgroundColor3 = self.Theme.Surface
        notification.BorderSizePixel = 0
        notification.Parent = self.NotifHolder
        notification.ClipsDescendants = true

        if self.RoundedCorners then
            local notifCorner = InstanceNew("UICorner")
            notifCorner.CornerRadius = self.CornerRadius
            notifCorner.Parent = notification
        end

        -- Progress bar
        local progress = InstanceNew("Frame")
        progress.Name = "Progress"
        progress.Size = UDim2New(1, 0, 0, 2)
        progress.Position = UDim2New(0, 0, 1, -2)
        progress.BackgroundColor3 = self.Theme.Accent
        progress.Parent = notification

        -- Content
        local titleLabel = InstanceNew("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2New(1, -20, 0, 25)
        titleLabel.Position = UDim2New(0, 10, 0, 5)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = StringUpper(title)
        titleLabel.TextColor3 = self.Theme.Accent
        titleLabel.Font = self.Font
        titleLabel.TextSize = 13
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = notification

        local messageLabel = InstanceNew("TextLabel")
        messageLabel.Name = "Message"
        messageLabel.Size = UDim2New(1, -20, 0, 40)
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

        -- Calculate height
        local textSize = TextService:GetTextSize(message, 13, self.Font, Vector2New(330, math.huge))
        notification.Size = UDim2New(1, 0, 0, textSize.Y + 40)
        messageLabel.Size = UDim2New(1, -20, 0, textSize.Y)

        -- Animate in
        notification.Position = UDim2New(0, 0, 0, -notification.Size.Y.Offset)
        TweenService:Create(notification, TweenInfo.new(0.3), {Position = UDim2New(0, 0, 0, 0)}):Play()

        -- Progress bar animation
        TweenService:Create(progress, TweenInfo.new(duration), {Size = UDim2New(0, 0, 0, 2)}):Play()

        -- Auto remove
        task.delay(duration, function()
            TweenService:Create(notification, TweenInfo.new(0.3), {Position = UDim2New(0, 0, 0, -notification.Size.Y.Offset)}):Play()
            task.delay(0.3, function()
                notification:Destroy()
            end)
        end)
    end

    -- Helper functions
    function Library:GetSectionCount(tab)
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

    function Library:GetElementsInSection(section)
        local count = 0
        for _, child in pairs(section:GetChildren()) do
            if child:IsA("TextButton") or child.Name:match("Toggle$") or child.Name:match("Slider$") or child.Name:match("Dropdown$") or child.Name:match("ColorPicker$") then
                count = count + 1
            end
        end
        return count
    end

    -- Unload function
    function Library:Unload()
        if self.Holder then
            self.Holder:Destroy()
        end
        if self.Blur then
            self.Blur:Destroy()
        end
        Library = nil
    end

    -- Initialize on creation
    Library:Initialize()
end

-- Return the library
return Library
