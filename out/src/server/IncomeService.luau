local IncomeService = {}

local PlayerStates = {}
local rng = Random.new(424242)

function IncomeService.InitPlayer(player)
    PlayerStates[player.UserId] = {
        Cash = 250,
        Multiplier = 1,
        Owned = {}
    }
end

function IncomeService.TickPlayers(delta)
    for userId, state in pairs(PlayerStates) do
        local incomePerSecond = 0
        for _, char in pairs(state.Owned) do
            local income = char.Income * state.Multiplier
            if char.IsShiny then income *= 3 end
            incomePerSecond += income
        end
        state.Cash += incomePerSecond * delta
    end
end

function IncomeService.BuyCharacter(player, plot, catalogEntry)
    local state = PlayerStates[player.UserId]
    if state.Cash >= catalogEntry.Price then
        state.Cash -= catalogEntry.Price
        local isShiny = rng:NextInteger(1, 12) == 1
        local char = {
            Name = catalogEntry.Name,
            Price = catalogEntry.Price,
            Income = catalogEntry.Income,
            Color = catalogEntry.Color,
            Rarity = catalogEntry.Rarity,
            IsShiny = isShiny
        }
        table.insert(state.Owned, char)
        return true, char
    end
    return false
end

function IncomeService.Rebirth(player)
    local state = PlayerStates[player.UserId]
    local counts = {}
    for _, char in pairs(state.Owned) do
        counts[char.Name] = (counts[char.Name] or 0) + 1
    end

    local canRebirth = false
    for _, count in pairs(counts) do
        if count >= 5 then canRebirth = true break end
    end

    if canRebirth then
        state.Owned = {}
        state.Multiplier += 0.5
        state.Cash = 250
        return true, state.Multiplier
    end
    return false
end

function IncomeService.Snapshot(player)
    local state = PlayerStates[player.UserId]
    local incomePerSecond = 0
    for _, char in pairs(state.Owned) do
        local income = char.Income * state.Multiplier
        if char.IsShiny then income *= 3 end
        incomePerSecond += income
    end

    return {
        Cash = state.Cash,
        Multiplier = state.Multiplier,
        OwnedCount = #state.Owned,
        IncomePerSecond = incomePerSecond,
        PlotSlotsFree = 10 - #state.Owned
    }
end

return IncomeService
