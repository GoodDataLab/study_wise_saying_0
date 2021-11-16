import 'package:share/share.dart';
import 'package:study_wise_saying/controllers/dynamic_link_controller.dart';

LinkShareHandler linkShareHandler = LinkShareHandler();

class LinkShareHandler {
  Future<bool?> makeLinkAndShare({
    required String postId,
    required String title,
    required String content,
    String? imageUrl,
  }) async {
    String? link = await dynamicLinkController.buildPostLink(
      postId: postId,
      previewTitle: title,
      previewDescription: content,
      previewImageUrl: imageUrl,
    );

    if (link != null) {
      await Share.share(link);
      return true;
    } else {
      return false;
    }
  }
}
