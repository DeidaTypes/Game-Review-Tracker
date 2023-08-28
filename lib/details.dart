// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:goodgame/game.dart';

class GameDetailsPage extends StatelessWidget {
  final Game game;

  const GameDetailsPage({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Game Description: ${game.description}");

    return Scaffold(
      appBar: AppBar(
        title: Text(game.name),
      ),
      body: ListView(
        children: [
          Row(
            // Begin of the new block
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (game.imageURL.isNotEmpty)
                Container(
                  width: 120.0, // set a specific width for the image
                  child: Image.network(game.imageURL),
                ),
              Expanded(
                  child:
                      _buildRatingAndStatusSection()), // we'll define this function below
            ],
          ), // End of the new block
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              game.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                backgroundColor: Colors
                    .yellow, // temporarily set a background to see the text widget's space
              ),
            ),
          ),
        ],
      ),
    );
  }

  // This function is added outside the build method but still within the GameDetailsPage class.
  Widget _buildRatingAndStatusSection() {
    // The current setup assumes the gameStatus is static (always 'Want to play').
    String gameStatus = 'Want to play';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (index) {
            return const Icon(Icons.star, color: Colors.yellow);
          }),
        ),
        const SizedBox(height: 10),
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
            // As this is a StatelessWidget, we aren't handling the onChanged
            // but if you convert this to a StatefulWidget you can manage the state.
          },
        ),
      ],
    );
  }
}
