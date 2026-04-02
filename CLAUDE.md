# CLAUDE.md - Flutter Project Guide

This is a comprehensive Flutter project with multi-flavor support, Firebase integration, and extensive tooling.

## 🏗️ Architecture & Structure

### Key Directories

- `lib/` - Main Dart source code
  - `common/` - Shared utilities, helpers, and constants
  - `data_source/` - API services, database, Firebase, and preferences
  - `model/` - Data models with Freezed, JSON serialization
  - `ui/` - Pages, components, and view models
  - `navigation/` - Auto route navigation setup
  - `exception/` - Error handling and exception mapping
- `test/` - Unit tests, widget tests, and integration tests
- `assets/` - Images, fonts, and other resources
- `dart_defines/` - Environment-specific configuration files
- `tools/` - Custom Dart tools for project maintenance

### Key Files

- `makefile` - Build automation and common commands
- `pubspec.yaml` - Dependencies and project configuration
- `analysis_options.yaml` - Dart analysis rules
- `l10n.yaml` - Localization configuration

## 🔧 Essential Commands

### Quick Setup

```bash
make gen_env        # Generate environment configurations
make sync           # Full project sync (pub get, l10n, build_runner)
make ref            # Clean and refresh everything
```

### Development Workflow

```bash
make pg             # Flutter pub get (includes super_lint)
make ln             # Generate localizations
make fb             # Build runner (generate code)
make ccfb           # Clean then build runner
```

### Code Quality

```bash
make lint           # Run all linting (super_lint + analyze)
make te             # Run all tests (unit + widget)
make fm             # Format code and sort ARB files
make check_ci             # Full CI pipeline locally
```

### Testing

```bash
make ut             # Unit tests only
make wt             # Widget tests only
make ug             # Update golden test files
```

### Building Apps

```bash
# APK builds
make build_dev_apk  # Development APK
make build_qa_apk   # QA APK
make build_stg_apk  # Staging APK
make build_prod_apk # Production APK

# iOS builds
make build_dev_ipa  # Development IPA
make build_qa_ipa   # QA IPA
make build_stg_ipa  # Staging IPA
make build_prod_ipa # Production IPA
```

## 📦 Flavors & Environments

### Supported Flavors

- **develop** - Development environment
- **qa** - Quality assurance environment
- **staging** - Pre-production environment
- **production** - Live production environment

### Configuration Files

- `dart_defines/develop.json` - Dev environment variables
- `dart_defines/qa.json` - QA environment variables
- `dart_defines/staging.json` - Staging environment variables
- `dart_defines/production.json` - Production environment variables

## 🧪 Testing Strategy

### Golden Tests

- Located in `test/ui_kit/`
- Update with `make ug`
- Used for visual regression testing

### Unit Tests

- Located in `test/unit_test/`
- Focus on business logic and utilities
- Run with `make ut`

### Widget Tests

- Located in `test/widget_test/`
- Test UI components and interactions
- Run with `make wt`

### Integration Tests

- Located in `integration_test/`
- End-to-end testing scenarios

## 📱 Key Dependencies

### State Management

- `hooks_riverpod` - Reactive state management
- `flutter_hooks` - React-like hooks for Flutter

### Networking & Data

- `dio` - HTTP client
- `firebase_*` - Firebase services (Auth, Firestore, Analytics, etc.)
- `isar` - Local database
- `freezed` - Immutable data classes

### UI & Navigation

- `auto_route` - Type-safe navigation
- `cached_network_image` - Image caching

### Code Generation

- `build_runner` - Code generation runner
- `json_serializable` - JSON serialization
- `injectable` - Dependency injection

## 🔍 Code Style & Analysis

### Linting

- Uses `super_lint` (custom lint rules)
- Line length: 100 characters
- Dart formatter with strict rules
- Run `dart run custom_lint` to check all custom rules

### Important Conventions

- Use Freezed for data models
- Follow Repository pattern for data sources
- Use Riverpod for state management
- Implement proper error handling with custom exceptions

## 🚨 Custom Lint Rules (MUST follow)

### `avoid_hard_coded_colors`

- NEVER use `Color(0xFF...)`, `Colors.white`, `Colors.black`, etc. in `lib/ui/`
- Use `color.xxx` from `AppColors` (getter in `res.dart`)
- If color doesn't exist, add it to `lib/resource/app_colors.dart` first
- Example: `color.primary`, `color.white`, `color.greyscale900`

### `avoid_hard_coded_strings`

