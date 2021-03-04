part of 'package:avatars/avatars.dart';

class InstagramSource extends Source {
  String username;
  int size;

  InstagramSource(this.username, [this.size = 500]);

  Future<Uint8List> _getImageBytes(String url) {

    Map<String, dynamic> jsonResponse;

    Completer<Uint8List> completer = Completer();
    HttpClient client = new HttpClient();
    var _downloadData = List<int>();
    client.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) {

      if (response.statusCode > 399) {
        completer.complete(null);
      } else {
        response
            .transform(utf8.decoder)
            .transform(json.decoder)
            .listen((c) => jsonResponse = c, onDone: () {
           super._getImageBytes(jsonResponse['graphql']['user']['profile_pic_url_hd'] + '&s=$size').then((bytes) => completer.complete(bytes));
        });
      }
    }).catchError((e) => completer.complete(null));
    return completer.future;
  }

  @override
  String getAvatarUrl() =>
      'https://www.instagram.com/$username/?__a=1';
}
