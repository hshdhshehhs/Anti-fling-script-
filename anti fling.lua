--this time im have updated your code, i like it but i want to be more extra on your code so i have add comments-- 
-- Initialization
if not game:IsLoaded() then
    repeat task.wait() until game:IsLoaded()
end

local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("SendNotification", {
    Title = "Anti-Fling Activated!",
    Text = "Script by Silly Nooby",
    Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"
})

local Duration = 16
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Client = Players.LocalPlayer
local Character = Client.Character
local AntiFlingConnections = {}

-- Function to apply anti-fling properties to a part
local function ApplyAntiFling(part)
    if not part or not part:IsA("BasePart") then return end
    if part.Parent == Character then return end
    if part.Anchored then return end
    if part.Name ~= "HumanoidRootPart" then return end
    
    local connection = RunService.Heartbeat:Connect(function()
        if not part or not part.Parent then
            if AntiFlingConnections[part] then
                AntiFlingConnections[part]:Disconnect()
                AntiFlingConnections[part] = nil
            end
            return
        end
        part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
        part.Velocity = Vector3.zero
        part.RotVelocity = Vector3.zero
        part.CanCollide = false
        task.wait(1)
    end)
    AntiFlingConnections[part] = connection
end

-- Function to handle character death
local function OnCharacterDied()
    for part, connection in pairs(AntiFlingConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    AntiFlingConnections = {}
end

-- Function to scan and apply anti-fling to existing parts
local function ScanForParts()
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("BasePart") then
            ApplyAntiFling(descendant)
        end
    end
end

-- Function to handle new parts being added
local function OnDescendantAdded(part)
    if part:IsA("BasePart") then
        task.wait(2)
        ApplyAntiFling(part)
    end
end

-- Main function to start anti-fling
local function StartAntiFling()
    ScanForParts()
    workspace.DescendantAdded:Connect(OnDescendantAdded)
    if Character and Character:IsA("Model") and Character:FindFirstChild("Humanoid") then
        Character.Humanoid.Died:Connect(OnCharacterDied)
    end
end

-- Start the anti-fling system
StartAntiFling()

-- Handle character added after script start
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if player == Client then
            Character = character
            StartAntiFling()
        end
    end)
end)
