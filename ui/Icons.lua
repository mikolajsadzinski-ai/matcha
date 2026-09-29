-- Pinned Lucide sprite coordinates. No HTTP or executable icon downloads.
local assets = {
["target"] = {"rbxassetid://97854828246256", 24, 24, 975, 875},
["person-standing"] = {"rbxassetid://97854828246256", 24, 24, 500, 750},
["crosshair"] = {"rbxassetid://97854828246256", 24, 24, 250, 525},
["sun"] = {"rbxassetid://97854828246256", 24, 24, 750, 975},
["settings"] = {"rbxassetid://97854828246256", 24, 24, 525, 900},
["pocket-knife"] = {"rbxassetid://97854828246256", 24, 24, 300, 975},
["user-round"] = {"rbxassetid://96738291359702", 24, 24, 150, 175},
["check"] = {"rbxassetid://97854828246256", 24, 24, 400, 225},
["chevron-up"] = {"rbxassetid://97854828246256", 24, 24, 50, 575},
["move-diagonal-2"] = {"rbxassetid://97854828246256", 24, 24, 600, 575},
["key"] = {"rbxassetid://97854828246256", 24, 24, 575, 450},
["move"] = {"rbxassetid://97854828246256", 24, 24, 300, 875},
["square-arrow-down-left"] = {"rbxassetid://97854828246256", 24, 24, 575, 950},
["x"] = {"rbxassetid://96738291359702", 24, 24, 400, 50},
["search"] = {"rbxassetid://97854828246256", 24, 24, 850, 575},
}

return {
    GetAsset = function(name)
        local asset = assets[name]
        if not asset then return nil end
        return {
            Url = asset[1],
            ImageRectSize = Vector2.new(asset[2], asset[3]),
            ImageRectOffset = Vector2.new(asset[4], asset[5]),
        }
    end,
}
