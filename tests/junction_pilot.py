"""Predeclared 256 candidate screen; no optimisation or universal claim."""
import itertools
import json
import random
import sys
from functools import lru_cache
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'src'))
from model import junction, parse, energy, dotbracket
from folding import fold, alternative
import exhaustive as ex

@lru_cache(None)
def compatible_count(seq):
    """Count before materialising so the declared enumeration budget is respected."""
    if not seq:
        return 1
    return compatible_count(seq[1:])+sum(
        compatible_count(seq[1:k])*compatible_count(seq[k+1:])
        for k in range(4,len(seq)) if seq[0]+seq[k] in ex.PAIR_ORDER)

@lru_cache(None)
def compatible_folds(seq, offset=0):
    if not seq:
        return ((),)
    out=[s for s in compatible_folds(seq[1:],offset+1)]
    for k in range(4,len(seq)):
        if seq[0]+seq[k] not in ex.PAIR_ORDER:
            continue
        for a in compatible_folds(seq[1:k],offset+1):
            for b in compatible_folds(seq[k+1:],offset+k+1):
                out.append(((offset,offset+k),)+a+b)
                if len(out)>200000:
                    raise RuntimeError('Explicit enumeration case cap exceeded')
    return tuple(out)

def main():
    target=junction()
    ps=parse(target)
    # Pair coordinates distinguish outer, left and right stem without relying on scorer.
    stems=[[(0,23),(1,22),(2,21)],[(3,11),(4,10),(5,9)],[(12,20),(13,19),(14,18)]]
    assert tuple(sorted(p for s in stems for p in s))==ps
    candidates=[]
    for words in itertools.product(ex.PAIR_ORDER,repeat=3):
        chars=['A']*24
        for stem,word in zip(stems,words):
            for i,j in stem:
                chars[i],chars[j]=word
        candidates.append(('constant_stems',''.join(chars)))
    rng=random.Random(24031008)
    for _ in range(192):
        chars=[rng.choice('ACGU') for _ in range(24)]
        for i,j in ps:
            chars[i],chars[j]=rng.choice(ex.PAIR_ORDER)
        candidates.append(('random_compatible',''.join(chars)))
    results=[]
    for origin,seq in candidates:
        table=fold(seq)
        best=min(table)
        target_e=energy(seq,ps)
        alt=alternative(table,ps)
        assert alt is not None
        alt_e,alt_s=alt
        row={'origin':origin,'sequence':seq,'target_energy':target_e,'minimum_energy':best,
             'optimal_count':table[best][0],'best_alternative_energy':alt_e,
             'gap':alt_e-target_e,'unique_target':best==target_e and table[best][0]==1,
             'alternative':dotbracket(24,alt_s)}
        assert ex.score(seq,ps)==target_e and ex.score(seq,alt_s)==alt_e
        assert row['unique_target']==(row['gap']>0)
        results.append(row)
    checks=[]
    chosen=[]
    skipped=[]
    for label,predicate in (('unique',lambda r:r['unique_target']),('tie',lambda r:r['gap']==0),('beaten',lambda r:r['gap']<0)):
        row=None
        for candidate in results:
            if not predicate(candidate):
                continue
            count=compatible_count(candidate['sequence'])
            if count>200000:
                skipped.append({'category':label,'sequence':candidate['sequence'],'compatible_fold_count':count,'reason':'declared 200000 enumeration cap'})
                continue
            row=candidate
            break
        if row and row['sequence'] not in chosen:
            chosen.append(row['sequence'])
            ss=compatible_folds(row['sequence'])
            energies=[(ex.score(row['sequence'],s),s) for s in ss]
            best=min(e for e,_ in energies)
            count=sum(e==best for e,_ in energies)
            alt=min(e for e,s in energies if s!=ps)
            assert (best,count,alt)==(row['minimum_energy'],row['optimal_count'],row['best_alternative_energy'])
            checks.append({'category':label,'sequence':row['sequence'],'folds_enumerated':len(ss),'status':'PASS','minimum_energy':best,'optimal_count':count,'best_alternative_energy':alt})
            compatible_folds.cache_clear()
    output={'status':'PASS','target':target,'positions':24,'candidate_count':len(results),
            'distinct_candidates':len(set(r['sequence'] for r in results)),
            'unique_target_count':sum(r['unique_target'] for r in results),
            'tied_target_count':sum(r['gap']==0 for r in results),
            'beaten_target_count':sum(r['gap']<0 for r in results),
            'full_enumeration_crosschecks':checks,'enumeration_cap_skips':skipped,'candidates':results,
            'scope':'Selected sequences for one target only; no general theorem or undesignability result.'}
    (ROOT/'results'/'junction_pilot.json').write_text(json.dumps(output,indent=2)+'\n')
    print(json.dumps({k:v for k,v in output.items() if k!='candidates'},indent=2))
    good=next((r for r in results if r['unique_target']),None)
    print('FIRST_SUCCESS',json.dumps(good))

if __name__=='__main__':
    main()
