import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../menu_laporan/data/stok_masuk_model.dart';

class StokMasukPreview extends StatelessWidget {
  final LaporanStokMasuk stokMasuk;

  const StokMasukPreview({
    super.key,
    required this.stokMasuk,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview Stok Masuk")),
      body: PdfPreview(
        build: (format) => _generatePdf(format),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    var jumlahStokMasuk = stokMasuk.detailItems!.length;
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header QR + Judul
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    children: [
                      pw.BarcodeWidget(
                        data: stokMasuk.noStokMasuk ?? "-",
                        barcode: pw.Barcode.qrCode(),
                        width: 80,
                        height: 80,
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(stokMasuk.noStokMasuk ?? "-"),
                    ],
                  ),
                  pw.SizedBox(width: 16),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Stok Masuk",
                            style: pw.TextStyle(
                                fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        pw.Text("No Stok Masuk ${stokMasuk.noStokMasuk}"),
                        pw.Text("Tanggal ${stokMasuk.tanggal}"),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 12),

              // Detail laporan
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FlexColumnWidth(2),
                  1: pw.FlexColumnWidth(3),
                },
                children: [
                  pw.TableRow(children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text("Jumlah Stok Masuk")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(jumlahStokMasuk.toString())),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text("Admin")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(stokMasuk.admin ?? "-")),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text("Keterangan")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(stokMasuk.keterangan ?? "-")),
                  ]),
                ],
              ),

              pw.SizedBox(height: 12),

              // Tabel daftar barang
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FixedColumnWidth(40),
                  1: const pw.FlexColumnWidth(3),
                  2: const pw.FlexColumnWidth(2),
                  3: const pw.FlexColumnWidth(2),
                },
                children: [
                  // Header tabel
                  pw.TableRow(
                    children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text("No", style: pw.TextStyle(fontSize: 10))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text("Nama item")),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text("Variasi")),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text("Jumlah masuk")),
                    ],
                  ),
                  // Data
                  ...stokMasuk.detailItems!.asMap().entries.map(
                        (e) => pw.TableRow(
                      children: [
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text("${e.key + 1}")),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(e.value.namaItem ?? "")),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(e.value.namaWarna ?? "")),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text("${e.value.jumlahMasuk.toString()} ${e.value.unit}")),
                      ],
                    ),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }
}