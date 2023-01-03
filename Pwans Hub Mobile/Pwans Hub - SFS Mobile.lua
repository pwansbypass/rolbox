repeat wait() until game:IsLoaded()
print("Last Update: 01/03/2023, 9:47 AM PHT")

local TweenService = game:GetService("TweenService")
local noclipE = false
local antifall = false

local function noclip()
    for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

local function moveto(obj, speed)
    local info =
        TweenInfo.new(
        ((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude) / speed,
        Enum.EasingStyle.Linear
    )
    local tween = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, info, {CFrame = obj})

    if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
        antifall = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
        antifall.Velocity = Vector3.new(0, 0, 0)
        noclipE = game:GetService("RunService").Stepped:Connect(noclip)
        tween:Play()
    end

    tween.Completed:Connect(
        function()
            antifall:Destroy()
            noclipE:Disconnect()
        end
    )
	
	if not tween then
        return tween
    end
end

local Area = {
    "Dungeon",
	"Dark Forest",
    "Skull Cove",
    "Demon Hill",
    "Polar Tundra",
    "Aether City",
    "Underworld",
    "Ancient Sands",
    "Enchanted Woods",
    "Mystic Mines",
	"Sacred Land",
	"Marine Castle"
	}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local function GetClosest(Range)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    if not (Character or HumanoidRootPart) then return end

    local TargetDistance = Range
    local Target

    for i,v in ipairs(game:GetService("Workspace").Live.NPCs.Client:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v.HumanoidRootPart:FindFirstChild("NPCTag") then
            local TargetHRP = v.HumanoidRootPart
            local mag = (HumanoidRootPart.Position - TargetHRP.Position).magnitude
            if mag < TargetDistance then
                TargetDistance = mag
                Target = v.Name
            end
        end
    end

    return Target
end

local function near()
    local dist, thing = math.huge
    for i, v in next, game:GetService("Workspace").Live.NPCs.Client:GetChildren() do
        if v:IsA("Model") then
            local mag =
                (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).magnitude
            if mag < dist then
                dist = mag
                thing = v
            end
        end
    end
    return thing
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/uzu01/lua/main/ui/uwuware.lua"))()
local window = library:CreateWindow("Pwans Hub")

window:AddList({
    text = "Select Zone", 
    value = "Dark Forest",
    values = Area, 
    callback = function(bool) 
        Zone = bool
    end
})

window:AddButton({
    text = "Teleport",
    callback = function()
    if Zone == "Dark Forest" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(326.81103515625, 154.78720092773438, -0.9621031284332275)
        elseif Zone == "Skull Cove" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2233.5947265625, 154.38075256347656, -573.1763305664062)
        elseif Zone == "Demon Hill" then 
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3947.695068359375, 154.7611541748047, -384.1679382324219)
        elseif Zone == "Polar Tundra" then 
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5964.9404296875, 154.76002502441406, -537.9541015625)
        elseif Zone == "Aether City" then 
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(8952.482421875, 613.51220703125, -514.54931640625)
        elseif Zone == "Underworld" then 
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(13587.9443359375, 159.0894775390625, 86.26057434082031)
        elseif Zone == "Ancient Sands" then
		    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(535.2523803710938, 154.1487274169922, -2911.2890625)
        elseif Zone == "Enchanted Woods" then
		    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(4034.58837890625, 154.32273864746094, -4377.16845703125)
        elseif Zone == "Mystic Mines" then
		    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(7191.892578125, -107.203857421875, -4666.94140625)
		elseif Zone == "Sacred Land" then
		    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9396.62890625, 155.7611846923828, -4369.650390625)
		elseif Zone == "Dungeon" then
		    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1818.9263916015625, -3.119408130645752, -129.5235595703125)
	    elseif Zone == "Marine Castle" then
		    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new()
        end
    end
})

window:AddToggle({
    text = "Auto Dungeon", 
    state = false,
    callback = function(bool) 
        autoDungeon = bool
end
})

window:AddToggle({
    text = "Auto Dungeon", 
    state = false,
    callback = function(bool) 
        autoDoor = bool
end
})

window:AddButton({
    text = "Redeem Rewards",
    callback = function()
	    leaveDungeon()
end
})

window:AddToggle({
    text = "Auto Power", 
    state = false,
    callback = function(bool) 
        autoPower = bool
end
})

window:AddToggle({
    text = "Aura (near)", 
    state = false,
    callback = function(bool) 
        nearAura = bool
end
})

window:AddToggle({
    text = "Magnet", 
    state = false,
    callback = function(bool) 
        Magnet = bool
end
})

window:AddButton({
    text = "Redeem Rewards",
    callback = function()
	    Rewards()
end
})

window:AddButton({
    text = "Anti AFK",
    callback = function()
	    AntiAFK()
end
})

