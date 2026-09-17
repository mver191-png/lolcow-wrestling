# Architectural Decisions: LOLCOW WRESTLING: OFFLINE MAYHEM

## Decision 1: Single Authoritative Movement Ownership
- **Context**: Wrestling games frequently suffer from sliding while downed, attacks while prone, or physics fighting animations.
- **Decision**: `FighterState` acts as strict gatekeeper. In `KNOCKED_DOWN`, `GETTING_UP`, `PINNED`, or `GRAPPLING_DEFENDER`, input movement vectors are discarded, velocity is clamped to zero, and position is driven purely by authored sequence or pin lock.

## Decision 2: Synchronized Grapple & Throw Resolution
- **Context**: Independent colliders during throws cause hand disconnection, clipping, or missed impacts.
- **Decision**: An initiated grapple validates range, angle, and state. When accepted, attacker locks defender into `GRAPPLING_DEFENDER` and becomes owner of defender's transform relative to attacker's root. At impact keyframe, authoritative single damage is applied, defender is transitioned to `KNOCKED_DOWN` at the exact canvas landing spot, and mutual lock is released.

## Decision 3: KingCobraJFS Referee Design & Memorial
- **Context**: KingCobraJFS passed away on 21 August 2025.
- **Decision**: KingCobraJFS serves as the neutral, respectful referee throughout all matches. He wears a referee uniform with restrained gothic accents and features a permanently visible soft gold halo. The halo pulses rhythmically with each count of the match (1, 2, 3). He is strictly non-targetable, non-colliding with fighters, and non-exploitable; match rules dictate the authoritative count, while the referee provides the visual in-ring storytelling.

## Decision 4: Combat Timing & Reversals
- **Context**: Button-mashing or spamming leads to degenerate gameplay.
- **Decision**: Explicit rock-paper-scissors arcade dynamics:
  - Strikes interrupt exposed grapple startup.
  - Grapples break turtling blocks.
  - Reversals punish predictable strike/grapple commitments at the cost of stamina/reversal stat.
  - Finishers require 100 Hype and a valid opening/setup.
