# Generate Screen Specification Document (v2.1.1)

## Purpose
Convert a messy Markdown file (copied from Google Sheets) into a structured Screen Specification document following the SCREEN_DETAIL_TEMPLATE v2.1 format.

## Input
- A Markdown file with messy formatting (copied from Google Sheets)
- Contains "Item Definition" and "Action and Screen Transition" sections
- May have mixed Japanese/English text
- Inconsistent table formatting

## Output
- Update the input file with structured content following SCREEN_DETAIL_TEMPLATE v2.1
- Preserve all original text exactly (no paraphrasing, no translation)
- Maintain strict formatting rules

## Task
Parse the input Markdown file and transform it into a well-structured document with these sections:

### 1. Header (extract from input)
```markdown
> **Mã màn hình:** `[Extract from sheet name or ID]`  
> **Tên màn hình:** `[Extract from title]`  
> **Mô tả ngắn:** [Extract from overview/処理概要 - 1-2 sentences]  
> **Ngày tạo:** [Today's date YYYY-MM-DD]  
> **Ngày cập nhật cuối:** [Today's date YYYY-MM-DD]  
> **Phiên bản:** 2.1
```

### 2. Table of Contents (v2.1 - 4 sections)
```markdown
## Mục lục
- [1. Tổng quan](#1-tổng-quan)
- [2. Chi tiết màn hình](#2-chi-tiết-màn-hình)
- [3. Luồng tương tác](#3-luồng-tương-tác)
- [4. Validation procedures detail](#4-validation-procedures-detail)
```

### 3. Section 1: Tổng Quan
Extract from "処理概要/Screen Overview" section:
```markdown
## 1. Tổng quan

### 1.1 Mục đích

[Extract JP text from 処理概要]

[Extract EN text from Screen Overview]

### 1.2 Đối tượng sử dụng màn hình (Role)

* [Infer from context if not explicitly stated]
* [List roles and their permissions: End-user (view/edit), Admin (full), etc.]
```

### 4. Section 2: Chi Tiết Màn Hình
Parse "Item Definition/項目定義" table and convert to:
```markdown
## 2. Chi tiết màn hình

#### Section 1 – [Group name, e.g., Main Components]:

| STT | Tên thành phần | Loại | Bắt buộc | Mặc định | Mô tả | Action |
| --- | -------------- | ---- | -------- | -------- | ----- | ------ |
| [Item No.] | [項目名 JP / EN] | [項目種別] | [必須: 〇/△/-] | [初期値] | [説明 - MERGE: データ型, 桁数, フォーマット, descriptions - REMOVE action ID references] | [EXTRACT EXACT TEXT from Action table] |

**Important for Mô tả column:**
- Combine: データ型 (Data type), 桁数 (No. of digits), フォーマット (Format)
- Keep both JP and EN descriptions
- Include error codes (HCK-XXX)
- Include validation rules
- **REMOVE "Refer to action ID X" or "アクションIDXを参照してください" after extracting action** ← NEW
- Example format: "**Data type:** String, **Length:** 254 chars. **JP:** [Japanese desc] **EN:** [English desc]"

**CRITICAL for Action column - PRESERVE EXACT TEXT:**

**Step-by-step process:**

1. **Check if description references an action ID:**
   - Look for "Refer to action ID X" or "アクションIDXを参照" in the Mô tả
   - If found, go to the Action table and find the row with that ID
   - **MARK this reference for removal from Mô tả**

2. **Extract EXACT TEXT from Action table:**
   - Find the action row in "Action and Screen Transition/アクション及び画面遷移"
   - Extract these columns AS IS (no modification):
     - **トリガー (Trigger)** - EXACT text
     - **画面遷移 (Screen Transition)** - EXACT text
     - **アクション概要 (Action)** - EXACT text

3. **Format the Action column - PRESERVE ORIGINAL TEXT:**
   - Use EXACT text from Action table
   - Format: Keep original separators (===, line breaks, bullets)
   - DO NOT paraphrase, summarize, or modify
   - DO NOT translate between JP/EN
   - Keep all punctuation, capitalization exactly

**Format Pattern:**

```
[Trigger from table - EXACT TEXT]
=====
[Action details from table - EXACT TEXT]
```

Or if bilingual:
```
**JP:** [Japanese trigger/action - EXACT TEXT]
**EN:** [English trigger/action - EXACT TEXT]
```

4. **Remove action ID reference from Mô tả:**
   - After extracting action to Action column
   - Remove the line: "- アクションIDXを参照してください。"
   - Remove the line: "- Refer to action ID X"
   - Keep all other text in Mô tả unchanged

5. **If no action ID reference:**
   - Set Action column to: **"-"**
   - DO NOT infer or add any text like "Enter/Paste", "Click", "View", etc.
   - Only use exact text from Action table when action ID is referenced

**Examples:**

**Example 1 - Extract EXACT text:**

```
Item Definition:
- Item 3: Forgot password button
- Description: "アクションID1を参照してください / Refer to action ID 1"

