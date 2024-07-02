import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'admin_dashboard.dart';

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
  tileProvider: CancellableNetworkTileProvider(),
);


class MapPage extends StatefulWidget {
  static const String route = '/second_screen';

  const MapPage({Key? key}) : super(key: key);

  @override
  MapState createState() => MapState();
}

class MapState extends State<MapPage> {
  final mapController = MapController();

  List<LatLng> markers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      drawer: const MenuDrawer('/admin_dashboard'),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              onTap: _handleTap,
              initialCenter: const LatLng(51.5, -0.09),
              initialZoom: 5,
              minZoom: 3,
            ),
            children: [
              openStreetMapTileLayer,
              MarkerLayer(
                markers: markers.map((latLng) => Marker(
                  width: 65,
                  height: 65,
                  point: latLng,
                  child: const Icon(
                    Icons.circle,
                    size: 10,
                    color: Colors.black,
                  ),
                )).toList(),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Column(
                children: markers.map((latLng) => Text(
                  '(${latLng.latitude.toStringAsFixed(3)}, ${latLng.longitude.toStringAsFixed(3)})',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )).toList(),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  void _handleTap(TapPosition tapPosition, LatLng latLng) {
    setState(() {
      markers.add(latLng);
    });
  }

  Future<void> _getCurrentLocation() async {
    if (await Permission.location.request().isGranted) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      mapController.move(currentLatLng, 15.0);
      setState(() {
        markers.add(currentLatLng);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission denied')),
      );
    }
  }
}

class Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapPage();
  }
}