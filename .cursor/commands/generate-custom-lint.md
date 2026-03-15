# Generate Custom Lint Rule

## Purpose
Create a custom lint rule in the super_lint package  following all instruction files mentioned in the Context section.

## Parameters:
- `rule_name`: The name of the lint rule if provided

## Context:
- Custom lint implementation instructions: @docs/technical/custom_lint_instructions.md

## Steps:

1. **Research existing rules**: Search similar rules in `super_lint/lib/src/lints/` and study their patterns

2. **Create rule file**: Implement the lint rule class in `super_lint/lib/src/lints/{{rule_name}}.dart`

3. **Export rule**: Add export to `super_lint/lib/src/index.dart`

4. **Register rule**: Add rule to `super_lint/lib/super_lint.dart`

5. **Create tests**: Write test cases in folder `super_lint/example/lib/{{rule_name}}_test/` with both valid and invalid examples

6. **Validate**: Add to `analysis_options.yaml` and `super_lint/example/analysis_options.yaml` then run `cd super_lint/example && dart run custom_lint` to verify lint works in the example project

7. **Document**: Update `super_lint/README.md` and `docs/technical/super_lint_rules.md`

## Notes:

- Import only from `index.dart`
- Never use deprecated APIs
- Include both valid (should NOT warn) and invalid (should warn) test cases
- Verify with: `cd super_lint/example && dart run custom_lint`
