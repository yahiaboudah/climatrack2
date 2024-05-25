import 'package:flutter/material.dart';
import 'package:climatrack2/services/auth.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Auth _auth = Auth();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Logged in w/ email: ',
                      style: TextStyle(color: Colors.black, fontSize: 18), // Set the color of "Logged in as: " to black
                    ),
                    TextSpan(
                      text: '${Auth().currentUser?.email ?? "Unknown"}',
                      style: TextStyle(color: Colors.green, fontSize: 16), // Set the color of the email to green
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text(
                'Log Out',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                // Show a confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Log Out'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Perform log out action
                            await _auth.signOut();
                            Navigator.of(context).pop(); // Close the dialog
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text('Log Out'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}