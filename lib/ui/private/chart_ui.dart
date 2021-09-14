import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal/controllers/private/chart_controller.dart';
import 'package:personal/ui/components/menu.dart';
import 'package:personal/helpers/general.dart';
import 'package:personal/ui/components/dropdown_picker.dart';
import 'package:personal/ui/components/all_chart.dart';
import 'package:responsive_grid/responsive_grid.dart';
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
                  //futureBuilder(),
                  loadingData(context)
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
              selectedOption: controller.currentMes,
              onChanged: (value) async {
                controller.updateMes(value!);
              },
            ),
          ),
        ],
      ),
    );
  }

  loadingData(context) {
    return GetBuilder<ChartController>(
      builder: (controller) {
        if (controller.currentDataCuentas.length > 0) {
          return ResponsiveGridRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ResponsiveGridCol(
                lg: 6,
                md: 6,
                xs: 12,
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 60,
                    top: 20,
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('chart.monthly'.tr),
                      makeBarChartTotales(context,
                          data: controller.currentDataCuentas["totales"]),
                    ],
                  ),
                ),
              ),
              ResponsiveGridCol(
                lg: 6,
                md: 6,
                xs: 12,
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 60,
                    top: 20,
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('chart.accounts'.tr),
                      makeBarChartTotalCuentas(
                        context,
                        data: controller.currentDataCuentas["totalCuentas"],
                        keyCuentas: controller.currentDataCuentas["keyCuentas"],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else
          return CircularProgressIndicator();
      },
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
