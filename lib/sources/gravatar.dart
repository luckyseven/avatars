part of 'package:avatars/avatars.dart';

class GravatarSource extends Source {
  String identifier; // Mail or Hash
  int size;

  GravatarSource(this.identifier, [this.size = 300]);

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
