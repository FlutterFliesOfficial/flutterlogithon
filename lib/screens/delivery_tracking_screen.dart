// import 'package:flutter/material.dart';
// import 'package:delivery_tracking/widgets/left_sidebar.dart';
// import 'package:delivery_tracking/widgets/orders_list.dart';
// import 'package:delivery_tracking/widgets/map_section.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class DeliveryTrackingScreen extends StatefulWidget {
//   const DeliveryTrackingScreen({super.key});

//   @override
//   State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
// }

// class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
//   // Default selected route (New York → Chicago)
//   List<LatLng> selectedRoute = [
//     const LatLng(40.7128, -74.0060), // New York
//     const LatLng(41.8781, -87.6298), // Chicago
//   ];

//   // Function to update selected route from OrdersList
//   void _updateSelectedRoute(List<LatLng> newRoute) {
//     setState(() {
//       selectedRoute = newRoute;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           const LeftSidebar(),
//           OrdersList(
//               onOrderSelected: _updateSelectedRoute), // Send update function
//           MapSection(
//               routeCoordinates: selectedRoute), // Pass selected route to map
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:delivery_tracking/widgets/left_sidebar.dart';
import 'package:delivery_tracking/widgets/orders_list.dart';
import 'package:delivery_tracking/widgets/map_section.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryTrackingScreen extends StatefulWidget {
  const DeliveryTrackingScreen({super.key});

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
  List<LatLng> selectedRoute = []; // Stores the selected order's route

  void _updateSelectedRoute(List<LatLng> newRoute) {
    setState(() {
      selectedRoute = newRoute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const LeftSidebar(),
          OrdersList(
              onOrderSelected: _updateSelectedRoute), // Send update function
          MapSection(
              routeCoordinates: selectedRoute), // Pass selected route to map
        ],
      ),
    );
  }
}
