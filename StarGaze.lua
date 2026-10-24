-- StarGaze Executor Edition — single-file Luau distribution
-- Original project: Starlight Solutions, Inc. (MIT).
-- Retains original modules/components; see LICENSE in repository.
-- Generated with tools/build_executor.py. Do not edit distribution manually.
local __sg_factories = {}
local __sg_cache = {}
local __sg_loading = {}
local function __sg_require(id)
    local cached = __sg_cache[id]
    if cached ~= nil then return cached end
    assert(not __sg_loading[id], 'StarGaze circular dependency: '..tostring(id))
    local factory = assert(__sg_factories[id], 'StarGaze missing module: '..tostring(id))
    __sg_loading[id] = true
    local ok, result = pcall(factory)
    __sg_loading[id] = nil
    if not ok then error('StarGaze module '..id..': '..tostring(result), 2) end
    if result == nil then result = true end
    __sg_cache[id] = result
    return result
end

__sg_factories['StarGaze/Components/Accordion'] = function()
local Utils=__sg_require('StarGaze/Core/Utils')
local Accordion={};Accordion.__index=Accordion
function Accordion.new(runtime,parent,options)
	options=options or {}
	local root=runtime:card(parent,{Size=options.Size or UDim2.fromScale(1,0.12),Color=options.Color or "Card",Radius=options.Radius or 10,ClipsDescendants=true})
	local trigger=Utils.button(root)
	local title=runtime:createText(root,options.Title or "Section",{Size=UDim2.fromScale(0.8,0.45),Position=UDim2.fromScale(0.04,0.08),TextSize=options.TextSize or 13})
	local arrow=runtime:createText(root,"⌄",{Size=UDim2.fromScale(0.08,0.45),Position=UDim2.fromScale(0.88,0.08),TextSize=15,TextXAlignment=Enum.TextXAlignment.Center,Color="Subtext"})
	local body=runtime:createFrame(root,{Size=UDim2.fromScale(0.92,0.42),Position=UDim2.fromScale(0.04,0.52),Color=options.BodyColor or "SurfaceAlt",Radius=8,Visible=false})
	if options.Build then options.Build(body,runtime) end
	runtime:track(root);runtime:track(trigger)
	local self=setmetatable({Runtime=runtime,Instance=root,Body=body,Arrow=arrow,Open=false,OriginalWidth=root.Size.X.Scale,CollapsedHeight=0.12,ExpandedHeight=0.44},Accordion)
	runtime:connect(trigger.Activated:Connect(function() self:toggle() end))
	return self
end
function Accordion:open()
	self.Open = true
	self.Body.Visible = true
	self.Arrow.Text = "⌃"
	self.Runtime:animate(self.Instance, {Size = UDim2.fromScale(self.OriginalWidth, self.ExpandedHeight)}, 0.16)
	return self
end
function Accordion:close()
	self.Open = false
	self.Body.Visible = false
	self.Arrow.Text = "⌄"
	self.Runtime:animate(self.Instance, {Size = UDim2.fromScale(self.OriginalWidth, self.CollapsedHeight)}, 0.16)
	return self
end
function Accordion:toggle() if self.Open then return self:close() end return self:open() end
return Accordion

end

__sg_factories['StarGaze/Components/Badge'] = function()
local Utils=__sg_require('StarGaze/Core/Utils')
local Badge={};Badge.__index=Badge
function Badge.new(runtime,parent,options)
	options=options or {}
	local holder=Utils.create("Frame",{Size=options.Size or UDim2.fromScale(0.18,0.06),BackgroundColor3=Utils.color(options.Color or "Accent",runtime.Theme),BackgroundTransparency=options.Transparency or 0,BorderSizePixel=0,Parent=parent or runtime.Gui})
	Utils.corner(holder,options.Radius or 999)
	local text=runtime:createText(holder,options.Text or "Badge",{TextSize=options.TextSize or 11,TextXAlignment=Enum.TextXAlignment.Center})
	runtime:track(holder)
	return setmetatable({Runtime=runtime,Instance=holder,Text=text},Badge)
end
function Badge:setText(value) self.Text.Text=tostring(value);return self end
function Badge:setColor(value) self.Runtime:animate(self.Instance,{BackgroundColor3=Utils.color(value,self.Runtime.Theme)});return self end
return Badge

end

__sg_factories['StarGaze/Components/Button'] = function()
local Utils = __sg_require('StarGaze/Core/Utils')
local Interaction = __sg_require('StarGaze/Core/Interaction')

local Button = {}
Button.__index = Button

function Button.new(runtime, parent, options)
	options = options or {}
	local theme = runtime.Theme
	local holder = Utils.create("Frame", {
		Name = options.Name or "Button",
		BackgroundColor3 = Utils.color(options.Color or "Accent", theme),
		BackgroundTransparency = options.Transparency or 0,
		BorderSizePixel = 0,
		Size = options.Size or UDim2.fromScale(1, 0.1),
		Position = options.Position or UDim2.fromScale(0, 0),
		Parent = parent or runtime.Gui,
	})
	Utils.corner(holder, options.Radius or 10)
	if options.Stroke then
		Utils.stroke(holder, Utils.color(options.StrokeColor or "Border", theme), options.StrokeTransparency or 0)
	end

	local button = Utils.button(holder)
	local text = Utils.text(holder, options.Text or "Button", theme, {
		Size = UDim2.fromScale(1, 1),
		TextSize = options.TextSize or 14,
		Color = options.TextColor or "Text",
		Font = options.Font or runtime.Options.Font,
		TextXAlignment = options.TextXAlignment or Enum.TextXAlignment.Center,
	})

	if options.Icon then
		local icon = Utils.create("ImageLabel", {
			BackgroundTransparency = 1,
			Image = options.Icon,
			ImageColor3 = Utils.color(options.IconColor or "Text", theme),
			Size = UDim2.fromScale(0.09, 0.5),
			Position = UDim2.fromScale(0.06, 0.25),
			ScaleType = Enum.ScaleType.Fit,
			Parent = holder,
		})
		runtime:track(icon)
		text.Size = UDim2.fromScale(0.79, 1)
		text.Position = UDim2.fromScale(0.16, 0)
	end

	runtime:track(holder)
	runtime:track(button)
	runtime:track(text)
	Interaction.bind(runtime, button, options)

	local self = setmetatable({Runtime = runtime, Instance = holder, Button = button, Text = text}, Button)
	if options.OnClick then
		self:connect(options.OnClick)
	end
	return self
end

function Button:connect(callback)
	return self.Runtime:connect(self.Button.Activated:Connect(function()
		callback(self)
	end))
end

function Button:setText(text)
	self.Text.Text = tostring(text)
	return self
end

function Button:setColor(value)
	self.Runtime:animate(self.Instance, {
		BackgroundColor3 = Utils.color(value, self.Runtime.Theme),
	}, 0.12)
	return self
end

function Button:setVisible(value)
	self.Instance.Visible = value == true
	return self
end

function Button:destroy()
	if self.Instance.Parent then self.Instance:Destroy() end
end

return Button

end

__sg_factories['StarGaze/Components/Checkbox'] = function()
local Utils = __sg_require('StarGaze/Core/Utils')

local Checkbox = {}
Checkbox.__index = Checkbox

function Checkbox.new(runtime, parent, options)
	options = options or {}
	local holder = runtime:card(parent, {Size = options.Size or UDim2.fromScale(1, 0.1), Color = options.Background or "Card", Radius = 10})
	local box = Utils.create("Frame", {
		BackgroundColor3 = runtime.Theme.SurfaceAlt,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(0.055, 0.55),
		Position = UDim2.fromScale(0.04, 0.225),
		Parent = holder,
	})
	Utils.corner(box, 7)
	Utils.stroke(box, runtime.Theme.Border, 0.1)
	local mark = runtime:createText(box, "✓", {Size = UDim2.fromScale(1,1), TextSize = 15, TextXAlignment = Enum.TextXAlignment.Center, Color = "Text"})
	mark.Visible = false
	local button = Utils.button(box)
	runtime:createText(holder, options.Text or "Checkbox", {Size = UDim2.fromScale(0.84,1), Position = UDim2.fromScale(0.12,0), TextSize = options.TextSize or 14})
	runtime:track(holder)
	runtime:track(box)
	runtime:track(button)
	local self = setmetatable({Runtime=runtime, Instance=holder, Box=box, Mark=mark, Value=options.Default==true}, Checkbox)
	self:update(self.Value, true)
	runtime:connect(button.Activated:Connect(function() self:update(not self.Value) end))
	return self
end

function Checkbox:update(value, silent)
	self.Value = value == true
	self.Mark.Visible = self.Value
	self.Runtime:animate(self.Box, {BackgroundColor3 = self.Value and self.Runtime.Theme.Accent or self.Runtime.Theme.SurfaceAlt})
	if self.OnChanged and not silent then self.OnChanged(self.Value) end
	return self
end
function Checkbox:set(value) return self:update(value) end
function Checkbox:get() return self.Value end
function Checkbox:changed(callback) self.OnChanged=callback return self end

return Checkbox

end

__sg_factories['StarGaze/Components/ColorPicker'] = function()
local Utils=__sg_require('StarGaze/Core/Utils')
local ColorPicker={};ColorPicker.__index=ColorPicker
function ColorPicker.new(runtime,parent,options)
	options=options or {}
	local holder=runtime:card(parent,{Size=options.Size or UDim2.fromScale(1,0.11),Color=options.Background or "Card",Radius=10})
	runtime:createText(holder,options.Text or "Color",{Size=UDim2.fromScale(0.62,1),Position=UDim2.fromScale(0.04,0),TextSize=13})
	local swatch=Utils.create("TextButton",{BackgroundColor3=options.Default or runtime.Theme.Accent,BorderSizePixel=0,Size=UDim2.fromScale(0.12,0.58),Position=UDim2.fromScale(0.82,0.21),Text="",AutoButtonColor=false,Parent=holder})
	Utils.corner(swatch,8);Utils.stroke(swatch,runtime.Theme.Border,0.2)
	local expanded=false
	local panel=runtime:createFrame(holder,{Size=UDim2.fromScale(0.94,2.2),Position=UDim2.fromScale(0.03,1.04),Color="Surface",Radius=10,Stroke=true,Visible=false,ZIndex=80})
	Utils.padding(panel,8,8,8,8);Utils.list(panel,{Padding=UDim.new(0,7)})
	local values=options.Colors or {runtime.Theme.Accent,runtime.Theme.AccentHover,runtime.Theme.Success,runtime.Theme.Warning,runtime.Theme.Danger,runtime.Theme.Info,runtime.Theme.Text}
	local self=setmetatable({Runtime=runtime,Instance=holder,Swatch=swatch,Panel=panel,Value=options.Default or values[1]},ColorPicker)
	for _,color in ipairs(values) do
		local choice=Utils.create("TextButton",{BackgroundColor3=color,BorderSizePixel=0,Size=UDim2.fromScale(1,0.11),Text="",AutoButtonColor=false,Parent=panel})
		Utils.corner(choice,8);runtime:track(choice)
		runtime:connect(choice.Activated:Connect(function() self:set(color);self:close() end))
	end
	runtime:track(holder);runtime:track(swatch);runtime:track(panel)
	runtime:connect(swatch.Activated:Connect(function() if expanded then self:close() else self:open() end end))
	return self
