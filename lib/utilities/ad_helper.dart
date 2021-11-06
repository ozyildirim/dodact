// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AdHelper {
//   RewardedAd rewardedAd;

//   Future prepareAd() async {
//     RewardedAd.load(
//       adUnitId: 'ca-app-pub-3940256099942544/5224354917',
//       request: AdRequest(),
//       rewardedAdLoadCallback: RewardedAdLoadCallback(
//         onAdLoaded: (ad) {
//           rewardedAd = ad;

//           ad.fullScreenContentCallback = FullScreenContentCallback(
//             onAdDismissedFullScreenContent: (ad) {
//               setState(() {
//                 isRewardedAdReady = false;
//               });
//               prepareAd();
//             },
//           );

//           setState(() {
//             isRewardedAdReady = true;
//           });
//         },
//         onAdFailedToLoad: (err) {
//           print('Failed to load a rewarded ad: ${err.message}');
//           setState(() {
//             isRewardedAdReady = false;
//           });
//         },
//       ),
//     );
//   }
// }
