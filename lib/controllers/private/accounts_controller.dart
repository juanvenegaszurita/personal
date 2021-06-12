import 'package:get/get.dart';
import 'package:personal/controllers/auth_controller.dart';
import 'package:personal/service/accounts_service.dart';

class AccountsController extends GetxController {
  static AccountsController to = Get.find();
  final AuthController authController = AuthController.to;

  final anio = DateTime.now().year.toString().obs;
  final propietario = "".obs;
  final titulo = "".obs;

  String get currentAnio => anio.value;
  String get currentPropietario => propietario.value;
  String get currentTitulo => titulo.value;

  @override
  void onReady() {
    updatePropietario(authController.firestoreUser.value!.owner);

    super.onReady();
  }

  Future<Map<String, dynamic>> getCuenta() async {
    try {
      return await AccountsService.getCuentas(
          anio: anio.value, propietario: propietario.value);
    } catch (e) {
      print("Error AccountsController => getCuenta\n ${e.toString()}");
      return Map<String, dynamic>();
    }
  }

  updateAnio(String value) {
    anio.value = value;
    update(['cuentas']);
  }

  updatePropietario(String value) {
    propietario.value = value;
    update(['cuentas']);
  }

  updateTitulo(String value) {
    titulo.value = value;
    update(['cuentas']);
  }
}
