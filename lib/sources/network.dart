part of 'package:avatars/avatars.dart';

class NetworkSource extends Source {
  String url;

  NetworkSource(this.url);

  @override
  String getAvatarUrl() => this.url;
}
