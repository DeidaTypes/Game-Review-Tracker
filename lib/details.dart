import 'package:flutter/material.dart';
import 'package:goodgame/game.dart';
// Make sure you import Firestore if not already imported.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goodgame/star_rating.dart';

class GameDetailsPage extends StatefulWidget {
  final Game game;

  const GameDetailsPage({Key? key, required this.game}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GameDetailsPageState createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  String gameStatus = 'Want to play';
  int currentRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.name),
      ),
      body: ListView(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.game.imageURL.isNotEmpty)
                // ignore: sized_box_for_whitespace
                Container(
                  width: 120.0,
                  child: Image.network(widget.game.imageURL),
                ),
              Expanded(child: _buildRatingAndStatusSection()),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.game.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                backgroundColor: Colors.yellow,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: saveToFirestore,
            child: const Text("Save Rating & Status"),
          )
        ],
      ),
    );
  }

  Widget _buildRatingAndStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // You'll need a custom widget or package for the StarRating.
        StarRating(
          onRatingChanged: (rating) {
            setState(() {
              currentRating = rating;
            });
          },
        ),
        DropdownButton<String>(
          value: gameStatus,
          items:
              <String>['Want to play', 'Played', 'Playing'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                gameStatus = newValue;
              });
            }
          },
        ),
      ],
    );
  }

  Future<void> saveToFirestore() async {
    // Assuming you have Firebase set up and imported
    final firestore = FirebaseFirestore.instance;

    // Save rating
    await firestore.collection('ratings').add({
      'userId': 'currentUserId',
      'gameId': widget.game.id,
      'rating': currentRating,
    });

    // Save game status
    await firestore.collection('gameStatuses').add({
      'userId': 'currentUserId',
      'gameId': widget.game.id,
      'status': gameStatus,
    });
  }
}
