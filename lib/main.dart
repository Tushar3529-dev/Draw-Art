import 'package:drawing_app/feature/draw/model/drawing.dart';
import 'package:drawing_app/feature/draw/model/stroke.dart';
import 'package:drawing_app/feature/draw/model/offset.dart';
import 'package:drawing_app/feature/draw/presentation/darw_page.dart';
import 'package:drawing_app/feature/home/presentation/home_screen.dart';
import 'package:drawing_app/feature/splash/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hide both status bar (top) and navigation bar (bottom)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await Hive.initFlutter();

  // Register all Hive adapters
  Hive.registerAdapter(OffsetCustomAdapter());
  Hive.registerAdapter(StrokeAdapter());
  Hive.registerAdapter(DrawingAdapter());

  // Open a box for Drawing objects (type-safe)
  await Hive.openBox<Drawing>('drawing');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drawing App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/draw': (context) => const DrawScreen(),
      },
    );
  }
}
