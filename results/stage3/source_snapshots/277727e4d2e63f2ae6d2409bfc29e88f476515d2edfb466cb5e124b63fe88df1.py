"""Deterministic, checkpointed Stage 3 batches. Outputs are separate from Stage 2."""
import argparse
import hashlib
import itertools
import json
import platform
from pathlib import Path
import time
from stage3 import ROOT, observe

BATCHES = {
    'original_loop_check': ('stage2_extension', [(3,3,3,u,v) for u in (3,4) for v in (3,4)]),
    'separated_gc_grid': ('separated_gc', list(itertools.product(range(3,6), repeat=5))),
}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('batch', choices=BATCHES)
    parser.add_argument('--output-dir', type=Path, required=True)
    args = parser.parse_args()
    construction, cases = BATCHES[args.batch]
    args.output_dir.mkdir(parents=True, exist_ok=True)
    destination = args.output_dir / (args.batch + '.json')
    if destination.exists():
        raise SystemExit('Refusing to overwrite a completed batch')
    partial = destination.with_suffix('.partial.jsonl')
    hashes = {p: hashlib.sha256((ROOT/p).read_bytes()).hexdigest() for p in
              ['parameters.json', 'src/model.py', 'src/folding.py', 'src/exhaustive.py',
               'research/stage3.py', 'research/run_stage3.py']}
    start = time.monotonic()
    rows = []
    with partial.open('x') as stream:
        for params in cases:
            row = observe(params, construction)
            rows.append(row)
            stream.write(json.dumps(row, sort_keys=True) + '\n')
            stream.flush()
            if len(rows) % 25 == 0:
                print(f'{len(rows)}/{len(cases)} cases; {sum(r["unique_target"] for r in rows)} unique', flush=True)
    summary = dict(batch=args.batch, model='wc-stack-2004-2dp-span3-v1',
                   status='COMPLETED', construction=construction, cases=len(rows),
                   unique=sum(r['unique_target'] for r in rows),
                   tied=sum(r['gap'] == 0 for r in rows),
                   beaten=sum(r['gap'] < 0 for r in rows),
                   minimum_gap=min(r['gap'] for r in rows),
                   python=platform.python_version(), elapsed_seconds=time.monotonic()-start,
                   source_sha256=hashes, rows=rows,
                   scope='Finite parameter cases only; all admissible folds considered by existing exact DP.')
    temporary = destination.with_suffix('.tmp')
    temporary.write_text(json.dumps(summary, indent=2)+'\n')
    temporary.replace(destination)
    print(json.dumps({k:v for k,v in summary.items() if k not in ('rows','source_sha256')}, indent=2))


if __name__ == '__main__':
    main()
