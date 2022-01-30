import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';

class Encrypt {
  String secureKey = '';
  Future init() async {
    final String k = await rootBundle.loadString('assets/key/key.txt');
    secureKey = k;
  }

  String encryption(String? plainText) {
    final key = Key.fromBase64(secureKey);
    final iv = IV.fromLength(16);

    final encryptor = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    final encrypted = encryptor.encrypt(plainText!, iv: iv);

    return encrypted.base64;
  }


  String decryption(String? plainText) {

    final key = Key.fromBase64(secureKey);
    final iv = IV.fromLength(16);

    final encryptor = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    final decrypted = encryptor.decrypt(Encrypted.from64(plainText!), iv: iv);

    return decrypted;
  }
}
