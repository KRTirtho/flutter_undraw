# Undraw.co for Flutter

A Flutter package to use [undraw.co](https://undraw.co) illustrations in your app. With also the ability to change the color of the illustrations.

## Getting Started

Run the following command:

```bash
flutter pub add flutter_undraw
```

## Usage

First use the, `Undraw` widget to display the illustration. 
The `illustration` property is required and it should be one of the `UndrawIllustration` enum values.
You can also change the color of the illustration by setting the `color` property. 
It'll change the primary color of the illustration.
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

For the sake of treeshaking and saving space, the illustrations you use, must also be added to your pubspec.yaml file.
```yaml
flutter:
  assets:
    - packages/flutter_undraw/assets/illustrations/bug_fixing.svg
```

Usually, the illustration file names are the same as the enum values but in snake case. If you can't guess it, you can
just use it and an error will be thrown with the correct file path.

If you want to use all of the illustrations, you can just import the whole folder of illustrations instead of importing
them one by one.
```yaml
flutter:
  assets:
    - packages/flutter_undraw/assets/illustrations/
```

## License

[MIT](./LICENSE)

> NB: This package is not affiliated with undraw.co. Every illustration is Licensed by undraw.co.
> This library only provides a way to use the illustrations in your Flutter app. So, we won't be
> responsible for any misuse of the illustrations' license.
> 
> Although these illustrations are also MIT licensed.
