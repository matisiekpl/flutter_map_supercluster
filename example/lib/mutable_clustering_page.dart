import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';
import 'package:flutter_map_supercluster_example/drawer.dart';
import 'package:flutter_map_supercluster_example/font/accurate_map_icons.dart';
import 'package:latlong2/latlong.dart';

class MutableClusteringPage extends StatefulWidget {
  static const String route = 'mutableClusteringPage';

  const MutableClusteringPage({Key? key}) : super(key: key);

  @override
  State<MutableClusteringPage> createState() => _MutableClusteringPageState();
}

class _MutableClusteringPageState extends State<MutableClusteringPage>
    with TickerProviderStateMixin {
  late final SuperclusterMutableController _superclusterController;
  late final AnimatedMapController _animatedMapController;

  final List<Marker> _initialMarkers = [
    const LatLng(51.5, -0.09),
    const LatLng(53.3498, -6.2603),
    const LatLng(53.3488, -6.2613)
  ].map((point) => _createMarker(point, Colors.black)).toList();

  @override
  void initState() {
    _superclusterController = SuperclusterMutableController();
    _animatedMapController = AnimatedMapController(vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _superclusterController.dispose();
    _animatedMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clustering Page (Mutable)'),
        actions: [
          StreamBuilder<SuperclusterState>(
              stream: _superclusterController.stateStream,
              builder: (context, snapshot) {
                final data = snapshot.data;
                final String markerCountLabel;
                if (data == null ||
                    data.loading ||
                    data.aggregatedClusterData == null) {
                  markerCountLabel = '...';
                } else {
                  markerCountLabel =
                      data.aggregatedClusterData!.markerCount.toString();
                }

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text('Total markers: $markerCountLabel'),
                  ),
                );
              }),
        ],
      ),
      drawer: buildDrawer(context, MutableClusteringPage.route),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _superclusterController.replaceAll(_initialMarkers);
          });
        },
        child: const Icon(Icons.refresh),
      ),
      body: FlutterMap(
        mapController: _animatedMapController.mapController,
        options: MapOptions(
          initialCenter: _initialMarkers[0].point,
          initialZoom: 5,
          maxZoom: 15,
          onTap: (_, latLng) {
            debugPrint(latLng.toString());
            _superclusterController.add(_createMarker(latLng, Colors.blue));
          },
        ),
        children: <Widget>[
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.flutter_map_supercluster_example'
          ),
          SuperclusterLayer.mutable(
            initialMarkers: _initialMarkers,
            indexBuilder: IndexBuilders.rootIsolate,
            controller: _superclusterController,
            moveMap: (center, zoom) => _animatedMapController.animateTo(
              dest: center,
              zoom: zoom,
            ),
            onMarkerTap: (marker) {
              _superclusterController.remove(marker);
            },
            clusterWidgetSize: const Size(40, 40),
            alignment: Alignment.center,
            calculateAggregatedClusterData: true,
            builder: (context, position, markerCount, extraClusterData) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    markerCount.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  static Marker _createMarker(LatLng point, Color color) => Marker(
        alignment: Alignment.topCenter,
        rotate: true,
        height: 30,
        width: 30,
        point: point,
        child: Icon(
          AccurateMapIcons.locationOnBottomAligned,
          color: color,
          size: 30,
        ),
      );
}
