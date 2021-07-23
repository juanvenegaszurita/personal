import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:personal/controllers/private/password_controller.dart';
import 'package:personal/helpers/validator.dart';
import 'package:personal/models/password_model.dart';
import 'package:personal/ui/components/components.dart';
import 'package:personal/ui/components/menu.dart';
import 'package:personal/helpers/general.dart' show titlePassword;

class PasswordUI extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PasswordController>(
      id: "password",
      init: PasswordController(),
      builder: (controller) => Scaffold(
        drawer: Menu(),
        appBar: AppBar(
          title: Text('password.title'.tr),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            alignment: AlignmentDirectional.topCenter,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  formPassword(context),
                  filter(),
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

  formPassword(context) {
    return GetBuilder<PasswordController>(
      id: "loadingData",
      builder: (controller) {
        return Form(
          key: _formKey,
          child: Container(
            child: Column(
              children: [
                FormInputFieldWithIcon(
                  controller: controller.nameController,
                  iconPrefix: Icons.account_box,
                  labelText: 'password.name'.tr,
                  validator: Validator().name,
                  onChanged: (value) => null,
                  onSaved: null,
                ),
                FormVerticalSpace(),
                FormInputFieldWithIcon(
                  controller: controller.userController,
                  iconPrefix: Icons.person,
                  labelText: 'password.user'.tr,
                  validator: null,
                  onChanged: (value) => null,
                  onSaved: null,
                ),
                FormVerticalSpace(),
                FormInputFieldWithIcon(
                  controller: controller.emailController,
                  iconPrefix: Icons.email,
                  labelText: 'password.email'.tr,
                  validator: Validator().emailEmpty,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => null,
                  onSaved: null,
                ),
                FormVerticalSpace(),
                FormInputFieldWithIcon(
                  controller: controller.passwordController,
                  iconPrefix: Icons.password,
                  labelText: 'password.password'.tr,
                  validator: null,
                  onChanged: (value) => null,
                  onSaved: null,
                ),
                FormVerticalSpace(),
                FormInputFieldWithIcon(
                  controller: controller.detailsController,
                  iconPrefix: Icons.details,
                  labelText: 'password.details'.tr,
                  validator: null,
                  onChanged: (value) => null,
                  onSaved: null,
                ),
                FormVerticalSpace(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PrimaryButton(
                      labelText: 'auth.signUpButton'.tr,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          SystemChannels.textInput.invokeMethod(
                              'TextInput.hide'); //to hide the keyboard - if any
                          controller.savedOrUpdatePassword();
                        }
                      },
                    ),
                    PrimaryButton(
                      labelText: 'general.cancel'.tr,
                      onPressed: () => controller.clearForm(),
                    ),
                  ],
                ),
                FormVerticalSpace(),
              ],
            ),
          ),
        );
      },
    );
  }

  filter() {
    return GetBuilder<PasswordController>(
      builder: (controller) {
        return FormInputFieldWithIcon(
          controller: controller.filterController,
          iconPrefix: Icons.filter_list_sharp,
          labelText: 'general.filter'.tr,
          validator: null,
          onChanged: (value) async {
            controller.filterDataPassword(value);
          },
          onSaved: null,
        );
      },
    );
  }

  loadingData(context) {
    return GetBuilder<PasswordController>(
      id: "loadingData",
      builder: (controller) {
        if (controller.currentDataPassword.length > 0) {
          List<PasswordModel> data =
              controller.currentDataPassword as List<PasswordModel>;
          return tableDataPassword(context, data);
        } else
          return Center(child: Text('general.noData'.tr));
      },
    );
  }

  tableDataPassword(context, List<PasswordModel> data) {
    return GetBuilder<PasswordController>(
      id: "tableDataPassword",
      builder: (controller) {
        // data table
        List<DataRow> dataRow = [];

        data.forEach((element) {
          List<DataCell> dataCell = [
            DataCell(
              Text(element.name),
              onLongPress: () =>
                  Clipboard.setData(new ClipboardData(text: element.name)),
            ),
            DataCell(
              Text(element.user),
              onLongPress: () =>
                  Clipboard.setData(new ClipboardData(text: element.user)),
            ),
            DataCell(
              Text(element.password),
              onLongPress: () =>
                  Clipboard.setData(new ClipboardData(text: element.password)),
            ),
            DataCell(
              Text(element.email),
              onLongPress: () =>
                  Clipboard.setData(new ClipboardData(text: element.email)),
            ),
            DataCell(
              Text(element.details),
              onLongPress: () =>
                  Clipboard.setData(new ClipboardData(text: element.details)),
            ),
            DataCell(
              Row(
                children: [
                  IconButton(
                    onPressed: () => controller.editPassword(element),
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () async => modalStatus(
                        context, await controller.deletePassword(element)),
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ];
          dataRow.add(DataRow(cells: dataCell));
        });

        DataTable dataTable = DataTable(
          columns: titlePassword
              .map((title) => DataColumn(label: Text(title)))
              .toList(),
          rows: dataRow,
        );

        return Container(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
          child: dataTable,
        );
      },
    );
  }

  modalStatus(context, bool status) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title:
            status ? Text('general.titleOK'.tr) : Text('general.titleNoOK'.tr),
        content: status
            ? Text('general.messageOK'.tr)
            : Text('general.messageNoOK'.tr),
        actions: [
          TextButton(
            child: Text('general.accept'.tr),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