end
function ColorPicker:set(color) self.Value=color;self.Swatch.BackgroundColor3=color;if self.OnChanged then self.OnChanged(color,self) end;return self end
function ColorPicker:get() return self.Value end
function ColorPicker:changed(callback) self.OnChanged=callback return self end
function ColorPicker:open() self.Panel.Visible=true;self.Panel.Size=UDim2.fromScale(0.94,2.2);self.Open=true;return self end
function ColorPicker:close() self.Panel.Visible=false;self.Open=false;return self end
return ColorPicker

end

__sg_factories['StarGaze/Components/CommandPalette'] = function()
local Utils=__sg_require('StarGaze/Core/Utils')
local CommandPalette={};CommandPalette.__index=CommandPalette
function CommandPalette.new(runtime,options)
	options=options or {}
	local overlay=Utils.create("Frame",{BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.45,BorderSizePixel=0,Size=UDim2.fromScale(1,1),Visible=false,ZIndex=900,Parent=runtime.Gui})
	local root=runtime:createFrame(overlay,{Size=options.Size or UDim2.fromScale(0.54,0.62),Position=UDim2.fromScale(0.5,0.19),AnchorPoint=Vector2.new(0.5,0),Color="Surface",Radius=14,Stroke=true,ZIndex=901,ClipsDescendants=true})
	local input=runtime:input(root,{Size=UDim2.fromScale(1,0.15),Placeholder=options.Placeholder or "Search commands...",Background="SurfaceAlt"})
	local results=runtime:createContainer(root,{Size=UDim2.fromScale(0.92,0.78),Position=UDim2.fromScale(0.04,0.18),Color="Surface",Layout={Padding=UDim.new(0,5)}})
	local self=setmetatable({Runtime=runtime,Overlay=overlay,Instance=root,Input=input,Results=results,Items=options.Items or {}},CommandPalette)
	self:refresh(options.Items or {})
	input:changed(function(value) self:filter(value) end)
	return self
end
function CommandPalette:refresh(items)
	for _,child in ipairs(self.Results:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
	for _,item in ipairs(items) do
		self.Runtime:button(self.Results,{Text=item.Text or item.Name or "Command",Size=UDim2.fromScale(1,0.12),Color="SurfaceAlt",OnClick=function() if item.OnClick then item.OnClick(item,self) end end})
	end
	return self
end
function CommandPalette:filter(query)
	query=string.lower(query or "")
	local filtered={}
	for _,item in ipairs(self.Items) do
		local text=string.lower(tostring(item.Text or item.Name or ""))
		if query=="" or string.find(text,query,1,true) then table.insert(filtered,item) end
	end
	return self:refresh(filtered)
end
function CommandPalette:open() self.Overlay.Visible=true;self.Input:focus();return self end
function CommandPalette:close() self.Overlay.Visible=false;return self end
function CommandPalette:toggle() if self.Overlay.Visible then return self:close() end return self:open() end
return CommandPalette

end

__sg_factories['StarGaze/Components/Confirm'] = function()
local Utils=__sg_require('StarGaze/Core/Utils')
local Confirm={};Confirm.__index=Confirm
function Confirm.new(runtime,options)
	options=options or {}
	local overlay=Utils.create("Frame",{BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.42,BorderSizePixel=0,Size=UDim2.fromScale(1,1),ZIndex=700,Parent=runtime.Gui})
	local dialog=runtime:createFrame(overlay,{Size=options.Size or UDim2.fromScale(0.42,0.33),Position=UDim2.fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,0.5),Color=options.Color or "Surface",Radius=14,Stroke=true,ZIndex=701})
	runtime:createText(dialog,options.Title or "Confirm Action",{Size=UDim2.fromScale(0.9,0.2),Position=UDim2.fromScale(0.05,0.08),TextSize=17})
	runtime:createText(dialog,options.Text or "Are you sure?",{Size=UDim2.fromScale(0.9,0.34),Position=UDim2.fromScale(0.05,0.3),TextSize=12,Color="Subtext",TextWrapped=true,TextYAlignment=Enum.TextYAlignment.Top})
	local self=setmetatable({Runtime=runtime,Instance=overlay},Confirm)
	runtime:button(dialog,{Text=options.CancelText or "Cancel",Color="SurfaceAlt",Size=UDim2.fromScale(0.27,0.2),Position=UDim2.fromScale(0.41,0.72),OnClick=function() if options.OnCancel then options.OnCancel() end self:close() end})
	runtime:button(dialog,{Text=options.ConfirmText or "Confirm",Color=options.ConfirmColor or "Accent",Size=UDim2.fromScale(0.27,0.2),Position=UDim2.fromScale(0.71,0.72),OnClick=function() if options.OnConfirm then options.OnConfirm() end self:close() end})
	runtime:track(overlay)
	return self
end
function Confirm:close() if self.Instance.Parent then self.Instance:Destroy() end end
return Confirm

end

__sg_factories['StarGaze/Components/ContextMenu'] = function()
local Utils=__sg_require('StarGaze/Core/Utils')
local ContextMenu={};ContextMenu.__index=ContextMenu
function ContextMenu.new(runtime,options)
	options=options or {}
	local menu=runtime:createFrame(runtime.Gui,{Size=options.Size or UDim2.fromScale(0.22,0.28),Color=options.Color or "Surface",Radius=10,Stroke=true,Visible=false,ZIndex=800,Position=options.Position or UDim2.fromScale(0.5,0.5),AnchorPoint=Vector2.new(0,0)})
	Utils.padding(menu,5,5,5,5);Utils.list(menu,{Padding=UDim.new(0,4)})
	local self=setmetatable({Runtime=runtime,Instance=menu},ContextMenu)
	for _,item in ipairs(options.Items or {}) do self:add(item) end
	return self
end
function ContextMenu:add(item)
	local button=self.Runtime:button(self.Instance,{Text=item.Text or item.Name or "Action",Color="SurfaceAlt",Size=UDim2.fromScale(1,0.15),OnClick=function() if item.OnClick then item.OnClick(self) end self:close() end})
	return button
end
function ContextMenu:open(position)
	if typeof(position) == "Vector2" then
		local size = self.Runtime.Gui.AbsoluteSize
		self.Instance.Position = UDim2.fromScale(
			math.clamp(position.X / math.max(size.X, 1), 0, 0.78),
			math.clamp(position.Y / math.max(size.Y, 1), 0, 0.72)
		)
	elseif typeof(position) == "UDim2" then
		self.Instance.Position = position
	end
	self.Instance.Visible=true
	return self
end
function ContextMenu:close() self.Instance.Visible=false;return self end
function ContextMenu:toggle(position) if self.Instance.Visible then return self:close() end return self:open(position) end
return ContextMenu

end

__sg_factories['StarGaze/Components/Divider'] = function()
local Utils=__sg_require('StarGaze/Core/Utils')
local Divider={};Divider.__index=Divider
function Divider.new(runtime,parent,options)
	options=options or {}
	local line=Utils.create("Frame",{Size=options.Size or UDim2.fromScale(1,0.002),Position=options.Position or UDim2.fromScale(0,0),BackgroundColor3=Utils.color(options.Color or "BorderSoft",runtime.Theme),BackgroundTransparency=options.Transparency or 0,BorderSizePixel=0,Parent=parent or runtime.Gui})
	runtime:track(line);return setmetatable({Runtime=runtime,Instance=line},Divider)
end
return Divider

end

__sg_factories['StarGaze/Components/Dropdown'] = function()
local Utils=__sg_require('StarGaze/Core/Utils')
local Dropdown={};Dropdown.__index=Dropdown
function Dropdown.new(runtime,parent,options)
	options=options or {}
	local holder=runtime:card(parent,{Size=options.Size or UDim2.fromScale(1,0.12),Color=options.Background or "Card",Radius=options.Radius or 10,ClipsDescendants=false,ZIndex=options.ZIndex or 20})
	runtime:createText(holder,options.Text or "Select",{Size=UDim2.fromScale(0.36,1),Position=UDim2.fromScale(0.04,0),TextSize=options.TextSize or 13})
	local selected=runtime:createText(holder,tostring(options.Default or "Choose..."),{Size=UDim2.fromScale(0.42,1),Position=UDim2.fromScale(0.49,0),TextSize=12,TextXAlignment=Enum.TextXAlignment.Right,Color="Subtext"})
	local arrow=runtime:createText(holder,"⌄",{Size=UDim2.fromScale(0.08,1),Position=UDim2.fromScale(0.87,0),TextSize=16,TextXAlignment=Enum.TextXAlignment.Center,Color="Subtext"})
	local trigger=Utils.button(holder)
	local list=runtime:createFrame(holder,{Size=UDim2.fromScale(1,0),Position=UDim2.fromScale(0,1.08),Color="Surface",Radius=10,Stroke=true,Visible=false,ZIndex=(options.ZIndex or 20)+10,ClipsDescendants=true})
	Utils.padding(list,5,5,5,5)
	Utils.list(list,{Padding=UDim.new(0,4)})
	runtime:track(holder);runtime:track(trigger);runtime:track(list)
	local self=setmetatable({Runtime=runtime,Instance=holder,List=list,Selected=selected,Arrow=arrow,Value=options.Default,Expanded=false},Dropdown)
	for _,item in ipairs(options.Items or {}) do self:add(item) end
	runtime:connect(trigger.Activated:Connect(function() self:toggle() end))
	return self
