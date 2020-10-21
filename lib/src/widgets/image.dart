import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ImageType {
  network,
  random,
  assets,
}

class WrapperImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final BoxFit fit;
  final ImageType imageType;

  WrapperImage(
      {@required this.url,
      @required this.width,
      @required this.height,
      this.imageType: ImageType.network,
      this.fit: BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null)
      return Image.asset(
        ImageHelper.wrapAssets("error-image.png"),
        width: width,
        height: height,
        fit: fit,
      );

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      placeholder: (_, __) =>
          ImageHelper.placeHolder(width: width, height: height),
      errorWidget: (_, __, ___) =>
          ImageHelper.error(width: width, height: height),
      fit: fit,
    );
  }

  String get imageUrl {
    switch (imageType) {
      case ImageType.random:
        return ImageHelper.randomUrl(
            key: url, width: width.toInt(), height: height.toInt());
      case ImageType.assets:
        return ImageHelper.wrapAssets(url);
      case ImageType.network:
        return url;
    }
    return url;
  }
}

class RoundedImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final BoxFit fit;
  final ImageType imageType;
  final double radius;

  RoundedImage(
      {@required this.url,
      @required this.width,
      @required this.height,
      this.radius: 4.0,
      this.imageType: ImageType.network,
      this.fit: BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: WrapperImage(
        url: url,
        width: width,
        height: height,
        fit: fit,
        imageType: imageType,
      ),
    );
  }
}

class ImageHelper {
  static const String baseUrl = 'http://www.meetingplus.cn';
  static const String imagePrefix = '$baseUrl/uimg/';

  static String wrapUrl(String url) {
    if (url.startsWith('http')) {
      return url;
    } else {}
    return imagePrefix + url;
  }

  static String wrapAssets(String name) {
    return "assets/images/" + name;
  }

  static Widget placeHolder({double width, double height}) {
    return SizedBox(
        width: width,
        height: height,
        child: CupertinoActivityIndicator(radius: min(10.0, width / 3)));
  }

  static Widget error({double width, double height, double size}) {
    return SizedBox(
        width: width,
        height: height,
        child: Icon(
          Icons.error_outline,
          size: size,
        ));
  }

  static String randomUrl(
      {int width = 100, int height = 100, Object key = ''}) {
    return 'http://placeimg.com/$width/$height/${key.hashCode.toString() + key.toString()}';
  }
}
