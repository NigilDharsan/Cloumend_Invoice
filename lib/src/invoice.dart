import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfReceiptPage extends StatefulWidget {
  const PdfReceiptPage({super.key});

  @override
  State<PdfReceiptPage> createState() => _PdfReceiptPageState();
}

class _PdfReceiptPageState extends State<PdfReceiptPage> {
  late pw.Font latoBold; // store loaded font

  @override
  void initState() {
    super.initState();
    // _loadFont(); // load once
  }

  Future<void> _loadFont() async {
    latoBold = await fontFromAssetBundle('assets/fonts/lato.bold.ttf');
  }

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();
    final logoImage = await imageFromAssetBundle("assets/bali.jpg");

    final smallText = pw.TextStyle(fontSize: 9);
    final boldText = pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold);
    final heading = pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (context) {
          return pw.Stack(
            children: [
              pw.Align(
                alignment: const pw.Alignment(0, 0.6), // 👈 move upward
                child: pw.Positioned(
                  child: pw.Transform.rotate(
                    angle: -10.14159 / 2, // rotate 90° counter-clockwise
                    child: pw.Text(
                      "PAID",
                      style: pw.TextStyle(color: PdfColors.grey, fontSize: 80),
                    ),
                  ),
                ),

                // pw.Text("PAID",style: pw.TextStyle(color: PdfColors.grey,fontSize: 50))
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Center(
                    child: pw.Text(
                      "Payment Receipt",
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 8),

                  pw.Container(
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black, width: 1),
                    ),
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                              height: 60,
                              width: double.infinity,
                              child: pw.Image(logoImage),
                            ),
                            pw.SizedBox(width: 8),

                            pw.Expanded(
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    "Cloumend Technologies",
                                    style: heading,
                                  ),
                                  pw.SizedBox(height: 4),
                                  pw.Text(
                                    "No.2 456, Indira Nagar, Malumichampatti Coimbatore Dist,",
                                    style: smallText,
                                  ),
                                  pw.Text(
                                    "Phone: 8675554547",
                                    style: smallText,
                                  ),
                                  pw.Text(
                                    "Email: harsan.nn@gmail.com",
                                    style: smallText,
                                  ),
                                  pw.Text(
                                    "State: 33-Tamil Nadu",
                                    style: smallText,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 6),
                        pw.Table(
                          border: pw.TableBorder.all(
                            color: PdfColors.black,
                            width: 0.5,
                          ),
                          columnWidths: {
                            0: const pw.FlexColumnWidth(2),
                            1: const pw.FlexColumnWidth(1),
                          },
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(6),
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        "Received From:",
                                        style: boldText,
                                      ),
                                      pw.SizedBox(height: 4),
                                      pw.Text(
                                        "SUPER MATIN INDUSTRIES",
                                        style: boldText,
                                      ),
                                      pw.Text(
                                        "S.F. NO.808/1A 1, PALGHAT MAIN ROAD,\nMADUKKARAI\nCoimbatore, Tamil Nadu-641105\nIndia",
                                        style: smallText,
                                      ),
                                      pw.SizedBox(height: 4),
                                      pw.Text(
                                        "Contact No: 9205370485",
                                        style: smallText,
                                      ),
                                      pw.Text(
                                        "GSTIN: 33NAXPS5699F1ZF",
                                        style: smallText,
                                      ),
                                      pw.Text(
                                        "State: 33-Tamil Nadu",
                                        style: smallText,
                                      ),
                                    ],
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(6),
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        "Receipt Details:",
                                        style: boldText,
                                      ),
                                      pw.SizedBox(height: 4),
                                      pw.Text("No: 4", style: smallText),
                                      pw.Text(
                                        "Date: 04/11/2025",
                                        style: smallText,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        pw.SizedBox(height: 6),

                        pw.Container(
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(
                              color: PdfColors.black,
                              width: 0.5,
                            ),
                          ),
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                "Received",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                "₹ 3,000.00",
                                style: pw.TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        pw.Container(
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(
                              color: PdfColors.black,
                              width: 0.5,
                            ),
                          ),
                          padding: const pw.EdgeInsets.all(6),

                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                "Amount in Words:",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Spacer(),
                              pw.Text(
                                "Three Thousand Rupees only",
                                style: boldText,
                              ),
                            ],
                          ),
                        ),

                        pw.SizedBox(height: 10),

                        pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Container(
                            width: 220,
                            height: 70,
                            decoration: pw.BoxDecoration(
                              color: PdfColors.grey200,
                              border: pw.Border.all(
                                color: PdfColors.black,
                                width: 0.5,
                              ),
                            ),
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.SizedBox(
                                  height: 30,
                                  child: pw.Center(
                                    child: pw.Text(
                                      "For Cloumend Technologies:",
                                      style: boldText,
                                    ),
                                  ),
                                ),

                                pw.SizedBox(height: 8),

                                pw.Text(
                                  "Authorized Signatory",
                                  style: smallText,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment Receipt PDF")),
      body: PdfPreview(
        build: (format) => _generatePdf(),
        canChangeOrientation: false,
        canChangePageFormat: false,
        allowPrinting: true,
        allowSharing: true,
        pdfFileName: "Payment_Receipt.pdf",
      ),
    );
  }
}
