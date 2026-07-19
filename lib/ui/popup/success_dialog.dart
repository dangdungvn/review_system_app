// ignore_for_file: missing_golden_test
import 'package:flutter/material.dart';

import '../../index.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.rps),
      ),
      backgroundColor: color.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.rps),
      child: Container(
        width: 340.rps,
        padding: EdgeInsets.only(
          top: 40.rps,
          bottom: 32.rps,
          left: 32.rps,
          right: 32.rps,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIllustration(),
            SizedBox(height: 32.rps),
            CommonText(
              title,
              style: style(
                color: color.primary,
                fontSize: 24.rps,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.rps),
            CommonText(
              message,
              style: style(
                color: color.greyscale900,
                fontSize: 16.rps,
                fontWeight: FontWeight.w400,
                height: 1.4,
                letterSpacing: 0.2.rps,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.rps),
            SizedBox(
              width: 36.rps,
              height: 36.rps,
              child: CircularProgressIndicator(
                strokeWidth: 3.5.rps,
                valueColor: AlwaysStoppedAnimation<Color>(color.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return CommonImage.asset(
      path: image.successPopup,
      width: 185.rps,
      height: 180.rps,
    );
  }
}
