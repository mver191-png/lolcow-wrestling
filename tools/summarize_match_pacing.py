"""Summarize matched CPU samples without treating duration as a pass/fail score."""
from __future__ import annotations
import argparse
import json
import math
import statistics
from pathlib import Path


def nearest_rank(values: list[float], probability: float) -> float | None:
    if not values:
        return None
    ordered = sorted(values)
    return ordered[max(0, math.ceil(len(ordered) * probability) - 1)]


def summarize(document: dict) -> dict:
    records = document["matches"]
    completed = [m for m in records if not m["timeout"]]
    durations = [m["seconds"] for m in completed]
    return {
        "matches": len(records),
        "completed": len(completed),
        "timeouts": len(records) - len(completed),
        "median_completed_seconds": statistics.median(durations) if durations else None,
        "p10_completed_seconds": nearest_rank(durations, 0.10),
        "p90_completed_seconds": nearest_rank(durations, 0.90),
        "minimum_completed_seconds": min(durations, default=None),
        "maximum_completed_seconds": max(durations, default=None),
        "player_one_wins": sum(m["result"]["winner_slot"] == 1 for m in completed),
        "near_zero_stamina_losses": sum(m["result"]["loser_stamina"] < 0.001 for m in completed),
        "losses_above_70_percent_vitality": sum(m["result"]["loser_vitality"] > 0.70 for m in completed),
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("before", type=Path)
    parser.add_argument("after", type=Path)
    args = parser.parse_args()
    before, after = [json.loads(p.read_text()) for p in (args.before, args.after)]
    key = lambda m: (m["a"], m["b"], m["seed"])
    if sorted(map(key, before["matches"])) != sorted(map(key, after["matches"])):
        raise SystemExit("Before/after must contain the same ordered pair/seed cases")
    if any(before[k] != after[k] for k in ("physics_hz", "visuals", "timeout_seconds")):
        raise SystemExit("Before/after simulation settings do not match")
    print(json.dumps({
        "comparison": "Same ordered pairs and seeds; entire controller patch, not an isolated causal estimate.",
        "duration_note": "Quantiles exclude timeouts; timeout counts must be read alongside durations.",
        "quantile_method": "nearest rank",
        "before": summarize(before), "after": summarize(after),
    }, indent=2))


if __name__ == "__main__":
    main()
