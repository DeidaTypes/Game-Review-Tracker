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
          if (game.imageURL.isNotEmpty) Image.network(game.imageURL),
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
}
