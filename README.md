# avatars

A complete avatar widget with a **priority & fallback** system that allow to specify multiple image sources like socials (Facebook, Instagram, GitHub, Gravatar) and custom providers (assets and network) or to use text (name initials or custom values). 

The widget will automatically find the best available image/text source. 

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

An **image source** is a class used to generate, from local or remote sources, an `ImageProvider()` that will be used to show a picture inside the widget.

The `sources` list in `Avatar()` widget can contain multiple image sources: is here that the *priority & fallback* system shows its power. If the first image source fails, the widget will try with the next one until a valid image source is found. If there are no sources available, the widget will use `name` or `value` data as seen in the previous example. 

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

#### LocalSource
LocalSource is generally used as a *jolly* image source: you can use any ImageProvider with it.
```dart
  LocalSource(ImageProvider image)
```

