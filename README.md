# personal

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

 ```dart

  /* Future<bool> deletePassword(PasswordModel password) async {
    try {
      _db
          .collection('dataPassword')
          .doc(authController.firebaseUser.value!.uid)
          .update({
        "data": FieldValue.arrayRemove([password.toJson()])
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> savedPassword() async {
    DocumentReference<Map<String, dynamic>> doc = _db
        .collection('dataPassword')
        .doc(authController.firebaseUser.value!.uid);
    if (this.currentIsNew) {
      await dataPasswordFirebase(doc, dataForm);
    }
    clearForm();
  }

  dataPasswordFirebase(
    DocumentReference<Map<String, dynamic>> dataPassword,
    PasswordModel password,
  ) async {
    if ((await dataPassword.get()).exists)
      await dataPassword.update({
        "data": FieldValue.arrayUnion([password.toJson()])
      });
    else
      await dataPassword.set({
        "data": [password.toJson()]
      });
  } */
 ```