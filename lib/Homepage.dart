import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'BannerAds_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  final adUnitId = 'ca-app-pub-3940256099942544/6300978111';

  InterstitialAd? _interstitialAd;
  final Interstitial_adUnitId = 'ca-app-pub-3940256099942544/1033173712';

  NativeAd? nativeAd;
  bool _nativeAdIsLoaded = false;
  final String nativeAd_adUnitId = 'ca-app-pub-3940256099942544/2247696110';
  AdWidget? adWidget;

  RewardedAd? _rewardedAd;
  final rewarde_adUnitId = 'ca-app-pub-3940256099942544/5224354917';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load_bannerAds();
    // load_interstitialAds();
    load_nativeAds();
    // load_rewardeAd();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        load_interstitialAds();
                        _interstitialAd!.show();
                      },
                      child: Text("Intertitial Ad")),
                  // Container(
                  //     height: 200,
                  //     width: double.infinity,
                  //     child: AdWidget(ad: nativeAd!)),
      ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 320, // minimum recommended width
          minHeight: 320, // minimum recommended height
          maxWidth: 400,
          maxHeight: 400,
        ),
        child: _nativeAdIsLoaded? AdWidget(ad: nativeAd!):Text("no ads")),
    ElevatedButton(onPressed: () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return BannerAds_page();
      },));
    }, child: Text("Banner List")),
    //   Container(
    //       alignment: Alignment.center,
    //       child: adWidget = AdWidget(ad: nativeAd!),
    //   width: 300,
    //   height: 200,
    // ),
                  ElevatedButton(
                      onPressed: () {
                        load_rewardeAd();
                        _rewardedAd!.show(onUserEarnedReward:
                            (AdWithoutView ad, RewardItem rewardItem) {
                          // Reward the user for watching an ad.
                        });
                      },
                      child: Text("RewardedAd Ad")),
                ],
              ),
            ),
          ),
          _isLoaded
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    child: SizedBox(
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                    ),
                  ),
                )
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    child: SizedBox(
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      child: Text("Space Ad"),
                    ),
                  ),
                )
        ],
      ),
    ));
  }

  void load_bannerAds() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    )..load();
  }

  void load_interstitialAds() {
    InterstitialAd.load(
        adUnitId: Interstitial_adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            setState(() {
              _interstitialAd = ad;
            });
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  void load_nativeAds() {
    nativeAd = NativeAd(
        adUnitId: nativeAd_adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            print('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            print('$NativeAd failedToLoad: $error');
            ad.dispose();
          },
          // Called when a click is recorded for a NativeAd.
          onAdClicked: (ad) {},
          // Called when an impression occurs on the ad.
          onAdImpression: (ad) {},
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (ad) {},
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (ad) {},
          // For iOS only. Called before dismissing a full screen view
          onAdWillDismissScreen: (ad) {},
          // Called when an ad receives revenue value.
          onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
            // Required: Choose a template.
            templateType: TemplateType.medium,
            // Optional: Customize the ad's style.
            mainBackgroundColor: Colors.purple,
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.cyan,
                backgroundColor: Colors.red,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Colors.cyan,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Colors.amber,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
  }
  // void load_nativeAds() {
  //   nativeAd = NativeAd(
  //     adUnitId: nativeAd_adUnitId,
  //     // Factory ID registered by your native ad factory implementation.
  //     factoryId: 'adFactoryExample',
  //     listener: NativeAdListener(
  //       onAdLoaded: (ad) {
  //         print('$NativeAd loaded.');
  //         setState(() {
  //           _nativeAdIsLoaded = true;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         // Dispose the ad here to free resources.
  //         print('$NativeAd failedToLoad: $error');
  //         ad.dispose();
  //       },
  //       // Called when a click is recorded for a NativeAd.
  //       onAdClicked: (ad) {},
  //       // Called when an impression occurs on the ad.
  //       onAdImpression: (ad) {},
  //       // Called when an ad removes an overlay that covers the screen.
  //       onAdClosed: (ad) {},
  //       // Called when an ad opens an overlay that covers the screen.
  //       onAdOpened: (ad) {},
  //       // For iOS only. Called before dismissing a full screen view
  //       onAdWillDismissScreen: (ad) {},
  //       // Called when an ad receives revenue value.
  //       onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
  //     ),
  //     request: const AdRequest(),
  //     // Optional: Pass custom options to your native ad factory implementation.
  //     // customOptions: {'custom-option-1', 'custom-value-1'}
  //   );
  //   nativeAd!.load();
  // }

  void load_rewardeAd() {
    RewardedAd.load(
      adUnitId: rewarde_adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                // Dispose the ad here to free resources.
                ad.dispose();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                // Dispose the ad here to free resources.
                ad.dispose();
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {});

          debugPrint('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          _rewardedAd = ad;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }
}
