import 'dart:ui'; // For ImageFilter
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:flutter/material.dart';
import '../../models/repository.dart'; // Adjust import path as needed
import '../../services/api_service.dart'; // Import ApiService

// Convert to StatefulWidget
class RepositoryCard extends StatefulWidget {
  final Repository repository;

  const RepositoryCard({super.key, required this.repository});

  @override
  State<RepositoryCard> createState() => _RepositoryCardState();
}

class _RepositoryCardState extends State<RepositoryCard> {
  // State variables for AI Summary
  String? _summary;
  bool _isLoadingSummary = false;
  String? _summaryError;
  final ApiService _apiService = ApiService(); // Instance of ApiService

  // Method to fetch summary
  Future<void> _fetchSummary() async {
    if (_isLoadingSummary || _summary != null) return; // Prevent multiple fetches

    setState(() {
      _isLoadingSummary = true;
      _summaryError = null; // Clear previous errors
    });

    try {
      final summaryResult = await _apiService.fetchSummary(
        widget.repository.author, // Use widget.repository here
        widget.repository.name,
      );
      setState(() {
        _summary = summaryResult;
        _isLoadingSummary = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching summary for ${widget.repository.name}: $e");
      }
      setState(() {
        _summaryError = "无法加载总结"; // User-friendly error message
        _isLoadingSummary = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for dynamic sizing
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand, // Make stack fill the PageView item
      children: [
        // 1. Background Image (Author's Avatar)
        if (widget.repository.avatar.isNotEmpty)
          Image.network(
            widget.repository.avatar,
            fit: BoxFit.cover,
            // Add error builder to handle potential loading failures gracefully
            errorBuilder: (context, error, stackTrace) {
              // Display a placeholder or icon if avatar fails to load
              return Container(
                color: Colors.grey[800], // Dark placeholder background
                child: const Center(
                  child: Icon(
                    Icons.person, // Placeholder icon
                    color: Colors.white54,
                    size: 100,
                  ),
                ),
              );
            },
             // Optional: Add a loading builder for a smoother experience
             loadingBuilder: (context, child, loadingProgress) {
               if (loadingProgress == null) return child;
               return Container(
                 color: Colors.grey[800],
                 child: Center(
                   child: CircularProgressIndicator(
                     value: loadingProgress.expectedTotalBytes != null
                         ? loadingProgress.cumulativeBytesLoaded /
                             loadingProgress.expectedTotalBytes!
                         : null,
                   ),
                 ),
               );
            },
          ),
        // Placeholder if avatar URL is empty
        if (widget.repository.avatar.isEmpty)
           Container(
             color: Colors.grey[800],
             child: const Center(
               child: Icon(
                 Icons.person, // Placeholder icon
                 color: Colors.white54,
                 size: 100,
               ),
             ),
           ),

        // 2. Frosted Glass Overlay for content
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Adjust blur intensity
            child: Container(
              // Semi-transparent black background for the blur effect
              color: Colors.black.withOpacity(0.3), // Adjust opacity
            ),
          ),
        ),

        // 3. Content Area (Centered)
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0), // Adjust padding if needed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- Repository Name & Author ---
                Text(
                  '${widget.repository.author} / ${widget.repository.name}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white, // White text for better contrast
                    fontWeight: FontWeight.bold,
                    shadows: [ // Add a subtle shadow for readability
                      Shadow(
                        blurRadius: 4.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ]
                  ),
                ),
                const SizedBox(height: 16),

                // --- Description ---
                Text(
                  widget.repository.description,
                  textAlign: TextAlign.center,
                  maxLines: 4, // Limit description lines
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                     shadows: [ // Add a subtle shadow
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(1.0, 1.0),
                      ),
                    ]
                  ),
                ),
                const SizedBox(height: 24),

                // --- Stats Row (Stars, Forks, Language) ---
                _buildStatsRow(context),

                const SizedBox(height: 12),

                 // --- Current Period Stars ---
                Text(
                  'Stars today: ${widget.repository.currentPeriodStars}', // Adjust text based on filter later
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 20), // Add space before summary section

                // --- AI Summary Section ---
                _buildSummarySection(), // Build the summary UI dynamically

                // TODO: Add Action Buttons (Share, View on GitHub?)

              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget for the stats row
  Widget _buildStatsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatItem(context, Icons.star_outline, widget.repository.stars.toString()),
        const SizedBox(width: 24),
        _buildStatItem(context, Icons.fork_right_outlined, widget.repository.forks.toString()),
        const SizedBox(width: 24),
        if (widget.repository.language.isNotEmpty && widget.repository.language != 'Unknown')
          _buildStatItem(context, Icons.code, widget.repository.language),
      ],
    );
  }

  // Helper widget for individual stat items
  Widget _buildStatItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white.withOpacity(0.8)),
        const SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.9),
             shadows: [ // Add a subtle shadow
              Shadow(
                blurRadius: 1.0,
                color: Colors.black.withOpacity(0.4),
                offset: const Offset(1.0, 1.0),
              ),
            ]
          ),
        ),
      ],
    );
  }

  // Helper widget for the Summary section UI
  Widget _buildSummarySection() {
    if (_isLoadingSummary) {
      return const SizedBox(
        height: 40, // Give loading indicator some space
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    } else if (_summaryError != null) {
      return Text(
        _summaryError!,
        style: const TextStyle(color: Colors.redAccent),
        textAlign: TextAlign.center,
      );
    } else if (_summary != null) {
      // Display the summary
      return Container(
         padding: const EdgeInsets.all(12),
         decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2), // Slightly different background for summary
            borderRadius: BorderRadius.circular(8),
         ),
         child: Text(
            _summary!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withOpacity(0.9), height: 1.4),
            maxLines: 6, // Limit summary lines as well
            overflow: TextOverflow.ellipsis,
         ),
      );
    } else {
      // Show the button to fetch summary
      return ElevatedButton.icon(
        icon: const Icon(Icons.auto_awesome), // Sparkle icon for AI
        label: const Text('获取 AI 总结'),
        onPressed: _fetchSummary, // Call the fetch method
        style: ElevatedButton.styleFrom(
          //foregroundColor: Colors.white, backgroundColor: Colors.deepPurple.withOpacity(0.7), // Button styling
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      );
    }
  }
} 