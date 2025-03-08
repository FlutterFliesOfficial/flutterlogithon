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

  // Update map controller
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: widget.routeCoordinates.first, // Center on first point
              zoom: 5,
            ),
            polylines: {
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
