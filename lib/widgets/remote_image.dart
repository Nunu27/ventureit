import 'package:flutter/widgets.dart';
import 'package:ventureit/constants/constants.dart';

class RemoteImage extends StatelessWidget {
  final String url;
  final BoxFit? fit;
  final double? height;
  final double? width;

  const RemoteImage({
    super.key,
    required this.url,
    this.fit,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      image: NetworkImage(url),
      placeholder: const AssetImage(Constants.imagePlaceholder),
      imageErrorBuilder: (context, error, stackTrace) => Image.asset(
        Constants.imagePlaceholder,
        fit: fit,
        height: height,
        width: width,
      ),
      fit: fit,
      height: height,
      width: width,
    );
  }
}
