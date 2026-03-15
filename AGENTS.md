# Essential Commands
```bash
# Get packages for all modules
make pg

# Run build_runner for code generation
make fb

# Run golden tests
flutter test [test_path] --tags=golden

# Update golden test files
flutter test [test_path] --update-goldens --tags=golden

# Format code
make fm

## Check lint
make sl

## Generate assets (images, fonts, etc.)
make ga

## Generate localization files
make ln
```

# Common Development Rules

## 📖 Complete Documentation References
- **Naming Conventions**: [docs/technical/naming_convention.md](../docs/technical/naming_convention.md)
- **UI Guidelines**: [docs/technical/ui_and_state_management_instructions.md](../docs/technical/ui_and_state_management_instructions.md)
- **Golden Test**: [docs/technical/golden_test_instructions.md](../docs/technical/golden_test_instructions.md)
- **API Integration**: [docs/technical/api_integration_instructions.md](../docs/technical/api_integration_instructions.md)
- **Custom Lint**: [docs/technical/custom_lint_instructions.md](../docs/technical/custom_lint_instructions.md)

## Coding Standards
- Line length: 100 characters (according to .vscode/settings.json)
- No compile errors
- No linter errors
- Follow consistent code formatting
- Follow rules in analysis_options.yaml
- Follow rules in super_lint/README.md
- Follow naming conventions in docs/technical/naming_convention.md
- When implementing UI, follow instructions in docs/technical/ui_and_state_management_instructions.md
- When writing golden tests, follow instructions in docs/technical/golden_test_instructions.md
- When writing API integration code, follow instructions in docs/technical/api_integration_instructions.md
- When creating new custom lint rules, follow instructions in docs/technical/custom_lint_instructions.md

## Import and Export Rules
- Always use relative imports within the same module
- Use `import '../../../index.dart';` for cross-module imports
- All public APIs/files must be exported through index.dart

## Security Guidelines
- Never hardcode secrets or API keys
- Use encryption for sensitive data storage
- Follow OWASP guidelines for mobile security
