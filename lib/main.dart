import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
        home: const Scaffold(body: Center(child: Text('An error occurred!'))));
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
        home: const Scaffold(body: Center(child: CircularProgressIndicator())));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Fixed the constructor

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RootPage(),
    );
  }
}

// //top level function for the root page
// Future<List<DocumentSnapshot>> fetchGamesByCategory(String category) async {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   return await firestore
//       .collection('games-collection')
//       .where('genre', isEqualTo: category)
//       .get()
//       .then((querySnapshot) => querySnapshot.docs);
// }

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  get responseData => null;

  Future<List<String>> fetchGameSuggestions(String query) async {
    final url =
        'https://api.rawg.io/api/games?key=${dotenv.env['RAWG_API_KEY']}&search=$query';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final games = (data['results'] as List)
          .map((game) => game['name'].toString())
          .toList();
      return games;
    } else {
      throw Exception('Failed to load games from API');
    }
  }

  // For instance, when you use it in a function:
  Future<List<DocumentSnapshot>> fetchGamesByCategory(String category) async {
    return await firestore
        .collection('games-collection')
        .where('genre', isEqualTo: category)
        .get()
        .then((querySnapshot) => querySnapshot.docs);
  }

  int currentPage = 0;

  List<String>? get gamesList =>
      ['Read Dead Redemption 2', 'Fortnite', 'Valorant', 'NBA 2k23'];
  List<String>? get recentGames =>
      ['Zelda', 'Mario', 'Sonic Adventure', 'Mario Odyssey'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Tracker'),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: GameSearch(gamesList!, recentGames!,
                        fetchGamesByCategory, fetchGamesByCategory, this));
              },
              icon: const Icon(Icons.search))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Floating Action Button');
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {},
                    ),
                    hintText: 'Search...',
                    border: InputBorder.none),
              ),
            )),
      ),
    );
  }
}

class GameSearch extends SearchDelegate<String> {
  final List<String> gamesList;
  final List<String> recentGames;
  final Function(String) fetchGamesByCategory;
  final Future<List<DocumentSnapshot>> Function(String) fetchGames;
  // ignore: library_private_types_in_public_api
  final _RootPageState rootPageState;
  // ignore: library_private_types_in_public_api
  GameSearch(
      this.gamesList,
      this.recentGames,
      this.fetchGamesByCategory,
      // ignore: library_private_types_in_public_api
      this.fetchGames,
      this.rootPageState);

  // Define your categories

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: fetchGames(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final gameData =
                  snapshot.data![index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(gameData['name'] ?? 'Unknown Game'),
                // Add more data as required
              );
            },
          );
        } else {
          return const Center(child: Text('No results found!'));
        }
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = ''; // Clear the search query
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Return empty string instead of null
      },
    );
  }

  // ... other methods remain unchanged

  @override
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      // Fetch and show recommended games when the query is empty
      return FutureBuilder<List<String>>(
        future: fetchRecommendedGames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]),
                  onTap: () {
                    query = snapshot.data![index];
                    showResults(context);
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No recommendations available.'));
          }
        },
      );
    } else {
      // Fetch game suggestions based on the query
      return FutureBuilder<List<String>>(
        future: rootPageState.fetchGameSuggestions(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final suggestionList = snapshot.data!;
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                onTap: () {
                  query = suggestionList[index];
                  showResults(context);
                },
                title: Text(suggestionList[index]),
              ),
              itemCount: suggestionList.length,
            );
          } else {
            return const Center(child: Text('No results found!'));
          }
        },
      );
    }
  }

  Future<List<String>> fetchRecommendedGames() async {
    final response = await http.get(
      Uri.parse(
          'https://api.rawg.io/api/games?key=${dotenv.env['RAWG_API_KEY']}&page_size=10'), // Fetches top 10 games
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<String> gameTitles = [];
      for (var game in data['results']) {
        gameTitles.add(game['name']);
      }
      return gameTitles;
    } else {
      throw Exception('Failed to load recommended games');
    }
  }
}
