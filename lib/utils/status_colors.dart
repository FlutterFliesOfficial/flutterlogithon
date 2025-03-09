import 'package:flutter/material.dart';

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'Delivered':
      return Colors.green[50]!;
    case 'Transit':
      return Colors.purple[50]!;
    case 'Pending':
      return Colors.orange[50]!;
    default:
      return Colors.grey[50]!;
  }
}

Color getStatusTextColor(String status) {
  switch (status.toLowerCase()) {
    case 'Delivered':
      return Colors.green[700]!;
    case 'Transit':
      return Colors.purple[700]!;
    case 'Pending':
      return Colors.orange[700]!;
    default:
      return Colors.grey[700]!;
  }
}
