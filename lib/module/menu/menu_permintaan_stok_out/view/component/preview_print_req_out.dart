import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../../../../core/database/data/m_item_stok_model.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PreviewPrintReqOut extends StatelessWidget {
  final String lastNoPermintaan;
  final String lastTanggal;
  final int totalBarang;
  final List<ItemStokModel> lastDetail;
  final String namaAdmin;
  final List<String> listTotalMinta;

  const PreviewPrintReqOut({
    super.key,
    required this.lastNoPermintaan,
    required this.lastTanggal,
    required this.totalBarang,
    required this.lastDetail,
    required this.namaAdmin,
    required this.listTotalMinta
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview Permintaan Keluar")),
      body: PdfPreview(
        build: (format) =>
            generatePdfPermintaanKeluar(
              lastNoPermintaan: lastNoPermintaan,
              lastTanggal: lastTanggal,
              totalBarang: totalBarang,
              lastDetail: lastDetail,
              namaAdmin : namaAdmin,
              listTotalMinta: listTotalMinta,
            ),
      ),
    );
  }
}


Future<Uint8List> generatePdfPermintaanKeluar({required String lastNoPermintaan,
  required String lastTanggal,
  required int totalBarang,
  required List<ItemStokModel> lastDetail,
  required List<String> listTotalMinta,
  required String namaAdmin}
    ) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    "BUKTI PERMINTAAN STOK KELUAR",
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    "Warehouse Management System",
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _infoRowPdf(
                        "No Permintaan",
                        lastNoPermintaan,
                      ),
                      _infoRowPdf(
                        "Tanggal",
                        lastTanggal,
                      ),
                      _infoRowPdf(
                        "Dibuat Oleh",
                        namaAdmin,
                      ),
                    ],
                  ),
                ),
                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: lastNoPermintaan,
                  width: 80,
                  height: 80,
                ),
              ],
            ),

            pw.Divider(height: 32),

            pw.Text(
              "Detail Barang",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),

            pw.SizedBox(height: 8),

            pw.Row(
              children: [
                pw.Expanded(flex: 3, child: pw.Text("Nama Barang")),
                pw.Expanded(flex: 2, child: pw.Text("Kode")),
                pw.Expanded(
                  child: pw.Text(
                    "Jumlah",
                    textAlign: pw.TextAlign.right,
                  ),
                ),
              ],
            ),

            pw.Divider(),

            pw.ListView.builder(
              itemCount: lastDetail.length,
              itemBuilder: (context, index) {
                final item = lastDetail[index];
                final qty = listTotalMinta[index];

                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(
                          "${item.namaItem} ${item.namaWarna}",
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(item.noItemWarna),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          "$qty ${item.unit}",
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            pw.Divider(height: 32),

            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "Total Item: ${totalBarang}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Column(
                  children: [
                    pw.Text("Petugas Gudang"),
                    pw.SizedBox(height: 40),
                    pw.Text("(....................)"),
                  ],
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

pw.Widget _infoRowPdf(String label, String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 4),
    child: pw.Row(
      children: [
        pw.SizedBox(width: 90, child: pw.Text(label)),
        pw.Text(": "),
        pw.Expanded(child: pw.Text(value)),
      ],
    ),
  );
}