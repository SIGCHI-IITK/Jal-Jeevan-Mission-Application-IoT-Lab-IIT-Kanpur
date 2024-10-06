import 'package:flutter/material.dart';
import '../models/complaint.dart'; // Import the Complaint class
import 'remarks_dialog.dart';
import 'map.dart';

class ComplaintDetailsScreen extends StatelessWidget {
  final Complaint complaint;

  ComplaintDetailsScreen({required this.complaint});

  void showRemarksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.easeOut,
          ),
          child: RemarksDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            complaint.image,
            fit: BoxFit.cover,
            height: 250,
            width: double.infinity,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                buildDetailTile('Latitude', complaint.latitude),
                buildDetailTile('Longitude', complaint.longitude),
                buildDetailTile('Address', complaint.address),
                buildDetailTile('Description', complaint.description),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildActionButton(
                      context,
                      icon: Icons.map,
                      label: 'View Map',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapPage(
                              latitude: double.parse(complaint.latitude),
                              longitude: double.parse(complaint.longitude),
                            ),
                          ),
                        );
                      },
                    ),
                    buildActionButton(
                      context,
                      icon: Icons.comment,
                      label: 'Remarks',
                      onPressed: () => showRemarksDialog(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailTile(String title, String subtitle) {
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }

  Widget buildActionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
