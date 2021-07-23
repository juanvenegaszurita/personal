import 'package:flutter/material.dart';
import 'package:personal/ui/home_ui.dart';
import 'package:personal/ui/private/private.dart';
import 'package:get/get.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: listMenu(),
      ),
    );
  }

  List<Widget> listMenu() {
    final List<Map<String, dynamic>> listMenuData = [
      {"title": "home.title".tr, "page": HomeUI()},
      {"title": "accounts.title".tr, "page": AccountsUI()},
      {"title": "chart.title".tr, "page": ChartUI()},
      {"title": "password.title".tr, "page": PasswordUI()},
    ];
    final List<Widget> listMenu = [
      DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Text('Menú Personal'),
      )
    ];
    listMenuData.forEach((menu) {
      listMenu.add(ListTile(
        title: Text(menu['title']),
        onTap: () {
          Get.to(menu['page']);
        },
      ));
    });
    return listMenu;
  }
}
