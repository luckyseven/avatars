part of 'package:avatars/avatars.dart';

abstract class Source {
  bool _cached = false;
  ImageProvider _cache;

  String getAvatarUrl();

  Future<ImageProvider> getAvatar() {
    if (_cached) {
      return Future.value(_cache);
    }
    return _getImageBytes(getAvatarUrl()).then((bytes) {
      if (bytes != null) {
        _cached = true;
        _cache = MemoryImage(bytes);
        return _cache;
      }
      return null;
    });
  }

  Future<Uint8List> _getImageBytes(String url) {
    Completer<Uint8List> completer = Completer();
    HttpClient client = new HttpClient();
    var _downloadData = List<int>();
    client.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) {
      if (response.statusCode > 399 ||
          !['image/jpeg', 'image/png']
              .contains(response.headers.contentType.toString())) {
        completer.complete(null);
      } else {
        response.listen((d) => _downloadData.addAll(d), onDone: () {
          completer.complete(Uint8List.fromList(_downloadData));
        });
      }
    }).catchError((e) => completer.complete(null));
    return completer.future;
  }
}