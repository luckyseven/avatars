part of 'package:avatars/avatars.dart';

class GitHubSource extends Source {
  String username;
  int size;

  GitHubSource(this.username, [this.size = 300]);

  Future<Uint8List?> _getImageBytes(String url) async {
    Completer<Uint8List> completer = Completer();

    try {
      HttpClient client = new HttpClient();

      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();

      if (response.statusCode > 399) {
        completer.complete(null);
      } else {
        Map<String, dynamic> jsonResponse = {};
        await for (var data
            in response.transform(utf8.decoder).transform(json.decoder)) {
          jsonResponse.addAll(data as Map<String, dynamic>);
        }

        Uint8List? bytes =
            await super._getImageBytes(jsonResponse['avatar_url']);
        if (bytes != null) {
          completer.complete(Uint8List.fromList(bytes));
        } else {
          completer.complete(null);
        }
      }
    } catch (e) {
      completer.complete(null);
    }

    return completer.future;
  }

  @override
  String getAvatarUrl() => 'https://api.github.com/users/$username';
}
