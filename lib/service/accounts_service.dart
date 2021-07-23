import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountsService {
  static String urlC =
      "https://us-central1-functions-generic.cloudfunctions.net";

  static Future<Map<String, dynamic>> getCuentas({
    String anio = "",
    int mes = 0,
    String propietario = "",
  }) async {
    final url =
        '$urlC/get_deuda?anio=$anio&mes=${mes > 0 ? mes : ''}&propietario=$propietario';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> valueMap = jsonDecode(response.body);
      return valueMap;
    } else {
      return Map.from({});
    }
  }

  //insert_deuda?id='+id+'&mes='+mes+'&anio=2021&monto='+monto
  static Future<Map<String, dynamic>> insertCuenta({
    required String id,
    required String anio,
    required int mes,
    required String monto,
  }) async {
    final url = '$urlC/insert_deuda?id=$id&anio=$anio&mes=$mes&monto=$monto';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> valueMap = jsonDecode(response.body);
      return valueMap;
    } else {
      return {"payload": "Error al insertar"};
    }
  }

  static Future<Map<String, dynamic>> deleteCuentas({String id = ""}) async {
    final url = '$urlC/delete_deuda?id=$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> valueMap = jsonDecode(response.body);
      return valueMap;
    } else {
      return {"payload": "Error al insertar"};
    }
  }
}
