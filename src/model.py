"""Frozen model, explicit structure validation and direct stack scoring."""
import json
from pathlib import Path

PARAMETERS = json.loads((Path(__file__).resolve().parents[1] / 'parameters.json').read_text())
PAIRS = frozenset(PARAMETERS['ordered_pairs'])
STACKS = {}
for key, value in PARAMETERS['stack_central_values'].items():
    top, bottom = key.split('/')
    for k in (key, bottom[::-1] + '/' + top[::-1]):
        assert k not in STACKS or STACKS[k] == value
        STACKS[k] = value
assert len(STACKS) == 16

def parse(text):
    pending, pairs = [], []
    for i, c in enumerate(text):
        if c == '(':
            pending.append(i)
        elif c == ')':
            if not pending:
                raise ValueError('Unbalanced structure')
            pairs.append((pending.pop(), i))
        elif c != '.':
            raise ValueError('Unknown structure symbol')
    if pending:
        raise ValueError('Unbalanced structure')
    return tuple(sorted(pairs))

def validate(sequence, pairs, span=3, wobble=False):
    if not set(sequence) <= set('ACGU'):
        raise ValueError('Unknown base')
    allowed = PAIRS | ({'GU', 'UG'} if wobble else set())
    used = set()
    for i, j in pairs:
        if not (0 <= i < j < len(sequence) and j - i - 1 >= span):
            raise ValueError('Invalid index or span')
        if i in used or j in used or sequence[i] + sequence[j] not in allowed:
            raise ValueError('Incompatible or multiply paired position')
        used.update((i, j))
    for i, j in pairs:
        for k, l in pairs:
            if i < k < j < l:
                raise ValueError('Crossing pairs')

def energy(sequence, pairs, span=3):
    validate(sequence, pairs, span)
    ps = set(pairs)
    return sum(STACKS[sequence[i:i+2] + '/' + sequence[j] + sequence[j-1]]
               for i, j in pairs if (i+1, j-1) in ps)

def dotbracket(n, pairs):
    a = ['.'] * n
    for i, j in pairs:
        a[i], a[j] = '(', ')'
    return ''.join(a)

def junction(a=3, b=3, c=3, u=3, v=3):
    if min(a, b, c, u, v) < 3:
        raise ValueError('Outside target family')
    return '(' * a + '(' * b + '.' * u + ')' * b + '(' * c + '.' * v + ')' * c + ')' * a
