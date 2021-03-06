import 'package:flutter/material.dart';
import 'package:avatars/avatars.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avatars Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Avatars Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Avatar(
              sources: [
                GitHubSource('luckyseven'),
                InstagramSource(
                    'alberto.fecchi'), // Fallback if GitHubSource is not available
              ],
              name:
                  'Alberto Fecchi', // Fallback if no image source is available
            ),
            Avatar(
              elevation: 3,
              shape: AvatarShape.rectangle(
                  100, 100, BorderRadius.all(new Radius.circular(20.0))),
              name: 'Alberto Fecchi', // Uses name initials (up to two)
            ),
          ],
        ),
      ),
    );
  }
}
