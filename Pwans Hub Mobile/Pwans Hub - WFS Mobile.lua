repeat wait() until game:IsLoaded()
print("Last Update: 01/03/2023, 9:47 AM PHT")
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/uzu01/lua/main/ui/uwuware.lua"))()
local window = library:CreateWindow("Pwans Hub")

window:AddToggle({
    text = "Auto Open", 
    state = false,
    callback = function(bool) 
        autoOpen = bool
    end
})

window:AddToggle({
    text = "Super Magnet", 
    state = false,
    callback = function(bool) 
        superMagnet = bool
    end
})

window:AddButton({
    text = "Fast Open",
    callback = function()
        fastOPEN()
    end
})

window:AddButton({
    text = "Anti Lag",
    callback = function()
	    noLAG()
    end
})

window:AddButton({
    text = "Anti AFK",
    callback = function()
	    noAFK()
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

task.spawn(function()
    while task.wait(1.5) do
        if not autoOpen then break end
        game:GetService('VirtualInputManager'):SendKeyEvent(true, "E", false, game)
        game:GetService('VirtualInputManager'):SendKeyEvent(false, "E", false, game)
    end
end)

spawn(function()
    if superMagnet then
        require(game:GetService("ReplicatedStorage").CommonConfig.CfgGlobal).RewardCollectRadius = 9e99
    else 
        require(game:GetService("ReplicatedStorage").CommonConfig.CfgGlobal).RewardCollectRadius = 12
    end
end)




function fastOPEN()
    require(game:GetService("ReplicatedStorage").CommonLogic.Model.GamePasses).HasGamePass = function() return true end
	warn("FAST OPEN: ON")
end

function noLAG()
    for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then --- i stole this from the actual game LOL >-<
            v.Material = Enum.Material.SmoothPlastic
                if v:IsA("Texture") then
                    v:Destroy()
                end
            end
        end
	warn("ANTI LAG: ON")
end

function noAFK()
	game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)
    warn("ANTI AFK: ON")
end

library:Init()