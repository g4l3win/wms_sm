
import '../../../../core/database/data/m_lokasi_stok.dart';
import '../../../../core/database/data/m_supplier.dart';
import '../../menu_item_variasi_stok/data/stok_grid_model.dart';
import 'menu_template_controller.dart';

extension CrudTemplateController on LocationController {
  Future<bool> createTableExist(String tableName) async {
    var isExist = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [tableName]);
    return isExist.isNotEmpty;

  }

  Future<List<Map<String, dynamic>>> getPaginationData(
      int limitQuery, int offset) async {

    var result = await db.query("LOKASI_STOK", limit: limitQuery, offset: offset);

    return result;
  }

  checkExist (LokasiStok data){
    var noPKtoCheck = data.NoLokasi;

    var exist = listData.any((element) => element.NoLokasi == noPKtoCheck);
    if(!exist) {
      listData.add(data);
      filterListData.add(data);
    }
  }

  onAssignPaginationData({bool reset = false}) async {
    if (reset) {
      page.value = 0;
      listData.clear();
      filterListData.clear();
      hasMore.value = true;
    }

    int offset = page.value * limit.value;
    var getData = await getPaginationData(limit.value, offset);

    if (getData.isEmpty) {
      hasMore.value = false;
    } else {
      for (var item in getData) {
        var data = LokasiStok.fromMap(item);
        checkExist(data);
      }
      page.value++;
    }
  }

  Future<List<Map<String, dynamic>>> getDataGridByLoc(String selectedNoLoc) async {
    final result = await db.rawQuery('''
    SELECT 
      i.NoItem,
      i.NamaItem,
      i.Unit,
      v.NoItemWarna,
      v.NamaWarna,
      v.Jumlah,
      v.Harga,
      v.GambarPath,
      v.ROP,
      l.NamaLokasi,
      k.NamaKategori
    FROM VARIASI_WARNA v
    JOIN ITEM_STOK i ON v.NoItem = i.NoItem
    JOIN LOKASI_STOK l ON i.NoLokasi = l.NoLokasi
    JOIN KATEGORI_STOK k ON i.NoKategori = k.NoKategori
    WHERE v.isDeleted = 0 AND l.NoLokasi = ?
  ''', [selectedNoLoc],);
    return result;
  }

  onAssignData(String noLocSelected) async {
    var result =  await getDataGridByLoc(noLocSelected);
    stokList.clear();

    for (var item in result) {
      stokList.add(StokGridModel.fromMap(item));

    }
    pageIdx.value =1;
  }

  Future<void> insertDatabase({required m_supplier data}) async {
    Map<String, dynamic> mapData = {};

    if (data.noSupplier != null) mapData["NoSupplier"] = data.noSupplier;
    if (data.namaSupplier != null) mapData["NamaSupplier"] = data.namaSupplier;
    if (data.alamat != null) mapData["Alamat"] = data.alamat;

    //tambahan
    if (data.jumlah != null) mapData["Jumlah"] = data.jumlah;
    if (data.tanggal != null) mapData["Tanggal"] = data.tanggal;

    db.insert("SUPPLIER", mapData);
    await  onAssignPaginationData(reset: true);
  }

  Future<void> updateDatabase({required m_supplier data}) async {
    Map<String, dynamic> mapData = {};

    if (data.noSupplier != null) mapData["NoSupplier"] = data.noSupplier;
    if (data.namaSupplier != null) mapData["NamaSupplier"] = data.namaSupplier;
    if (data.alamat != null) mapData["Alamat"] = data.alamat;

    //tambahan
    if(data.jumlah !=null) mapData["Jumlah"] = data.jumlah;
    if(data.tanggal !=null) mapData["Tanggal"] = data.tanggal;

    db.update("SUPPLIER", mapData,
        where: "NoSupplier = ?", whereArgs: [mapData["NoSupplier"]]);
    await onAssignPaginationData(reset: true);
  }

  Future<void> deleteDatabase(String id) async {
    db.delete("SUPPLIER", where: "NoSupplier = ?", whereArgs: [id]);
    await  onAssignPaginationData(reset: true);
  }

}