enum ShipmentPriority { cost, time, balanced }

enum TransportMode { air, sea, land }

class Shipment {
  final String origin;
  final String destination;
  // final double weight;
  // final double volume;
  // final ShipmentPriority priority;
  // final TransportMode? preferredMode;

  Shipment({
    required this.origin,
    required this.destination,
    // required this.weight,
    // required this.volume,
    // required this.priority,
    // this.preferredMode,
  });
}
