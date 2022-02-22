import 'package:flutter/material.dart';
// get
import 'package:get/get.dart';
// firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// personal
import 'package:personal/controllers/auth_controller.dart';
import 'package:personal/models/menu_option_model.dart';
// model
import 'package:personal/models/password_model.dart';
// other
import 'package:personal/helpers/aes_encryption_helper.dart';

class PasswordController extends GetxController {
  static PasswordController to = Get.find();
  final AuthController authController = AuthController.to;

  // Firebase user one-time fetch
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<User> get getUser async => _auth.currentUser!;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  TextEditingController filterController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  // groups init
  List<MenuOptionsModel> groups = [
    MenuOptionsModel(key: "", value: "Seleccionar Grupo"),
  ];
  final group = "".obs;
  String get currentGroup => group.value;

  updateGroup(String value) {
    group.value = value;
    update(['loadingData']);
  }
  // groups end

  List<PasswordModel> _allDataPassword = [];
  final dataPassword = [].obs;

  List<dynamic> get currentDataPassword => dataPassword.value;

  PasswordModel get dataForm => PasswordModel(
        id: idController.text,
        group: currentGroup,
        name: nameController.text,
        user: userController.text,
        email: emailController.text,
        password: AesHelper.encrypt(
            authController.firebaseUser.value!.uid, passwordController.text),
        details: detailsController.text,
      );

  @override
  void onReady() async {
    await streamFirestoreGroups();
    streamFirestorePassword().listen((event) {
      _allDataPassword = event;
      filterDataPassword(filterController.text);
    });
    super.onReady();
  }

  @override
  void onClose() {
    filterController.dispose();
    super.onClose();
  }

  updateDataPassword(List<PasswordModel> value) {
    dataPassword.value = value;
    update(["loadingData"]);
  }

  filterDataPassword(String filter) {
    List<PasswordModel> dataFinal = _allDataPassword
        .where((password) =>
            "${password.group} ${password.name} ${password.user} ${password.email} ${password.details}"
                .toUpperCase()
                .contains(filter.toUpperCase()))
        .toList();
    updateDataPassword(dataFinal);
  }

  Stream<List<PasswordModel>> streamFirestorePassword() {
    return _db
        .collection('dataPassword')
        .doc(authController.firebaseUser.value!.uid)
        .collection("data")
        .orderBy("group")
        .snapshots()
        .map((event) => event.docs.map((e) {
              Map<String, dynamic> finalData = e.data();
              finalData['id'] = e.id;
              if (finalData['password'] != "") {
                finalData['password'] = AesHelper.decrypt(
                    authController.firebaseUser.value!.uid,
                    finalData['password']);
              }
              return PasswordModel.fromMap((finalData));
            }).toList());
  }

  Future<void> streamFirestoreGroups() async {
    DocumentSnapshot<Map<String, dynamic>> data = await _db
        .collection('dataPassword')
        .doc(authController.firebaseUser.value!.uid)
        .get();
    if (data.exists) {
      Map<String, dynamic>? finalData = data.data();
      List<dynamic> groupsFB = finalData!['GROUPS'];
      var a =
          (groupsFB.map((e) => MenuOptionsModel(key: e, value: e))).toList();
      groups.addAll(a);
    }
  }

  void editPassword(PasswordModel password) {
    idController.text = password.id;
    nameController.text = password.name;
    userController.text = password.user;
    emailController.text = password.email;
    passwordController.text = password.password;
    detailsController.text = password.details;
    updateGroup(password.group);
  }

  Future<bool> deletePassword(PasswordModel password) async {
    try {
      _db
          .collection('dataPassword')
          .doc(authController.firebaseUser.value!.uid)
          .collection("data")
          .doc(password.id)
          .delete();
      if (idController.text != "") clearForm();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> savedOrUpdatePassword() async {
    try {
      if (idController.text == "") {
        _db
            .collection('dataPassword')
            .doc(authController.firebaseUser.value!.uid)
            .collection("data")
            .add(dataForm.toJson());
      } else {
        _db
            .collection('dataPassword')
            .doc(authController.firebaseUser.value!.uid)
            .collection("data")
            .doc(idController.text)
            .update(dataForm.toJson());
      }
      clearForm();
      return true;
    } catch (e) {
      return false;
    }
  }

  clearForm() {
    idController.clear();
    nameController.clear();
    userController.clear();
    emailController.clear();
    passwordController.clear();
    detailsController.clear();
    updateGroup("");
    update(["password"]);
  }
}
