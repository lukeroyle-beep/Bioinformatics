"""Independent oracle: topology enumeration and explicit outer/inner pair matrix.

Does not import the production model, scorer or dynamic-programming implementation.
The 16 values were transcribed independently from the published ten-stack table.
"""
from functools import lru_cache

PAIR_ORDER = ('AU', 'UA', 'CG', 'GC')
MATRIX = ((-93, -110, -224, -208),
          (-133, -93, -235, -211),
          (-211, -208, -326, -236),
          (-235, -224, -342, -326))

@lru_cache(None)
def structures(n, span=3):
    if n == 0:
        return ((),)
    out = [tuple((i+1, j+1) for i, j in s) for s in structures(n-1, span)]
    for k in range(span+1, n):
        for inside in structures(k-1, span):
            for after in structures(n-k-1, span):
                out.append(((0, k),) + tuple((i+1, j+1) for i, j in inside)
                           + tuple((i+k+1, j+k+1) for i, j in after))
    return tuple(out)

def compatible(seq, pairs, wobble=False):
    allowed = PAIR_ORDER + (('GU', 'UG') if wobble else ())
    return all(seq[i] + seq[j] in allowed for i, j in pairs)

def score(seq, pairs):
    partner = [-1] * len(seq)
    for i, j in pairs:
        partner[i], partner[j] = j, i
    total = 0
    for i in range(len(seq)-1):
        j = partner[i]
        if j > i+1 and partner[i+1] == j-1:
            outer = PAIR_ORDER.index(seq[i] + seq[j])
            inner = PAIR_ORDER.index(seq[i+1] + seq[j-1])
            total += MATRIX[outer][inner]
    return total

def spectrum(seq, span=3, objective='stack', wobble=False):
    spectrum = {}
    folds = 0
    for s in structures(len(seq), span):
        if compatible(seq, s, wobble):
            e = score(seq, s) if objective == 'stack' else -len(s)
            count, witnesses = spectrum.get(e, (0, []))
            if len(witnesses) < 2:
                witnesses.append(s)
            spectrum[e] = (count+1, witnesses)
            folds += 1
    return spectrum, folds
