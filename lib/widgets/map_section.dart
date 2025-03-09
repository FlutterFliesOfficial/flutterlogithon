import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSection extends StatefulWidget {
  final List<LatLng> routeCoordinates; // Route from selected order

  const MapSection({super.key, required this.routeCoordinates});

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _animateCamera(); // Move camera when map is created
  }

  @override
  void didUpdateWidget(covariant MapSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.routeCoordinates != oldWidget.routeCoordinates) {
      _animateCamera(); // Move camera when new route is selected
    }
  }

  void _animateCamera() {
    if (widget.routeCoordinates.isNotEmpty && mapController != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(_getBounds(widget.routeCoordinates), 100),
      );
    }
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    double south = points.first.latitude;
    double north = points.first.latitude;
    double west = points.first.longitude;
    double east = points.first.longitude;

    for (LatLng point in points) {
      if (point.latitude < south) south = point.latitude;
      if (point.latitude > north) north = point.latitude;
      if (point.longitude < west) west = point.longitude;
      if (point.longitude > east) east = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: widget.routeCoordinates.isNotEmpty
                  ? widget.routeCoordinates.first
                  : const LatLng(40.7128, -74.0060), // Default: NYC
              zoom: 5,
            ),
            polylines: {
              if (widget.routeCoordinates.length > 1)
                Polyline(
                  polylineId: const PolylineId("route"),
                  color: Colors.blue,
                  width: 5,
                  points: widget.routeCoordinates, // Dynamic route
                  startCap: Cap.roundCap,
                  endCap: Cap.roundCap,
                  jointType: JointType.round,
                ),
            },
            markers: widget.routeCoordinates.map((LatLng point) {
              return Marker(
                markerId: MarkerId(point.toString()),
                position: point,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              );
            }).toSet(),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            mapToolbarEnabled: true,
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapSection extends StatefulWidget {
//   final List<LatLng> routeCoordinates; // Route from selected order

 // const MapSection({super.key, required this.routeCoordinates});

//   @override
//   State<MapSection> createState() => _MapSectionState();
// }

// class _MapSectionState extends State<MapSection> {
//   late GoogleMapController mapController;

//   // Define multiple coordinates (with names for markers)
//   final List<Map<String, dynamic>> routeCoordinates = [
//     {"latLng": const LatLng(40.7128, -74.0060), "title": "New York"},
//     {"latLng": const LatLng(41.8781, -87.6298), "title": "Chicago"},
//     {"latLng": const LatLng(34.0522, -118.2437), "title": "Los Angeles"},
//     {"latLng": const LatLng(31.2314, -122.4194), "title": "San Francisco"},
//   ];

//   // Function to create a polyline (connects points)
//   Set<Polyline> _createPolyline() {
//     return {
//       Polyline(
//         polylineId: const PolylineId("route"),
//         color: Colors.blue, // Color of the polyline
//         width: 5, // Thickness
//         points: routeCoordinates
//             .map((point) => point["latLng"] as LatLng)
//             .toList(), // Convert map to list of LatLng
//         startCap: Cap.roundCap,
//         endCap: Cap.roundCap,
//         jointType: JointType.round,
//       ),
//     };
//   }

//   // Function to create markers for each location
//   Set<Marker> _createMarkers() {
//     return routeCoordinates.map((point) {
//       return Marker(
//         markerId: MarkerId(point["title"]),
//         position: point["latLng"],
//         infoWindow: InfoWindow(title: point["title"]), // Show name on tap
//         icon: BitmapDescriptor.defaultMarkerWithHue(
//             BitmapDescriptor.hueRed), // Highlight with a red marker
//       );
//     }).toSet();
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: _onMapCreated,
//             initialCameraPosition: CameraPosition(
//               target:
//                   routeCoordinates.first["latLng"], // Center map on first point
//               zoom: 4, // Adjust zoom to fit all locations
//             ),
//             polylines: _createPolyline(), // Add polyline to map
//             markers: _createMarkers(), // Add markers
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             zoomControlsEnabled: true,
//             mapToolbarEnabled: true,
//           ),
//         ],
//       ),
//     );
//   }
// }
