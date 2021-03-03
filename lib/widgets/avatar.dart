part of 'package:avatars/avatars.dart';

class Avatar extends StatefulWidget {

  final List<Source> sources;
  final String facebookId;
  final String gravatar;

  Avatar({this.sources, this.facebookId, this.gravatar});

  @override
  _AvatarState createState() => _AvatarState();

}

class _AvatarState extends State<Avatar> {

  Source _source;
  AvatarData _avatarData;

  bool found = false;

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return _bestSource();
  }

  Widget _bestSource() {
    if (found) {
      // return CircleAvatar(
      //   backgroundImage: CachedNetworkImageProvider(_avatarData.imageUrl),
      //   backgroundColor: Colors.brown.shade800,
      //   radius: 30,
      //   onBackgroundImageError: (a, b) {
      //     found = false;
      //     setState(() {});
      //   },
      // );
      return Image(image: CachedNetworkImageProvider(_avatarData.imageUrl));
    }
    if (this.widget.sources.length > 0) {
      Source current = this.widget.sources.first;
      this.widget.sources.removeAt(0);

      print("PROVO UNO");

      current.getAvatar(200).then((ad) {
        _avatarData = ad;
        found = true;
        setState(() {});
      });
    }
    return CircleAvatar(
      backgroundColor: Colors.brown.shade800,
      child: _loader(),
      radius: 30,
    );
  }

  Widget _loader() {
    return CircularProgressIndicator();
  }

}

abstract class Source {
  Future<AvatarData> getAvatar(int size);
}

class FacebookSource implements Source {
  String facebookId;
  String appToken; // Since Sep 2020 you need to use an App Token to get user's profile pictures

  FacebookSource(this.facebookId, this.appToken);

  @override
  Future<AvatarData> getAvatar(int size) {
    return Future.value(AvatarData(imageUrl: 'https://graphaaa.facebook.com/$facebookId/picture?width=$size&height=$size'));
  }
}

class GravatarSource implements Source {
  String identifier; // Mail or Hash

  GravatarSource(this.identifier);

  @override
  Future<AvatarData> getAvatar(int size) {
    String hash = identifier;
    RegExp matcher = RegExp(r'^[a-f0-9]{32}$');
    if (!matcher.hasMatch(hash)) {
      hash = md5.convert(utf8.encode(identifier)).toString();
    }
    return Future.value(AvatarData(imageUrl: 'https://secure.gravatar.com/avatar/$hash?s=$size&d=404'));
  }
}

class AvatarData {
  String imageUrl;
  String name;
  String value;

  AvatarData({this.imageUrl, this.name, this.value});
}