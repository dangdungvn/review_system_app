# Generate Unit Tests

## Purpose
Create or regenerate unit test files for code files or entire folders (ViewModel, Util, Provider, etc.) following all instruction files mentioned in the Context section.

## Context:
- Common testing instructions: @docs/technical/common_testing_instructions.md
- Unit test instructions: @docs/technical/unit_test_instructions.md

## Parameters:
- `target`: Can be:
  - A single file path: `lib/ui/page/login/view_model/login_view_model.dart`
  - Multiple file paths (comma-separated): `lib/common/util/app_util.dart, lib/common/util/date_util.dart`
  - A folder path: `lib/ui/page/login/view_model/`
  - Multiple folders: `lib/common/util/, lib/ui/shared/`

## Steps:

1. Determine target files:
   - If {{target}} is a folder → Find all `.dart` files in that folder (non-recursive)
   - If {{target}} contains multiple paths (comma-separated) → Process each path
   - If {{target}} is a file → Process that single file
   - Skip files that are in the exclusion list (see step 2)

2. For each file found, check if it needs unit tests:
   - Skip files in exclusion list from @docs/technical/unit_test_instructions.md:
     - `*_client.dart`, `*_service.dart` in api folder
     - `lib/data_source/firebase/`
     - `lib/ui/component/`, `lib/ui/popup/`, `lib/ui/page/*_page.dart`
     - `lib/ui/base/`, `lib/navigation/`, `lib/resource/`
     - `lib/main.dart`, `lib/di.dart`, etc.
   - If file is excluded → Skip to next file
   - If file needs tests → Continue to step 3

3. For each target file, analyze the source code to understand:
   - All public functions that need testing
   - Private functions with @visibleForTesting
   - Dependencies and mocking requirements
   - If a `*_spec.md` file exists, read it carefully - tests MUST follow the spec

4. Determine test file path by mirroring the `lib` structure:
   - Code file: `lib/ui/page/login/view_model/login_view_model.dart`
   - Test file: `test/unit_test/ui/page/login/view_model/login_view_model_test.dart`

5. Check if test file already exists:
   - If exists: Read the existing test file
   - Check for compile errors by running: `flutter test <test_path> --no-pub`
   - Check for rule violations:
     - Missing happy/unhappy groups
     - Group names not matching function names
     - Not using common test utilities
     - Missing tests for functions
   - If too many compile errors OR multiple rule violations detected → Regenerate from scratch
   - Otherwise → Only update/fix specific issues

6. Generate test file following mandatory structure:
   ```dart
   import 'package:flutter_test/flutter_test.dart';
   import 'package:mocktail/mocktail.dart';
   import 'package:nalsflutter/index.dart';
   
   import '../../../common/index.dart'; // Adjust path as needed
   
   void main() {
     late MyViewModel viewModel; // or class under test
     
     setUp(() {
       viewModel = MyViewModel(ref); // Initialize with mocks from base_test.dart
     });
     
     group('functionName', () {
       group('happy', () {
         test('when <describe scenario>', () {
           // Test happy case
         });
       });
       
       group('unhappy', () {
         test('when <describe error scenario>', () {
           // Test unhappy case
         });
       });
     });
   }
   ```

7. For EACH function in the source file:
   - Create group with name matching function name exactly
   - Add 2 subgroups: `happy` and `unhappy`
   - Write comprehensive test cases:
     - **Happy cases**: Normal scenarios with valid data
     - **Unhappy cases**: Edge cases, validation failures, exceptions
   - If function is void: Use `verify()` to check calls
   - If function is async: Use `async`/`await` properly
   - Use descriptive dummy data names (e.g., `dummyEmail`, `dummyUser`)

8. Ensure all mocks come from `test/common/base_test.dart`:
   - Reuse existing mocks: `ref`, `navigator`, `appApiService`, `appPreferences`, etc.
   - Do NOT create duplicate mock classes
   - Use `when()` to stub behaviors
   - Use `verify()` to check calls

9. If the code is hard to test (cannot mock dependencies):
   - **DO NOT** skip tests immediately
   - **DO** check if code needs refactoring for testability:
     - Hard-coded classes → Use dependency injection
     - Static methods → Wrap in injectable class
     - Global singletons → Inject via ref
   - **ONLY** skip tests if truly impossible to test (e.g., platform code)

10. Run tests to verify they pass:
    ```bash
    flutter test test/unit_test/path/to/test_file_test.dart
    ```

11. If tests fail:
   - Fix the test cases (if test logic is wrong)
   - OR fix the source code (if code doesn't match spec)
   - If `*_spec.md` exists: Code MUST be updated to match spec, NOT the other way around

12. Repeat steps 3-11 for all files in the target list

13. After all files are processed, provide a summary:
    - Total files processed
    - Tests created (new files)
    - Tests regenerated (existing files rewritten)
    - Tests updated (existing files fixed)
    - Files skipped (excluded or no tests needed)

## Critical Rules to Follow:

**MUST DO:**
- Group name = function name (exact match)
  - Regular functions: `group('functionName', ...)`
  - Extension methods: `group('ExtensionName.methodName', ...)` (e.g., `ObjectExt.let`, `DateTime.toStringWithFormat`)
- Every function group has `happy` and `unhappy` subgroups
- Reuse mocks from `test/common/base_test.dart`
- Import `test/common/index.dart`
- Use descriptive dummy data names
- Test edge cases thoroughly
- Follow spec if `*_spec.md` exists

**MUST NOT:**
- Use `state_notifier_test` package
- Create duplicate mock classes
- Write tests to make code pass (if spec exists)
- Skip tests without trying to refactor code first
- Miss tests for any public function

## Remember:

- Can process single file, multiple files, or entire folders
- Automatically skip excluded files (components, pages, services, etc.)
- If file already exists with many errors or rule violations → Regenerate from scratch
- Always check for `*_spec.md` file - if exists, tests MUST follow spec
- If code is hard to test, refactor the code first before considering skipping tests
- Strictly follow all patterns in @docs/technical/unit_test_instructions.md
- Provide summary after processing all files

