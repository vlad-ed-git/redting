import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart' hide Key;

class EncryptTxtMessage {
  static String? encryptTxtMessage(String message) {
    try {
      final useIv = IV.fromLength(16);
      final useKey = Key.fromLength(32);

      final encryptor = Encrypter(AES(useKey));
      final encrypted = encryptor.encrypt(message, iv: useIv);
      return encrypted.base64;
    } catch (e) {
      if (kDebugMode) {
        print("============ encryptTxtMessage exc $e =========");
      }
      return null;
    }
  }

  static String? decryptTxtMessage(String encryptedMessage) {
    try {
      final useIv = IV.fromLength(16);
      final useKey = Key.fromLength(32);

      final encryptor = Encrypter(AES(useKey));
      final decrypted =
          encryptor.decrypt(Encrypted.fromBase64(encryptedMessage), iv: useIv);
      return decrypted;
    } catch (e) {
      if (kDebugMode) {
        print("============ encryptTxtMessage exc $e =========");
      }
      return null;
    }
  }
}
