// ignore_for_file: avoid_hard_coded_colors
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../../index.dart';

class MainHeader extends HookConsumerWidget {
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearching = useState(false);
    final focusNode = useFocusNode();
    final controller = useTextEditingController();

    useEffect(() {
      void listener() {
        if (!focusNode.hasFocus) {
          isSearching.value = false;
        }
      }

      focusNode.addListener(listener);
      return () => focusNode.removeListener(listener);
    }, [focusNode]);

    if (isSearching.value) {
      return SizedBox(
        height: 44.rps,
        child: GlassSearchBar(
          controller: controller,
          focusNode: focusNode,
          placeholder: 'Tìm kiếm...'.hardcoded,
          showsCancelButton: true,
          useOwnLayer: true,
          cancelButtonColor: color.primary,
          clearIconColor: color.primary,
          searchIconColor: color.primary,
          textStyle: style(color: color.black, fontSize: 16.rps),
          placeholderStyle: style(color: color.greyscale500, fontSize: 16.rps),
          onCancel: () {
            isSearching.value = false;
            controller.clear();
            focusNode.unfocus();
          },
        ),
      );
    }

    final avatarUrl = ref.watch(appPreferencesProvider).avatarUrl;

    Widget buildAvatar() {
      if (avatarUrl.startsWith('data:image')) {
        try {
          final base64String = avatarUrl.split(',').last;
          final bytes = base64Decode(base64String);
          return CommonImage.memory(
            bytes: bytes,
            width: 36.rps,
            height: 36.rps,
            fit: BoxFit.cover,
          );
        } catch (e) {
          Log.e('Error decoding avatar base64: $e');
        }
      }
      return CommonImage.asset(
        path: image.imageAppIcon,
        width: 36.rps,
        height: 36.rps,
        fit: BoxFit.cover,
      );
    }

    return Row(
      children: [
        CommonImage.asset(
          path: image.imageAppIcon,
          width: 32.rps,
          height: 32.rps,
        ),
        SizedBox(width: 8.rps),
        CommonText(
          'UTTQ'.hardcoded,
          style: style(
            color: color.black,
            fontSize: 24.rps,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        Stack(
          children: [
            Icon(
              AppIcons.notificationLight,
              size: 28.rps,
              color: color.greyscale900,
            ),
            Positioned(
              right: 2.rps,
              top: 2.rps,
              child: Container(
                width: 8.rps,
                height: 8.rps,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 16.rps),
        GestureDetector(
          onTap: () {
            isSearching.value = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              focusNode.requestFocus();
            });
          },
          child: Icon(
            AppIcons.searchLight,
            size: 28.rps,
            color: color.greyscale900,
          ),
        ),
        SizedBox(width: 16.rps),
        Container(
          width: 36.rps,
          height: 36.rps,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.greyscale200, width: 1.5.rps),
          ),
          child: ClipOval(
            child: buildAvatar(),
          ),
        ),
      ],
    );
  }
}
