# Next Implementation Tasks: Pass B (64-Matchup Scene Validation & Skeletal Animation Pipeline)

## Pass A Status: 100% Complete & Verified
All critical combat repairs mandated by source code review have been implemented, verified, and confirmed passing across 396 automated tests (340 unit/mechanics tests + 56 full scene physics integration tests with 0 failures, 0 warnings, 0 ObjectDB leaks):
1. **Pin-Balance Acceptance**: 4-mode empirical validation (CPU, 10 Hz Mash, Hold-on-Entry, Pre-Held), explicit move metadata impact classification (ordinary heavy impact vs genuine finisher disorientation), and tick 198 (3.30s) kickout/rope break preemptive priority over 3-count.
2. **Boundary-Safe Paired Throws**: Pre-throw spatial trajectory validation and inward pair adjustment ($d_{\text{slam}} \le 3.50\text{m}$) preventing defender out-of-bounds clipping through ring ropes ($|x| > 3.65\text{m}$).
3. **Directional Contact & Grapple Startup**: Forward contact cone ($\cos(60^\circ) = 0.50$, $120^\circ$ cone) in strike windows, measurable `GRAPPLE_STARTUP` window ($0.18\text{s}$ duration, $0.25\text{s}$ whiff recovery), strike interruption, reversal counter, and tactical CPU reaction.
4. **Simultaneous Submission Outcome Ordering & Centralized Hold Cleanup**: Authoritative simultaneous priority policy (`ESCAPE_BREAKS` vs `TAPOUT_WINS`) in `MatchManager`, 1.0 HP clutch survival on buzzer-beater breakouts, and symmetrical pointer clearing (`synchronized_partner = null`) across all breakout, rope break, and tap-out pathways.

---

## Pass B Roadmap & Priorities

### Priority 1: Scene Integration & Visual Verification Across All 64 Matchups
- Run headless automated matchup validation across all 8 x 8 = 64 fighter combinations.
- Verify scene loading, mesh attachment, stat scaling, signature move execution, and win/loss resolution for every roster pairing.
- Note: Headless execution remains standard; visual inspections and manual playtests remain designated according to code review protocol.

### Priority 2: Skeletal Animation Rigging & Authored Animation Pipeline
- Establish glTF/GLB skeletal armature pipeline in Blender for all 8 fighter archetypes.
- Replace procedural geometric tweening with authored skeletal animation clips:
  - Idles, walk cycles, guard stance, strike animations (punches, kicks, backfists).
  - Synchronized throw animations (powerslams, suplexes, trips, takedowns).
  - Ground states (knockdown, ground struggle, pinfall hold, getting up).
  - Submission holds (armbars, chokes, Boston crabs, figure-fours).
- Implement Godot `AnimationTree` state machines for smooth blending and root motion support.

### Priority 3: Tournament & Spectator Modes (Post-Combat Acceptance)
- Tournament bracket generator (single-elimination 8-fighter tournament).
- Spectator / CPU vs CPU exhibition mode with broadcast camera director transitions.
- Victory screens, championship trophy presentation, and match statistics recap.
