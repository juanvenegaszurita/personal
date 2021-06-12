import 'package:flutter/material.dart';
import 'package:personal/controllers/controllers.dart';
import 'package:personal/ui/components/components.dart';
import 'package:personal/ui/components/menu.dart';
import 'package:personal/ui/ui.dart';
import 'package:get/get.dart';

class HomeUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      // ignore: unnecessary_null_comparison
      builder: (controller) => controller.firestoreUser.value!.uid == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              drawer: Menu(),
              appBar: AppBar(
                title: Text('home.title'.tr),
                actions: [
                  IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Get.to(SettingsUI());
                      }),
                ],
              ),
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Avatar(controller.firestoreUser.value!),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FormVerticalSpace(),
                          Text(
                              'home.uidLabel'.tr +
                                  ': ' +
                                  controller.firestoreUser.value!.uid,
                              style: TextStyle(fontSize: 16)),
                          FormVerticalSpace(),
                          Text(
                              'home.nameLabel'.tr +
                                  ': ' +
                                  controller.firestoreUser.value!.name,
                              style: TextStyle(fontSize: 16)),
                          FormVerticalSpace(),
                          Text(
                              'home.emailLabel'.tr +
                                  ': ' +
                                  controller.firestoreUser.value!.email,
                              style: TextStyle(fontSize: 16)),
                          FormVerticalSpace(),
                          Text(
                              'home.adminUserLabel'.tr +
                                  ': ' +
                                  controller.admin.value.toString(),
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
