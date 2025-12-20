import 'package:flutter/material.dart';

import '../../../../../core/util_manager/app_theme.dart';
import '../../../../../core/util_manager/form_manager.dart';
import '../../data/stok_keluar_model.dart';
import '../../data/stok_masuk_model.dart';
import '../laporan_container.dart';

extension StokKeluarContainer on LaporanContainer {

     Widget detailRow(String title, String value, {StokKeluarModel? dataKeluar, StokMasukModel? dataMasuk}) {
    Color colorKeluar =  dataKeluar == null
        ? AppTheme.whiteColor
        : dataKeluar.stokSekarang == 0
        ? AppTheme.lightGrey
        : dataKeluar.stokSekarang! < dataKeluar.rop!
        ? Colors.yellow
        : AppTheme.whiteColor;

    Color colorMasuk =dataMasuk == null
        ? AppTheme.whiteColor
        : dataMasuk.stokSekarang == 0
        ? AppTheme.lightGrey
        : dataMasuk.stokSekarang! < dataMasuk.rop!
        ? Colors.yellow
        : AppTheme.whiteColor;
    return Container(
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          border: Border(
            bottom:
                BorderSide(color: AppTheme.lightGrey, width: 1), // cuma bawah
          ),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: dataKeluar != null ? colorKeluar :
              dataMasuk != null ? colorMasuk : AppTheme.whiteColor,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(title, style: const TextStyle(fontSize: 14))),
              const SizedBox(
                width: 4,
              ),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          dataKeluar?.isDeleted == 1
              ? Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: AppTheme.redColor),
                  child: Text(
                    "Sudah dihapus",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                        color: AppTheme.whiteColor),
                  ),
                )
              : const SizedBox.shrink(),
          dataMasuk?.isDeleted == 1
              ? Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: AppTheme.redColor),
            child: Text(
              "Sudah dihapus",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 8,
                  color: AppTheme.whiteColor),
            ),
          )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget stokKeluarContent(int index) {
    String noStokKeluar = controller.lsNoStokKeluarGrouped[index];
    var qtyDetail = controller.lsDetailStokKeluar[noStokKeluar]?.length;
    var header = controller.showDetailKeluar(noStokKeluar: noStokKeluar);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.lightGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              InfoRow(label: "No Stok Keluar", value: noStokKeluar),
              InfoRow(label: "Jumlah keluar", value: qtyDetail.toString()),
              InfoRow(label: "Tanggal", value: header?.tanggal ?? "-"),
              InfoRow(label: "Admin", value: header?.namaDepan ?? "-"),
              InfoRow(label: "Keterangan", value: header?.keterangan ?? "-"),
            ],
          ),
          const Divider(),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.lsDetailStokKeluar[noStokKeluar]?.length,
              itemBuilder: (context, i) {
                var dataKeluar =
                controller.lsDetailStokKeluar[noStokKeluar]?[i];
                return detailRow(
                    "${dataKeluar?.namaItem ?? "-"} ${dataKeluar?.namaWarna ??
                        "-"}",
                    "${dataKeluar?.jumlahKeluar ?? "-"} ${dataKeluar?.unit ??
                        '-'}", dataKeluar: dataKeluar
                );
              }),
        ],
      ),
    );
  }

  Widget totalStokKeluar(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.15,
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.greyColor400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Transaksi Stok Keluar : ${controller.lsNoStokKeluarGrouped
                .length.toString()}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),

          const Divider(),
          InfoRow(label: "Perlu di-restok",
            value: "${controller.forRestock.value.toString()} variasi",
            sizeLabel: 10,
            sizeValue: 10,
          ),
          InfoRow(label: "Stok Habis",
            value: "${controller.stockEmpty.value.toString()} variasi",
            sizeLabel: 10,
            sizeValue: 10,),

        ],
      ),
    );
  }

  Widget stokKeluarContainer(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        "Laporan Stok Keluar",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 4),
      controller.lsNoStokKeluarGrouped.isNotEmpty
          ? SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.4,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: controller.lsNoStokKeluarGrouped.length,
          itemBuilder: (context, index) {
            return stokKeluarContent(index);
          },
        ),
      )
          : SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.44,
        width: double.infinity,
        child: const Center(
          child: Text(
            "Tidak ada data stok keluar pada bulan ini, "
                "coba cari lagi pada bulan lain",
            style: TextStyle(
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      const SizedBox(height: 8),
      totalStokKeluar(context),
    ]);
  }
}