- Applies to: `lib/ui/page/**/*_page.dart`, `lib/ui/page/**/view_model/*.dart`
- Use `l10n.xxx` from ARB localization files
- Add strings to BOTH `intl_vi.arb` and `intl_en.arb`, run `make ln`

### `prefer_common_widgets`

- `CommonText` instead of `Text`
- `CommonImage.asset` instead of `Image.asset`
- `CommonImage.svg` instead of `SvgPicture`
- `CommonImage.network` instead of `Image.network`
- `CommonScaffold` instead of `Scaffold`
- `CommonAppBar` instead of `AppBar`

### `prefer_single_widget_per_file`

- One widget class per file in `lib/ui/`
- Extract sub-widgets into `component/` subfolder

### `prefer_importing_index_file`

- Export new files in `lib/index.dart` (sorted alphabetically)
- Import via `index.dart`, not individual files

### `missing_run_catching`

- All async operations in ViewModel must use `runCatching(action: () async { ... })`
- Use `handleLoading: false` if no loading indicator needed

### `avoid_unnecessary_async_function`

- Don't mark functions `async` if they don't use `await`

### `avoid_using_text_style_constructor_directly`

- Use `style()` helper from `app_text_style.dart` instead of `TextStyle()`

### `missing_golden_test`

- Every `*_page.dart` must have golden test in `test/widget_test/`

## 📐 Page Architecture Pattern

Every new page must include:

1. **Page file**: `@RoutePage()`, extends `BasePage<State, Provider>`, defines `screenViewEvent`
2. **State file**: `@freezed`, extends `BaseState`
3. **ViewModel file**: `StateNotifierProvider.autoDispose`, extends `BaseViewModel<State>`
4. **ScreenName**: Add enum entry in `lib/common/helper/analytics/screen_name.dart`
5. **Route**: Add in `lib/navigation/routes/app_router.dart`
6. **Exports**: Add all files to `lib/index.dart`
7. **Golden test**: Add in `test/widget_test/ui/page/<name>/`
8. **Generate**: Run `make fb` after creating freezed/route files

## 🚀 CI/CD Integration

### Supported Platforms

- Jenkins (`Jenkinsfile`)
- Bitbucket Pipelines (`bitbucket-pipelines.yml`)
- CodeMagic (`codemagic.yaml`)
- GitHub Actions (`.github/workflows/`)

### Fastlane Integration

- iOS: `ios/fastlane/Fastfile`
- Android: `android/fastlane/Fastfile`
- Automated version bumping and deployment

## ⚠️ Important Notes

### Before Making Changes

1. Always run `make sync` after pulling changes
2. Use `make ci` before committing
3. Run `make te` to ensure tests pass
4. Update golden tests with `make ug` if UI changes

### Firebase Setup Required

- Configure `google-services.json` for each Android flavor
- Configure `GoogleService-Info.plist` for each iOS flavor
- Update Firebase project IDs in configuration files

### Multi-flavor Development

- Use `--flavor {flavor_name}` when running/building
- Each flavor has separate Firebase projects
- Environment variables defined in `dart_defines/` JSON files

### Performance Considerations

- Images are cached via `cached_network_image`
- Implement proper state management with Riverpod

## 🔧 Troubleshooting

### Common Issues

1. **Build failures**: Run `make ref` (clean + refresh)
2. **Missing translations**: Run `make ln`
3. **Generated code issues**: Run `make ccfb`
4. **iOS pod issues**: Run `make pod`
5. **Test failures**: Check golden files with `make ug`

### Clean Reset
 Notes

### Before Making Changes

1. Always run `make sync` after pulling changes
2. Use `make ci` before committing
3. Run `make te` to ensure tests pass
4. Update golden tests with `make ug` if UI changes

### Firebase Setup Required

- Configure `google-services.json` for each Android flavor
- Configure `GoogleService-Info.plist` for each iOS flavor
- Update Firebase project IDs in configuration files

### Multi-flavor Development

- Use `--flavor {flavor_name}` when running/building
- Each flavor has separate Firebase projects
- Environment variables defined in `dart_defines/` JSON files

### Performance Considerations

- Images are cached via `cached_network_image`
- Implement proper state management with Riverpod

## 🔧 Troubleshooting

### Common Issues

1. **Build failures**: Run `make ref` (clean + refresh)
2. **Missing translations**: Run `make ln`
3. **Generated code issues**: Run `make ccfb`
4. **iOS pod issues**: Run `make pod`
5. **Test failures**: Check golden files with `make ug`

### Clean Reset

```bash
make ref   # Full refresh (clean + sync)
```