end
function Dropdown:add(item)
	local button=Utils.create("TextButton",{BackgroundColor3=self.Runtime.Theme.SurfaceAlt,BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.fromScale(1,0.16),Text=tostring(item),TextColor3=self.Runtime.Theme.Text,TextSize=12,Font=self.Runtime.Options.Font,AutoButtonColor=false,Parent=self.List})
	Utils.corner(button,8);self.Runtime:track(button)
	self.Runtime:connect(button.MouseEnter:Connect(function() self.Runtime:animate(button,{BackgroundTransparency=0},0.1) end))
	self.Runtime:connect(button.MouseLeave:Connect(function() self.Runtime:animate(button,{BackgroundTransparency=1},0.1) end))
	self.Runtime:connect(button.Activated:Connect(function() self:set(item);self:close() end))
	return self
end
function Dropdown:open()
	self.Expanded=true;self.List.Visible=true;self.Arrow.Text="⌃"
	local count=0
	for _,child in ipairs(self.List:GetChildren()) do if child:IsA("TextButton") then count+=1 end end
	self.Runtime:animate(self.List,{Size=UDim2.fromScale(1,math.clamp(count*0.17+0.04,0.08,0.9))},0.15)
	return self
end
function Dropdown:close() self.Expanded=false;self.List.Visible=false;self.Arrow.Text="⌄";return self end
function Dropdown:toggle() if self.Expanded then return self:close() end return self:open() end
function Dropdown:set(value) self.Value=value;self.Selected.Text=tostring(value);if self.OnChanged then self.OnChanged(value,self) end;return self end
function Dropdown:get() return self.Value end
function Dropdown:changed(callback) self.OnChanged=callback return self end
return Dropdown

end

__sg_factories['StarGaze/Components/Input'] = function()
local Utils = __sg_require('StarGaze/Core/Utils')

local Input = {}
Input.__index = Input

function Input.new(runtime,parent,options)
	options=options or {}
	local holder=runtime:card(parent,{Size=options.Size or UDim2.fromScale(1,0.12),Color=options.Background or "Card",Radius=options.Radius or 10})
	if options.Label then runtime:createText(holder,options.Label,{Size=UDim2.fromScale(0.23,1),Position=UDim2.fromScale(0.04,0),TextSize=options.LabelSize or 13}) end
	local box=Utils.create("Frame",{BackgroundColor3=runtime.Theme.SurfaceAlt,BorderSizePixel=0,Size=options.Label and UDim2.fromScale(0.67,0.66) or UDim2.fromScale(0.92,0.66),Position=options.Label and UDim2.fromScale(0.29,0.17) or UDim2.fromScale(0.04,0.17),Parent=holder})
	Utils.corner(box,8)
	Utils.stroke(box,runtime.Theme.Border,0.25)
	local field=Utils.create("TextBox",{BackgroundTransparency=1,BorderSizePixel=0,ClearTextOnFocus=false,Size=UDim2.fromScale(0.94,1),Position=UDim2.fromScale(0.03,0),Text=options.Default or "",PlaceholderText=options.Placeholder or "Type here...",TextColor3=runtime.Theme.Text,PlaceholderColor3=runtime.Theme.Subtext,TextSize=options.TextSize or 13,Font=runtime.Options.Font,TextXAlignment=Enum.TextXAlignment.Left,Parent=box})
	if options.MultiLine then field.MultiLine=true end
	runtime:track(holder);runtime:track(box);runtime:track(field)
	local self=setmetatable({Runtime=runtime,Instance=holder,Field=field},Input)
	runtime:connect(field.FocusLost:Connect(function(enter) if self.OnFocusLost then self.OnFocusLost(field.Text,enter,self) end end))
	return self
end
function Input:get() return self.Field.Text end
function Input:set(value) self.Field.Text=tostring(value) return self end
function Input:changed(callback) self.OnChanged=callback;self.Runtime:connect(self.Field:GetPropertyChangedSignal("Text"):Connect(function() callback(self.Field.Text,self) end));return self end
function Input:focus() self.Field:CaptureFocus();return self end
function Input:focusLost(callback) self.OnFocusLost=callback return self end
return Input

end

__sg_factories['StarGaze/Components/Keybind'] = function()
local Utils = __sg_require('StarGaze/Core/Utils')
local UserInputService = game:GetService("UserInputService")

local Keybind = {}
Keybind.__index = Keybind

function Keybind.new(runtime, parent, options)
	options = options or {}
	local holder = runtime:card(parent, {Size = options.Size or UDim2.fromScale(1, 0.1), Color = options.Background or "Card", Radius = 10})
	runtime:createText(holder, options.Text or "Keybind", {Size = UDim2.fromScale(0.55, 1), Position = UDim2.fromScale(0.04, 0), TextSize = options.TextSize or 13})
	local button = Utils.create("TextButton", {BackgroundColor3 = runtime.Theme.SurfaceAlt, BorderSizePixel = 0, Size = UDim2.fromScale(0.28, 0.64), Position = UDim2.fromScale(0.66, 0.18), Text = options.Key and options.Key.Name or "Set Key", TextColor3 = runtime.Theme.Subtext, TextSize = 11, Font = runtime.Options.Font, AutoButtonColor = false, Parent = holder})
	Utils.corner(button, 8)
	runtime:track(holder); runtime:track(button)
	local self = setmetatable({Runtime = runtime, Instance = holder, Button = button, Key = options.Key, Listening = false}, Keybind)
	runtime:connect(button.Activated:Connect(function() self:capture() end))
	if options.Key and options.OnPressed then
		runtime:connect(UserInputService.InputBegan:Connect(function(input, processed)
			if not processed and input.KeyCode == self.Key then options.OnPressed(self, input) end
		end))
	end
	return self
end

function Keybind:capture()
	self.Listening = true
	self.Button.Text = "Press key..."
	return self
end

function Keybind:listen(callback)
	self.Runtime:connect(UserInputService.InputBegan:Connect(function(input, processed)
		if not self.Listening or processed then return end
		if input.KeyCode == Enum.KeyCode.Unknown then return end
		self.Key = input.KeyCode
		self.Button.Text = input.KeyCode.Name
		self.Listening = false
		if callback then callback(self.Key, self) end
	end))
	return self
end

function Keybind:set(key)
	self.Key = key
	self.Button.Text = key and key.Name or "Set Key"
	return self
end

function Keybind:get() return self.Key end
return Keybind

end

__sg_factories['StarGaze/Components/Notification'] = function()
local Utils=__sg_require('StarGaze/Core/Utils')
local Notification={};Notification.__index=Notification
local colors={Success="Success",Warning="Warning",Danger="Danger",Info="Info",Default="Accent"}
function Notification.new(runtime,options)
	options=options or {}
	local layer=runtime:getLayer("Notifications")
	if not layer then
		layer=Utils.create("Frame",{BackgroundTransparency=1,Size=UDim2.fromScale(0.31,0.92),Position=UDim2.fromScale(0.67,0.04),Parent=runtime.Gui,ZIndex=300})
		Utils.list(layer,{HorizontalAlignment=Enum.HorizontalAlignment.Right,VerticalAlignment=Enum.VerticalAlignment.Top,Padding=UDim.new(0,8)})
		runtime:track(layer);runtime:registerLayer("Notifications",layer)
	end
	local card=runtime:createFrame(layer,{Size=options.Size or UDim2.fromScale(0.98,0.095),Color=options.Color or "Surface",Transparency=options.Transparency or 0,Radius=12,Stroke=true,StrokeTransparency=0.4,ZIndex=301})
	local accent=Utils.create("Frame",{Size=UDim2.fromScale(0.012,0.78),Position=UDim2.fromScale(0.035,0.11),BackgroundColor3=Utils.color(colors[options.Type or "Default"] or "Accent",runtime.Theme),BorderSizePixel=0,Parent=card})
	Utils.corner(accent,999)
	runtime:createText(card,options.Title or "Notification",{Size=UDim2.fromScale(0.88,0.28),Position=UDim2.fromScale(0.085,0.1),TextSize=13})
	runtime:createText(card,options.Text or "",{Size=UDim2.fromScale(0.88,0.46),Position=UDim2.fromScale(0.085,0.4),TextSize=11,Color="Subtext",TextWrapped=true,TextYAlignment=Enum.TextYAlignment.Top})
	local self=setmetatable({Runtime=runtime,Instance=card},Notification)
	runtime:animate(card,{Position=UDim2.fromScale(0,0)},0.2,Enum.EasingStyle.Quint)
	task.delay(options.Duration or 4,function() if card.Parent then self:close() end end)
	return self
end
function Notification:close()
	local tween=self.Runtime:animate(self.Instance,{BackgroundTransparency=1},0.18)
	tween.Completed:Connect(function() if self.Instance.Parent then self.Instance:Destroy() end end)
end
return Notification

end

__sg_factories['StarGaze/Components/Progress'] = function()
local Utils = __sg_require('StarGaze/Core/Utils')
local Progress = {}
Progress.__index=Progress
function Progress.new(runtime,parent,options)
	options=options or {}
	local holder=runtime:card(parent,{Size=options.Size or UDim2.fromScale(1,0.1),Color=options.Background or "Card",Radius=options.Radius or 10})
	runtime:createText(holder,options.Text or "Progress",{Size=UDim2.fromScale(0.24,1),Position=UDim2.fromScale(0.04,0),TextSize=options.TextSize or 13})
	local bar=Utils.create("Frame",{BackgroundColor3=runtime.Theme.SurfaceAlt,BorderSizePixel=0,Size=UDim2.fromScale(0.58,0.28),Position=UDim2.fromScale(0.31,0.36),Parent=holder})
	Utils.corner(bar,999)
	local fill=Utils.create("Frame",{BackgroundColor3=Utils.color(options.Color or "Accent",runtime.Theme),BorderSizePixel=0,Size=UDim2.fromScale(0,1),Parent=bar})
	Utils.corner(fill,999)
	local valueText=runtime:createText(holder,"0%",{Size=UDim2.fromScale(0.08,1),Position=UDim2.fromScale(0.9,0),TextSize=11,TextXAlignment=Enum.TextXAlignment.Right,Color="Subtext"})
	runtime:track(holder);runtime:track(bar);runtime:track(fill)
	local self=setmetatable({Runtime=runtime,Instance=holder,Fill=fill,ValueText=valueText,Value=0},Progress)
	self:set(options.Default or 0)
	return self
