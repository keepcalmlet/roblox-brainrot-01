local BrainrotCatalog = {}

local Rarity = {
    Common = "Common",
    Rare = "Rare",
    Epic = "Epic",
    Legendary = "Legendary",
    Mythic = "Mythic",
    Secret = "Secret"
}

local Characters = {
    {Name = "Skibidi Sapi", Income = 1, Rarity = Rarity.Common, Color = Color3.fromRGB(255, 255, 255), Price = 25},
    {Name = "Tralalero Trunk", Income = 2, Rarity = Rarity.Common, Color = Color3.fromRGB(200, 200, 200), Price = 50},
    {Name = "Ohio Ogre", Income = 3, Rarity = Rarity.Common, Color = Color3.fromRGB(150, 150, 150), Price = 75},
    {Name = "Fanum Taxman", Income = 4, Rarity = Rarity.Common, Color = Color3.fromRGB(100, 100, 100), Price = 100},
    
    {Name = "Grimace Shake-y", Income = 10, Rarity = Rarity.Rare, Color = Color3.fromRGB(200, 100, 200), Price = 500},
    {Name = "Sigma Slicer", Income = 15, Rarity = Rarity.Rare, Color = Color3.fromRGB(100, 200, 100), Price = 750},
    {Name = "Mewing Master", Income = 20, Rarity = Rarity.Rare, Color = Color3.fromRGB(100, 100, 200), Price = 1000},
    {Name = "Gyatt Gladiator", Income = 25, Rarity = Rarity.Rare, Color = Color3.fromRGB(200, 200, 100), Price = 1250},
    
    {Name = "Rizzler Rex", Income = 100, Rarity = Rarity.Epic, Color = Color3.fromRGB(255, 150, 50), Price = 5000},
    {Name = "Capybara King", Income = 150, Rarity = Rarity.Epic, Color = Color3.fromRGB(150, 255, 50), Price = 7500},
    {Name = "Looksmaxxer", Income = 200, Rarity = Rarity.Epic, Color = Color3.fromRGB(50, 255, 150), Price = 10000},
    {Name = "Sticking Out Your Gyatt", Income = 250, Rarity = Rarity.Epic, Color = Color3.fromRGB(50, 150, 255), Price = 12500},
    
    {Name = "Toilet Titan", Income = 1000, Rarity = Rarity.Legendary, Color = Color3.fromRGB(255, 50, 50), Price = 50000},
    {Name = "Camera Crusher", Income = 1500, Rarity = Rarity.Legendary, Color = Color3.fromRGB(50, 255, 50), Price = 75000},
    {Name = "Speaker Swag", Income = 2000, Rarity = Rarity.Legendary, Color = Color3.fromRGB(50, 50, 255), Price = 100000},
    {Name = "TV Terror", Income = 2500, Rarity = Rarity.Legendary, Color = Color3.fromRGB(255, 255, 50), Price = 125000},
    
    {Name = "Goon Cave Guru", Income = 10000, Rarity = Rarity.Mythic, Color = Color3.fromRGB(200, 0, 200), Price = 250000},
    {Name = "Brainrot Barone", Income = 15000, Rarity = Rarity.Mythic, Color = Color3.fromRGB(0, 200, 200), Price = 375000},
    {Name = "Sigma Sovereign", Income = 20000, Rarity = Rarity.Mythic, Color = Color3.fromRGB(200, 200, 0), Price = 500000},
    {Name = "Negative Aura King", Income = 25000, Rarity = Rarity.Mythic, Color = Color3.fromRGB(100, 0, 0), Price = 625000},
    
    {Name = "Alpha Omega", Income = 100000, Rarity = Rarity.Secret, Color = Color3.fromRGB(255, 255, 255), Price = 1000000},
    {Name = "The Final Boss", Income = 150000, Rarity = Rarity.Secret, Color = Color3.fromRGB(255, 0, 255), Price = 1500000},
    {Name = "Unknown Entity", Income = 200000, Rarity = Rarity.Secret, Color = Color3.fromRGB(0, 255, 255), Price = 2000000},
    {Name = "The One", Income = 250000, Rarity = Rarity.Secret, Color = Color3.fromRGB(0, 0, 0), Price = 2500000}
}

function BrainrotCatalog.GetByRarity(rarity)
    local list = {}
    for _, char in pairs(Characters) do
        if char.Rarity == rarity then
            table.insert(list, char)
        end
    end
    return list
end

function BrainrotCatalog.RollRarity(rng)
    local roll = rng:NextNumber()
    if roll < 0.001 then return Rarity.Secret end
    if roll < 0.05 then return Rarity.Mythic end
    if roll < 0.15 then return Rarity.Legendary end
    if roll < 0.35 then return Rarity.Epic end
    if roll < 0.60 then return Rarity.Rare end
    return Rarity.Common
end

BrainrotCatalog.Characters = Characters
BrainrotCatalog.Rarity = Rarity

return BrainrotCatalog
