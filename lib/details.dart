// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:goodgame/game.dart';

class GameDetailsPage extends StatelessWidget {
  final Game game; // This will store details of the game you want to display

  const GameDetailsPage({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Game Name: ${game.name}');
    print('Game Description: ${game.description}');
    print('Game Image: ${game.imageURL}');
    return Scaffold(
      appBar: AppBar(
        title: Text(game.name),
      ),
      body: Column(
        children: [
          Image.network(
              game.imageURL), // assuming imageURL is a property in Game class
          Text(game.description), // and so on...
        ],
      ),
    );
  }
}
