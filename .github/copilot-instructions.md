# Copilot instructions for Godot_Asteroids

This file gives targeted, actionable guidance for AI coding agents working on this Godot 4.x project.

- **Project root & engine**: Open the project with Godot 4.5 (see [project.godot](project.godot)). The game's main scene is `Scenes/LoadingScreen.tscn` configured in `project.godot`.

- **Global state / event bus**: Communication uses a central event autoload in [Scripts/Events.gd](Scripts/Events.gd). Prefer emitting and connecting to these signals rather than tight coupling between scenes. Example: `Events.fire_laser` (emitted in `Scripts/ship.gd`, handled in `Scripts/BulletManager.gd`).

- **Autoload singletons**: Important autoloads are declared in `project.godot`: `Events`, `GameSettings`, and `HighScore` (see [project.godot](project.godot)). To add a new global, register it as an autoload there and use signals for communication.

- **Managers & architecture**: The codebase uses manager nodes under `Scripts/` that centralize domain logic:
  - Asteroids: [Scripts/AsteroidManager.gd](Scripts/AsteroidManager.gd) (spawning, groups)
  - Bullets: [Scripts/BulletManager.gd](Scripts/BulletManager.gd) (instantiates `Scenes/laser.tscn`)
  - Audio: [Scripts/AudioManager.gd](Scripts/AudioManager.gd) (listens to `GameSettings` signals and `Events`)
  - Game flow: [Scripts/GameManager.gd](Scripts/GameManager.gd) (lives, levels, core game loops)

- **Patterns and conventions**:
  - Use `preload("res://...")` for scene and asset references (see many managers).
  - Use signals on `Events` for cross-node communication; never directly call distant nodes.
  - Use `user://` for local persistence (`GameSettings` stores `user://settings.save`, `HighScore` uses `user://highscore.save`).
  - Nodes frequently expose `cleanup()` to safely remove group objects (see `AsteroidManager._On_New_Game` and `ship.cleanup`).
  - Group usage: asteroids are added to the "asteroids" group; use `get_nodes_in_group("asteroids")` to query.
  - Naming: functions and variables use snake_case; exported properties use `@export`.

- **Physics & plugins**: Project uses the Box2D physics backend (see `[physics]` in [project.godot](project.godot)) and contains `addons/godot-box2d/` — be cautious when changing physics layers or contact handling.

- **Audio & settings coupling**: `AudioManager` listens to `GameSettings.*_volume_changed` signals; change volumes through `Scripts/GameSettings.gd` to automatically update audio.

- **Debugging shortcuts & dev keys**: Several scripts check raw keypresses for quick dev actions (e.g., `KEY_HOME` spawns an asteroid in `AsteroidManager.gd`, `KEY_END` kills the ship in `ship.gd`). Use these for quick in-editor testing.

- **Where experiments should go**: Add new gameplay features as small manager nodes, register signals in `Events.gd` when cross-component messages are needed, and keep per-entity logic in their scene scripts (e.g., `Scenes/asteroid.tscn` + `Scripts/Asteroid.gd`).

- **Common pitfalls**:
  - Avoid direct scene-tree traversals between distant nodes; prefer `Events` to avoid fragile coupling.
  - When removing nodes during physics callbacks, use `queue_free()` or deferred property setters (the code uses `set_deferred` for collision layers).
  - Persisted files use `user://` — do not hardcode OS paths.

- **Files to inspect for examples** (start here):
  - [project.godot](project.godot)
  - [Scripts/Events.gd](Scripts/Events.gd)
  - [Scripts/GameManager.gd](Scripts/GameManager.gd)
  - [Scripts/GameSettings.gd](Scripts/GameSettings.gd)
  - [Scripts/AudioManager.gd](Scripts/AudioManager.gd)
  - [Scripts/AsteroidManager.gd](Scripts/AsteroidManager.gd)
  - [Scripts/BulletManager.gd](Scripts/BulletManager.gd)
  - [Scenes/ship.tscn](Scenes/ship.tscn) and [Scripts/ship.gd](Scripts/ship.gd)

- **If you need to run or test**: Open the project in Godot 4.5 and run the main scene from the editor. Use dev keys (HOME/END) noted above for quick checks. There is no separate build step in this repo — use Godot's export workflow for packaging.

If any area needs deeper examples (signal names, typical payloads, or where to add an autoload), tell me which part to expand and I will update this file.
