import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal/ui/components/dropdown_picker.dart';
import 'package:personal/ui/components/menu.dart';
import 'package:personal/controllers/private/accounts_controller.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';
import 'package:personal/helpers/general.dart';
import 'package:personal/ui/components/form_vertical_spacing.dart';
import 'package:responsive_grid/responsive_grid.dart';

class AccountsUI extends StatelessWidget {
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
    return GetBuilder<AccountsController>(
      builder: (controller) => ResponsiveGridRow(
        children: [
          ResponsiveGridCol(
            lg: 4,
            md: 6,
            xs: 12,
            child: DropdownPicker(
              marginButtom: 10,
              marginTop: 10,
              marginLeft: 10,
              marginRight: 10,
              menuOptions: aniosMOM,
              selectedOption: controller.currentAnio,
              onChanged: (value) async {
                controller.updateAnio(value!);
              },
            ),
          ),
          ResponsiveGridCol(
            lg: 4,
            md: 6,
            xs: 12,
            child: DropdownPicker(
              marginButtom: 10,
              marginTop: 10,
              marginLeft: 10,
              marginRight: 10,
              menuOptions: propietarioMOM,
              selectedOption: controller.currentPropietario,
              onChanged: (value) async {
                controller.updatePropietario(value!);
              },
            ),
          ),
          ResponsiveGridCol(
            lg: 4,
            md: 6,
            xs: 12,
            child: DropdownPicker(
              marginButtom: 10,
              marginTop: 10,
              marginLeft: 10,
              marginRight: 10,
              menuOptions: mesesMOM,
              selectedOption: controller.currentTitulo,
              onChanged: (value) async {
                controller.updateTitulo(value!);
              },
            ),
          ),
        ],
      ),
    );
  }

  tableCuentas(context, data) {
    return GetBuilder<AccountsController>(
      id: "tableCuentas",
      builder: (controller) {
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
            dataCell.add(
              dataCellColor(
                context,
                true,
                ReCase(keyCuentas).titleCase,
              ),
            );
            List<dynamic> cuentas = valueCuentas as List<dynamic>;
            cuentas.asMap().forEach((index, element) {
              Map<String, dynamic> cuenta = element as Map<String, dynamic>;
              int monto = cuenta['MONTO'].runtimeType == 'int'
                  ? cuenta['MONTO']
                  : cuenta['MONTO'].toInt();
              total += monto;
              totales[index] += monto;
              String srtMonto = "\$ " + f.format(monto);
              Map<String, dynamic> dataEdit = {
                "id": cuenta['ID'],
                "key": keyData,
                "mes": (index + 1),
                "anio": controller.currentAnio,
                "monto": "",
              };

              if (indexMes == -1) {
                dataCell.add(dataCellColor(context, false, srtMonto,
                    dataEdit: dataEdit, controller: controller));
              } else {
                if ((index + 1) == indexMes)
                  dataCell.add(dataCellColor(context, false, srtMonto,
                      dataEdit: dataEdit, controller: controller));
              }
            });
          });

          if (indexMes == -1) {
            dataCell.add(dataCellColor(context, true, "\$ " + f.format(total)));
          }
          dataRow.add(DataRow(cells: dataCell));
        });

        // footer table
        List<DataCell> dataCell = [
          dataCellColor(context, true, 'general.total'.tr)
        ];
        int totalAnual = 0;
        totales.asMap().forEach((index, monto) {
          if (indexMes == -1) {
            dataCell
                .add(dataCellColor(context, false, "\$ " + f.format(monto)));
            totalAnual += monto;
          } else if (indexMes == (index + 1)) {
            dataCell
                .add(dataCellColor(context, false, "\$ " + f.format(monto)));
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
      },
    );
  }

  colorTitle(context) {
    return MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.08);
    });
  }

  DataCell dataCellColor(
    context,
    isTitle,
    String dato, {
    Map<String, dynamic>? dataEdit,
    AccountsController? controller,
  }) {
    bool isAdmin = controller?.authController.admin.value != null
        ? controller!.authController.admin.value
        : false;
    return DataCell(
      Container(
        color: isTitle
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : null,
        child: Text(dato),
        width: double.infinity,
        height: double.infinity,
      ),
      showEditIcon: isAdmin,
      onLongPress: () {
        if (isAdmin && dataEdit != null) {
          // delete
          if (dataEdit["id"] != "") {
            dialog(
              context: context,
              title: 'accounts.delete'.tr,
              content: Text('accounts.questionDelete'.tr),
              onPressed: () async =>
                  await controller.deleteCuenta(id: dataEdit["id"].toString()),
            );
          } else {
            dialog(
              context: context,
              title: 'accounts.insert'.tr,
              content: Container(
                height: 100,
                child: Column(
                  children: [
                    FormVerticalSpace(),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'general.amount'.tr,
                      ),
                      onChanged: (value) {
                        controller.updateMonto(value);
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              onPressed: () async => await controller.insertCuenta(
                id: dataEdit["key"],
                anio: dataEdit["anio"],
                mes: dataEdit["mes"],
                monto: controller.currentMonto,
              ),
            );
          }
        }
      },
    );
  }

  dialog({
    context: BuildContext,
    title: String,
    content: Widget,
    Future Function()? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              child: Text('general.cancel'.tr),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('general.accept'.tr),
              onPressed: () async {
                await onPressed!.call();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
