local Theme = require(script.Parent.Theme)
local TabManager = require(script.Parent.TabManager)
local MatchaUI = {}

function MatchaUI.createLibrary()
    local library = require(script.Parent.vendor.Obsidian)
    Theme.apply(library)
    local createWindow = library.CreateWindow
    function library:CreateWindow(info)
        return createWindow(self, Theme.window(info))
    end
    return library
end

function MatchaUI.createTabs(library, window)
    return TabManager.create(library, window)
end

function MatchaUI.createManagers(library)
    local themeManager = require(script.Parent.vendor.ThemeManager)
    local saveManager = require(script.Parent.vendor.SaveManager)
    themeManager:SetLibrary(library)
    themeManager:SetDefaultTheme(Theme.Colors)
    return themeManager, saveManager
end

return MatchaUI
