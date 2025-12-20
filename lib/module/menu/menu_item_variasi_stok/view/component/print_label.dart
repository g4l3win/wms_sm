import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../data/stok_grid_model.dart';

class PrintLabelPage extends StatelessWidget {
  final List<StokGridModel> listToPrint;

  const PrintLabelPage({
    super.key,
    required this.listToPrint
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview Label")),
      body: PdfPreview(
        build: (format) => _generatePdf(format),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          pw.Column(
            children: listToPrint.map((item) {
              return pw.Container(
                padding: const pw.EdgeInsets.all(12),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Column(
                      children: [
                        pw.BarcodeWidget(
                          barcode: pw.Barcode.qrCode(),
                          data: item.noItemWarna ?? "-",
                          width: 40,
                          height: 40,
                          drawText: false,
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(item.noItemWarna ?? "-", style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                    pw.SizedBox(width: 12),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            item.namaItem ?? "-",
                            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text("Warna: ${item.namaWarna}", style: const pw.TextStyle(fontSize: 10)),
                          pw.Text("Lokasi: ${item.namaLokasi}", style: const pw.TextStyle(fontSize: 10)),
                          pw.SizedBox(height: 8),
                        ]
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );

    return pdf.save();
  }
}
