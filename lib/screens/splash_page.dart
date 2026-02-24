import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription? _sub;
  bool _handledDeepLink = false;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    try {
      // Cold start
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _handledDeepLink = true;
        _navigateFromUri(uri);
      }

      // While app running
      _sub = _appLinks.uriLinkStream.listen((uri) {
        _navigateFromUri(uri);
      });

      // Normal splash delay
      await Future.delayed(const Duration(seconds: 2));

      if (!_handledDeepLink) {
        Get.toNamed("/profile");
      } else {
        Get.toNamed("/error");
      }
    } catch (_) {
      Get.toNamed("/error");
    }
  }

  void _navigateFromUri(Uri uri) {
    debugPrint("Deep Link Received: $uri");

    final path = uri.path;

    if (path.isNotEmpty && path != "/") {
      Get.toNamed(path);
      return;
    } else {
      Get.toNamed("/error");
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Splash Screen")));
  }
}
