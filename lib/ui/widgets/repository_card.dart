import 'dart:ui'; // For ImageFilter
import 'dart:ui'; // For ImageFilter
import 'dart:ui'; // For ImageFilter
// import 'dart:ui'; // For ImageFilter // This was duplicated, removing one
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // Import for Share functionality
import '../../models/repository.dart'; // Adjust import path as needed
import '../../services/api_service.dart'; // Import ApiService
import '../screens/deepwiki_page.dart'; // Import for DeepWikiPage

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
    return Stack(
      fit: StackFit.expand,
      children: [
        // Layer 1: Background Image (Author's Avatar)
        SizedBox.expand( // Ensures the image tries to fill the space
          child: widget.repository.avatar.isNotEmpty
              ? Image.network(
                  widget.repository.avatar,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white54,
                          size: 100,
                        ),
                      ),
                    );
                  },
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
                )
              : Container( // Fallback if avatar is empty
                  color: Colors.grey[800],
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white54,
                      size: 100,
                    ),
                  ),
                ),
        ),
        
        // Layer 2: Blur Layer (applied to the background image)
        Positioned.fill(
          child: ClipRRect( // Important to contain the blur
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0), // Increased blur
              child: Container(
                color: Colors.black.withOpacity(0.1), // Slight tint for the blur
              ),
            ),
          ),
        ),

        // Layer 3: Actual Content Area
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Clear Avatar
                SizedBox(
                  width: 150,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: widget.repository.avatar.isNotEmpty
                        ? Image.network(
                            widget.repository.avatar,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[700]?.withOpacity(0.5), // Slightly transparent fallback
                                child: const Center(
                                  child: Icon(
                                    Icons.person_off_outlined, // Different icon for clear avatar error
                                    color: Colors.white70,
                                    size: 75,
                                  ),
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[700]?.withOpacity(0.5),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0, // Thinner progress bar
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white70),
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container( // Fallback if avatar is empty for the clear view
                            decoration: BoxDecoration(
                              color: Colors.grey[700]?.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person_outline, // Different icon
                                color: Colors.white70,
                                size: 75,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20), // Increased spacing

                // Repository Name & Author
                Text(
                  '${widget.repository.author} / ${widget.repository.name}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: const [
                          Shadow(
                              blurRadius: 3.0,
                              color: Colors.black87,
                              offset: Offset(1.5, 1.5))
                        ],
                      ),
                ),
                const SizedBox(height: 10), // Adjusted spacing

                // Description
                Text(
                  widget.repository.description,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        shadows: const [
                           Shadow(
                              blurRadius: 2.0,
                              color: Colors.black54,
                              offset: Offset(1.0, 1.0))
                        ],
                      ),
                ),
                const SizedBox(height: 18), // Adjusted spacing

                // Stats Row
                _buildStatsRow(context),
                const SizedBox(height: 10), // Adjusted spacing

                // Current Period Stars
                Text(
                  'Stars: ${widget.repository.currentPeriodStars} (this period)', // Clarified text
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.85),
                        shadows: const [
                           Shadow(
                              blurRadius: 2.0,
                              color: Colors.black54,
                              offset: Offset(1.0, 1.0))
                        ],
                      ),
                ),
                const SizedBox(height: 16), // Spacing before summary
                _buildSummarySection(), // AI Summary section
                const SizedBox(height: 20), // Spacing after summary, before buttons

                // Action Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.white, size: 28),
                      tooltip: 'Share',
                      onPressed: () async {
                        if (widget.repository.url.isNotEmpty) {
                          await Share.share(
                            widget.repository.url,
                            subject: 'Check out this repository: ${widget.repository.name}',
                          );
                        } else {
                          if (kDebugMode) {
                            print("Repository URL is empty, cannot share.");
                          }
                          // Optional: Show a SnackBar if context is available and it's appropriate
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(content: Text('Repository URL is not available to share.')),
                          // );
                        }
                      },
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.public, color: Colors.white, size: 28),
                      label: const Text(
                        "DeepWiki",
                        style: TextStyle(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                           shadows: [ // Add shadow for better visibility
                            Shadow(
                              blurRadius: 2.0,
                              color: Colors.black54,
                              offset: Offset(1.0, 1.0),
                            ),
                          ]
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.white.withOpacity(0.5)),
                        ),
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                      onPressed: () {
                        String originalUrl = widget.repository.url;
                        String deepWikiUrl = originalUrl; // Default to original

                        if (originalUrl.isNotEmpty && originalUrl.contains('github.com')) {
                          deepWikiUrl = originalUrl.replaceFirst('github.com', 'deepwiki.com');
                        } else if (originalUrl.isNotEmpty) {
                          // Fallback for non-GitHub URLs or if replacement somehow fails
                          // Use the repository name for a search query on DeepWiki
                          String repoNameForSearch = widget.repository.name; 
                          deepWikiUrl = 'https://deepwiki.com/search?q=${Uri.encodeComponent(repoNameForSearch)}';
                        } else {
                          if (kDebugMode) {
                            print("Repository URL is empty, cannot generate DeepWiki URL for ${widget.repository.name}.");
                          }
                          // Optionally, show a SnackBar or disable the button if URL is empty
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(content: Text('Repository URL is not available for DeepWiki.')),
                          // );
                          return; // Don't proceed if URL is empty
                        }
                        
                        if (kDebugMode) {
                          print("Navigating to DeepWiki: $deepWikiUrl for ${widget.repository.name}");
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeepWikiPage(url: deepWikiUrl),
                          ),
                        );
                      },
                    ),
                  ],
                )
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
    final theme = Theme.of(context);
    if (_isLoadingSummary) {
      return const SizedBox(
        height: 40, // Give loading indicator some space
        child: Center(child: CircularProgressIndicator()), // Use theme default color
      );
    } else if (_summaryError != null) {
      return Text(
        _summaryError!,
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
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
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9), // Keep high contrast against image bg
              height: 1.4,
            ),
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
          backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.8),
          foregroundColor: theme.colorScheme.onPrimaryContainer,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      );
    }
  }
}