#!/usr/bin/env python3
"""Verify that the legacy script differs only at explicit UI integration points."""
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE = '70499733105d8cfb265a8bead246cfc301f94d33'
original = subprocess.check_output(['git', 'show', f'{BASE}:script.lua'], cwd=ROOT, text=True)
current = (ROOT / 'script.lua').read_text()


def normalize(source, new):
    start = source.index('-- The UI bundle' if new else 'local repo = ')
    end = source.index('local Options = Library.Options', start)
    source = source[:start] + '<UI BOOTSTRAP>\n' + source[end:]
    start = source.index('local Tabs = ')
    end = source.index('local previousTargetHealth', start)
    source = source[:start] + '<TAB CREATION>\n' + source[end:]
    if new:
        source = source.replace("Tabs.Inventory:AddRightGroupbox('Gun Mods')", "Tabs.Main:AddRightGroupbox('Gun Mods')")
        source = source.replace("Tabs.Inventory:AddLeftGroupbox('AutoBuy')", "Tabs.Misc:AddLeftGroupbox('AutoBuy')")
    return source

assert normalize(original, False) == normalize(current, True), 'Non-UI script content changed'
controls = re.findall(r':Add(?:Toggle|Slider|Dropdown|Input|ColorPicker|KeyPicker)\(\s*[\'\"]([^\'\"]+)', current)
print(f'Preserved all non-UI source and {len(controls)} control declarations (including original IDs/defaults/callbacks).')
