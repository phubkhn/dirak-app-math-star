# ADR-001: Engine, renderer, and Android export toolchain

## Status

Accepted (2026-07-30).

## Context

`APP_SPEC.md` §8.1 already recommends Godot 4.x/GDScript. This ADR records the concrete toolchain choices made when actually setting up the production project and producing a first installable build, per the owner's request to build all features and produce an APK targeting a Samsung Galaxy S25.

## Decision

- **Engine:** Godot 4.7.1 (stable), installed via `brew install --cask godot`.
- **Renderer:** `rendering/renderer/rendering_method = "mobile"` (Forward Mobile), matching APP_SPEC's guidance to favor lighter rendering for wider device support.
- **Android SDK toolchain:** installed locally via `brew install --cask android-commandlinetools`, with `platform-tools`, `platforms;android-34`, and `build-tools;34.0.0` installed through `sdkmanager`. JDK: the machine's existing Corretto 21 (OpenJDK).
- **Export templates:** official `Godot_v4.7.1-stable_export_templates.tpz`, matching the installed engine version exactly (export templates must match the engine version or export silently fails/mismatches).
- **Signing (this build only):** a standard Android debug keystore (`androiddebugkey` / `android`), generated locally with `keytool` using Google's documented debug-keystore parameters. This is fine for local sideload testing; it is **not** a release-signing key and must not be used for a Google Play submission.
- **Export path used:** the "quick" (non-Gradle) Android export (`gradle_build/use_gradle_build=false`), which repackages Godot's prebuilt `android_debug.apk` template. This does **not** require Gradle/AGP or network access during export, but it also means custom `min_sdk`/`target_sdk` values in `export_presets.cfg` are not honored — the resulting manifest uses whatever SDK levels are baked into the official Godot 4.7.1 debug template (observed: `minSdkVersion 24`, `targetSdkVersion 36`), which is comfortably compatible with a Galaxy S25 but not yet verified against `GP-08`'s Phase 2 target-API requirement for a real Play Store submission.

## Consequences

- Package name is currently `vn.dirak.hanhtrinhsaotoan` — a placeholder. Per `APP_SPEC.md` §15.1 (GP-04), this **cannot be changed after first Play Console registration**, so it must be finalized deliberately before any Phase 2 submission work, not left as this placeholder.
- Because this uses the non-Gradle export path, moving to a Play Store **release** build later will require switching to `gradle_build/use_gradle_build=true`, which needs Gradle/AGP available (network access during build) and re-verifying `min_sdk`/`target_sdk` actually apply. That is future work, out of scope for this local debug build.
- No physical Android device was connected during this session, so the produced APK has been build-verified (signed, valid manifest) but not yet runtime-verified on real hardware. See `docs/qa/` for the outstanding device-verification task.
