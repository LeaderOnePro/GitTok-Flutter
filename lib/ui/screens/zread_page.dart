import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class ZreadPage extends StatefulWidget {
  final String url;

  const ZreadPage({super.key, required this.url});

  @override
  State<ZreadPage> createState() => _ZreadPageState();
}

class _ZreadPageState extends State<ZreadPage> {
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
                print('Zread WebView error: ${error.description}');
              }
              setState(() {
                _hasError = true;
                _errorMessage = 'Failed to load page: ${error.description}';
                _isLoading = false;
              });
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    } catch (e) {
      if (kDebugMode) {
        print('Zread WebView initialization error: $e');
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
        title: const Text('Zread Analysis'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        bottom: _isLoading
            ? const PreferredSize(
                preferredSize: Size.fromHeight(4.0),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.orange,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : null,
        actions: [
          if (!_hasError && defaultTargetPlatform != TargetPlatform.windows)
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
              Icons.analytics_outlined,
              size: 64,
              color: Colors.orange,
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
              'Zread will open in your default web browser for the best experience on Windows.',
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
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
              'Unable to load Zread',
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}