Action Table (ID 1):
- Trigger: 「パスワードをお忘れですか?」をクリックするとき
           =====
           When user click "Forgot password"
- Screen: UFP_01 - パスワード忘れ（Forgot password）
- Action: - 「UFP_01 - パスワード忘れ」画面へ遷移します。
          =====
          - Navigate to UFP_01 - Forgot password

Result:
Mô tả: [Other descriptions - WITHOUT "アクションID1を参照してください / Refer to action ID 1"]
Action: 「パスワードをお忘れですか?」をクリックするとき
        =====
        When user click "Forgot password"
        →
        - 「UFP_01 - パスワード忘れ」画面へ遷移します。
        =====
        - Navigate to UFP_01 - Forgot password
```

**Example 2 - Complex action with conditions:**

```
Action Table (ID 2):
- Trigger: 「ログイン」をクリックするとき
           =====
           When user click "Login"
- Screen: UOC_01 - 認証コード確認（OTP confirm）
          UTO_01 - トップ画面（TOP Screen）
- Action: - 存在しない/削除されたアカウントを入力した場合、HCK-005をのエラーメッセージ表示します。
          - 正しいアカウントを入力したが、アカウントを認証していない場合、アカウント認証のリクエストポップアップ（6）が開きます。
          - 正しいアカウントを入力し、かつアカウントが認証済みの場合、UTO_01 - トップ画面に遷移します。
          =====
          - If user enter an unexisted/deleted account show error message HCK-005
          - If user enter correct account BUT has NOT verified account, Open Request to verify account pop-up (6)
          - If user enter correct account AND has verified account, navigate to UTO_01 - TOP Screen

Result - Use EXACT TEXT:
Action: 「ログイン」をクリックするとき
        =====
        When user click "Login"
        →
        - 存在しない/削除されたアカウントを入力した場合、HCK-005をのエラーメッセージ表示します。
        - 正しいアカウントを入力したが、アカウントを認証していない場合、アカウント認証のリクエストポップアップ（6）が開きます。
        - 正しいアカウントを入力し、かつアカウントが認証済みの場合、UTO_01 - トップ画面に遷移します。
        =====
        - If user enter an unexisted/deleted account show error message HCK-005
        - If user enter correct account BUT has NOT verified account, Open Request to verify account pop-up (6)
        - If user enter correct account AND has verified account, navigate to UTO_01 - TOP Screen
```

#### Section 2 – [Another group, e.g., Popups]:

[Repeat table structure for other logical groupings]
```

### 5. Section 3: Luồng Tương Tác
Extract from "Action and Screen Transition" table:
```markdown
## 3. Luồng tương tác

### 3.1 Các Bước Thao Tác

[Extract step-by-step flow from actions, keeping original numbering and text]
[Describe in a narrative way that non-technical people can understand]

Example:
1) [Step 1 description in natural language]
2) [Step 2 description in natural language]
3) ...

### 3.2 Các Màn Hình Liên Quan

* **Trước:** [Screen before this one]
* **Sau:** [Screen after this one]
* **Popups:** [List all popups/dialogs mentioned]
```

### 6. Section 4: Validation Procedures Detail
```markdown
## 4. Validation procedures detail

### 4.1 Quy tắc chung (màn hình)

[Extract all business rules from descriptions and actions]
[Include rules about data, permissions, workflows]

### 4.2 Ràng buộc & Error Codes

[Extract all HCK-XXX error codes with descriptions]

* `HCK-001`: [Description from original]
* `HCK-003`: [Description from original]
* ...

### Field-level Validation

| Field | Rule |
| ----- | ---- |
| [Field name JP/EN] | [Validation rules: Required, format, length, etc.] |
```

## CRITICAL FORMATTING RULES

