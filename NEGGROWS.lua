local placeId = 126884695634066
if game.placeId ~= placeId then return end

local StartTick = tick()

-- Wait for Utils
repeat task.wait()
until game:IsLoaded() and game:GetService("Players") and game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.PlayerGui and game:GetService("Players").LocalPlayer.Backpack;

-- Services
local Env_ = getgenv();
local Players = game:GetService("Players");
local HttpService = game:GetService("HttpService");

-- LocalPlayer
local LocalPlayer = Players.LocalPlayer;
local User = LocalPlayer.Name;
local DisplayName = LocalPlayer.DisplayName;
local PlayerId = LocalPlayer.UserId;

-- Config path
local Folder = "Pwans/Config/" .. User .. ".json";

-- Config
Env_.Configs = {};

Save = function(key, value)
	if key ~= nil then
		Env_.Configs[key] = value;
	end;
	if not isfolder("Pwans") then
		makefolder("Pwans");
	end;
	writefile(Folder, HttpService:JSONEncode(Env_.Configs));
end;

Load = function()
	if not isfile(Folder) then Save(); end;
	return HttpService:JSONDecode(readfile(Folder));
end;

Default = function(v, a)
	if type(v) == "table" then
		for i, k in pairs(v) do
			if Env_.Configs[i] == nil then
				Env_.Configs[i] = k;
			end;
		end;
	else
		if Env_.Configs[v] == nil then
			Env_.Configs[v] = a;
		end;
	end;
end;

DeleteSettings = function()
	if isfile(Folder) then
		delfile(Folder);
	end;
end;

-- local Gears = {
	-- "Friendship Pot",
	-- "Harvest Tool",
    -- "Favorite Tool",
	-- "Cleaning Spray",
	-- "Tanning Mirror",
    -- "Watering Can",
    -- "Recall Wrench",
    -- "Trowel",
    -- "Basic Sprinkler",
    -- "Advanced Sprinkler",
    -- "Godly Sprinkler",
    -- "Master Sprinkler"
-- }

function ufav()
    local player = game:GetService("Players").LocalPlayer
    local char = player.Character
    local backpack = player.Backpack
    local tool = char:FindFirstChildOfClass("Tool") or backpack:FindFirstChildOfClass("Tool")

    if tool and tool:GetAttribute("Favorite") == true then
        game:GetService("ReplicatedStorage").GameEvents.Favorite_Item:FireServer({tool})
    end
end

local function KeysOf(dict)
    local list = {}
    for k, v in pairs(dict) do
        if v then
            table.insert(list, k)
        end
    end
    return list
end

local function GetGearShop()
    local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    local gearShopGui = playerGui:WaitForChild("Gear_Shop")
    local gearsFrame = gearShopGui:WaitForChild("Frame"):WaitForChild("ScrollingFrame")

    local gearList = {}

    for _, gearFrame in pairs(gearsFrame:GetChildren()) do
        if gearFrame:IsA("Frame") then
            local mainFrame = gearFrame:FindFirstChild("Main_Frame")
            if mainFrame then
                local gearText = mainFrame:FindFirstChild("Gear_Text")
                if gearText and gearText:IsA("TextLabel") then
                    table.insert(gearList, gearText.Text)
					table.sort(gearList)
                end
            end
        end
    end
    return gearList
end

local Gears = GetGearShop()

Config = function() return Env_.Configs;end;

Env_.Configs = Load()

local ui = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local win = ui:CreateWindow({
    Title = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
    Icon = "rbxassetid://129260712070622",
    IconThemed = true,
    Author = "by Pwans",
    Folder = "",
    Size = UDim2.fromOffset(580, 400),
    Transparent = false,
    Theme = "Dark",
    SideBarWidth = 160,
    HideSearchBar = true, -- hides searchbar
    ScrollBarEnabled = true -- enables scrollbar
})

-- Shop Tab
local Shop = win:Tab({Title = "Shop",Icon = "shopping-cart",})

Default('Selected Gears', {})

Shop:Dropdown({
    Title = "Select Gear",
    Values = Gears,
    Value = Config()['Selected Gears'],
    Multi = true,
    AllowNone = true,
    Callback = function(v) 
		Config()['Selected Gears'] = KeysOf(v)
		Save('Selected Gears', v)
    end
})

Default('Auto Buy Gears', false)

Shop:Toggle({
    Title = "Buy Gears",
    Type = "Checkbox",
    Default = Config()['Auto Buy Gears'],
    Callback = function(v)
		Config()['Auto Buy Gears'] = v
		Save('Auto Buy Gears', v)
		while Config()['Auto Buy Gears'] do
			pcall(function()
				local DataService = require(game:GetService("ReplicatedStorage").Modules.DataService)
				local playerData = DataService:GetData()
				
				if playerData and playerData.GearStock and playerData.GearStock.Stocks then
					for itemName, stockData in pairs(playerData.GearStock.Stocks) do
						if table.find(Config()['Selected Gears'], itemName) and stockData.Stock > 0 then
							local stockAmount = stockData.Stock
							for i = 1, stockAmount do
								game:GetService("ReplicatedStorage").GameEvents.BuyGearStock:FireServer(itemName)
								
								local updatedData = DataService:GetData()
								if updatedData and updatedData.GearStock and 
								   updatedData.GearStock.Stocks[itemName] then
									local newStock = updatedData.GearStock.Stocks[itemName].Stock
									if newStock < stockAmount then
										stockAmount = newStock
										if stockAmount == 0 then break end
									else
										task.wait()
										break
									end
								end
								task.wait(0.25)
							end
							
						end
					end
				end
			end)
			task.wait(0.75)
		end
    end
})

