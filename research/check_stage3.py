"""Bounded exhaustive checks of candidate lemmas; does not prove all lengths."""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import platform
import sys
import time
from stage3 import ROOT, sequence_for, junction, parse, fold

sys.path.insert(0, str(ROOT / 'tests'))
from junction_pilot import compatible_count, compatible_folds
from exhaustive import score

CASES = [('separated_gc', (3,3,3,3,3))]
for k in range(5):
    p = [3]*5
    p[k] = 4
    CASES.append(('separated_gc', tuple(p)))
CASES.append(('stage2_extension', (3,3,3,4,3)))


def check_lemmas(seq, pairs, params):
    a,b,c,u,v = params
    ps = set(pairs)
    stacks = [(i,j,seq[i:i+2]+'/'+seq[j]+seq[j-1])
              for i,j in pairs if (i+1,j-1) in ps]
    types = Counter(t for i,j,t in stacks)
    assert set(types) <= {'AA/UU','CC/GG','GG/CC','AG/UC'}
    x = types['AA/UU']
    y = types['CC/GG'] + types['GG/CC']
    mixed = types['AG/UC']
    assert x <= a-1 and y <= b+c-2 and mixed <= 1
    if mixed:
        assert next((i,j) for i,j,t in stacks if t == 'AG/UC') == (a+b+u-1,len(seq)-a)
        assert not any(a <= i < a+b or a <= j < a+b for i,j in pairs)
        assert y <= c-1
    if y == b+c-2:
        target_gc = {(i,j) for i,j in parse(junction(*params)) if seq[i] in 'CG'}
        actual_gc = {(i,j) for i,j in pairs if seq[i] in 'CG'}
        assert actual_gc == target_gc
        if x == a-1:
            assert ps == set(parse(junction(*params)))
    e = score(seq, pairs)
    assert e == -93*x -326*y -208*mixed
    target_e = -93*(a-1)-326*(b+c-2)
    if ps != set(parse(junction(*params))):
        assert e-target_e >= (326*(b-1)-208 if mixed else 93)
    return mixed


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args()
    if args.output.exists():
        raise SystemExit('Refusing to overwrite existing evidence')
    start=time.monotonic()
    rows=[]
    for construction,params in CASES:
        seq=sequence_for(params,construction)
        count=compatible_count(seq)
        row=dict(construction=construction,params=list(params),sequence=seq,compatible_folds=count)
        if count>200000:
            row.update(status='SKIPPED_CAP',cap=200000)
        else:
            ss=compatible_folds(seq)
            assert len(ss)==count and len(set(ss))==count
            energies=Counter(score(seq,s) for s in ss)
            dp=fold(seq)
            assert [(e,energies[e]) for e in sorted(energies)[:2]] == [(e,dp[e][0]) for e in sorted(dp)]
            mixed_count=0
            if construction=='separated_gc':
                for s in ss:
                    mixed_count+=check_lemmas(seq,s,params)
                lemma_status='ALL_ENUMERATED_FOLDS_PASS'
            else:
                lemma_status='NOT_APPLICABLE'
            target=parse(junction(*params))
            target_e=score(seq,target)
            alt=min(score(seq,s) for s in ss if s!=target)
            row.update(status='PASS',target_energy=target_e,minimum_energy=min(energies),
                       optimal_count=energies[min(energies)],gap=alt-target_e,
                       mixed_stack_folds=mixed_count,lemma_status=lemma_status,
                       first_two_levels=[[e,energies[e]] for e in sorted(energies)[:2]])
            compatible_folds.cache_clear()
            compatible_count.cache_clear()
        rows.append(row)
        print(json.dumps(row),flush=True)
    paths=['research/check_stage3.py','research/stage3.py','tests/junction_pilot.py',
           'src/exhaustive.py','src/model.py','src/folding.py','parameters.json']
    result=dict(status='PASS' if all(r['status']=='PASS' for r in rows) else 'PARTIAL',
                python=platform.python_version(),elapsed_seconds=time.monotonic()-start,
                cap_per_case=200000,source_sha256={p:hashlib.sha256((ROOT/p).read_bytes()).hexdigest() for p in paths},
                cases=rows,scope='Independent enumeration and scoring; finite lemma checks only; no Lean proof.')
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(result,indent=2)+'\n')


if __name__=='__main__':
    main()
