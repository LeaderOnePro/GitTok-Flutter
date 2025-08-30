import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class DeepWikiPage extends StatefulWidget {
  final String url;

  const DeepWikiPage({super.key, required this.url});

  @override
  State<DeepWikiPage> createState() => _DeepWikiPageState();
}

class _DeepWikiPageState extends State<DeepWikiPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    // Check if we're on Windows and WebView is available
    if (defaultTargetPlatform == TargetPlatform.windows) {
      // On Windows, WebView might not be available - fallback to external browser
      _openInExternalBrowser();
      return;
    }
    
    try {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading progress
            },
            onPageStarted: (String url) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                _isLoading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {
              if (kDebugMode) {
                print('DeepWiki WebView error: ${error.description}');
              }
              setState(() {
                _hasError = true;
                _errorMessage = 'Failed to load page: ${error.description}';
                _isLoading = false;
              });
            },
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          ),
        );
      
      // Load the URL
      _controller.loadRequest(Uri.parse(widget.url));
    } catch (e) {
      if (kDebugMode) {
        print('DeepWiki WebView initialization error: $e');
      }
      setState(() {
        _hasError = true;
        _errorMessage = 'WebView not supported on this platform';
        _isLoading = false;
      });
    }
  }
  
  void _openInExternalBrowser() async {
    try {
      final uri = Uri.parse(widget.url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        // Close this page since we opened external browser
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = 'Cannot open URL: ${widget.url}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Error opening browser: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DeepWiki View'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        bottom: _isLoading
            ? const PreferredSize(
                preferredSize: Size.fromHeight(4.0),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.indigo,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : null,
        actions: [
          if (!_hasError)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
                _controller.reload();
              },
            ),
        ],
      ),
      body: _hasError
          ? _buildErrorView()
          : (defaultTargetPlatform == TargetPlatform.windows
              ? _buildWindowsFallback()
              : WebViewWidget(controller: _controller)),
    );
  }

  Widget _buildWindowsFallback() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.public,
              size: 64,
              color: Colors.indigo,
            ),
            const SizedBox(height: 16),
            const Text(
              'Opening in Browser',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'DeepWiki will open in your default web browser for the best experience on Windows.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.launch),
              label: const Text('Open in Browser'),
              onPressed: _openInExternalBrowser,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load DeepWiki',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  onPressed: () {
                    _initializeWebView();
                  },
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.launch),
                  label: const Text('Open in Browser'),
                  onPressed: _openInExternalBrowser,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
