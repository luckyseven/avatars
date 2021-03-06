part of 'package:avatars/avatars.dart';

class GenericSource extends Source {
  ImageProvider image;

  GenericSource(this.image);

  @override
  String? getAvatarUrl() => null;

  @override
  Future<ImageProvider> getAvatar([bool useCache = false]) =>
      Future.value(image);
}
