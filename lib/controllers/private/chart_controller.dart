import 'package:get/get.dart';
import 'package:personal/controllers/auth_controller.dart';
import 'package:personal/helpers/general.dart';
import 'package:personal/service/accounts_service.dart';
import 'package:personal/ui/components/all_chart.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartController extends GetxController {
  static ChartController to = Get.find();
  final AuthController authController = AuthController.to;

  final anio = DateTime.now().year.toString().obs;
  final propietario = "".obs;
  final mes = "".obs;

  String get currentAnio => anio.value;
  String get currentPropietario => propietario.value;
  String get currentMes => mes.value;

  @override
  void onReady() {
    updatePropietario(authController.firestoreUser.value!.owner);

    super.onReady();
  }

  Future<Map<String, dynamic>> getCuenta() async {
    List<int> totales = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    List<String> keyCuentas = [];
    List<int> totalCuentas = [];
    try {
      Map<String, dynamic> data = await AccountsService.getCuentas(
        anio: anio.value,
        propietario: propietario.value,
        mes: titulos.indexOf(mes.value),
      );

      data.forEach((keyData, valueData) {
        Map<String, dynamic> cuentas = valueData as Map<String, dynamic>;
        int total = 0;
        cuentas.forEach((nombreCuentas, valueCuentas) {
          keyCuentas.add(nombreCuentas);
          List<dynamic> cuentas = valueCuentas as List<dynamic>;
          cuentas.asMap().forEach((index, element) {
            Map<String, dynamic> cuenta = element as Map<String, dynamic>;
            int monto = cuenta['MONTO'].runtimeType == 'int'
                ? cuenta['MONTO']
                : cuenta['MONTO'].toInt();
            total += monto;
            totales[index] += monto;
          });
        });
        totalCuentas.add(total);
      });
    } catch (e) {
      print("Error AccountsController => getCuenta\n ${e.toString()}");
    }
    return {
      "keyCuentas": keyCuentas,
      "totalCuentas": totalCuentas,
      "totales": totales,
    };
  }

  updateAnio(String value) {
    anio.value = value;
    update(['chart']);
  }

  updatePropietario(String value) {
    propietario.value = value;
    update(['chart']);
  }

  updateMes(String value) {
    mes.value = value;
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
}