end
function Progress:set(value)
	self.Value=math.clamp(value,0,1)
	self.Runtime:animate(self.Fill,{Size=UDim2.fromScale(self.Value,1)},0.15)
	self.ValueText.Text=tostring(math.floor(self.Value*100+0.5)).."%"
	return self
end
function Progress:get() return self.Value end
return Progress

end

__sg_factories['StarGaze/Components/Radio'] = function()
local Utils = __sg_require('StarGaze/Core/Utils')

local Radio = {}
Radio.__index = Radio

function Radio.new(runtime, parent, options)
	options = options or {}
	local holder = runtime:card(parent, {Size = options.Size or UDim2.fromScale(1,0.1), Color = options.Background or "Card", Radius = 10})
	local outer = Utils.create("Frame", {BackgroundColor3 = runtime.Theme.SurfaceAlt, BorderSizePixel=0, Size=UDim2.fromScale(0.055,0.55), Position=UDim2.fromScale(0.04,0.225), Parent=holder})
	Utils.corner(outer,999)
	Utils.stroke(outer,runtime.Theme.Border,0.1)
	local dot = Utils.create("Frame", {BackgroundColor3 = runtime.Theme.Accent, BorderSizePixel=0, Size=UDim2.fromScale(0.45,0.45), Position=UDim2.fromScale(0.275,0.275), Visible=false, Parent=outer})
	Utils.corner(dot,999)
	local button = Utils.button(outer)
	runtime:createText(holder, options.Text or "Option", {Size=UDim2.fromScale(0.84,1), Position=UDim2.fromScale(0.12,0), TextSize=options.TextSize or 14})
	local self = setmetatable({Runtime=runtime, Instance=holder, Dot=dot, Button=button, Value=options.Default==true}, Radio)
	self:update(self.Value,true)
	runtime:connect(button.Activated:Connect(function() self:update(true) end))
	return self
end
function Radio:update(value,silent)
	self.Value=value==true
	self.Dot.Visible=self.Value
	if self.OnChanged and not silent then self.OnChanged(self.Value,self) end
	return self
end
function Radio:set(value) return self:update(value) end
function Radio:get() return self.Value end
function Radio:changed(callback) self.OnChanged=callback return self end

function Radio:group(radios)
	for _, radio in ipairs(radios or {}) do
		if radio ~= self and radio.set then
			local original = radio.OnChanged
			radio.OnChanged = function(value, instance)
				if value then self:set(false) end
				if original then original(value, instance) end
			end
		end
	end
	return self
end

return Radio

end

__sg_factories['StarGaze/Components/Segmented'] = function()
local Utils = __sg_require('StarGaze/Core/Utils')
local Segmented = {}
Segmented.__index = Segmented
function Segmented.new(runtime,parent,options)
	options=options or {}
	local root=runtime:card(parent,{Size=options.Size or UDim2.fromScale(1,0.1),Color=options.Background or "SurfaceAlt",Radius=options.Radius or 10})
	Utils.padding(root,4,4,4,4);Utils.list(root,{Direction=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,4),Wraps=true})
	local self=setmetatable({Runtime=runtime,Instance=root,Items={},Value=options.Default},Segmented)
	for _,item in ipairs(options.Items or {}) do self:add(item) end
	if self.Value then self:select(self.Value) elseif options.Items and options.Items[1] then self:select(options.Items[1].Value or options.Items[1].Name or options.Items[1]) end
	return self
end
function Segmented:add(item)
	local name=item.Value or item.Name or item
	local text=item.Text or item.Name or tostring(name)
	local button=Utils.create("TextButton",{BackgroundColor3=self.Runtime.Theme.SurfaceAlt,BackgroundTransparency=1,BorderSizePixel=0,Size=item.Size or UDim2.fromScale(0.2,0.8),Text=text,TextColor3=self.Runtime.Theme.Text,TextSize=item.TextSize or 12,Font=self.Runtime.Options.Font,AutoButtonColor=false,Parent=self.Instance})
	Utils.corner(button,7);self.Runtime:track(button);self.Items[name]={Button=button,Definition=item}
	self.Runtime:connect(button.Activated:Connect(function() self:select(name) end))
	return self
end
function Segmented:select(name)
	local entry=self.Items[name];if not entry then return self end
	for key,item in pairs(self.Items) do
		local active=key==name
		self.Runtime:animate(item.Button,{BackgroundColor3=active and self.Runtime.Theme.Accent or self.Runtime.Theme.SurfaceAlt,BackgroundTransparency=active and 0 or 1},0.12)
	end
	self.Value=name
	if entry.Definition.OnSelected then entry.Definition.OnSelected(name,self) end
	if self.OnChanged then self.OnChanged(name,self) end
	return self
end
function Segmented:changed(callback) self.OnChanged=callback return self end
function Segmented:get() return self.Value end
return Segmented

end

__sg_factories['StarGaze/Components/Slider'] = function()
local Utils = __sg_require('StarGaze/Core/Utils')

local Slider = {}
Slider.__index = Slider

function Slider.new(runtime, parent, options)
	options = options or {}
	local min,max=options.Min or 0, options.Max or 100
	local value=math.clamp(options.Default or min,min,max)
	local holder=runtime:card(parent,{Size=options.Size or UDim2.fromScale(1,0.14),Color=options.Background or "Card",Radius=options.Radius or 10})
	runtime:createText(holder,options.Text or "Slider",{Size=UDim2.fromScale(0.72,0.36),Position=UDim2.fromScale(0.04,0.04),TextSize=options.TextSize or 14})
	local valueText=runtime:createText(holder,tostring(value),{Size=UDim2.fromScale(0.2,0.36),Position=UDim2.fromScale(0.76,0.04),TextSize=12,TextXAlignment=Enum.TextXAlignment.Right,Color="Subtext"})
	local bar=Utils.create("Frame",{BackgroundColor3=runtime.Theme.SurfaceAlt,BorderSizePixel=0,Size=UDim2.fromScale(0.92,0.1),Position=UDim2.fromScale(0.04,0.72),Parent=holder})
	Utils.corner(bar,999)
	local fill=Utils.create("Frame",{BackgroundColor3=runtime.Theme.Accent,BorderSizePixel=0,Size=UDim2.fromScale(0,1),Parent=bar})
	Utils.corner(fill,999)
	local button=Utils.button(bar)
	local drag=false
	local self=setmetatable({Runtime=runtime,Instance=holder,Bar=bar,Fill=fill,Value=value,Min=min,Max=max,ValueText=valueText,Formatter=options.Format},Slider)
	runtime:track(holder);runtime:track(bar);runtime:track(fill);runtime:track(button)
	local function update(input)
		local alpha=math.clamp((input.Position.X-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1)
		self:set(min+(max-min)*alpha)
	end
	runtime:connect(button.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then drag=true;update(input) end end))
	runtime:connect(game:GetService("UserInputService").InputChanged:Connect(function(input) if drag and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then update(input) end end))
	runtime:connect(game:GetService("UserInputService").InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then drag=false end end))
	self:set(value,true)
	return self
end
function Slider:set(value,silent)
	self.Value=math.clamp(value,self.Min,self.Max)
	local alpha=(self.Value-self.Min)/math.max(self.Max-self.Min,0.00001)
	self.Runtime:animate(self.Fill,{Size=UDim2.fromScale(alpha,1)},0.08)
	self.ValueText.Text=self.Formatter and self.Formatter(self.Value) or tostring(math.floor(self.Value*100)/100)
	if self.OnChanged and not silent then self.OnChanged(self.Value) end
	return self
end
function Slider:get() return self.Value end
function Slider:changed(callback) self.OnChanged=callback return self end
function Slider:format(callback)
	assert(callback == nil or type(callback) == "function", "Slider formatter must be a function")
	self.Formatter = callback
	self:set(self.Value, true)
	return self
end
return Slider

end

__sg_factories['StarGaze/Components/Tabs'] = function()
local Utils=__sg_require('StarGaze/Core/Utils')
local Tabs={};Tabs.__index=Tabs
function Tabs.new(runtime,parent,options)
	options=options or {}
	local root=runtime:card(parent,{Size=options.Size or UDim2.fromScale(1,1),Color=options.Color or "Background",Radius=options.Radius or 10})
	local header=runtime:createFrame(root,{Size=UDim2.fromScale(1,0.12),Color=options.HeaderColor or "SurfaceAlt",Radius=10})
	Utils.padding(header,0,0,0,0);Utils.list(header,{Direction=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Left,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,4),Wraps=true})
	local pageHolder=runtime:createFrame(root,{Size=UDim2.fromScale(1,0.84),Position=UDim2.fromScale(0,0.15),Color=options.PageColor or "Background",Radius=10})
	local self=setmetatable({Runtime=runtime,Instance=root,Header=header,Pages=pageHolder,Items={},Active=nil},Tabs)
	for _,def in ipairs(options.Tabs or {}) do self:add(def) end
	local first=options.Default or (options.Tabs[1] and options.Tabs[1].Name)
	if first then self:select(first) end
	return self
end
function Tabs:add(def)
	local button=Utils.create("TextButton",{BackgroundColor3=self.Runtime.Theme.SurfaceAlt,BackgroundTransparency=1,BorderSizePixel=0,Size=def.Size or UDim2.fromScale(0.16,0.74),Text=def.Text or def.Name,TextColor3=self.Runtime.Theme.Text,TextSize=def.TextSize or 12,Font=self.Runtime.Options.Font,AutoButtonColor=false,Parent=self.Header})
	Utils.corner(button,8)
	local page=self.Runtime:createFrame(self.Pages,{Name=def.Name,Size=UDim2.fromScale(1,1),Color=def.Color or "Background",Radius=0,Visible=false})
	local entry={Button=button,Page=page,Definition=def};self.Items[def.Name]=entry
	self.Runtime:track(button);self.Runtime:connect(button.Activated:Connect(function() self:select(def.Name) end))
	if def.Build then def.Build(page,self.Runtime,self) end
	return self
