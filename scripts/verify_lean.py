#!/usr/bin/env python3
"""Clean-build the pinned finite pilot, retaining commands, output and hashes.

Does not run either Python experiment. Standard library only.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import platform
import re
import shutil
import subprocess
import sys
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--bin-dir', type=Path, help='Directory containing official Lean 4.19.0 lean and lake binaries; otherwise use PATH.')
parser.add_argument('--output-dir', type=Path, default=ROOT / 'results' / 'stage2_verification')
args = parser.parse_args()
out = args.output_dir.resolve()
out.mkdir(parents=True, exist_ok=True)
env = os.environ.copy()
if args.bin_dir:
    env['PATH'] = str(args.bin_dir.resolve()) + os.pathsep + env.get('PATH', '')
lean = shutil.which('lean', path=env.get('PATH'))
lake = shutil.which('lake', path=env.get('PATH'))
if not lean or not lake:
    sys.exit('Lean and Lake must be installed before running verification.')
receipt = {
    'status': 'RUNNING', 'started_utc': datetime.now(timezone.utc).isoformat(),
    'platform': platform.platform(), 'machine': platform.machine(),
    'python': sys.version, 'lean_executable': lean, 'lake_executable': lake,
    'pin': (ROOT / 'lean/lean-toolchain').read_text().strip(),
    'source_sha256': hashlib.sha256((ROOT / 'lean/Pilot.lean').read_bytes()).hexdigest(),
    'commands': [],
}

def save():
    (out / 'lean_build.json').write_text(json.dumps(receipt, indent=2) + '\n')

def run(label, command):
    result = subprocess.run(command, cwd=ROOT / 'lean', env=env,
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    log = out / (label + '.log')
    log.write_text(result.stdout)
    receipt['commands'].append({'command': command, 'cwd': str(ROOT / 'lean'),
                                'exit_code': result.returncode, 'log': log.name,
                                'sha256': hashlib.sha256(log.read_bytes()).hexdigest()})
    save()
    print(result.stdout, end='')
    if result.returncode:
        raise RuntimeError(f'{label} exited {result.returncode}; see {log}')
    return result.stdout

try:
    if receipt['pin'] != 'leanprover/lean4:v4.19.0':
        raise RuntimeError('Unexpected lean-toolchain pin')
    version = run('lean_version', [lean, '--version'])
    if not version.startswith('Lean (version 4.19.0,'):
        raise RuntimeError('Actual Lean version does not match pin')
    run('lake_version', [lake, '--version'])
    run('lean_clean', [lake, 'clean'])
    run('lean_build', [lake, 'build'])
    # Explicit elaboration prints every transitive axiom set, independently of
    # whether Lake replays cached diagnostic output.
    audit = run('lean_axioms', [lake, 'env', 'lean', 'Pilot.lean'])
    source = (ROOT / 'lean/Pilot.lean').read_text()
    declared = re.findall(r'^theorem\s+(\w+)', source, re.MULTILINE)
    printed = re.findall(r'^#print axioms\s+(\w+)', source, re.MULTILINE)
    if sorted(declared) != sorted(printed):
        raise RuntimeError('Every project theorem must have exactly one axiom print command')
    deps = {}
    for name in declared:
        match = re.search(r"'Stage2\." + re.escape(name) + r"' (does not depend on any axioms|depends on axioms: \[([^\]]*)\])", audit)
        if not match:
            raise RuntimeError(f'Missing axiom report: {name}')
        deps[name] = [] if match[2] is None else [v.strip() for v in match[2].split(',') if v.strip()]
    axioms = sorted({a for values in deps.values() for a in values})
    receipt['theorem_axioms'] = deps
    receipt['transitive_axiom_union'] = axioms
    if not set(axioms) <= {'propext', 'Quot.sound', 'Classical.choice'}:
        raise RuntimeError(f'Unexpected axiom dependencies: {axioms}')
    if re.search(r'\b(sorry|admit|native_decide|axiom|unsafe)\b', source):
        raise RuntimeError('Prohibited proof construct in Pilot.lean')
    receipt['status'] = 'PASS'
except Exception as exc:
    receipt['status'] = 'FAIL'
    receipt['error'] = str(exc)
    print(str(exc), file=sys.stderr)
finally:
    receipt['finished_utc'] = datetime.now(timezone.utc).isoformat()
    save()
sys.exit(0 if receipt['status'] == 'PASS' else 1)
