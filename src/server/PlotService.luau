local PlotService = {}

local PLOT_SIZE = Vector3.new(40, 2, 40)
local PLOT_SPACING = 80
local PLOTS_PER_ROW = 4

-- Setup World
local floor = Instance.new("Part")
floor.Name = "GrassFloor"
floor.Size = Vector3.new(600, 1, 600)
floor.Position = Vector3.new(0, -0.5, 0)
floor.Anchored = true
floor.Color = Color3.fromRGB(39, 139, 39)
floor.Parent = workspace

local shop = Instance.new("Model", workspace)
shop.Name = "ShopBuilding"
local shopBase = Instance.new("Part", shop)
shopBase.Size = Vector3.new(40, 20, 40)
shopBase.Position = Vector3.new(0, 10, 0)
shopBase.Anchored = true
local neonRoof = Instance.new("Part", shop)
neonRoof.Size = Vector3.new(40, 2, 40)
neonRoof.Position = Vector3.new(0, 21, 0)
neonRoof.Anchored = true
neonRoof.Material = Enum.Material.Neon
neonRoof.Color = Color3.fromRGB(255, 255, 0)

-- Plots
local plots = {}
for i = 0, 7 do
    local row = math.floor(i / PLOTS_PER_ROW)
    local col = i % PLOTS_PER_ROW
    local x = (col - 1.5) * PLOT_SPACING
    local z = (row - 0.5) * PLOT_SPACING
    
    local plotBase = Instance.new("Part")
    plotBase.Name = "Plot_" .. i
    plotBase.Size = PLOT_SIZE
    plotBase.Position = Vector3.new(x, 1, z)
    plotBase.Anchored = true
    plotBase.Parent = workspace
    
    local gui = Instance.new("BillboardGui", plotBase)
    gui.Size = UDim2.new(0, 200, 0, 50)
    gui.StudsOffset = Vector3.new(0, 5, 0)
    local label = Instance.new("TextLabel", gui)
    label.Text = "Plot " .. (i + 1)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    
    local slotPositions = {}
    for sy = 0, 4 do
        for sx = 0, 1 do
            table.insert(slotPositions, Vector3.new(x + (sx - 0.5) * 20, 3, z + (sy - 2) * 6))
        end
    end
    
    plots[i + 1] = {BasePart = plotBase, SlotPositions = slotPositions, Owner = nil}
end

function PlotService.AssignPlot(player)
    for _, plot in pairs(plots) do
        if not plot.Owner then
            plot.Owner = player.UserId
            return plot
        end
    end
    return nil
end

function PlotService.PlaceCharacter(plot, slotIndex, characterEntry)
    local pos = plot.SlotPositions[slotIndex]
    local part = Instance.new("Part")
    part.Name = characterEntry.Name
    part.Size = Vector3.new(2, 2, 2)
    part.Position = pos
    part.Anchored = true
    part.Material = (characterEntry.Rarity == "Legendary" or characterEntry.Rarity == "Mythic") and Enum.Material.Neon or Enum.Material.SmoothPlastic
    
    if characterEntry.IsShiny then
        part.Color = Color3.fromRGB(255, 215, 0) -- Gold
    else
        part.Color = characterEntry.Color
    end
    part.Parent = workspace

    local gui = Instance.new("BillboardGui", part)
    gui.Size = UDim2.new(0, 100, 0, 50)
    gui.StudsOffset = Vector3.new(0, 3, 0)
    local label = Instance.new("TextLabel", gui)
    local shinyText = characterEntry.IsShiny and " [SHINY!]" or ""
    label.Text = string.format("%s%s\n[%s]\n+$%d/s", characterEntry.Name, shinyText, characterEntry.Rarity, characterEntry.Income)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1

    return part
end
return PlotService
