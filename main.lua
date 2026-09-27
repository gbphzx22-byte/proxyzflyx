-- DeepHat Ultimate - SAFE START VERSION
-- Se não abrir, verifique o console do seu executor

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Variáveis de Controle
local Flying = false
local SpeedActive = false
local WalkSpeedValue = 16
local FlySpeedValue = 50
local Camera = workspace.CurrentCamera

-- Variáveis de Arrastar
local dragging, dragStart, startPos
local MainFrame = nil

-- Cores
local Color_Bg = Color3.fromRGB(20, 15, 30)
local Color_Accent = Color3.fromRGB(130, 0, 255)
local Color_Secondary = Color3.fromRGB(35, 25, 50)
local Color_Text = Color3.fromRGB(255, 255, 255)
local Color_Danger = Color3.fromRGB(255, 50, 50)

-- [LÓGICA DE MOVIMENTO]
local function UpdateMovement()
    local Character = Player.Character
    if not Character then return end
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    local Hum = Character:FindFirstChild("Humanoid")
    if not RootPart or not Hum then return end

    -- WalkSpeed
    if SpeedActive then
        Hum.WalkSpeed = WalkSpeedValue
    else
        Hum.WalkSpeed = 16
    end

    -- Fly
    if Flying then
        local MoveDir = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then MoveDir = MoveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then MoveDir = MoveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then MoveDir = MoveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then MoveDir = MoveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then MoveDir = MoveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then MoveDir = MoveDir - Vector3.new(0, 1, 0) end

        RootPart.Velocity = MoveDir * FlySpeedValue
        RootPart.CFrame = RootPart.CFrame:Lerp(RootPart.CFrame + (MoveDir * (FlySpeedValue/60)), 0.15)
    end
end

RunService.RenderStepped:Connect(UpdateMovement)

-- [CONSTRUÇÃO DA UI]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeepHat_Ultimate_V10"
ScreenGui.ResetOnSpawn = false -- IMPORTITO: Não some quando você morre
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 380)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -190)
MainFrame.BackgroundColor3 = Color_Bg
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 10 -- Garante que fica na frente de tudo

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 6)

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color_Secondary
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Text = "DEEPHAT // ULTIMATE"
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.TextColor3 = Color_Accent
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local ScrollContainer = Instance.new("Frame", MainFrame)
ScrollContainer.Size = UDim2.new(1, 0, 1, -130)
ScrollContainer.Position = UDim2.new(0, 0, 0, 45)
ScrollContainer.BackgroundTransparency = 1

-- Funções de UI
local function CreateCommandButton(name, pos, color, callback)
    local btn = Instance.new("TextButton", ScrollContainer)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color_Text
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(callback)
end

local function CreateValueInput(name, pos, callback)
    local label = Instance.new("TextLabel", ScrollContainer)
    label.Text = name
    label.Size = UDim2.new(0.9, 0, 0, 15)
    label.Position = pos
    label.TextColor3 = Color_Accent
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left

    local input = Instance.new("TextBox", ScrollContainer)
    input.Size = UDim2.new(0.9, 0, 0, 30)
    input.Position = pos + UDim2.new(0, 0, 0, 15)
    input.BackgroundColor3 = Color_Secondary
    input.TextColor3 = Color_Text
    input.PlaceholderText = "Value (0-1000)"
    input.Text = ""
    input.Font = Enum.Font.Gotham
    input.TextSize = 14
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 4)

    local apply = Instance.new("TextButton", ScrollContainer)
    apply.Size = UDim2.new(0.9, 0, 0, 25)
    apply.Position = pos + UDim2.new(0, 0, 0, 45)
    apply.BackgroundColor3 = Color_Secondary
    apply.TextColor3 = Color_Text
    apply.Text = "APPLY"
    apply.Font = Enum.Font.GothamBold
    apply.TextSize = 12
    Instance.new("UICorner", apply).CornerRadius = UDim.new(0, 4)

    apply.MouseButton1Click:Connect(function()
        local val = tonumber(input.Text)
        if val then callback(val) end
    end)
end

-- [BOTÕES]
CreateCommandButton("TOGGLE FLY (F)", UDim2.new(0.05, 0, 0, 10), Color_Accent, function()
    Flying = not Flying
end)

CreateValueInput("FLY SPEED", UDim2.new(0.05, 0, 0, 55), function(val)
    FlySpeedValue = math.clamp(val, 0, 1000)
end)

CreateCommandButton("TOGGLE SPEED", UDim2.new(0.05, 0, 0, 120), Color_Accent, function()
    SpeedActive = not SpeedActive
end)

CreateValueInput("WALK SPEED", UDim2.new(0.05, 0, 0, 165), function(val)
    WalkSpeedValue = math.clamp(val, 0, 1000)
end)

local DestroyBtn = Instance.new("TextButton", MainFrame)
DestroyBtn.Text = "PURGE SYSTEM"
DestroyBtn.Size = UDim2.new(0.9, 0, 0, 35)
DestroyBtn.Position = UDim2.new(0.05, 0, 1, -40)
DestroyBtn.BackgroundColor3 = Color_Danger
DestroyBtn.TextColor3 = Color_Text
DestroyBtn.Font = Enum.Font.GothamBold
DestroyBtn.TextSize = 14
Instance.new("UICorner", DestroyBtn).CornerRadius = UDim.new(0, 4)

-- [SISTEMA DE ARRASTAR]
TitleBar = Header
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- [EVENTOS FINAIS]
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F then
        Flying = not Flying
    end
end)

DestroyBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("[DeepHat] V10 SAFE START: GUI Loaded Successfully.")
