#!/usr/bin/env python3
"""Run presentation boundary tests with a Luau CLI (default: luau on PATH)."""
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
modules = []
for name in ['Theme', 'ComponentBuilder', 'TabManager']:
    source = (ROOT / 'ui' / f'{name}.lua').read_text()
    source = source.replace('local ComponentBuilder = require(script.Parent.ComponentBuilder)', '')
    modules.append(f'local {name} = (function()\n{source}\nend)()')
source = (ROOT / 'tests/adapter_harness.luau').read_text().replace('-- MODULES_INSERTED_HERE', '\n'.join(modules))
with tempfile.TemporaryDirectory(prefix='matcha-adapters-') as directory:
    test = Path(directory) / 'adapters.luau'
    test.write_text(source)
    result = subprocess.run([sys.argv[1] if len(sys.argv) > 1 else 'luau', str(test)])
    raise SystemExit(result.returncode)
