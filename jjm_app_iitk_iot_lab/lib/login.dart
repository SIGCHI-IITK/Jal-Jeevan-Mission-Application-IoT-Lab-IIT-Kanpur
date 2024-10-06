import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'user_dashboard.dart'; // Import the UserDashboard

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminDashboard()),
                );
              },
              child: Text('Admin'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserDashboard()),
                );
              },
              child: Text('User'),
            ),
          ],
        ),
      ),
    );
  }
}
