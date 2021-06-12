import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal/ui/components/dropdown_picker.dart';
import 'package:personal/ui/components/menu.dart';
import 'package:personal/controllers/private/accounts_controller.dart';
import 'package:personal/models/menu_option_model.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

class AccountsUI extends StatelessWidget {
  List<String> titulos = [
    "accounts.title".tr,
    "accounts.january".tr,
    "accounts.february".tr,
    "accounts.march".tr,
    "accounts.april".tr,
    "accounts.may".tr,
    "accounts.june".tr,
    "accounts.july".tr,
    "accounts.august".tr,
    "accounts.september".tr,
    "accounts.october".tr,
    "accounts.november".tr,
    "accounts.december".tr,
    "accounts.total".tr,
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountsController>(
      id: 'cuentas',
      init: AccountsController(),
      builder: (controller) => Scaffold(
        drawer: Menu(),
        appBar: AppBar(
          title: Text('accounts.title'.tr),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            alignment: AlignmentDirectional.topCenter,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  filtros(),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: FutureBuilder(
                      future: controller.getCuenta(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return tableCuentas(context, snapshot.data);
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        // By default, show a loading spinner.
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  filtros() {
    List<MenuOptionsModel> propietario = [
      MenuOptionsModel(key: "", value: "accounts.selectAll".tr),
      MenuOptionsModel(key: "JUAN_VENEGAS", value: "Juan Venegas"),
      MenuOptionsModel(key: "MARCELA_ZURITA", value: "Marcela Zurita"),
    ];

    List<MenuOptionsModel> anios = List<MenuOptionsModel>.generate(
      (DateTime.now().year - 2019),
      (i) => MenuOptionsModel(key: "${i + 2020}", value: "${i + 2020}"),
    );

    List<MenuOptionsModel> meses = [
      MenuOptionsModel(key: "", value: "accounts.selectAll".tr),
    ];
    titulos.forEach((element) {
      if (!["accounts.title".tr, "accounts.total".tr].contains(element)) {
        meses.add(MenuOptionsModel(key: element, value: element));
      }
    });
    return GetBuilder<AccountsController>(
      builder: (controller) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DropdownPicker(
            menuOptions: anios,
            selectedOption: controller.currentAnio,
            onChanged: (value) async {
              controller.updateAnio(value!);
            },
          ),
          DropdownPicker(
            menuOptions: propietario,
            selectedOption: controller.currentPropietario,
            onChanged: (value) async {
              controller.updatePropietario(value!);
            },
          ),
          DropdownPicker(
            menuOptions: meses,
            selectedOption: controller.currentTitulo,
            onChanged: (value) async {
              controller.updateTitulo(value!);
            },
          ),
        ],
      ),
    );
  }

  tableCuentas(context, data) {
    return GetBuilder<AccountsController>(builder: (controller) {
      NumberFormat f = new NumberFormat("#,##0", "es_es");
      List<DataRow> dataRow = [];
      var totales = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

      // Títulos
      int indexMes = titulos.indexOf(controller.currentTitulo);
      List<DataColumn> dataColumn = [];
      if (controller.currentTitulo != "") {
        [
          "accounts.title".tr,
          controller.currentTitulo,
        ].forEach((element) {
          dataColumn.add(DataColumn(
            label: Text(
              element,
            ),
          ));
        });
      } else {
        titulos.forEach((titulo) {
          dataColumn.add(DataColumn(
            label: Text(
              titulo,
            ),
          ));
        });
      }

      // data table
      data.forEach((keyData, valueData) {
        List<DataCell> dataCell = [];
        Map<String, dynamic> cuentas = valueData as Map<String, dynamic>;
        int total = 0;

        cuentas.forEach((keyCuentas, valueCuentas) {
          dataCell
              .add(dataCellColor(context, true, ReCase(keyCuentas).titleCase));
          List<dynamic> cuentas = valueCuentas as List<dynamic>;
          cuentas.asMap().forEach((index, element) {
            Map<String, dynamic> cuenta = element as Map<String, dynamic>;
            int monto = cuenta['MONTO'].runtimeType == 'int'
                ? cuenta['MONTO']
                : cuenta['MONTO'].toInt();
            total += monto;
            totales[index] += monto;
            if (indexMes == -1) {
              dataCell
                  .add(dataCellColor(context, false, "\$ " + f.format(monto)));
            } else {
              if ((index + 1) == indexMes) {
                dataCell.add(
                    dataCellColor(context, false, "\$ " + f.format(monto)));
              }
            }
          });
        });

        if (indexMes == -1)
          dataCell.add(dataCellColor(context, true, "\$ " + f.format(total)));
        dataRow.add(DataRow(
          cells: dataCell,
        ));
      });

      // footer table
      List<DataCell> dataCell = [dataCellColor(context, true, "Total")];
      int totalAnual = 0;
      totales.asMap().forEach((index, monto) {
        if (indexMes == -1) {
          dataCell.add(dataCellColor(context, false, "\$ " + f.format(monto)));
          totalAnual += monto;
        } else if (indexMes == (index + 1)) {
          dataCell.add(dataCellColor(context, false, "\$ " + f.format(monto)));
        }
      });
      if (indexMes == -1)
        dataCell
            .add(dataCellColor(context, false, "\$ " + f.format(totalAnual)));

      dataRow.add(DataRow(
        color: colorTitle(context),
        cells: dataCell,
      ));

      DataTable dataTable = DataTable(
        columns: dataColumn,
        rows: dataRow,
      );

      return Container(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
        child: dataTable,
      );
    });
  }

  colorTitle(context) {
    return MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.08);
    });
  }

  DataCell dataCellColor(context, isTitle, String dato) {
    return DataCell(
      Container(
        color: isTitle
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : null,
        child: Text(dato),
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
