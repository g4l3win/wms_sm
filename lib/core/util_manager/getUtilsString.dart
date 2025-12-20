import 'package:get/get_utils/src/get_utils/get_utils.dart';

extension GetStringUtils on String {
  bool get isNum => GetUtils.isNum(this);

  bool get isNumericOnly => GetUtils.isNumericOnly(this);

  bool get isAlphabetOnly => GetUtils.isAlphabetOnly(this);

  bool get isBool => GetUtils.isBool(this);

  bool get isVectorFileName => GetUtils.isVector(this);

  bool get isImageFileName => GetUtils.isImage(this);

  bool get isAudioFileName => GetUtils.isAudio(this);

  bool get isExcelFileName => GetUtils.isExcel(this);

  bool get isPhoneNumber => GetUtils.isPhoneNumber(this);

  bool get isDateTime => GetUtils.isDateTime(this);

  bool get isSHA256 => GetUtils.isSHA256(this);

  bool get isPalindrom => GetUtils.isPalindrom(this);

  bool get isCurrency => GetUtils.isCurrency(this);

  bool isCaseInsensitiveContains(String b) =>
      GetUtils.isCaseInsensitiveContains(this, b);

  bool isCaseInsensitiveContainsAny(String b) =>
      GetUtils.isCaseInsensitiveContainsAny(this, b);

  String? get capitalize => GetUtils.capitalize(this);

  String? get capitalizeFirst => GetUtils.capitalizeFirst(this);

  String get removeAllWhitespace => GetUtils.removeAllWhitespace(this);

  String? get camelCase => GetUtils.camelCase(this);

  String? get paramCase => GetUtils.paramCase(this);

  String numericOnly({bool firstWordOnly = false}) =>
      GetUtils.numericOnly(this, firstWordOnly: firstWordOnly);

  String createPath([Iterable? segments]) {
    final path = startsWith('/') ? this : '/$this';
    return GetUtils.createPath(path, segments);
  }
}

///cara pakai
// cobaGetUtils.value = value; //alamat123

//   log("cek camel case : ${cobaGetUtils.value.camelCase}");
//   log("cek isnumerik : ${cobaGetUtils.value.isNumericOnly}");
//   log("cek isalfabetonly : ${cobaGetUtils.value.isAlphabetOnly}");
//   log("cek issha256 : ${cobaGetUtils.value.isSHA256}");
//   log("cek palindrom : ${cobaGetUtils.value.isPalindrom}");
//   log("cek createPath : ${cobaGetUtils.value.createPath(["cek", "123"])}");
//   log("cek case sensitive : ${cobaGetUtils.value.isCaseInsensitiveContains("123")}");
//   log("cek case sensitive  any: ${cobaGetUtils.value.isCaseInsensitiveContainsAny("a")}");

///hasil
// [log] cek camel case : alamat123
// [log] cek isnumerik : false
// [log] cek isalfabetonly : false
// [log] cek issha256 : false
// [log] cek palindrom : false
// [log] cek createPath : /alamat123/cek/123
// [log] cek case sensitive : true
// [log] cek case sensitive  any: true
// V/StudioTransport(18706): Agent handling command (id:232 type:APP_INSPECTION) for pid:18706.
// V/StudioTransport(18706): Agent handling command (id:233 type:APP_INSPECTION) for pid:18706.
