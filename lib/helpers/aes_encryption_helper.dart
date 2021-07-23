import 'package:ninja/ninja.dart';

class AesHelper {
  static String encrypt(String secretKey, String plaintext) {
    try {
      final aes = AESKey.fromUTF8(_generateKey(secretKey));
      return aes.encryptToBase64(plaintext);
    } catch (e) {
      return "";
    }
  }

  static String decrypt(String secretKey, String encoded) {
    try {
      final aes = AESKey.fromUTF8(_generateKey(secretKey));
      return aes.decryptToUtf8(encoded);
    } catch (e) {
      return "";
    }
  }

  static String _generateKey(String key) {
    List<int> faltante = List.generate((32 - key.length).toInt(), (i) => i);
    faltante.forEach((i) => key += "a");
    return key;
  }
}
