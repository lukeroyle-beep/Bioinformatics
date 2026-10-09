"""Clean-build the Stage 4 modules and audit their exact transitive axioms.

This verifies retained declarations, not completion of the unbounded theorem.
The old experiment runners and Stage 2 evidence are never changed.
"""
import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
PACKAGE = ROOT / 'lean/Stage4'


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--bin-dir', type=Path)
    parser.add_argument('--output-dir', type=Path, required=True)
    args = parser.parse_args()
    out = args.output_dir.resolve()
    out.mkdir(parents=True, exist_ok=False)
    env = os.environ.copy()
    if args.bin_dir:
        env['PATH'] = str(args.bin_dir.resolve()) + os.pathsep + env.get('PATH', '')
    lean = shutil.which('lean', path=env['PATH'])
    lake = shutil.which('lake', path=env['PATH'])
    sources = sorted(PACKAGE.glob('*.lean'))
    receipt = dict(status='RUNNING', started_utc=datetime.now(timezone.utc).isoformat(),
                   general_theorem_verified=False, proof_scope='Exact frozen-model theorem only; see current Stage 4 report and explicit theorem hypotheses',
                   sources={str(p.relative_to(ROOT)): digest(p) for p in sources}, commands=[])

    def save():
        (out / 'verification.json').write_text(json.dumps(receipt, indent=2) + '\n')

    def run(label, command):
        r = subprocess.run(command, cwd=PACKAGE, env=env, text=True,
                           stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=180)
        log = out / (label + '.log')
        log.write_text(r.stdout)
        receipt['commands'].append(dict(command=command, cwd=str(PACKAGE),
                                        exit_code=r.returncode, log=log.name, sha256=digest(log)))
        save()
        if r.returncode:
            raise RuntimeError(f'{label} failed; see {log}')
        return r.stdout

    try:
        if not lean or not lake:
            raise RuntimeError('Pinned Lean and Lake executables are required')
        if (PACKAGE / 'lean-toolchain').read_text().strip() != 'leanprover/lean4:v4.19.0':
            raise RuntimeError('Unexpected toolchain pin')
        if not run('lean_version', [lean, '--version']).startswith('Lean (version 4.19.0,'):
            raise RuntimeError('Actual Lean version differs from pin')
        run('lake_version', [lake, '--version'])
        run('clean', [lake, 'clean'])
        run('build', [lake, 'build'])
        dependencies = {}
        for source in sources:
            text = source.read_text()
            # Proof bypasses are prohibited even in comments: keep the source audit simple.
            if re.search(r'\b(sorry|admit|native_decide|axiom|unsafe)\b', text):
                raise RuntimeError(f'Prohibited proof token: {source.name}')
            declared = re.findall(r'^theorem\s+(\w+)', text, re.MULTILINE)
            printed = re.findall(r'^#print axioms\s+(\w+)', text, re.MULTILINE)
            if sorted(declared) != sorted(printed):
                raise RuntimeError(f'Every theorem needs exactly one axiom print: {source.name}')
            audit = run(source.stem + '_axioms', [lake, 'env', 'lean', source.name])
            for name in declared:
                pattern = (r"'([^']*\." + re.escape(name) + r")' "
                           r"(does not depend on any axioms|depends on axioms: \[([^\]]*)\])")
                matches = re.findall(pattern, audit)
                if len(matches) != 1:
                    raise RuntimeError(f'Nonunique or absent axiom report: {name}')
                full, _, deps = matches[0]
                dependencies[full] = [a.strip() for a in deps.split(',') if a.strip()]
        union = sorted({a for deps in dependencies.values() for a in deps})
        if not set(union) <= {'propext', 'Quot.sound', 'Classical.choice'}:
            raise RuntimeError(f'Unexpected transitive axioms: {union}')
        if any(digest(ROOT / p) != h for p, h in receipt['sources'].items()):
            raise RuntimeError('Source changed during verification')
        required_final = {'Stage4.unique_minimum', 'Stage4.exact_gap'}
        receipt.update(status='PASS', theorem_count=len(dependencies),
                       general_theorem_verified=required_final.issubset(dependencies),
                       final_theorems=sorted(required_final.intersection(dependencies)),
                       theorem_axioms=dependencies, transitive_axiom_union=union)
    except Exception as exc:
        receipt.update(status='FAIL', error=str(exc))
    receipt['finished_utc'] = datetime.now(timezone.utc).isoformat()
    save()
    print(json.dumps({k: v for k, v in receipt.items() if k not in ('commands', 'theorem_axioms')}, indent=2))
    return 0 if receipt['status'] == 'PASS' else 1


if __name__ == '__main__':
    sys.exit(main())
