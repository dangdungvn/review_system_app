# Generate Page

## Purpose
Use the Figma MCP tools to fetch all screen design data from {{figma_link}}, and generate the complete Dart page implementation at lib/ui/page/{{screen_name}} including Page, ViewModel, State classes and Golden Tests following all instruction files mentioned in the Context section.

## Context:
- Common UI coding instructions: @docs/technical/common_ui_coding_instructions.md
- Page implementation instructions: @docs/technical/page_instructions.md
- Model classes and enum instructions: @docs/technical/model_classes_and_enum_instructions.md
- ViewModel instructions: @docs/technical/view_model_instructions.md
- State management instructions: @docs/technical/state_management_instructions.md
- Golden test generation instructions: @docs/technical/golden_test_instructions.md

## Parameters:
- `figma_link`: The Figma link to fetch screen design data from
- `screen_name`: The name of the screen

## Steps:

1. Use tools of Figma MCP to fetch all data of the screen in the {{figma_link}} and get the preview image

2. Search all fixed strings in the Figma design and add them to `.i18n.json` files

3. Search all images in the Figma design and check assets/images folder:
   - If matching file exists: Use it with CommonImage
   - If no matching file exists: Use any image in the assets/images folder. Do not download the image from Figma to assets/images folder.

4. Based on the data from step 1, complete the {{screen_name_pascal}}Page, {{screen_name_pascal}}ViewModel, {{screen_name_pascal}}State classes following the respective instruction files in the Context section and the spec file in lib/ui/page/{{screen_name}}/{{screen_name}}_spec.md

5. Write golden tests and generate golden images for lib/ui/page/{{screen_name}}/{{screen_name}}_page.dart following the instructions in @docs/technical/golden_test_instructions.md

## Notes:

- Output of the golden tests must be the same as the design when getting the preview image at step 1

## Checklist

- [ ] lib/ui/page/{{screen_name}}/{{screen_name}}_page.dart is updated
- [ ] lib/ui/page/{{screen_name}}/view_model/{{screen_name}}_view_model.dart is updated
- [ ] lib/ui/page/{{screen_name}}/view_model/{{screen_name}}_state.dart is updated
- [ ] test/widget_test/ui/page/{{screen_name}}/{{screen_name}}_page_test.dart is updated
- [ ] Ran `make fb` before generating golden images
- [ ] Golden images are generated
- [ ] Golden images are the same as the design
