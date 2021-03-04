part of 'package:avatars/avatars.dart';

class AvatarShape {
  double width;
  double height;
  BorderRadius borderRadius;

  static AvatarShape circle(double radius) => AvatarShape(width: radius * 2, height: radius * 2, borderRadius: BorderRadius.circular(radius));

  static AvatarShape square(double size) => AvatarShape(width: size, height: size, borderRadius: BorderRadius.zero);

  static AvatarShape roundedSquare(double size, double borderRadius) => AvatarShape(width: size, height: size, borderRadius: BorderRadius.circular(borderRadius));

  AvatarShape({this.width, this.height, this.borderRadius});

}

class Avatar extends StatefulWidget {
  final List<Source> sources;
  final String name;
  final String value;

  final double elevation;
  final double radius;
  final double size;

  final AvatarShape shape;

  final Border border;

  Avatar({this.border, this.elevation = 0, this.name, this.radius = 50, this.shape, this.size, this.sources, this.value});

  @override
  _AvatarState createState() => _AvatarState();

}

class _AvatarState extends State<Avatar> {

  bool _loading = true;

  Widget _avatar;
  AvatarShape _shape;

  @override
  void initState() {
    _shape = this.widget.shape;
    if (_shape == null) {
      _shape = AvatarShape.circle(50);
    }
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
    return _avatar;
  }

  Future<Widget> _buildBestAvatar() async {
    ImageProvider avatar;
    if (this.widget.sources != null && this.widget.sources.length > 0) {
      for (int i = 0; i < this.widget.sources.length; i++) {
        avatar = await this.widget.sources.elementAt(i).getAvatar();
        if (avatar != null) {
          return _imageAvatar(avatar);
        }
      }
    }
    if (this.widget.name != null) {
      List<String> nameParts = this.widget.name.split(' ');
      String initials = nameParts.map((p) => p.substring(0, 1)).join('');
      return _textAvatar(initials.substring(0, initials.length >= 2 ? 2 : initials.length));
    }
    if (this.widget.value != null) {
      return _textAvatar(this.widget.value);
    }
  }

  Widget _loader() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }


  Widget _imageAvatar(ImageProvider avatar) {
    return Container(
      width: this.widget.shape.width,
      height: this.widget.shape.height,
      decoration: BoxDecoration(
        border: this.widget.border,
        borderRadius: _shape.borderRadius,
        image: DecorationImage(
          image: avatar,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _textAvatar(String text) {
    return _baseAvatar(
        Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: this.widget.shape.height / 2
            ),
          ),
        )
    , Colors.orange);
  }

  Widget _baseAvatar(Widget _content, [Color color = Colors.transparent]) {
    return Material(
      type: MaterialType.circle,
      color: Colors.transparent,
      elevation: this.widget.elevation,
      child: Container(
        clipBehavior: Clip.hardEdge,
        width: _shape.width,
        height: _shape.height,
        decoration: BoxDecoration(
            border: this.widget.border,
            borderRadius: _shape.borderRadius,
            color: color
        ),
        child: _content,
      ),
    );
  }
}

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
  ImageProvider image; // Mail or Hash

  PlaceholderSource(this.image);

  @override
  String getAvatarUrl() => null;

  @override
  Future<ImageProvider> getAvatar() => Future.value(image);

}