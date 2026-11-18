-- LocalScript for the Brainrot Bazar HUD
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local Catalog = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("BrainrotCatalog"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local SyncState = Remotes:WaitForChild("SyncState")
local BuyCharacter = Remotes:WaitForChild("BuyCharacter")
local CollectCash = Remotes:WaitForChild("CollectCash")
local Rebirth = Remotes:WaitForChild("Rebirth")
local ThreatEvent = Remotes:WaitForChild("ThreatEvent")

local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotBazarHud"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- HUD Elements
local cashBar = Instance.new("Frame", gui)
cashBar.Size = UDim2.new(0, 300, 0, 80)
cashBar.Position = UDim2.new(0.5, -150, 0, 20)
cashBar.BackgroundColor3 = Color3.new(0, 0, 0)
cashBar.BackgroundTransparency = 0.5
cashBar.BorderSizePixel = 0

local cashText = Instance.new("TextLabel", cashBar)
cashText.Size = UDim2.new(1, 0, 0.6, 0)
cashText.TextColor3 = Color3.new(1, 1, 1)
cashText.TextSize = 24
cashText.Font = Enum.Font.SourceSansBold
cashText.Parent = cashBar

local incomeText = Instance.new("TextLabel", cashBar)
incomeText.Size = UDim2.new(1, 0, 0.4, 0)
incomeText.Position = UDim2.new(0, 0, 0.6, 0)
incomeText.TextColor3 = Color3.new(1, 1, 1)
incomeText.TextSize = 16
incomeText.Parent = cashBar

-- Shop Panel
local shopPanel = Instance.new("ScrollingFrame", gui)
shopPanel.Size = UDim2.new(0, 400, 0, 500)
shopPanel.Position = UDim2.new(0.8, -200, 0.5, -250)
shopPanel.CanvasSize = UDim2.new(0, 0, 2, 0)
shopPanel.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Instance.new("UIListLayout", shopPanel)

for _, rarity in pairs(Catalog.Rarity) do
    local rarityHeader = Instance.new("TextLabel", shopPanel)
    rarityHeader.Text = rarity
    rarityHeader.Size = UDim2.new(1, 0, 0, 30)
    for _, char in pairs(Catalog.GetByRarity(rarity)) do
        local row = Instance.new("Frame", shopPanel)
        row.Size = UDim2.new(1, 0, 0, 40)
        
        local stripe = Instance.new("Frame", row)
        stripe.Size = UDim2.new(0, 10, 1, 0)
        stripe.BackgroundColor3 = char.Color
        
        local nameLabel = Instance.new("TextLabel", row)
        nameLabel.Text = "<b>"..char.Name.."</b>"
        nameLabel.RichText = true
        nameLabel.Position = UDim2.new(0, 15, 0, 0)
        
        local buyBtn = Instance.new("TextButton", row)
        buyBtn.Text = "Buy ($"..char.Price..")"
        buyBtn.Position = UDim2.new(0.7, 0, 0, 5)
        buyBtn.Size = UDim2.new(0.25, 0, 0, 30)
        buyBtn.BackgroundColor3 = Color3.new(0, 1, 0)
        
        buyBtn.MouseButton1Click:Connect(function()
            BuyCharacter:FireServer(char)
        end)
    end
end

-- Minimap
local minimap = Instance.new("Frame", gui)
minimap.Size = UDim2.new(0, 100, 0, 100)
minimap.Position = UDim2.new(0, 10, 0, 10)
minimap.BackgroundColor3 = Color3.new(0,0,0)
for i=1, 8 do
    local plot = Instance.new("Frame", minimap)
    plot.Size = UDim2.new(0, 20, 0, 20)
    plot.Position = UDim2.new(0, (i%4)*25, 0, math.floor(i/4)*25)
end

-- Events
ThreatEvent.OnClientEvent:Connect(function(message, color)
    local banner = Instance.new("TextLabel", gui)
    banner.Size = UDim2.new(1, 0, 0, 50)
    banner.Position = UDim2.new(0, 0, 0.5, -25)
    banner.BackgroundColor3 = color
    banner.Text = message
    banner.TextSize = 30
    task.wait(4)
    banner:Destroy()

    -- Camera shake
    local cam = workspace.CurrentCamera
    for i = 1, 5 do
        cam.CFrame *= CFrame.new(math.random(-1, 1), math.random(-1, 1), 0) * CFrame.Angles(0, 0, math.rad(math.random(-1, 1)))
        task.wait(0.1)
    end
end)

-- Rarity Legend
local legend = Instance.new("Frame", gui)
legend.Size = UDim2.new(0, 150, 0, 200)
legend.Position = UDim2.new(0, 10, 0.5, -100)
legend.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Instance.new("UIListLayout", legend)
for name, rarity in pairs(Catalog.Rarity) do
    local item = Instance.new("TextLabel", legend)
    item.Text = rarity
    item.Size = UDim2.new(1, 0, 0, 25)
end

SyncState.OnClientEvent:Connect(function(state)
    cashText.Text = "$" .. math.floor(state.Cash)
    incomeText.Text = "+$" .. math.floor(state.IncomePerSecond) .. "/s"
end)
