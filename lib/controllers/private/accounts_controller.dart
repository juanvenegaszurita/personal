// get
import 'package:get/get.dart';
// personal
import 'package:personal/controllers/auth_controller.dart';
import 'package:personal/models/cuentas_model.dart';
import 'package:personal/models/menu_option_model.dart';
// service
import 'package:personal/service/accounts_service.dart';
// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountsController extends GetxController {
  static AccountsController to = Get.find();
  final AuthController authController = AuthController.to;

  // Firebase user one-time fetch
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final anio = DateTime.now().year.toString().obs;
  final propietario = "".obs;
  final titulo = "".obs;
  final monto = "".obs;
  final dataCuentas = [].obs;
  final loading = true.obs;

  String get currentAnio => anio.value;
  String get currentPropietario => propietario.value;
  String get currentTitulo => titulo.value;
  String get currentMonto => monto.value;
  List<dynamic> get currentDataCuentas => dataCuentas.value;
  bool get currentLoading => loading.value;

  List<MenuOptionsModel> propietarioList = [];

  @override
  void onReady() async {
    propietarioList = await authController.userList();
    updatePropietario(authController.firestoreUser.value!.uid);
    listenCuentas();

    super.onReady();
  }

  listenCuentas() {
    loading.value = true;
    streamFirestoreCuentas().listen((event) {
      updateDataCuentas(event);
      loading.value = false;
    });
  }

  updateAnio(String value) {
    anio.value = value;
    listenCuentas();
  }

  updatePropietario(String value) {
    propietario.value = value;
    listenCuentas();
  }

  updateTitulo(String value) {
    titulo.value = value;
    update(['cuentas']);
  }

  updateMonto(String value) {
    monto.value = value;
    update(['tableCuentas']);
  }

  updateDataCuentas(List<CuentasModel> value) {
    dataCuentas.value = value;
    update(['cuentas']);
  }

  // Firebase
  Stream<List<CuentasModel>> streamFirestoreCuentas() {
    return _db
        .collection("cuentas")
        .doc(propietario.value)
        .collection(anio.value)
        .orderBy('nombre')
        .snapshots()
        .map((event) => event.docs.map((e) {
              Map<String, dynamic> finalData = e.data();
              finalData['id'] = e.id;
              return CuentasModel.fromMap((finalData));
            }).toList());
  }

  Future<bool> updateCuenta({required CuentasModel cuenta}) async {
    try {
      _db
          .collection("cuentas")
          .doc(propietario.value)
          .collection(anio.value)
          .doc(cuenta.id)
          .update(cuenta.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addCuenta({required CuentasModel cuenta}) async {
    try {
      _db
          .collection("cuentas")
          .doc(propietario.value)
          .collection(anio.value)
          .doc(cuenta.id)
          .set(cuenta.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteCuenta(String id) async {
    try {
      _db
          .collection("cuentas")
          .doc(propietario.value)
          .collection(anio.value)
          .doc(id)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