end
function Tabs:select(name)
	local entry=self.Items[name];if not entry then return self end
	for key,item in pairs(self.Items) do
		local active=key==name;item.Page.Visible=active
		self.Runtime:animate(item.Button,{BackgroundColor3=active and self.Runtime.Theme.Accent or self.Runtime.Theme.SurfaceAlt,BackgroundTransparency=active and 0 or 1},0.12)
	end
	self.Active=name
	if entry.Definition.OnSelected then entry.Definition.OnSelected(entry.Page,self) end
	return self
end
function Tabs:get() return self.Active end
return Tabs

end

__sg_factories['StarGaze/Components/Toggle'] = function()
local Utils = __sg_require('StarGaze/Core/Utils')

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(runtime, parent, options)
	options = options or {}
	local holder = runtime:card(parent, {
		Name = options.Name or "Toggle",
		Size = options.Size or UDim2.fromScale(1, 0.11),
		Color = options.Background or "Card",
		Radius = options.Radius or 10,
	})

	runtime:createText(holder, options.Text or "Toggle", {
		Size = UDim2.fromScale(0.72, 1),
		Position = UDim2.fromScale(0.04, 0),
		TextSize = options.TextSize or 14,
	})

	local switch = Utils.create("Frame", {
		BackgroundColor3 = runtime.Theme.SurfaceAlt,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(0.13, 0.46),
		Position = UDim2.fromScale(0.83, 0.27),
		Parent = holder,
	})
	Utils.corner(switch, 999)

	local button = Utils.button(switch)
	local knob = Utils.create("Frame", {
		BackgroundColor3 = runtime.Theme.Text,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(0.42, 0.72),
		Position = UDim2.fromScale(0.06, 0.14),
		Parent = switch,
	})
	Utils.corner(knob, 999)

	runtime:track(switch)
	runtime:track(button)
	runtime:track(knob)

	local self = setmetatable({Runtime = runtime, Instance = holder, Switch = switch, Knob = knob, Value = options.Default == true}, Toggle)
	self:update(self.Value, true)
	runtime:connect(button.Activated:Connect(function() self:update(not self.Value) end))
	return self
end

function Toggle:update(value, silent)
	self.Value = value == true
	self.Runtime:animate(self.Switch, {BackgroundColor3 = self.Value and self.Runtime.Theme.Accent or self.Runtime.Theme.SurfaceAlt})
	self.Runtime:animate(self.Knob, {Position = self.Value and UDim2.fromScale(0.52, 0.14) or UDim2.fromScale(0.06, 0.14)})
	if self.OnChanged and not silent then self.OnChanged(self.Value) end
	return self
end

function Toggle:set(value) return self:update(value) end
function Toggle:toggle() return self:update(not self.Value) end
function Toggle:get() return self.Value end
function Toggle:changed(callback) self.OnChanged = callback return self end

return Toggle

end

__sg_factories['StarGaze/Components/Tooltip'] = function()
local Utils=__sg_require('StarGaze/Core/Utils')
local Tooltip={};Tooltip.__index=Tooltip
function Tooltip.new(runtime,target,options)
	options=options or {}
	local tip=runtime:createFrame(runtime.Gui,{Size=options.Size or UDim2.fromScale(0.16,0.06),Color=options.Color or "Surface",Radius=8,Stroke=true,Visible=false,ZIndex=500})
	runtime:createText(tip,options.Text or "",{Size=UDim2.fromScale(0.94,0.9),Position=UDim2.fromScale(0.03,0.05),TextSize=10,TextWrapped=true})
	local self=setmetatable({Runtime=runtime,Instance=tip},Tooltip)
	runtime:connect(target.MouseEnter:Connect(function()
		local pos=target.AbsolutePosition;local root=runtime.Gui.AbsoluteSize
		local sx=(pos.X+target.AbsoluteSize.X+8)/math.max(root.X,1);local sy=(pos.Y+target.AbsoluteSize.Y*0.5)/math.max(root.Y,1)
		tip.Position=UDim2.fromScale(math.clamp(sx,0.01,0.84),math.clamp(sy,0.02,0.92));tip.Visible=true
	end))
	runtime:connect(target.MouseLeave:Connect(function() tip.Visible=false end))
	return self
end
return Tooltip

end

__sg_factories['StarGaze/Components/Window'] = function()
local Utils = __sg_require('StarGaze/Core/Utils')

local Window = {}
Window.__index = Window

function Window.new(runtime, options)
	options = options or {}
	local root = runtime:glass(runtime.Gui, {
		Name = options.Name or "Window",
		Size = options.Size or UDim2.fromScale(0.62, 0.68),
		Position = options.Position or UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Color = options.Color or "Surface",
		Transparency = options.Transparency or 0,
		Radius = options.Radius or 16,
		Stroke = true,
		StrokeTransparency = 0.3,
		ClipsDescendants = true,
		ZIndex = options.ZIndex or 10,
	})

	local top = runtime:createFrame(root, {
		Size = UDim2.fromScale(1, 0.11),
		Color = options.TopbarColor or "SurfaceAlt",
		Radius = 0,
		ZIndex = root.ZIndex + 1,
	})

	local title = runtime:createText(top, options.Title or "StarGaze", {
		Size = UDim2.fromScale(0.68, 0.52),
		Position = UDim2.fromScale(0.035, 0.1),
		TextSize = options.TitleSize or 17,
		Font = options.TitleFont or runtime.Options.Font,
	})

	local subtitle
	if options.Subtitle then
		subtitle = runtime:createText(top, options.Subtitle, {
			Size = UDim2.fromScale(0.68, 0.3),
			Position = UDim2.fromScale(0.035, 0.57),
			TextSize = options.SubtitleSize or 10,
			Color = "Subtext",
		})
	end

	runtime:button(top, {
		Text = "×",
		Color = "Danger",
		Size = UDim2.fromScale(0.07, 0.63),
		Position = UDim2.fromScale(0.9, 0.185),
		Radius = 10,
		TextSize = 20,
		ZIndex = top.ZIndex + 2,
		OnClick = function()
			root.Visible = false
			if options.OnClose then options.OnClose() end
		end,
	})

	local content = runtime:createFrame(root, {
		Name = "Content",
		Size = UDim2.fromScale(0.94, 0.84),
		Position = UDim2.fromScale(0.03, 0.14),
		Color = options.ContentColor or "Background",
		Radius = 12,
		ClipsDescendants = true,
	})

	if options.Padding then
		Utils.padding(content, options.Padding, options.Padding, options.Padding, options.Padding)
	end

	local self = setmetatable({Runtime = runtime, Instance = root, Content = content, Title = title, Subtitle = subtitle, OriginalSize = root.Size}, Window)
	runtime.Windows[options.Name or "Window"] = self
	return self
end

function Window:open()
	self.Instance.Visible = true
	self.Instance.Size = UDim2.new(
		self.OriginalSize.X.Scale * 0.96,
		self.OriginalSize.X.Offset * 0.96,
		self.OriginalSize.Y.Scale * 0.96,
		self.OriginalSize.Y.Offset * 0.96
	)
	self.Runtime:animate(self.Instance, {Size = self.OriginalSize}, 0.22, Enum.EasingStyle.Quint)
	return self
end

function Window:close()
	self.Instance.Visible = false
	return self
end

function Window:toggle()
	if self.Instance.Visible then return self:close() end
	return self:open()
end

function Window:setTitle(value)
	self.Title.Text = tostring(value)
	return self
end

function Window:setSubtitle(value)
	if self.Subtitle then
		self.Subtitle.Text = tostring(value)
	end
	return self
end

return Window

end

__sg_factories['StarGaze/Core/Interaction'] = function()
local Utils = __sg_require('StarGaze/Core/Utils')

local Interaction = {}

function Interaction.bind(runtime, instance, options)
	options = options or {}
	local scale = instance:FindFirstChildOfClass("UIScale") or Utils.scale(instance, 1)
	local normalColor = instance.BackgroundColor3
	local normalTransparency = instance.BackgroundTransparency
	local hoverColor = options.HoverColor and Utils.color(options.HoverColor, runtime.Theme) or normalColor
	local pressedColor = options.PressedColor and Utils.color(options.PressedColor, runtime.Theme) or hoverColor
	local hoverTransparency = options.HoverTransparency or math.max(0, normalTransparency - 0.08)
	local pressedTransparency = options.PressedTransparency or math.max(0, hoverTransparency - 0.06)

	if options.Hover ~= false then
		runtime:connect(instance.MouseEnter:Connect(function()
			runtime:animate(instance, {
				BackgroundColor3 = hoverColor,
				BackgroundTransparency = hoverTransparency,
			}, 0.12)
		end))

		runtime:connect(instance.MouseLeave:Connect(function()
			runtime:animate(instance, {
				BackgroundColor3 = normalColor,
				BackgroundTransparency = normalTransparency,
			}, 0.14)
		end))
	end

	if options.Press ~= false then
		runtime:connect(instance.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				runtime:animate(scale, {Scale = options.PressScale or 0.985}, 0.08)
				runtime:animate(instance, {
					BackgroundColor3 = pressedColor,
					BackgroundTransparency = pressedTransparency,
				}, 0.08)
			end
		end))

		runtime:connect(instance.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				runtime:animate(scale, {Scale = 1}, 0.1)
			end
		end))
	end

	return scale
end

return Interaction

end

__sg_factories['StarGaze/Core/Plugins'] = function()
local Utils = __sg_require('StarGaze/Core/Utils')

local Plugins = {}
Plugins.__index = Plugins

function Plugins.new(runtime)
	return setmetatable({
		Runtime = runtime,
		Loaded = {},
		Order = {},
	}, Plugins)
end

function Plugins:register(plugin, options)
	assert(type(plugin) == "table", "StarGaze plugin must be a table")
	assert(type(plugin.Name) == "string" and plugin.Name ~= "", "StarGaze plugin needs a Name")

	if self.Loaded[plugin.Name] then
		self:unregister(plugin.Name)
	end

	local context = {
		Runtime = self.Runtime,
		Options = Utils.merge({}, options or {}),
		Plugin = plugin,
	}

	self.Loaded[plugin.Name] = {
		Definition = plugin,
		Context = context,
	}
	table.insert(self.Order, plugin.Name)

	if type(plugin.Setup) == "function" then
		local success, errorMessage = pcall(plugin.Setup, context)
		if not success then
			self:unregister(plugin.Name)
			error("[StarGaze] Plugin " .. plugin.Name .. " failed during Setup: " .. tostring(errorMessage), 2)
		end
	end

	return context
