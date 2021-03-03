part of 'package:avatars/avatars.dart';

class Avatar extends StatefulWidget {

  final String facebookId;
  final String gravatar;

  Avatar({this.facebookId, this.gravatar});

  @override
  _AvatarState createState() => _AvatarState();

}

class _AvatarState extends State<Avatar> {

  Source _source;
  AvatarData _avatarData;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    if (this.widget.facebookId != null) {
      _source = FacebookSource(this.widget.facebookId, '');
    } else if (this.widget.gravatar != null) {
      _source = GravatarSource(this.widget.gravatar);
    }

    _source.getAvatar(200).then((ad) {
      _avatarData = ad;
      loading = false;
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    return _buildAvatar();
  }

  Widget _buildAvatar() {
    if (loading) {
      return Text("Carica");
    }
    ImageProvider image = CachedNetworkImageProvider(_avatarData.imageUrl);
    return CircleAvatar(
      backgroundImage: _avatarData.imageUrl != null ? image : null,
      backgroundColor: Colors.brown.shade800,
      child: _avatarData.imageUrl != null ? null : Text("OK"),
      radius: 30,
    );
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
    return Future.value(AvatarData(imageUrl: 'https://graph.facebook.com/$facebookId/picture?width=$size&height=$size'));
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