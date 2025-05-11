import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Import ApiService
import '../models/repository.dart'; // Import Repository model
import 'widgets/repository_card.dart'; // Import the new card widget

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  late Future<List<Repository>> _trendingRepositories;
  TrendingSince _selectedSince = TrendingSince.daily; // Default to daily

  @override
  void initState() {
    super.initState();
    _loadTrendingRepositories();
  }

  void _loadTrendingRepositories() {
    setState(() {
      _trendingRepositories = _apiService.fetchTrendingRepositories(_selectedSince);
    });
  }

  void _changeSince(TrendingSince since) {
    if (_selectedSince != since) {
      setState(() {
        _selectedSince = since;
        _loadTrendingRepositories(); // Reload data when since changes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitTok Flutter'),
        backgroundColor: Colors.black.withOpacity(0.3), // Make AppBar semi-transparent
        elevation: 0, // Remove shadow
        actions: [
          PopupMenuButton<TrendingSince>(
            initialValue: _selectedSince,
            onSelected: _changeSince,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<TrendingSince>>[
              const PopupMenuItem<TrendingSince>(
                value: TrendingSince.daily,
                child: Text('Today'),
              ),
              const PopupMenuItem<TrendingSince>(
                value: TrendingSince.weekly,
                child: Text('This Week'),
              ),
              const PopupMenuItem<TrendingSince>(
                value: TrendingSince.monthly,
                child: Text('This Month'),
              ),
            ],
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      extendBodyBehindAppBar: true, // Allow PageView content to go behind AppBar
      body: FutureBuilder<List<Repository>>(
        future: _trendingRepositories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // More engaging loading indicator (optional)
            return Container(
              color: Colors.black, // Match dark theme during load
              child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text("Loading Trending...", style: TextStyle(color: Colors.white70))
                    ],
                  )),
            );
          } else if (snapshot.hasError) {
            return Center(
               child: Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Text(
                    'Error loading repositories: ${snapshot.error}',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
               )
            );
          } else if (snapshot.hasData) {
            final repositories = snapshot.data!;
            if (repositories.isEmpty) {
              return const Center(child: Text('No trending repositories found.'));
            }
            // Use RepositoryCard inside PageView.builder
            return PageView.builder(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              pageSnapping: false,
              itemCount: repositories.length,
              itemBuilder: (context, index) {
                final repo = repositories[index];
                return RepositoryCard(repository: repo); // Use the RepositoryCard widget
              },
            );
          } else {
            return const Center(child: Text('No trending repositories found.'));
          }
        },
      ),
    );
  }
} 