end

function Plugins:unregister(name)
	local entry = self.Loaded[name]
	if not entry then
		return false
	end

	if type(entry.Definition.Destroy) == "function" then
		pcall(entry.Definition.Destroy, entry.Context)
	end

	self.Loaded[name] = nil
	for index, pluginName in ipairs(self.Order) do
		if pluginName == name then
			table.remove(self.Order, index)
			break
		end
	end

	return true
end

function Plugins:get(name)
	local entry = self.Loaded[name]
	return entry and entry.Context or nil
end

function Plugins:list()
	local result = {}
	for _, name in ipairs(self.Order) do
		table.insert(result, name)
	end
	return result
end

function Plugins:destroy()
	local names = {}
	for _, name in ipairs(self.Order) do
		table.insert(names, name)
	end
	for _, name in ipairs(names) do
		self:unregister(name)
	end
end

return Plugins

end

__sg_factories['StarGaze/Core/Presets'] = function()
return {
	Styles = {
		Soft = "Soft",
		Sharp = "Sharp",
		Glass = "Glass",
		Dense = "Dense",
	},
	Templates = {
		MinimalWindow = "MinimalWindow",
		Dashboard = "Dashboard",
		CompactPanel = "CompactPanel",
		Inspector = "Inspector",
	},
	Primary = {
		Color = "Accent",
		HoverColor = "AccentHover",
		PressedColor = "AccentPressed",
		TextColor = "Text",
		Radius = 10,
	},
	Secondary = {
		Color = "SurfaceAlt",
		HoverColor = "SurfaceRaised",
		PressedColor = "Surface",
		TextColor = "Text",
		Radius = 10,
	},
	Ghost = {
		Color = "SurfaceAlt",
		Transparency = 1,
		HoverTransparency = 0.88,
		PressedTransparency = 0.78,
		TextColor = "Text",
		Radius = 10,
	},
	Danger = {
		Color = "Danger",
		HoverColor = "Danger",
		PressedColor = "Danger",
		TextColor = "Text",
		Radius = 10,
	},
	Glass = {
		Color = "Glass",
		Transparency = 0.14,
		Radius = 14,
		Stroke = true,
		StrokeTransparency = 0.35,
	},
	Card = {
		Color = "Card",
		Radius = 12,
		Stroke = true,
		StrokeTransparency = 0.45,
	},
	Pill = {
		Radius = 999,
	},
}

end

__sg_factories['StarGaze/Core/Responsive'] = function()
local Utils = __sg_require('StarGaze/Core/Utils')

local Responsive = {}

function Responsive.apply(runtime, root, options)
	options = options or {}
	local uiScale = Utils.scale(root, options.Scale or 1)
	local camera = workspace.CurrentCamera
	local connection

	local function update()
		if not camera then return end
		local width = camera.ViewportSize.X
		local height = camera.ViewportSize.Y
		local base = options.BaseWidth or 1440
		local scale = math.clamp(width / base, options.Min or 0.75, options.Max or 1.15)
		if height < (options.SmallHeight or 700) then
			scale *= options.SmallMultiplier or 0.94
		end
		runtime:animate(uiScale, {Scale = scale}, 0.16)
	end

	connection = runtime:connect(camera:GetPropertyChangedSignal("ViewportSize"):Connect(update))
	update()

	return uiScale, connection
end

return Responsive

end

__sg_factories['StarGaze/Core/Runtime'] = function()
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Utils = __sg_require('StarGaze/Core/Utils')
local Themes = __sg_require('StarGaze/Core/Themes')
local Elements = __sg_require('StarGaze/Elements')
local Plugins = __sg_require('StarGaze/Core/Plugins')
local Styles = __sg_require('StarGaze/Core/Styles')
local Templates = __sg_require('StarGaze/Core/Templates')
local Settings = __sg_require('StarGaze/Core/Settings')

local Runtime = {}
Runtime.__index = Runtime

local Defaults = {
	Name = "StarGaze",
	Theme = "Obsidian",
	AnimationSpeed = 0.18,
	Font = Enum.Font.Gotham,
	DisplayOrder = 100,
}

function Runtime.new(options)
	options = Utils.merge(Defaults, options or {})
	local self = setmetatable({
		Options = options,
		Theme = Themes.resolve(options.Theme),
		Connections = {},
		Instances = {},
		ThemeListeners = {},
		Windows = {},
		Layers = {},
		Styles = nil,
		Templates = nil,
		Settings = nil,		
		Plugins = nil,
	}, Runtime)

	local parent = options.Parent or Players.LocalPlayer:WaitForChild("PlayerGui")

	self.Gui = Utils.create("ScreenGui", {
		Name = options.Name,
		ResetOnSpawn = false,
		IgnoreGuiInset = options.IgnoreGuiInset == true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = options.DisplayOrder,
		Parent = parent,
	})

	self:track(self.Gui)
	self.Settings = Settings.new(self, options.Settings)
	self.Options = Utils.merge(self.Options, self.Settings:all())
	self.Styles = Styles.new(self)
	self.Templates = Templates.new(self)
	self.Plugins = Plugins.new(self)
	self._elements = Elements.new(self)

	return self
end

function Runtime:track(instance)
	if instance then
		table.insert(self.Instances, instance)
	end
	return instance
end

function Runtime:connect(connection)
	if connection then
		table.insert(self.Connections, connection)
	end
	return connection
end

function Runtime:animate(instance, properties, duration, style, direction)
	local tween = TweenService:Create(instance, TweenInfo.new(
		duration or self.Options.AnimationSpeed,
		style or Enum.EasingStyle.Quart,
		direction or Enum.EasingDirection.Out
	), properties)
	tween:Play()
	return tween
end

function Runtime:onThemeChanged(callback)
	table.insert(self.ThemeListeners, callback)
	return callback
end

function Runtime:setTheme(theme)
	local nextTheme = Themes.resolve(theme)
	if not nextTheme then
		return false
	end
	self.Theme = nextTheme
	for _, callback in ipairs(self.ThemeListeners) do
		callback(nextTheme)
	end
	return true
end

function Runtime:registerLayer(name, instance)
	self.Layers[name] = instance
	return instance
end

function Runtime:getLayer(name)
	return self.Layers[name]
end


function Runtime:configure(values)
	values = values or {}
	self.Settings:update(values)
	self.Options = Utils.merge(self.Options, values)
	if values.AnimationSpeed ~= nil then
		self.Options.AnimationSpeed = math.max(0, values.AnimationSpeed)
	end
	return self
end

function Runtime:setting(key, value)
	if value == nil then
		return self.Settings:get(key)
	end
	self.Settings:set(key, value)
	self.Options[key] = value
	return self
end

function Runtime:registerPlugin(plugin, options)
	return self.Plugins:register(plugin, options)
end

function Runtime:unregisterPlugin(name)
	return self.Plugins:unregister(name)
end

function Runtime:getPlugin(name)
	return self.Plugins:get(name)
end

function Runtime:listPlugins()
	return self.Plugins:list()
end

function Runtime:registerStyle(name, definition)
	return self.Styles:register(name, definition)
end

function Runtime:applyStyle(instance, style, overrides)
	return self.Styles:apply(instance, style, overrides)
end

function Runtime:registerTemplate(name, definition)
	return self.Templates:register(name, definition)
end

function Runtime:template(name, overrides)
	return self.Templates:resolve(name, overrides)
end

function Runtime:createFrame(parent, options)
	return self._elements:frame(parent, options)
end

function Runtime:createText(parent, text, options)
	return self._elements:text(parent, text, options)
end

function Runtime:createContainer(parent, options)
	return self._elements:container(parent, options)
end

function Runtime:scroll(parent, options)
	return self._elements:scroll(parent, options)
end

function Runtime:button(parent, options)
	return __sg_require('StarGaze/Components/Button').new(self, parent, options)
end

function Runtime:toggle(parent, options)
	return __sg_require('StarGaze/Components/Toggle').new(self, parent, options)
end

function Runtime:checkbox(parent, options)
	return __sg_require('StarGaze/Components/Checkbox').new(self, parent, options)
end

function Runtime:radio(parent, options)
	return __sg_require('StarGaze/Components/Radio').new(self, parent, options)
end

function Runtime:slider(parent, options)
	return __sg_require('StarGaze/Components/Slider').new(self, parent, options)
end

function Runtime:dropdown(parent, options)
	return __sg_require('StarGaze/Components/Dropdown').new(self, parent, options)
end

function Runtime:segmented(parent, options)
	return __sg_require('StarGaze/Components/Segmented').new(self, parent, options)
end

function Runtime:accordion(parent, options)
	return __sg_require('StarGaze/Components/Accordion').new(self, parent, options)
end

function Runtime:colorPicker(parent, options)
	return __sg_require('StarGaze/Components/ColorPicker').new(self, parent, options)
end

function Runtime:keybind(parent, options)
	return __sg_require('StarGaze/Components/Keybind').new(self, parent, options)
end

function Runtime:responsive(root, options)
	return __sg_require('StarGaze/Core/Responsive').apply(self, root, options)
end

function Runtime:input(parent, options)
	return __sg_require('StarGaze/Components/Input').new(self, parent, options)
end

function Runtime:progress(parent, options)
	return __sg_require('StarGaze/Components/Progress').new(self, parent, options)
end

function Runtime:tabs(parent, options)
	return __sg_require('StarGaze/Components/Tabs').new(self, parent, options)
end

function Runtime:window(options)
	return __sg_require('StarGaze/Components/Window').new(self, options)
end

function Runtime:notification(options)
	return __sg_require('StarGaze/Components/Notification').new(self, options)
end

function Runtime:notify(options)
	return self:notification(options)
end

function Runtime:confirm(options)
	return __sg_require('StarGaze/Components/Confirm').new(self, options)
end

function Runtime:contextMenu(options)
	return __sg_require('StarGaze/Components/ContextMenu').new(self, options)
end

