import 'package:flutter/foundation.dart';

class Repository {
  final String author;
  final String name;
  final String avatar;
  final String url;
  final String description;
  final String language;
  final String languageColor;
  final int stars;
  final int forks;
  final int currentPeriodStars;
  final List<Contributor> builtBy;
  String? summary; // AI summary, optional

  Repository({
    required this.author,
    required this.name,
    required this.avatar,
    required this.url,
    required this.description,
    required this.language,
    required this.languageColor,
    required this.stars,
    required this.forks,
    required this.currentPeriodStars,
    required this.builtBy,
    this.summary,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    // Safely handle the 'builtBy' list
    List<Contributor> contributors = []; // Default to empty list
    if (json['builtBy'] != null && json['builtBy'] is List) {
      // Only proceed if 'builtBy' exists and is a list
      var builtByList = json['builtBy'] as List;
      // Add another try-catch here for safety during Contributor mapping
      try {
         contributors = builtByList
           .where((i) => i is Map<String, dynamic>) // Ensure items are maps
           .map((i) => Contributor.fromJson(i as Map<String, dynamic>))
           .toList();
      } catch (e) {
          if (kDebugMode) {
            print('Error parsing contributors for repo ${json['name']}: $e');
            // Optionally print the problematic 'builtBy' data
            // print('Problematic builtBy data: ${json['builtBy']}');
          }
          // Keep contributors as empty list on error
      }
    }

    return Repository(
      author: json['author'] ?? 'Unknown Author', // Add null checks for safety
      name: json['name'] ?? 'Unknown Repo',     // Add null checks for safety
      avatar: json['avatar'] ?? '',             // Provide default empty string
      url: json['url'] ?? '',                   // Provide default empty string
      description: json['description'] ?? '',
      language: json['language'] ?? 'Unknown',
      languageColor: json['languageColor'] ?? '#cccccc',
      stars: json['stars'] ?? 0,                // Provide default 0
      forks: json['forks'] ?? 0,                // Provide default 0
      currentPeriodStars: json['currentPeriodStars'] ?? 0, // Provide default 0
      builtBy: contributors, // Use the safely processed list
      summary: json['summary'],
    );
  }
}

class Contributor {
  final String username;
  final String href;
  final String avatar;

  Contributor({
    required this.username,
    required this.href,
    required this.avatar,
  });

  factory Contributor.fromJson(Map<String, dynamic> json) {
    return Contributor(
      username: json['username'] ?? 'Unknown User', // Add null checks
      href: json['href'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }
} 