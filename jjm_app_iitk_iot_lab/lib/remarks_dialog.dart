//lib/screens/remarks_dialog.dart

import 'package:flutter/material.dart';

class RemarksDialog extends StatefulWidget {
  @override
  _RemarksDialogState createState() => _RemarksDialogState();
}

class _RemarksDialogState extends State<RemarksDialog> {
  final _formKey = GlobalKey<FormState>();
  final _remarksController = TextEditingController();

  void _submitRemarks() {
    if (_formKey.currentState!.validate()) {
      // Handle the remarks submission logic here
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Remarks submitted successfully')),
      );

      // Navigate to the NearbyComplaintsScreen
      Navigator.of(context).pushNamedAndRemoveUntil('/nearby-complaints', (Route<dynamic> route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your remarks')),
      );
    }
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Your Remarks'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _remarksController,
          decoration: InputDecoration(
            hintText: 'Enter your remarks on the complaint here',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your remarks';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitRemarks,
          child: Text('Submit Remark'),
        ),
      ],
    );
  }
}