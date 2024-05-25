import 'package:flutter/material.dart';
import 'package:climatrack2/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MonitorDetail extends StatefulWidget {
  final String roomName;

  const MonitorDetail({Key? key, required this.roomName}) : super(key: key);

  @override
  _MonitorDetailState createState() => _MonitorDetailState();
}

class _MonitorDetailState extends State<MonitorDetail> {
  late double temperature;
  late double humidity;
  final String collectionName = "Rooms";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(collectionName).doc(widget.roomName).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          if (data.isEmpty) {
            return const Text('No data available');
          }

          temperature = data["Temp"].toDouble();
          humidity = data['Humid'].toDouble();

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Room: ${widget.roomName}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _tempIndicator(temperature),
                const SizedBox(height: 20),
                _humidIndicator(humidity),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addBookmark(context, widget.roomName, temperature, humidity);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.bookmark),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _addBookmark(BuildContext context, String roomName, double temperature, double humidity) async {
    try {
      // Get the current user's email using Auth class
      String? userId = Auth().currentUser?.uid;

      // Check if user is authenticated
      if (userId == null) {
        throw 'User not authenticated';
      }

      // Get current datetime
      DateTime now = DateTime.now();

      // Add the bookmark data to Firestore
      await FirebaseFirestore.instance.collection('Bookmarks').add({
        'userId': userId, // Use user's email as identifier
        'datetime': now,
        'roomName': roomName,
        'temperature': temperature,
        'humidity': humidity,
      });

      // Show a snackbar to indicate successful bookmark addition
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bookmark added successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Show a snackbar to indicate error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _humidIndicator(double humidity) {
    return CircularPercentIndicator(
      radius: 80.0,
      lineWidth: 7.0,
      percent: humidity / 100,
      header: const Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: Text(
          "Humidity",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.water_drop,
            size: 50.0,
            color: Colors.blue,
          ),
          Text(
            "$humidity%",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey,
      progressColor: Colors.blue,
    );
  }

  Widget _tempIndicator(double temperature) {
    return CircularPercentIndicator(
      radius: 80.0,
      lineWidth: 7.0,
      percent: temperature / 100,
      header: const Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: Text(
          "Temperature",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.thermostat,
            size: 50.0,
            color: Colors.red,
          ),
          Text(
            "$temperature°C",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey,
      progressColor: Colors.red,
    );
  }
}
