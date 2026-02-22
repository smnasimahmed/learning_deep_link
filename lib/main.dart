import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_deep_linking/screens/error_page.dart';
import 'package:learning_deep_linking/screens/home_page.dart';
import 'package:learning_deep_linking/screens/profile_page.dart';
import 'package:learning_deep_linking/screens/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
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
        GetPage(name: '/', page: () => SplashPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/profile', page: () => ProfilePage()),
        GetPage(name: '/error', page: () => ErrorPage()),
      ],
    );
  }
}
