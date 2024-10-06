import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Import Geolocator plugin
import 'dart:math';
import 'complaint_details_screen.dart'; // Import the Complaint class
import '../models/complaint.dart';
import 'remarks_dialog.dart';
import '../models/complaint_card.dart'; // Import the ComplaintCard widget

class NearbyComplaintsScreen extends StatefulWidget {
  @override
  _NearbyComplaintsScreenState createState() => _NearbyComplaintsScreenState();
}

class _NearbyComplaintsScreenState extends State<NearbyComplaintsScreen> {
  List<Complaint> nearbyComplaints = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchNearbyComplaints();
  }

  void fetchNearbyComplaints() async {
    setState(() {
      isLoading = true;
    });

    // Simulating a delay for fetching data
    await Future.delayed(Duration(seconds: 0));

    List<Complaint> fetchedComplaints = mockComplaints();
    Position? currentPosition = await _getCurrentLocation();
    if (currentPosition != null) {
      fetchedComplaints.sort((a, b) {
        double distanceToA = _calculateDistance(
          currentPosition.latitude,
          currentPosition.longitude,
          double.parse(a.latitude),
          double.parse(a.longitude),
        );
        double distanceToB = _calculateDistance(
          currentPosition.latitude,
          currentPosition.longitude,
          double.parse(b.latitude),
          double.parse(b.longitude),
        );
        return distanceToA.compareTo(distanceToB);
      });
      fetchedComplaints = fetchedComplaints.take(10).toList();
    }

    setState(() {
      nearbyComplaints = fetchedComplaints;
      isLoading = false;
    });
  }

  List<Complaint> mockComplaints() {
    // Replace this with actual data fetching logic
    return [
      Complaint(
        image: 'https://via.placeholder.com/150/FF5733/FFFFFF?text=Water+Leakage',
        latitude: '26.4041',
        longitude: '80.1025',
        address: 'G66M+W5J, Kalyanpur, Kanpur, Uttar Pradesh 208016',
        description: 'Water leakage is the accidental release of water from a plumbing system, such as pipes, tanks, faucets, or fittings.',
      ),
      Complaint(
        image: 'https://via.placeholder.com/150/3D9970/FFFFFF?text=Pothole',
        latitude: '28.6139',
        longitude: '77.2090',
        address: 'Connaught Place, New Delhi, Delhi 110001',
        description: 'Pothole on the road causing traffic congestion and potential accidents.',
      ),
      Complaint(
        image: 'https://via.placeholder.com/150/85144B/FFFFFF?text=Garbage+Overflow',
        latitude: '19.0760',
        longitude: '72.8777',
        address: '56/78, 14thA Cross, 2nd Main, Garden Layout, JP Nagar 7th Phase. Landmark: Behind Sparsh Supermarket.',
        description: 'Garbage overflow issue at the local market, affecting cleanliness.',
      ),
      Complaint(
        image: 'https://via.placeholder.com/150/FF5733/FFFFFF?text=Street+Light+Out',
        latitude: '12.9716',
        longitude: '77.5946',
        address: 'MG Road, Bengaluru, Karnataka 560001',
        description: 'Street light not functioning, causing darkness and safety issues at night.',
      ),
      Complaint(
        image: 'https://via.placeholder.com/150/3D9970/FFFFFF?text=Illegal+Dumping',
        latitude: '22.5726',
        longitude: '88.3639',
        address: 'Park Street, Kolkata, West Bengal 700016',
        description: 'Illegal dumping of waste in a residential area, causing health hazards.',
      ),
      Complaint(
        image: 'https://via.placeholder.com/150/85144B/FFFFFF?text=Noise+Pollution',
        latitude: '28.4595',
        longitude: '77.0266',
        address: 'Cyber Hub, DLF Phase 2, Sector 24, Gurugram, Haryana 122002',
        description: 'Excessive noise from construction work, disturbing the residents.',
      ),
      Complaint(
        image: 'https://via.placeholder.com/150/FF5733/FFFFFF?text=Broken+Bench',
        latitude: '13.0827',
        longitude: '80.2707',
        address: 'Marina Beach, Chennai, Tamil Nadu 600005',
        description: 'Public bench broken, posing a risk to people who use it.',
      ),
      Complaint(
        image: 'https://via.placeholder.com/150/3D9970/FFFFFF?text=Blocked+Drain',
        latitude: '17.3850',
        longitude: '78.4867',
        address: 'Hussain Sagar, Hyderabad, Telangana 500029',
        description: 'Blocked drain causing water logging and foul smell in the area.',
      ),
      Complaint(
        image: 'https://via.placeholder.com/150/85144B/FFFFFF?text=Stray+Dogs',
        latitude: '26.9124',
        longitude: '75.7873',
        address: 'Hawa Mahal, Jaipur, Rajasthan 302002',
        description: 'Large number of stray dogs creating safety concerns for the locals.',
      ),
      Complaint(
        image: 'https://via.placeholder.com/150/FF5733/FFFFFF?text=Fallen+Tree',
        latitude: '15.3173',
        longitude: '75.7139',
        address: 'Hospet Road, Hampi, Karnataka 583239',
        description: 'Fallen tree blocking the road, causing traffic disruption.',
      ),
      Complaint(
        image: 'https://via.placeholder.com/150/3D9970/FFFFFF?text=Open+Manhole',
        latitude: '23.0225',
        longitude: '72.5714',
        address: 'Sabarmati Riverfront, Ahmedabad, Gujarat 380027',
        description: 'Open manhole posing a danger to pedestrians and vehicles.',
      ),
      Complaint(
        image: 'https://via.placeholder.com/150/85144B/FFFFFF?text=Overgrown+Grass',
        latitude: '9.9312',
        longitude: '76.2673',
        address: 'Marine Drive, Ernakulam, Kochi, Kerala 682011',
        description: 'Overgrown grass in the park, making it difficult for people to use the space.',
      ),
      Complaint(
        image: 'https://via.placeholder.com/150/FF5733/FFFFFF?text=Broken+Swing',
        latitude: '30.7333',
        longitude: '76.7794',
        address: 'Sector 17 Plaza, Chandigarh 160017',
        description: 'Broken swing in the playground, posing a risk to children.',
      ),
      Complaint(
        image: 'https://via.placeholder.com/150/3D9970/FFFFFF?text=Erosion',
        latitude: '27.1767',
        longitude: '78.0081',
        address: 'Taj Mahal, Agra, Uttar Pradesh 282001',
        description: 'Soil erosion near the riverbank, endangering nearby structures.',
      ),
      Complaint(
        image: 'https://via.placeholder.com/150/85144B/FFFFFF?text=Fallen+Signage',
        latitude: '31.1048',
        longitude: '77.1734',
        address: 'Mall Road, Shimla, Himachal Pradesh 171001',
        description: 'Fallen road signage causing confusion for drivers and pedestrians.',
      ),
      Complaint(
        image: 'https://via.placeholder.com/150/FF5733/FFFFFF?text=Graffiti',
        latitude: '11.0168',
        longitude: '76.9558',
        address: 'Race Course, Coimbatore, Tamil Nadu 641018',
        description: 'Graffiti on public walls, defacing the property and affecting aesthetics.',
      ),
    ];
  }

  void navigateToComplaintDetails(Complaint complaint) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComplaintDetailsScreen(complaint: complaint),
      ),
    );
  }

  void showRemarksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return RemarksDialog();
      },
    );
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      bool serviceStatus = await Geolocator.openLocationSettings();
      if (!serviceStatus) {
        return null;
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return null;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    double a = 0.5 - cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // Distance in kilometers
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Complaints', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : nearbyComplaints.isEmpty
          ? Center(child: Text('No complaints nearby'))
          : RefreshIndicator(
        onRefresh: () async {
          fetchNearbyComplaints();
        },
        child: ListView.builder(
          itemCount: nearbyComplaints.length,
          itemBuilder: (context, index) {
            return ComplaintCard(
              complaint: nearbyComplaints[index],
              onDetailsTap: navigateToComplaintDetails,
              onRemarksTap: showRemarksDialog,
            );
          },
        ),
      ),
    );
  }
}
