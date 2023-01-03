do pcall(function()
  for _,v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name == "PwansHubGui" then
      v:Remove()
    end
  end
end) end

local ProtectGui = protectgui or (syn and syn.protect_gui) or (function() end)
local PwansHubGui = Instance.new("ScreenGui")
ProtectGui(PwansHubGui)
local Toggle = Instance.new("TextButton")
PwansHubGui.Name = "PwansHubGui"
PwansHubGui.Parent = game.CoreGui
Toggle.Name = "Toggle"
Toggle.Parent = PwansHubGui
Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Toggle.Position = UDim2.new(0.050000000, 0, 0.250000000, 0)
Toggle.Size = UDim2.new(0, 35, 0, 35)
Toggle.Font = Enum.Font.Code
Toggle.Text = "H"
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.TextScaled = true
Toggle.MouseButton1Down:connect(function()
        game:GetService('VirtualInputManager'):SendKeyEvent(true, "RightControl", false, game)
    game:GetService('VirtualInputManager'):SendKeyEvent(false, "RightControl", false, game)
end)
