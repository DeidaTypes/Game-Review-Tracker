// ignore_for_file: avoid_print, use_rethrow_when_possible, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goodgame/details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:goodgame/game.dart';
import 'package:goodgame/profile.dart';

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

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  PageController _pageController = PageController();

  int currentPage = 0;

  // Note: You should replace nulls with actual implementations for game list, recent games,
  // fetchGameDetails, and fetchGameSuggestions.
  // For now, I'm just demonstrating where they should go in your code.
  List<String>? get gamesList => null;
  List<String>? get recentGames => null;
  Future<Map<String, dynamic>> Function(String p1)? get fetchGameDetails =>
      null;
  Future<List<String>> Function(String p1)? get fetchGameSuggestions => null;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
                  delegate: GameSearch(
                    gamesList!,
                    recentGames!,
                    fetchGameDetails!,
                    fetchGameSuggestions!,
                  ),
                );
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
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(color: Colors.blue), // Home Page (replace with actual page)
          const ProfilePage(), // Profile Page (replace with actual page)
          Container(
              color: Colors.green), // Search Page (replace with actual page)
          Container(
              color: Colors
                  .yellow), // My Collection Page (replace with actual page)
          Container(
              color: Colors.red), // Settings Page (replace with actual page)
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(
              icon: Icon(Icons.collections), label: 'My Collection'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
          _pageController.jumpToPage(index);
        },
        selectedIndex: currentPage,
      ),
    );
  }
}

//Search Page
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

//Game Search Class
class GameSearch extends SearchDelegate<String> {
  final List<String> gamesList;
  final List<String> recentGames;
  final Future<Map<String, dynamic>> Function(String) fetchGameDetails;
  final Future<List<String>> Function(String) fetchGameSuggestions;

  GameSearch(
    this.gamesList,
    this.recentGames,
    this.fetchGameDetails,
    this.fetchGameSuggestions,
  );

  get rootPageState => null;

  // Define your categories

  @override
  @override

  //Game details page
  Widget buildResults(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchGameDetails(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null) {
          final gameData = snapshot.data!;

          return ListTile(
            title: Text(gameData['name'] ?? 'Unknown Game'),
            onTap: () {
              Game selectedGame = Game(
                name: gameData['name'],
                description: gameData['description_raw'] ??
                    '', // Directly use the description from the RAWG API
                imageURL: gameData['background_image'],
              );

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GameDetailsPage(game: selectedGame),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No results found!'));
        }
      },
    );
  }

//clear search
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
                  onTap: () async {
                    final gameDetails =
                        await fetchGameDetails(snapshot.data![index]);
                    if (gameDetails != null) {
                      final game = Game(
                        name: gameDetails['name'] ?? 'Unknown Game',
                        description: gameDetails['description_raw'] ?? '',
                        imageURL: gameDetails['background_image'] ?? '',
                      );

                      // ignore: use_build_context_synchronously
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => GameDetailsPage(game: game),
                        ),
                      );
                    }
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
        future: fetchGameSuggestions(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final suggestionList = snapshot.data!;
            return ListView.builder(
              itemCount: suggestionList.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(suggestionList[index]),
                onTap: () async {
                  final gameDetails =
                      await fetchGameDetails(suggestionList[index]);
                  if (gameDetails != null) {
                    final game = Game(
                      name: gameDetails['name'] ?? 'Unknown Game',
                      description: gameDetails['description_raw'] ?? '',
                      imageURL: gameDetails['background_image'] ?? '',
                    );

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => GameDetailsPage(game: game),
                      ),
                    );
                  }
                },
              ),
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
