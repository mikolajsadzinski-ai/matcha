local ComponentBuilder = require(script.Parent.ComponentBuilder)
local TabManager = {}

TabManager.Definitions = {
    { Key = "Aimbot", Name = "Aimbot", Icon = "target" },
    { Key = "Character", Name = "Anti-Aim / Character", Icon = "person-standing" },
    { Key = "Visuals", Name = "Visuals", Icon = "crosshair" },
    { Key = "World", Name = "World & Settings", Icon = "sun" },
    { Key = "Inventory", Name = "Inventory / Weapons", Icon = "pocket-knife" },
    { Key = "Profile", Name = "Profile / Configs", Icon = "user-round" },
}

function TabManager.create(library, window)
    local pages = {}
    for order, definition in ipairs(TabManager.Definitions) do
        local tab = window:AddTab({
            Name = definition.Name, Icon = definition.Icon,
            Description = definition.Name, Tooltip = definition.Name, Order = order,
        })
        tab.Button.Name = definition.Key
        tab.Button.Size = UDim2.new(1, 0, 0, 60)
        if definition.Key == "World" then
            local gear = Instance.new("ImageLabel")
            gear.Name = "SettingsIcon"
            gear.BackgroundTransparency = 1
            gear.Position = UDim2.new(1, -22, 1, -22)
            gear.Size = UDim2.fromOffset(16, 16)
            gear.ImageColor3 = library.Scheme.FontColor
            gear.Parent = tab.Button
            library:ApplyLucideIcon(gear, library:GetIcon("settings"))
            library:AddToRegistry(gear, { ImageColor3 = "FontColor" })
        end
        pages[definition.Key] = ComponentBuilder.decorateTab(library, tab)
    end
    -- Aliases keep every original section's variable and callback intact.
    return {
        Main = pages.Aimbot, Target = pages.Aimbot,
        Player = pages.Character, Character = pages.Character,
        Visual = pages.Visuals, World = pages.World,
        Misc = pages.World, Extra = pages.World,
        Inventory = pages.Inventory, ['UI Settings'] = pages.Profile,
    }
end

return TabManager
