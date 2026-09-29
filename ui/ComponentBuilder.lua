-- Adapt presentation around the vendor's controls; retain the original objects,
-- callbacks, value setters, registry, and input handlers.
local ComponentBuilder = {}

function ComponentBuilder.decorateGroup(library, group)
    if group.MatchaStyled then return group end
    group.MatchaStyled = true

    if group.Type == "Groupbox" then
        local header = group.Holder:FindFirstChildOfClass("Frame")
        local arrow = header and header:FindFirstChildOfClass("ImageButton")
        if arrow then
            arrow.ImageTransparency = 1
            local indicator = Instance.new("TextLabel")
            indicator.Name = "CollapseIndicator"
            indicator.BackgroundTransparency = 1
            indicator.AnchorPoint = arrow.AnchorPoint
            indicator.Position = arrow.Position
            indicator.Size = arrow.Size
            indicator.Font = Enum.Font.Code
            indicator.TextSize = 13
            indicator.TextColor3 = library.Scheme.FontColor
            indicator.Text = group.Collapsed and "[+]" or "[-]"
            indicator.Parent = header
            library:AddToRegistry(indicator, { TextColor3 = "FontColor" })
            local setCollapsed = group.SetCollapsed
            function group:SetCollapsed(collapsed)
                setCollapsed(self, collapsed)
                indicator.Text = self.Collapsed and "[+]" or "[-]"
            end
        end
    end

    local addToggle = group.AddToggle
    function group:AddToggle(id, info)
        local toggle = addToggle(self, id, info)
        local checkbox = toggle.Holder:FindFirstChildOfClass("Frame")
        if checkbox then
            checkbox.SizeConstraint = Enum.SizeConstraint.RelativeXY
            checkbox.Size = UDim2.fromOffset(12, 12)
            checkbox.Position = UDim2.new(0, 0, 0.5, -6)
            local checkImage = checkbox:FindFirstChildOfClass("ImageLabel")
            if checkImage then checkImage.Visible = false end
            local display = toggle.Display
            function toggle:Display()
                display(self)
                local key = self.Value and "AccentColor" or "MainColor"
                checkbox.BackgroundColor3 = library.Scheme[key]
                checkbox.BackgroundTransparency = self.Disabled and 0.6 or 0
                library.Registry[checkbox].BackgroundColor3 = key
            end
            toggle:Display()
        end
        return toggle
    end

    local addSlider = group.AddSlider
    function group:AddSlider(id, info)
        local slider = addSlider(self, id, info)
        local bar = slider.Holder:FindFirstChildOfClass("TextButton")
        local fill = bar:FindFirstChildOfClass("Frame")
        -- Retain the full input hit area; only the visible track is thin.
        bar.BackgroundTransparency = 1
        local outline = bar:FindFirstChildOfClass("UIStroke")
        if outline then outline.Enabled = false end
        local track = Instance.new("Frame")
        track.Name = "Track"
        track.BorderSizePixel = 0
        track.Position = UDim2.new(0, 0, 1, -5)
        track.Size = UDim2.new(1, 0, 0, 4)
        track.BackgroundColor3 = library.Scheme.OutlineColor
        track.Parent = bar
        library:AddToRegistry(track, { BackgroundColor3 = "OutlineColor" })
        fill.Position = track.Position
        local display = slider.Display
        function slider:Display()
            display(self)
            fill.Size = UDim2.new(fill.Size.X.Scale, 0, 0, 4)
        end
        slider.Holder.Size = UDim2.new(1, 0, 0, 36)
        local valueLabel = bar:FindFirstChildOfClass("TextLabel")
        valueLabel.Position = UDim2.fromOffset(0, -18)
        valueLabel.Size = UDim2.new(1, 0, 0, 14)
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        -- Keep the title and value on separate lines to avoid long-label overlap.
        local title = slider.Holder:FindFirstChildOfClass("TextLabel")
        if title then
            title.Size = UDim2.new(1, 0, 0, 14)
            valueLabel.Position = UDim2.fromOffset(0, -4)
        end
        slider:Display()
        return slider
    end

    local addDependencyBox = group.AddDependencyBox
    function group:AddDependencyBox(...)
        return ComponentBuilder.decorateGroup(library, addDependencyBox(self, ...))
    end
    return group
end

function ComponentBuilder.decorateTab(library, tab)
    local addGroupbox = tab.AddGroupbox
    function tab:AddGroupbox(info)
        -- Pop-out headers conflict with a fixed two-column classic layout.
        info.PopOut = false
        local previous = self.Groupboxes[info.Name]
        local group = addGroupbox(self, info)
        if previous then
            -- Merged legacy tabs can contain identically named sections.
            -- Preserve both in the vendor registry for search/theme/unload.
            local index = 2
            while self.Groupboxes[info.Name .. " #" .. index] do index += 1 end
            self.Groupboxes[info.Name .. " #" .. index] = previous
        end
        return ComponentBuilder.decorateGroup(library, group)
    end
    local addTabbox = tab.AddTabbox
    function tab:AddTabbox(info)
        info.PopOut = false
        local box = addTabbox(self, info)
        local addTab = box.AddTab
        function box:AddTab(...)
            return ComponentBuilder.decorateGroup(library, addTab(self, ...))
        end
        return box
    end
    for _, side in ipairs(tab.Sides) do
        side.ScrollBarThickness = 2
        side.ScrollBarImageTransparency = 0.5
        side.ScrollBarImageColor3 = library.Scheme.OutlineColor
    end
    return tab
end

return ComponentBuilder
