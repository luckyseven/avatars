part of 'package:avatars/avatars.dart';

abstract class Source {
  String getAvatarUrl();

  Future<ImageProvider> getAvatar([bool useCache = false]) async {
    FileInfo cached = await DefaultCacheManager().getFileFromCache(getAvatarUrl());
    if (useCache && cached != null) {
      return MemoryImage(cached.file.readAsBytesSync());
    }
    try {
      Uint8List bytes = await _getImageBytes(getAvatarUrl());
      if (bytes != null) {
        if (useCache) {
          await DefaultCacheManager().putFile(getAvatarUrl(), bytes, maxAge: Duration(days: 7));
        }
        return MemoryImage(bytes);
      }
    } catch (e) {}

    return null;
  }

  Future<Uint8List> _getImageBytes(String url) async {
    Completer<Uint8List> completer = Completer();
    HttpClient client = new HttpClient();
    
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    
    if (response.statusCode > 399 ||
        !['image/jpeg', 'image/png']
            .contains(response.headers.contentType.toString())) {
      completer.complete(null);
    } else {
      completer.complete(Uint8List.fromList(await consolidateHttpClientResponseBytes(response)));
    }
    return completer.future;


    // var _downloadData = List<int>();
    // client.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
    //   return request.close();
    // }).then((HttpClientResponse response) {
    //   if (response.statusCode > 399 ||
    //       !['image/jpeg', 'image/png']
    //           .contains(response.headers.contentType.toString())) {
    //     completer.complete(null);
    //   } else {
    //     response.listen((d) => _downloadData.addAll(d), onDone: () {
    //       completer.complete(Uint8List.fromList(_downloadData));
    //     });
    //   }
    // }).catchError((e) => completer.complete(null));
    // return completer.future;
  }
}