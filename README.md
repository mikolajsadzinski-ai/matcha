# Matcha — classic dark UI

The UI uses six icon tabs, two independently scrolling columns, square silver
checkboxes, dark dropdowns, thin slider tracks, and collapsible `[-]` sections.
Existing gameplay callbacks, option IDs, defaults, state tables and remote calls
in `script.lua` are preserved.

## Navigation

| Sidebar tab | Existing sections |
| --- | --- |
| Aimbot | Main and Target, except Gun Mods |
| Anti-Aim / Character | Player and Character |
| Visuals | Visual |
| World & Settings | World, Misc and Extra, except AutoBuy |
| Inventory / Weapons | Gun Mods and AutoBuy (still restricted to its original game) |
| Profile / Configs | UI Settings, configuration and themes |

Collapsed sections retain their control values. Scrolling allows all existing
sections to remain accessible. RightShift is the existing menu binding; its
configurable control is under Profile / Configs. The selected tab name is shown
above the content, and sidebar icons have tooltips. Window resizing and DPI
selection remain available. Previously saved themes can override the default
silver palette, as they did before.

## Modules

- `ui/Theme.lua`: colors, typography and window dimensions.
- `ui/TabManager.lua`: the six tabs and aliases for original section names.
- `ui/ComponentBuilder.lua`: visual adapters around existing control objects.
- `ui/Icons.lua`: local icon metadata using Roblox sprite assets.
- `ui/MatchaUI.lua`: public composition API.
- `ui/vendor/`: pinned Obsidian controls and config/theme managers, with licenses
  and provenance. The old library and addon URLs returned 404. This is a
  compatible API replacement; behavior specific to the unavailable fork cannot
  be verified.
- `dist/MatchaUI.lua`: generated bundle for the legacy HTTP entry point.

## Roblox Studio

Sync `default.project.json` using Rojo, or manually create a `MatchaUI` Folder in
ReplicatedStorage containing the `ui/` files as ModuleScripts (and `vendor` as a
subfolder). Add `studio/Preview.client.lua` as a LocalScript under
StarterPlayerScripts. Run **Play** with a client.

The preview runs the UI independently and asserts callback dispatch, object
identity, tab aliases and section collapse. It does not run gameplay features.
For your own LocalScript, use:

```lua
local UI = require(game.ReplicatedStorage.MatchaUI.MatchaUI)
local library = UI.createLibrary()
local window = library:CreateWindow({ Title = "matcha", Footer = "" })
local tabs = UI.createTabs(library, window)
tabs.Main:AddLeftGroupbox("Aimbot"):AddToggle("Enabled", {
    Text = "Enabled", Default = false,
    Callback = function(value) print(value) end,
})
```

The original gameplay script requires executor APIs (`getgenv`, metatable hooks,
HTTP `loadstring`, etc.). It is **not a Studio LocalScript**. Those requirements
were retained to avoid changing gameplay logic. The config/theme managers also
require the existing executor filesystem APIs; the Studio preview deliberately
uses only the UI modules. A normal Studio game should supply its own authorized
persistence integration rather than call `createManagers`.

## Build and checks

Python 3.9+ and a Luau compiler are sufficient; no package installation is needed.

```sh
python3 tools/build_ui.py
python3 tools/build_ui.py --check
python3 tests/check_preservation.py
python3 tests/run_adapters.py luau
luau-compile --null ui/*.lua ui/vendor/*.lua studio/Preview.client.lua dist/MatchaUI.lua script.lua
```

Commit `dist/MatchaUI.lua` together with module edits. `script.lua` loads that
bundle from the feature branch `coderabbit/redesign-roblox-gui/f2033e82`; update
that URL when promoting the entry point to another branch. Keep the branch while
using this entry point. Studio uses local ModuleScripts and needs no HTTP Lua
loader. The unrelated external feature URLs in the original script are retained.

## Manual verification before release

Roblox Studio is unavailable in the development sandbox. Compilation and source
preservation checks do not establish rendering or runtime correctness. In Studio:

1. Run the preview and check the Output assertions. Visit all six tabs; resize
   the window and verify both columns scroll and icons remain reachable.
2. Toggle controls and bind a key. Drag sliders, use right-click numeric entry,
   select single and multiple dropdown values, and edit a color/transparency.
3. Collapse/expand sections; check values persist and dependency boxes respond.
4. Test keyboard and touch layouts, then unload and verify the UI disappears.
5. In the original supported runtime, check an existing saved config, save/load,
   autoload, theme selection, all original keybind modes, and the menu binding.
   The Studio preview does not validate executor-backed persistence or features.

The supplied reference was a text script, with no image attachment. The design
follows the written layout and color specifications.
