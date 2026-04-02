class $AssetsImagesGen {
  const $AssetsImagesGen();

  String get iconBack => 'assets/images/icon_back.svg';

  String get iconClose => 'assets/images/icon_close.svg';

  String get imageAppIcon => 'assets/images/image_app_icon.png';

  String get imageBackground => 'assets/images/image_background.png';

  String get imageDarkBackground => 'assets/images/image_dark_background.jpeg';

  String get onboarding1 => 'assets/images/onboarding_1.png';

  String get onboarding2 => 'assets/images/onboarding_2.png';

  String get onboarding3 => 'assets/images/onboarding_3.png';

  /// List of all assets
  List<String> get values =>
      [iconBack, iconClose, imageAppIcon, imageBackground, imageDarkBackground, onboarding1, onboarding2, onboarding3];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}
