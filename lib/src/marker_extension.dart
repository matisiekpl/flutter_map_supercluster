import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';

extension MarkerExtension on Marker {
  Alignment get effectiveAlignment => alignment ?? Alignment.center;
}
