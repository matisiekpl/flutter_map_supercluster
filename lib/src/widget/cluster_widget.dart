import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_supercluster/src/layer/anchor_util.dart';
import 'package:flutter_map_supercluster/src/layer/flutter_map_state_extension.dart';
import 'package:flutter_map_supercluster/src/layer_element_extension.dart';
import 'package:supercluster/supercluster.dart';

import '../layer/cluster_data.dart';
import '../layer/supercluster_layer.dart';

class ClusterWidget extends StatelessWidget {
  final LayerCluster<Marker> cluster;
  final ClusterWidgetBuilder builder;
  final VoidCallback onTap;
  final Size size;
  final Point<double> position;
  final double mapRotationRad;
  final Alignment rotationAlignment;

  ClusterWidget({
    Key? key,
    required MapCamera mapCamera,
    required this.cluster,
    required this.builder,
    required this.onTap,
    required this.size,
    required Alignment? alignment,
  })  : position = _getClusterPixel(
          mapCamera,
          cluster,
          alignment ?? Alignment.center,
          size,
        ),
        mapRotationRad = mapCamera.rotationRad,
        rotationAlignment = (alignment ?? Alignment.center) * -1,
        super(key: ValueKey(cluster.uuid));

  @override
  Widget build(BuildContext context) {
    final clusterData = cluster.clusterData as ClusterData;

    return Positioned(
      width: size.width,
      height: size.height,
      left: position.x,
      top: position.y,
      child: Transform.rotate(
        angle: -mapRotationRad,
        alignment: rotationAlignment,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: builder(
            context,
            cluster.latLng,
            clusterData.markerCount,
            clusterData.innerData,
          ),
        ),
      ),
    );
  }

  static Point<double> _getClusterPixel(
    MapCamera mapCamera,
    LayerCluster<Marker> cluster,
    Alignment alignment,
    Size size,
  ) {
    return AnchorUtil.removeClusterAnchor(
      mapCamera.getPixelOffset(cluster.latLng),
      alignment,
      size.width,
      size.height,
    );
  }
}
