import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'admin_dashboard.dart';
import 'complaint.dart'; // Import the complaint page

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
  tileProvider: CancellableNetworkTileProvider(),
);

class MapUserPage extends StatefulWidget {
  static const String route = '/second_screen';

  const MapUserPage({Key? key}) : super(key: key);

  @override
  MapUserState createState() => MapUserState();
}

class MapUserState extends State<MapUserPage> {
  final mapController = MapController();

  List<LatLng> markers = []; // This will hold your marker points

  @override
  void initState() {
    super.initState();
    // Add dummy data markers near 26.5, 80.1
    markers = [
      LatLng(26.5, 80.1),
      LatLng(26.52, 80.12),
      LatLng(26.48, 80.08),
      LatLng(26.55, 80.15),
      LatLng(26.47, 80.11),
    ];
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
              onTap: (tapPosition, latLng) {
                // Do nothing on tap, since we don't want to add new markers
              },
              initialCenter: LatLng(26.5, 80.1),
              minZoom: 3,
            ),
            children: [
              openStreetMapTileLayer,
              MarkerLayer(
                markers: markers.map((latLng) =>
                    Marker(
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
                children: markers.map((latLng) =>
                    Text(
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
          Positioned(
            bottom: 20, // Adjust this value to move the button further down
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () async {
                final selectedLatLng = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPickerPage()),
                );
                if (selectedLatLng != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ComplaintPage(location: selectedLatLng),
                    ),
                  );
                }
              },
              child: const Text('Point Leakage'),
            ),
          ),
        ],
      ),
    );
  }

  void _getCurrentLocation() async {
    if (await Permission.location.request().isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final LatLng currentLatLng = LatLng(
          position.latitude, position.longitude);
      mapController.move(currentLatLng, 15.0);

      // No need to add a marker here, just move the map
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied')),
      );
    }
  }
}

class MapPickerPage extends StatefulWidget {
  @override
  _MapPickerPageState createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  final MapController _mapPickerController = MapController();
  LatLng _selectedLatLng = LatLng(26.5, 80.1); // Default position
  double _zoomLevel = 10.0; // Adjusted initial zoom level

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick a Location')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapPickerController,
            options: MapOptions(
              initialCenter: _selectedLatLng,
              minZoom: 3.0, // Adjusted minimum zoom level
              maxZoom: 18.0, // Optional: Set maximum zoom level if needed
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  setState(() {
                    _selectedLatLng = position.center!;
                    _zoomLevel = position.zoom!;
                  });
                }
              },
            ),
            children: [
              openStreetMapTileLayer,
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: _selectedLatLng,
                    child: const Icon(
                      Icons.location_on,
                      size: 40.0,
                      color: Colors.red,
                    ),
                  ),
                ],
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
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _selectedLatLng);
              },
              child: const Text('Proceed'),
            ),
          ),
        ],
      ),
    );
  }

  void _getCurrentLocation() async {
    if (await Permission.location.request().isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final LatLng currentLatLng = LatLng(
          position.latitude, position.longitude);
      _mapPickerController.move(currentLatLng, 15.0);

      setState(() {
        _selectedLatLng = currentLatLng; // Update the selected location
        _zoomLevel = 15.0; // Adjust zoom level when moving to current location
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied')),
      );
    }
  }
}


class ComplaintPage extends StatelessWidget {
  final LatLng location;

  const ComplaintPage({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RaiseComplaintScreen(latitude: location.latitude.toString(), longitude: location.longitude.toString()),
    );
  }
}

class Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MapUserPage();
  }
}
