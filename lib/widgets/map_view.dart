import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapView extends StatefulWidget {
  final String mapUrl;

  const MapView({super.key, required this.mapUrl});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.mapUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Map View"), automaticallyImplyLeading: false),
      body: Stack(children: [
        WebViewWidget(
          controller: _controller,
        ),
        InkWell(onTap: () => _openMap(widget.mapUrl)),
      ]),
    );
  }

  Future<void> _openMap(String uri) async {
    final Uri url = Uri.parse(uri);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
