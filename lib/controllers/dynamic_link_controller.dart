import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:study_wise_saying/screens/screen_by_dynamic_link.dart';
import '../screens/common/global_popup.dart';

import '../common_import.dart';

final DynamicLinkController dynamicLinkController = DynamicLinkController();
final dynamicLinkPostKeyword = 'postLink';

class DynamicLinkController {
  final dynamicLinkPrefix = 'https://gongmyeong.page.link';
  final androidPackageName = 'com.gooddatalab.studyWiseSaying';
  final iosPackageName = 'com.gooddatalab.studyWiseSaying';
  final iosAppstroeId = ''; // todo
  final defaultInvitationImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/study-wisesaying.appspot.com/o/appicon%2Fappstore.png?alt=media&token=e1834944-44a8-4d14-8c7f-83ba00984564';

  Future<String?> buildPostLink({
    required String postId,
    required String previewTitle,
    required String previewDescription,
    String? previewImageUrl,
  }) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: dynamicLinkPrefix,
      link: Uri.parse('$dynamicLinkPrefix?${dynamicLinkPostKeyword}_$postId'),
      androidParameters: AndroidParameters(
        packageName: androidPackageName,
      ),
      iosParameters: IosParameters(
        bundleId: iosPackageName,
        appStoreId: iosAppstroeId,
      ),
      navigationInfoParameters:
          NavigationInfoParameters(forcedRedirectEnabled: true),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: previewTitle,
        description: previewDescription,
        imageUrl: previewImageUrl == null
            ? Uri.parse(defaultInvitationImageUrl)
            : Uri.parse(previewImageUrl),
      ),
    );

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;
    return shortUrl.toString();
  }

  handleRouteFromDynamicLink() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;
      if (deepLink != null) {
        log(deepLink.toString());
        _handleValidRoute(deepLink);
      } else {
        log('deepLink is null');
      }
    }, onError: (OnLinkErrorException e) async {
      log('onLinkError');
      log(e.message.toString());
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      log(deepLink.toString());
      _handleValidRoute(deepLink);
    } else {
      log('deepLink is null');
    }
  }

  Future<void> _handleValidRoute(Uri deepLink) async {
    AppData appData = Get.find();
    log(deepLink.toString());
    List<String> metadata = deepLink.toString().split('?');
    if (metadata.length > 1) {
      List<String> data = metadata[1].split(',');
      if (data.length > 0) {
        Map<String, String> dataMap = {};
        data.forEach((element) {
          List<String> keyAndValue = element.split('_');
          dataMap[keyAndValue[0]] = keyAndValue[1];
        });
        if (dataMap[dynamicLinkPostKeyword] != null) {
          String postId = dataMap[dynamicLinkPostKeyword]!;
          Get.to(() => ScreenByDynamicLink(postId: postId));
        }
      }
    }
  }
}
