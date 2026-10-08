"""Stage 3 constructions and bounded exact-fold observations; no theorem oracle."""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'src'))
from model import junction, parse, energy, dotbracket, validate
from folding import fold, alternative
from exhaustive import score


def sequence_for(params, construction):
    a, b, c, u, v = params
    junction(*params)  # Enforce the frozen target domain.
    if construction == 'stage2_extension':
        return 'A' * (a+b+u) + 'U'*b + 'C'*c + 'A'*v + 'G'*c + 'U'*a
    if construction == 'separated_gc':
        return 'A'*a + 'C'*b + 'A'*u + 'G'*(b+c) + 'A'*v + 'C'*c + 'U'*a
    raise ValueError('Unknown construction')


def observe(params, construction):
    target = junction(*params)
    pairs = parse(target)
    sequence = sequence_for(params, construction)
    table = fold(sequence)
    minimum = min(table)
    target_energy = energy(sequence, pairs)
    alt_energy, alt_pairs = alternative(table, pairs)
    validate(sequence, alt_pairs)
    assert score(sequence, pairs) == target_energy
    assert score(sequence, alt_pairs) == alt_energy
    unique = minimum == target_energy and table[minimum][0] == 1
    assert unique == (alt_energy > target_energy)
    return dict(params=list(params), construction=construction, sequence=sequence,
                target=target, target_energy=target_energy, minimum_energy=minimum,
                optimal_count=table[minimum][0], best_alternative_energy=alt_energy,
                gap=alt_energy-target_energy, unique_target=unique,
                alternative=dotbracket(len(sequence), alt_pairs))
