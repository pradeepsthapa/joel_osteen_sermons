import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleBannerWidget extends StatefulWidget {
  const GoogleBannerWidget({Key? key}) : super(key: key);

  @override
  State<GoogleBannerWidget> createState() => _GoogleBannerWidgetState();
}

class _GoogleBannerWidgetState extends State<GoogleBannerWidget> {

  bool _loadingAnchoredBanner = false;
  late BannerAd bannerAd;

  void createBanner(){
    bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: "ca-app-pub-2693320098955235/2277663101",
        // adUnitId: BannerAd.testAdUnitId,
        listener: BannerAdListener(
          onAdLoaded: (ad){
            _loadingAnchoredBanner = true;
          },
          onAdFailedToLoad: (ad,err){
            ad.dispose();
          }
        ),
        request: const AdRequest(),);
    bannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    createBanner();
  }

  @override
  void dispose() {
    super.dispose();
    bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loadingAnchoredBanner?SizedBox(
      height: bannerAd.size.height.toDouble(),
      width: bannerAd.size.width.toDouble(),
      child: AdWidget(ad: bannerAd),
    ):const SizedBox.shrink();
  }
}
