if game:GetService("CoreGui"):FindFirstChild("SpringGui") then
	game:GetService("CoreGui"):FindFirstChild("SpringGui"):Destroy()
end

local Gui

Gui = {
	Data = {
		SetInteractionsEnabled = function(Value)
			Gui.InteractionsEnabled = Value or false
		end,
		SetTheme = function(t1,t2)
			Gui.Theme = t1; Gui.Theme2 = t2
		end,
	},
	Theme = nil,
	Theme2 = nil,
	InteractionsEnabled = true,
	FocusedDropdown = nil
}

do
	Gui.Flags = {}

	local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

	local Signal = {}
	Signal.__index = Signal
	Signal.ClassName = "Signal"

	-- Constructor
	function Signal.new()
		return setmetatable(
			{
				_bindable = Instance.new("BindableEvent"),
				_args = nil,
				_argCount = nil -- To stay true to _args, even when some indexes are nil
			},
			Signal
		)
	end

	function Signal:Fire(...)
		-- I use this method of arguments because when passing it in a bindable event, it creates a deep copy which makes it slower
		self._args = {...}
		self._argCount = select("#", ...)
		self._bindable:Fire()
	end

	function Signal:fire(...)
		return self:Fire(...)
	end

	function Signal:Connect(handler)
		if not (type(handler) == "function") then
			error(("connect(%s)"):format(typeof(handler)), 2)
		end
		return self._bindable.Event:Connect(
			function()
				handler(unpack(self._args, 1, self._argCount))
			end
		)
	end

	function Signal:connect(...)
		return self:Connect(...)
	end

	function Signal:Wait()
		self._bindableEvent.Event:Wait()
		assert(self._argData, "Missing argument data, likely due to :TweenSize/Position corrupting.")
		return unpack(self._args, 1, self._argCount)
	end

	function Signal:wait()
		return self:Wait()
	end

	function Signal:Remove()
		if self._bindable then
			self._bindable:Remove()
			self._bindable = nil
		end
		self._args = nil
		self._argCount = nil
		setmetatable(self, nil)
	end

	function Signal:Remove()
		return self:Remove()
	end

	local function HasProperty(Instance, Property)
		return pcall(
			function()
				local A = Instance[Property]
			end
		)
	end

	local function dragify(Frame)
		local dragToggle = nil
		local dragSpeed = .25
		local dragInput = nil
		local dragStart = nil
		local dragPos = nil
		local startPos = nil

		local function updateInput(input)
			local Delta = input.Position - dragStart
			local Position =
				UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
			game:GetService("TweenService"):Create(Frame, TweenInfo.new(.25), {Position = Position}):Play()
		end

		Frame.InputBegan:Connect(
			function(input)
				if
					(input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
				then
					dragToggle = true
					dragStart = input.Position
					startPos = Frame.Position
					input.Changed:Connect(
						function()
							if (input.UserInputState == Enum.UserInputState.End) then
								dragToggle = false
							end
						end
					)
				end
			end
		)

		Frame.InputChanged:Connect(
			function(input)
				if
					(input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch)
				then
					dragInput = input
				end
			end
		)

		game:GetService("UserInputService").InputChanged:Connect(
		function(input)
			if (input == dragInput and dragToggle) then
				updateInput(input)
			end
		end
		)
	end

	Gui.CreateGui = function(self, AssignedGuiName, GuiSet)
		if type(GuiSet) ~= "table" then
			GuiSet = {}
		end
		GuiSet = GuiSet or {}
		GuiSet.Theme = GuiSet.Theme or Color3.fromRGB(0, 255, 0)
		GuiSet.Theme2 = GuiSet.Theme2 or Color3.fromRGB(0, 204, 0)
		Gui.Data.SetTheme(GuiSet.Theme,GuiSet.Theme2)
		local CreatedGui = {}

		local SpringGui = Instance.new("ScreenGui")
		SpringGui.Name = "SpringGui"
		SpringGui.DisplayOrder = 1

		local function SetHui()
			SpringGui.Parent = gethui()
		end

		while not pcall(SetHui) do
			wait(0.01)
		end

		CreatedGui.Toggle = function()
			SpringGui.Enabled = not SpringGui.Enabled
		end

		local Main = Instance.new("Frame")
		Main.Name = "Main"
		Main.AnchorPoint = Vector2.new(0.5, 0.5)
		Main.ZIndex = 0
		Main.Size = UDim2.new(0, 291, 0, 279)
		Main.BorderColor3 = Color3.fromRGB(195, 195, 195)
		Main.BackgroundTransparency = 1
		Main.Position = UDim2.new(0.5, 0, 0.5, 0)
		Main.Active = true
		Main.BorderSizePixel = 0
		Main.BackgroundColor3 = Color3.fromRGB(135, 37, 202)
		Main.Parent = SpringGui

		local Main1 = Instance.new("Frame")
		Main1.Name = "Main"
		Main1.ZIndex = 0
		Main1.Size = UDim2.new(1, -2, 1, -10)
		Main1.Position = UDim2.new(0, 1, 0, 9)
		Main1.BorderSizePixel = 0
		Main1.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
		Main1.Parent = Main

		local UICorner = Instance.new("UICorner")
		UICorner.Parent = Main1

		local Top = Instance.new("Frame")
		Top.Name = "Top"
		Top.AnchorPoint = Vector2.new(0.5, 0)
		Top.Size = UDim2.new(1, -20, 0, 30)
		Top.Position = UDim2.new(0.5, 0, 0, 34)
		Top.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
		Top.Parent = Main1

		local UICorner1 = Instance.new("UICorner")
		UICorner1.CornerRadius = UDim.new(0, 6)
		UICorner1.Parent = Top

		local Frame = Instance.new("Frame")
		Frame.AnchorPoint = Vector2.new(0.5, 0.5)
		Frame.Size = UDim2.new(1, -2, 1, -2)
		Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
		Frame.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
		Frame.Parent = Top

		local UICorner2 = Instance.new("UICorner")
		UICorner2.CornerRadius = UDim.new(0, 6)
		UICorner2.Parent = Frame

		local ScrollingFrame = Instance.new("ScrollingFrame")
		ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
		ScrollingFrame.BackgroundTransparency = 1
		ScrollingFrame.Active = true
		ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
		ScrollingFrame.ScrollBarThickness = 0
		ScrollingFrame.Parent = Frame

		local UIListLayout = Instance.new("UIListLayout")
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 3)
		UIListLayout.Parent = ScrollingFrame
		game:GetService("RunService").Heartbeat:Connect(function()
			ScrollingFrame.CanvasSize = UDim2.fromOffset(UIListLayout.AbsoluteContentSize.X + 8, 0)
		end
		)

		local Content = Instance.new("Frame")
		Content.Name = "Content"
		Content.AnchorPoint = Vector2.new(0.5, 0)
		Content.Size = UDim2.new(1, -20, 1, -78)
		Content.Position = UDim2.new(0.5, 0, 0, 68)
		Content.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
		Content.Parent = Main1

		local UICorner5 = Instance.new("UICorner")
		UICorner5.CornerRadius = UDim.new(0, 6)
		UICorner5.Parent = Content

		local Inner = Instance.new("Frame")
		Inner.Name = "Inner"
		Inner.AnchorPoint = Vector2.new(0.5, 0.5)
		Inner.Size = UDim2.new(1, -2, 1, -2)
		Inner.Position = UDim2.new(0.5, 0, 0.5, 0)
		Inner.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		Inner.Parent = Content

		local UICorner6 = Instance.new("UICorner")
		UICorner6.CornerRadius = UDim.new(0, 6)
		UICorner6.Parent = Inner

		CreatedGui.CreateTab = function(self, Name)
			Name = Name or "..."
			local CreatedTab = {}
			local UIPadding = Instance.new("UIPadding")
			UIPadding.PaddingTop = UDim.new(0, 3)
			UIPadding.PaddingBottom = UDim.new(0, 3)
			UIPadding.PaddingLeft = UDim.new(0, 3)
			UIPadding.PaddingRight = UDim.new(0, 3)
			UIPadding.Parent = ScrollingFrame

			local Tab2 = Instance.new("ScrollingFrame")
			Tab2.Name = Name
			Tab2.AnchorPoint = Vector2.new(0.5, 0.5)
			Tab2.Size = UDim2.new(1, -12, 1, -12)
			Tab2.BackgroundTransparency = 1
			Tab2.Position = UDim2.new(0.5, 0, 0.5, 0)
			Tab2.Active = true
			Tab2.Visible = false
			Tab2.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
			Tab2.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
			Tab2.ScrollBarImageTransparency = 1
			Tab2.ScrollBarThickness = 0
			Tab2.Parent = Inner

			local Tab = Instance.new("TextButton")
			Tab.Name = Name
			Tab.Size = UDim2.new(0, 50, 1, 0)
			Tab.BackgroundTransparency = 0.975
			Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Tab.FontSize = Enum.FontSize.Size14
			Tab.TextSize = 14
			Tab.TextColor3 = Gui.Theme2
			Tab.Text = Name
			Tab.Font = Enum.Font.SourceSans
			Tab.Parent = ScrollingFrame
			Tab.TouchTap:Connect(
				function()
					CreatedTab:SetDefault()
				end
			)
			game:GetService"RunService".Heartbeat:Connect(
				function()
					Tab.Size = UDim2.new(0, Tab.TextBounds.X + 16, 1, 0)
				end
			)

			local Border = Instance.new("Frame")
			Border.Name = "Border"
			Border.ZIndex = -1
			Border.Size = UDim2.new(1, 2, 1, 2)
			Border.Position = UDim2.fromScale(0.5,0.5)
			Border.AnchorPoint = Vector2.new(0.5,0.5)
			Border.BorderSizePixel = 0
			Border.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			Border.Parent = Tab

			local UICorner3 = Instance.new("UICorner")
			UICorner3.CornerRadius = UDim.new(0, 6)
			UICorner3.Parent = Tab

			local UICorner32 = Instance.new("UICorner")
			UICorner32.CornerRadius = UDim.new(0, 6)
			UICorner32.Parent = Border

			local Left = Instance.new("Frame")
			Left.Name = "Left"
			Left.Size = UDim2.new(0.5, -2, 1, 0)
			Left.BackgroundTransparency = 1
			Left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Left.Parent = Tab2

			local UIListLayout1 = Instance.new("UIListLayout")
			UIListLayout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout1.Padding = UDim.new(0, 3)
			UIListLayout1.Parent = Left

			local Right = Instance.new("Frame")
			Right.Name = "Right"
			Right.AnchorPoint = Vector2.new(1, 0)
			Right.Size = UDim2.new(0.5, -2, 1, 0)
			Right.BackgroundTransparency = 1
			Right.Position = UDim2.new(1, 0, 0, 0)
			Right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Right.Parent = Tab2

			local UIListLayout6 = Instance.new("UIListLayout")
			UIListLayout6.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout6.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout6.Padding = UDim.new(0, 3)
			UIListLayout6.Parent = Right

			game:GetService"RunService".Heartbeat:Connect(function()
				Tab2.CanvasSize = UDim2.fromOffset(0, UIListLayout1.AbsoluteContentSize.Y + 4 >= UIListLayout6.AbsoluteContentSize.Y and UIListLayout1.AbsoluteContentSize.Y + 4 or UIListLayout6.AbsoluteContentSize.Y + 4)
			end)

			game:GetService"RunService".Heartbeat:Connect(function()
				Tab2.CanvasSize = UDim2.fromOffset(0, UIListLayout1.AbsoluteContentSize.Y + 4 >= UIListLayout6.AbsoluteContentSize.Y and UIListLayout1.AbsoluteContentSize.Y + 4 or UIListLayout6.AbsoluteContentSize.Y + 4)
			end)

			CreatedTab.SetDefault = function(self)
				Tab.BackgroundTransparency = 0.95
				Tab.TextColor3 = Gui.Theme
				table.foreachi(
					Inner:GetChildren(),
					function(i, v)
						if v ~= Tab2 and v:IsA("ScrollingFrame") then
							v.Visible = false
						end
					end
				)
				table.foreachi(
					ScrollingFrame:GetChildren(),
					function(i, v)
						if v ~= Tab and v:IsA("TextButton") then
							v.BackgroundTransparency = 0.975
							v.TextColor3 = Gui.Theme2
						end
					end
				)
				Tab2.Visible = true
				return CreatedTab
			end

			CreatedTab.CreateSection = function(self, SecetionName, Side)
				Side = Side and Side:lower() or "left"
				local CreatedSection = {}
				local Section = Instance.new("Frame")
				Section.Name = "Section"
				Section.Size = UDim2.new(1, 0, 0, 116)
				Section.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
				Section.Parent = Side == "left" and Left or Side == "right" and Right or Left

				local Inner1 = Instance.new("Frame")
				Inner1.Name = "Inner"
				Inner1.AnchorPoint = Vector2.new(0.5, 0.5)
				Inner1.Size = UDim2.new(1, -2, 1, -2)
				Inner1.Position = UDim2.new(0.5, 0, 0.5, 0)
				Inner1.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
				Inner1.Parent = Section

				local UICorner7 = Instance.new("UICorner")
				UICorner7.CornerRadius = UDim.new(0, 4)
				UICorner7.Parent = Inner1

				local SectionName = Instance.new("TextLabel")
				SectionName.Name = "SectionName"
				SectionName.AnchorPoint = Vector2.new(1, 0)
				SectionName.Size = UDim2.new(1, -8, 0, 24)
				SectionName.BackgroundTransparency = 1
				SectionName.Position = UDim2.new(1, 0, 0, 8)
				SectionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SectionName.FontSize = Enum.FontSize.Size14
				SectionName.TextSize = 14
				SectionName.TextColor3 = Gui.Theme
				SectionName.Text = SecetionName or "Section"
				SectionName.TextYAlignment = Enum.TextYAlignment.Top
				SectionName.TextWrapped = true
				SectionName.Font = Enum.Font.SourceSansBold
				SectionName.TextWrap = true
				SectionName.TextXAlignment = Enum.TextXAlignment.Left
				SectionName.Parent = Inner1

				local SectionContent = Instance.new("Frame")
				SectionContent.Name = "SectionContent"
				SectionContent.AnchorPoint = Vector2.new(0.5, 1)
				SectionContent.Size = UDim2.new(1, -12, 1, -40)
				SectionContent.BackgroundTransparency = 1
				SectionContent.Position = UDim2.new(0.5, 0, 1, -6)
				SectionContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SectionContent.Parent = Inner1

				local UIListLayout2 = Instance.new("UIListLayout")
				UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout2.Padding = UDim.new(0, 3)
				UIListLayout2.Parent = SectionContent
				game:GetService"RunService".Heartbeat:Connect(
					function()
						Section.Size =
							UDim2.new(1, 0, 0, UIListLayout2.AbsoluteContentSize.Y + 20 + SectionName.AbsoluteSize.Y)
					end
				)

				CreatedSection.CreateButton = function(self, Name, Callback)
					Callback = Callback or function()
					end
					local Button = Instance.new("Frame")
					Button.Name = "Button"
					Button.Size = UDim2.new(1, 0, 0, 23)
					Button.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
					Button.Parent = SectionContent
					Button.ClipsDescendants = true

					local UICorner8 = Instance.new("UICorner")
					UICorner8.CornerRadius = UDim.new(0, 4)
					UICorner8.Parent = Button

					local TextButton = Instance.new("TextButton")
					TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
					TextButton.Size = UDim2.new(1, -2, 1, -2)
					TextButton.Position = UDim2.new(0.5, 0, 0.5, 0)
					TextButton.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
					TextButton.AutoButtonColor = false
					TextButton.FontSize = Enum.FontSize.Size9
					TextButton.Text = Name or "Button"
					TextButton.TextSize = 12
					TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
					TextButton.TextWrapped = true
					TextButton.Font = Enum.Font.SourceSans
					TextButton.Parent = Button
					TextButton.ClipsDescendants = true

					local Sample = Instance.new("ImageLabel")
					Sample.Name = "Sample"
					Sample.BackgroundTransparency = 1
					Sample.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Sample.ImageTransparency = 0.65
					Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
					Sample.Parent = TextButton

					TextButton.MouseEnter:Connect(
						function()
							game:GetService("TweenService"):Create(
							TextButton,
							TweenInfo.new(0.22),
							{
								TextColor3 = Gui.Theme
							}
							):Play()
						end
					)
					TextButton.MouseLeave:Connect(
						function()
							game:GetService("TweenService"):Create(
							TextButton,
							TweenInfo.new(0.22),
							{
								TextColor3 = Color3.fromRGB(255, 255, 255)
							}
							):Play()
						end
					)

					TextButton.TouchTap:Connect(
						function()
							if Gui.InteractionsEnabled ~= true then
								return
							end
							spawn(
								function()
									game:GetService("TweenService"):Create(
									TextButton,
									TweenInfo.new(0.1),
									{
										TextSize = 8
									}
									):Play()
									wait(0.1)
									game:GetService("TweenService"):Create(
									TextButton,
									TweenInfo.new(0.1),
									{
										TextSize = 12
									}
									):Play()

									local c = Sample:Clone()
									c.Parent = Button
									c.Position = UDim2.new(0.5, 0, 0.5, 0)
									local len, size = 0.75, nil
									if Button.AbsoluteSize.X >= Button.AbsoluteSize.Y then
										size = (Button.AbsoluteSize.X * 1.5)
									else
										size = (Button.AbsoluteSize.Y * 1.5)
									end
									c:TweenSizeAndPosition(
										UDim2.new(0, size, 0, size),
										UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)),
										"Out",
										"Quad",
										len,
										true,
										nil
									)
									for i = 1, 10 do
										c.ImageTransparency = c.ImageTransparency + 0.05
										wait(len / 12)
									end
									c:Remove()
								end
							)
							Callback()
						end
					)

					local UICorner9 = Instance.new("UICorner")
					UICorner9.CornerRadius = UDim.new(0, 4)
					UICorner9.Parent = TextButton
				end

				CreatedSection.CreateTextbox = function(self, Name, Callback, Settings)
					Name = Name or "..."
					Callback = Callback or function()
					end
					Settings = Settings or {}
					Settings.RememberLastText = Settings.RememberLastText == nil and true or Settings.RememberLastText

					local PreviousText = Settings.Text or "..."

					local Textbox = Instance.new("Frame")
					Textbox.Name = "Textbox"
					Textbox.Size = UDim2.new(1, 0, 0, 23)
					Textbox.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
					Textbox.Parent = SectionContent

					local UICorner = Instance.new("UICorner")
					UICorner.CornerRadius = UDim.new(0, 4)
					UICorner.Parent = Textbox

					local Inner = Instance.new("Frame")
					Inner.Name = "Inner"
					Inner.AnchorPoint = Vector2.new(0.5, 0.5)
					Inner.Size = UDim2.new(1, -2, 1, -2)
					Inner.Position = UDim2.new(0.5, 0, 0.5, 0)
					Inner.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
					Inner.Parent = Textbox

					local UICorner1 = Instance.new("UICorner")
					UICorner1.CornerRadius = UDim.new(0, 4)
					UICorner1.Parent = Inner

					local TextBox = Instance.new("TextBox")
					TextBox.AnchorPoint = Vector2.new(1, 0)
					TextBox.Size = UDim2.new(1, -6, 1, 0)
					TextBox.ClipsDescendants = true
					TextBox.BackgroundTransparency = 1
					TextBox.Position = UDim2.new(1, 0, 0, 0)
					TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					TextBox.FontSize = Enum.FontSize.Size10
					TextBox.TextStrokeTransparency = 0.75
					TextBox.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
					TextBox.TextSize = 12
					TextBox.TextColor3 = Gui.Theme
					TextBox.Text = Settings.Text or "..."
					TextBox.PlaceholderText = Settings.Text
					TextBox.CursorPosition = -1
					TextBox.Font = Enum.Font.Code
					TextBox.TextXAlignment = Enum.TextXAlignment.Left
					TextBox.Parent = Inner
					TextBox.Focused:Connect(
						function()
							if Gui.InteractionsEnabled ~= true then
								TextBox.TextEditable = false
								return
							else
								TextBox.TextEditable = true
							end
						end
					)
					TextBox.FocusLost:Connect(
						function()
							if TextBox.Text == "" then
								TextBox.Text = PreviousText or "..."
							else
								PreviousText = TextBox.Text
							end
							if TextBox.Text ~= "" then
								Callback(TextBox.Text)
							end
						end
					)
				end

				CreatedSection.CreateToggle = function(self, Name, Callback, Settings)
					Callback = Callback or function()
					end
					Settings = Settings or {}
					Settings.Enabled = Settings.Enabled or false
					if Settings.Flag then
						Gui.Flags[Settings.Flag] = {
							Enabled = false,
							Changed = Signal.new()
						}
					end
					local CreatedToggle = {}
					local Toggle = Instance.new("TextButton")
					Toggle.Name = "Toggle"
					Toggle.AnchorPoint = Vector2.new(0.5, 0.5)
					Toggle.Size = UDim2.new(1, 0, 0, 23)
					Toggle.BackgroundTransparency = 1
					Toggle.Position = UDim2.new(0.5, 0, 0.5, 0)
					Toggle.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
					Toggle.AutoButtonColor = false
					Toggle.FontSize = Enum.FontSize.Size9
					Toggle.TextSize = 12
					Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
					Toggle.Text = ""
					Toggle.Font = Enum.Font.SourceSans
					Toggle.Parent = SectionContent

					local Toggle1 = Instance.new("Frame")
					Toggle1.Name = "Toggle"
					Toggle1.Size = UDim2.new(0, 23, 0, 23)
					Toggle1.BackgroundColor3 = Settings.Enabled and Gui.Theme or Color3.fromRGB(37, 37, 37)
					Toggle1.Parent = Toggle

					local UICorner10 = Instance.new("UICorner")
					UICorner10.CornerRadius = UDim.new(0, 4)
					UICorner10.Parent = Toggle1

					local Toggle2 = Instance.new("Frame")
					Toggle2.Name = "Toggle"
					Toggle2.AnchorPoint = Vector2.new(0.5, 0.5)
					Toggle2.Size = UDim2.new(1, -2, 1, -2)
					Toggle2.Position = UDim2.new(0.5, 0, 0.5, 0)
					Toggle2.BackgroundColor3 = Settings.Enabled and Gui.Theme2 or Color3.fromRGB(21, 21, 21)
					Toggle2.Parent = Toggle1

					local ImageLabel = Instance.new("ImageLabel")
					ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
					ImageLabel.Size = UDim2.new(1, -4, 1, -4)
					ImageLabel.BackgroundTransparency = 1
					ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
					ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					ImageLabel.Image = "rbxassetid://8589545938"
					ImageLabel.ImageTransparency = Settings.Enabled and 0 or 1
					ImageLabel.Parent = Toggle2

					local UICorner11 = Instance.new("UICorner")
					UICorner11.CornerRadius = UDim.new(0, 4)
					UICorner11.Parent = Toggle2

					local TextLabel = Instance.new("TextLabel")
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.BackgroundTransparency = 1
					TextLabel.Position = UDim2.new(0, 30, 0, 0)
					TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					TextLabel.FontSize = Enum.FontSize.Size10
					TextLabel.TextSize = 12
					TextLabel.TextColor3 = Settings.Enabled and Gui.Theme or Color3.fromRGB(255, 255, 255)
					TextLabel.Text = Name or "Toggle"
					TextLabel.Font = Enum.Font.SourceSans
					TextLabel.TextXAlignment = Enum.TextXAlignment.Left
					TextLabel.Parent = Toggle

					CreatedToggle.Fire = function()
						if getgc ~= nil then
							for i, v in getgc(true) do
								--if v == CreatedToggle then
								--print('found')
								--CreatedToggle = v
								--else
								--end
							end
						end
						if Gui.InteractionsEnabled ~= true then
							return
						end
						Settings.Enabled = not Settings.Enabled
						if Gui.Flags[Settings.Flag] then
							Gui.Flags[Settings.Flag].Enabled = Settings.Enabled
							Gui.Flags[Settings.Flag].Changed:Fire(Settings.Enabled)
						end
						spawn(
							function()
								game:GetService("TweenService"):Create(
								Toggle1,
								TweenInfo.new(0.3),
								{
									BackgroundColor3 = Settings.Enabled and Gui.Theme or Color3.fromRGB(37, 37, 37)
								}
								):Play()
								game:GetService("TweenService"):Create(
								Toggle2,
								TweenInfo.new(0.3),
								{
									BackgroundColor3 = Settings.Enabled and Gui.Theme2 or Color3.fromRGB(21, 21, 21)
								}
								):Play()
								game:GetService("TweenService"):Create(
								ImageLabel,
								TweenInfo.new(0.3),
								{
									ImageTransparency = Settings.Enabled and 0 or 1
								}
								):Play()
								game:GetService("TweenService"):Create(
								TextLabel,
								TweenInfo.new(0.3),
								{
									TextColor3 = Settings.Enabled and Gui.Theme or Color3.fromRGB(255, 255, 255)
								}
								):Play()
							end
						)
						Callback(Settings.Enabled)
					end
					Toggle.TouchTap:Connect(CreatedToggle.Fire)
					return CreatedToggle
				end

				local Line = Instance.new("Frame")
				Line.Name = "Line"
				Line.AnchorPoint = Vector2.new(0.5, 0)
				Line.Size = UDim2.new(1, -8, 0, 1)
				Line.Position = UDim2.new(0.5, 0, 0, 26)
				Line.BorderSizePixel = 0
				Line.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
				Line.Parent = Inner1

				local UICorner14 = Instance.new("UICorner")
				UICorner14.CornerRadius = UDim.new(0, 4)
				UICorner14.Parent = Section

				CreatedSection.CreateDividor = function(self, Size)
					local Divider = Instance.new("Frame")
					Divider.Name = "Divider"
					Divider.Size = UDim2.new(1, 0, 0, Size or 7)
					Divider.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
					Divider.Transparency = 1
					Divider.Parent = SectionContent

					local UICorner = Instance.new("UICorner")
					UICorner.CornerRadius = UDim.new(0, 4)
					UICorner.Parent = Divider

					local Inner = Instance.new("Frame")
					Inner.Name = "Inner"
					Inner.AnchorPoint = Vector2.new(0.5, 0.5)
					Inner.Size = UDim2.new(1, -2, 1, -2)
					Inner.Position = UDim2.new(0.5, 0, 0.5, 0)
					Inner.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
					Inner.Transparency = 1
					Inner.Parent = Divider

					local UICorner1 = Instance.new("UICorner")
					UICorner1.CornerRadius = UDim.new(0, 4)
					UICorner1.Parent = Inner
				end

				CreatedSection.CreateTextlabel = function(self,FirstText)
					local CreatedTextlabel = {}
					local Text = Instance.new("Frame")
					Text.Name = "Text"
					Text.Size = UDim2.new(1, 0, 0, 26)
					Text.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
					Text.Parent = SectionContent
					local UICorner = Instance.new("UICorner")
					UICorner.CornerRadius = UDim.new(0, 4)
					UICorner.Parent = Text

					local Inner = Instance.new("Frame")
					Inner.Name = "Inner"
					Inner.AnchorPoint = Vector2.new(0.5, 0.5)
					Inner.Size = UDim2.new(1, -2, 1, -2)
					Inner.Position = UDim2.new(0.5, 0, 0.5, 0)
					Inner.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
					Inner.Parent = Text

					local UICorner1 = Instance.new("UICorner")
					UICorner1.CornerRadius = UDim.new(0, 4)
					UICorner1.Parent = Inner

					local TextLabel = Instance.new("TextLabel")
					TextLabel.AnchorPoint = Vector2.new(0, 0.5)
					TextLabel.Size = UDim2.new(1, -7, 1, 0)
					TextLabel.BackgroundTransparency = 1
					TextLabel.Position = UDim2.new(0, 7, 0.5, 0)
					TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					TextLabel.FontSize = Enum.FontSize.Size10
					TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
					TextLabel.TextSize = 12
					TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					TextLabel.Text = FirstText or "..."
					TextLabel.RichText = true
					TextLabel.Font = Enum.Font.SourceSans
					TextLabel.TextXAlignment = Enum.TextXAlignment.Left
					TextLabel.Parent = Inner
					CreatedTextlabel.Set = function(self,New)
						TextLabel.Text = New or "..."
					end
					CreatedTextlabel.SetColor = function(self,New)
						TextLabel.TextColor3 = New
					end
					return CreatedTextlabel
				end

				CreatedSection.CreateSlider = function(self, Name, Callback, Settings)
					Callback = Callback or function()
					end
					Settings = Settings or {}
					Settings.Min = Settings.Min or 0
					Settings.Max = Settings.Max or 100
					Settings.Value = Settings.Value or 50
					local CreatedSlider = {}
					local Slider = Instance.new("Frame")
					Slider.Name = "Slider"
					Slider.Size = UDim2.new(1, 0, 0, 46)
					Slider.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
					Slider.Parent = SectionContent

					local UICorner30 = Instance.new("UICorner")
					UICorner30.CornerRadius = UDim.new(0, 4)
					UICorner30.Parent = Slider

					local TextButton10 = Instance.new("TextButton")
					TextButton10.AnchorPoint = Vector2.new(0.5, 0.5)
					TextButton10.Size = UDim2.new(1, -2, 1, -2)
					TextButton10.Position = UDim2.new(0.5, 0, 0.5, 0)
					TextButton10.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
					TextButton10.AutoButtonColor = false
					TextButton10.FontSize = Enum.FontSize.Size9
					TextButton10.TextSize = 12
					TextButton10.TextColor3 = Color3.fromRGB(255, 255, 255)
					TextButton10.Text = ""
					TextButton10.Font = Enum.Font.SourceSans
					TextButton10.Parent = Slider

					local UICorner31 = Instance.new("UICorner")
					UICorner31.CornerRadius = UDim.new(0, 4)
					UICorner31.Parent = TextButton10

					local SectionName3 = Instance.new("TextLabel")
					SectionName3.Name = "SectionName"
					SectionName3.AnchorPoint = Vector2.new(1, 0)
					SectionName3.Size = UDim2.new(1, -6, 0, 24)
					SectionName3.BackgroundTransparency = 1
					SectionName3.Position = UDim2.new(1, 0, 0, 6)
					SectionName3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					SectionName3.FontSize = Enum.FontSize.Size10
					SectionName3.TextSize = 12
					SectionName3.TextColor3 = Color3.fromRGB(255, 255, 255)
					SectionName3.Text = Name or "Slider"
					SectionName3.TextYAlignment = Enum.TextYAlignment.Top
					SectionName3.TextWrapped = true
					SectionName3.Font = Enum.Font.SourceSans
					SectionName3.TextWrap = true
					SectionName3.TextXAlignment = Enum.TextXAlignment.Left
					SectionName3.Parent = Slider
					--SectionName3.ZIndex = 2

					local TextLabel = Instance.new("TextLabel")
					TextLabel.AnchorPoint = Vector2.new(1, 0)
					TextLabel.Size = UDim2.new(0, 20, 0, 10)
					TextLabel.BackgroundTransparency = 1
					TextLabel.Position = UDim2.new(1, -6, 0, 6)
					TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					TextLabel.FontSize = Enum.FontSize.Size9
					TextLabel.TextYAlignment = Enum.TextYAlignment.Top
					TextLabel.TextSize = 12
					TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					TextLabel.Text = "1/12"
					TextLabel.Font = Enum.Font.SourceSans
					TextLabel.TextXAlignment = Enum.TextXAlignment.Right
					TextLabel.Parent = Slider
					--TextLabel.ZIndex = 2

					local Main2 = Instance.new("Frame")
					Main2.Name = "Main"
					Main2.AnchorPoint = Vector2.new(0.5, 1)
					Main2.Size = UDim2.new(1, -12, 0, 12)
					Main2.Position = UDim2.new(0.5, 0, 1, -6)
					Main2.BackgroundColor3 = Gui.Theme
					Main2.Parent = Slider
					--Main2.ZIndex = 2

					local UICorner32 = Instance.new("UICorner")
					UICorner32.CornerRadius = UDim.new(0, 4)
					UICorner32.Parent = Main2

					local Inner5 = Instance.new("Frame")
					Inner5.Name = "Inner"
					Inner5.AnchorPoint = Vector2.new(0.5, 0.5)
					Inner5.Size = UDim2.new(1, -2, 1, -2)
					Inner5.Position = UDim2.new(0.5, 0, 0.5, 0)
					Inner5.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
					Inner5.Parent = Main2
					--Inner5.ZIndex = 2

					local UICorner33 = Instance.new("UICorner")
					UICorner33.CornerRadius = UDim.new(0, 4)
					UICorner33.Parent = Inner5

					local Indicator = Instance.new("Frame")
					Indicator.Name = "Indicator"
					--Indicator.AnchorPoint = Vector2.new(0, 0)
					Indicator.Size = UDim2.new(0.5649717, 0, 1, 0)
					Indicator.Position = UDim2.new(0, 0, 0, 0)
					Indicator.BackgroundColor3 = Gui.Theme2
					Indicator.Parent = Inner5
					Indicator.BorderSizePixel = 0
					--Indicator.ZIndex = 2

					local UICorner34 = Instance.new("UICorner")
					UICorner34.CornerRadius = UDim.new(0, 4)
					UICorner34.Parent = Indicator

					local MouseDown, Floor, EndInput = false, function(...)
						return math.floor(...)
					end, nil

					TextButton10.TouchTap:Connect(function(x, y)
						if Gui.InteractionsEnabled ~= true then
							return
						end
						MouseDown = true
						Indicator:TweenSize(
							UDim2.new(0, math.clamp(Mouse.X - Inner5.AbsolutePosition.X, 0, Inner5.AbsoluteSize.X), 1, 0),
							Enum.EasingDirection.InOut,
							Enum.EasingStyle.Linear,
							0.1,
							true, function()
								Settings.Value = Floor(((Indicator.AbsoluteSize.X / Inner5.AbsoluteSize.X) * (Settings.Max - Settings.Min)) + Settings.Min)
								Callback(Settings.Value)
								TextLabel.Text = tostring(Settings.Value) .. "/" .. tostring(Settings.Max)
							end
						)
						game:GetService("RunService").Heartbeat:Connect(function()
							spawn(function()
								if MouseDown then
									Indicator:TweenSize(
										UDim2.new(0, math.clamp(Mouse.X - Inner5.AbsolutePosition.X, 0, Inner5.AbsoluteSize.X), 1, 0),
										Enum.EasingDirection.InOut,
										Enum.EasingStyle.Linear,
										0.1,
										true, function()
											Settings.Value = Floor(((Indicator.AbsoluteSize.X / Inner5.AbsoluteSize.X) * (Settings.Max - Settings.Min)) + Settings.Min)
											Callback(Settings.Value)
											TextLabel.Text = tostring(Settings.Value) .. "/" .. tostring(Settings.Max)
										end
									)
								else
									while _VERSION == "Luau" do
										wait()
										--repeat wait() until MouseDown
									end
								end
							end)
						end)
						game:GetService("UserInputService").InputEnded:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
								if MouseDown then
									MouseDown = false
								else

								end

							end
						end)
					end)

					TextLabel.Text = tostring(Settings.Value) .. "/" .. tostring(Settings.Max)
					Indicator.Size = UDim2.new((Settings.Value - math.abs(Settings.Min))/(Settings.Max - math.abs(Settings.Min)), 0, 1, 0)

					return CreatedSlider
				end

				CreatedSection.CreateDropdown = function(self, Name, Items, Callback, Settings)
					Items = Items or {"Bread", "Harms", "Haze", "Mikee"}
					Callback = Callback or function()
					end
					Settings = Settings or {}
					Settings.Selected = Settings.Selected or "select"
					local CreatedDropdown = {Opened = false}
					Settings.ZIndex = Settings.ZIndex or 3
					if Settings.CloseAutomatically == nil then
						Settings.CloseAutomatically = true
					end
					Settings.Id = game.HttpService:GenerateGUID(false)

					local Dropdown = Instance.new("Frame")
					Dropdown.Name = "Dropdown"
					Dropdown.Size = UDim2.new(1, 0, 0, 23)
					Dropdown.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
					Dropdown.Parent = SectionContent
					Dropdown.ZIndex = Settings.ZIndex

					local UICorner16 = Instance.new("UICorner")
					UICorner16.CornerRadius = UDim.new(0, 4)
					UICorner16.Parent = Dropdown

					local TextButton1 = Instance.new("TextButton")
					TextButton1.AnchorPoint = Vector2.new(0.5, 0.5)
					TextButton1.Size = UDim2.new(1, -2, 1, -2)
					TextButton1.Position = UDim2.new(0.5, 0, 0.5, 0)
					TextButton1.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
					TextButton1.AutoButtonColor = false
					TextButton1.FontSize = Enum.FontSize.Size9
					TextButton1.TextSize = 12
					TextButton1.TextColor3 = Gui.Theme2
					TextButton1.Text =
						"<font color='rgb(255,255,255)'>   " .. Name .. ":</font> " .. tostring(Settings.Selected)
					TextButton1.TextXAlignment = Enum.TextXAlignment.Left
					TextButton1.Font = Enum.Font.SourceSans
					TextButton1.Parent = Dropdown
					TextButton1.ZIndex = Settings.ZIndex
					TextButton1.RichText = true

					local UICorner17 = Instance.new("UICorner")
					UICorner17.CornerRadius = UDim.new(0, 4)
					UICorner17.Parent = TextButton1

					local ImageLabel1 = Instance.new("ImageLabel")
					ImageLabel1.AnchorPoint = Vector2.new(0.5, 0.5)
					ImageLabel1.Size = UDim2.new(0, 18, 0, 18)
					ImageLabel1.BackgroundTransparency = 1
					ImageLabel1.Position = UDim2.new(1, -12, 0.5, 0)
					ImageLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					ImageLabel1.ImageColor3 = Gui.Theme2
					ImageLabel1.ImageRectOffset = Vector2.new(564, 284)
					ImageLabel1.ImageRectSize = Vector2.new(36, 36)
					ImageLabel1.Image = "rbxassetid://3926305904"
					ImageLabel1.Parent = TextButton1
					ImageLabel1.ZIndex = Settings.ZIndex

					local DropdownContent = Instance.new("Frame")
					DropdownContent.Name = "DropdownContent"
					--DropdownContent.Visible = false
					DropdownContent.Size = UDim2.new(1, 0, 0, 95)
					DropdownContent.Position = UDim2.new(0, 0, 1, 8)
					DropdownContent.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
					DropdownContent.Parent = Dropdown
					DropdownContent.ZIndex = Settings.ZIndex
					DropdownContent.Active = true

					local UICorner18 = Instance.new("UICorner")
					UICorner18.CornerRadius = UDim.new(0, 5)
					UICorner18.Parent = DropdownContent

					local Frame1 = Instance.new("Frame")
					Frame1.AnchorPoint = Vector2.new(0.5, 0.5)
					Frame1.Size = UDim2.new(1, -2, 1, -2)
					Frame1.Position = UDim2.new(0.5, 0, 0.5, 0)
					Frame1.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
					Frame1.Parent = DropdownContent
					Frame1.ZIndex = Settings.ZIndex

					--Frame1.BackgroundTransparency = 1
					ImageLabel1.Rotation = 0
					--DropdownContent.BackgroundTransparency = 1

					TextButton1.MouseEnter:Connect(
						function()
							--if DropdownContent.BackgroundTransparency == 1 then
							--	DropdownContent.Visible = true
							--end
							game:GetService("TweenService"):Create(
							TextButton1,
							TweenInfo.new(0.3),
							{
								TextColor3 = Gui.Theme
							}
							):Play()
							game:GetService("TweenService"):Create(
							ImageLabel1,
							TweenInfo.new(0.3),
							{
								ImageColor3 = Gui.Theme
							}
							):Play()
						end
					)
					TextButton1.MouseLeave:Connect(
						function()
							--if DropdownContent.BackgroundTransparency == 1 then
							--	DropdownContent.Visible = false
							--end
							game:GetService("TweenService"):Create(
							TextButton1,
							TweenInfo.new(0.3),
							{
								TextColor3 = Gui.Theme2
							}
							):Play()
							game:GetService("TweenService"):Create(
							ImageLabel1,
							TweenInfo.new(0.3),
							{
								ImageColor3 = Gui.Theme2
							}
							):Play()
						end
					)

					TextButton1.TextColor3 = Gui.Theme2
					DropdownContent.BackgroundTransparency = 1
					for i, v in next, DropdownContent:GetDescendants() do
						if
							HasProperty(v, "BackgroundTransparency") and not v:IsA("TextLabel") and
							not v:IsA("ScrollingFrame")
						then
							v.BackgroundTransparency = 1
						end
						if HasProperty(v, "TextTransparency") then
							v.TextTransparency = 1
						end
					end

					TextButton1.TouchTap:Connect(
						function()
							if Gui.InteractionsEnabled ~= true and Gui.FocusedDropdown ~= Name .. Settings.Id then
								return
							end
							Gui.FocusedDropdown = Name .. Settings.Id
							spawn(
								function()
									game:GetService("TweenService"):Create(
									ImageLabel1,
									TweenInfo.new(.3),
									{
										Rotation = ImageLabel1.Rotation == 180 and 0 or 180,
										ImageColor3 = ImageLabel1.BackgroundColor3 == Gui.Theme and Gui.Theme2 or
											Gui.Theme
									}
									):Play()
									game:GetService("TweenService"):Create(
									TextButton1,
									TweenInfo.new(.3),
									{
										TextColor3 = TextButton1.BackgroundColor3 == Gui.Theme and Gui.Theme2 or
											Gui.Theme
									}
									):Play()
									game:GetService("TweenService"):Create(
									DropdownContent,
									TweenInfo.new(.3),
									{
										BackgroundTransparency = DropdownContent.BackgroundTransparency == 1 and 0 or 1
									}
									):Play()
									table.foreachi(
										DropdownContent:GetDescendants(),
										function(i, v)
											if
												HasProperty(v, "BackgroundTransparency") and not v:IsA("TextLabel") and
												not v:IsA("ScrollingFrame")
											then
												game:GetService("TweenService"):Create(
												v,
												TweenInfo.new(.3),
												{
													BackgroundTransparency = v.BackgroundTransparency == 1 and 0 or 1
												}
												):Play()
											end
											if HasProperty(v, "TextTransparency") then
												game:GetService("TweenService"):Create(
												v,
												TweenInfo.new(0.3),
												{
													TextTransparency = v.TextTransparency == 1 and 0 or 1
												}
												):Play()
											end
										end
									)
									wait(.3)
									Gui.Data.SetInteractionsEnabled(ImageLabel1.Rotation == 0 and true or false) -- lol
								end
							)
						end
					)

					local UICorner19 = Instance.new("UICorner")
					UICorner19.CornerRadius = UDim.new(0, 5)
					UICorner19.Parent = Frame1

					local ScrollingFrame1 = Instance.new("ScrollingFrame")
					ScrollingFrame1.AnchorPoint = Vector2.new(0.5, 0.5)
					ScrollingFrame1.Size = UDim2.new(1, -4, 1.0210526, -4)
					ScrollingFrame1.BackgroundTransparency = 1
					ScrollingFrame1.Position = UDim2.new(0.5, 0, 0.5105263, 0)
					ScrollingFrame1.Active = true
					ScrollingFrame1.BorderSizePixel = 0
					ScrollingFrame1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					ScrollingFrame1.CanvasSize = UDim2.new(0, 0, 0, 255)
					ScrollingFrame1.ScrollBarThickness = 0
					ScrollingFrame1.Parent = Frame1
					ScrollingFrame1.ZIndex = Settings.ZIndex
					ScrollingFrame1.BackgroundTransparency = 1

					local UIListLayout4 = Instance.new("UIListLayout")
					UIListLayout4.HorizontalAlignment = Enum.HorizontalAlignment.Center
					UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
					UIListLayout4.Padding = UDim.new(0, 3)
					UIListLayout4.Parent = ScrollingFrame1
					game:GetService("RunService").Heartbeat:Connect(function()
						if UIListLayout4.AbsoluteContentSize.Y > 120 then
							ScrollingFrame1.CanvasSize = UDim2.fromOffset(0, UIListLayout4.AbsoluteContentSize.Y + 8)
							DropdownContent.Size = UDim2.new(1, 0, 0, 120)
						else
							ScrollingFrame1.CanvasSize = UDim2.fromOffset(0, 0)
							DropdownContent.Size = UDim2.new(1, 0, 0, UIListLayout4.AbsoluteContentSize.Y + 8)
						end
					end)
					CreatedDropdown.Add = function(Key)
						local TextButton2 = Instance.new("Frame")
						TextButton2.Size = UDim2.new(1, -2, 0, 28)
						TextButton2.BorderSizePixel = 0
						TextButton2.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
						--TextButton2.AutoButtonColor = false
						--TextButton2.FontSize = Enum.FontSize.Size14
						--TextButton2.TextSize = 14
						--TextButton2.TextColor3 = Color3.fromRGB(0, 0, 0)
						--TextButton2.Text = ""
						--TextButton2.Font = Enum.Font.SourceSans
						TextButton2.Parent = ScrollingFrame1
						TextButton2.ZIndex = Settings.ZIndex
						TextButton2.BackgroundTransparency = 1
						TextButton2.Active = true

						local TextLabel2 = Instance.new("TextLabel")
						TextLabel2.Size = UDim2.new(1, 0, 1, 0)
						TextLabel2.BorderColor3 = Color3.fromRGB(27, 42, 53)
						TextLabel2.BackgroundTransparency = 1
						TextLabel2.Position = UDim2.new(0, 6, 0, 0)
						TextLabel2.BorderSizePixel = 0
						TextLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						TextLabel2.FontSize = Enum.FontSize.Size18
						TextLabel2.Text = Key
						TextLabel2.TextSize = 15
						TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
						TextLabel2.Font = Enum.Font.SourceSans
						TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
						TextLabel2.Parent = TextButton2
						TextLabel2.ZIndex = Settings.ZIndex
						TextLabel2.BackgroundTransparency = 1
						TextLabel2.TextTransparency = 1
						TextButton2.MouseEnter:Connect(
							function()
								--if TextButton2.BackgroundTransparency > 0 then
								--	return
								--end
								game:GetService("TweenService"):Create(
								TextLabel2,
								TweenInfo.new(0.22),
								{
									TextColor3 = Gui.Theme
								}
								):Play()
							end
						)
						TextButton2.MouseLeave:Connect(
							function()
								game:GetService("TweenService"):Create(
								TextLabel2,
								TweenInfo.new(0.22),
								{
									TextColor3 = Color3.fromRGB(255, 255, 255)
								}
								):Play()
							end
						)

						TextButton2.InputEnded:Connect(function(Mouse)
							if Mouse.UserInputType == Enum.UserInputType.MouseButton1 or Mouse.UserInputType == Enum.UserInputType.Touch then
								Gui.Data.SetInteractionsEnabled(true)
							end
						end)

						TextButton2.InputBegan:Connect(
							function(Mouse)
								if Gui.InteractionsEnabled ~= false or TextButton2.Transparency > 0 then
									return
								end
								if Mouse.UserInputType == Enum.UserInputType.MouseButton1 or Mouse.UserInputType == Enum.UserInputType.Touch then
									if DropdownContent.Visible == false then
										return
									end
									spawn(
										function()
											if Settings.CloseAutomatically then
												game:GetService("TweenService"):Create(
												ImageLabel1,
												TweenInfo.new(.3),
												{
													Rotation = 0
												}
												):Play()
												game:GetService("TweenService"):Create(
												DropdownContent,
												TweenInfo.new(.3),
												{
													BackgroundTransparency = 1
												}
												):Play()
												table.foreachi(
													DropdownContent:GetDescendants(),
													function(i, v)
														if
															HasProperty(v, "BackgroundTransparency") and
															not v:IsA("TextLabel") and
															not v:IsA("ScrollingFrame")
														then
															game:GetService("TweenService"):Create(
															v,
															TweenInfo.new(.3),
															{
																BackgroundTransparency = 1
															}
															):Play()
														end
														if HasProperty(v, "TextTransparency") then
															game:GetService("TweenService"):Create(
															v,
															TweenInfo.new(0.3),
															{
																TextTransparency = 1
															}
															):Play()
														end
													end
												)
												--DropdownContent.Visible = false
											end
											Settings.Selected = Key
											TextButton1.Text =
												"<font color='rgb(255,255,255)'>   " ..
												Name .. ":</font> " .. tostring(Settings.Selected)
											Callback(Settings.Selected)
											wait(.3)
											--DropdownContent.Visible = not DropdownContent.Visible
										end
									)
								end
							end
						)
					end

					table.foreachi(
						Items,
						function(i, v)
							CreatedDropdown.Add(v)
						end
					)
					return CreatedDropdown
				end

				--local Line1 = Instance.new("Frame")
				--Line1.Name = "Line"
				--Line1.AnchorPoint = Vector2.new(0.5, 0)
				--Line1.Size = UDim2.new(1, -8, 0, 1)
				--Line1.Position = UDim2.new(0.5, 0, 0, 26)
				--Line1.BorderSizePixel = 0
				--Line1.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
				--Line1.Parent = Inner

				--local UICorner24 = Instance.new("UICorner")
				--UICorner24.CornerRadius = UDim.new(0, 4)
				--UICorner24.Parent = Section

				local Section2 = Instance.new("Frame")
				Section2.Name = "Section"
				Section2.Size = UDim2.new(1, 0, 0, 140)
				Section2.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
				Section2.Parent = nil

				local Inner3 = Instance.new("Frame")
				Inner3.Name = "Inner"
				Inner3.AnchorPoint = Vector2.new(0.5, 0.5)
				Inner3.Size = UDim2.new(1, -2, 1, -2)
				Inner3.Position = UDim2.new(0.5, 0, 0.5, 0)
				Inner3.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
				Inner3.Parent = Section2

				local UICorner25 = Instance.new("UICorner")
				UICorner25.CornerRadius = UDim.new(0, 4)
				UICorner25.Parent = Inner3

				local SectionName2 = Instance.new("TextLabel")
				SectionName2.Name = "SectionName"
				SectionName2.AnchorPoint = Vector2.new(1, 0)
				SectionName2.Size = UDim2.new(1, -8, 0, 24)
				SectionName2.BackgroundTransparency = 1
				SectionName2.Position = UDim2.new(1, 0, 0, 8)
				SectionName2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SectionName2.FontSize = Enum.FontSize.Size14
				SectionName2.TextSize = 14
				SectionName2.TextColor3 = Gui.Theme
				SectionName2.Text = "Section"
				SectionName2.TextYAlignment = Enum.TextYAlignment.Top
				SectionName2.TextWrapped = true
				SectionName2.Font = Enum.Font.SourceSansBold
				SectionName2.TextWrap = true
				SectionName2.TextXAlignment = Enum.TextXAlignment.Left
				SectionName2.Parent = Inner3

				local SectionContent2 = Instance.new("Frame")
				SectionContent2.Name = "SectionContent"
				SectionContent2.AnchorPoint = Vector2.new(0.5, 1)
				SectionContent2.Size = UDim2.new(1, -12, 1, -40)
				SectionContent2.BackgroundTransparency = 1
				SectionContent2.Position = UDim2.new(0.5, 0, 1, -6)
				SectionContent2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SectionContent2.Parent = Inner3

				local UIListLayout7 = Instance.new("UIListLayout")
				UIListLayout7.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout7.Padding = UDim.new(0, 3)
				UIListLayout7.Parent = SectionContent2

				local Button1 = Instance.new("Frame")
				Button1.Name = "Button"
				Button1.Size = UDim2.new(1, 0, 0, 23)
				Button1.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
				Button1.Parent = SectionContent2

				local UICorner26 = Instance.new("UICorner")
				UICorner26.CornerRadius = UDim.new(0, 4)
				UICorner26.Parent = Button1

				local TextButton9 = Instance.new("TextButton")
				TextButton9.AnchorPoint = Vector2.new(0.5, 0.5)
				TextButton9.Size = UDim2.new(1, -2, 1, -2)
				TextButton9.Position = UDim2.new(0.5, 0, 0.5, 0)
				TextButton9.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
				TextButton9.AutoButtonColor = false
				TextButton9.FontSize = Enum.FontSize.Size9
				TextButton9.TextSize = 12
				TextButton9.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextButton9.Font = Enum.Font.SourceSans
				TextButton9.Parent = Button1

				local UICorner27 = Instance.new("UICorner")
				UICorner27.CornerRadius = UDim.new(0, 4)
				UICorner27.Parent = TextButton9
				CreatedSection.CreateKeybind = function(self, Dname, Callback, Settings)
					Callback = Callback or function()
					end
					Settings = Settings or {}
					Settings.Bind = Settings.Bind or Enum.KeyCode.E
					local Keybind = Instance.new("TextButton")
					Keybind.Name = "Keybind"
					Keybind.AnchorPoint = Vector2.new(0.5, 0.5)
					Keybind.Size = UDim2.new(1, 0, 0, 23)
					Keybind.BackgroundTransparency = 1
					Keybind.Position = UDim2.new(0.5, 0, 0.5, 0)
					Keybind.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
					Keybind.AutoButtonColor = false
					Keybind.FontSize = Enum.FontSize.Size9
					Keybind.TextSize = 12
					Keybind.TextColor3 = Color3.fromRGB(255, 255, 255)
					Keybind.Text = ""
					Keybind.Font = Enum.Font.SourceSans
					Keybind.Parent = SectionContent

					local Bind = Instance.new("Frame")
					Bind.Name = "Bind"
					Bind.Size = UDim2.new(0, 43, 0, 23)
					Bind.BackgroundColor3 = Gui.Theme
					Bind.Parent = Keybind

					local UICorner28 = Instance.new("UICorner")
					UICorner28.CornerRadius = UDim.new(0, 4)
					UICorner28.Parent = Bind

					local Inner4 = Instance.new("Frame")
					Inner4.Name = "Inner"
					Inner4.AnchorPoint = Vector2.new(0.5, 0.5)
					Inner4.Size = UDim2.new(1, -2, 1, -2)
					Inner4.Position = UDim2.new(0.5, 0, 0.5, 0)
					Inner4.BackgroundColor3 = Gui.Theme2
					Inner4.Parent = Bind

					local UICorner29 = Instance.new("UICorner")
					UICorner29.CornerRadius = UDim.new(0, 4)
					UICorner29.Parent = Inner4

					local Key = Instance.new("TextLabel")
					Key.Name = "Key"
					Key.Size = UDim2.new(1, -6, 1, 0)
					Key.BackgroundTransparency = 1
					Key.Position = UDim2.new(0, 6, 0, 0)
					Key.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Key.FontSize = Enum.FontSize.Size10
					Key.TextTruncate = Enum.TextTruncate.AtEnd
					Key.TextSize = 12
					Key.TextColor3 = Color3.fromRGB(255, 255, 255)
					Key.Text = "Backspace"
					Key.Font = Enum.Font.SourceSans
					Key.TextXAlignment = Enum.TextXAlignment.Left
					Key.Parent = Inner4

					local Name = Instance.new("TextLabel")
					Name.Name = "Name"
					Name.Size = UDim2.new(1, 0, 1, 0)
					Name.BackgroundTransparency = 1
					Name.Position = UDim2.new(0, 50, 0, 0)
					Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Name.FontSize = Enum.FontSize.Size10
					Name.TextSize = 12
					Name.TextColor3 = Color3.fromRGB(255, 255, 255)
					Name.Text = Dname or "Keybind"
					Name.Font = Enum.Font.SourceSans
					Name.TextXAlignment = Enum.TextXAlignment.Left
					Name.Parent = Keybind

					local Ignore = false
					local IgnoreNext = function()
						--spawn(
						--	function()
						Ignore = true
						wait()
						Ignore = false
						--	end
						--)
					end
					local Binput = function()
						Key.Text = "..."
						local Binded = false
						game:GetService("UserInputService").InputBegan:Connect(
						function(input, processed)
							if not processed then
								if not tostring(input.UserInputType):find("Mouse") then
									if Binded then return end
									IgnoreNext()
									Settings.Bind = input.KeyCode
								end
								if Binded then return end
								IgnoreNext()
								Key.Text = Settings.Bind.Name
								Binded = true
							end
						end
						)
					end

					Key.Text = Settings.Bind.Name

					game:GetService("UserInputService").InputBegan:Connect(
					function(input, processed)
						if not processed and input.KeyCode == Settings.Bind and not Ignore then
							Callback()
						end
					end
					)

					Keybind.InputBegan:Connect(
						function(Input, Processed)
							if not Processed then
								if Gui.InteractionsEnabled ~= true then
									return
								end
								if Input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
									Binput()
								end
							end
						end
					)
				end

				local Line2 = Instance.new("Frame")
				Line2.Name = "Line"
				Line2.AnchorPoint = Vector2.new(0.5, 0)
				Line2.Size = UDim2.new(1, -8, 0, 1)
				Line2.Position = UDim2.new(0.5, 0, 0, 26)
				Line2.BorderSizePixel = 0
				Line2.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
				Line2.Parent = Inner3

				local UICorner35 = Instance.new("UICorner")
				UICorner35.CornerRadius = UDim.new(0, 4)
				UICorner35.Parent = Section2

				local UIPadding1 = Instance.new("UIPadding")
				UIPadding1.PaddingTop = UDim.new(0, 1)
				UIPadding1.PaddingBottom = UDim.new(0, 1)
				UIPadding1.PaddingLeft = UDim.new(0, 1)
				UIPadding1.PaddingRight = UDim.new(0, 1)
				UIPadding1.Parent = Tab2

				local Border = Instance.new("Frame")
				Border.Name = "Border"
				Border.ZIndex = -1
				Border.Size = UDim2.new(1, 0, 1, 0)
				Border.BorderSizePixel = 0
				Border.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
				Border.Parent = Main

				local UICorner36 = Instance.new("UICorner")
				UICorner36.Parent = Border
				return CreatedSection
			end
			return CreatedTab
		end

		dragify(Main)

		local Frame3 = Instance.new("Frame")
		Frame3.Size = UDim2.new(1, -2, 0, 31)
		Frame3.Position = UDim2.new(0, 1, 0, 1)
		Frame3.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
		Frame3.Parent = Main

		local UICorner37 = Instance.new("UICorner")
		UICorner37.Parent = Frame3

		local Bottom = Instance.new("Frame")
		Bottom.Name = "Bottom"
		Bottom.AnchorPoint = Vector2.new(0, 1)
		Bottom.Size = UDim2.new(1, 0, 0, 8)
		Bottom.ClipsDescendants = true
		Bottom.BorderColor3 = Color3.fromRGB(255, 255, 255)
		Bottom.Position = UDim2.new(0, 0, 1, 0)
		Bottom.BorderSizePixel = 0
		Bottom.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
		Bottom.Parent = Frame3

		local Border1 = Instance.new("Frame")
		Border1.Name = "Border"
		Border1.Size = UDim2.new(1, 0, 0, 1)
		Border1.Position = UDim2.new(0, 0, 1, -1)
		Border1.BorderSizePixel = 0
		Border1.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
		Border1.Parent = Bottom

		local Buttons = Instance.new("Frame")
		Buttons.Name = "Buttons"
		Buttons.ZIndex = 3
		Buttons.Size = UDim2.new(1, 0, 1, 0)
		Buttons.BackgroundTransparency = 1
		Buttons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Buttons.Parent = Frame3

		local UIListLayout8 = Instance.new("UIListLayout")
		UIListLayout8.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout8.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout8.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout8.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout8.Padding = UDim.new(0, 4)
		UIListLayout8.Parent = Buttons

		local UIPadding2 = Instance.new("UIPadding")
		UIPadding2.PaddingRight = UDim.new(0, 10)
		UIPadding2.Parent = Buttons

		local Title = Instance.new("TextLabel")
		Title.Name = "Title"
		Title.ZIndex = 2
		Title.Size = UDim2.new(1, -48, 1, 0)
		Title.BackgroundTransparency = 1
		Title.Position = UDim2.new(0, 12, 0, -1)
		Title.BorderSizePixel = 0
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Title.FontSize = Enum.FontSize.Size18
		Title.TextSize = 15
		Title.TextColor3 = Gui.Theme
		Title.Text = "Spring"
		Title.Font = Enum.Font.SourceSans
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Title.Parent = Frame3

		local Notifications = Instance.new("Frame")
		Notifications.Name = "Notifications"
		Notifications.AnchorPoint = Vector2.new(1, 1)
		Notifications.Size = UDim2.new(0, 255, 1, 0)
		Notifications.BackgroundTransparency = 1
		Notifications.Position = UDim2.new(1, -16, 1, -16)
		Notifications.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Notifications.Parent = SpringGui

		local UIListLayout9 = Instance.new("UIListLayout")
		UIListLayout9.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout9.VerticalAlignment = Enum.VerticalAlignment.Bottom
		UIListLayout9.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout9.Padding = UDim.new(0, 3)
		UIListLayout9.Parent = Notifications

		CreatedGui.CreateNotification = function(self, Name, Description, Duration)
			local AlreadyClosing = false
			local Notification = {}
			Notification.Checked = Signal.new()
			Notification.Revoked = Signal.new()
			Notification.Ended = Signal.new()

			local Main3 = Instance.new("Frame")
			Main3.Name = "Main"
			Main3.ZIndex = 6
			Main3.Size = UDim2.new(0, 416, 0, 64)
			Main3.BorderColor3 = Color3.fromRGB(195, 195, 195)
			Main3.BackgroundTransparency = 1
			Main3.Position = UDim2.new(0, -161, 0, 508)
			Main3.Active = true
			Main3.ClipsDescendants = true
			Main3.BorderSizePixel = 0
			Main3.BackgroundColor3 = Color3.fromRGB(26, 32, 40)
			Main3.Parent = Notifications

			local Main4 = Instance.new("Frame")
			Main4.Name = "Main"
			Main4.ZIndex = 1
			Main4.Size = UDim2.new(1, -2, 1, -10)
			Main4.Position = UDim2.new(0, 1, 0, 9)
			Main4.BorderSizePixel = 0
			Main4.ClipsDescendants = true
			Main4.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
			Main4.Parent = Main3

			local UICorner38 = Instance.new("UICorner")
			UICorner38.Parent = Main4

			local Title1 = Instance.new("TextLabel")
			Title1.Name = "Desc"
			Title1.ZIndex = 2
			Title1.AnchorPoint = Vector2.new(0, 1)
			Title1.Size = UDim2.new(1, -48, 1, -28)
			Title1.BackgroundTransparency = 1
			Title1.Position = UDim2.new(0, 12, 1, -1)
			Title1.BorderSizePixel = 0
			Title1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title1.FontSize = Enum.FontSize.Size18
			Title1.TextSize = 15
			Title1.TextColor3 = Color3.fromRGB(245, 245, 245)
			Title1.Text =
				Description or 'This module has been disabled for: "As of now, Kill all is detected, don\'t use it"'
			Title1.TextYAlignment = Enum.TextYAlignment.Top
			Title1.Font = Enum.Font.SourceSans
			Title1.TextXAlignment = Enum.TextXAlignment.Left
			Title1.Parent = Main4

			local Border2 = Instance.new("Frame")
			Border2.Name = "Border"
			Border2.ZIndex = -1
			Border2.Size = UDim2.new(1, 0, 1, 0)
			Border2.BorderSizePixel = 0
			Border2.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
			Border2.Parent = Main3

			local UICorner39 = Instance.new("UICorner")
			UICorner39.Parent = Border2

			--local UIScale1 = Instance.new("UIScale")
			--UIScale1.Parent = Main3

			local Frame4 = Instance.new("Frame")
			Frame4.Size = UDim2.new(1, -2, 0, 31)
			Frame4.Position = UDim2.new(0, 1, 0, 1)
			Frame4.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
			Frame4.Parent = Main3

			local UICorner40 = Instance.new("UICorner")
			UICorner40.Parent = Frame4

			local Bottom1 = Instance.new("Frame")
			Bottom1.Name = "Bottom"
			Bottom1.AnchorPoint = Vector2.new(0, 1)
			Bottom1.Size = UDim2.new(1, 0, 0, 8)
			Bottom1.ClipsDescendants = true
			Bottom1.BorderColor3 = Color3.fromRGB(255, 255, 255)
			Bottom1.Position = UDim2.new(0, 0, 1, 0)
			Bottom1.BorderSizePixel = 0
			Bottom1.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
			Bottom1.Parent = Frame4

			local Border3 = Instance.new("Frame")
			Border3.Name = "Border"
			Border3.Size = UDim2.new(1, 0, 0, 1)
			Border3.Position = UDim2.new(0, 0, 1, -1)
			Border3.BorderSizePixel = 0
			Border3.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
			Border3.Parent = Bottom1

			local Buttons1 = Instance.new("Frame")
			Buttons1.Name = "Buttons"
			Buttons1.ZIndex = 3
			Buttons1.Size = UDim2.new(1, 0, 1, 0)
			Buttons1.BackgroundTransparency = 1
			Buttons1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Buttons1.Parent = Frame4

			local UIListLayout10 = Instance.new("UIListLayout")
			UIListLayout10.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout10.HorizontalAlignment = Enum.HorizontalAlignment.Right
			UIListLayout10.VerticalAlignment = Enum.VerticalAlignment.Center
			UIListLayout10.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout10.Padding = UDim.new(0, 3)
			UIListLayout10.Parent = Buttons1

			local ImageButton1 = Instance.new("ImageButton")
			ImageButton1.ZIndex = 2
			ImageButton1.Size = UDim2.new(0, 14, 0, 14)
			ImageButton1.BackgroundTransparency = 1
			ImageButton1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ImageButton1.ImageColor3 = Gui.Theme
			ImageButton1.Image = "rbxassetid://3224442404"
			ImageButton1.Parent = Buttons1
			ImageButton1.TouchTap:Connect(
				function()
					if AlreadyClosing then
						return
					end
					Notification.Checked:fire()
					Notification.Ended:fire()
				end
			)
			local UIPadding3 = Instance.new("UIPadding")
			UIPadding3.PaddingRight = UDim.new(0, 10)
			UIPadding3.Parent = Buttons1

			local ImageButton2 = Instance.new("ImageButton")
			ImageButton2.ZIndex = 2
			ImageButton2.Size = UDim2.new(0, 14, 0, 14)
			ImageButton2.BackgroundTransparency = 1
			ImageButton2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ImageButton2.ImageColor3 = Gui.Theme
			ImageButton2.Image = "rbxassetid://4661609682"
			ImageButton2.Parent = Buttons1
			ImageButton2.TouchTap:Connect(
				function()
					if AlreadyClosing then
						return
					end
					Notification.Revoked:fire()
					Notification.Ended:fire()
				end
			)

			local CircularProgressBar = Instance.new("Frame")
			CircularProgressBar.Name = "CircularProgressBar"
			CircularProgressBar.LayoutOrder = -1
			CircularProgressBar.AnchorPoint = Vector2.new(0.5, 0.5)
			CircularProgressBar.Size = UDim2.new(0, 15, 0, 15)
			CircularProgressBar.BackgroundTransparency = 1
			CircularProgressBar.Position = UDim2.new(1, -56, 1, -56)
			CircularProgressBar.Parent = Buttons1

			local Half2 = Instance.new("Frame")
			Half2.Name = "Half2"
			Half2.Size = UDim2.new(0.5, 0, 1, 0)
			Half2.ClipsDescendants = true
			Half2.BackgroundTransparency = 1
			Half2.Parent = CircularProgressBar

			local ImageLabel3 = Instance.new("ImageLabel")
			ImageLabel3.Size = UDim2.new(2, 0, 1, 0)
			ImageLabel3.BackgroundTransparency = 1
			ImageLabel3.ImageColor3 = Gui.Theme
			ImageLabel3.Image = "rbxassetid://2763450503"
			ImageLabel3.Parent = Half2

			local UIGradient = Instance.new("UIGradient")
			UIGradient.Transparency =
				NumberSequence.new(
					{
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(0.4999, 0),
						NumberSequenceKeypoint.new(0.5, 1),
						NumberSequenceKeypoint.new(1, 1)
					}
				)
			UIGradient.Rotation = -125
			UIGradient.Parent = ImageLabel3

			local Half1 = Instance.new("Frame")
			Half1.Name = "Half1"
			Half1.Size = UDim2.new(0.5, 0, 1, 0)
			Half1.ClipsDescendants = true
			Half1.BackgroundTransparency = 1
			Half1.Position = UDim2.new(0.5, 0, 0, 0)
			Half1.Parent = CircularProgressBar

			local ImageLabel4 = Instance.new("ImageLabel")
			ImageLabel4.Size = UDim2.new(2, 0, 1, 0)
			ImageLabel4.BackgroundTransparency = 1
			ImageLabel4.Position = UDim2.new(-1, 0, 0, 0)
			ImageLabel4.ImageColor3 = Gui.Theme
			ImageLabel4.Image = "rbxassetid://2763450503"
			ImageLabel4.Parent = Half1

			local UIGradient1 = Instance.new("UIGradient")
			UIGradient1.Transparency =
				NumberSequence.new(
					{
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(0.4999, 0),
						NumberSequenceKeypoint.new(0.5, 1),
						NumberSequenceKeypoint.new(1, 1)
					}
				)
			UIGradient1.Rotation = 180
			UIGradient1.Parent = ImageLabel4

			local Title2 = Instance.new("TextLabel")
			Title2.Name = "Title"
			Title2.ZIndex = 2
			Title2.Size = UDim2.new(1, -48, 1, 0)
			Title2.BackgroundTransparency = 1
			Title2.Position = UDim2.new(0, 12, 0, -1)
			Title2.BorderSizePixel = 0
			Title2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title2.FontSize = Enum.FontSize.Size18
			Title2.TextSize = 15
			Title2.TextColor3 = Gui.Theme
			Title2.Text = Name or "Kill all"
			Title2.Font = Enum.Font.SourceSans
			Title2.TextXAlignment = Enum.TextXAlignment.Left
			Title2.Parent = Frame4

			local function Close()
				if AlreadyClosing == true then
					return
				end
				AlreadyClosing = true
				spawn(
					function()
						game:GetService("TweenService"):Create(
						Main3,
						TweenInfo.new(.25, Enum.EasingStyle.Sine),
						{
							Size = UDim2.new(0, Main3.AbsoluteSize.X - 4, 0, Main3.AbsoluteSize.Y - 4),
							BackgroundColor3 = Color3.fromRGB(18, 18, 18)
						}
						):Play()
						wait(.2)
						game:GetService("TweenService"):Create(
						Main3,
						TweenInfo.new(.65, Enum.EasingStyle.Sine),
						{
							Size = UDim2.new(0, 0, 0, Main3.AbsoluteSize.Y - 4)
						}
						):Play()
						wait(1)
						game:GetService("TweenService"):Create(
						Main3,
						TweenInfo.new(.35, Enum.EasingStyle.Sine),
						{
							Size = UDim2.new(0, 0, 0, 0)
						}
						):Play()
						wait(1)
						Main3:Remove()
					end
				)
			end

			local T, d = Title2, Title1
			local GreatestAbsX = nil
			--print(Title2.TextBounds.X <= Title1.TextBounds.X)
			GreatestAbsX =
				math.ceil(Title2.TextBounds.X + 76) >= math.ceil(Title1.TextBounds.X + 32) and
				math.ceil(Title2.TextBounds.X + 76) or
				math.ceil(Title1.TextBounds.X + 32)
			--print(GreatestAbsX, T.TextBounds.X, d.TextBounds.X)
			Main3.Size = UDim2.fromOffset(GreatestAbsX, 64)
			spawn(
				function()
					Main3.Size = UDim2.fromOffset(0, 0)
					game:GetService("TweenService"):Create(
					Main3,
					TweenInfo.new(.2, Enum.EasingStyle.Back),
					{
						Size = UDim2.fromOffset(0, 64)
					}
					):Play()
					wait(.2)
					game:GetService("TweenService"):Create(
					Main3,
					TweenInfo.new(.65, Enum.EasingStyle.Sine),
					{
						Size = UDim2.fromOffset(GreatestAbsX, 64)
					}
					):Play()
					wait(Duration)
					Close()
				end
			)

			Notification.Ended:Connect(Close)

			spawn(
				function()
					UIGradient1.Rotation = 0
					UIGradient.Rotation = -180
					game:GetService("TweenService"):Create(
					UIGradient1,
					TweenInfo.new(Duration / 2, Enum.EasingStyle.Linear),
					{
						Rotation = 180
					}
					):Play()
					repeat
						wait()
					until UIGradient1.Rotation == 180
					game:GetService("TweenService"):Create(
					UIGradient,
					TweenInfo.new(Duration / 2, Enum.EasingStyle.Linear),
					{
						Rotation = 0
					}
					):Play()
					repeat
						wait()
					until UIGradient.Rotation == 0
					Notification.Ended:fire()
				end
			)
			return Notification
		end
		CreatedGui.SetTitle = function(self, New)
			Title.Text = New or "Title"
		end
		CreatedGui:SetTitle(AssignedGuiName)
		return CreatedGui
	end
end

return Gui
