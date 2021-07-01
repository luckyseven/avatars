part of 'package:avatars/avatars.dart';

abstract class Source {
  String? getAvatarUrl();

  Future<ImageProvider?> getAvatar([bool useCache = false]) async {
    try {
      FileInfo? cached;
      if (useCache && getAvatarUrl() != null) {
        cached = await DefaultCacheManager().getFileFromCache(getAvatarUrl()!);
        if (cached != null) {
          return MemoryImage(cached.file.readAsBytesSync());
        }
      }

      if (getAvatarUrl() != null) {
        Uint8List? bytes = await _getImageBytes(getAvatarUrl()!);
        if (bytes != null) {
          if (useCache && getAvatarUrl() != null) {
            await DefaultCacheManager()
                .putFile(getAvatarUrl()!, bytes, maxAge: Duration(days: 7));
          }
          return MemoryImage(bytes);
        }
      }
    } catch (e) {}

    return null;
  }

  Future<Uint8List?> _getImageBytes(String url) async {
    Completer<Uint8List> completer = Completer();

    try {
      HttpClient client = new HttpClient();

      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();

      if (response.statusCode > 399 ||
          !['image/jpeg', 'image/png']
              .contains(response.headers.contentType.toString())) {
        completer.complete(null);
      } else {
        completer.complete(Uint8List.fromList(
            await consolidateHttpClientResponseBytes(response)));
      }
    } catch (e) {
      completer.complete(null);
    }
    return completer.future;
  }
}
