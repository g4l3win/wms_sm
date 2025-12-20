import 'package:get/get.dart';

class MonthYearPickerController extends GetxController {
  var selectedMonth = DateTime.now().month.obs; // default bulan sekarang
  var selectedYear = DateTime.now().year.obs;   // default tahun sekarang

  var listMonth = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  //list tahun dari 2000 - 2100
  List<int> get listYear =>
      List<int>.generate(101, (index) => 2000 + index);


  void setMonth(int month) {
    selectedMonth.value = month;
  }

  void setYear(int year) {
    selectedYear.value = year;
  }
}