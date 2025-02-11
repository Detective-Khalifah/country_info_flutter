import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Import for Android features.
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// // Import for iOS features.
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

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
    // #docregion platform_features
    // late final PlatformWebViewControllerCreationParams params;
    // if (WebViewPlatform.instance is WebKitWebViewPlatform) {
    //   params = WebKitWebViewControllerCreationParams(
    //     allowsInlineMediaPlayback: true,
    //     mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
    //   );
    // } else {
    //   params = const PlatformWebViewControllerCreationParams();
    // }

    // final WebViewController controller =
    //     WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.mapUrl));
    // WebViewPlatform.instance =
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Map View")),
      body: Stack(children: [
        WebViewWidget(
          controller: _controller,
          // gestureRecognizers: TapGestureRecognizer()
          //   ..onTap = () {
          //     _openMap(widget.mapUrl);
          //   }
        ),
        InkWell(onTap: () => _openMap(widget.mapUrl)),
      ]),
    );
  }

  Future<void> _openMap(String uri) async {
    final Uri url = Uri.parse(uri);
    if (!await launchUrl(url /*, mode: LaunchMode.externalApplication*/)) {
      throw 'Could not launch $url';
    }
  }
}
