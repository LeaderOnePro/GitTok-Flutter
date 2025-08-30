import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ZreadPage extends StatefulWidget {
  final String url;

  const ZreadPage({super.key, required this.url});

  @override
  State<ZreadPage> createState() => _ZreadPageState();
}

class _ZreadPageState extends State<ZreadPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zread View'),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}