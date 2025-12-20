import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../menu_laporan/data/stok_keluar_model.dart';

class StokKeluarPreview extends StatelessWidget {
  final LaporanStokKeluar stokKeluar;

  const StokKeluarPreview({
    super.key,
    required this.stokKeluar
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview Stok Keluar")),
      body: PdfPreview(
        build: (format) => _generatePdf(format),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    var jumlahStokKeluar = stokKeluar.detailItems!.length;
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
                        data: stokKeluar.noStokKeluar  ?? '-',
                        barcode: pw.Barcode.qrCode(),
                        width: 80,
                        height: 80,
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(stokKeluar.noStokKeluar  ?? '-'),
                    ],
                  ),
                  pw.SizedBox(width: 16),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Stok Keluar",
                            style: pw.TextStyle(
                                fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        pw.Text("No Stok Keluar ${stokKeluar.noStokKeluar  ?? '-'}"),
                        pw.Text("Tanggal ${stokKeluar.tanggal}"),
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
                        child: pw.Text("Jumlah Stok Keluar")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(jumlahStokKeluar.toString())),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text("Admin")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(stokKeluar.admin ?? "-")),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text("Keterangan")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(stokKeluar.keterangan  ?? "-")),
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
                          child: pw.Text("Jumlah Keluar")),
                    ],
                  ),
                  // Data
                  ...stokKeluar.detailItems!.asMap().entries.map(
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
                            child: pw.Text("${e.value.jumlahKeluar.toString()} ${e.value.unit}")),
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