local ProtectGui = protectgui or (syn and syn.protect_gui) or (function() end)
local PwansHubGui = Instance.new("PwansHubGui")
ProtectGui(PwansHubGui)
local Toggle = Instance.new("TextButton")
PwansHubGui.Name = "PwansHubGui"
PwansHubGui.Parent = game.CoreGui
Toggle.Name = "Toggle"
Toggle.Parent = PwansHubGui
Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Toggle.Position = UDim2.new(0.120833337, 0, 0.0952890813, 0)
Toggle.Size = UDim2.new(0, 25, 0, 25)
Toggle.Font = Enum.Font.Code
Toggle.Text = "H"
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.TextScaled = true
Toggle.MouseButton1Down:connect(function()
    library:Close()
end)

spawn(function()
    while task.wait(0.5) do
        if Magnet then
            task.spawn(function()
                for i,v in pairs(game.Workspace.Live.Pickups:GetChildren()) do
                    v.CFrame = game.Players.localPlayer.Character.HumanoidRootPart.CFrame
                end
            end)
		end
    end
end)

spawn(function()
    while task.wait() do
        if nearAura then
            task.spawn(function()
                game:GetService("ReplicatedStorage").Packages.Knit.Services.ClickService.RF.Click:InvokeServer(near().Name)
            end)
		end
    end
end)

spawn(function()
    while task.wait() do
        if Aura then
            task.spawn(function()
                for i,v in ipairs(game:GetService("Workspace").Live.NPCs.Client:GetChildren()) do
                    if v.Name == GetClosest(math.huge) and v:FindFirstChild("HumanoidRootPart") and v.HumanoidRootPart:FindFirstChild("NPCTag") then
                        game:GetService("ReplicatedStorage").Packages.Knit.Services.ClickService.RF.Click:InvokeServer(v.Name)
                    end
                end
            end)
		end
    end
end)

spawn(function()
    while task.wait() do
        if autoPower then
            task.spawn(function()
                game:GetService("ReplicatedStorage").Packages.Knit.Services.ClickService.RF.Click:InvokeServer()
            end)
		end
    end
end)

spawn(function()
    while task.wait() do
        if autoDungeon then
			task.spawn(function()
                for i, v in pairs(game:GetService("Workspace").Live.NPCs.Client:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") and v.HumanoidRootPart:FindFirstChild("NPCTag") and autoDungeon == true then
                        repeat task.wait()
							moveto(v.HumanoidRootPart.CFrame + Vector3.new(5,0,0),200)
                            game:GetService("ReplicatedStorage").Packages.Knit.Services.ClickService.RF.Click:InvokeServer(v.Name)
                        until not v.HumanoidRootPart:FindFirstChild("NPCTag") or autoDungeon == false
					end
                end
            end)
        end
    end
end)

spawn(function()
    while wait(2) do
        if autoDoor then
            if game:GetService("Players").LocalPlayer:GetAttribute("Dungeon") ~= nil then
                local Dungeon1 = game:GetService("Players").LocalPlayer:GetAttribute("Dungeon")
                game:GetService("ReplicatedStorage").Packages.Knit.Services.DungeonService.RF.ContinueDungeon:InvokeServer(Dungeon1)
			end
        end
	end
end)

function Rewards()
game:GetService("ReplicatedStorage").Packages.Knit.Services.ChestService.RF.ClaimChest:InvokeServer(("Free Ticket 1"))
game:GetService("ReplicatedStorage").Packages.Knit.Services.ChestService.RF.ClaimChest:InvokeServer(("Free Ticket 2"))
game:GetService("ReplicatedStorage").Packages.Knit.Services.ChestService.RF.ClaimChest:InvokeServer(("Free Ticket 3"))
game:GetService("ReplicatedStorage").Packages.Knit.Services.ChestService.RF.ClaimChest:InvokeServer(("Free Ticket 4"))
game:GetService("ReplicatedStorage").Packages.Knit.Services.ChestService.RF.ClaimChest:InvokeServer(("Free Ticket 5"))
game:GetService("ReplicatedStorage").Packages.Knit.Services.ChestService.RF.ClaimChest:InvokeServer(("Free Ticket 6"))
game:GetService("ReplicatedStorage").Packages.Knit.Services.ChestService.RF.ClaimChest:InvokeServer(("Chest 1"))
game:GetService("ReplicatedStorage").Packages.Knit.Services.ChestService.RF.ClaimChest:InvokeServer(("Chest 2"))
warn("Rewards: Redeemed")
end

function AntiAFK()
    game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)
warn("ANTI AFK : ON")
end

function leaveDungeon()
    game:GetService("ReplicatedStorage").Packages.Knit.Services.DungeonService.RF.LeaveDungeon:InvokeServer()
end

library:Init()