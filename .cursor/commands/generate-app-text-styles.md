# Generate App Text Styles

## Purpose
Fetch all typography/text styles from Figma and add to app_text_style.dart

## Parameters:
- `figma_link`: The Figma link to fetch typography/text styles from

## Steps

Use tools of Figma MCP to fetch all typography/text styles from the {{figma_link}} to [app_text_style.dart](lib/resource/app_text_style.dart), without comment, do not modify any existing text styles.

## Example

```dart
TextStyle largeNoneBold({required Color color}) => style(
      fontWeight: FontWeight.w700,
      fontSize: 18.rps,
      height: 18 / 18,
      color: color,
    );
```
