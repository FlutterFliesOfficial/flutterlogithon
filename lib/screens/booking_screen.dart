import 'dart:io';
import 'package:delivery_tracking/service/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:universal_html/html.dart' as html;

class BookingPage extends StatefulWidget {
  final String startPort;
  final String endPort;
  final dynamic routeDetails;

  const BookingPage({
    Key? key,
    required this.startPort,
    required this.endPort,
    required this.routeDetails,
  }) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  String? pdfPath;
  final Map<String, bool> _documents = {
    'Certificate of Origin (COO)': true,
    'Commercial Invoice': true,
    'Packing List': true,
    'Bill of Lading (B/L) / Air Waybill': true,
    'Export License': true,
    'Shipper\'s Letter of Instruction (SLI)': false,
    'Certificate of Free Sale': false,
    'Inland Bill of Lading': true,
    'Insurance Documents': true,
    'Letter of Credit (L/C) or Bank Draft': false,
  };

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  Future<void> generateAndSavePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'SHIPPING INVOICE',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      _companyController.text,
                      style: pw.TextStyle(fontSize: 16),
                    ),
                    pw.Text(
                      'Phone: ${_phoneController.text}',
                      style: pw.TextStyle(fontSize: 16),
                    ),
                    pw.SizedBox(height: 20),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // Invoice details
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Date: ${DateTime.now().toString().split(' ')[0]}',
                    style: pw.TextStyle(fontSize: 16),
                  ),
                  pw.Text(
                    'Invoice #: ${DateTime.now().millisecondsSinceEpoch}',
                    style: pw.TextStyle(fontSize: 16),
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              // Customer Information
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey200,
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Customer Details:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text('Name: ${_nameController.text}'),
                    pw.Text('Email: ${_emailController.text}'),
                    pw.Text('Phone: ${_phoneController.text}'),
                    pw.Text('Company: ${_companyController.text}'),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Shipping Details
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey200,
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Shipping Details:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text('From: ${widget.startPort}'),
                    pw.Text('To: ${widget.endPort}'),
                    pw.Text(
                        'Total Cost: \$${widget.routeDetails['totalCost'].toStringAsFixed(2)}'),
                    if (widget.routeDetails['time'] != null)
                      pw.Text(
                          'Estimated Time: ${widget.routeDetails['time'].toStringAsFixed(2)} hours'),
                    if (widget.routeDetails['totalDistance'] != null)
                      pw.Text(
                          'Distance: ${widget.routeDetails['totalDistance']} km'),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Required Documents
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey200,
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Required Documents:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    ..._documents.entries
                        .where((entry) => entry.value)
                        .map((entry) => pw.Text('# ${entry.key}')),
                  ],
                ),
              ),

              // Footer
              pw.Spacer(),
              pw.Divider(),
              pw.Center(
                child: pw.Text(
                  'Thank you for choosing our shipping services!',
                  style: pw.TextStyle(
                    fontStyle: pw.FontStyle.italic,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();

    if (kIsWeb) {
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrl(blob);
      final anchor = html.AnchorElement()
        ..href = url
        ..style.display = 'none'
        ..download = 'shipping_invoice.pdf';
      html.document.body!.children.add(anchor);
      anchor.click();
      html.document.body!.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    } else {
      try {
        Directory? output;
        if (Platform.isAndroid) {
          output = await getExternalStorageDirectory();
        } else if (Platform.isIOS) {
          output = await getApplicationDocumentsDirectory();
        }

        if (output != null) {
          final file = File("${output.path}/shipping_invoice.pdf");
          await file.writeAsBytes(bytes);

          setState(() {
            pdfPath = file.path;
          });

          await OpenFilex.open(file.path);
        }
      } catch (e) {
        debugPrint('Error generating PDF: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Your Route"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.route,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Route Summary",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(Icons.location_on_outlined, "From",
                            widget.startPort),
                        const SizedBox(height: 8),
                        _buildInfoRow(Icons.location_on, "To", widget.endPort),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          Icons.attach_money,
                          "Total Cost",
                          "\$${widget.routeDetails['totalCost'].toStringAsFixed(2)}",
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: Color(0xFF8B5CF6),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Contact Information",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration:
                              _buildInputDecoration("Full Name", Icons.person),
                          validator: (value) => value?.isEmpty ?? true
                              ? "Please enter your name"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration:
                              _buildInputDecoration("Email", Icons.email),
                          validator: (value) => value?.isEmpty ?? true
                              ? "Please enter your email"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration:
                              _buildInputDecoration("Phone", Icons.phone),
                          validator: (value) => value?.isEmpty ?? true
                              ? "Please enter your phone"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _companyController,
                          decoration: _buildInputDecoration(
                              "Company Name", Icons.business),
                          validator: (value) => value?.isEmpty ?? true
                              ? "Please enter company name"
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.description_outlined,
                                color: Color(0xFF10B981),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Required Documents",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Please ensure you have the following documents:",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        ..._documents.entries.map((entry) => CheckboxListTile(
                              title: Text(entry.key),
                              subtitle: Text(
                                entry.value ? "Required" : "Optional",
                                style: TextStyle(
                                  color: entry.value ? Colors.red : Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              value: entry.value,
                              onChanged: null,
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        // onPressed: () {
                        //   if (_formKey.currentState?.validate() ?? false) {
                        //     generateAndSavePdf();
                        //     // here add the submit function of supabase
                        //     // Example usage
                        //     String newOrderId = await SupabaseService.createOrder('pending');
                        //     // Example usage
                        //     await SupabaseService.createOrderTracking(
                        //       orderId: 'your-order-id',
                        //       status: 'in_transit',
                        //       trackingDetails: 'Package is on the way',
                        //       location: 'Mumbai, Maharashtra',
                        //       route: 'MUM-DEL-001'
                        //     );
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(
                        //         content:
                        //             Text('Booking submitted successfully!'),
                        //         backgroundColor: Colors.green,
                        //       ),
                        //     );
                        //   }
                        // },
                        onPressed: () async {
                          // Add async keyword
                          if (_formKey.currentState?.validate() ?? false) {
                            try {
                              // First create the order and get the ID
                              int newOrderId =
                                  await SupabaseService.createOrder('Pending');

                              // Then create the tracking entry using the new order ID
                              await SupabaseService.createOrderTracking(
                                orderId: newOrderId,
                                status: 'Transit',
                                trackingDetails:
                                    'Shipment booked from ${widget.startPort} to ${widget.endPort}',
                                location: widget.startPort,
                                // route: widget.routeDetails["Path"] as String,
                                // Convert the Path array to a string by joining its elements
                                route: (widget.routeDetails["Path"] as List),
                                // route: '${widget.startPort}-${widget.endPort}',
                              );

                              // Generate PDF after successful database operations
                              await generateAndSavePdf();

                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Booking submitted successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              // Handle any errors
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Error submitting booking: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text(
                          'Confirm & Generate Invoice',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (!kIsWeb && pdfPath != null) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PdfViewerScreen(pdfPath: pdfPath!),
                          ),
                        );
                      },
                      icon: const Icon(Icons.visibility),
                      label: const Text('View Invoice'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
    );
  }
}

class PdfViewerScreen extends StatelessWidget {
  final String pdfPath;

  const PdfViewerScreen({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice Preview"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
      ),
    );
  }
}
