part of 'package:avatars/avatars.dart';

class PlaceholderSource extends Source {
  ImageProvider image; // Mail or Hash

  PlaceholderSource(this.image);

  @override
  String getAvatarUrl() => null;

  @override
  Future<ImageProvider> getAvatar() => Future.value(image);
}
