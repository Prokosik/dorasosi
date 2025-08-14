-- Загружаем Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Создаем окно
local Window = Rayfield:CreateWindow({
    Name = "PvP Utility",
    LoadingTitle = "Загрузка функций...",
    LoadingSubtitle = "Dorasosal>?",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "PvPUtil",
        FileName = "Settings"
    }
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local Root = Char:WaitForChild("HumanoidRootPart")

------------------------------------------------
-- Спиды
------------------------------------------------
local SpeedEnabled = false
local SpeedPower = 30

local function velocityBoost()
    if not SpeedEnabled then return end
    local moveDir = Hum.MoveDirection
    if moveDir.Magnitude > 0 then
        Root.Velocity = Vector3.new(
            moveDir.X * SpeedPower,
            Root.Velocity.Y * 0.9,
            moveDir.Z * SpeedPower
        )
    end
end

RunService.Heartbeat:Connect(velocityBoost)

LP.CharacterAdded:Connect(function(newChar)
    Char = newChar
    Hum = newChar:WaitForChild("Humanoid")
    Root = newChar:WaitForChild("HumanoidRootPart")
    SpeedEnabled = false
end)

------------------------------------------------
-- Хитбоксы
------------------------------------------------
local HeadSize = 25
local HitboxEnabled = false
local Transparency = 0.95
local Friends = {}

RunService.RenderStepped:Connect(function()
    if HitboxEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(HeadSize, HeadSize, HeadSize)
                    hrp.Transparency = Transparency
                    hrp.BrickColor = BrickColor.new("White")
                    hrp.Material = Enum.Material.Neon
                    hrp.CanCollide = false
                end
            end
        end
    end
end)

------------------------------------------------
-- Ноуклип
------------------------------------------------
local NoclipEnabled = false

RunService.Stepped:Connect(function()
    if LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not NoclipEnabled
            end
        end
    end
end)

------------------------------------------------
-- Флай (только вверх)
------------------------------------------------
local FlyUpEnabled = false
local FlyUpSpeed = 5

RunService.Heartbeat:Connect(function()
    if FlyUpEnabled and Root then
        Root.CFrame = Root.CFrame + Vector3.new(0, FlyUpSpeed * RunService.Heartbeat:Wait(), 0)
    end
end)

------------------------------------------------
-- Freeze Self
------------------------------------------------
local FreezeEnabled = false
local FreezePosition

RunService.Heartbeat:Connect(function()
    if FreezeEnabled and Root then
        Root.CFrame = FreezePosition
        Root.Velocity = Vector3.new(0, 0, 0)
    end
end)

------------------------------------------------
-- Бинды
------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Z then
        SpeedEnabled = not SpeedEnabled
    elseif input.KeyCode == Enum.KeyCode.N then
        NoclipEnabled = not NoclipEnabled
    elseif input.KeyCode == Enum.KeyCode.X then
        FlyUpEnabled = not FlyUpEnabled
    elseif input.KeyCode == Enum.KeyCode.P then
        FreezeEnabled = not FreezeEnabled
        if FreezeEnabled and Root then
            FreezePosition = Root.CFrame
        end
    end
end)

------------------------------------------------
-- Rayfield GUI
------------------------------------------------
local TabMain = Window:CreateTab("Главное", 4483362458)

-- Спиды
TabMain:CreateToggle({
    Name = "Спидхак (Z)",
    CurrentValue = false,
    Callback = function(Value)
        SpeedEnabled = Value
    end
})

TabMain:CreateSlider({
    Name = "Сила спида",
    Range = {10, 50},
    Increment = 1,
    Suffix = "Скорость",
    CurrentValue = SpeedPower,
    Callback = function(Value)
        SpeedPower = Value
    end
})

-- Хитбоксы
TabMain:CreateToggle({
    Name = "Хитбоксы",
    CurrentValue = false,
    Callback = function(Value)
        HitboxEnabled = Value
    end
})

TabMain:CreateSlider({
    Name = "Размер хитбокса",
    Range = {5, 50},
    Increment = 1,
    Suffix = "Size",
    CurrentValue = HeadSize,
    Callback = function(Value)
        HeadSize = Value
    end
})

-- Ноуклип
TabMain:CreateToggle({
    Name = "Ноуклип (N)",
    CurrentValue = false,
    Callback = function(Value)
        NoclipEnabled = Value
    end
})

-- Флай вверх
TabMain:CreateToggle({
    Name = "Флай вверх (X)",
    CurrentValue = false,
    Callback = function(Value)
        FlyUpEnabled = Value
    end
})

TabMain:CreateSlider({
    Name = "Скорость флая вверх",
    Range = {1, 20},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = FlyUpSpeed,
    Callback = function(Value)
        FlyUpSpeed = Value
    end
})

-- Freeze Self
TabMain:CreateToggle({
    Name = "Freeze Self (P)",
    CurrentValue = false,
    Callback = function(Value)
        FreezeEnabled = Value
        if Value and Root then
            FreezePosition = Root.CFrame
        end
    end
})
