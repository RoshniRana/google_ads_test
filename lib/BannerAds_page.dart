import 'package:flutter/material.dart';
import 'package:google_ads_test/Homepage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAds_page extends StatefulWidget {
  const BannerAds_page({super.key});

  @override
  State<BannerAds_page> createState() => _BannerAds_pageState();
}

class _BannerAds_pageState extends State<BannerAds_page> {
  // BannerAd? _bannerAd;
  List<BannerAd> banner_ads = [];
  bool _isLoaded = false;
  final adUnitId = 'ca-app-pub-3940256099942544/6300978111';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < 15; i++) {
      load_bannerAds(i);
      // if(i % 4 == 0){
      //   load_bannerAds(i);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Homepage();
      },));
      return Future.value(true);
    },
      child: Scaffold(
        body: Container(child: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) {
            if (index % 4 == 0) {
              return SizedBox(
                  width: banner_ads[index].size.width.toDouble(),
                  height: banner_ads[index].size.height.toDouble(),
                  child: AdWidget(ad: banner_ads[index]));
            } else {
              return ListTile(
                title: Text("$index"),
              );
            }
          },
        )),
      ),
    );
  }

  void load_bannerAds(int i) {

    // banner_ads[i] = BannerAd(
    //   adUnitId: adUnitId,
    //   request: const AdRequest(),
    //   size: AdSize.banner,
    //   listener: BannerAdListener(
    //     // Called when an ad is successfully received.
    //     onAdLoaded: (ad) {
    //       debugPrint('$ad loaded.');
    //       setState(() {
    //         _isLoaded = true;
    //       });
    //     },
    //     // Called when an ad request failed.
    //     onAdFailedToLoad: (ad, err) {
    //       debugPrint('BannerAd failed to load: $err');
    //       // Dispose the ad here to free resources.
    //       ad.dispose();
    //     },
    //     // Called when an ad opens an overlay that covers the screen.
    //     onAdOpened: (Ad ad) {},
    //     // Called when an ad removes an overlay that covers the screen.
    //     onAdClosed: (Ad ad) {},
    //     // Called when an impression occurs on the ad.
    //     onAdImpression: (Ad ad) {},
    //   ),
    // )..load();

    banner_ads.add(BannerAd(
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
    )..load());

    print("len = ${banner_ads.length}");
  }
}
