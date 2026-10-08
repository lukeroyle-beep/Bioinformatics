#!/usr/bin/env python3
"""Package committed source and a complete Git bundle; verify a fresh restoration.

Local only. Refuses uncommitted or untracked non-ignored files. Does not publish.
"""
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile
import zipfile

ROOT = Path(__file__).resolve().parents[1]

def git(*args, cwd=ROOT):
    return subprocess.check_output(['git', *args], cwd=cwd)

def sha(data):
    return hashlib.sha256(data).hexdigest()

if git('status', '--porcelain').strip():
    raise SystemExit('Commit reviewed changes before packaging.')
commit = git('rev-parse', 'HEAD').decode().strip()
status = json.loads((ROOT / 'results/lean_status.json').read_text())
if status.get('status') != 'PASS':
    raise SystemExit('Lean verification is not PASS.')
paths = [s.decode() for s in git('ls-files', '-z').split(b'\0') if s]
source = {p: git('show', f'{commit}:{p}') for p in paths}
proof_sha = sha(source['lean/Pilot.lean'])
receipt = json.loads(source['results/stage2_verification/lean_build.json'])
if receipt.get('status') != 'PASS' or receipt.get('source_sha256') != proof_sha:
    raise SystemExit('Clean-build receipt does not match committed Lean source.')
if json.loads(source['results/python_reproduction.json']).get('status') != 'PASS':
    raise SystemExit('Python reproduction is not PASS.')
out = ROOT / 'checkpoints'
out.mkdir(exist_ok=True)
name = f'RNA_Stage_2_Verified_{commit[:12]}'
with tempfile.TemporaryDirectory(prefix='rna-stage2-package-') as tmp:
    temp = Path(tmp)
    bundle = temp / 'RNA_Stage_2.bundle'
    subprocess.run(['git', 'bundle', 'create', str(bundle), '--all'], cwd=ROOT, check=True)
    subprocess.run(['git', 'bundle', 'verify', str(bundle)], cwd=ROOT, check=True)
    clone = temp / 'restored'
    subprocess.run(['git', 'clone', '-q', str(bundle), str(clone)], check=True)
    assert git('rev-parse', 'HEAD', cwd=clone).decode().strip() == commit
    for path, data in source.items():
        assert (clone / path).read_bytes() == data, path
    intake = (f'# Pending RNA Stage 2 memory intake\n\n'
              f'Local only; not uploaded. Source commit: `{commit}`.\n\n'
              'Stage 2 verification passed on 8 October 2026. Official Lean 4.19.0 clean build '
              'and kernel-checked seven-position GGAAACC model-completeness bridge passed. '
              'See REPORT.md and results/lean_status.json for exact axiom dependencies and limits. '
              'Both unchanged Python runners were reproduced once with unchanged numerical results. '
              'The 24-position evidence remains computational; no general folder correctness or '
              'infinite-family theorem was proved. Literature novelty remains provisional. '
              'Stage 3 was not started. Astra Extra High was not verified. '
              'No remote publication or external review was performed.\n').encode()
    restore = (f'# Restore this verified Stage 2 checkpoint\n\n'
               f'Commit: `{commit}`\n\n'
               'Verify MANIFEST.json SHA-256 entries, then run:\n\n'
               '```sh\ngit clone RNA_Stage_2.bundle recovered-repository\n'
               'cd recovered-repository\n```\n\n'
               'Read README.md and REPORT.md for the pinned compiler, retained evidence and '
               'clean-build command. The compiler distribution is excluded; no project dependencies '
               'beyond the pinned Lean distribution and Python standard library are needed. '
               'Stop at Stage 2.\n').encode()
    extras = {'RNA_Stage_2.bundle': bundle.read_bytes(),
              'RNA_Stage_2_Memory_Intake.md': intake, 'RESTORE.md': restore}
    manifest = {
        'commit': commit, 'base_commit': 'd037996e324a1fc0923270f950e5a540ac0a45d6',
        'stage2_status': 'COMPLETE', 'stage3_started': False,
        'files': {p: sha(b) for p, b in source.items()},
        'archive_members': {p: {'sha256': sha(b), 'bytes': len(b)} for p, b in extras.items()},
        'toolchain_included': False,
        'verification': 'Complete bundle verified; fresh restored HEAD and all committed source bytes matched.',
    }
    archive = out / (name + '.zip')
    with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED) as z:
        for p, data in source.items():
            z.writestr('source/' + p, data)
        for p, data in extras.items():
            z.writestr(p, data)
        z.writestr('MANIFEST.json', json.dumps(manifest, indent=2) + '\n')
    with zipfile.ZipFile(archive) as z:
        assert z.testzip() is None
        for p, digest in manifest['files'].items():
            assert sha(z.read('source/' + p)) == digest
        for p, value in manifest['archive_members'].items():
            b = z.read(p)
            assert len(b) == value['bytes'] and sha(b) == value['sha256']
    digest = sha(archive.read_bytes())
    (out / (name + '.sha256')).write_text(digest + '  ' + archive.name + '\n')
    (out / (name + '.manifest.json')).write_text(json.dumps(manifest, indent=2) + '\n')
    print(json.dumps({'status': 'PASS', 'commit': commit, 'archive': str(archive),
                      'sha256': digest, 'source_files_verified': len(source),
                      'fresh_bundle_restore': True}, indent=2))