function Runtime:commandPalette(options)
	return __sg_require('StarGaze/Components/CommandPalette').new(self, options)
end

function Runtime:badge(parent, options)
	return __sg_require('StarGaze/Components/Badge').new(self, parent, options)
end

function Runtime:divider(parent, options)
	return __sg_require('StarGaze/Components/Divider').new(self, parent, options)
end

function Runtime:tooltip(target, options)
	return __sg_require('StarGaze/Components/Tooltip').new(self, target, options)
end

function Runtime:card(parent, options)
	options = Utils.merge({Color = "Card", Radius = 12, Stroke = true, StrokeTransparency = 0.45}, options or {})
	return self:createFrame(parent, options)
end

function Runtime:glass(parent, options)
	options = Utils.merge({Color = "Glass", Transparency = 0.14, Radius = 14, Stroke = true, StrokeTransparency = 0.35}, options or {})
	return self:createFrame(parent, options)
end

function Runtime:destroy()
	if self.Plugins then
		self.Plugins:destroy()
	end
	for _, connection in ipairs(self.Connections) do
		if connection then
			connection:Disconnect()
		end
	end
	for _, instance in ipairs(self.Instances) do
		if instance and instance.Parent then
			instance:Destroy()
		end
	end
	self.Connections = {}
	self.Instances = {}
	self.Windows = {}
	self.Layers = {}
	self.Gui = nil
end

return Runtime

end

__sg_factories['StarGaze/Core/Settings'] = function()
local Utils = __sg_require('StarGaze/Core/Utils')

local Settings = {}
Settings.__index = Settings

Settings.Defaults = {
	Density = "Comfortable",
	Style = "Soft",
	Template = "Dashboard",
	CornerRadius = 10,
	Animation = true,
	AnimationSpeed = 0.18,
	Hover = true,
	Press = true,
	FocusRing = true,
	Tooltips = true,
	Glassmorphism = false,
	Shadows = false,
	Outline = true,
	OutlineTransparency = 0.35,
	ModalOpacity = 0.4,
	NotificationDuration = 4,
	NotificationPosition = "TopRight",
	Responsive = true,
	ScaleMin = 0.78,
	ScaleMax = 1.08,
	Font = Enum.Font.Gotham,
	TextScale = 1,
	IconStyle = "Solid",
	IconSize = 18,
	SidebarWidth = 0.18,
	SectionSpacing = 0.014,
	ComponentSpacing = 0.012,
	PagePadding = 0.022,
}

function Settings.new(runtime, initial)
	return setmetatable({
		Runtime = runtime,
		Values = Utils.merge(Settings.Defaults, initial or {}),
		Listeners = {},
	}, Settings)
end

function Settings:get(key, fallback)
	local value = self.Values[key]
	if value == nil then
		return fallback
	end
	return value
end

function Settings:set(key, value)
	self.Values[key] = value
	local listeners = self.Listeners[key]
	if listeners then
		for _, callback in ipairs(listeners) do
			callback(value)
		end
	end
	return self
end

function Settings:update(values)
	for key, value in pairs(values or {}) do
		self:set(key, value)
	end
	return self
end

function Settings:changed(key, callback)
	self.Listeners[key] = self.Listeners[key] or {}
	table.insert(self.Listeners[key], callback)
	return self
end

function Settings:all()
	return Utils.merge({}, self.Values)
end

return Settings

end

__sg_factories['StarGaze/Core/Styles'] = function()
local Utils = __sg_require('StarGaze/Core/Utils')

local Styles = {}
Styles.__index = Styles

Styles.BuiltIn = {
	Soft = {
		Radius = 14,
		StrokeTransparency = 0.5,
		HoverStrength = 0.06,
		PressScale = 0.98,
		Shadow = false,
	},
		Sharp = {
		Radius = 5,
		StrokeTransparency = 0.2,
		HoverStrength = 0.04,
		PressScale = 0.985,
		Shadow = false,
	},
		Glass = {
		Radius = 16,
		Transparency = 0.18,
		StrokeTransparency = 0.28,
		HoverStrength = 0.05,
		PressScale = 0.985,
		Shadow = true,
	},
		Dense = {
		Radius = 8,
		StrokeTransparency = 0.36,
		HoverStrength = 0.04,
		PressScale = 0.985,
		Shadow = false,
	},
}

function Styles.new(runtime)
	return setmetatable({
		Runtime = runtime,
		Definitions = Utils.merge(Styles.BuiltIn),
	}, Styles)
end

function Styles:register(name, definition)
	self.Definitions[name] = Utils.merge(self.Definitions[name] or {}, definition or {})
	return self.Definitions[name]
end

function Styles:get(name)
	return self.Definitions[name]
end

function Styles:resolve(style)
	if type(style) == "string" then
		return self.Definitions[style] or self.Definitions.Soft
	end
	return style or self.Definitions.Soft
end

function Styles:apply(instance, style, overrides)
	local resolved = Utils.merge(self:resolve(style), overrides or {})
	if resolved.Radius ~= nil then
		local existing = instance:FindFirstChildOfClass("UICorner")
		if existing then
			existing.CornerRadius = UDim.new(0, resolved.Radius)
		else
			Utils.corner(instance, resolved.Radius)
		end
	end
	if resolved.Transparency ~= nil then
		instance.BackgroundTransparency = resolved.Transparency
	end
	return resolved
end

return Styles

end

__sg_factories['StarGaze/Core/Templates'] = function()
local Utils = __sg_require('StarGaze/Core/Utils')

local Templates = {}
Templates.__index = Templates

Templates.BuiltIn = {
	MinimalWindow = {
		Window = {
			Size = UDim2.fromScale(0.56, 0.68),
			CornerRadius = 12,
			Stroke = true,
		},
		Content = {
			Padding = 0.025,
		},
	},
	Dashboard = {
		Window = {
			Size = UDim2.fromScale(0.72, 0.78),
			CornerRadius = 16,
			Stroke = true,
		},
		Content = {
			Padding = 0.022,
		},
	},
	CompactPanel = {
		Window = {
			Size = UDim2.fromScale(0.42, 0.64),
			CornerRadius = 9,
			Stroke = true,
		},
		Content = {
			Padding = 0.018,
		},
	},
	Inspector = {
		Window = {
			Size = UDim2.fromScale(0.34, 0.82),
			CornerRadius = 10,
			Stroke = true,
		},
		Content = {
			Padding = 0.016,
		},
	},
}

function Templates.new(runtime)
	return setmetatable({
		Runtime = runtime,
		Definitions = Utils.merge(Templates.BuiltIn),
	}, Templates)
end

function Templates:register(name, definition)
	self.Definitions[name] = Utils.merge(self.Definitions[name] or {}, definition or {})
	return self.Definitions[name]
end

function Templates:get(name)
	return self.Definitions[name]
end

function Templates:resolve(name, overrides)
	return Utils.merge(self.Definitions[name] or {}, overrides or {})
end

return Templates

end

__sg_factories['StarGaze/Core/Themes'] = function()
local Themes = {}

Themes.Definitions = {
	Obsidian = {
		Background = Color3.fromRGB(8, 9, 12),
		Surface = Color3.fromRGB(14, 16, 21),
		SurfaceAlt = Color3.fromRGB(20, 23, 30),
		SurfaceRaised = Color3.fromRGB(25, 28, 36),
		Glass = Color3.fromRGB(18, 20, 27),
		Border = Color3.fromRGB(48, 53, 66),
		BorderSoft = Color3.fromRGB(34, 38, 48),
		Text = Color3.fromRGB(244, 246, 250),
		Subtext = Color3.fromRGB(150, 156, 171),
		Muted = Color3.fromRGB(99, 106, 121),
		Accent = Color3.fromRGB(144, 97, 255),
		AccentHover = Color3.fromRGB(166, 125, 255),
		AccentPressed = Color3.fromRGB(119, 75, 228),
		Success = Color3.fromRGB(74, 211, 132),
		Warning = Color3.fromRGB(245, 182, 67),
		Danger = Color3.fromRGB(242, 83, 86),
		Info = Color3.fromRGB(84, 157, 255),
	},
	Midnight = {
		Background = Color3.fromRGB(6, 10, 18),
		Surface = Color3.fromRGB(11, 17, 28),
		SurfaceAlt = Color3.fromRGB(16, 25, 39),
		SurfaceRaised = Color3.fromRGB(22, 33, 49),
		Glass = Color3.fromRGB(16, 24, 39),
		Border = Color3.fromRGB(42, 62, 88),
		BorderSoft = Color3.fromRGB(29, 42, 60),
		Text = Color3.fromRGB(241, 246, 255),
		Subtext = Color3.fromRGB(143, 157, 180),
		Muted = Color3.fromRGB(94, 108, 130),
		Accent = Color3.fromRGB(75, 144, 255),
		AccentHover = Color3.fromRGB(107, 163, 255),
		AccentPressed = Color3.fromRGB(53, 117, 226),
		Success = Color3.fromRGB(74, 215, 141),
		Warning = Color3.fromRGB(245, 184, 73),
		Danger = Color3.fromRGB(239, 82, 95),
		Info = Color3.fromRGB(78, 170, 255),
	},
	Carbon = {
		Background = Color3.fromRGB(3, 4, 5),
		Surface = Color3.fromRGB(9, 10, 12),
		SurfaceAlt = Color3.fromRGB(15, 17, 20),
		SurfaceRaised = Color3.fromRGB(20, 22, 26),
		Glass = Color3.fromRGB(16, 18, 21),
		Border = Color3.fromRGB(39, 42, 47),
		BorderSoft = Color3.fromRGB(27, 30, 34),
		Text = Color3.fromRGB(246, 246, 247),
		Subtext = Color3.fromRGB(151, 154, 159),
		Muted = Color3.fromRGB(97, 101, 107),
		Accent = Color3.fromRGB(224, 225, 232),
		AccentHover = Color3.fromRGB(246, 247, 250),
		AccentPressed = Color3.fromRGB(187, 188, 195),
		Success = Color3.fromRGB(80, 212, 131),
		Warning = Color3.fromRGB(244, 183, 65),
		Danger = Color3.fromRGB(240, 83, 85),
		Info = Color3.fromRGB(92, 154, 255),
	},
	Violet = {
		Background = Color3.fromRGB(10, 6, 15),
		Surface = Color3.fromRGB(20, 12, 28),
		SurfaceAlt = Color3.fromRGB(27, 16, 38),
		SurfaceRaised = Color3.fromRGB(35, 21, 48),
		Glass = Color3.fromRGB(26, 16, 37),
		Border = Color3.fromRGB(67, 42, 85),
		BorderSoft = Color3.fromRGB(47, 29, 61),
		Text = Color3.fromRGB(248, 243, 255),
		Subtext = Color3.fromRGB(164, 145, 176),
		Muted = Color3.fromRGB(109, 89, 121),
		Accent = Color3.fromRGB(178, 89, 255),
		AccentHover = Color3.fromRGB(201, 126, 255),
		AccentPressed = Color3.fromRGB(148, 67, 218),
		Success = Color3.fromRGB(76, 215, 137),
		Warning = Color3.fromRGB(244, 181, 68),
		Danger = Color3.fromRGB(240, 82, 90),
		Info = Color3.fromRGB(103, 158, 255),
	},
}

