import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:personal/controllers/auth_controller.dart';
import 'package:personal/helpers/general.dart';
import 'package:personal/models/cuentas_model.dart';
import 'package:personal/models/menu_option_model.dart';
import 'package:personal/ui/components/all_chart.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartController extends GetxController {
  static ChartController to = Get.find();
  final AuthController authController = AuthController.to;

  // Firebase user one-time fetch
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final anio = DateTime.now().year.toString().obs;
  final propietario = "".obs;
  final mes = "".obs;
  final dataCuentas = Map<String, dynamic>().obs;

  String get currentAnio => anio.value;
  String get currentPropietario => propietario.value;
  String get currentMes => mes.value;
  Map<String, dynamic> get currentDataCuentas => dataCuentas.value;

  List<MenuOptionsModel> propietarioList = [];

  @override
  void onReady() async {
    propietarioList = await authController.userList();
    updatePropietario(authController.firestoreUser.value!.uid);
    listenCuentas();

    super.onReady();
  }

  listenCuentas() {
    streamFirestoreCuentas().listen((event) {
      updateDataCuentas(getCuenta(event));
    });
  }

  Map<String, dynamic> getCuenta(List<CuentasModel> cuentas) {
    List<int> totales = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    List<String> keyCuentas = [];
    List<int> totalCuentas = [];
    var mesNum = titulos.indexOf(mes.value) - 1;
    cuentas.forEach((cuenta) {
      int total = 0;
      keyCuentas.add(cuenta.nombre);
      if (mesNum < 0) {
        cuenta.montos.asMap().forEach((index, monto) {
          totales[index] += monto;
          total += monto;
        });
      } else {
        int monto = cuenta.montos[mesNum];
        totales[mesNum] += monto;
        total += monto;
      }

      totalCuentas.add(total);
    });

    return {
      "keyCuentas": keyCuentas,
      "totalCuentas": totalCuentas,
      "totales": totales,
    };
  }

  updateAnio(String value) {
    anio.value = value;
    listenCuentas();
  }

  updatePropietario(String value) {
    propietario.value = value;
    listenCuentas();
  }

  updateMes(String value) {
    mes.value = value;
    listenCuentas();
  }

  updateDataCuentas(Map<String, dynamic> value) {
    dataCuentas.value = value;
    update(['chart']);
  }

  List<BarChartGroupData> dataBarGroups(List<int> data) {
    List<BarChartGroupData> dataFinal = [];

    data.asMap().forEach((index, data) {
      dataFinal.add(
        makeBarChartGroupData(
          index,
          double.parse('$data'),
          barColor: availableColors[index],
        ),
      );
    });

    return dataFinal;
  }

  // Firebase
  Stream<List<CuentasModel>> streamFirestoreCuentas() {
    return _db
        .collection("cuentas")
        .doc(propietario.value)
        .collection(anio.value)
        .snapshots()
        .map((event) => event.docs.map((e) {
              Map<String, dynamic> finalData = e.data();
              finalData['id'] = e.id;
              return CuentasModel.fromMap((finalData));
            }).toList());
  }
}
