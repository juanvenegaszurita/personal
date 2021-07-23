import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:personal/models/menu_option_model.dart';
import 'package:flutter/material.dart';

List<String> titulos = [
  "general.title".tr,
  "general.january".tr,
  "general.february".tr,
  "general.march".tr,
  "general.april".tr,
  "general.may".tr,
  "general.june".tr,
  "general.july".tr,
  "general.august".tr,
  "general.september".tr,
  "general.october".tr,
  "general.november".tr,
  "general.december".tr,
  "general.total".tr,
];

List<String> meses = [
  "general.january".tr,
  "general.february".tr,
  "general.march".tr,
  "general.april".tr,
  "general.may".tr,
  "general.june".tr,
  "general.july".tr,
  "general.august".tr,
  "general.september".tr,
  "general.october".tr,
  "general.november".tr,
  "general.december".tr,
];

List<MenuOptionsModel> propietarioMOM = [
  MenuOptionsModel(key: "", value: "general.selectowner".tr),
  MenuOptionsModel(key: "JUAN_VENEGAS", value: "Juan Venegas"),
  MenuOptionsModel(key: "MARCELA_ZURITA", value: "Marcela Zurita"),
];
List<MenuOptionsModel> aniosMOM = List<MenuOptionsModel>.generate(
  (DateTime.now().year - 2019),
  (i) => MenuOptionsModel(key: "${i + 2020}", value: "${i + 2020}"),
);

List<MenuOptionsModel> mesesMOM = [
  MenuOptionsModel(key: "", value: "general.selectAll".tr),
  MenuOptionsModel(key: "general.january".tr, value: "general.january".tr),
  MenuOptionsModel(key: "general.february".tr, value: "general.february".tr),
  MenuOptionsModel(key: "general.march".tr, value: "general.march".tr),
  MenuOptionsModel(key: "general.april".tr, value: "general.april".tr),
  MenuOptionsModel(key: "general.may".tr, value: "general.may".tr),
  MenuOptionsModel(key: "general.june".tr, value: "general.june".tr),
  MenuOptionsModel(key: "general.july".tr, value: "general.july".tr),
  MenuOptionsModel(key: "general.august".tr, value: "general.august".tr),
  MenuOptionsModel(key: "general.september".tr, value: "general.september".tr),
  MenuOptionsModel(key: "general.october".tr, value: "general.october".tr),
  MenuOptionsModel(key: "general.november".tr, value: "general.november".tr),
  MenuOptionsModel(key: "general.december".tr, value: "general.december".tr),
];

List<Color> availableColors = [
  Colors.amber,
  Colors.blue,
  Colors.brown,
  Colors.cyan,
  Colors.deepOrange,
  Colors.deepPurple,
  Colors.green,
  Colors.grey,
  Colors.indigo,
  Colors.lightBlue,
  Colors.lightGreen,
  Colors.lime,
  Colors.orange,
  Colors.pink,
  Colors.purple,
  Colors.redAccent,
  Colors.teal,
  Colors.yellow,
];

List<String> titlePassword = [
  "Nombre",
  "Usuario",
  "Clave",
  "Correo",
  "Detalle",
  "Acción",
];
