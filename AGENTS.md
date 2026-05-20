# AGENTS.md

## Project Mission

This project is a submission-ready Flutter/Dart memory matching game for CS5450 Mobile Programming, Exercise 2: Memory Matching Flutter Game.

The final result must be professional, polished, original, stable, and easy for an instructor to run and evaluate. The goal is to maximize the grading categories:

1. Programming quality in Flutter/Dart
2. Functionality demonstrated on Android/iOS Emulator and/or Chrome Web
3. App design, art quality, and responsive design

The assignment requires:
- Flutter/Dart code
- A README.pdf explaining configuration and how to run the solution
- Screenshots inside the README.pdf
- Exact project structure described in the README.pdf
- Full Android Studio project uploaded to a public GitHub repository
- A final ZIP package containing Dart files, images, and README.PDF

Do not produce incomplete, placeholder, copied, or fragile work.

---

## Non-Negotiable Rules

### 1. No Placeholder Work

Do not leave:
- TODO comments
- FIXME comments
- placeholder screens
- unused imports
- missing assets
- broken image paths
- fake screenshots
- incomplete README sections
- empty widgets
- dead buttons
- debug-only UI
- commented-out abandoned code

Every feature visible in the app must work.

### 2. Originality

The app must be written as an original implementation for this submission.

Do not copy code from:
- other students
- GitHub repositories
- online tutorials
- StackOverflow answers
- package examples

You may use standard Flutter/Dart APIs and normal programming patterns, but the app code, structure, UI composition, asset set, README, and screenshots must be created for this project.

### 3. Stability First

Do not add unnecessary dependencies.

Prefer Flutter SDK and Dart standard library only unless a dependency clearly improves the project and is stable.

If adding a package:
- explain why it is needed
- add it cleanly to `pubspec.yaml`
- verify it installs successfully
- verify the app runs after adding it
- make sure Android builds still work

### 4. Do Not Damage Platform Files

Do not delete or corrupt:
- `android/`
- `ios/`
- `web/`
- `linux/`
- `macos/`
- `windows/`

Only edit platform files when absolutely necessary. This is primarily a Flutter/Dart assignment, so most work should be in:
- `lib/`
- `assets/`
- `test/`
- `README.md`
- `README.pdf`
- project-level config files such as `pubspec.yaml`

### 5. Always Verify

After meaningful changes, run:

```bash
flutter pub get
flutter analyze
flutter test