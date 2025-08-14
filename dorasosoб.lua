-- Загружаем Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Создаем окно
local Window = Rayfield:CreateWindow({
    Name = "PvP Utility",
    LoadingTitle = "Загрузка функций...",
    LoadingSubtitle = "by dora",
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
local IsTeamCheckEnabled = false
local Transparency = 0.95
local Friends = {}

local function AddFriend(username)
    local player = Players:FindFirstChild(username)
    if player and player ~= LP then
        Friends[player] = true
    end
end

local function RemoveFriend(username)
    local player = Players:FindFirstChild(username)
    if player and Friends[player] then
        Friends[player] = nil
    end
end

RunService.RenderStepped:Connect(function()
    if HitboxEnabled then
        local localPlayerTeam = LP.Team
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and (not IsTeamCheckEnabled or player.Team ~= localPlayerTeam) then
                if not Friends[player] and player.Character then
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
    end
end)

------------------------------------------------
-- Ноуклип
------------------------------------------------
local NoclipEnabled = false

RunService.Stepped:Connect(function()
    if NoclipEnabled and LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

------------------------------------------------
-- Rayfield GUI
------------------------------------------------
local TabMain = Window:CreateTab("Главное", 4483362458)

-- Спиды
TabMain:CreateToggle({
    Name = "Спидхак",
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

TabMain:CreateToggle({
    Name = "Игнор тиммейтов",
    CurrentValue = false,
    Callback = function(Value)
        IsTeamCheckEnabled = Value
    end
})

-- Ноуклип
TabMain:CreateToggle({
    Name = "Ноуклип",
    CurrentValue = false,
    Callback = function(Value)
        NoclipEnabled = Value
    end
})