### Text Preservation (STRICT)
1. **Keep original text EXACTLY**: Do not paraphrase, translate, or modify any text
2. **Preserve capitalization**: Keep ALL uppercase/lowercase as written
3. **Preserve punctuation**: Keep all commas, periods, colons, semicolons exactly
4. **Preserve Japanese characters**: Keep full-width parentheses（）, full-width spaces, Japanese punctuation
5. **Keep error codes verbatim**: `HCK-001`, `HCK-003`, etc. exactly as written
6. **No added periods**: If the original text doesn't end with a period, don't add one

### Action Column Rules (v2.1.1 - CRITICAL)
1. **MUST use EXACT TEXT from Action table** - no paraphrasing, no summarizing
2. **MUST preserve original separators** - keep ===, bullets, numbering exactly
3. **MUST keep bilingual format** - JP first, then EN, with separator
4. **MUST NOT translate** - if original has both JP and EN, keep both; don't translate
5. **MUST NOT modify** - no changing words, no fixing grammar, no adding explanations

### Mô tả Column Rules (v2.1.1 - NEW)
1. **MUST remove action ID references** after extracting to Action column:
   - Remove: "- アクションIDXを参照してください。"
   - Remove: "- Refer to action ID X"
   - Remove both JP and EN versions
2. **MUST keep all other text** in Mô tả unchanged

### Structure Rules
1. **Keep item order**: Maintain the exact order of items as they appear in the input
2. **Group logically**: Group items into Sections based on UI areas (Main, Popup, Actions, etc.)
3. **Merge data fields**: Combine データ型, 桁数, フォーマット into the Mô tả column
4. **No placeholder text**: Never add "TBD", "N/A", or similar placeholders

## Processing Steps

1. **Read the input file** completely
2. **Identify sections**:
   - Find "処理概要/Screen Overview"
   - Find "Item Definition/項目定義" table
   - Find "Action and Screen Transition/アクション及び画面遷移" table
3. **Parse Action table FIRST**: Create a map of Action ID → EXACT Action details (preserve all text)
4. **Parse Item Definition table**:
   - Extract each row with all columns
   - For each item, check if description references an action ID
   - If yes:
     - Lookup the action details from Action table
     - Copy EXACT TEXT to Action column (no modification)
     - REMOVE the "Refer to action ID X" line from Mô tả
   - Group items logically
   - Merge データ型, 桁数, フォーマット into Mô tả
   - Keep all other text exactly as written
5. **Map to v2.1 template**: Follow the 4-section structure
6. **Generate output**: Format according to SCREEN_DETAIL_TEMPLATE v2.1
7. **Verify formatting**: 
   - Check Action column has EXACT text from Action table
   - Check Mô tả does NOT have "Refer to action ID X"
   - Check all strict formatting rules
8. **Update the input file** with the new structured content

## Validation Checklist

Before completing:
- [ ] All original text preserved exactly (no paraphrasing)
- [ ] **Action column uses EXACT TEXT from Action table** (no summarizing)
- [ ] **Mô tả does NOT contain "Refer to action ID X"** (removed after extraction)
- [ ] All error codes (HCK-XXX) kept verbatim
- [ ] Screen transitions exact (no added "Navigate to" unless in original)
- [ ] Item order matches input file
- [ ] Both JP and EN text preserved where present in Action column
- [ ] All punctuation and capitalization preserved
- [ ] No translation between JP/EN
- [ ] Table of contents matches v2.1 (4 sections with correct anchors)
- [ ] Table columns follow v2.1: STT | Tên thành phần | Loại | Bắt buộc | Mặc định | Mô tả | Action
- [ ] データ型, 桁数, フォーマット merged into Mô tả column
- [ ] All HCK error codes listed in section 4
- [ ] Version is 2.1

## Notes

- This command processes ONE file at a time
- The input file will be UPDATED in place
- **Action column must use EXACT TEXT from Action table** - this is critical
- **Mô tả must NOT have "Refer to action ID X" after extraction** - clean it up
- Follow SCREEN_DETAIL_TEMPLATE v2.1 structure strictly
- Refer to:
  - `docs/business/screen_spec/screen_spec_template.md` (v2.1)
  - `docs/business/screen_spec/screen_spec_template_guidelines.md`
  - `docs/business/screen_spec/screen_spec_example.md`
  - `.cursor/rules/screen_spec_formatting.mdc` for detailed formatting rules

