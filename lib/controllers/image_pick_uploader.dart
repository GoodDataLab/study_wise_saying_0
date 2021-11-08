import 'package:study_wise_saying/controllers/storage_controller.dart';

import '../../common_import.dart';
import '../screens/common/global_popup.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';

ImagePickUploader imagePickUploader = ImagePickUploader();

class ImagePickUploader {
  final _picker = ImagePicker();
  Future<String?> pickAndUpload(
    String uploadPath,
  ) async {
    try {
      XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        // maxWidth: kImageMaxWidth,
        // maxHeight: kImageMaxHeight,
      );
      print(image?.path ?? 'null');
      if (image != null) {
        var result = await firebaseStorageController.uploadFile(
          filePath: image.path,
          uploadPath: uploadPath,
        );

        return result;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
