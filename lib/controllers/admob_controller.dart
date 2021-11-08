import 'package:study_wise_saying/common_import.dart';

AdmobController admobController = AdmobController();

class AdmobController {
  late BannerAd _bannerAd;
  late BannerAd _mediumRectangleAd;
  // late InterstitialAd? _interstitialAd;
  // late NativeAd _nativeAd;

  BannerAd get mediumRectangleAd => _mediumRectangleAd;

  initMobileAds() {
    MobileAds.instance.initialize();
  }

  initBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: BannerAd.testAdUnitId,
        listener: BannerAdListener(),
        request: AdRequest())
      ..load();
  }

  // initNativeAd() {
  //   _nativeAd = NativeAd(
  //       adUnitId: NativeAd.testAdUnitId,
  //       listener: NativeAdListener(),
  //       request: AdRequest(),
  //       factoryId: 'Container')
  //     ..load();
  // }

  initMediumRectangleAd() {
    _mediumRectangleAd = BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: BannerAd.testAdUnitId,
        listener: BannerAdListener(),
        request: AdRequest())
      ..load();
  }

  // initIntertitialAd() {
  //   _interstitialAd = InterstitialAd.
  // }
  // createNativeAd() {
  //   return AdWidget(ad: _nativeAd);
  // }

  createMediumAd() {
    return AdWidget(
      ad: _mediumRectangleAd,
    );
  }

  createBannerAd() {
    return AdWidget(ad: _bannerAd);
  }
}
