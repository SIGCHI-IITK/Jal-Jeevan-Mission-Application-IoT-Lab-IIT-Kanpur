import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class RaiseComplaintScreen extends StatefulWidget {
  final String latitude;
  final String longitude;

  RaiseComplaintScreen({required this.latitude, required this.longitude});

  @override
  _RaiseComplaintScreenState createState() => _RaiseComplaintScreenState();
}

class _RaiseComplaintScreenState extends State<RaiseComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  String _address = '';
  String _description = '';
  File? _imageFile;
  double? _imageWidth;
  double? _imageHeight;
  bool _isSubmitting = false; // Track if form submission is in progress

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Raise a Complaint', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () => _showImageSourceDialog(),
                  child: _imageFile == null
                      ? Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(Icons.add_a_photo, size: 54, color: Colors.grey),
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.file(_imageFile!),
                    ),
                  ),
                ),
                SizedBox(height: 18.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200], // Match with the lighter shade of the "Complaint Submitted" dialog box
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Latitude: ', style: TextStyle(fontSize: 15.0)),
                      Text(
                        double.parse(widget.latitude).toStringAsFixed(4), // Display latitude rounded to 4 decimal points
                        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 12.0),
                      Text(','),
                      SizedBox(width: 12.0),
                      Text('Longitude: ', style: TextStyle(fontSize: 15.0)),
                      Text(
                        double.parse(widget.longitude).toStringAsFixed(4), // Display longitude rounded to 4 decimal points
                        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the address of the Leakage';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _address = value;
                    });
                  },
                  maxLines: null, // Allow multiple lines
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description of the complaint';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                  maxLines: null, // Allow multiple lines
                ),
                SizedBox(height: 15.0),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text('Choose an Option', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // Lighter shade color
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.camera),
                title: Text('Click a picture'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: 12), // Adjust spacing between options as needed
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // Lighter shade color
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.photo_album),
                title: Text('Choose a picture'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final image = File(pickedFile.path);

      setState(() {
        _imageFile = image;
      });

    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_imageFile == null) {
        _showErrorDialog('Image Not Added', 'Please add an image of your complaint.', 'Add Image');
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      // Show a loading spinner
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: Text('Complaint Submitted', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                  SizedBox(height: 15),
                  Text('Your complaint has been submitted successfully.', textAlign: TextAlign.center),
                  SizedBox(height: 9),
                  Text('Details:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 9),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Light shade color
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Latitude:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(widget.latitude),
                            Text('Longitude:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(widget.longitude),
                          ],
                        ),
                        SizedBox(height: 9),
                        Text('Address:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(_address),
                        SizedBox(height: 9),
                        Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(_description),
                        if (_imageFile != null) ...[
                          SizedBox(height: 9),
                          Text('Complaint Image:', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 9),
                          Image.file(_imageFile!),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 9),
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, '/map-user', (route) => false);
                      },
                      child: Text('OK'),
                    ),
                  ),
                  // SizedBox(height: 10), // Adjust spacing as needed
                ],
              ),
            ),
          ),
        ),
      );

      // Simulate a network call
      await Future.delayed(Duration(seconds: 2));
      bool networkSuccess = _simulateNetworkCall(); // Simulate network call result

      setState(() {
        _isSubmitting = false;
      });

      if (!networkSuccess) {
        // Show error dialog
        _showErrorDialog('Submission Failed', 'There was a problem submitting your complaint. Please try again.', 'Retry');
        Navigator.pop(context); // Dismiss the success dialog if submission failed
      }
    }
  }

  void _showErrorDialog(String title, String message, String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
        content: Text(message),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the error dialog
                if (action == 'Add Image') {
                  Future.delayed(Duration(milliseconds: 100), () {
                    _showImageSourceDialog(); // Show the image source dialog
                  });
                } else if (action == 'Retry') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RaiseComplaintScreen(latitude: widget.latitude, longitude: widget.longitude)),
                  ); // Open a new "Raise a Complaint" screen
                }
              },
              child: Text(action),
            ),
          ),
        ],
      ),
    );
  }

  // Simulate a network call
  bool _simulateNetworkCall() {
    // Simulate a 50% chance of success
    return DateTime.now().second % 2 == 0;
  }
}
