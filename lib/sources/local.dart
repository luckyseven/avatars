part of 'package:avatars/avatars.dart';

class LocalSource extends Source {
  ImageProvider image;

  LocalSource(this.image);

  @override
  String getAvatarUrl() => null;

  @override
  Future<ImageProvider> getAvatar([bool useCache = false]) =>
      Future.value(image);
}
