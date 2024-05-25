import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({Key? key}) : super(key: key);

  Future<int> _getBookmarksCount(String roomName) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Bookmarks')
        .where('roomName', isEqualTo: roomName)
        .get();
    return querySnapshot.docs.length;
  }

  Future<void> _deleteRoom(BuildContext context, String roomName) async {
    await FirebaseFirestore.instance.collection('Rooms').doc(roomName).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Room $roomName deleted successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _addRoom(BuildContext context, String roomName) async {
    try {
      await FirebaseFirestore.instance.collection('Rooms').doc(roomName).set({
        'Temp': 0.0, // Initial temperature
        'Humid': 0.0, // Initial humidity
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Room $roomName added successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add room: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rooms'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Rooms').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final rooms = snapshot.data?.docs ?? [];
          if (rooms.isEmpty) {
            return Center(child: Text('No rooms available'));
          }

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              final roomName = room.id;
              final temperature = room['Temp']?.toDouble() ?? 0.0;
              final humidity = room['Humid']?.toDouble() ?? 0.0;

              return FutureBuilder<int>(
                future: _getBookmarksCount(roomName),
                builder: (context, bookmarkSnapshot) {
                  if (bookmarkSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text(roomName),
                      subtitle: Text('Loading bookmark count...'),
                    );
                  }
                  if (bookmarkSnapshot.hasError) {
                    return ListTile(
                      title: Text(roomName),
                      subtitle: Text('Error loading bookmark count'),
                    );
                  }

                  final bookmarksCount = bookmarkSnapshot.data ?? 0;

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        roomName,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Container(
                        margin: EdgeInsets.only(top: 8.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.thermostat, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Temperature: $temperature°C',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.water_drop, color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                  'Humidity: $humidity%',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.bookmark, color: Colors.orange),
                                SizedBox(width: 8),
                                Text(
                                  'Bookmarks: $bookmarksCount',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete Room'),
                                content: Text('Are you sure you want to delete the room $roomName?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Delete'),
                                    onPressed: () async {
                                      await _deleteRoom(context, roomName);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final roomNameController = TextEditingController();
              return AlertDialog(
                title: Text('Add Room'),
                content: TextField(
                  controller: roomNameController,
                  decoration: InputDecoration(labelText: 'Room Name'),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Add'),
                    onPressed: () {
                      final roomName = roomNameController.text.trim();
                      if (roomName.isNotEmpty) {
                        _addRoom(context, roomName);
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter a room name'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
