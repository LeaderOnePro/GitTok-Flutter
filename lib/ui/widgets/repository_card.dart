import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart' as share_plus; // Import for Share functionality
import 'package:url_launcher/url_launcher.dart'; // Import for URL launching
import '../../models/repository.dart'; // Adjust import path as needed
import '../../services/api_service.dart'; // Import ApiService
import '../screens/deepwiki_page.dart'; // Import for DeepWikiPage
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
    // Get language-based color system
    final textColor = LanguageGradients.getTextColorForLanguage(widget.repository.language);
    final primaryColor = LanguageGradients.getLanguagePrimaryColor(widget.repository.language);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LanguageGradients.getLanguageGradient(widget.repository.language),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Subtle overlay for better text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(0.3),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
          
          // Main content with improved hierarchy
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top section: Author info (compact)
                  _buildAuthorSection(textColor, primaryColor),
                  
                  // Spacer - push main content to golden ratio position
                  const Spacer(flex: 2),
                  
                  // Main section: Project focus area  
                  _buildProjectSection(textColor, primaryColor),
                  
                  const Spacer(flex: 1),
                  
                  // Bottom section: Actions
                  _buildActionSection(textColor, primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Top author info section - compact design
  Widget _buildAuthorSection(Color textColor, Color primaryColor) {
    return Row(
      children: [
        // Small avatar 
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: textColor.withOpacity(0.3), width: 1),
          ),
          child: ClipOval(
            child: widget.repository.avatar.isNotEmpty
                ? Image.network(
                    widget.repository.avatar,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person, color: textColor.withOpacity(0.7), size: 20);
                    },
                  )
                : Icon(Icons.person, color: textColor.withOpacity(0.7), size: 20),
          ),
        ),
        const SizedBox(width: 8),
        
        // Author name
        Text(
          widget.repository.author,
          style: TextStyle(
            color: textColor.withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        const Spacer(),
        
        // Language tag - using language primary color
        if (widget.repository.language.isNotEmpty && widget.repository.language != 'Unknown')
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withOpacity(0.3)),
            ),
            child: Text(
              widget.repository.language,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  // Main project info section - 48px large title
  Widget _buildProjectSection(Color textColor, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Project name - 48px bold, following visual hierarchy requirements
        Text(
          widget.repository.name,
          style: TextStyle(
            color: textColor,
            fontSize: 48,
            fontWeight: FontWeight.w900,
            height: 1.1,
            letterSpacing: -1.0,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 16),
        
        // Description
        Text(
          widget.repository.description,
          style: TextStyle(
            color: textColor.withOpacity(0.9),
            fontSize: 16,
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 20),
        
        // Stats row - more compact
        Row(
          children: [
            _buildStatChip(Icons.star_outline, widget.repository.stars.toString(), textColor, primaryColor),
            const SizedBox(width: 12),
            _buildStatChip(Icons.fork_right_outlined, widget.repository.forks.toString(), textColor, primaryColor),
            const SizedBox(width: 12),
            _buildStatChip(Icons.trending_up, '${widget.repository.currentPeriodStars}', textColor, primaryColor),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // AI summary section
        _buildEnhancedSummarySection(textColor, primaryColor),
      ],
    );
  }

  // Stat chip component
  Widget _buildStatChip(IconData icon, String text, Color textColor, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor.withOpacity(0.8)),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: textColor.withOpacity(0.9),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Bottom action section - clear primary/secondary hierarchy
  Widget _buildActionSection(Color textColor, Color primaryColor) {
    return Row(
      children: [
        // Primary action - View project (large button)
        Expanded(
          flex: 3,
          child: ElevatedButton.icon(
            icon: Icon(Icons.launch, color: textColor, size: 20),
            label: Text(
              'View Project',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: textColor.withOpacity(0.15),
              foregroundColor: textColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: textColor.withOpacity(0.3)),
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
        
        const SizedBox(width: 12),
        
        // Secondary actions - tool buttons
        _buildToolButton(
          icon: Icons.public,
          tooltip: 'DeepWiki',
          color: textColor,
          onTap: () => _openDeepWiki(),
        ),
        
        const SizedBox(width: 8),
        
        _buildToolButton(
          icon: Icons.analytics_outlined,
          tooltip: 'Zread',
          color: Colors.orange,
          onTap: () => _openZread(),
        ),
        
        const SizedBox(width: 8),
        
        _buildToolButton(
          icon: Icons.share,
          tooltip: 'Share',
          color: textColor,
          onTap: () => _shareRepository(),
        ),
      ],
    );
  }

  // Tool button component
  Widget _buildToolButton({
    required IconData icon,
    required String tooltip,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
      ),
    );
  }

  // Enhanced AI summary section
  Widget _buildEnhancedSummarySection(Color textColor, Color primaryColor) {
    if (_isLoadingSummary) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: textColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
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
            Text(
              'AI 正在分析...',
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontSize: 13,
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
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          _summaryError!,
          style: TextStyle(
            color: Colors.red[300],
            fontSize: 13,
          ),
        ),
      );
    }

    if (_summary != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: textColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
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
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _summary!,
              style: TextStyle(
                color: textColor.withOpacity(0.9),
                fontSize: 13,
                height: 1.3,
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
        style: TextStyle(color: primaryColor, fontSize: 13),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: primaryColor.withOpacity(0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

  void _openZread() async {
    String repoName = widget.repository.name;
    if (repoName.contains('/')) {
      repoName = repoName.split('/').last;
    }

    final zreadUrl = 'https://zread.ai/${widget.repository.author}/$repoName';

    try {
      final uri = Uri.parse(zreadUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error launching Zread URL: $e");
      }
    }
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