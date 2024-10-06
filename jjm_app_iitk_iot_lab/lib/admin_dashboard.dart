import 'package:flutter/material.dart';
import 'map.dart'; // Assuming Map is correctly implemented and imported
import 'graphs.dart'; // Import the graphs.dart file



class MenuDrawer extends StatelessWidget {
  final String currentRoute;

  const MenuDrawer(this.currentRoute, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Admin Dashboard'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin_dashboard');
            },
          ),
          ListTile(
            title: Text('Maps'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/map');
            },
          ),
          ListTile(
            title: Text('Graphs'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/graphs');
            },
          ),
        ],
      ),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jal Jeevan Mission - IITK')),
      drawer: const MenuDrawer('/admin_dashboard'), // Adjust currentRoute as needed
      body: Column(
        children: [
          // First Row with Buttons or Widgets
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.blue,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Map()), // Navigate to Map screen
                          );
                        },
                        child: Text('Open Map'),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.green,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GraphsPage()), // Navigate to Graphs screen
                          );
                        },
                        child: Text('Open Graphs'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Second Row with Content Placeholder
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              child: Center(
                child: Text('Content Placeholder'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
