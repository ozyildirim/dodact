import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class FirebaseDynamicLinkService {
  static initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink.link;

      if (deepLink != null) {
        print(deepLink);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print('getInitialLink=> $deepLink');
    }
  }

  static createUserProfileDynamicLink(String userId) {
    final DynamicLinkParameters parameters = new DynamicLinkParameters(
      uriPrefix: 'https://dodact.page.link',
      link: Uri.parse(
          'https://dodact.page.link/showUserProfile?userId=${userId}'),
      androidParameters: new AndroidParameters(
        packageName: 'com.dodact.dodact_v1',
        minimumVersion: 0,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.dodact.dodact',
        minimumVersion: '0',
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Dodact Kullanıcı Profili',
        description: 'Hadi sen de Dodact profilimi görüntüle!',
      ),
    );

    return parameters;
  }

  static Future<Uri> getShortLink(DynamicLinkParameters parameters) async {
    Uri shortLink;
    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;
    print('shortUrl: $shortUrl');
    shortLink = shortUrl;
    return shortLink;
  }

  showUserProfile() {}

  showGroupProfile() {}

  showPost() {}
}
