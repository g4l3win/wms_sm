import 'package:get/get.dart';
import '../login/view/login_page.dart';
import '../module/home/binding/home_binding.dart';
import '../module/home/view/home_page.dart';
import '../module/menu/menu_item_variasi_stok/binding/item_variasi_stok_binding.dart';
import '../module/menu/menu_item_variasi_stok/view/item_variasi_stok_container.dart';
import '../module/menu/menu_kategori/binding/kategori_stok_binding.dart';
import '../module/menu/menu_kategori/view/kategori_stok_container.dart';
import '../module/menu/menu_laporan/binding/laporan_binding.dart';
import '../module/menu/menu_laporan/view/laporan_container.dart';
import '../module/menu/menu_laporan_permintaan/binding/laporan_req_binding.dart';
import '../module/menu/menu_laporan_permintaan/view/laporan_req_container.dart';
import '../module/menu/menu_lokasi/binding/menu_template_binding.dart';
import '../module/menu/menu_lokasi/view/location_container.dart';
import '../module/menu/menu_permintaan_stok_in/binding/req_stock_in_binding.dart';
import '../module/menu/menu_permintaan_stok_in/view/req_stock_in_container.dart';
import '../module/menu/menu_permintaan_stok_out/binding/req_stock_out_binding.dart';
import '../module/menu/menu_permintaan_stok_out/view/req_stock_out_container.dart';
import '../module/menu/menu_revisi_stok_keluar/binding/revisi_stock_keluar_binding.dart';
import '../module/menu/menu_revisi_stok_keluar/view/revisi_stock_keluar_container.dart';
import '../module/menu/menu_revisi_stok_masuk/binding/revisi_stock_masuk_binding.dart';
import '../module/menu/menu_revisi_stok_masuk/view/revisi_stock_masuk_container.dart';
import 'routes.dart';

class AppPages {
  AppPages._();
  static const initial = Routes.login;

  static final routes = [
    GetPage(name: Routes.login, page: () => LoginPage()),
    GetPage(name: Routes.home, page: () => HomePage(), binding: HomeBinding()),
    GetPage(
      name: Routes.itemVariasiStok,
      page: () => ItemVariasiStokContainer(),
      binding: ItemVariasiStokBinding(),
    ),
    GetPage(
      name: Routes.kategoriStok,
      page: () => KategoriStokContainer(),
      binding: KategoriStokBinding(),
    ),
    GetPage(
      name: Routes.laporanPage,
      page: () => LaporanContainer(),
      binding: LaporanBinding(),
    ),
    GetPage(
      name: Routes.menuLocation,
      page: () => LocationContainer(),
      binding: LocationBinding(),
    ),
    //kelola permintaan masuk
    GetPage(
      name: Routes.reqMasuk,
      page: () => RequestStockInContainer(),
      binding: ReqStockInBinding(),
    ),
    //kelola permintaan keluar
    GetPage(
      name: Routes.reqKeluar,
      page: () => RequestStockOutContainer(),
      binding: ReqStockOutBinding(),
    ),
    //kelola laporan permintaan
    GetPage(
      name: Routes.laporanReq,
      page: () => LaporanReqContainer(),
      binding: LaporanReqBinding(),
    ),
    //revisi stok masuk
    GetPage(
      name: Routes.revisiStockMasuk,
      page: () => RevisiStockMasukContainer(),
      binding: RevisiStockMasukBinding(),
    ),
    //revisi stok keluar
    GetPage(
      name: Routes.revisiStockKeluar,
      page: () => RevisiStockKeluarContainer(),
      binding: RevisiStockKeluarBinding(),
    ),
  ];
}