-- Card is used by Runtime:card and several built-in components.
-- Upstream themes omit it, causing Utils.color to fall back to bright Text.
for _, theme in pairs(Themes.Definitions) do
	theme.Card = theme.SurfaceRaised
	theme.Input = theme.SurfaceAlt
end

function Themes.get(name)
	return Themes.Definitions[name]
end

function Themes.resolve(theme)
	if type(theme) == "table" then
		return theme
	end
	return Themes.get(theme or "Obsidian") or Themes.Definitions.Obsidian
end

function Themes.register(name, definition)
	Themes.Definitions[name] = definition
end

return Themes

end

__sg_factories['StarGaze/Core/Utils'] = function()
local Utils = {}

function Utils.merge(...)
	local result = {}
	for _, source in ipairs({...}) do
		if source then
			for key, value in pairs(source) do
				if type(value) == "table" and type(result[key]) == "table" then
					result[key] = Utils.merge(result[key], value)
				else
					result[key] = value
				end
			end
		end
	end
	return result
end

function Utils.create(className, properties)
	local instance = Instance.new(className)
	for property, value in pairs(properties or {}) do
		instance[property] = value
	end
	return instance
end

function Utils.color(value, theme)
	if typeof(value) == "Color3" then
		return value
	end
	if type(value) == "string" and theme[value] then
		return theme[value]
	end
	if type(value) == "string" then
		return theme.Text or Color3.new(1, 1, 1)
	end
	return value
end

function Utils.corner(parent, radius)
	return Utils.create("UICorner", {
		CornerRadius = UDim.new(0, radius or 10),
		Parent = parent,
	})
end

function Utils.stroke(parent, color, transparency, thickness)
	return Utils.create("UIStroke", {
		Color = color,
		Transparency = transparency or 0,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent,
	})
end

function Utils.aspect(parent, ratio)
	return Utils.create("UIAspectRatioConstraint", {
		AspectRatio = ratio,
		Parent = parent,
	})
end

function Utils.scale(parent, value)
	return Utils.create("UIScale", {
		Scale = value or 1,
		Parent = parent,
	})
end

function Utils.padding(parent, top, right, bottom, left)
	return Utils.create("UIPadding", {
		PaddingTop = UDim.new(0, top or 0),
		PaddingRight = UDim.new(0, right or top or 0),
		PaddingBottom = UDim.new(0, bottom or top or 0),
		PaddingLeft = UDim.new(0, left or right or top or 0),
		Parent = parent,
	})
end

function Utils.list(parent, options)
	options = options or {}
	return Utils.create("UIListLayout", {
		FillDirection = options.Direction or Enum.FillDirection.Vertical,
		HorizontalAlignment = options.HorizontalAlignment or Enum.HorizontalAlignment.Left,
		VerticalAlignment = options.VerticalAlignment or Enum.VerticalAlignment.Top,
		Padding = options.Padding or UDim.new(0, 8),
		SortOrder = options.SortOrder or Enum.SortOrder.LayoutOrder,
		Wraps = options.Wraps or false,
		Parent = parent,
	})
end

function Utils.text(parent, text, theme, options)
	options = options or {}
	return Utils.create("TextLabel", {
		BackgroundTransparency = 1,
		Size = options.Size or UDim2.fromScale(1, 1),
		Position = options.Position or UDim2.fromScale(0, 0),
		AnchorPoint = options.AnchorPoint or Vector2.zero,
		Text = tostring(text or ""),
		TextColor3 = Utils.color(options.Color or "Text", theme),
		TextSize = options.TextSize or 14,
		TextScaled = options.TextScaled or false,
		AutomaticSize = options.AutomaticSize or Enum.AutomaticSize.None,
		Font = options.Font or Enum.Font.Gotham,
		TextXAlignment = options.TextXAlignment or Enum.TextXAlignment.Left,
		TextYAlignment = options.TextYAlignment or Enum.TextYAlignment.Center,
		TextWrapped = options.TextWrapped or false,
		RichText = options.RichText or false,
		Parent = parent,
	})
end

function Utils.button(parent)
	return Utils.create("TextButton", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Text = "",
		AutoButtonColor = false,
		Parent = parent,
	})
end

return Utils

end

__sg_factories['StarGaze/Elements'] = function()
local Utils = __sg_require('StarGaze/Core/Utils')

local Elements = {}
Elements.__index = Elements

function Elements.new(runtime)
	return setmetatable({Runtime = runtime}, Elements)
end

function Elements:frame(parent, options)
	options = options or {}
	local theme = self.Runtime.Theme
	local frame = Utils.create("Frame", {
		Name = options.Name or "Frame",
		BackgroundColor3 = Utils.color(options.Color or "Surface", theme),
		BackgroundTransparency = options.Transparency or 0,
		BorderSizePixel = 0,
		Size = options.Size or UDim2.fromScale(1, 1),
		Position = options.Position or UDim2.fromScale(0, 0),
		AnchorPoint = options.AnchorPoint or Vector2.zero,
		Visible = options.Visible ~= false,
		ClipsDescendants = options.ClipsDescendants or false,
		ZIndex = options.ZIndex or 1,
		Parent = parent or self.Runtime.Gui,
	})
	if options.Radius ~= 0 then
		Utils.corner(frame, options.Radius or 10)
	end
	if options.Stroke then
		Utils.stroke(frame, Utils.color(options.StrokeColor or "Border", theme), options.StrokeTransparency or 0, options.StrokeThickness or 1)
	end
	if options.Padding then
		Utils.padding(frame, options.Padding.Top, options.Padding.Right, options.Padding.Bottom, options.Padding.Left)
	end
	self.Runtime:track(frame)
	return frame
end

function Elements:scroll(parent, options)
	options = options or {}
	local theme = self.Runtime.Theme
	local scroll = Utils.create("ScrollingFrame", {
		Name = options.Name or "Scroll",
		BackgroundColor3 = Utils.color(options.Color or "Background", theme),
		BackgroundTransparency = options.Transparency or 0,
		BorderSizePixel = 0,
		Size = options.Size or UDim2.fromScale(1, 1),
		Position = options.Position or UDim2.fromScale(0, 0),
		AnchorPoint = options.AnchorPoint or Vector2.zero,
		Visible = options.Visible ~= false,
		ClipsDescendants = options.ClipsDescendants ~= false,
		CanvasSize = UDim2.fromScale(0, 0),
		AutomaticCanvasSize = options.AutomaticCanvasSize or Enum.AutomaticSize.Y,
		ScrollingDirection = options.ScrollingDirection or Enum.ScrollingDirection.Y,
		ScrollBarThickness = options.ScrollBarThickness or 4,
		ScrollBarImageColor3 = Utils.color(options.ScrollBarColor or "Border", theme),
		ScrollBarImageTransparency = options.ScrollBarTransparency or 0.25,
		ScrollingEnabled = options.ScrollingEnabled ~= false,
		ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
		ZIndex = options.ZIndex or 1,
		Parent = parent or self.Runtime.Gui,
	})
	if options.Radius ~= 0 then
		Utils.corner(scroll, options.Radius or 10)
	end
	if options.Stroke then
		Utils.stroke(scroll, Utils.color(options.StrokeColor or "Border", theme), options.StrokeTransparency or 0, options.StrokeThickness or 1)
	end
	if options.Padding then
		Utils.padding(scroll, options.Padding.Top, options.Padding.Right, options.Padding.Bottom, options.Padding.Left)
	end
	if options.Layout then
		Utils.list(scroll, options.Layout)
	end
	self.Runtime:track(scroll)
	return scroll
end

function Elements:text(parent, text, options)
	options = options or {}
	local element = Utils.text(parent or self.Runtime.Gui, text, self.Runtime.Theme, {
		Name = options.Name,
		Size = options.Size or UDim2.fromScale(1, 1),
		Position = options.Position or UDim2.fromScale(0, 0),
		AnchorPoint = options.AnchorPoint or Vector2.zero,
		Color = options.Color or "Text",
		TextSize = options.TextSize or 14,
		TextScaled = options.TextScaled,
		AutomaticSize = options.AutomaticSize,
		Font = options.Font or self.Runtime.Options.Font,
		TextXAlignment = options.TextXAlignment,
		TextYAlignment = options.TextYAlignment,
		TextWrapped = options.TextWrapped,
		RichText = options.RichText,
	})
	element.Name = options.Name or "Text"
	self.Runtime:track(element)
	return element
end

function Elements:container(parent, options)
	options = options or {}
	local container = self:frame(parent, options)
	if options.Layout then
		Utils.list(container, options.Layout)
	end
	return container
end

return Elements

end

__sg_factories['StarGaze'] = function()
local Runtime = __sg_require('StarGaze/Core/Runtime')
local Themes = __sg_require('StarGaze/Core/Themes')
local Presets = __sg_require('StarGaze/Core/Presets')
local Settings = __sg_require('StarGaze/Core/Settings')
local Styles = __sg_require('StarGaze/Core/Styles')
local Templates = __sg_require('StarGaze/Core/Templates')

local StarGaze = {
	Version = "2.1.0",
	Themes = Themes,
	Presets = Presets,
	Settings = Settings,
	Styles = Styles,
	Templates = Templates,
}

function StarGaze.create(options)
	return Runtime.new(options)
end

return StarGaze

end

return __sg_require("StarGaze")
