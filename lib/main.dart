import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_deep_linking/deep_link_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(DeepLinkController()); // Initialize once

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      unknownRoute: GetPage(name: '/error', page: () => ErrorPage()),
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/number', page: () => NumberPage()),
        GetPage(name: '/error', page: () => ErrorPage()),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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

class NumberPage extends StatelessWidget {
  const NumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments ?? 'unknown';
    return Scaffold(
      appBar: AppBar(title: Text("Number Page")),
      body: Center(
        child: Text(
          "Number from URL: ${id.toString()}",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Error Page")),
      body: Center(
        child: Text(
          'Error Page'
        ),
      ),
    );
  }
}