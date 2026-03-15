# Generate Golden Tests

## Purpose
Create or regenerate golden test files for code files or entire folders (Page, Component, Popup) following all instruction files mentioned in the Context section.

## Context:
- Golden test instructions: @docs/technical/golden_test_instructions.md

## Parameters:
- `target`: Can be:
  - A single file path: `lib/ui/page/login/login_page.dart`
  - Multiple file paths (comma-separated): `lib/ui/page/login/login_page.dart, lib/ui/page/register/register_page.dart`
  - A folder path: `lib/ui/popup/`
  - Multiple folders: `lib/ui/popup/, lib/ui/component/`

## Steps:

1. Determine target files:
   - If {{target}} is a folder → Find all `.dart` files in that folder (non-recursive)
   - If {{target}} contains multiple paths (comma-separated) → Process each path
   - If {{target}} is a file → Process that single file

2. For each file found, analyze the source code to understand:
   - All widget constructors (default, factory, or named)
   - Dependencies, props, and state structure
   - Number of constructors (for multiple constructor groups)

3. Determine test file path by mirroring the `lib` structure:
   - Code file: `lib/ui/page/account_information/account_information_page.dart`
   - Test file: `test/widget_test/ui/page/account_information/account_information_page_test.dart`

4. Check if test file already exists:
   - If exists: Read the existing test file
   - Check for compile errors by running: `flutter test <test_path> --update-goldens --tags=golden --no-pub`
   - Check for rule violations:
     - Missing 3-level group structure (Constructor → Happy/Unhappy → Test cases)
     - Level 1 group names not matching constructor names
     - Missing `happy` or `unhappy` sub-groups
     - Incorrect filename patterns
     - Not using common test utilities from `test/common/index.dart`
   - If too many compile errors OR multiple rule violations detected → Regenerate from scratch
   - Otherwise → Only update/fix specific issues

5. Generate test file following 3-level structure:

   **Level 1: Constructor Groups**
   - For default constructor: Use class name (e.g., `'SplashPage'`)
   - For factory constructor: Use factory name (e.g., `'passwordResetCompleted'` for `ConfirmDialog.passwordResetCompleted()`)
   - For named constructor: Use constructor name (e.g., `'withData'` for `MyWidget.withData()`)
   - Create one group for EACH constructor

   **Level 2: Happy/Unhappy Sub-groups (inside each constructor group)**
   
   **"happy" group** - Normal/expected use cases:
   - Test case description should clearly describe the state being tested
   - filename must be `[constructor name]/[test case description]`
   - Use realistic mock data that represents typical user scenarios
   - If the UI has a Network Image, pass `hasNetworkImage: true` and pass the `testImageUrl` variable to all dummy image urls
   - If the dummy data has a local image path, pass "" or null
   - If need interaction testing, use `onCreate: (tester, key) async { ... }` with 2 parameters

   **"unhappy" group** - Edge cases and abnormal cases:
   - Combine multiple similar cases into single test when possible. Ex:
      - Test case: "long text + max value" -> all fields with long text, not just one field
      - Test case: "empty + min value" -> all fields with empty state and min value
      - Error cases if any. Don't mock `appException` in `CommonState`
   - Don't cover loading states cases. Only use `data` property in `CommonState`

6. Template structure:
   ```dart
   import 'package:flutter_test/flutter_test.dart';
   import 'package:golden_toolkit/golden_toolkit.dart';
   import 'package:hooks_riverpod/hooks_riverpod.dart';
   import 'package:mocktail/mocktail.dart';
   import 'package:[app]/index.dart';
   
   import '../../../../common/index.dart'; // Adjust path as needed
   
   void main() {
     group('[ConstructorName]', () {
       group('happy', () {
         testGoldens('test case description', (tester) async {
           await tester.testWidget(
             filename: '[constructor name]/[test case]',
             widget: const MyWidget(),
             overrides: [...],
           );
         });
       });
       
       group('unhappy', () {
         testGoldens('test case description', (tester) async {
           await tester.testWidget(
             filename: '[constructor name]/[test case]',
             widget: const MyWidget(),
             overrides: [...],
           );
         });
       });
     });
   }
   ```

7. Generate golden images and verify all tests pass:
   ```bash
   flutter test <test_path> --update-goldens --tags=golden
   ```

8. Verify that the component/popup renders correctly with proper styling and no UI issues (overflow, clipping, etc.).

9. If tests fail:
   - Fix the test cases (if test logic is wrong)
   - OR fix the source code (if code doesn't match design)

10. Repeat steps 2-9 for all files in the target list

11. After all files are processed, provide a summary:
    - Total files processed
    - Tests created (new files)
    - Tests regenerated (existing files rewritten)
    - Tests updated (existing files fixed)

## Critical Rules to Follow:

**MUST DO:**
- Follow 3-level group structure: Constructor → Happy/Unhappy → Test cases
- Level 1 group name = constructor name (exact match)
- Every constructor group has `happy` and `unhappy` sub-groups
- Use correct filename pattern: `[constructor name]/[test case]`
- Reuse utilities from `test/common/index.dart`
- Use realistic mock data with Japanese text
- Set `hasNetworkImage: true` when UI contains network images

**MUST NOT:**
- Create duplicate mock classes or utilities
- Skip happy or unhappy groups
- Use incorrect group names
- Test loading states (only use `data` property in `CommonState`)

## Remember:

- Can process single file, multiple files, or entire folders
- If file already exists with many errors or rule violations → Regenerate from scratch
- Strictly follow all patterns in @docs/technical/golden_test_instructions.md
- Provide summary after processing all files
- No lint checks afterwards
- Always start with fresh context—avoid reusing cached code or test files from previous sessions

