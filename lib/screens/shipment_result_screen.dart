import 'package:flutter/material.dart';
import 'package:delivery_tracking/models/shipment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:delivery_tracking/screens/booking_screen.dart';
import 'package:delivery_tracking/service/shipment_cache.dart';

class ShipmentResultsScreen extends StatefulWidget {
  final Shipment shipment;

  const ShipmentResultsScreen({
    super.key,
    required this.shipment,
    List? cachedResults,
  });

  @override
  State<ShipmentResultsScreen> createState() => _ShipmentResultsScreenState();
}

class _ShipmentResultsScreenState extends State<ShipmentResultsScreen> {
  List<dynamic> routes = [];
  bool isLoading = true;
  String selectedFilter = "default";
  String? selectedTransportMode; // Add this for transport mode filtering
  String? error;
  Set<int> expandedCards = {};
  var _cache = ShipmentCache();

  @override
  void initState() {
    super.initState();
    fetchRoutes();
  }

  // Create a cache key that includes transport mode
  String _createCacheKey(String origin, String destination, String filterType,
      String? transportMode) {
    return "$origin-$destination-$filterType-${transportMode ?? 'all'}";
  }

  Future<void> fetchRoutes() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    // Create a cache key that includes transport mode
    final cacheKey = _createCacheKey(
      widget.shipment.origin,
      widget.shipment.destination,
      selectedFilter,
      selectedTransportMode,
    );

    // Check cache first
    final cachedResults = _cache.getResults(
      widget.shipment.origin,
      widget.shipment.destination,
      cacheKey,
    );

