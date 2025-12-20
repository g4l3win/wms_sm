import 'package:flutter/material.dart';

import '../../../navigation/routes.dart';

class MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String rute;

  MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.rute,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      icon: map['icon'],
      title: map['title'],
      subtitle: map['subtitle'],
      rute: map['rute'],
    );
  }

  // Mengonversi instance ke Map
  Map<String, dynamic> toMap() {
    return {
      'icon': icon,
      'title': title,
      'subtitle': subtitle,
      'rute': rute,
    };
  }
}

var menu = [
  {
    "icon" : Icons.folder,
    "title" : "List Kategori Stok",
    "subtitle" : "Kelola Daftar kategori stok",
    "rute" : Routes.kategoriStok
  },
  {
    "icon" : Icons.inventory,
    "title" : "List item dan variasi stok",
    "subtitle" : "Kelola Daftar item stok dan variasi stok",
    "rute" : Routes.itemVariasiStok
  },
  {
    "icon" : Icons.report,
    "title" : "Laporan Stok",
    "subtitle" : "Kelola Laporan stok masuk dan keluar bulanan",
    "rute" : Routes.laporanPage
  },
  {
    "icon" : Icons.location_on,
    "title" : "Kelola Lokasi",
    "subtitle" : "Kelola dan lacak lokasi stok",
    "rute" : Routes.menuLocation
  },
  {
    "icon" : Icons.request_page,
    "title" : "Kelola Permintaan Masuk",
    "subtitle" : "Membuat permintaan stok masuk",
    "rute" : Routes.reqMasuk
  },
  {
    "icon" : Icons.request_quote,
    "title" : "Kelola Permintaan Keluar",
    "subtitle" : "Membuat permintaan stok keluar",
    "rute" : Routes.reqKeluar
  },
  {
    "icon" : Icons.report_rounded,
    "title" : "Laporan Permintaan",
    "subtitle" : "Membuat laporan permintaan",
    "rute" : Routes.laporanReq
  },
  {
    "icon" : Icons.inbox_sharp,
    "title" : "Kelola Stok Masuk",
    "subtitle" : "Menu kelola stok masuk",
    "rute" : Routes.revisiStockMasuk
  },
  {
    "icon" : Icons.outbox_sharp,
    "title" : "Kelola Stok Keluar",
    "subtitle" : "Menu kelola stok keluar",
    "rute" : Routes.revisiStockKeluar
  },
];

var menuAdmin = [
  {
    "icon" : Icons.folder,
    "title" : "List Kategori Stok",
    "subtitle" : "Kelola Daftar kategori stok",
    "rute" : Routes.kategoriStok
  },
  {
    "icon" : Icons.inventory,
    "title" : "List item dan variasi stok",
    "subtitle" : "Kelola Daftar item stok dan variasi stok",
    "rute" : Routes.itemVariasiStok
  },
  {
    "icon" : Icons.location_on,
    "title" : "Kelola Lokasi",
    "subtitle" : "Kelola dan lacak lokasi stok",
    "rute" : Routes.menuLocation
  },
  {
    "icon" : Icons.request_page,
    "title" : "Kelola Permintaan Masuk",
    "subtitle" : "Membuat permintaan stok masuk",
    "rute" : Routes.reqMasuk
  },
  {
    "icon" : Icons.request_quote,
    "title" : "Kelola Permintaan Keluar",
    "subtitle" : "Membuat permintaan stok keluar",
    "rute" : Routes.reqKeluar
  },
  {
    "icon" : Icons.inbox_sharp,
    "title" : "Kelola Stok Masuk",
    "subtitle" : "Menu kelola stok masuk",
    "rute" : Routes.revisiStockMasuk
  },
  {
    "icon" : Icons.outbox_sharp,
    "title" : "Kelola Stok Keluar",
    "subtitle" : "Menu kelola stok keluar",
    "rute" : Routes.revisiStockKeluar
  },
];

var menuPemilik = [
  {
    "icon" : Icons.report,
    "title" : "Laporan Stok",
    "subtitle" : "Kelola Laporan stok masuk dan keluar bulanan",
    "rute" : Routes.laporanPage
  },
  {
    "icon" : Icons.report_rounded,
    "title" : "Laporan Permintaan",
    "subtitle" : "Membuat laporan permintaan",
    "rute" : Routes.laporanReq
  },
];
