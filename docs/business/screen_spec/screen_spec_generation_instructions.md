# Screen Specification Generation Instructions

## Overview

This document provides technical instructions for generating structured screen specification documents from messy Markdown files (typically copied from Google Sheets).

**Goal**: Transform unstructured input into well-organized documentation following `SCREEN_DETAIL_TEMPLATE.md` while preserving all original text exactly.

---

## Table of Contents

1. [Input Format](#input-format)
2. [Output Format](#output-format)
3. [Processing Algorithm](#processing-algorithm)
4. [Formatting Rules](#formatting-rules)
5. [Validation](#validation)
6. [Examples](#examples)
7. [Troubleshooting](#troubleshooting)

---

## Input Format

### Expected Input Structure

The input file typically contains two main sections:

1. **処理概要 / Screen Overview**
   - Japanese description (labeled `JP:`)
   - English description (labeled `EN:`)
   - Separated by blank lines or `=====`

2. **Item Definition / 項目定義**
   - Table with columns:
     - Item No. (番号)
     - 項目名 (Item name) - JP
     - 項目名 (Item name) - EN
     - 項目種別 (Item type)
     - バリデーション (Validation)
     - 必須 (Required): 〇, △, -
     - データ型 (Data type)
     - 桁数 (No. of digits)
     - フォーマット (Format)
     - 初期値 (Initial value)
     - 説明 (Description) - JP
     - 説明 (Description) - EN

3. **Action and Screen Transition / アクション及び画面遷移**
   - Table with columns:
     - ID (Action ID)
     - Item No.
     - トリガー (Trigger) - JP
     - トリガー (Trigger) - EN
     - 画面遷移 (Screen Transition)
     - アクション概要 (Action) - JP
     - アクション概要 (Action) - EN
     - 備考 (Remarks)

### Input Characteristics

- **Messy formatting**: Tables may have inconsistent spacing, line breaks
- **Merged cells**: Some cells span multiple rows/columns
- **Mixed languages**: Japanese and English intermixed
- **Various separators**: Uses `=====`, blank lines, or both
- **Inconsistent capitalization**: Different styles in different sections
- **Full-width characters**: Japanese text uses full-width punctuation （）、。

---

## Output Format

### Required Structure

Follow `SCREEN_DETAIL_TEMPLATE.md` exactly:

```markdown
> **Mã màn hình:** `[code]`
> **Tên màn hình:** `[name]`
> **Mô tả:** [description]
> **Ngày tạo:** YYYY-MM-DD
> **Ngày cập nhật cuối:** YYYY-MM-DD
> **Phiên bản:** 1.0

---

## Mục Lục
[Table of contents with links]

---

## 1. Tổng Quan
### 1.1 Mục Đích
### 1.2 Đối Tượng Sử Dụng

## 2. Giao Diện
### 2.1 Các Thành Phần Chính
### 2.1.1 Hình minh họa giao diện
### 2.1.2 Các Thành Phần Chi Tiết

## 3. Chức Năng
### 3.1 Các Thao Tác Chính
### 3.2 Các Trường Hợp Đặc Biệt

## 4. Luồng Tương Tác
### 4.1 Các Bước Thao Tác
### 4.2 Các Màn Hình Liên Quan

## 5. Quy Tắc Nghiệp Vụ
### 5.1 Các Quy Tắc Chung
### 5.2 Các Ràng Buộc

## 6. Logic Nghiệp Vụ
### 6.1 Xử lý Dữ Liệu Đặc Biệt
### 6.2 Quy Tắc Hiển Thị Dữ Liệu

## 7. Responsive Design

## 8. Ràng Buộc & Quy Tắc Nghiệp Vụ

## 9. Tài Liệu Liên Quan

## 10. Validation Procedures Detail
### HCK Error Codes:
### Field-level Validation:
```

---

## Processing Algorithm

### Step 1: Parse Input File

```python
def parse_input(file_content):
    sections = {
        'overview': extract_overview(file_content),
        'items': extract_item_definition_table(file_content),
        'actions': extract_action_table(file_content)
    }
    return sections
```

**Extract Overview**:
- Find section starting with "処理概要/Screen Overview"
- Split by "JP:" and "EN:" markers
- Extract text until next major section
- Preserve all line breaks and formatting

**Extract Item Definition Table**:
- Find section starting with "Item Definition/項目定義"
- Identify table headers
- Parse each row maintaining column alignment
- Handle merged cells by repeating value
- Preserve exact text in each cell

**Extract Action Table**:
- Find section starting with "Action and Screen Transition"
- Parse table structure
- Link actions to items via Item No.
- Preserve exact text including separators

### Step 2: Extract Metadata

```python
def extract_metadata(sections):
    return {
        'screen_code': infer_screen_code(sections['overview']),
        'screen_name': extract_screen_name(sections['overview']),
        'description': extract_first_line(sections['overview']['en']),
        'created_date': get_today_date(),
        'updated_date': get_today_date(),
        'version': '1.0'
    }
```

### Step 3: Map Data to Template

```python
def map_to_template(sections, metadata):
    output = {
        'header': generate_header(metadata),
        'toc': generate_table_of_contents(),
        'overview': generate_overview(sections['overview']),
        'interface': generate_interface_section(sections['items']),
        'functions': generate_functions_section(sections['actions']),
        'interaction': generate_interaction_flow(sections['actions']),
        'business_rules': extract_business_rules(sections['items'], sections['actions']),
        'logic': extract_business_logic(sections['items'], sections['actions']),
        'responsive': generate_responsive_section(sections['items']),
        'constraints': extract_constraints(sections['items']),
        'related_docs': generate_related_docs(metadata),
        'validation': extract_validation_rules(sections['items'])
    }
    return output
```

### Step 4: Generate Interface Section

```python
def generate_interface_section(items):
    # Group items by logical sections (Main, Popup, etc.)
    grouped = group_items_by_section(items)
    
    tables = []
    for section_name, section_items in grouped.items():
        table = f"#### Section {i} – {section_name}:\n\n"
        table += "| STT | Tên thành phần | Loại | Bắt buộc | Kiểu dữ liệu | Ký tự | Định dạng | Mặc định | Mô tả |\n"
        table += "| --- | -------------- | ---- | -------- | ------------ | ----- | --------- | -------- | ----- |\n"
        
        for item in section_items:
            # Preserve exact text from original
            row = format_table_row(item, preserve_exact_text=True)
            table += row + "\n"
        
        tables.append(table)
    
    return "\n".join(tables)
```

### Step 5: Generate Functions Section

```python
def generate_functions_section(actions):
    main_actions = []
    special_cases = []
    
    for action in actions:
        if is_special_case(action):
            special_cases.append(action)
        else:
            main_actions.append(action)
    
    # Generate main actions table
    main_table = generate_actions_table(main_actions)
    
    # Generate special cases table
    special_table = generate_special_cases_table(special_cases)
    
    return {
        'main_actions': main_table,
        'special_cases': special_table
    }
```

### Step 6: Extract Business Rules

```python
def extract_business_rules(items, actions):
    rules = []
    constraints = []
    
    # From item descriptions
    for item in items:
        if 'required' in item and item['required'] == '〇':
            rules.append(f"{item['name_en']} is required")
        
        if 'validation' in item['description']:
            constraints.append(extract_validation_rule(item['description']))
    
    # From action descriptions
    for action in actions:
        if 'condition' in action['description']:
            rules.append(extract_condition(action['description']))
    
    return {
        'general_rules': rules,
        'constraints': constraints
    }
```

### Step 7: Extract Validation Rules

```python
def extract_validation_rules(items):
    error_codes = set()
    field_validations = {}
    
    for item in items:
        # Find all HCK-XXX error codes in description
        codes = re.findall(r'HCK-\d{3}', item['description'])
        error_codes.update(codes)
        
        # Build validation rules for this field
        validations = []
        if item['required'] == '〇':
            validations.append('Required')
        if item['digits']:
            validations.append(f"max {item['digits']} characters")
        if item['format']:
            validations.append(item['format'])
        
        field_validations[item['name_en']] = ', '.join(validations)
    
    return {
        'error_codes': sorted(error_codes),
        'field_rules': field_validations
    }
```

### Step 8: Generate Output

```python
def generate_output(mapped_data):
    output = []
    
    # Header
    output.append(generate_header_block(mapped_data['header']))
    output.append("---\n")
    
    # Table of Contents
    output.append(mapped_data['toc'])
    output.append("---\n")
    
    # All sections
    for section_name, section_content in mapped_data.items():
        if section_name not in ['header', 'toc']:
            output.append(format_section(section_name, section_content))
    
    return '\n'.join(output)
```

---

## Formatting Rules

### Critical Rules (MUST FOLLOW)

1. **Text Preservation**
   ```python
   # CORRECT
   original = "When user click ""Login"""
   output = original  # Exact copy
   
   # WRONG
   original = "When user click ""Login"""
   output = "When the user clicks ""Login"""  # Modified grammar [WRONG]
   ```

2. **Capitalization**
   ```python
   # CORRECT
   preserve_case("TOP Screen") → "TOP Screen"
   
   # WRONG
   normalize_case("TOP Screen") → "Top Screen" [WRONG]
   ```

3. **Punctuation**
   ```python
   # CORRECT
   original = "Navigate to UTO_01 - TOP Screen"
   output = original  # No period added
   
   # WRONG
   original = "Navigate to UTO_01 - TOP Screen"
   output = original + "."  # Added period [WRONG]
   ```

4. **Japanese Characters**
   ```python
   # CORRECT
   preserve("認証コード確認（OTP confirm）")
   
   # WRONG
   convert("認証コード確認（OTP confirm）") → "認証コード確認(OTP confirm)" [WRONG]
   # Changed full-width （） to half-width ()
   ```

5. **Error Codes**
   ```python
   # CORRECT
   preserve("the error message HCK-001 is displayed")
   
   # WRONG
   expand("the error message HCK-001 is displayed")
   → "the error message HCK-001 (Required field) is displayed" [WRONG]
   ```

6. **Screen Transitions**
   ```python
   # CORRECT
   original = "UTO_01 - TOP Screen"
   output = original  # No prefix added
   
   # WRONG
   original = "UTO_01 - TOP Screen"
   output = "Navigate to " + original  # Added prefix [WRONG]
   ```

### Processing Guidelines

1. **When parsing tables**:
   - Detect column boundaries by alignment
   - Handle multi-line cells by preserving line breaks
   - Don't trim whitespace if it's meaningful
   - Keep empty cells empty (no placeholders)

2. **When merging data**:
   - Link by Item No. reference
   - Preserve both item data and action data
   - Don't create new text to connect them
   - Keep original structure of both sources

3. **When extracting rules**:
   - Copy exact text from descriptions
   - Don't interpret or expand
   - Keep context around rule statements
   - Preserve conditional language

4. **When generating tables**:
   - Use Markdown table syntax
   - Align columns for readability (optional)
   - Don't add extra columns
   - Keep row order from source

---

## Validation

### Pre-Output Checklist

Before writing output file, verify:

```python
def validate_output(original, generated):
    checks = [
        verify_text_preservation(original, generated),
        verify_capitalization(original, generated),
        verify_punctuation(original, generated),
        verify_error_codes(original, generated),
        verify_screen_codes(original, generated),
        verify_no_translation(original, generated),
        verify_item_order(original, generated),
        verify_no_placeholders(generated),
        verify_all_sections_present(generated),
        verify_table_structure(generated)
    ]
    
    return all(checks)
```

### Specific Validations

1. **Text Preservation**
   ```python
   def verify_text_preservation(original, generated):
       # Extract all significant text from both
       original_text = extract_text_content(original)
       generated_text = extract_text_content(generated)
       
       # Compare character by character
       for orig, gen in zip(original_text, generated_text):
           if orig != gen:
               raise ValidationError(f"Text modified: '{orig}' → '{gen}'")
       
       return True
   ```

2. **Error Code Check**
   ```python
   def verify_error_codes(original, generated):
       # Find all error codes in original
       original_codes = set(re.findall(r'HCK-\d{3}', original))
       
       # Find all error codes in generated
       generated_codes = set(re.findall(r'HCK-\d{3}', generated))
       
       # Must match exactly
       if original_codes != generated_codes:
           missing = original_codes - generated_codes
           extra = generated_codes - original_codes
           raise ValidationError(f"Error codes mismatch. Missing: {missing}, Extra: {extra}")
       
       return True
   ```

3. **Screen Code Check**
   ```python
   def verify_screen_codes(original, generated):
       # Pattern for screen codes: U[A-Z]{2}_\d{2}
       screen_pattern = r'U[A-Z]{2}_\d{2}'
       
       original_screens = re.findall(screen_pattern, original)
       generated_screens = re.findall(screen_pattern, generated)
       
       # All original screens must be in generated
       for screen in original_screens:
           if screen not in generated_screens:
               raise ValidationError(f"Missing screen code: {screen}")
       
       return True
   ```

4. **No Translation Check**
   ```python
   def verify_no_translation(original, generated):
       # Extract Japanese text from original
       original_jp = extract_japanese_text(original)
       
       # Verify all Japanese text is in generated
       for jp_text in original_jp:
           if jp_text not in generated:
               raise ValidationError(f"Japanese text missing or translated: {jp_text}")
       
       return True
   ```

---

## Examples

### Example 1: Simple Item Transformation

**Input (from Google Sheet)**:
```
Item Definition/項目定義
Item No. | 項目名 - JP | 項目名 - EN | 必須 | データ型 | 説明 - JP | 説明 - EN
1 | メールアドレス | Email address | 〇 | String | HCK-001のエラーメッセージが表示されます | the error message HCK-001 is displayed
```

**Output (in template)**:
```markdown
## 2. Giao Diện

### 2.1.2 Các Thành Phần Chi Tiết

#### Section 1 – Main Components:

| STT | Tên thành phần | Loại | Bắt buộc | Kiểu dữ liệu | Mô tả |
| --- | -------------- | ---- | -------- | ------------ | ----- |
| 1 | メールアドレス / Email address | Text box | 〇 | String | HCK-001のエラーメッセージが表示されます / the error message HCK-001 is displayed |
```

### Example 2: Action Transformation

**Input**:
```
Action and Screen Transition
ID | Trigger | 画面遷移 | アクション
2 | 「ログイン」をクリックするとき / When user click "Login" | UTO_01 - トップ画面（TOP Screen） | - 正しいアカウントを入力し、かつアカウントが認証済みの場合、UTO_01 - トップ画面に遷移します / If user enter correct account AND has verified account, navigate to UTO_01 - TOP Screen
```

**Output**:
```markdown
## 3. Chức Năng

### 3.1 Các Thao Tác Chính

| ID | Tên thao tác | Kích hoạt | Chuyển màn | Mô tả |
| -- | ------------ | --------- | ---------- | ----- |
| 2 | Login | 「ログイン」をクリックするとき / When user click "Login" | UTO_01 - トップ画面（TOP Screen） | - 正しいアカウントを入力し、かつアカウントが認証済みの場合、UTO_01 - トップ画面に遷移します / If user enter correct account AND has verified account, navigate to UTO_01 - TOP Screen |
```

### Example 3: Validation Rules Extraction

**Input (from item descriptions)**:
```
- When not entering the email address, the error message HCK-001 is displayed
- When user enter an incorrect email address, the error message HCK-003 is displayed
```

**Output**:
```markdown
## 10. Validation Procedures Detail

### HCK Error Codes:

* `HCK-001`: Required field
* `HCK-003`: Invalid email format

### Field-level Validation:

| Field | Rule |
| ----- | ---- |
| Email address | Required, valid email format |
```

---

## Troubleshooting

### Common Issues

1. **Table parsing fails**
   - **Cause**: Inconsistent column alignment in source
   - **Solution**: Use column headers to identify columns, not just whitespace
   - **Code**:
     ```python
     # Don't rely on whitespace alignment
     columns = detect_columns_by_headers(table_text)
     ```

2. **Text gets modified**
   - **Cause**: String manipulation functions that "clean" text
   - **Solution**: Use raw string operations, no `.strip()`, `.title()`, etc.
   - **Code**:
     ```python
     # WRONG
     text = original.strip().title()
     
     # CORRECT
     text = original  # Keep as-is
     ```

3. **Missing content**
   - **Cause**: Section detection fails due to format variation
   - **Solution**: Use multiple detection patterns
   - **Code**:
     ```python
     patterns = [
         r'Item Definition/項目定義',
         r'Item Definition',
         r'項目定義'
     ]
     section_start = find_first_match(content, patterns)
     ```

4. **Merged cells cause duplicate rows**
   - **Cause**: Spreadsheet merged cells become blank rows in markdown
   - **Solution**: Forward-fill blank cells from previous row
   - **Code**:
     ```python
     def forward_fill_merged_cells(table_rows):
         for i in range(1, len(table_rows)):
             for j in range(len(table_rows[i])):
                 if table_rows[i][j].strip() == '':
                     table_rows[i][j] = table_rows[i-1][j]
         return table_rows
     ```

5. **Error codes not extracted**
   - **Cause**: Regex doesn't match all patterns
   - **Solution**: Use comprehensive regex
   - **Code**:
     ```python
     # Match HCK-001, HCK-003, etc.
     error_codes = re.findall(r'HCK-\d{3}', text)
     ```

### Debugging Steps

1. **Enable verbose logging**:
   ```python
   logger.setLevel(logging.DEBUG)
   logger.debug(f"Parsing section: {section_name}")
   logger.debug(f"Extracted items: {len(items)}")
   ```

2. **Compare character by character**:
   ```python
   def char_diff(original, generated):
       for i, (o, g) in enumerate(zip(original, generated)):
           if o != g:
               print(f"Diff at position {i}: '{o}' (U+{ord(o):04X}) → '{g}' (U+{ord(g):04X})")
   ```

3. **Validate intermediate results**:
   ```python
   items = extract_items(content)
   assert len(items) > 0, "No items extracted"
   assert all('name' in item for item in items), "Some items missing name"
   ```

---

## Best Practices

1. **Always preserve original**:
   - Work on copies, never modify original data
   - Keep original text in variables with `_original` suffix

2. **Validate at each step**:
   - After parsing: verify all sections found
   - After extraction: verify all items and actions present
   - After mapping: verify no data loss
   - Before output: verify formatting rules

3. **Handle edge cases**:
   - Empty sections: include section header with "(None)" or omit
   - Missing translations: keep whatever language is present
   - Malformed tables: parse what's possible, log what's not

4. **Document assumptions**:
   - If inferring screen code, document the pattern used
   - If grouping items into sections, document grouping logic
   - If ordering items, document ordering criteria

5. **Test thoroughly**:
   - Test with multiple input files
   - Test with JP-only, EN-only, and bilingual files
   - Test with various table formats
   - Test with missing sections

---

## Related Documents

- **Template**: `/doc/rules/SCREEN_DETAIL_TEMPLATE.md`
- **Guidelines**: `/doc/rules/SCREEN_DETAIL_RULES.md`
- **Formatting Rules**: `/app/.cursor/rules/screen_spec_formatting.mdc`
- **Command**: `/app/.cursor/commands/generate-screen-spec.md`

---

## Change Log

| Version | Date | Changes |
| ------- | ---- | ------- |
| 1.0 | 2025-10-29 | Initial version |

---

**Version**: 1.0  
**Last Updated**: 2025-10-29  
**Maintained by**: Development Team

