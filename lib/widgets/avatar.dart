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

class Avatar extends StatefulWidget {
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

  Avatar({
    this.backgroundColor = Colors.transparent,
    this.border,
    this.elevation = 0,
    this.margin,
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
  })  : this.placeholderColors = placeholderColors ??
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
        this.textStyle = textStyle ??
            TextStyle(
              color: Colors.white,
              fontSize: shape != null ? shape.height / 2 : 50,
            );
  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  bool _loading = true;

  Widget? _avatar;

  @override
  void initState() {
    super.initState();
    _buildBestAvatar().then((a) {
      if (mounted) {
        setState(() {
          _avatar = a;
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return _loader();
    }
    return _avatar!;
  }

  Future<Widget> _buildBestAvatar() async {
    ImageProvider? avatar;
    List<Source>? sources = this.widget.sources;

    if (sources != null && sources.length > 0) {
      for (int i = 0; i < sources.length; i++) {
        avatar = await sources.elementAt(i).getAvatar(this.widget.useCache);
        if (avatar != null) {
          return _imageAvatar(avatar);
        }
      }
    }
    if (this.widget.name != null) {
      List<String> nameParts = this.widget.name!.split(' ');
      String initials = nameParts.map((p) => p.substring(0, 1)).join('');
      return _textAvatar(
          initials.substring(0, initials.length >= 2 ? 2 : initials.length));
    }

    return _textAvatar(this.widget.value ?? "");
  }

  Widget _loader() {
    return _baseAvatar(Container(
      width: this.widget.shape!.width,
      height: this.widget.shape!.height,
      decoration: BoxDecoration(
        border: this.widget.border,
        borderRadius: this.widget.shape!.shapeBorder.borderRadius,
        color: this.widget.backgroundColor,
      ),
      child: this.widget.loader,
    ));
  }

  Widget _imageAvatar(ImageProvider avatar) {
    return _baseAvatar(Container(
      width: this.widget.shape!.width,
      height: this.widget.shape!.height,
      decoration: BoxDecoration(
        border: this.widget.border,
        borderRadius: this.widget.shape!.shapeBorder.borderRadius,
        color: this.widget.backgroundColor,
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
      width: this.widget.shape!.width,
      height: this.widget.shape!.height,
      decoration: BoxDecoration(
        border: this.widget.border,
        borderRadius: this.widget.shape!.shapeBorder.borderRadius,
        color: this
            .widget
            .placeholderColors[textCode % this.widget.placeholderColors.length],
      ),
      child: Center(
        child: Text(
          text,
          style: this.widget.textStyle,
        ),
      ),
    ));
  }

  Widget _baseAvatar(Widget _content) {
    return GestureDetector(
      onTap: this.widget.onTap,
      child: Card(
        shadowColor: this.widget.shadowColor,
        elevation: this.widget.elevation,
        shape: this.widget.shape!.shapeBorder,
        margin: this.widget.margin,
        child: _content,
      ),
    );
  }
}
