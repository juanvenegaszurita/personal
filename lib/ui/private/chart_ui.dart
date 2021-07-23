import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal/controllers/private/chart_controller.dart';
import 'package:personal/ui/components/form_vertical_spacing.dart';
import 'package:personal/ui/components/menu.dart';
import 'package:personal/helpers/general.dart';
import 'package:personal/ui/components/dropdown_picker.dart';
import 'package:personal/ui/components/all_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class ChartUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChartController>(
      id: 'chart',
      init: ChartController(),
      builder: (controller) => Scaffold(
        drawer: Menu(),
        appBar: AppBar(
          title: Text("chart.title".tr),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            alignment: AlignmentDirectional.topCenter,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  filtro(),
                  futureBuilder(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  filtro() {
    return GetBuilder<ChartController>(
      builder: (controller) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DropdownPicker(
            menuOptions: aniosMOM,
            selectedOption: controller.currentAnio,
            onChanged: (value) async {
              controller.updateAnio(value!);
            },
          ),
          DropdownPicker(
            menuOptions: propietarioMOM,
            selectedOption: controller.currentPropietario,
            onChanged: (value) async {
              controller.updatePropietario(value!);
            },
          ),
          DropdownPicker(
            menuOptions: mesesMOM,
            selectedOption: controller.currentMes,
            onChanged: (value) async {
              controller.updateMes(value!);
            },
          ),
        ],
      ),
    );
  }

  futureBuilder() {
    return GetBuilder<ChartController>(
      builder: (controller) => FutureBuilder(
        future: controller.getCuenta(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var dataFinal = snapshot.data as Map<String, dynamic>;
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('chart.monthly'.tr),
                  makeBarChartTotales(context, data: dataFinal["totales"]),
                  FormVerticalSpace(),
                  Text('chart.accounts'.tr),
                  makeBarChartTotalCuentas(
                    context,
                    data: dataFinal["totalCuentas"],
                    keyCuentas: dataFinal["keyCuentas"],
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }

  makeBarChartTotales(context, {List<int> data = const []}) {
    return GetBuilder<ChartController>(
      builder: (controller) {
        List<BarChartGroupData> barChartGroupData =
            controller.dataBarGroups(data);
        if (data.length > 0 && data.reduce(max) > 0) {
          return Center(
            child: SizedBox(
              width: 5000.0,
              height: 300.0,
              child: MakeBarChart(
                barChartGroupData: barChartGroupData,
                titulos: meses,
                colorFont: Theme.of(context).textTheme.bodyText1!.color,
                interval: (data.reduce(max) / 5),
              ),
            ),
          );
        } else {
          return Text('general.noData'.tr);
        }
      },
    );
  }

  makeBarChartTotalCuentas(
    context, {
    List<int> data = const [],
    List<String> keyCuentas = const [],
  }) {
    return GetBuilder<ChartController>(
      builder: (controller) {
        if (data.length > 0 && data.reduce(max) > 0) {
          List<BarChartGroupData> barChartGroupData =
              controller.dataBarGroups(data);
          return Center(
            child: SizedBox(
              width: 5000.0,
              height: 300.0,
              child: MakeBarChart(
                barChartGroupData: barChartGroupData,
                titulos: keyCuentas,
                colorFont: Theme.of(context).textTheme.bodyText1!.color,
                interval: (data.reduce(max) / 5),
              ),
            ),
          );
        } else {
          return Text('general.noData'.tr);
        }
      },
    );
  }
}
