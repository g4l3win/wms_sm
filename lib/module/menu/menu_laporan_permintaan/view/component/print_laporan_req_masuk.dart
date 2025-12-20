import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../data/m_permintaan_masuk.dart';

class PrintLaporanReqMasuk extends StatelessWidget {
  final List<PermintaanMasukDummy> data;
  final String periode;
  const PrintLaporanReqMasuk({
    super.key,
    required this.data,
    required this.periode
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview Laporan Stok Masuk")),
      body: PdfPreview(
        build: (format) => _generatePdf(format, data, periode),
      ),
    );
  }
}

Future<Uint8List> _generatePdf(
    PdfPageFormat format,
    List<PermintaanMasukDummy> data,
    String periode
    ) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(20),
      build: (context) => [
        pw.Center(
          child: pw.Text(
            'LAPORAN PERMINTAAN STOK MASUK',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Center(child: pw.Text('Periode: $periode')),
        pw.SizedBox(height: 15),

        ...data.map((permintaan) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  color: PdfColors.grey200,
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('No: ${permintaan.noPermintaan}'),
                    pw.Text('Tanggal: ${permintaan.tanggal}'),
                  ],
                ),
              ),

              pw.TableHelper.fromTextArray(
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                cellAlignment: pw.Alignment.centerLeft,
                headers: ['Nama Item', 'Warna', 'Jumlah', 'Unit'],
                data: permintaan.detail.map((d) {
                  return [
                    d.namaItem,
                    d.namaWarna,
                    d.jumlah.toString(),
                    d.unit,
                  ];
                }).toList(),
              ),


              pw.SizedBox(height: 10),
            ],
          );
        }).toList(),
      ],
    ),
  );
  return pdf.save();

}