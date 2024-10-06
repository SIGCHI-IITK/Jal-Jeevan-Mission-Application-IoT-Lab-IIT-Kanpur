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
  final double? latitude;
  final double? longitude;

  const MapPage({Key? key, this.latitude, this.longitude}) : super(key: key);

  @override
  MapState createState() => MapState();
}

class MapState extends State<MapPage> {
  final mapController = MapController();
  LatLng? complaintLocation;
  LatLng? currentLocation;
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    if (widget.latitude != null && widget.longitude != null) {
      complaintLocation = LatLng(widget.latitude!, widget.longitude!);
      markers.add(_buildMarker(complaintLocation!, Icons.location_pin, Colors.red));
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          mapController.move(complaintLocation!, 15.0);
        }
      });
    }
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
              initialCenter: complaintLocation ?? const LatLng(51.5, -0.09),
              initialZoom: 5,
              minZoom: 3,
            ),
            children: [
              openStreetMapTileLayer,
              MarkerLayer(
                markers: markers,
              ),
            ],
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

  Marker _buildMarker(LatLng point, IconData icon, Color color) {
    return Marker(
      width: 65,
      height: 65,
      point: point,
      child: Icon(
        icon,
        size: 30,
        color: color,
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    if (await Permission.location.request().isGranted) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentLocation = LatLng(position.latitude, position.longitude);

      mapController.move(currentLocation!, 15.0); // Move map directly to current location

      setState(() {
        markers = [
          _buildMarker(complaintLocation!, Icons.location_pin, Colors.red),
          _buildMarker(currentLocation!, Icons.circle, Colors.blue),
        ];
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
