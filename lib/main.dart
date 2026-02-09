import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fetch initial link (cold start)
  String? initialLink;
  try {
    initialLink = await AppLinks().getInitialLinkString();
    print('Initial link (cold start): $initialLink');
  } catch (e) {
    print('Error fetching initial link: $e');
  }

  runApp(MyApp(initialLink: initialLink));
}

class MyApp extends StatelessWidget {
  final String? initialLink;
  const MyApp({super.key, this.initialLink});

  @override
  Widget build(BuildContext context) {
    // Determine initial route based on deep link
    String? initialRoute = '/';
    if (initialLink != null) {
      final uri = Uri.parse(initialLink!);
      if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'number') {
        initialRoute = '/number/${uri.pathSegments[1]}';
      }
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/number/:id', page: () => NumberPage()),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppLinks _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();

    // Listen for deep links when the app is running (foreground/background)
    _appLinks.uriLinkStream.listen((uri) {
      if (uri != null) {
        print('Received deep link while running: $uri');
        if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'number') {
          final id = uri.pathSegments[1];
          Get.toNamed('/number/$id');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Waiting for deep link..."),
            SizedBox(height: 20),
            Text(
              "Try: myapp://tometo/number/123",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class NumberPage extends StatefulWidget {
  const NumberPage({super.key});

  @override
  State<NumberPage> createState() => _NumberPageState();
}

class _NumberPageState extends State<NumberPage> {
    final AppLinks _appLinks = AppLinks();
@override
  void initState() {
    super.initState();

    // Listen for deep links when the app is running (foreground/background)
    _appLinks.uriLinkStream.listen((uri) {
      if (uri != null) {
        print('Received deep link while running: $uri');
        if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'number') {
          final id = uri.pathSegments[1];
          Get.toNamed('/number/$id');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = Get.parameters['id'] ?? 'unknown';
    return Scaffold(
      appBar: AppBar(title: Text("Number Page")),
      body: Center(
        child: Text(
          "Number from URL: $id",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
