# TechTus Team Tools Documentation

Tài liệu này giới thiệu các công cụ được sử dụng trong dự án TechTus Mobile nhằm tăng năng suất, đảm bảo chất lượng code và duy trì tính nhất quán trong toàn bộ codebase.

## 📋 Mục lục

- [1. Linting](#1-linting)
- [2. Development Tools](#2-development-tools)
- [3. CI/CD & Workflows](#3-cicd--workflows)
- [4. Testing Framework](#4-testing-framework)
- [5. Git Hooks](#5-git-hooks)
- [6. AI & Prompt Templates](#6-ai--prompt-templates)
- [7. Makefile Commands](#7-makefile-commands)
- [8. Best Practices](#8-best-practices)

---

## 1. Linting

### 1.1. Flutter Lint

**Mục đích**: Giúp cho cả team tuân thủ, coding style và best practices của Flutter một cách nhất quán

**Cách hoạt động**:

- Nó sẽ warning hoặc error khi code không tuân thủ coding style và best practices của Flutter trong IDE
- Check trong CI để đảm bảo không có code vi phạm trước khi merge PR

**Cách sử dụng**:

```bash
# Chạy lệnh này để check các lỗi đang vi phạm trước khi push code
make analyze
```

### 1.2. Super Lint

**Mục đích**: Ngoài Flutter lint, Super Lint giúp kiểm tra về code style, conventions theo tiêu chuẩn riêng của công ty và dự án như:

```bash
# chỉ nên có 1 widget public trong file
prefer_single_widget_per_file

# tên file phải trùng với tên class
require_matching_file_and_class_name

# file code UI phải có file golden test tương ứng
missing_golden_test
...
```

<i>Xem đầy đủ rule trong file [super_lint/README.md](super_lint/README.md)</i>

**Cách hoạt động**:

- Hoạt động tương tự như Flutter Lint

**Cách sử dụng**:

```bash
# Chạy lệnh này để check các lỗi đang vi phạm trước khi push code
make sl

# Kiểm tra cả flutter lint và super lint trong cùng 1 lệnh
make lint
```

---

## 2. Development Tools

### 2.1. gen_assets.dart

**Mục đích**:

- Tự động generate asset path mà không cần chạy `build_runner`, giúp tiết kiệm thời gian.

**Cách hoạt động**:

- Gen tất cả image path vào file [app_images.dart](lib/resource/app_images.dart)
- Gen tất cả font vào file [app_fonts.dart](lib/resource/app_fonts.dart)

**Cách sử dụng**:

- Thêm asset vào folder `assets` và chạy lệnh:

```bash
make ga
```

### 2.2. gen_all_pages.dart

**Mục đích**:

- Tự động generate tất cả file cần thiết và code mẫu khi tạo mới một page mà không cần chạy `build_runner`, giúp tiết kiệm thời gian code và chạy `build_runner`.

**Cách hoạt động**:

- Tạo mới và code mẫu cho 6 file:
  - \*\_page.dart
  - \*\_view_model.dart
  - \*\_state.dart
  - \*.freezed.dart
  - \*\_spec.md
  - \*\_test.dart
- Thêm value vào enum ScreenName trong [screen_name.dart](lib/common/helper/analytics/screen_name.dart)
- Thêm route trong [app_router.dart](lib/navigation/routes/app_router.dart) và [app_router.gr.dart](lib/navigation/routes/app_router.gr.dart)
- Tự động export vào [index.dart](lib/index.dart)

**Cách sử dụng**:

- Thêm tất cả tên page cần generate vào file [input_pages.md](lib/ui/page/input_pages.md) và chạy lệnh:

```bash
make gap
```

### 2.3. export_all_files.dart

**Mục đích**:

- Tự động export tất cả files trong lib vào file `index.dart` để sau này chỉ cần import file `index.dart` là có thể sử dụng tất cả các file trong lib, giúp tiết kiệm thời gian import từng file.
- Đảm bảo mọi người không quên export file mới tạo vào `index.dart`.

**Cách hoạt động**:

- Export tất cả các file dart trong lib vào file [index.dart](lib/index.dart)
- Check trong CI để đảm bảo không quên export tất cả file trước khi merge PR

**Cách sử dụng**:

- Chạy lệnh:

```bash
make ep
```

### 2.4. check_component_usage.dart

**Mục đích**:

- Đảm bảo mọi người tuân thủ rule: "chỉ tạo component mới khi nó được sử dụng ở ít nhất 2 màn hình, nếu nó chỉ được sử dụng ở 1 màn hình thì nên tạo private widget trong màn hình đó".
- Nếu có component không được sử dụng ở bất kỳ đâu, công cụ này sẽ báo cáo để mọi người có thể xóa nó, giúp giảm bundle size.

**Cách hoạt động**:

- Báo lỗi trong CI khi có component không được sử dụng ở bất kỳ đâu hoặc chỉ được sử dụng ở 1 màn hình.

**Cách sử dụng**:

- Chạy lệnh:

```bash
make check_component_usage
```

- Biến `_excluded` trong file [check_component_usage.dart](tools/dart_tools/lib/check_component_usage.dart) có thể thêm các component đặc biệt không cần tuân thủ rule này, ví dụ như các component sẽ được sử dụng trong tương lai

### 2.5. check_page_routes.dart

**Mục đích**:

- Kiểm tra xem tất cả page đã được khai báo trong [AppRouter](lib/navigation/routes/app_router.dart) chưa nhằm tránh lỗi khi navigate đến page đó.

**Cách hoạt động**:

- Báo lỗi trong CI khi có page nào thuộc [lib/ui/page](lib/ui/page) mà chưa được khai báo trong [AppRouter](lib/navigation/routes/app_router.dart)

**Cách sử dụng**:

- Chạy lệnh:

```bash
make check_page_routes
```

### 2.6. check_pubspecs.dart

**Mục đích**:

- Đảm bảo mọi người tuân thủ rule: "Không sử dụng dấu ^ trong version của thư viện trong `pubspec.yaml` để tránh các vấn đề về lỗi code khi thư viện đó có version mới".

**Cách hoạt động**:

- Báo lỗi trong CI khi có thư viện nào sử dụng dấu ^ trong version.

**Cách sử dụng**:

```bash
make check_pubs
```

### 2.7. check_l10n_convention.dart

**Mục đích**:

- Validate localization conventions để đảm bảo consistency trong việc sử dụng l10n.

**Cách hoạt động**:

- Báo lỗi trong CI khi tên key không theo camelCase

**Cách sử dụng**:

```bash
make clc
```

### 2.8. remove_unused_pub.dart

**Mục đích**:

- Xóa unused dependencies để giảm bundle size.

**Cách hoạt động**:

- Báo lỗi trong CI khi có thư viện nào được khai báo trong `pubspec.yaml` mà không được sử dụng trong codebase

**Cách sử dụng**:

```bash
make rup
```

### 2.9. remove_unused_l10n.dart

**Mục đích**:

- Xóa unused localization keys để giảm bundle size và maintain clean l10n files.

**Cách hoạt động**:

- Báo lỗi trong CI khi có key nào trong `.arb` files mà không được sử dụng trong codebase

**Cách sử dụng**:

```bash
make rul
```

### 2.10. remove_unused_asset.dart

**Mục đích**:

- Xóa unused assets để giảm bundle size và maintain clean asset structure.

**Cách hoạt động**:

- Báo lỗi trong CI khi có asset nào trong folder `assets` mà không được sử dụng trong codebase

**Cách sử dụng**:

```bash
make rua
```

### 2.11. remove_duplicate_l10n.dart

**Mục đích**:

- Xóa duplicate localization có cùng key hoặc cùng value để tránh confusion và maintain consistency.

**Cách hoạt động**:

- Báo lỗi trong CI khi có key nào trong `.arb` files bị duplicate (cùng key hoặc cùng value)

**Cách sử dụng**:

```bash
make rdl
```

### 2.12. cleanup_empty_page_folders.dart

**Mục đích**:

- Dọn dẹp empty folders hoặc folders chỉ chứa các generated files như `*.freezed.dart` để cho project gọn gàng hơn.

**Cách hoạt động**:

- Xoá tất cả empty folders hoặc folders chỉ chứa các generated files như `*.freezed.dart`

**Cách sử dụng**:

```bash
make delete_empty_folders
```

### 2.13. sort_arb_files.dart

**Mục đích**:

- Sắp xếp `.arb` files theo alphabetical order để tránh bị duplicate khi merge 2 PR có cùng thêm 1 key-value mới ở 2 vị trí khác nhau.

**Cách hoạt động**:

- Sắp xếp keys của tất cả file `.arb` theo alphabetical order

**Cách sử dụng**:

```bash
make sort_arb
```

### 2.14. check_sorted_arb_keys.dart

**Mục đích**:

- Đảm bảo tất cả keys trong `.arb` files được sắp xếp theo alphabetical order

**Cách hoạt động**:

- Báo lỗi trong CI khi có file `.arb` nào có keys không được sắp xếp theo alphabetical order

**Cách sử dụng**:

```bash
make check_sorted_arb_keys
```

### 2.15. gen_api_from_swagger.dart

**Mục đích**:

- Generate API Integration code và model classes từ Swagger specification để tiết kiệm thời gian viết code và tránh lỗi khi viết tay.

**Cách hoạt động**:

- Generate toàn bộ API methods trong `app_api_service.dart`
- Generate toàn bộ model classes trong folder `lib/model/api`

**Cách sử dụng**:

- Đặt tệp API DOC (JSON) vào thư mục `docs/api_doc`
- Chạy `make gen_api` để gen các API method và các model classes
- Chạy `make fb` để tạo các tệp dựng cần thiết sau khi tạo API
- Các tham số tùy chọn:

```bash
# Trường hợp default: input_path=docs/api_doc, replace=false
make gen_api

# Chỉ định gen các API cụ thể. Mặc định sẽ gen tất cả API trong docs/api_doc
make gen_api apis=get_v1/users,post_v1/auth,get_v2/profile

# Nếu đặt thành `true`, sẽ thay thế tất cả mã đã tạo hiện có thay vì append vào. Mặc định là false (append mode)
make gen_api replace=true

# Chỉ định custom input path
make gen_api input_path=custom/swagger/docs

# Gen vào custom output path thay vì folder mặc định
make gen_api output_path=lib/custom/api

# Tổng hợp tất cả tham số trên
make gen_api input_path=swagger/docs replace=true apis=get_v1/search,post_v2/city
```

### 2.16. set_build_number_pubspec.dart

**Mục đích**:

- Tự động nâng build number trong `pubspec.yaml` trước khi build app trong CD, đỡ phải chỉnh tay và tạo PR để update build number.

**Cách hoạt động**:

- Tự động tăng build number thêm "1" trong `pubspec.yaml`

**Cách sử dụng**:

```bash
dart run tools/dart_tools/lib/set_build_number_pubspec.dart [build_number]
```

### 2.17. gen_env.dart

**Mục đích**:

- Gen các file config khi init project

**Cách hoạt động**:

- Generate folder dart_defines gồm 4 files:
  - develop.json
  - qa.json
  - staging.json
  - production.json
- Generate file `setting_initial_config.md` để config khi init project

**Cách sử dụng**:

```bash
make gen_env
```

### 2.18. reset_project.dart

**Mục đích**:

- Xoá toàn bộ code mẫu và example code trong project
- Reset project về trạng thái ban đầu để chuẩn bị cho việc init project mới

**Cách hoạt động**:

- Xoá toàn bộ màn hình và unit test, widget test tương ứng trừ `splash` và `main`
- Xoá toàn bộ component example và test tương ứng
- Xoá toàn bộ color trong app_colors.dart trừ màu `black`
- Xoá code mẫu trong `shared_view_model.dart` và `shared_provider.dart`
- Xoá routes example trong `app_router.dart`
- Xoá code blocks được đánh dấu trong `main_view_model.dart` và `base_test.dart`
- Xoá integration test folder

**Cách sử dụng**:

```bash
make reset
```

### 2.19. init_project.dart

**Mục đích**:

- Config project khi mới start dự án giúp tiết kiệm thời gian setup ban đầu
- Generate lại các file theo template cho 3 màn: `login`, `home`, `my_profile`

**Cách hoạt động**:

- Đọc file `setting_initial_config.md` và config project
- Generate lại các file theo template cho 3 màn: `login`, `home`, `my_profile`
- Update Android MainActivity với bundle ID từ config

**Cách sử dụng**:

- Đảm bảo đã chạy lệnh `make gen_env` trước đó để tạo file `setting_initial_config.md`
- Điền các giá trị trong file `setting_initial_config.md`
- Chạy lệnh

```bash
make init
```

### 2.20. find_duplicate_svg.dart

**Mục đích**:

- Tìm các file SVG bị duplicate (cùng nội dung nhưng khác tên) để xóa bớt, giúp giảm bundle size.

**Cách hoạt động**:

- Báo lỗi trong CI khi có file SVG nào bị duplicate (cùng nội dung nhưng khác tên)

**Cách sử dụng**:

- Chạy lệnh:

```bash
make fds
```

### 2.21. super_lint.sh

**Mục đích**:

- Kiểm tra việc tuân thủ các rule trong package super_lint trong CI

**Cách hoạt động**:

- Báo lỗi trong CI khi có rule nào bị vi phạm

**Cách sử dụng**:

- Chạy lệnh này để kiểm tra các lỗi đang vi phạm trước khi push code

```bash
make sl
```

### 2.22. check_assets_structure.dart

**Mục đích**:

- Kiểm tra cấu trúc assets tuân thủ quy tắc dự án để đảm bảo tính nhất quán và dễ maintain.

**Cách hoạt động**:

- Kiểm tra chỉ có 3 folder được phép: `images/`, `fonts/`, `raw/`
- Kiểm tra SVG files phải bắt đầu với `icon_`
- Kiểm tra Other image files phải bắt đầu với `image_`
- Kiểm tra fonts chỉ chứa file font (ttf, otf, woff, woff2)
- Kiểm tra raw/ không có subdirectory
- Báo lỗi trong CI khi có vi phạm quy tắc

**Cách sử dụng**:

```bash
make check_assets_structure
```

### 2.23. MynaviMobileTool VSCode Extension

**Mục đích**:

- Giúp generate code với các commands và snippets hữu ích.

**Cách hoạt động**:

- Tham khảo [tools/vscode/README.md](tools/vscode/README.md) để biết cách sử dụng.

**Cách sử dụng**:

- Cài đặt extension từ thư mục `tools/vscode`
- Copy settings từ [.vscode/sample/settings.json](.vscode/sample/settings.json) vào file [.vscode/settings.json](.vscode/settings.json) của VSCode
- Sử dụng các commands và snippets có sẵn trong extension để generate code

---

## 3. CI/CD & Workflows

### 3.1. GitHub Actions

**Mục đích**:

- CI và CD (dùng khi khách hàng yêu cầu)

**Cách hoạt động**:

- CI: kiểm tra mọi thứ được định nghĩa trong lệnh `make check_ci`
- CD: build và deploy app lên Firebase App Distribution cho các môi trường develop, qa, staging, production

**Cách sử dụng**:

- CI: tự động chạy khi có PR mới hoặc push code lên PR có sẵn
- CD: chọn workflow và chạy thủ công

### 3.2. Codemagic

**Mục đích**:

- CI và CD (thường được dùng hơn GitHub Actions trong các dự án labor)

**Cách hoạt động**:

- CI: kiểm tra mọi thứ được định nghĩa trong lệnh `make check_ci`
- CD: có các workflows:
  - distribution_qa:
    - build Android & iOS app cho môi trường qa, phân phối qua QR code trên Codemagic
  - distribution_store_staging:
    - tự động nâng version, build và deploy Android app lên Google Play Internal Testing của staging
    - tự động nâng version, build và deploy iOS app lên TestFlight của staging
  - distribution_store_production:
    - tự động nâng version, build và deploy Android app lên Google Play Internal Testing của production
    - tự động nâng version, build và deploy iOS app lên TestFlight của production

**Cách sử dụng**:

- CI: tự động chạy khi có PR mới hoặc push code lên PR có sẵn
- CD: chọn workflow và chạy thủ công

### 3.3. Bitbucket Pipelines

**Mục đích**:

- CI (thường dùng cho dự án fixed price)

**Cách hoạt động**:

- CI: kiểm tra mọi thứ được định nghĩa trong lệnh `make check_ci`

**Cách sử dụng**:

- Tự động chạy khi có PR mới hoặc push code lên PR có sẵn

### 3.4. Fastlane

**Mục đích**:

- CD (thường dùng cho dự án fixed price để tiết kiệm chi phí)

**Cách hoạt động**:

- Android: build & deploy Android app lên Firebase App Distribution dev, qa, staging
- iOS: build & deploy iOS app lên TestFlight dev, qa, staging

**Cách sử dụng**:

- Chạy các lệnh sau:

```bash
make cd_dev    # Deploy both develop Android & iOS
make cd_qa     # Deploy both QA Android & iOS
make cd_stg    # Deploy both staging Android & iOS

make cd_dev_android    # Deploy develop Android only
make cd_dev_ios        # Deploy develop iOS only
make cd_qa_android     # Deploy QA Android only
make cd_qa_ios         # Deploy QA iOS only
make cd_stg_android    # Deploy staging Android only
make cd_stg_ios        # Deploy staging iOS only
```

### 3.5. GitHub Workflows

#### 3.5.1. check-pr-title.yml

**Mục đích**:

- Đảm bảo PR title tuân thủ naming convention và có ticket number

**Cách hoạt động**:

- Extract ticket number từ branch name (ví dụ: feat/123_abc → 123)
- Kiểm tra PR title phải bắt đầu với ticket number hoặc [WIP]
- Format hợp lệ: "123: your feature description" hoặc "[WIP] 123: your work in progress"

**Cách sử dụng**:

- Tự động chạy khi tạo hoặc edit PR hoặc chạy thủ công

#### 3.5.2. check-assignee.yml

**Mục đích**:

- Đảm bảo mọi PR đều có assignee

**Cách hoạt động**:

- Kiểm tra PR có ít nhất 1 assignee
- Fail nếu không có assignee nào được assign

**Cách sử dụng**:

- Tự động chạy khi tạo hoặc edit PR hoặc chạy thủ công

#### 3.5.3. check-branch-name.yml

**Mục đích**:

- Đảm bảo branch name tuân thủ naming convention

**Cách hoạt động**:

- Kiểm tra branch name theo format: `(feat|fix|chore|hotfix)/[0-9]+(_[0-9]+)?` hoặc `v.\d+.\d+.\d+`
- Ví dụ hợp lệ: "feat/1234", "fix/567_890", "v.1.2.3"

**Cách sử dụng**:

- Tự động chạy khi tạo PR hoặc chạy thủ công
- Nếu lỡ tạo branch mà không tuân thủ naming convention, có thể bỏ qua lỗi này

#### 3.5.4. check-commit-message.yml

**Mục đích**:

- Đảm bảo tất cả commit messages tuân thủ Git Convention

**Cách hoạt động**:

- Validate tất cả commit messages trong PR
- Format hợp lệ: `(feat|fix|chore|refactor|package): description`
- Skip merge commits
- Ví dụ hợp lệ: "feat: add login form", "fix: resolve navigation bug"

**Cách sử dụng**:

- Tự động chạy khi tạo PR hoặc push commits mới hoặc chạy thủ công
- Nếu lỡ commit mà không tuân thủ Git Convention, có thể bỏ qua lỗi này

#### 3.5.5. check-comment-reply.yml

**Mục đích**:

- Đảm bảo tất cả review comments được reply bằng cách mention tác giả comment với commit hash dùng để fix comment đó

**Cách hoạt động**:

- Đếm số root review comments (không bao gồm PR author và bot comments)
- Đếm số replies có @mention từ non-excluded users
- Fail nếu số replies ít hơn số root comments
- Excluded users: Copilot, coderabbitai[bot], cursor[bot]

**Cách sử dụng**:

- Tự động chạy khi tạo, edit hoặc push PR
- Nó sẽ không tự động chạy lại sau khi reply nên cần phải chạy thủ công sau khi reply

---

## 4. Testing Framework

### 4.1. Unit Tests

**Mục đích**:

- Tránh bug do impact/refactor code

**Cách hoạt động**:

- Viết test cho các hàm data validation để đảm bảo hàm hoạt động đúng với các input khác nhau mà manual test không cover hết được. VD: validate email, validate password, validate phone number,...
- Viết test cho các hàm common sài ở nhiều màn hình để đảm bảo fix bug ở màn này không gây bug cho màn khác. VD: SharedViewModel, SharedProvider
- Viết test cho các hàm có logic phức tạp, nhiều case vì nó rất dễ bug khi thay đổi code sau này: Nested if-else, loop, nhiều operator. VD các hàm private dài trong các ViewModel

**Cách sử dụng**:

```bash
# Chạy unit tests
make ut

# Chạy unit tests cụ thể
flutter test [test_path]
```

### 4.2. Golden Tests

**Mục đích**:

- Đảm bảo không có bug UI và dễ dàng check impact khi thay đổi code UI.

**Cách hoạt động**:

- Gen golden images theo nhiều kịch bản UI khác nhau
- So sánh golden images với thiết kế trong Figma một cách thủ công
- Nếu mình không thay đổi UI màn hình nào đó nhưng golden image của nó bị thay đổi, chỗ đó có thể là bug do impact, cần check lại.

**Cách sử dụng**:

```bash
# Chạy toàn bộ golden tests
make wt

# Gen lại tất cả golden images
make ug

# Gen lại golden tests cụ thể
flutter test [test_path] --update-goldens --tags=golden

# Chạy lại golden tests cụ thể
flutter test [test_path] --tags=golden
```

### 4.3. Integration Tests

**Mục đích**:

- Đảm bảo các flows chính và quan trọng trong app hoạt động đúng.

**Cách hoạt động**:

- Simulate lại các flows chính tren máy thật hoặc simulator/emulator
- Verify UI interactions và navigation
- Screenshot các bước quan trọng để so sánh với expected design/spec

**Cách sử dụng**:

```bash
# Chạy integration tests
flutter test integration_test/
```

### 4.4. Test Coverage

**Mục đích**:

- Gen code coverage để report cho dự án

**Cách hoạt động**:

- Generate Unit test coverage
- Generate Widget test coverage
- Generate Test coverage bao gồm cả unit tests và widget tests

**Cách sử dụng**:

```bash
# Generate coverage report
make cov

# Unit test coverage only
make cov_ut

# Widget test coverage only
make cov_wt
```

---

## 5. Git Hooks

### 5.1. Commit Message Validation

**Mục đích**:

- Validate commit message format để đảm bảo mọi người tuân thủ Git Convention

**Cách hoạt động**:

- Reject commit nếu message không đúng format quy định tại file [.lefthook/commit-msg/commit-msg.sh](.lefthook/commit-msg/commit-msg.sh)

**Cách sử dụng**:

- Install lefthook theo hướng dẫn trong file [README.md](README.md)
- Tự động chạy khi commit

### 5.2. Branch Name Validation

**Mục đích**:

- Validate branch name format để đảm bảo mọi người tuân thủ Git Convention

**Cách hoạt động**:

- Reject commit nếu branch name không đúng format quy định tại file [.lefthook/pre-commit/pre-commit.sh](.lefthook/pre-commit/pre-commit.sh)

**Cách sử dụng**:

- Install lefthook theo hướng dẫn trong file [README.md](README.md)
- Tự động chạy khi commit

---

## 6. AI & Prompt Templates

### 6.1. Golden Test Generation Template

**Mục đích**:

- Tự động tạo complete golden test files với design và edge cases

**Cách hoạt động**:

- Tạo "design" group với test cases matching design images
- Tạo "others" group với edge cases và abnormal cases
- Generate golden test, golden images và verify tests pass

**Cách sử dụng**:

- Copy toàn bộ nội dung trong file [.prompt_templates/golden_test/generate_golden_tests_prompt.md](.prompt_templates/golden_test/generate_golden_tests_prompt.md)
- Update `[YOUR_PAGE_FILE_PATH]` với đường dẫn đến file dart của page cần tạo golden test
- Đính kèm hình ảnh design vào prompt để gia tăng độ chính xác

### 6.2. Figma to UI Code Template

**Mục đích**:

- Generate Flutter code dựa trên Figma designs và spec được định nghĩa trong file \*\_spec.md để tăng tốc development

**Cách hoạt động**:

- Generate code UI theo design và screen spec
- Code logic cho ViewModel và State theo screen spec
- Tạo golden tests và generate golden images

**Cách sử dụng**:

- Copy toàn bộ nội dung trong file [.prompt_templates/ui/generate_page_prompt.md](.prompt_templates/ui/generate_page_prompt.md)
- Update `[YOUR_FIGMA_LINK]` với link Figma
- Update `[SNAKE_CASE_SCREEN_NAME]` với tên màn hình theo định dạng snake_case
- Đính kèm hình ảnh design vào prompt để gia tăng độ chính xác

### 6.3. Color Extraction Template

**Mục đích**:

- Extract toàn bộ colors từ Figma và update AppColors class

**Cách hoạt động**:

- Gen toàn bộ colors trong Figma vào file [app_colors.dart](lib/resource/app_colors.dart)

**Cách sử dụng**:

- Copy toàn bộ nội dung trong file [.prompt_templates/ui/generate_app_colors_prompt.md](.prompt_templates/ui/generate_app_colors_prompt.md)
- Update `[YOUR_FIGMA_LINK]` với link Figma

### 6.3. AI Code Review

**Mục đích**:

- Tự động review code để tìm bugs, code smells và suggest improvements

**Cách hoạt động**:

- Các bot AI sẽ review code và comment trực tiếp trong PR

**Cách sử dụng**:

- Chọn các bot sau trong phần Reviewers khi tạo PR:
  - coderabbitai[bot]
  - cursor[bot]
  - Copilot

---

## 7. Makefile Commands

### 7.1. Phổ biến nhất

```bash
make pg      # flutter pub get toàn bộ packages
make ln      # gen localization (l10n)
make fb      # run build_runner
make ccfb    # clear build_runner cache và run build_runner
make sync    # chạy tuần tự 3 lệnh make pg, make ln, make ccfb
```

### 7.2. Để fix lỗi build issues

```bash
make cl          # flutter clean && rm -rf pubspec.lock
make ref         # full refresh: clean + delete empty folders + sync + upgrade + pod
make pod         # pod install lại
make pu          # flutter pub upgrade
make dart_fix    # dart fix --apply
make ci          # fix tất cả lỗi CI
```

### 7.3. Để check CI dưới local trước khi push

```bash
make check_ci    # check xem đã pass CI chưa trước khi push
make fm          # format code + sort .arb files
make ug          # gen lại tất cả golden images
make lint        # chạy super lint + analyze để kiểm tra trước khi push
make sl          # chạy super lint only để kiểm tra trước khi push
make te          # chạy tất cả tests (unit + widget)
```

### 7.4. Build Commands

```bash
# APK builds
make build_dev_apk    # build develop APK
make build_qa_apk     # build QA APK
make build_stg_apk    # build staging APK
make build_prod_apk   # build production APK

# AAB builds (Android App Bundle)
make build_dev_aab    # build develop AAB
make build_qa_aab     # build QA AAB
make build_stg_aab    # build staging AAB
make build_prod_aab   # build production AAB

# IPA builds (iOS)
make build_dev_ipa    # build develop IPA
make build_qa_ipa     # build QA IPA
make build_stg_ipa    # build staging IPA
make build_prod_ipa   # build production IPA
```

### 7.5. Continuous Deployment (CD)

```bash
# Deploy both Android & iOS
make cd_dev      # deploy develop
make cd_qa       # deploy QA
make cd_stg      # deploy staging

# Deploy Android only
make cd_dev_android    # deploy develop Android
make cd_qa_android     # deploy QA Android
make cd_stg_android    # deploy staging Android

# Deploy iOS only
make cd_dev_ios        # deploy develop iOS
make cd_qa_ios         # deploy QA iOS
make cd_stg_ios        # deploy staging iOS
```

### 7.6. App Icon & Splash

- Tự động tạo complete golden test files với design và edge cases

**Cách hoạt động**:

- Tạo "design" group với test cases matching design images
- Tạo "others" group với edge cases và abnormal cases
- Generate golden test, golden images và verify tests pass

**Cách sử dụng**:

- Copy toàn bộ nội dung trong file [.prompt_templates/golden_test/generate_golden_tests_prompt.md](.prompt_templates/golden_test/generate_golden_tests_prompt.md)
- Update `[YOUR_PAGE_FILE_PATH]` với đường dẫn đến file dart của page cần tạo golden test
- Đính kèm hình ảnh design vào prompt để gia tăng độ chính xác

### 6.2. Figma to UI Code Template

**Mục đích**:

- Generate Flutter code dựa trên Figma designs và spec được định nghĩa trong file \*\_spec.md để tăng tốc development

**Cách hoạt động**:

- Generate code UI theo design và screen spec
- Code logic cho ViewModel và State theo screen spec
- Tạo golden tests và generate golden images

**Cách sử dụng**:

- Copy toàn bộ nội dung trong file [.prompt_templates/ui/generate_page_prompt.md](.prompt_templates/ui/generate_page_prompt.md)
- Update `[YOUR_FIGMA_LINK]` với link Figma
- Update `[SNAKE_CASE_SCREEN_NAME]` với tên màn hình theo định dạng snake_case
- Đính kèm hình ảnh design vào prompt để gia tăng độ chính xác

### 6.3. Color Extraction Template

**Mục đích**:

- Extract toàn bộ colors từ Figma và update AppColors class

**Cách hoạt động**:

- Gen toàn bộ colors trong Figma vào file [app_colors.dart](lib/resource/app_colors.dart)

**Cách sử dụng**:

- Copy toàn bộ nội dung trong file [.prompt_templates/ui/generate_app_colors_prompt.md](.prompt_templates/ui/generate_app_colors_prompt.md)
- Update `[YOUR_FIGMA_LINK]` với link Figma

### 6.3. AI Code Review

**Mục đích**:

- Tự động review code để tìm bugs, code smells và suggest improvements

**Cách hoạt động**:

- Các bot AI sẽ review code và comment trực tiếp trong PR

**Cách sử dụng**:

- Chọn các bot sau trong phần Reviewers khi tạo PR:
  - coderabbitai[bot]
  - cursor[bot]
  - Copilot

---

## 7. Makefile Commands

### 7.1. Phổ biến nhất

```bash
make pg      # flutter pub get toàn bộ packages
make ln      # gen localization (l10n)
make fb      # run build_runner
make ccfb    # clear build_runner cache và run build_runner
make sync    # chạy tuần tự 3 lệnh make pg, make ln, make ccfb
```

### 7.2. Để fix lỗi build issues

```bash
make cl          # flutter clean && rm -rf pubspec.lock
make ref         # full refresh: clean + delete empty folders + sync + upgrade + pod
make pod         # pod install lại
make pu          # flutter pub upgrade
make dart_fix    # dart fix --apply
make ci          # fix tất cả lỗi CI
```

### 7.3. Để check CI dưới local trước khi push

```bash
make check_ci    # check xem đã pass CI chưa trước khi push
make fm          # format code + sort .arb files
make ug          # gen lại tất cả golden images
make lint        # chạy super lint + analyze để kiểm tra trước khi push
make sl          # chạy super lint only để kiểm tra trước khi push
make te          # chạy tất cả tests (unit + widget)
```

### 7.4. Build Commands

```bash
# APK builds
make build_dev_apk    # build develop APK
make build_qa_apk     # build QA APK
make build_stg_apk    # build staging APK
make build_prod_apk   # build production APK

# AAB builds (Android App Bundle)
make build_dev_aab    # build develop AAB
make build_qa_aab     # build QA AAB
make build_stg_aab    # build staging AAB
make build_prod_aab   # build production AAB

# IPA builds (iOS)
make build_dev_ipa    # build develop IPA
make build_qa_ipa     # build QA IPA
make build_stg_ipa    # build staging IPA
make build_prod_ipa   # build production IPA
```

### 7.5. Continuous Deployment (CD)

```bash
# Deploy both Android & iOS
make cd_dev      # deploy develop
make cd_qa       # deploy QA
make cd_stg      # deploy staging

# Deploy Android only
make cd_dev_android    # deploy develop Android
make cd_qa_android     # deploy QA Android
make cd_stg_android    # deploy staging Android

# Deploy iOS only
make cd_dev_ios        # deploy develop iOS
make cd_qa_ios         # deploy QA iOS
make cd_stg_ios        # deploy staging iOS
```

### 7.6. App Icon & Splash

```bash
make gen_ai      # generate app icon từ app_icon/app-icon.yaml
make gen_spl     # generate splash screen từ splash/splash.yaml
make rm_spl      # remove splash screen
```

---

## 8. Best Practices

1. **Luôn chạy `make ci` trước khi tạo PR**
2. **Chạy `make sync` sau khi pull code mới hoặc checkout branch khác**
3. **Sử dụng `make ref` để reset lại dự án khi gặp build issues**

---
