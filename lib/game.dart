class Game {
  final String name;
  final String imageURL;
  final String description;

  Game({
    required this.name,
    required this.imageURL,
    required this.description,
  });

  // You can also add a factory method to create a Game object from API's JSON response
}
