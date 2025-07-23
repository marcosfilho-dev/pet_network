import 'package:image_picker/image_picker.dart';

class Post {
  final XFile image;
  final String? caption;
  bool isLiked;

  Post({
    required this.image,
    this.caption,
    this.isLiked = false,
  });
}