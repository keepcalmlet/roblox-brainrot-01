local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Catalog = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("BrainrotCatalog"))
local PlotService = require(script.Parent:WaitForChild("PlotService"))
local IncomeService = require(script.Parent:WaitForChild("IncomeService"))
local ThreatService = require(script.Parent:WaitForChild("ThreatService"))

local Remotes = Instance.new("Folder", ReplicatedStorage)
Remotes.Name = "Remotes"

local BuyCharacter = Instance.new("RemoteEvent", Remotes)
BuyCharacter.Name = "BuyCharacter"
local CollectCash = Instance.new("RemoteEvent", Remotes)
CollectCash.Name = "CollectCash"
local SyncState = Instance.new("RemoteEvent", Remotes)
SyncState.Name = "SyncState"
local SpawnCharacter = Instance.new("RemoteEvent", Remotes)
SpawnCharacter.Name = "SpawnCharacter"
local Rebirth = Instance.new("RemoteEvent", Remotes)
Rebirth.Name = "Rebirth"

local PlayerPlots = {}

Players.PlayerAdded:Connect(function(player)
    IncomeService.InitPlayer(player)
    local plot = PlotService.AssignPlot(player)
    if plot then
        PlayerPlots[player.UserId] = plot
    end
end)

BuyCharacter.OnServerEvent:Connect(function(player, rarity)
    local plot = PlayerPlots[player.UserId]
    if not plot then return end

    local entry = Catalog.GetByRarity(rarity)[1] -- Simplified: take first
    local success, characterEntry = IncomeService.BuyCharacter(player, plot, entry)
    if success then
        PlotService.PlaceCharacter(plot, #PlayerPlots[player.UserId].SlotPositions, characterEntry)
    end
end)

Rebirth.OnServerEvent:Connect(function(player)
    local success, newMult = IncomeService.Rebirth(player)
    if success then
        -- Refresh plots logic needed here to clear characters
    end
end)

task.spawn(function()
    local lastTick = tick()
    while task.wait(1) do
        local now = tick()
        local delta = now - lastTick
        lastTick = now
        
        IncomeService.TickPlayers(delta)
        ThreatService.Update(delta)
        
        for _, player in pairs(Players:GetPlayers()) do
            SyncState:FireClient(player, IncomeService.Snapshot(player))
        end
    end
end)
