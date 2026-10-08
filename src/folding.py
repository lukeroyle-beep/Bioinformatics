"""Exact interval folding retaining two distinct energy levels and exact ties.

P[i,j]: endpoints paired. U[i,j]: endpoints not paired to each other.
F = disjoint union U and P. U uses the unique leftmost-position decomposition.
P adds a stack only when its immediately interior endpoints form a pair.
Entries store (energy, multiplicity, up to two distinct witness structures).
"""
from model import PAIRS, STACKS

EMPTY = {0: (1, ((),))}

def merge(*tables):
    out = {}
    for table in tables:
        for e, (count, witnesses) in table.items():
            old_count, old_witnesses = out.get(e, (0, ()))
            unique = tuple(dict.fromkeys(old_witnesses + witnesses))[:2]
            out[e] = (old_count + count, unique)
    return {e: out[e] for e in sorted(out)[:2]}

def shift(table, cost, pair=None):
    return {e+cost: (count, tuple(tuple(sorted(((pair,) if pair else ()) + s)) for s in ss))
            for e, (count, ss) in table.items()}

def product(a, b):
    pieces = []
    for x, (ca, wa) in a.items():
        for y, (cb, wb) in b.items():
            ws = tuple(tuple(sorted(sa+sb)) for sa in wa for sb in wb)[:2]
            pieces.append({x+y: (ca*cb, ws)})
    return merge(*pieces)

def fold(seq, span=3, objective='stack', wobble=False):
    if not set(seq) <= set('ACGU') or span < 0:
        raise ValueError('Invalid sequence or span')
    if objective not in ('stack', 'pairs') or (objective == 'stack' and wobble):
        raise ValueError('Unsupported model')
    allowed = PAIRS | ({'GU', 'UG'} if wobble else set())
    n = len(seq)
    F, U, P = {}, {}, {}
    get = lambda tab, i, j: EMPTY if i > j else tab[i, j]
    for length in range(1, n+1):
        for i in range(n-length+1):
            j = i+length-1
            ps = {}
            if j-i-1 >= span and seq[i]+seq[j] in allowed:
                pair_cost = -1 if objective == 'pairs' else 0
                unstacked = shift(get(U, i+1, j-1), pair_cost, (i, j))
                stacked = {}
                if i+1 < j-1 and P[i+1, j-1]:
                    cost = pair_cost if objective == 'pairs' else STACKS[seq[i:i+2]+'/'+seq[j]+seq[j-1]]
                    stacked = shift(P[i+1, j-1], cost, (i, j))
                ps = merge(unstacked, stacked)
            P[i, j] = ps
            pieces = [get(F, i+1, j)]
            for k in range(i+span+1, j):
                if P[i, k]:
                    pieces.append(product(P[i, k], get(F, k+1, j)))
            U[i, j] = merge(*pieces)
            F[i, j] = merge(U[i, j], P[i, j])
    return F.get((0, n-1), EMPTY)

def alternative(table, target):
    for e, (_, witnesses) in sorted(table.items()):
        for s in witnesses:
            if s != target:
                return e, s
    return None
