part of 'package:avatars/avatars.dart';

class Avatar extends StatefulWidget {
  final List<Source> sources;
  final String name;
  final String value;

  final double elevation;
  final double radius;

  Avatar({this.elevation = 0, this.name, this.radius = 50, this.sources, this.value});

  @override
  _AvatarState createState() => _AvatarState();

}

class _AvatarState extends State<Avatar> {

  bool _loading = true;

  Widget _avatar;

  @override
  void initState() {
    _buildBestAvatar().then((a) => setState((){
      _avatar = a;
      _loading = false;
    }));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return _loader();
    }
    return Material(
      type: MaterialType.circle,
      color: Colors.orange,
      elevation: this.widget.elevation,
      child: Container(
        width: this.widget.radius * 2,
        height: this.widget.radius * 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(this.widget.radius),
          child:  _avatar,
        ),
      ),
    );
  }

  Future<Widget> _buildBestAvatar() async {
    Image avatar;
    if (this.widget.sources != null && this.widget.sources.length > 0) {
      for (int i = 0; i < this.widget.sources.length; i++) {
        avatar = await this.widget.sources.elementAt(i).getAvatar();
        if (avatar != null) {
          return avatar;
        }
      }
    }
    if (this.widget.name != null) {
      List<String> nameParts = this.widget.name.split(' ');
      return Text(nameParts.map((p) => p.substring(0,1)).join('').substring(0,2));
    }
    if (this.widget.value != null) {
      return Text(this.widget.value);
    }
  }

  Widget _loader() {
    return CircularProgressIndicator();
  }

}

abstract class Source {
  bool _cached = false;
  Image _cache;

  String getAvatarUrl();

  Future<Image> getAvatar() {
    if (_cached) {
      return Future.value(_cache);
    }
    return _getImageBytes(getAvatarUrl()).then((bytes) {
      if (bytes != null) {
        _cached = true;
        _cache = Image.memory(bytes);
        return _cache;
      }
      return null;
    });
  }

  Future<Uint8List> _getImageBytes(String url) {
    Completer<Uint8List> completer = Completer();
    HttpClient client = new HttpClient();
    var _downloadData = List<int>();
    client.getUrl(Uri.parse(url))
        .then((HttpClientRequest request) {
          return request.close();
        })
        .then((HttpClientResponse response) {
          if (response.statusCode > 399 || !['image/jpeg', 'image/png'].contains(response.headers.contentType.toString())) {
            completer.complete(null);
          } else {
            response.listen(
              (d) => _downloadData.addAll(d),
              onDone: () {
                completer.complete(Uint8List.fromList(_downloadData));
              }
            );
          }
        }).catchError((e) => completer.complete(null));
    return completer.future;
  }
}

class FacebookSource extends Source {
  String facebookId;
  String appToken; // Since Sep 2020 you need to use an App Token to get user's profile pictures
  int size;

  FacebookSource(this.facebookId, this.appToken, [this.size = 500]);

  @override
  String getAvatarUrl() => 'https://graph.facebook.com/$facebookId/picture?width=$size&height=$size';

}

class GravatarSource extends Source {
  String identifier; // Mail or Hash
  int size;

  GravatarSource(this.identifier, [this.size = 500]);

  @override
  String getAvatarUrl() {
    String hash = identifier;
    RegExp matcher = RegExp(r'^[a-f0-9]{32}$');
    if (!matcher.hasMatch(hash)) {
      hash = md5.convert(utf8.encode(identifier)).toString();
    }
    return 'https://secure.gravatar.com/avatar/$hash?s=$size&d=404';
  }

}

class PlaceholderSource extends Source {
  Image image; // Mail or Hash

  PlaceholderSource(this.image);

  @override
  String getAvatarUrl() => null;

  @override
  Future<Image> getAvatar() => Future.value(image);

}