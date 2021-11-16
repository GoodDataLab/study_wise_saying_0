import 'package:study_wise_saying/common_import.dart';

AdmobController admobController = AdmobController();

class AdmobController {
  late BannerAd _bannerAd;
  //late BannerAd _exitBannerAd;
  InterstitialAd? _interstitialAd;
  // late InterstitialAd? _interstitialAd;
  //late NativeAd _nativeAd;

  //InterstitialAd get mediumRectangleAd => _interstitialAd;

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

  // initExitBannerAd() {
  //   _exitBannerAd = BannerAd(
  //       size: AdSize.mediumRectangle,
  //       adUnitId: 'ca-app-pub-6982016124752185/9417050435',
  //       listener: BannerAdListener(),
  //       request: AdRequest())
  //     ..load();
  // }

  // initNativeAd() {
  //   _nativeAd = NativeAd(
  //       adUnitId: NativeAd.testAdUnitId,
  //       listener: NativeAdListener(),
  //       request: AdRequest(),
  //       factoryId: 'Container')
  //     ..load();
  // }

  initInterstitialAd() {
    return InterstitialAd.load(
        adUnitId: InterstitialAd.testAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            this._interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  createInterstitialAd() {
    _interstitialAd?.show();
  }

  // fullScreenEvent() {
  //   _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdShowedFullScreenContent: (InterstitialAd ad) =>
  //         print('$ad onAdShowedFullScreenContent.'),
  //     onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //       print('$ad onAdDismissedFullScreenContent.');
  //       ad.dispose();
  //     },
  //     onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
  //       print('$ad onAdFailedToShowFullScreenContent: $error');
  //       ad.dispose();
  //     },
  //     onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),
  //   );
  // }

  createBannerAd() {
    return AdWidget(ad: _bannerAd);
  }

  // createExitBannerAd() {
  //   return AdWidget(ad: _interstitialAd);
  // }

  // createNativeAd() {
  //   return AdWidget(ad: _nativeAd);
  // }
}
