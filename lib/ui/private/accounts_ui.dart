import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal/models/cuentas_model.dart';
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
                  FormVerticalSpace(),
                  addCuenta(context),
                  FormVerticalSpace(),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: loadingData(context),
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
              menuOptions: controller.propietarioList,
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

  loadingData(context) {
    return GetBuilder<AccountsController>(
      id: "loadingData",
      builder: (controller) {
        if (controller.currentLoading) {
          return CircularProgressIndicator();
        } else if (controller.currentDataCuentas.length > 0) {
          List<CuentasModel> data =
              controller.currentDataCuentas as List<CuentasModel>;
          return tableCuentas(context, data);
        } else
          return Center(child: Text('general.noData'.tr));
      },
    );
  }

  tableCuentas(context, List<CuentasModel> data) {
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
        data.forEach((cuenta) {
          List<DataCell> dataCell = [];
          int total = cuenta.montos.reduce((a, b) => a + b);

          dataCell.add(
            dataCellColor(
              context,
              true,
              ReCase(cuenta.nombre).titleCase,
              idDelete: cuenta.id,
              controller: controller,
            ),
          );
          cuenta.montos.asMap().forEach((index, monto) {
            String srtMonto = "\$ " + f.format(monto);
            totales[index] += monto;
            Map<String, dynamic> dataEdit = {
              "cuenta": cuenta,
              "mes": index,
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
    String idDelete = "",
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
          // modificar
          dialog(
            context: context,
            title: 'accounts.edit'.tr,
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
                      CuentasModel cuenta = dataEdit['cuenta'] as CuentasModel;
                      cuenta.montos[dataEdit['mes']] = int.parse(value);
                      dataEdit['cuenta'] = cuenta;
                      print(dataEdit);
                    },
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            onPressed: () async =>
                await controller.updateCuenta(cuenta: dataEdit['cuenta']),
          );
        } else if (idDelete != "") {
          dialog(
            context: context,
            title: 'accounts.delete'.tr,
            content: Text('accounts.questionDelete'.tr),
            onPressed: () async => await controller!.deleteCuenta(idDelete),
          );
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

  addCuenta(context) {
    String id = "";
    String nombre = "";
    return GetBuilder<AccountsController>(
      id: "addCuentas",
      builder: (controller) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 100, height: 40),
            child: ElevatedButton(
              child: Icon(Icons.add),
              onPressed: () {
                dialog(
                  context: context,
                  title: 'accounts.insert'.tr,
                  content: Container(
                    height: 150,
                    child: Column(
                      children: [
                        FormVerticalSpace(),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'accounts.id'.tr,
                          ),
                          onChanged: (value) {
                            id = value;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        FormVerticalSpace(),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'accounts.name'.tr,
                          ),
                          onChanged: (value) {
                            nombre = value;
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () async => await controller.addCuenta(
                    cuenta: new CuentasModel(
                      id: id,
                      nombre: nombre,
                      montos: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
