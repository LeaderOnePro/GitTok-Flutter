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
        actions: <Widget>[
          _buildFilterChips(),
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
                      CircularProgressIndicator(), // Use theme default color
                      SizedBox(height: 16),
                      Text("Loading Trending...", style: TextStyle(color: Colors.white70)) // Keep this for dark loading screen
                    ],
                  )),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading repositories: ${snapshot.error}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final repositories = snapshot.data!;
            if (repositories.isEmpty) {
              return Center(
                child: Text(
                  'No trending repositories found.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                ),
              );
            }
            // Use RepositoryCard inside PageView.builder
            return PageView.builder(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
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

  Widget _buildFilterChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: TrendingSince.values.map((TrendingSince since) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: FilterChip(
            label: Text(since.displayName),
            selected: _selectedSince == since,
            onSelected: (bool selected) {
              if (selected) {
                _changeSince(since);
              }
            },
            showCheckmark: false, // Optional: to make it look more like tabs
            selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
            labelStyle: TextStyle(
              color: _selectedSince == since
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        );
      }).toList(),
    );
  }
}

extension TrendingSinceExtension on TrendingSince {
  String get displayName {
    switch (this) {
      case TrendingSince.daily:
        return 'Day';
      case TrendingSince.weekly:
        return 'Week';
      case TrendingSince.monthly:
        return 'Month';
      default:
        return '';
    }
  }
}