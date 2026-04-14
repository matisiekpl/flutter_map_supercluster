import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_supercluster/src/layer/anchor_util.dart';
import 'package:flutter_map_supercluster/src/layer/flutter_map_state_extension.dart';
import 'package:flutter_map_supercluster/src/marker_extension.dart';
import 'package:flutter_map_supercluster/src/splay/displaced_marker.dart';

class MarkerWidget extends StatelessWidget {
  final Marker marker;
  final Widget markerChild;
  final VoidCallback onTap;
  final Point<double> position;
  final double mapRotationRad;
  final Alignment rotationAlignment;

  MarkerWidget({
    super.key,
    required MapCamera mapCamera,
    required this.marker,
    required this.markerChild,
    required this.onTap,
  })  : mapRotationRad = mapCamera.rotationRad,
        position = _getMapPointPixel(mapCamera, marker),
        rotationAlignment = marker.effectiveAlignment * -1;

  MarkerWidget.displaced({
    Key? key,
    required DisplacedMarker displacedMarker,
    required Point<double> position,
    required this.markerChild,
    required this.onTap,
    required this.mapRotationRad,
  })  : marker = displacedMarker.marker,
        position = AnchorUtil.removeAlignment(
          position,
          displacedMarker.marker.width,
          displacedMarker.marker.height,
          DisplacedMarker.alignment,
        ),
        rotationAlignment = DisplacedMarker.alignment * -1,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: markerChild,
    );

    return Positioned(
      key: ObjectKey(marker),
      width: marker.width,
      height: marker.height,
      left: position.x,
      top: position.y,
      child: marker.rotate != true
          ? child
          : Transform.rotate(
              angle: -mapRotationRad,
              alignment: rotationAlignment,
              child: child,
            ),
    );
  }

  static Point<double> _getMapPointPixel(
    MapCamera mapCamera,
    Marker marker,
  ) {
    return AnchorUtil.removeAlignment(
      mapCamera.getPixelOffset(marker.point),
      marker.width,
      marker.height,
      marker.effectiveAlignment,
    );
  }
}
