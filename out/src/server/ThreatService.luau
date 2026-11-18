local ThreatService = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ThreatEvent = Instance.new("RemoteEvent", Remotes)
ThreatEvent.Name = "ThreatEvent"

local rng = Random.new(424242)
local counter = 0

function ThreatService.Update(delta)
    counter += delta
    if counter >= 90 then
        counter = 0
        local eventType = rng:NextInteger(1, 3)
        if eventType == 1 then
            ThreatService.TriggerNuscannerWave()
        elseif eventType == 2 then
            ThreatService.TriggerRivalThief()
        elseif eventType == 3 then
            ThreatService.TriggerGoldenHour()
        end
    end
end

function ThreatService.TriggerNuscannerWave()
    ThreatEvent:FireAllClients({Kind='wave', Message='Nuscanner Wave approaching!'})
    -- Actual implementation would involve animating a giant Part across the map
end

function ThreatService.TriggerRivalThief()
    ThreatEvent:FireAllClients({Kind='thief', Message='Rival Thief is stealing your characters!'})
    -- Logic to find a plot and move parts
end

function ThreatService.TriggerGoldenHour()
    ThreatEvent:FireAllClients({Kind='golden', Message='Golden Hour! Income doubled!'})
    task.spawn(function()
        local oldBrightness = Lighting.Brightness
        local oldClockTime = Lighting.ClockTime
        Lighting.Brightness = 5
        Lighting.ClockTime = 12
        task.wait(20)
        Lighting.Brightness = oldBrightness
        Lighting.ClockTime = oldClockTime
        ThreatEvent:FireAllClients({Kind='end', Message='Golden Hour ended.'})
    end)
end

function ThreatService.Describe()
    return "Hazards occur every 90 seconds: Nuscanner Wave destroys characters, Rival Thief steals valuable ones, Golden Hour doubles income."
end

return ThreatService
