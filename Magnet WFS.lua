local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/uzu01/lua/main/ui/uwuware.lua"))()
local window = library:CreateWindow("WFS")

local area = {}
local autocollect = false

for i, v in pairs(game:GetService("Workspace").Fight:GetChildren()) do
    if string.find(v.Name,"FightArea") and not table.find(area,v.Name)then
        table.insert(area,v.Name)
    end
end

for i, v in pairs(game:GetService("ReplicatedStorage").CommonLogic.Fight.Models:GetChildren()) do
    if string.find(v.Name,"FightArea") then
        table.insert(area,v.Name)
    end
end


local selected_gamble_area = area[1]
table.sort(area)

window:AddToggle({
    text = "Auto Open", 
    state = autogamble,
    callback = function(v) 
        autogamble = v
 
        task.spawn(function()
            while task.wait() do
                if not autogamble then break end
                for i, v in pairs(game.Workspace.Fight[selected_gamble_area].Gamble:GetChildren()) do
                    if v:IsA("Part") then
                        game:GetService('VirtualInputManager'):SendKeyEvent(true, "E", false, game)
                        game:GetService('VirtualInputManager'):SendKeyEvent(false, "E", false, game)
                    end
                end
            end
        end) 
    end
})

window:AddList({
    text = "Select World", 
    values = area,
    callback = function(a) 
        selected_gamble_area = a
    end
})

window:AddToggle({
    text = "Magnet", 
    state = autocollect,
    callback = function(v) 
        autocollect = v

        local RS = require(game:GetService("ReplicatedStorage").CommonConfig.CfgGlobal)
        
        if autocollect then
            RS.RewardCollectRadius = 9e99
        else 
            RS.RewardCollectRadius = 12
        end
    end
})

window:AddButton({
    text = "Fast Open",
    callback = function()
        local a = require(game:GetService("ReplicatedStorage").CommonLogic.Model.GamePasses)
        a.HasGamePass = function() return true end
     
        game:GetService("Players").LocalPlayer.PlayerGui.MainGui.ScreenGui.MainLeftBarView.FrameChild3.BgTeleport.ImgMask.Visible = false
    end
})

window:AddButton({
        text = "No Disconnect",
        callback = function()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)
OrionLib:MakeNotification({
            Name = "ANTI-AFK: ON",
            Content = "",
            Image = "rbxassetid://6023426945",
            Duration = 5
                                     })
warn("ANTI-AFK: ON")
      end
    })

	local ScreenGui = Instance.new("ScreenGui")
    local Toggle = Instance.new("TextButton")
    ScreenGui.Name = "ScreenGui"
    ScreenGui.Parent = game.CoreGui
    Toggle.Name = "Toggle"
    Toggle.Parent = ScreenGui
    Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Toggle.Position = UDim2.new(0.120833337, 0, 0.0952890813, 0)
    Toggle.Size = UDim2.new(0, 50, 0, 50)
    Toggle.Font = Enum.Font.Code
    Toggle.Text = "P"
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.TextScaled = true
    Toggle.MouseButton1Down:connect(function()
        library:Close()
    end)
library:Init()