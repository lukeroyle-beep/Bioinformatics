"""Bounded cross-implementation validation; exits nonzero on any disagreement."""
import hashlib
import itertools
import json
import platform
import random
import sys
import time
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT/'src'))
import model
import exhaustive as ex
from folding import fold

def main():
    start = time.monotonic()
    checked_sequences = checked_folds = tied = 0
    digest = hashlib.sha256()
    coverage = {}
    rng = random.Random(20261008)
    for n in range(13):
        # All <=8; selected finite sample thereafter, not all length-12 sequences.
        seqs = (''.join(s) for s in itertools.product('ACGU', repeat=n)) if n <= 8 else (
            ''.join(rng.choice('ACGU') for _ in range(n)) for _ in range(128))
        count = 0
        for seq in seqs:
            spec, num = ex.spectrum(seq)
            expected = {e: spec[e][0] for e in sorted(spec)[:2]}
            actual = fold(seq)
            assert {e: a[0] for e, a in actual.items()} == expected, (seq, actual, spec)
            for s in ex.structures(n):
                if ex.compatible(seq, s):
                    assert model.energy(seq, s) == ex.score(seq, s), (seq, s)
            for e, (multiplicity, witnesses) in actual.items():
                assert len(set(witnesses)) == min(2, multiplicity)
                for s in witnesses:
                    assert model.energy(seq, s) == e
            checked_sequences += 1
            checked_folds += num
            count += 1
            tied += expected[min(expected)] > 1
            digest.update((seq+':'+repr(expected)+'\n').encode())
        coverage[n] = {'sequence_cases':count, 'admissible_topologies':len(ex.structures(n))}
    # Two independent parameter encodings agree in all 16 orientations.
    for i, outer in enumerate(ex.PAIR_ORDER):
        for j, inner in enumerate(ex.PAIR_ORDER):
            seq = outer[0]+inner[0]+'AAA'+inner[1]+outer[1]
            ps = ((0,6),(1,5))
            assert model.energy(seq,ps) == ex.MATRIX[i][j]
    # Published documentation's six-pair example: stack sum only, not full energy.
    pairword = ('AU','GC','CG','GC','CG','UA')
    seq = ''.join(p[0] for p in pairword)+'AAA'+''.join(p[1] for p in reversed(pairword))
    ps = model.parse('('*6+'...'+')'*6)
    assert model.energy(seq,ps) == -1336
    # Empty and isolated pair must tie under stacking-only, span boundary enforced.
    assert fold('AAAAC')[0][0] == 1
    assert fold('AAA AU'.replace(' ',''))[0][0] == 2
    for seq, ps in [('ACGU',((0,3),)),('GAAAU',((0,4),)),('GCGCGCGC',((0,5),(2,7)))]:
        try:
            model.energy(seq,ps)
        except ValueError:
            pass
        else:
            raise AssertionError(('Invalid structure accepted',seq,ps))
    assert len(ex.structures(12,0)) == 15511, 'Published Fig 1 topology count'
    baseline=[]
    for stem in (3,4):
        for loop in (3,4):
            seq='G'*stem+'A'*loop+'C'*stem
            target=model.parse('('*stem+'.'*loop+')'*stem)
            for span,wobble in ((0,True),(3,False)):
                spec,_=ex.spectrum(seq,span,'pairs',wobble)
                dp=fold(seq,span,'pairs',wobble)
                assert {e:a[0] for e,a in dp.items()} == {e:spec[e][0] for e in sorted(spec)[:2]}
                assert min(spec)==-stem and spec[-stem][0]==1 and spec[-stem][1][0]==target
                baseline.append({'sequence':seq,'target':model.dotbracket(len(seq),target),'span':span,'wobble':wobble,'maximum_pairs':stem,'optimal_count':1})
    result={'status':'PASS','model':model.PARAMETERS['model_id'],'python':platform.python_version(),
            'sequence_cases':checked_sequences,'compatible_folds_scored_twice':checked_folds,
            'cases_with_tied_optima':tied,'coverage':coverage,'results_sha256':digest.hexdigest(),
            'parameter_orientations_checked':16,'seed_figure_1_topology_count_n12_span0':15511,
            'base_pair_theorem_instances':baseline,'seconds':round(time.monotonic()-start,3),
            'limits':'Finite cross-implementation evidence; no general folder correctness or designability proof.'}
    (ROOT/'results'/'validation.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))

if __name__=='__main__':
    main()
