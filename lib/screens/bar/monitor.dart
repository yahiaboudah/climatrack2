import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'monitor_detail.dart';
import 'package:climatrack2/models/Room.dart';


class MonitorPage extends StatelessWidget {
  
  const MonitorPage({super.key});

  @override
  Widget build(BuildContext context) {

    const collectionName = "Rooms";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rooms'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<Room> rooms = snapshot.data!.docs.map((DocumentSnapshot document) {
            String docId = document.id;
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return Room(
              name: docId,
              hasTemperatureSensor: data.containsKey('Temp'),
              hasHumiditySensor: data.containsKey('Humid'),
            );
          }).toList();

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              Room room = rooms[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MonitorDetail(roomName: room.name),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: ListTile(
                      title: Text(room.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (room.hasTemperatureSensor)
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.thermostat),
                            ),
                          if (room.hasHumiditySensor)
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.water_damage),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
