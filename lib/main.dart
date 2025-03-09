import 'package:delivery_tracking/service/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:delivery_tracking/app.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'; //C:\flutterapps\flutterlogithon\lib\screens\delivery_tracking_screen.dart
import 'package:delivery_tracking/screens/dashboard_screen.dart';
import 'package:delivery_tracking/screens/delivery_tracking_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Google Maps
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }

  // Initialize Supabase
  await SupabaseService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delivery Tracking',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/', // Home screen (Dashboard)
      routes: {
        '/': (context) => const DashboardScreen(), // Home screen
        '/tracking': (context) => const DeliveryTrackingScreen(),
      },
    );
  }
}
