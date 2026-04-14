import 'dart:math';

import 'package:flutter/widgets.dart';

class AnchorUtil {
  static Point<double> removeClusterAnchor(
    Point pos,
    Alignment clusterAlignment,
    double width,
    double height,
  ) {
    return removeAlignment(pos, width, height, clusterAlignment);
  }

  static Point<double> removeAlignment(
    Point pos,
    double width,
    double height,
    Alignment alignment,
  ) {
    final x = (pos.x + alignment.x * width / 2 - width / 2).toDouble();
    final y = (pos.y + alignment.y * height / 2 - height / 2).toDouble();
    return Point(x, y);
  }
}
