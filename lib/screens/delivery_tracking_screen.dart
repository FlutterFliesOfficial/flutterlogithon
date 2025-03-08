import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:delivery_tracking/widgets/left_sidebar.dart';
import 'package:delivery_tracking/widgets/orders_list.dart';
import 'package:delivery_tracking/widgets/map_section.dart';

class DeliveryTrackingScreen extends StatefulWidget {
  const DeliveryTrackingScreen({super.key});

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          LeftSidebar(),
          OrdersList(),
          MapSection(),
        ],
      ),
    );
  }
}
