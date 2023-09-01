import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyCollectionPage extends StatefulWidget {
  @override
  _MyCollectionPageState createState() => _MyCollectionPageState();
}

class _MyCollectionPageState extends State<MyCollectionPage> {
  late Stream<QuerySnapshot> ratingsStream;
  late Stream<QuerySnapshot> gameStatusStream;

  @override
  void initState() {
    super.initState();

    // Assuming you have Firebase set up
    final firestore = FirebaseFirestore.instance;

    // TODO: Replace with the actual user's ID
    String currentUserId = 'currentUserId';

    ratingsStream = firestore
        .collection('ratings')
        .where('userId', isEqualTo: currentUserId)
        .snapshots();

    gameStatusStream = firestore
        .collection('gameStatuses')
        .where('userId', isEqualTo: currentUserId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Collection'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ratingsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('An error occurred!'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No ratings found.'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final rating = doc['rating'];
                    final gameId =
                        doc['gameId']; // You can fetch more details if needed
                    return ListTile(
                      title: Text('Game ID: $gameId'),
                      subtitle: Text('Rating: $rating stars'),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: gameStatusStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('An error occurred!'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No game statuses found.'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final status = doc['status'];
                    final gameId =
                        doc['gameId']; // You can fetch more details if needed
                    return ListTile(
                      title: Text('Game ID: $gameId'),
                      subtitle: Text('Status: $status'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
