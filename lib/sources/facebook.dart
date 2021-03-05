part of 'package:avatars/avatars.dart';

class FacebookSource extends Source {
  String facebookId;
  String
      appToken; // Since Sep 2020 you need to use an App Token to get user's profile pictures
  int size;

  FacebookSource(this.facebookId, this.appToken, [this.size = 300]);

  @override
  String getAvatarUrl() =>
      'https://graph.facebook.com/$facebookId/picture?width=$size&height=$size';
}
