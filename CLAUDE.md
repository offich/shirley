# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

**Shirley** is a Flutter DevTools Extension that provides an interactive UI for generating customizable Flutter `ElevatedButton` widget code. Users configure button properties through the UI, see a live preview, and copy the generated Dart code.

Uses FVM to pin Flutter to `3.38.10`. Prefix Dart/Flutter commands with `fvm` (e.g., `fvm flutter run`).

## Common Commands

```bash
# Run in simulated DevTools environment (for local development)
fvm flutter run -d chrome --dart-define=use_simulated_environment=true

# Run in real DevTools environment
fvm dart run devtools_extensions build_and_copy --source=. --dest=./example/extension/devtools
cd example && fvm flutter run

# Lint and format checks (mirrors CI)
dart format --set-exit-if-changed lib test
fvm flutter analyze lib test

# Run tests
fvm flutter test
fvm flutter test test/widget_test.dart  # single test file
```

## Architecture

### Data Flow

`ButtonField` (model) → `toCode()` (code_builder AST) → Dart source string displayed in `PreviewCodeView`

`ButtonField` → `toJsonString()` → JSON schema → `json_dynamic_widget` renders live preview in `PreviewWidgetView`

### Key Files

- **lib/main.dart** — Entry point; runs `ShirleyDevToolsExtension()`
- **lib/shirley.dart** — Root widgets: `ShirleyDevToolsExtension` (DevTools API event wiring) and `Shirley` (main layout with preset button configs)
- **lib/src/model/button_field.dart** — Core data model. Contains `toCode()` (generates Dart code via `code_builder`) and `toJsonString()` (generates JSON for dynamic widget rendering)

### UI Component Tree

```
ShirleyDevToolsExtension
└── Shirley (presets + layout)
    ├── PreviewContainer (TabBarView)
    │   ├── PreviewWidgetView  ← renders button via json_dynamic_widget
    │   └── PreviewCodeView    ← syntax-highlighted Dart code
    └── FieldSettingContainer (TabBarView)
        ├── QuickSettingView   ← basic controls
        ├── BodySettingView    ← size/border settings
        └── TextSettingView    ← text/typography settings
```

All stateful widgets use `flutter_hooks` (HookWidget + `useState`/`useEffect`).

### DevTools Extension Config

`extension/devtools/config.yaml` — declares the extension to DevTools. `requiresConnection: false` means it works without a connected app.

During publishing, the built extension is copied to `example/extension/devtools/` via `devtools_extensions build_and_copy`.

## CI

- **code-analysis.yml** — triggers on changes to `lib/`, `test/`, `pubspec.yaml`; runs format check and `flutter analyze`
- **publish.yml** — triggers on `v*` tags; validates extension, builds, copies to example/, then publishes to pub.dev
