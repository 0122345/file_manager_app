import 'package:flutter/material.dart';
import 'components/file_browser/view/onboarding.dart';
//import 'components/file_browser/view/home.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

@override
  // void initState() {
  //   //super.initState();
  //   initialization();
  // }

  // void initialization() async {
  //   FlutterNativeSplash.remove();
  // }



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ZomoOnboardingScreen(),
      //HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

