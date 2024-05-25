import 'package:flutter/material.dart';
import 'package:climatrack2/services/auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:climatrack2/models/Bookmark.dart';

class BookmarkListWidget extends StatelessWidget {
  final List<Bookmark> bookmarks;

  const BookmarkListWidget({Key? key, required this.bookmarks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        Bookmark bookmark = bookmarks[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: ListTile(
              title: Text('${bookmark.roomName} - ${_formatDate(bookmark.date)}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (bookmark.temperature != null)
                    Text('Temperature: ${bookmark.temperature}'),
                  if (bookmark.humidity != null) Text('Humidity: ${bookmark.humidity}'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _confirmDelete(context, bookmark);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, Bookmark bookmark) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this bookmark?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirm) {
      await FirebaseFirestore.instance.collection('Bookmarks').doc(bookmark.id).delete();
    }
  }

   String _formatDate(DateTime date) {
    DateFormat formatter = DateFormat('EEE, MMM d, y h:mm a', 'en_US');
    return formatter.format(date);
  }
}

class Bookmarks extends StatelessWidget {
  const Bookmarks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    const String collectionName = "Bookmarks";

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bookmarks'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            List<Bookmark> userBookmarks = snapshot.data!.docs
                .where((doc) => doc['userId'] == Auth().currentUser?.uid)
                .map((doc) => Bookmark(
                      id: doc.id, // Document ID
                      roomName: doc['roomName'],
                      date: doc['datetime'].toDate().add(const Duration(hours: 1)),
                      temperature: doc['temperature']?.toDouble(),
                      humidity: doc['humidity']?.toDouble(),
                    ))
                .toList();
            
            userBookmarks.sort((a, b) => b.date.compareTo(a.date));

            if (userBookmarks.isEmpty) {
              return const Center(
                child: Text('No bookmarks recorded'),
              );
            } else {
              return BookmarkListWidget(bookmarks: userBookmarks);
            }
          },
        ),
      ),
    );
  }
}
