/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/add-image-photo-icon.svg
  String get addImagePhotoIcon => 'assets/icons/add-image-photo-icon.svg';

  /// File path: assets/icons/add-video.svg
  String get addVideo => 'assets/icons/add-video.svg';

  /// File path: assets/icons/affiliate-marketing-icon.svg
  String get affiliateMarketingIcon =>
      'assets/icons/affiliate-marketing-icon.svg';

  /// File path: assets/icons/box-package-icon.svg
  String get boxPackageIcon => 'assets/icons/box-package-icon.svg';

  /// File path: assets/icons/category-icon.svg
  String get categoryIcon => 'assets/icons/category-icon.svg';

  /// File path: assets/icons/content-view-thumbnails-icon.svg
  String get contentViewThumbnailsIcon =>
      'assets/icons/content-view-thumbnails-icon.svg';

  /// File path: assets/icons/economy-grow-icon.svg
  String get economyGrowIcon => 'assets/icons/economy-grow-icon.svg';

  /// File path: assets/icons/file-line-icon.svg
  String get fileLineIcon => 'assets/icons/file-line-icon.svg';

  /// File path: assets/icons/ic_back.svg
  String get icBack => 'assets/icons/ic_back.svg';

  /// File path: assets/icons/logout-line-icon.svg
  String get logoutLineIcon => 'assets/icons/logout-line-icon.svg';

  /// File path: assets/icons/noun-add-product-6282309.svg
  String get nounAddProduct6282309 =>
      'assets/icons/noun-add-product-6282309.svg';

  /// File path: assets/icons/package-add-icon.svg
  String get packageAddIcon => 'assets/icons/package-add-icon.svg';

  /// File path: assets/icons/receipt-us-dollar-icon.svg
  String get receiptUsDollarIcon => 'assets/icons/receipt-us-dollar-icon.svg';

  /// File path: assets/icons/registration-icon.svg
  String get registrationIcon => 'assets/icons/registration-icon.svg';

  /// File path: assets/icons/services-icon.svg
  String get servicesIcon => 'assets/icons/services-icon.svg';

  /// File path: assets/icons/setting-line-icon.svg
  String get settingLineIcon => 'assets/icons/setting-line-icon.svg';

  /// File path: assets/icons/sliders-icon.svg
  String get slidersIcon => 'assets/icons/sliders-icon.svg';

  /// File path: assets/icons/store-15.svg
  String get store15 => 'assets/icons/store-15.svg';

  /// File path: assets/icons/text-document-add-icon.svg
  String get textDocumentAddIcon => 'assets/icons/text-document-add-icon.svg';

  /// List of all assets
  List<String> get values => [
        addImagePhotoIcon,
        addVideo,
        affiliateMarketingIcon,
        boxPackageIcon,
        categoryIcon,
        contentViewThumbnailsIcon,
        economyGrowIcon,
        fileLineIcon,
        icBack,
        logoutLineIcon,
        nounAddProduct6282309,
        packageAddIcon,
        receiptUsDollarIcon,
        registrationIcon,
        servicesIcon,
        settingLineIcon,
        slidersIcon,
        store15,
        textDocumentAddIcon
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Autocarlogo.png
  AssetGenImage get autocarlogo =>
      const AssetGenImage('assets/images/Autocarlogo.png');

  /// File path: assets/images/Rectangle.png
  AssetGenImage get rectangle =>
      const AssetGenImage('assets/images/Rectangle.png');

  /// List of all assets
  List<AssetGenImage> get values => [autocarlogo, rectangle];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
