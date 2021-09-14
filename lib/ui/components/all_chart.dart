import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:recase/recase.dart';

BarChartGroupData makeBarChartGroupData(
  int x,
  double y, {
  bool isTouched = false,
  Color barColor = Colors.white,
  double width = 22,
  List<int> showTooltips = const [],
}) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        y: isTouched ? y + 1 : y,
        colors: isTouched ? [Colors.yellow] : [barColor],
        width: width,
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          y: 20,
          colors: [Color(0xff72d8bf)],
        ),
      ),
    ],
    showingTooltipIndicators: showTooltips,
  );
}

class MakeBarChart extends StatelessWidget {
  MakeBarChart({
    required this.barChartGroupData,
    required this.titulos,
    this.colorFont = Colors.black,
    this.duration = const Duration(milliseconds: 250),
    this.interval = 100000,
  });

  final List<BarChartGroupData> barChartGroupData;
  final List<String> titulos;
  final Color? colorFont;
  final Duration duration;
  final double interval;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      barChartData(
        barChartGroupData,
        colorFont: colorFont,
        interval: interval,
      ),
      swapAnimationDuration: duration,
    );
  }

  BarChartData barChartData(
    List<BarChartGroupData> barChartGroupData, {
    double interval = 100000,
    Color? colorFont = Colors.white,
  }) {
    return BarChartData(
      barTouchData: BarTouchData(enabled: true),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => TextStyle(
            color: colorFont,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          margin: 55,
          getTitles: (double value) {
            String str = "";
            if (titulos.length > 0 && value.toInt() < titulos.length)
              str = titulos[value.toInt()].length > 10
                  ? ReCase(titulos[value.toInt()].substring(0, 10)).titleCase +
                      "..."
                  : ReCase(titulos[value.toInt()]).titleCase;
            return str;
          },
          rotateAngle: -90,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (double value) => TextStyle(color: Colors.white),
          interval: interval,
        ),
      ),
      borderData: FlBorderData(show: true),
      barGroups: barChartGroupData,
    );
  }
}
