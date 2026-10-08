"""Make and restore-check a committed local Stage 4 partial verification checkpoint."""
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile
import zipfile

ROOT = Path(__file__).resolve().parents[1]


def git(*args, cwd=ROOT):
    return subprocess.check_output(['git', *args], cwd=cwd)


def digest(data):
    return hashlib.sha256(data).hexdigest()


def main():
    if git('status', '--porcelain').strip():
        raise SystemExit('Commit reviewed changes before packaging')
    commit = git('rev-parse', 'HEAD').decode().strip()
    branch = git('branch', '--show-current').decode().strip()
    paths = [p.decode() for p in git('ls-files', '-z').split(b'\0') if p]
    source = {p: git('show', f'{commit}:{p}') for p in paths}
    validation = json.loads(source['results/stage4/checkpoint_validation.json'])
    assert validation['status'] == 'PASS'
    out = ROOT/'checkpoints'
    out.mkdir(exist_ok=True)
    archive = out/f'RNA_Stage_4_Checkpoint_{commit[:12]}.zip'
    if archive.exists():
        raise SystemExit('Refusing to overwrite an existing checkpoint')
    with tempfile.TemporaryDirectory(prefix='rna-stage4-') as tmp:
        temp = Path(tmp)
        bundle = temp/'RNA_Stage_4.bundle'
        subprocess.run(['git','bundle','create',str(bundle),'--all'],cwd=ROOT,check=True)
        subprocess.run(['git','bundle','verify',str(bundle)],cwd=ROOT,check=True)
        restored = temp/'restored'
        subprocess.run(['git','clone','-q','--branch',branch,str(bundle),str(restored)],check=True)
        assert git('rev-parse','HEAD',cwd=restored).decode().strip() == commit
        for p, data in source.items():
            assert (restored/p).read_bytes() == data, p
        restore = (f'Stage 4 partial verification checkpoint; general theorem remains unproved.\nCommit: {commit}\n'
                   'Verify every MANIFEST.json entry before restoration.\n'
                   f'git clone --branch {branch} RNA_Stage_4.bundle recovered-repository\n'
                   'Read research/STAGE4_REPORT.md and research/STAGE3_CANDIDATE.md.\n'
                   'The full unbounded theorem is not Lean-verified or externally reviewed.\n'
                   'No automatic continuation or remote push is included.\n').encode()
        members = {'source/'+p:data for p,data in source.items()}
        members.update({'RNA_Stage_4.bundle':bundle.read_bytes(),'RESTORE.txt':restore})
        manifest = dict(commit=commit,branch=branch,base_commit=git('rev-parse','827ba64').decode().strip(),
                        stage4_status='PARTIAL_VERIFICATION',stage4_started=True,
                        general_theorem_verified=False,remote_pushed=False,
                        archive_members={p:dict(sha256=digest(b),bytes=len(b)) for p,b in members.items()},
                        verification='Fresh bundle restoration matches every committed file.')
        with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED) as z:
            for p,b in members.items():
                z.writestr(p,b)
            z.writestr('MANIFEST.json',json.dumps(manifest,indent=2)+'\n')
        with zipfile.ZipFile(archive) as z:
            assert z.testzip() is None
            for p,v in manifest['archive_members'].items():
                b=z.read(p)
                assert len(b)==v['bytes'] and digest(b)==v['sha256'],p
        receipt=dict(status='PASS',archive=str(archive),commit=commit,sha256=digest(archive.read_bytes()),
                     committed_files_verified=len(source),fresh_bundle_restore=True,
                     stage4_status='PARTIAL_VERIFICATION',stage4_started=True,remote_pushed=False)
        archive.with_suffix('.sha256').write_text(receipt['sha256']+'  '+archive.name+'\n')
        archive.with_suffix('.receipt.json').write_text(json.dumps(receipt,indent=2)+'\n')
        print(json.dumps(receipt,indent=2))


if __name__=='__main__':
    main()
