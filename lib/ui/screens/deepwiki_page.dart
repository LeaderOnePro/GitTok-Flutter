import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DeepWikiPage extends StatefulWidget {
  final String url;

  const DeepWikiPage({super.key, required this.url});

  @override
  State<DeepWikiPage> createState() => _DeepWikiPageState();
}

class _DeepWikiPageState extends State<DeepWikiPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // Optional: You can set a NavigationDelegate for more control
      // ..setNavigationDelegate(
      //   NavigationDelegate(
      //     onProgress: (int progress) {
      //       // Update loading bar progress.
      //     },
      //     onPageStarted: (String url) {},
      //     onPageFinished: (String url) {},
      //     onWebResourceError: (WebResourceError error) {},
      //     onNavigationRequest: (NavigationRequest request) {
      //       // Example: Prevent navigation to other domains
      //       // if (!request.url.startsWith(widget.url)) { // Be careful with this logic
      //       //   return NavigationDecision.prevent;
      //       // }
      //       return NavigationDecision.navigate;
      //     },
      //   ),
      // )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DeepWiki View'),
        // Example: Add a loading indicator in the AppBar if desired
        // bottom: _isLoadingPage ? PreferredSize(
        //   preferredSize: Size.fromHeight(4.0),
        //   child: LinearProgressIndicator(),
        // ) : null,
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
