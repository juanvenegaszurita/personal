import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountsService {
  static Future<Map<String, dynamic>> getCuentas(
      {anio: String, propietario: String}) async {
    final url =
        'https://us-central1-functions-generic.cloudfunctions.net/get_deuda?anio=$anio&propietario=$propietario';
    print("==========>>>>>>>>>><   ${url}");
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> valueMap = jsonDecode(response.body);
      return valueMap;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return Map.from({});
    }
  }
}
