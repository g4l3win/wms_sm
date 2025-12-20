import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';

import '../../data/stok_keluar_model.dart';

class LaporanKeluarPrintPreview extends StatelessWidget {
  final String month;
  final List<StokKeluarModel> listStokKeluar;

  const LaporanKeluarPrintPreview({
    super.key,

    required this.month,
    required this.listStokKeluar
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview Laporan Stok Keluar")),
      body: PdfPreview(
        build: (format) => _generatePdf(format,  month, listStokKeluar,),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format,
      String month,
      List<StokKeluarModel> listStokKeluar
      ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return  [
            pw.Center(
              child: pw.Text(
                "Laporan Stok Keluar",
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 10),

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

            // ⬇️ tabel utama
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: const pw.FixedColumnWidth(35),
                1: const pw.FlexColumnWidth(2),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FlexColumnWidth(3),
                4: const pw.FlexColumnWidth(2),
                5: const pw.FlexColumnWidth(2),
                6: const pw.FlexColumnWidth(2),
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
                    _cell("Jumlah Keluar"),
                    _cell("Stok sekarang"),
                  ],
                ),
                ...listStokKeluar.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final item = entry.value;
                  return pw.TableRow(
                    children: [
                      _cell(idx.toString()),
                      _cell("${item.noStokKeluar} - ${item.noItem} - ${item.noItemWarna}"),
                      _cell(item.tanggal ?? "-"),
                      _cell(item.namaItem ?? "-"),
                      _cell(item.namaWarna ?? "-"),
                      _cell("${item.jumlahKeluar.toString()} ${item.unit}"),
                      _cell("${item.stokSekarang.toString()} ${item.unit}",
                          stokSekarang: item.stokSekarang, rop: item.rop),
                    ],
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text("Keterangan warna :", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.Text("Stok habis ", style: const pw.TextStyle(fontSize: 12, color: PdfColors.red)),
            pw.Text("Perlu restok ", style: const pw.TextStyle(fontSize: 12, color: PdfColors.deepOrange500)),
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

  pw.Widget _cell(String text, {double? stokSekarang, double? rop}) {
    var pdfColor =  PdfColors.black;
    if (stokSekarang == null || rop == null) {
      pdfColor = PdfColors.black;
    } else if (stokSekarang == 0) {
      pdfColor = PdfColors.red;
    } else if (stokSekarang < rop) {
      pdfColor = PdfColors.deepOrange500;
    } else {
      pdfColor = PdfColors.black;
    }
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(text, style: pw.TextStyle(color: pdfColor, fontSize: 10)),
    );
  }
}
