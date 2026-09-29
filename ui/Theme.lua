-- Presentation defaults only. Option values belong to the control library.
local Theme = {}
Theme.Colors = {
    BackgroundColor = Color3.fromRGB(16, 16, 16),
    MainColor = Color3.fromRGB(20, 20, 20),
    AccentColor = Color3.fromRGB(192, 192, 192),
    OutlineColor = Color3.fromRGB(48, 48, 48),
    FontColor = Color3.fromRGB(218, 218, 218),
}

function Theme.apply(library)
    for key, value in pairs(Theme.Colors) do
        library.Scheme[key] = value
    end
    library.ForceCheckbox = true
    library.CornerRadius = 0
    library:UpdateColorsUsingRegistry()
end

function Theme.window(info)
    local result = table.clone(info)
    result.Size = UDim2.fromOffset(760, 640)
    result.CornerRadius = 0
    result.Font = Enum.Font.Code
    result.SidebarCompacted = true
    result.SidebarCompactWidth = 64
    result.EnableSidebarResize = false
    result.EnableCompacting = true
    result.TabButtonsStyle = {
        Gap = 8, Padding = 4, CornerRadius = 0,
        Indicator = true, IndicatorWidth = 2, IndicatorHeight = 28,
    }
    return result
end

return Theme
