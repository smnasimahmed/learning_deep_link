import 'package:get/get.dart';
import 'package:app_links/app_links.dart';

class DeepLinkController extends GetxController {
  final AppLinks _appLinks = AppLinks();

  RxnString deepLink = RxnString();
  late Worker _worker;

  @override
  void onInit() {
    super.onInit();

    // React whenever deepLink changes
    _worker = ever(deepLink, _handleDeepLink);

    _initDeepLinks();
  }

  void _initDeepLinks() async {
    // Cold start
    final initial = await _appLinks.getInitialLinkString();
    if (initial != null) {
      deepLink.value = initial;
    }

    // While app running
    _appLinks.uriLinkStream.listen((uri) {
      if (uri != null) {
        deepLink.value = uri.toString();
      }
    });
  }

  void _handleDeepLink(String? link) {
  if (link == null) return;

  final uri = Uri.parse(link);

  if (uri.pathSegments.isNotEmpty &&
      uri.pathSegments[0] == 'number' &&
      uri.pathSegments.length > 1) {

    final id = uri.pathSegments[1];

    print('Navigate to: /number/$id'); // Debug

    Get.toNamed('/number',arguments: id);
    return;
  }

  Get.toNamed('/error');
}

  // void _handleDeepLink(String? link) {
  //   // If null → stay on Home
  //   if (link == null) return;

  //   Uri uri;

  //   // Check if URL is valid format
  //   try {
  //     uri = Uri.parse(link);
  //   } catch (e) {
  //     _goToError();
  //     return;
  //   }

  //   // No path → invalid
  //   if (uri.pathSegments.isEmpty) {
  //     _goToError();
  //     return;
  //   }

  //   // Route handling
  //   switch (uri.pathSegments[0]) {
  //     case 'number':
  //       if (uri.pathSegments.length > 1) {
  //         final id = uri.pathSegments[1];

  //         // Prevent duplicate navigation
  //         if (Get.currentRoute != '/number/$id') {
  //           Get.toNamed('/number/$id');
  //         }
  //       } else {
  //         _goToError();
  //       }
  //       break;

  //     default:
  //       _goToError();
  //   }
  // }

  void _goToError() {
    if (Get.currentRoute != '/error') {
      Get.toNamed('/error');
    }
  }

  @override
  void onClose() {
    _worker.dispose();
    super.onClose();
  }
}