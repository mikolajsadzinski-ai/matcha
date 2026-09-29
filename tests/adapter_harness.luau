-- Small Roblox value/tree doubles for testing the presentation boundary in Luau.
-- This is not an engine/rendering test; the Studio preview covers that boundary.
local Enum = { Font = { Code = "Code" }, SizeConstraint = { RelativeXY = "XY" }, TextXAlignment = { Right = "Right" } }
local Color3 = { fromRGB = function(r, g, b) return { R = r / 255, G = g / 255, B = b / 255 } end }
local UDim2 = { new = function(xs, xo, ys, yo) return { X = { Scale = xs, Offset = xo }, Y = { Scale = ys, Offset = yo } } end }
UDim2.fromOffset = function(x, y) return UDim2.new(0, x, 0, y) end
local Instance = {}
function Instance.new(class)
    local node = { ClassName = class, Children = {} }
    function node:FindFirstChildOfClass(kind)
        for _, child in ipairs(self.Children) do if child.ClassName == kind then return child end end
    end
    return setmetatable(node, { __newindex = function(self, key, value)
        rawset(self, key, value)
        if key == "Parent" then table.insert(value.Children, self) end
    end })
end
local function child(parent, class)
    local node = Instance.new(class)
    node.Parent = parent
    return node
end
local library = { Scheme = {}, Registry = {}, Toggles = {}, Options = {} }
function library:AddToRegistry(node, fields) self.Registry[node] = fields end
function library:UpdateColorsUsingRegistry() end
function library:GetIcon(name) return name end
function library:ApplyLucideIcon(node, icon) node.Icon = icon end

local function makeGroup(name)
    local group = { Type = "Groupbox", Holder = Instance.new("Frame"), Container = { Visible = true }, Collapsed = false, Name = name }
    local header = child(group.Holder, "Frame")
    child(header, "ImageButton")
    function group:SetCollapsed(value) self.Collapsed = value; self.Container.Visible = not value end
    function group:AddToggle(id, info)
        local control = { Holder = Instance.new("TextButton"), Value = info.Default, Callback = info.Callback, Disabled = false }
        local box = child(control.Holder, "Frame")
        child(box, "ImageLabel")
        library.Registry[box] = {}
        function control:Display() end
        function control:SetValue(value) self.Value = value; self:Display(); self.Callback(value) end
        library.Toggles[id] = control
        return control
    end
    function group:AddSlider(id, info)
        local control = { Holder = Instance.new("Frame"), Value = info.Default, Callback = info.Callback }
        child(control.Holder, "TextLabel")
        local bar = child(control.Holder, "TextButton")
        local fill = child(bar, "Frame")
        child(bar, "UIStroke")
        child(bar, "TextLabel")
        function control:Display() fill.Size = UDim2.new((self.Value - info.Min) / (info.Max - info.Min), 0, 1, 0) end
        function control:SetValue(value) self.Value = value; self:Display(); self.Callback(value) end
        library.Options[id] = control
        return control
    end
    function group:AddDependencyBox() local box = makeGroup("dependency"); box.Type = "Depbox"; return box end
    return group
end
local function makeTab()
    local tab = { Groupboxes = {}, Sides = { {}, {} }, Button = Instance.new("TextButton") }
    function tab:AddGroupbox(info) local group = makeGroup(info.Name); self.Groupboxes[info.Name] = group; return group end
    function tab:AddTabbox()
        return { AddTab = function(_, name) local group = makeGroup(name); group.Type = "SubTab"; return group end }
    end
    return tab
end
-- MODULES_INSERTED_HERE
Theme.apply(library)
local info = { Title = "Original" }
local themed = Theme.window(info)
assert(info.Size == nil and themed.Title == info.Title, "Window styling must not mutate caller options")
assert(themed.SidebarCompacted and themed.EnableCompacting, "Vendor must initialize compact sidebar")
local created = {}
local window = { AddTab = function(_, definition)
    table.insert(created, definition)
    return makeTab()
end }
local tabs = TabManager.create(library, window)
assert(#created == 6, "Exactly six sidebar tabs required")
assert(created[1].Name == "Aimbot" and created[6].Name == "Profile / Configs")
assert(tabs.Main == tabs.Target and tabs.Player == tabs.Character and tabs.Extra == tabs.World)
local group = tabs.Main:AddGroupbox({ Name = "Aimbot" })
local invocations = 0
local callback = function() invocations += 1 end
local toggle = group:AddToggle("test", { Default = true, Callback = callback })
assert(invocations == 0, "Styling must not dispatch callbacks")
assert(toggle == library.Toggles.test and toggle.Callback == callback and toggle.Value == true)
toggle:SetValue(false)
assert(invocations == 1 and toggle.Holder:FindFirstChildOfClass("Frame").BackgroundColor3 == library.Scheme.MainColor)
toggle:SetValue(true)
assert(invocations == 2 and toggle.Holder:FindFirstChildOfClass("Frame").BackgroundColor3 == library.Scheme.AccentColor)
local slider = group:AddSlider("angle", { Default = 90, Min = 0, Max = 180, Callback = callback })
assert(slider == library.Options.angle and slider.Value == 90 and invocations == 2)
slider:SetValue(135)
local fill = slider.Holder:FindFirstChildOfClass("TextButton"):FindFirstChildOfClass("Frame")
assert(fill.Size.X.Scale == 0.75 and fill.Size.Y.Offset == 4 and invocations == 3)
group:SetCollapsed(true)
assert(not group.Container.Visible and toggle.Value == true and slider.Value == 135)
group:SetCollapsed(false)
assert(group.Container.Visible and invocations == 3)
local duplicate = tabs.Main:AddGroupbox({ Name = "Aimbot" })
assert(tabs.Main.Groupboxes.Aimbot == duplicate and tabs.Main.Groupboxes['Aimbot #2'] == group)
local dependency = group:AddDependencyBox()
assert(dependency.MatchaStyled, "Dependency children must use the same presentation")
local sub = tabs.Player:AddTabbox({}):AddTab("Position")
assert(sub.MatchaStyled, "Nested tab controls must use the same presentation")
print("Adapter checks passed: six tabs, aliases, callback isolation, control identity, values, collapse, duplicate groups, nested/dependent controls")