Shop:Divider()
Default('Auto Buy Seeds', false)

Shop:Toggle({
    Title = "Buy All Seeds",
    Type = "Checkbox",
    Default = Config()['Auto Buy Seeds'],
    Callback = function(v)
		Config()['Auto Buy Seeds'] = v
		Save('Auto Buy Seeds', v)
		while Config()['Auto Buy Seeds'] do
			pcall(function()
				local DataService = require(game:GetService("ReplicatedStorage").Modules.DataService)
				local SeedData = require(game:GetService("ReplicatedStorage").Data.SeedData)
				local playerData = DataService:GetData()
				
				if playerData and playerData.SeedStock and playerData.SeedStock.Stocks then
					for seedName, stockData in pairs(playerData.SeedStock.Stocks) do
						if stockData.Stock > 0 then
							local stockAmount = stockData.Stock
							for i = 1, stockAmount do
								game:GetService("ReplicatedStorage").GameEvents.BuySeedStock:FireServer(seedName)
								
								local updatedData = DataService:GetData()
								if updatedData and updatedData.SeedStock and 
								   updatedData.SeedStock.Stocks[itemName] then
									local newStock = updatedData.SeedStock.Stocks[itemName].Stock
									if newStock < stockAmount then
										stockAmount = newStock
										if stockAmount == 0 then break end
									else
										task.wait()
										break
									end
								end
								task.wait(0.25)
							end
						end
					end
				end
			end)
			task.wait(0.75)
		end
    end
})

Shop:Divider()
Default('Auto Buy Eggs', false)

Shop:Toggle({
    Title = "Buy All Eggs",
    Type = "Checkbox",
    Default = Config()['Auto Buy Eggs'],
    Callback = function(v)
		Config()['Auto Buy Eggs'] = v
		Save('Auto Buy Eggs', v)
		while Config()['Auto Buy Eggs'] do
			pcall(function()
				local DataService = require(game:GetService("ReplicatedStorage").Modules.DataService)
				local playerData = DataService:GetData()

				if playerData and playerData.PetEggStock and playerData.PetEggStock.Stocks then
					for eggIndex, eggData in pairs(playerData.PetEggStock.Stocks) do
						if eggData.Stock > 0 then
							local stockAmount = eggData.Stock
							for i = 1, stockAmount do
								game:GetService("ReplicatedStorage").GameEvents.BuyPetEgg:FireServer(eggIndex)
								
								local updatedData = DataService:GetData()
								if updatedData and updatedData.PetEggStock and 
								   updatedData.PetEggStock.Stocks[eggIndex] then
									local newStock = updatedData.PetEggStock.Stocks[eggIndex].Stock
									if newStock < stockAmount then
										stockAmount = newStock
										if stockAmount == 0 then break end
									else
										task.wait()
										break
									end
								end
								task.wait(0.25)
							end
						end
					end
				end
			end)
			task.wait(0.75)
		end
    end
})

local ItemsOrdered = {}

local Event = win:Tab({Title = "Event",Icon = "calendar",})

Event:Toggle({
	Title = "Auto Honey",
	Type = "Checkbox",
	Default = false,
	Callback = function(v)
		Config()['Auto Honey'] = v

		if not v then return end

		local player = game:GetService("Players").LocalPlayer

		local function temPollinated(nome)
			return nome:lower():find("pollinated") ~= nil
		end

		-- Updates the list of items sorted by weight
		task.spawn(function()
			while Config()['Auto Honey'] do
				local novaLista = {}
				local char = player.Character or player.CharacterAdded:Wait()
				local mochila = player:FindFirstChild("Backpack")

				for _, container in ipairs({char, mochila}) do
					if container then
						for _, item in ipairs(container:GetChildren()) do
							if item:IsA("Tool") and temPollinated(item.Name) then
								local weightObj = item:FindFirstChild("Weight")
								if weightObj and weightObj:IsA("NumberValue") then
									table.insert(novaLista, {Tool = item, Weight = weightObj.Value})
								end
							end
						end
					end
				end

				table.sort(novaLista, function(a, b)
					return a.Weight < b.Weight
				end)

				ItemsOrdered = novaLista
				task.wait(2)
			end
		end)

		-- Machine interaction
		task.spawn(function()
			while Config()['Auto Honey'] do
				local char = player.Character or player.CharacterAdded:Wait()
				local humanoid = char:FindFirstChildOfClass("Humanoid")
				local label

				pcall(function()
					label = workspace.HoneyEvent.HoneyCombpressor.Sign.SurfaceGui.TextLabel
				end)

				local listaLocal = table.clone(ItemsOrdered)

				for _, itemData in ipairs(listaLocal) do
					if not Config()['Auto Honey'] then break end
					local tool = itemData.Tool
					if tool and tool.Parent and label then
						local texto = label.Text
						if texto == "READY" or texto:match("^%d*%.?%d+/10 KG$") then

							if tool.Parent == player.Backpack or tool.Parent == player.Character then
								local sucesso, erro = pcall(function()
									humanoid:EquipTool(tool)
								end)

								if sucesso then
									task.wait(0.1)
									ufav()
									game:GetService("ReplicatedStorage").GameEvents.HoneyMachineService_RE:FireServer("MachineInteract")
									task.wait(0.6)
								end
							end

						end
					end
				end

				task.wait(0.5)
			end
		end)
	end
})

print(string.format('Pwans Hub Loaded in %.2f second(s)!', tick() - StartTick))

ui:Notify({
	Title = "Pwans Hub",
	Content = string.format('Pwans Hub Loaded in %.2f second(s)!', tick() - StartTick),
	Duration = 5,
})
