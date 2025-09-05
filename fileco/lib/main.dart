import 'package:fileco/components/media/screens/audio_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/file_browser/view/onboarding.dart';
import 'components/media/services/audio_service.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioService()),
      ],
      child: MaterialApp(
        title: 'Music Player',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          fontFamily: 'SF Pro Display',
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

