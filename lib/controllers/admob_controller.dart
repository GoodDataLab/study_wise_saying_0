import 'package:study_wise_saying/common_import.dart';

AdmobController admobController = AdmobController();

class AdmobController {
  BannerAd? _bannerAd;
  BannerAd? _mediumRectangleAd;

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

  initMediumRectangleAd() {
    _mediumRectangleAd = BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: BannerAd.testAdUnitId,
        listener: BannerAdListener(),
        request: AdRequest())
      ..load();
  }

  createMediumAd() {
    return AdWidget(ad: _mediumRectangleAd!);
  }

  createBannerAd() {
    return AdWidget(ad: _bannerAd!);
  }
}
