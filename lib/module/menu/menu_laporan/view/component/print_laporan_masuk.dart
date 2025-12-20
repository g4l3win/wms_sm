import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';

import '../../data/stok_masuk_model.dart';

class LaporanMasukPrintPreview extends StatelessWidget {
  final String month;
  final List<StokMasukModel> laporanList;

  const LaporanMasukPrintPreview({
    super.key,
    required this.month,
    required this.laporanList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview Laporan Stok Masuk")),
      body: PdfPreview(
        build: (format) => _generatePdf(format, month, laporanList),
      ),
    );
  }
}

Future<Uint8List> _generatePdf(
    PdfPageFormat format,
    String month,
    List<StokMasukModel> laporanList,
    ) async {
  final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [pw.Center(
                child: pw.Text(
                  "Laporan Stok Masuk",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),

              // header
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(4),
                },
                children: [
                  _rowHeader("Bulan", month),
                ],
              ),

              pw.SizedBox(height: 20),

              // detail items
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FixedColumnWidth(35),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(2),
                  3: const pw.FlexColumnWidth(3),
                  4: const pw.FlexColumnWidth(2),
                  5: const pw.FlexColumnWidth(2),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      _cell("No"),
                      _cell("Kode"),
                      _cell("Tanggal"),
                      _cell("Nama Item"),
                      _cell("Variasi"),
                      _cell("Jumlah Masuk"),
                    ],
                  ),
                  ...laporanList.asMap().entries.map((entry) {
                    final idx = entry.key + 1;
                    final item = entry.value;
                    return pw.TableRow(
                      children: [
                        _cell(idx.toString()),
                        _cell("${item.noStokMasuk} - ${item.noItem} - ${item.noItemWarna}"),
                        _cell(item.tanggal ?? "-"),
                        _cell(item.namaItem ?? "-"),
                        _cell(item.namaWarna ?? "-"),
                        _cell("${item.jumlahMasuk.toString()} ${item.unit}"),
                      ],
                    );
                  }),
                ],
              )
          ];
        },
      ),
    );

  return pdf.save();
}

pw.TableRow _rowHeader(String label, String value) {
  return pw.TableRow(
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(4),
        child: pw.Text(label),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(4),
        child: pw.Text(value),
      ),
    ],
  );
}

pw.Widget _cell(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(4),
    child: pw.Text(text, style: const pw.TextStyle(fontSize: 10)),
  );
}
