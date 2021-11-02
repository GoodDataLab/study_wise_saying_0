import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_wise_saying/model/post.dart';

DatabaseController databaseController = DatabaseController();

class DatabaseController {
  Future<void> addPost({required Post post}) async {
    await FirebaseFirestore.instance
        .collection('post')
        .doc(post.id)
        .set(post.toJson());
  }

  Future<DocumentSnapshot> getPost({required String postId}) async {
    print('postId: $postId');
    return FirebaseFirestore.instance.collection('post').doc(postId).get();
  }

  Future<void> deletePost({required String postId}) async {
    return FirebaseFirestore.instance.collection('post').doc(postId).delete();
  }

  Future<void> updatePost(
      {required String postId,
      required String postTitle,
      required String postSubtitle,
      required String postContent}) async {
    await FirebaseFirestore.instance.collection('post').doc(postId).update({
      'title': postTitle,
      'subtitle': postSubtitle,
      'content': postContent,
    });
  }
}
