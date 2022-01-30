import 'package:encrypt/encrypt.dart';

class Encrypt {


  static String encryption(String? plainText) {

    final key = Key.fromBase64('qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    final encrypted = encrypter.encrypt(plainText!, iv: iv);

    return encrypted.base64;
  }

  static String decryption(String? plainText) {

    final key = Key.fromBase64('qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    final decrypted = encrypter.decrypt(Encrypted.from64(plainText!), iv: iv);

    return decrypted;
  }
}