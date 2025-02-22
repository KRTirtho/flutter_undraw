library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import './src/collection/undraw_illustration.dart';
export './src/collection/undraw_illustration.dart';

class Undraw extends StatefulWidget {
  const Undraw({
    super.key,
    required this.illustration,
    this.color = const Color(0xFF6C63FF),
    this.semanticLabel,
    this.alignment = Alignment.center,
    this.fit = BoxFit.contain,
    this.colorFilter,
    this.height,
    this.width,
    this.placeholder,
    this.errorWidget,
    this.padding,
    this.useMemCache = true,
  });

  /// Enum [UnDrawIllustration] with all supported illustrations
  final UndrawIllustration illustration;

  /// The color that will replaced for illustration
  final Color color;

  /// The [Semantics.label] for this picture.
  ///
  /// The value indicates the purpose of the picture, and will be
  /// read out by screen readers.
  final String? semanticLabel;

  /// How to align the picture within its parent widget.
  ///
  /// The alignment aligns the given position in the picture to the given position
  /// in the layout bounds. For example, an [Alignment] alignment of (-1.0,
  /// -1.0) aligns the image to the top-left corner of its layout bounds, while a
  /// [Alignment] alignment of (1.0, 1.0) aligns the bottom right of the
  /// picture with the bottom right corner of its layout bounds. Similarly, an
  /// alignment of (0.0, 1.0) aligns the bottom middle of the image with the
  /// middle of the bottom edge of its layout bounds.
  ///
  /// If the [alignment] is [TextDirection]-dependent (i.e. if it is a
  /// [AlignmentDirectional]), then a [TextDirection] must be available
  /// when the picture is painted.
  ///
  /// Defaults to [Alignment.center].
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final AlignmentGeometry alignment;

  /// How to inscribe the picture into the space allocated during layout.
  /// The default is [BoxFit.contain].
  final BoxFit fit;

  /// The `color` and `colorBlendMode` arguments, if specified, will be used to set a
  /// [ColorFilter] on any [Paint]s created for this drawing.
  final ColorFilter? colorFilter;

  /// If specified, the width to use for the SVG.  If unspecified, the SVG
  /// will take the width of its parent.
  final double? width;

  /// If specified, the height to use for the SVG.  If unspecified, the SVG
  /// will take the height of its parent.
  final double? height;

  /// The widget that will appear during loading illustration from the internet
  final Widget? placeholder;

  /// The widget that will appear if occurs an error
  final Widget? errorWidget;

  /// Empty space to inscribe inside the [decoration]. The [child], if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  final EdgeInsets? padding;

  /// If cache image in memory, if enable reload the same illustration is be more fast
  final bool useMemCache;

  @override
  State<Undraw> createState() => _UndrawState();
}

class _UndrawState extends State<Undraw> {
  Future<String> renderIllustration(
    BuildContext context,
  ) async {
    String image = await DefaultAssetBundle.of(
      context,
    ).loadString("packages/flutter_undraw/${widget.illustration.path}");

    String valueString = widget.color.value.toRadixString(16).substring(2);
    return image.replaceAll("#6c63ff", "#$valueString");
  }

  late Future<String> illustrationFuture;

  @override
  void initState() {
    super.initState();
    illustrationFuture = renderIllustration(context);
  }

  @override
  void didUpdateWidget(covariant Undraw oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.illustration != widget.illustration ||
        oldWidget.color != widget.color) {
      illustrationFuture = renderIllustration(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: illustrationFuture,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: widget.padding ?? EdgeInsets.all(16),
            child: SvgPicture.string(
              snapshot.data!,
              height: widget.height,
              width: widget.width,
              alignment: widget.alignment,
              colorFilter: widget.colorFilter,
              fit: widget.fit,
              semanticsLabel: widget.semanticLabel,
            ),
          );
        } else if (snapshot.hasError) {
          if (kDebugMode &&
              snapshot.error is FlutterError &&
              (snapshot.error as FlutterError)
                  .message
                  .contains('Unable to load asset: ') &&
              widget.errorWidget == null) {
            return Center(
              child: SelectableText(
                'Illustration not found in the AssetBundle.\n'
                'Did you forget to add \n'
                'packages/flutter_undraw/${widget.illustration.path}\n'
                'in your pubspec.yaml file\'s assets?',
              ),
            );
          }

          return Center(
            child: widget.errorWidget ?? Text('Could not load illustration!'),
          );
        } else {
          return Center(
            child: widget.placeholder ?? CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
