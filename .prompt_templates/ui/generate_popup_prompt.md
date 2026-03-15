Fetch the data from the [FIGMA_LINK], then based on the codebase and existing popups, write the code for the lib/ui/popup/[popup_name].dart popup.

## Steps:

1. Use get_code to fetch all data of the popup in the [FIGMA_LINK]

2. Search all strings in the [FIGMA_LINK] and add the appropriate strings to lib/resource/l10n/intl_ja.arb (no need to translate to other languages and do not add strings that can be dynamic data), later when coding UI use l10n.<key>. 
   - Key should be in camelCase. If the string already exists in intl_ja.arb, reuse it.
   - Key name should be translated from value to English. Ex: "ifYouWishToCancelAfter24HoursPleaseCallTheOwnerDirectly": "24時間以降のキャンセルはサロンへ直接お電話ください", "jp": "JP"

3. Search all images in the Figma design and check assets/images folder:
   - If matching file exists: Use it with CommonImage(lib/ui/component/ui_kit/common_image.dart) for next step
     - For .svg files: Use `CommonImage.svg()` constructor
     - For .png files: Use `CommonImage.asset()` constructor
   - If no matching file exists: Do not download the image to assets/images folder and do not use the image in the UI code

4. Based on the data from the get_code command above, complete the {PascalCasePopupName} popup class. Follow the instructions:
    - Use CommonImage with path image.<image_name>, do not use Icon widget
    - Use CommonImage.svg() for .svg files and CommonImage.asset() for .png files
    - Use CommonText for text with `style: style(color: color.<color_name>, fontSize: <font_size>.rps)` for text style. If the <color_name> does not exist in AppColors(lib/resource/app_colors.dart), use Color(0xFF<hex_color>) instead
    - Use l10n.<key> for strings
    - Some special strings that are not declared in the .arb file — such as 'yyyy-MM-dd', '*', and others — should be declared in the lib/common/constant.dart file.
    - Use `.rps` for fontSize, width, height, other dimensions
    - Prioritize using flutter_hooks: useScrollController() for scroll controllers, useTextEditingController() for text editing controllers,...
    - Prioritize using the common widgets available in lib/ui/component/ folder
        - CommonAppBar instead of AppBar
        - CommonDivider instead of Divider
        - CommonImage instead of Image, Icon or SvgPicture
        - CommonScaffold instead of Scaffold
        - CommonText instead of Text
        - Text.rich instead of RichText
        - CommonProgressIndicator instead of CircularProgressIndicator
    - One file has only one public widget class, do not create multiple public widget classes in one file, private classes are allowed
    - Text color must be same as Figma design
    - Font size must be same as Figma design
    - Layout/widget alignment must be the same as design
    - Make the popup flexible with parameters for different use cases
    - Add proper documentation comments for the popup
    - If the popup has scrollable content, wrap with SingleChildScrollView when needed
    - Create a function in lib/ui/popup/base/common_popup.dart to return the popup

5. Write golden tests and generate snapshots based on the instructions in .prompt_templates/golden_test/generate_golden_tests_prompt.md file with PAGE_FILE_PATH: lib/ui/popup/[popup_name].dart

## Notes:

- Do not comment
- Do not modify any existing strings, colors or images
- Use make_fb instead of dart run build_runner build
- Popup should be reusable and flexible
- Export the popup through lib/index.dart

## Variables:
- [FIGMA_LINK]: [YOUR_FIGMA_LINK]
- [popup_name]: [POPUP_NAME]

Note: 
- Output must be the same as the design in the attached image.
