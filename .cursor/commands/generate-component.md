# Generate Component

## Purpose
Use the Figma MCP tools to fetch all component design data from {{figma_links}}, and generate the Dart component at lib/ui/component/{{component_name}}/{{component_name}}.dart with multiple constructor variants and corresponding Golden Tests following all instruction files mentioned in the Context section.

## Context:
- Common UI coding instructions: @docs/technical/common_ui_coding_instructions.md
- Component implementation instructions: @docs/technical/component_instructions.md
- Golden test instructions: @docs/technical/golden_test_instructions.md

## Parameters:
- `figma_links`: A list of Figma links
- `component_name`: The name of the component

## Steps:

1. For each Figma link in {{figma_links}}, use tools of Figma MCP to fetch all data and get the preview image

2. Search all fixed strings from ALL Figma designs and add them to `.i18n.json` files

3. Search all images from ALL Figma designs and check assets/images folder:
   - If matching file exists: Use it with CommonImage
   - If no matching file exists: Use any image in the assets/images folder. Do not download the image from Figma to assets/images folder.

4. Based on the data from step 1, create the {{component_name_pascal}} component class:
   - If multiple variants: Create ONE private base constructor with all possible parameters and ONE named constructor for EACH Figma link provided
   - If single variant: Create ONE constructor with flexible parameters
   - Each named constructor should be named based on constructor name if provided

5. Write golden tests for ALL constructor variants and generate golden images for lib/ui/component/{{component_name}}/{{component_name}}.dart following the instructions in @docs/technical/golden_test_instructions.md

## Notes:

- Output of the golden tests must be the same as the designs when getting the preview images at step 1
- Each named constructor represents one Figma design variant
- If only one Figma link provided, create a single flexible constructor

