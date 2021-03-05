# avatars

A complete avatar widget with a **priority & fallback** system which allows you to specify multiple image sources like socials (Facebook, Instagram, GitHub, Gravatar) and custom providers (assets and network) or to use text (name initials or custom values). 

The widget will automatically find the best available image/text source among those provided.

![Avatars examples](/screenshots/example.png)

# Installation

In your `pubspec.yaml` file within your Flutter Project: 
         
    dependencies:
       avatars: ^1.0.0

# Usage

## Basic - text
         
   ```dart
  import 'package:avatars/avatars.dart';
   
  //...
  Avatar(name: 'Alberto Fecchi'),
  Avatar(value: '89'),
  //...
   ```

Using `name` property, the widget displays **up to two** initial letters found in the provided string.
Using `value` property, the widget displays the exact provided string.

Avatar's background is calculated from a default list of `Color()`. You can use a custom set of colors using `placeholderColors`:

```dart

  //...
  Avatar(
    name: 'Alberto Fecchi',
    placeholderColors: [
      Color(0xFFFF0000),
      Color(0xFFFFFF00),
      //...
    ] 
  ),
  //...
```

## Basic - images

An **image source** is an object used to generate, from local or remote sources, an `ImageProvider()` that will be used to show a picture inside the widget.

The `sources` list in `Avatar()` widget can contain multiple image sources: here, the **priority & fallback** system shows its power. If the first image source fails, the widget will try with the next one until a valid image source is found. If there are no sources available, the widget will use `name` or `value` data as seen in the previous example.

```dart

  //...
  Avatar(
    sources: [
      GitHubSource('luckyseven'),
      //...
    ]   
  ),
  //...
```

Here's the complete set of available image sources:

### Socials

#### FacebookSource
Since Sep. 2020, to retrieve a user's profile picture by its ID from Facebook, you must make the request with an App Token or an Access Token.
You can find more info [here](https://developers.facebook.com/docs/graph-api/reference/user/picture/).
```dart
  FacebookSource(String facebookId, String appToken, [int size = 300])
```

#### GitHubSource
You can retrieve a GitHub profile image from user's username.
```dart
  GitHubSource(String username, [int size = 300])
```

#### GravatarSource
You can retrieve a Gravatar using the user e-mail address or its hash.
```dart
  GravatarSource(String identifier, [int size = 300])
```

#### InstagramSource
You can retrieve an Instagram profile picture using a username.
```dart
  InstagramSource(String username, [int size = 300])
```

### Remote and local sources

#### NetworkSource
You can retrieve an image from any remote source.
```dart
  NetworkSource(String url)
```

#### GenericSource
GenericSource is generally used as a *jolly* image source: you can pass an `ImageProvider()` to show a picture.
```dart
  GenericSource(ImageProvider image)
```

## Shape, dimension, border and color

You can pass an `AvatarShape()` object to the widget using the `shape` property. For common shapes, the `AvatarShape` class provides helper methods like `circle(double radius)`, `square(double size)`, `roundedSquare(double size, double borderRadius)`:

   ```dart
  //...
  Avatar(name: 'Alberto Fecchi', shape: AvatarShape(width: 50, height: 70, borderRadius: 10),
  Avatar(name: 'Alberto Fecchi', shape: AvatarShape.circle(50),
  Avatar(name: 'Alberto Fecchi', shape: AvatarShape.square(100),
  Avatar(name: 'Alberto Fecchi', shape: AvatarShape.roundedSquare(100, 10),
  //...
   ```

Here's a list of other parameters which allows you to change the appearance of your avatars:

Parameter			| Type				| Default		| Description
---						| ---					| ---				| ---
`backgroundColor`		| `Color`	| `Colors.transparent`		| The background color used when the image is loading and/or when you load a transparent PNG.
`border`		| `Border`	| `null`		| You can pass a `Border` object here. Ex. `Border.all(color: Colors.blue, width: 3)`.
`elevation`		| `double`		| `0`		| The standard Material elevation.
`loader`		| `Widget`		| `Center(child: CircularProgressIndicator())`		| You can pass any custom Widget to replace the default loader.
`textStyle`		| `TextStyle`		| `TextStyle(color: Colors.white, fontSize: height / 2);`		| The TextStyle used when your widget uses text values from `name` or `value` parameters.

## Gestures

You can use `onTap` to pass a callback function:

   ```dart
  //...
  Avatar(
    onTap: () {
      print("Tap!")
    }),
  )
  //...
   ```

## Cache

This package uses `flutter_cache_manager` as dependency. The `useCache` set to `true` enables cache for every remote image request, improving performances. The default cache expiration is set to **7 days**.

  ```dart
 //...
 Avatar(
   useCache: true
 )
 //...
  ```

## Suggestions, improvements, issues and more

**Have you used this package in your project?**

Say hello with a [tweet](https://twitter.com/luckysevenrox)!

**Wanna improve this package?**

The library source code lives inside the demo project on [GitHub](https://github.com/luckyseven/avatars). Fork it and work! ;)

**Need support?**

Feel free to contact me at [alberto.fecchi@gmail.com](alberto.fecchi@gmail.com) or just open an issue on the official repository on [GitHub](https://github.com/luckyseven/avatars).

## License

> MIT License - Copyright (c) Alberto Fecchi

Full license [here](LICENSE)