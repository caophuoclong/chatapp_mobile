import 'package:bebes/app/config/index.dart';
import 'package:flutter/material.dart';

class Utils {
  static customCircleImage(String url, {double radius = 30}) {
    return CircleAvatar(
      backgroundImage: NetworkImage(ConfigService.renderServerImageUrl(url)),
      onBackgroundImageError: (exception, stackTrace) => CircleAvatar(
        backgroundImage: NetworkImage("https://picsum.photos/200"),
        radius: radius,
      ),
      radius: radius,
    );
  }
}
