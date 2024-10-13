import 'package:flutter/material.dart';
import 'package:metatube_flutter/screens/splash_screen.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
      minimumSize: Size(400, 780),
      size: Size(600, 780),
      center: true,
      title: "MetaTube");

  windowManager.waitUntilReadyToShow(windowOptions);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
