part of 'package:avatars/avatars.dart';

class AvatarShape {
  double width;
  double height;
  RoundedRectangleBorder shapeBorder;

  static AvatarShape circle(double radius) => AvatarShape(
      width: radius * 2,
      height: radius * 2,
      shapeBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)));

  static AvatarShape rectangle(double width, double height,
          [BorderRadius borderRadius = BorderRadius.zero]) =>
      AvatarShape(
          width: width,
          height: height,
          shapeBorder: RoundedRectangleBorder(borderRadius: borderRadius));

  AvatarShape(
      {required this.width, required this.height, required this.shapeBorder});
}

class Avatar extends StatelessWidget {
  final List<Source>? sources;
  final String? name;
  final String? value;

  final double? elevation;
  final AvatarShape? shape;
  final EdgeInsetsGeometry? margin;

  final Border? border;
  final Color backgroundColor;
  final List<Color> placeholderColors;
  final Widget? loader;
  final Color? shadowColor;
  final TextStyle textStyle;
  final bool useCache;

  final GestureTapCallback? onTap;

  Avatar(
      {this.backgroundColor = Colors.transparent,
      this.border,
      this.elevation = 0,
      this.name,
      this.onTap,
      this.shadowColor,
      this.sources,
      this.useCache = false,
      this.value,
      Widget? loader,
      List<Color>? placeholderColors,
      AvatarShape? shape,
      TextStyle? textStyle,
      EdgeInsetsGeometry? margin})
      : this.placeholderColors = placeholderColors ??
            [
              Color(0xFF1abc9c),
              Color(0xFFf1c40f),
              Color(0xFF8e44ad),
              Color(0xFFe74c3c),
              Color(0xFFd35400),
              Color(0xFF2c3e50),
              Color(0xFF7f8c8d),
            ],
        this.shape = shape ?? AvatarShape.circle(50),
        this.loader = loader ?? Center(child: CircularProgressIndicator()),
        this.margin = margin ?? EdgeInsets.all(0),
        this.textStyle = textStyle ??
            TextStyle(
              color: Colors.white,
              fontSize: shape != null ? shape.height / 2 : 50,
            );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
        future: _buildBestAvatar(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return _loader();
          }
        });
  }

  Future<Widget> _buildBestAvatar() async {
    ImageProvider? avatar;
    List<Source>? sources = this.sources;

    if (sources != null && sources.length > 0) {
      for (int i = 0; i < sources.length; i++) {
        avatar = await sources.elementAt(i).getAvatar(this.useCache);
        if (avatar != null) {
          return _imageAvatar(avatar);
        }
      }
    }
    if (this.name != null) {
      List<String> nameParts = this.name!.split(' ');
      String initials = nameParts.map((p) => p.substring(0, 1)).join('');
      return _textAvatar(
          initials.substring(0, initials.length >= 2 ? 2 : initials.length));
    }

    return _textAvatar(this.value ?? "");
  }

  Widget _loader() {
    return _baseAvatar(Container(
      width: this.shape!.width,
      height: this.shape!.height,
      decoration: BoxDecoration(
        border: this.border,
        borderRadius: this.shape!.shapeBorder.borderRadius,
        color: this.backgroundColor,
      ),
      child: this.loader,
    ));
  }

  Widget _imageAvatar(ImageProvider avatar) {
    return _baseAvatar(Container(
      width: this.shape!.width,
      height: this.shape!.height,
      decoration: BoxDecoration(
        border: this.border,
        borderRadius: this.shape!.shapeBorder.borderRadius,
        color: this.backgroundColor,
        image: DecorationImage(
          image: avatar,
          fit: BoxFit.cover,
        ),
      ),
    ));
  }

  Widget _textAvatar(String text) {
    int textCode = text
        .split('')
        .map((l) => l.codeUnitAt(0))
        .reduce((previous, current) => previous + current);

    return _baseAvatar(Container(
      width: this.shape!.width,
      height: this.shape!.height,
      decoration: BoxDecoration(
        border: this.border,
        borderRadius: this.shape!.shapeBorder.borderRadius,
        color: this.placeholderColors[textCode % this.placeholderColors.length],
      ),
      child: Center(
        child: Text(
          text,
          style: this.textStyle,
        ),
      ),
    ));
  }

  Widget _baseAvatar(Widget _content) {
    return GestureDetector(
      onTap: this.onTap,
      child: Card(
        shadowColor: this.shadowColor,
        elevation: this.elevation,
        shape: this.shape!.shapeBorder,
        margin: this.margin,
        child: _content,
      ),
    );
  }
}
