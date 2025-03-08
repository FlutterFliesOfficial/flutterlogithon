import 'package:delivery_tracking/screens/dashboard_screen.dart';
import 'package:delivery_tracking/screens/delivery_tracking_screen.dart';
import 'package:delivery_tracking/screens/shipment_form_screen.dart';
import 'package:flutter/material.dart';

class DeliveryTrackingApp extends StatelessWidget {
  const DeliveryTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery Tracking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
      ),
      home: const DeliveryTrackingScreen(),
    );
  }
}
