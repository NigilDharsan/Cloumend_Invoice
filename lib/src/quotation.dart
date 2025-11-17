import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Service {
  final String name;
  final double price;
  final String unit;
  int quantity;
  final String category;

  Service({
    required this.name,
    required this.price,
    required this.unit,
    this.quantity = 1,
    required this.category,
  });

  double get total => price * quantity;
}

class QuotationScreen extends StatefulWidget {
  const QuotationScreen({Key? key}) : super(key: key);

  @override
  State<QuotationScreen> createState() => _QuotationScreenState();
}

class _QuotationScreenState extends State<QuotationScreen> {
  final _clientNameController = TextEditingController();
  final _clientEmailController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime quotationDate = DateTime.now();
  DateTime? validUntil;
  double discount = 0;

  List<Service> selectedServices = [];

  final Map<String, List<Map<String, dynamic>>> serviceCategories = {
    'Social Media Management': [
      {'name': 'Post Creation (per image)', 'price': 450.0, 'unit': 'per post'},
      {'name': 'Post Content Writing', 'price': 150.0, 'unit': 'per content'},
      {'name': 'Post Publishing', 'price': 100.0, 'unit': 'per post'},
      {'name': 'Account Setup', 'price': 1000.0, 'unit': 'per account'},
      {'name': 'Social Media Strategy', 'price': 3000.0, 'unit': 'monthly'},
      {'name': 'Monthly Analytics Report', 'price': 1500.0, 'unit': 'monthly'},
      {'name': 'Community Management', 'price': 5000.0, 'unit': 'monthly'},
    ],
    'Paid Advertising': [
      {'name': 'Google Ads Setup', 'price': 1000.0, 'unit': 'one-time'},
      {'name': 'Google Ads Management', 'price': 5000.0, 'unit': 'monthly'},
      {'name': 'Facebook Ads Setup', 'price': 1000.0, 'unit': 'one-time'},
      {'name': 'Facebook Ads Management', 'price': 5000.0, 'unit': 'monthly'},
      {'name': 'Ad Campaign Strategy', 'price': 2500.0, 'unit': 'per campaign'},
    ],
    'Website Development': [
      {'name': 'Dynamic Website', 'price': 10000.0, 'unit': 'one-time'},
      {'name': 'Landing Page Design', 'price': 5000.0, 'unit': 'per page'},
      {'name': 'E-commerce Website', 'price': 25000.0, 'unit': 'one-time'},
      {'name': 'Website Maintenance', 'price': 2000.0, 'unit': 'monthly'},
    ],
    'SEO Services': [
      {'name': 'SEO Monthly Package', 'price': 10000.0, 'unit': 'monthly'},
      {'name': 'SEO Audit & Report', 'price': 5000.0, 'unit': 'one-time'},
      {'name': 'Keyword Research', 'price': 2500.0, 'unit': 'one-time'},
      {'name': 'On-Page SEO', 'price': 7500.0, 'unit': 'one-time'},
    ],
    'Content Creation': [
      {'name': 'Blog Writing', 'price': 800.0, 'unit': 'per article'},
      {'name': 'Video Editing', 'price': 1500.0, 'unit': 'per video'},
      {'name': 'Logo Design', 'price': 3000.0, 'unit': 'one-time'},
      {'name': 'Banner Design', 'price': 800.0, 'unit': 'per design'},
    ],
  };

  double get subtotal => selectedServices.fold(0, (sum, s) => sum + s.total);
  double get discountAmount => subtotal * (discount / 100);
  double get total => subtotal - discountAmount;

  void addService(String category, Map<String, dynamic> serviceData) {
    setState(() {
      selectedServices.add(Service(
        name: serviceData['name'],
        price: serviceData['price'],
        unit: serviceData['unit'],
        category: category,
      ));
    });
  }

  void removeService(int index) {
    setState(() {
      selectedServices.removeAt(index);
    });
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd MMM yyyy');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Header
          pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue700,
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'DIGITAL MARKETING QUOTATION',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  'Professional Services Proposal',
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.white,
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 30),

