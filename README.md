# Undraw.co for Flutter

A Flutter package to use [undraw.co](https://undraw.co) illustrations in your app. With also the ability to change the color of the illustrations.

## Getting Started

Run the following command:

```bash
flutter pub add flutter_undraw
```

## Usage

```dart
import 'package:flutter_undraw/flutter_undraw.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Undraw(
          illustration: UndrawIllustration.bugFixing,
          color: Colors.red,
        ),
      ),
    );
  }
}

```

## License

[MIT](./LICENSE)

> NB: This package is not affiliated with undraw.co. Every illustration is Licensed by undraw.co.
> This library only provides a way to use the illustrations in your Flutter app. So, we won't be
> responsible for any misuse of the illustrations' license.
> 
> Although these illustrations are also MIT licensed.
