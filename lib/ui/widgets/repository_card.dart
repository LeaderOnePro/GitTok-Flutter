import 'dart:ui'; // For ImageFilter (BackdropFilter)
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart' as share_plus; // Import for Share functionality
import 'package:url_launcher/url_launcher.dart'; // Import for URL launching
import '../../models/repository.dart'; // Adjust import path as needed
import '../../services/api_service.dart'; // Import ApiService
import '../screens/deepwiki_page.dart'; // Import for DeepWikiPage
import '../screens/zread_page.dart'; // Import for ZreadPage
import '../theme/language_colors.dart'; // Import language color system

// Redesigned RepositoryCard with improved visual hierarchy
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
  final ApiService _apiService = ApiService();

  // Method to fetch summary
  Future<void> _fetchSummary() async {
    if (_isLoadingSummary || _summary != null) return;

    setState(() {
      _isLoadingSummary = true;
      _summaryError = null;
    });

    try {
      final summaryResult = await _apiService.fetchSummary(
        widget.repository.author,
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
        _summaryError = "无法加载总结";
        _isLoadingSummary = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get language-based color system for accent colors
    final primaryColor = LanguageGradients.getLanguagePrimaryColor(widget.repository.language);
    
    return Stack(
      fit: StackFit.expand,
      children: [
        // Layer 1: Background Image (Repository owner's avatar with breathing effect)
        SizedBox.expand(
          child: widget.repository.avatar.isNotEmpty
              ? Image.network(
                  widget.repository.avatar,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LanguageGradients.getLanguageGradient(widget.repository.language),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LanguageGradients.getLanguageGradient(widget.repository.language),
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: LanguageGradients.getLanguageGradient(widget.repository.language),
                  ),
                ),
        ),
        
        // Layer 2: Blur and overlay for readability with breathing effect
        Positioned.fill(
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ),
        
        // Layer 3: Main content with enhanced text shadows for readability
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top section: Author info (compact) with clear avatar
                _buildAuthorSection(primaryColor),
                
                // Spacer - push main content to golden ratio position
                const Spacer(flex: 2),
                
                // Main section: Project focus area  
                _buildProjectSection(primaryColor),
                
                const Spacer(flex: 1),
                
                // Bottom section: Actions with text labels
                _buildActionSection(primaryColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Top author info section with clear avatar and strong text shadows
  Widget _buildAuthorSection(Color primaryColor) {
    return Row(
      children: [
        // Clear avatar (not blurred, floating above background)
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(
            child: widget.repository.avatar.isNotEmpty
                ? Image.network(
                    widget.repository.avatar,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: primaryColor.withOpacity(0.3),
                        child: Icon(Icons.person, color: Colors.white, size: 24),
                      );
                    },
                  )
                : Container(
                    color: primaryColor.withOpacity(0.3),
                    child: Icon(Icons.person, color: Colors.white, size: 24),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        
        // Author name with enhanced shadow
        Text(
          widget.repository.author,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(
                blurRadius: 8.0,
                color: Colors.black,
                offset: Offset(1.0, 1.0),
              ),
              Shadow(
                blurRadius: 16.0,
                color: Colors.black,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        
        const Spacer(),
        
        // Language tag - using language primary color with shadow
        if (widget.repository.language.isNotEmpty && widget.repository.language != 'Unknown')
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              widget.repository.language,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                shadows: [
                  Shadow(
                    blurRadius: 2.0,
                    color: Colors.black54,
                    offset: Offset(0.5, 0.5),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // Main project info section - enhanced for image background readability
  Widget _buildProjectSection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Project name - 48px bold with strong shadows for readability
        Text(
          widget.repository.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.w900,
            height: 1.1,
            letterSpacing: -1.0,
            shadows: [
              Shadow(
                blurRadius: 12.0,
                color: Colors.black,
                offset: Offset(2.0, 2.0),
              ),
              Shadow(
                blurRadius: 24.0,
                color: Colors.black,
                offset: Offset(4.0, 4.0),
              ),
            ],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 16),
        
        // Description with enhanced readability
        Text(
          widget.repository.description,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.4,
            fontWeight: FontWeight.w400,
            shadows: [
              Shadow(
                blurRadius: 8.0,
                color: Colors.black,
                offset: Offset(1.0, 1.0),
              ),
              Shadow(
                blurRadius: 16.0,
                color: Colors.black,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 20),
        
        // Stats row with enhanced shadows
        Row(
          children: [
            _buildStatChip(Icons.star_outline, widget.repository.stars.toString(), primaryColor),
            const SizedBox(width: 12),
            _buildStatChip(Icons.fork_right_outlined, widget.repository.forks.toString(), primaryColor),
            const SizedBox(width: 12),
            _buildStatChip(Icons.trending_up, '${widget.repository.currentPeriodStars}', primaryColor),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // AI summary section
        _buildEnhancedSummarySection(primaryColor),
      ],
    );
  }

  // Stat chip component with shadow for floating effect
  Widget _buildStatChip(IconData icon, String text, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  blurRadius: 2.0,
                  color: Colors.black,
                  offset: Offset(0.5, 0.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bottom action section with text labels - MUCH clearer UX
  Widget _buildActionSection(Color primaryColor) {
    return Column(
      children: [
        // Primary action - View Project (full width for maximum tap area)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.launch, color: Colors.white, size: 20),
            label: const Text(
              'View on GitHub',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.6),
              foregroundColor: Colors.white,
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
            ),
            onPressed: () async {
              if (widget.repository.url.isNotEmpty) {
                final uri = Uri.parse(widget.repository.url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              }
            },
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Secondary actions row with CLEAR TEXT LABELS
        Row(
          children: [
            // DeepWiki - now with clear text label
            Expanded(
              child: TextButton.icon(
                icon: const Icon(Icons.public, color: Colors.white, size: 18),
                label: const Text(
                  'DeepWiki',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    shadows: [
                      Shadow(
                        blurRadius: 4.0,
                        color: Colors.black,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                ),
                onPressed: () => _openDeepWiki(),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Zread - now with clear text label  
            Expanded(
              child: TextButton.icon(
                icon: const Icon(Icons.analytics_outlined, color: Colors.white, size: 18),
                label: const Text(
                  'Zread',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    shadows: [
                      Shadow(
                        blurRadius: 4.0,
                        color: Colors.black,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.orange.withOpacity(0.7),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.orange.withOpacity(0.5)),
                  ),
                ),
                onPressed: () => _openZread(),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Share - compact but still clear
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.4),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
              ),
              onPressed: () => _shareRepository(),
              child: const Text(
                'Share',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Enhanced AI summary section with better contrast on image background
  Widget _buildEnhancedSummarySection(Color primaryColor) {
    if (_isLoadingSummary) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'AI 正在分析...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                shadows: [
                  Shadow(
                    blurRadius: 2.0,
                    color: Colors.black,
                    offset: Offset(0.5, 0.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (_summaryError != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          _summaryError!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.black,
                offset: Offset(0.5, 0.5),
              ),
            ],
          ),
        ),
      );
    }

    if (_summary != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: primaryColor, size: 14),
                const SizedBox(width: 4),
                Text(
                  'AI 总结',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    shadows: const [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black,
                        offset: Offset(0.5, 0.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _summary!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.3,
                shadows: [
                  Shadow(
                    blurRadius: 4.0,
                    color: Colors.black,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }

    // AI summary button
    return OutlinedButton.icon(
      icon: Icon(Icons.psychology, color: primaryColor, size: 16),
      label: Text(
        'AI 总结',
        style: TextStyle(
          color: primaryColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          shadows: const [
            Shadow(
              blurRadius: 2.0,
              color: Colors.black,
              offset: Offset(0.5, 0.5),
            ),
          ],
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: primaryColor.withOpacity(0.8)),
        backgroundColor: Colors.black.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: _fetchSummary,
    );
  }

  // Action methods
  void _openDeepWiki() {
    String originalUrl = widget.repository.url;
    String deepWikiUrl = originalUrl;

    if (originalUrl.isNotEmpty && originalUrl.contains('github.com')) {
      deepWikiUrl = originalUrl.replaceFirst('github.com', 'deepwiki.com');
    } else if (originalUrl.isNotEmpty) {
      String repoNameForSearch = widget.repository.name;
      deepWikiUrl = 'https://deepwiki.com/search?q=${Uri.encodeComponent(repoNameForSearch)}';
    } else {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeepWikiPage(url: deepWikiUrl),
      ),
    );
  }

  void _openZread() {
    String repoName = widget.repository.name;
    if (repoName.contains('/')) {
      repoName = repoName.split('/').last;
    }

    final zreadUrl = 'https://zread.ai/${widget.repository.author}/$repoName';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ZreadPage(url: zreadUrl),
      ),
    );
  }

  void _shareRepository() async {
    if (widget.repository.url.isNotEmpty) {
      await share_plus.Share.share(
        widget.repository.url,
        subject: 'Check out this repository: ${widget.repository.name}',
      );
    }
  }
}