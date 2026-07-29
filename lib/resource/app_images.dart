class $AssetsImagesGen {
  const $AssetsImagesGen();

  String get flashcard => 'assets/images/flashcard.png';

  String get iconBack => 'assets/images/icon_back.svg';

  String get iconClose => 'assets/images/icon_close.svg';

  String get imageAppIcon => 'assets/images/image_app_icon.png';

  String get logo => 'assets/images/logo.svg';

  String get onboarding1 => 'assets/images/onboarding_1.png';

  String get onboarding2 => 'assets/images/onboarding_2.png';

  String get onboarding3 => 'assets/images/onboarding_3.png';

  String get quiz => 'assets/images/quiz.png';

  String get register => 'assets/images/register.png';

  String get registerIllustration => 'assets/images/register_illustration.svg';

  String get successPopup => 'assets/images/success_popup.png';

  String get summary => 'assets/images/summary.png';

  /// List of all assets
  List<String> get values => [
        flashcard,
        iconBack,
        iconClose,
        imageAppIcon,
        logo,
        onboarding1,
        onboarding2,
        onboarding3,
        quiz,
        register,
        registerIllustration,
        successPopup,
        summary
      ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}
