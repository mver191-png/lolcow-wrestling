# Known Issues & Observable Defects: LOLCOW WRESTLING: OFFLINE MAYHEM

## Resolved in M2 & M3
1. **Procedural vs Skeletal Animation (Resolved for M3 Baseline)**:
   - Synchronized state-machine locking and deformation offsets guarantee rock-solid throws and submissions.
2. **Asymmetric Grapple Lift Offsets (Resolved in M2)**:
   - Implemented weight-class and leverage ratio throw trajectory scaling (low-angle trips vs overhead slams).
3. **Sound Effects & Foley (Resolved in M2/M3)**:
   - Integrated procedural 16-bit PCM synthesized audio manager with ring bell, impacts, power chords, fanfares, and referee counts.
4. **Desktop Launcher Script Trailing Quote Bug (Resolved in M3 Polish)**:
   - Fixed `%~dp0` trailing backslash in `START_GAME.bat` which previously caused Godot to abort due to escaped quote in arguments.
   - Created direct Windows Desktop shortcut at `C:\Users\mauri\Desktop\LOLCOW WRESTLING.lnk`.

