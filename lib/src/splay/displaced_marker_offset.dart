import 'dart:math';

import 'package:flutter_map_supercluster/src/splay/displaced_marker.dart';

/// Pixel positions for a [Marker] which has been displaced from its original
/// position.
class DisplacedMarkerOffset {
  final DisplacedMarker displacedMarker;
  final Point<double> displacedOffset;
  final Point<double> originalOffset;

  const DisplacedMarkerOffset({
    required this.displacedMarker,
    required this.displacedOffset,
    required this.originalOffset,
  });
}