          // Client and Date Info
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'CLIENT INFORMATION',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text('Name: ${_clientNameController.text}'),
                  pw.Text('Email: ${_clientEmailController.text}'),
                  pw.Text('Phone: ${_clientPhoneController.text}'),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'QUOTATION DETAILS',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text('Date: ${dateFormat.format(quotationDate)}'),
                  if (validUntil != null)
                    pw.Text('Valid Until: ${dateFormat.format(validUntil!)}'),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 30),

          // Services Table
          pw.Text(
            'SERVICES',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),

          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              // Header Row
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Service',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Category',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Qty',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Price',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Total',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ),
              // Service Rows
              ...selectedServices.map((service) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(service.name,
                            style: const pw.TextStyle(fontSize: 10)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(service.category,
                            style: const pw.TextStyle(fontSize: 10)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('${service.quantity}',
                            style: const pw.TextStyle(fontSize: 10)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('₹${service.price.toStringAsFixed(2)}',
                            style: const pw.TextStyle(fontSize: 10)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('₹${service.total.toStringAsFixed(2)}',
                            style: const pw.TextStyle(fontSize: 10)),
                      ),
                    ],
                  )),
            ],
          ),

          pw.SizedBox(height: 20),

          // Summary
          pw.Container(
            alignment: pw.Alignment.centerRight,
            child: pw.Container(
              width: 250,
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Subtotal:'),
                      pw.Text('₹${subtotal.toStringAsFixed(2)}'),
                    ],
                  ),
                  if (discount > 0) ...[
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Discount ($discount%):'),
                        pw.Text('- ₹${discountAmount.toStringAsFixed(2)}',
                            style: const pw.TextStyle(color: PdfColors.green)),
                      ],
                    ),
                  ],
                  pw.Divider(thickness: 2),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'TOTAL:',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        '₹${total.toStringAsFixed(2)}',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (_notesController.text.isNotEmpty) ...[
            pw.SizedBox(height: 30),
            pw.Text(
              'NOTES & TERMS',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text(_notesController.text,
                style: const pw.TextStyle(fontSize: 11)),
          ],

          pw.SizedBox(height: 30),

          // Footer
          pw.Divider(),
          pw.Text(
            'Thank you for your business!',
            style: pw.TextStyle(
              fontSize: 10,
              fontStyle: pw.FontStyle.italic,
              color: PdfColors.grey600,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Marketing Quotation'),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.indigo],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Client Information Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Client Information',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _clientNameController,
                      decoration: const InputDecoration(
                        labelText: 'Client Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _clientEmailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _clientPhoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Date Information
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quotation Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Quotation Date'),
                      subtitle:
                          Text(DateFormat('dd MMM yyyy').format(quotationDate)),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: quotationDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) setState(() => quotationDate = date);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.event),
                      title: const Text('Valid Until'),
                      subtitle: Text(validUntil != null
                          ? DateFormat('dd MMM yyyy').format(validUntil!)
                          : 'Not set'),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: validUntil ??
                              DateTime.now().add(const Duration(days: 30)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) setState(() => validUntil = date);
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Services Selection
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Services',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...serviceCategories.entries.map((category) {
                      return ExpansionTile(
                        title: Text(
                          category.key,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        children: category.value.map((service) {
                          return ListTile(
                            title: Text(service['name']),
                            subtitle: Text(
                                '₹${service['price']} - ${service['unit']}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.add_circle,
                                  color: Colors.blue),
                              onPressed: () =>
                                  addService(category.key, service),
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Selected Services
            if (selectedServices.isNotEmpty) ...[
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selected Services',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ...selectedServices.asMap().entries.map((entry) {
                        int index = entry.key;
                        Service service = entry.value;
                        return Card(
                          color: Colors.blue.shade50,
                          child: ListTile(
                            title: Text(service.name),
                            subtitle: Text(
                                '${service.category} - ₹${service.price} x ${service.quantity}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    if (service.quantity > 1) {
                                      setState(() => service.quantity--);
                                    }
                                  },
                                ),
                                Text('${service.quantity}'),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () =>
                                      setState(() => service.quantity++),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => removeService(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Summary
              Card(
                elevation: 2,
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal:',
                              style: TextStyle(fontSize: 16)),
                          Text('₹${subtotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Discount (%):'),
                          SizedBox(
                            width: 100,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                              ),
                              onChanged: (value) {
                                setState(() =>
                                    discount = double.tryParse(value) ?? 0);
                              },
                            ),
                          ),
                        ],
                      ),
                      if (discount > 0) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Discount Amount:',
                                style: TextStyle(color: Colors.green)),
                            Text('- ₹${discountAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                      const Divider(thickness: 2, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('TOTAL:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('₹${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Notes
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notes & Terms',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _notesController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText:
                            'Add any special terms, conditions, or notes...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Generate PDF Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: selectedServices.isEmpty ? null : generatePDF,
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Generate & Download PDF'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
