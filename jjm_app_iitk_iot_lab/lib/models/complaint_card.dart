import 'package:flutter/material.dart';
import '../models/complaint.dart'; // Import the Complaint class
import '../map.dart';

class ComplaintCard extends StatelessWidget {
  final Complaint complaint;
  final void Function(Complaint) onDetailsTap;
  final void Function(BuildContext) onRemarksTap;

  ComplaintCard({
    required this.complaint,
    required this.onDetailsTap,
    required this.onRemarksTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onDetailsTap(complaint),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      complaint.image,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: ElevatedButton(
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
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      minimumSize: Size(45, 45),
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(Icons.map),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: ElevatedButton(
                    onPressed: () => onRemarksTap(context),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      minimumSize: Size(45, 45),
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(Icons.comment),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    complaint.address,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Text(
                    complaint.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}