    if (cachedResults != null) {
      setState(() {
        routes = cachedResults;
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Using cached results'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      // Create request body with transport mode
      final requestBody = {
        "start_port": widget.shipment.origin,
        "end_port": widget.shipment.destination,
        "filter_type": selectedFilter,
      };

      // Only add transport_mode if it's selected
      if (selectedTransportMode != null) {
        requestBody["transport_mode"] = selectedTransportMode!;
      }

      final response = await http.post(
        Uri.parse("http://192.168.10.37:5000/get_route"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final routeResults = jsonResponse['routes'];

        // Cache the results with the transport mode included in the key
        _cache.cacheResults(
          widget.shipment.origin,
          widget.shipment.destination,
          cacheKey,
          routeResults,
        );

        setState(() {
          routes = routeResults;
          isLoading = false;
        });
      } else {
        setState(() {
          error = "Failed to load routes. Please try again.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Error connecting to server. Please check your connection.";
        isLoading = false;
      });
    }
  }

  void toggleCardExpansion(int index) {
    setState(() {
      if (expandedCards.contains(index)) {
        expandedCards.remove(index);
      } else {
        expandedCards.add(index);
      }
    });
  }

  String _formatPath(List<dynamic> pathData, [List<dynamic>? transportModes]) {
    if (transportModes == null || transportModes.isEmpty) {
      return pathData.map((e) => e is String ? e : e["name"]).join(" → ");
    }

    List<String> formattedPath = [];
    int modeIndex = 0;

    for (int i = 0; i < pathData.length; i++) {
      String node = pathData[i].toString();

      // Skip "CONNECTED_TO" nodes
      if (node == "CONNECTED_TO") continue;

      formattedPath.add(node);

      // Add transport mode emoji if there's a next location
      if (i < pathData.length - 1 && modeIndex < transportModes.length) {
        String mode = transportModes[modeIndex].toString().toLowerCase();
        String icon = "";
        if (mode == 'air') {
          icon = "->✈️->";
        } else if (mode == 'sea') {
          icon = "->🚢->";
        } else if (mode == 'road') {
          icon = "->🚗->";
        }
        formattedPath.add(icon);
        modeIndex++;
      }
    }

    return formattedPath.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green[50],
              child: const Icon(Icons.local_shipping, color: Colors.green),
            ),
            const SizedBox(width: 12),
            const Text(
              'Route Options',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black54),
            onPressed: () {
              _cache.clearCache();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared'),
                  duration: Duration(seconds: 2),
                ),
              );
              fetchRoutes(); // Refresh routes after clearing cache
            },
            tooltip: 'Clear Cache',
          ),
          IconButton(
            icon:
                const Icon(Icons.notifications_outlined, color: Colors.black54),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[200],
            child: const Text('U', style: TextStyle(color: Colors.black87)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.shipment.origin} → ${widget.shipment.destination}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: fetchRoutes,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.refresh,
                                size: 16, color: Colors.green[700]),
                            const SizedBox(width: 4),
                            Text(
                              'Refresh',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Filter type chips
                const Text(
                  "Filter by:",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip("default", "All Routes"),
                      _buildFilterChip("cost", "Lowest Cost"),
                      _buildFilterChip("distance", "Shortest"),
                      _buildFilterChip("time", "Fastest"),
                    ],
                  ),
                ),

                // Transport mode chips
                const SizedBox(height: 16),
                const Text(
                  "Transport Mode:",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTransportModeChip(null, "All Modes"),
                      _buildTransportModeChip("Air", "Air ✈️"),
                      _buildTransportModeChip("Sea", "Sea 🚢"),
                      _buildTransportModeChip("Road", "Road 🚗"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              error!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: fetchRoutes,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : routes.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No routes found with the selected filters',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedFilter = "default";
                                      selectedTransportMode = null;
                                    });
                                    fetchRoutes();
                                  },
                                  child: const Text('Reset Filters'),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: routes.length,
                            itemBuilder: (context, index) {
                              final route = routes[index];
                              return _buildRouteCard(route, index);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (bool selected) {
          setState(() {
            selectedFilter = value;
          });
          fetchRoutes();
        },
        backgroundColor: Colors.white,
        selectedColor: Colors.green[50],
        checkmarkColor: Colors.green,
        labelStyle: TextStyle(
          color: isSelected ? Colors.green[700] : Colors.black87,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  // New method for transport mode chips
  Widget _buildTransportModeChip(String? value, String label) {
    final isSelected = selectedTransportMode == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (bool selected) {
          setState(() {
            selectedTransportMode = selected ? value : null;
          });
          fetchRoutes();
        },
        backgroundColor: Colors.white,
        selectedColor: value == null
            ? Colors.grey[100]
            : value == "air"
                ? Colors.blue[50]
                : value == "sea"
                    ? Colors.cyan[50]
                    : Colors.amber[50],
        checkmarkColor: value == null
            ? Colors.grey[700]
            : value == "air"
                ? Colors.blue
                : value == "sea"
                    ? Colors.cyan
                    : Colors.amber,
        labelStyle: TextStyle(
          color: isSelected
              ? (value == null
                  ? Colors.grey[700]
                  : value == "air"
                      ? Colors.blue[700]
                      : value == "sea"
                          ? Colors.cyan[700]
                          : Colors.amber[700])
              : Colors.black87,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  // Updated route card to include expandable details
  Widget _buildRouteCard(Map<String, dynamic> route, int index) {
    bool isExpanded = expandedCards.contains(index);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.route, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        route["transport_modes"] != null
                            ? _formatPath(
                                route["Path"], route["transport_modes"])
                            : _formatPath(route["Path"]),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${route['time'].toStringAsFixed(1)} hours",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.speed, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          "${route['totalDistance']} km",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.eco, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          "${route['carbonEmission'].toStringAsFixed(1)} kg CO₂",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    // Display transport modes as badges
                    if (route["transport_modes"] != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.swap_horiz,
                              size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Wrap(
                            spacing: 4,
                            children: _buildTransportModeBadges(
                                route["transport_modes"]),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\$${route['totalCost'].toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // View Details button
                        TextButton.icon(
                          icon: Icon(
                            isExpanded
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 16,
                            color: Colors.blue,
                          ),
                          label: Text(
                            isExpanded ? "Hide Details" : "View Details",
                            style: const TextStyle(color: Colors.blue),
                          ),
                          onPressed: () => toggleCardExpansion(index),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingPage(
                                  startPort: widget.shipment.origin,
                                  endPort: widget.shipment.destination,
                                  routeDetails: route,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Book Now',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // Expanded details section
            if (isExpanded) ...[
              const SizedBox(height: 16),
              const Divider(),
              DetailItem(
                icon: Icons.route,
                label: "Distance",
                value: "${route['totalDistance']} km",
              ),
              DetailItem(
                icon: Icons.timer,
                label: "Time",
                value: "${route['time'].toStringAsFixed(2)} hours",
              ),
              DetailItem(
                icon: Icons.factory,
                label: "Carbon Emission",
                value: "${route['carbonEmission'].toStringAsFixed(2)} kg",
              ),
              if (route['minWeight'] != null)
                DetailItem(
                  icon: Icons.fitness_center,
                  label: "Maximum Weight",
                  value: "${route['minWeight']} kg",
                ),
              if (route['regulations'] != null)
                DetailItem(
                  icon: Icons.gavel,
                  label: "Regulations",
                  value: route['regulations'].join(", "),
                ),
              DetailItem(
                icon: Icons.directions,
                label: "Path",
                value: route["transport_modes"] != null
                    ? _formatPath(route["Path"], route["transport_modes"])
                    : _formatPath(route["Path"]),
              ),
              if (route["transport_modes"] != null)
                DetailItem(
                  icon: Icons.swap_horiz,
                  label: "Transport Modes",
                  value: route["transport_modes"]
                      .map((mode) => mode.toString().toUpperCase())
                      .join(", "),
                ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper method to build transport mode badges
  List<Widget> _buildTransportModeBadges(List<dynamic> transportModes) {
    final uniqueModes = transportModes.toSet().toList();
    return uniqueModes.map((mode) {
      String modeStr = mode.toString().toLowerCase();
      Color bgColor;
      Color textColor;
      String label;
      IconData icon;

      if (modeStr == 'air') {
        bgColor = Colors.blue[50]!;
        textColor = Colors.blue[700]!;
        label = "Air";
        icon = Icons.flight;
      } else if (modeStr == 'sea') {
        bgColor = Colors.cyan[50]!;
        textColor = Colors.cyan[700]!;
        label = "Sea";
        icon = Icons.sailing;
      } else {
        bgColor = Colors.amber[50]!;
        textColor = Colors.amber[700]!;
        label = "Road";
        icon = Icons.directions_car;
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
