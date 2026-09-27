-- DeepHat Cyber-Security Framework v4.0
-- Tema: Cyber-Purple | Foco: Draggable UI & Performance

local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Configurações de Voo
local Flying = false
local CurrentSpeed = 50 
local FlyKey = Enum.KeyCode.F
local Camera = workspace.CurrentCamera

-- Variáveis de Controle de Arrastar (Drag System)
local dragging, dragInput, dragStart, startPos
local MainFrame = nil

-- Definição de Presets
local Presets = {
    {Name = "Stealth (Safe)", Speed = 50, Risk = "Low", Color = Color3.fromRGB(0, 255, 150)},
    {Name = "Balanced", Speed = 120, Risk = "Medium", Color = Color3.fromRGB(255, 200, 0)},
    {Name = "Rage (High Risk)", Speed = 450, Risk = "High", Color = Color3.fromRGB(255, 50, 50)}
}

-- Cores do Tema
local Color_Primary = Color3.fromRGB(130, 0, 255)
local Color_Secondary = Color3.fromRGB(30, 0, 50)
local Color_Accent = Color3.fromRGB(200, 100, 255)

-- [SISTEMA DE ARRASTAR - LÓGICA]
local function Update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

local function OnInputBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end

local function OnInputChanged(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
end

-- [LÓGICA DE VOO]
local function StartFly()
    local Character = Player.Character
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end

    local Connection = RunService.RenderStepped:Connect(function()
        if Flying and Character and RootPart then
            local MoveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then MoveDir = MoveDir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then MoveDir = MoveDir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then MoveDir = MoveDir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then MoveDir = MoveDir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then MoveDir = MoveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then MoveDir = MoveDir - Vector3.new(0, 1, 0) end

            RootPart.Velocity = MoveDir * CurrentSpeed
            RootPart.CFrame = RootPart.CFrame:Lerp(RootPart.CFrame + (MoveDir * (CurrentSpeed/60)), 0.15)
        end
    end)
end

-- [CONSTRUÇÃO DA UI]
local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "DeepHat_GUI"

MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.BackgroundColor3 = Color_Secondary
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

-- Barra de Título (Área de Arrastar)
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", TitleBar)
Title.Text = "DEEPHAT FLY [PRO]"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.TextColor3 = Color_Accent
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- Status e Botões (Mantendo a estrutura anterior)
local StatusFrame = Instance.new("Frame", MainFrame)
StatusFrame.Size = UDim2.new(0.9, 0, 0, 50)
StatusFrame.Position = UDim2.new(0.05, 0, 0, 50)
StatusFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", StatusFrame).CornerRadius = UDim.new(0, 8)

local StatusText = Instance.new("TextLabel", StatusFrame)
StatusText.Text = "MODE: STEALTH\nSPEED: 50\nRISK: LOW"
StatusText.Size = UDim2.new(1, 0, 1, 0)
StatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusText.BackgroundTransparency = 1
StatusText.Font = Enum.Font.GothamSemibold
StatusText.TextSize = 12

-- Botões de Preset
local function CreatePresetBtn(name, index)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.8, 0, 0, 30)
    btn.Position = UDim2.new(0.1, 0, 0, 105 + (index-1)*35)
    btn.BackgroundColor3 = Color_Primary
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        CurrentSpeed = Presets[index].Speed
        StatusText.Text = "MODE: " .. Presets[index].Name:upper() .. "\nSPEED: " .. CurrentSpeed .. "\nRISK: " .. Presets[index].Risk:upper()
        StatusText.TextColor3 = Presets[index].Color
    end)
end

CreatePresetBtn("STEALTH (Safe)", 1)
CreatePresetBtn("BALANCED (Med)", 2)
CreatePresetBtn("RAGE (High)", 3)

-- Botão de Toggle e Self-Destruct
local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Text = "TOGGLE FLY (F)"
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 35)
ToggleBtn.Position = UDim2.new(0.1, 0, 0, 220)
ToggleBtn.BackgroundColor3 = Color_Primary
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

local DestroyBtn = Instance.new("TextButton", MainFrame)
DestroyBtn.Text = "SELF-DESTRUCT"
DestroyBtn.Size = UDim2.new(0.8, 0, 0, 25)
DestroyBtn.Position = UDim2.new(0.1, 0, 0, 265)
DestroyBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
DestroyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DestroyBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", DestroyBtn).CornerRadius = UDim.new(0, 6)

-- [EVENTOS]
-- Conectar o Drag à TitleBar (Para arrastar pela barra de título)
TitleBar.InputBegan:Connect(OnInputBegan)
UserInputService.InputChanged:Connect(OnInputChanged)

-- Toggle Fly
local function ToggleFly()
    Flying = not Flying
    if Flying then
        StartFly()
    else
        -- Parar voo
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == FlyKey then
        ToggleFly()
    end
end)

ToggleBtn.MouseButton1Click:Connect(ToggleFly)
DestroyBtn.MouseButton1Click:Connect(function()
    -- Lógica de destruição rápida
    ScreenGui:Destroy()
end)

print("[DeepHat] V4 Loaded. Drag the TitleBar to move the menu.")
