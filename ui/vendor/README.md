# Vendored UI dependencies

Obsidian Library, ThemeManager and SaveManager: MIT, deividcomsono.
Pinned source: https://github.com/deividcomsono/Obsidian/tree/fb0b7b22604664ab94bea7c67e2a14ab1a47ec27

The original Kazamatcha/asmobile library and both addon URLs returned HTTP 404
when this redesign was implemented. This snapshot provides the Obsidian control
API used by script.lua. The old fork could not be recovered, so equivalence to
that fork's undocumented behavior cannot be guaranteed. Gameplay code and its
control definitions are verified separately by tests/check_preservation.py.

Only local change to Obsidian.lua: replace the online executable Lucide loader
with require(script.Parent.Parent.Icons). ThemeManager and SaveManager are
unchanged apart from trailing whitespace normalization in all three files. Keep LICENSE with redistributed sources and generated bundles.

Icons.lua contains a small subset of Lucide sprite coordinates from:
https://github.com/mstudio45/lucide-roblox-direct/tree/1c37dd176d79ab42388597aa9dc9e3a1b0dd7416
The sprites remain Roblox assets; no icon Lua is downloaded at runtime.
See LICENSE-Lucide for the sprite registry license and LICENSE-Lucide-Icons
for the icon artwork license.
