import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyStoreCore {
  final FlutterSecureStorage secureStorage;
  final String base;
  final String prefix;
  Uint8List signature;

  KeyStoreCore({required this.prefix})
      : secureStorage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            keyCipherAlgorithm:
                KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
            storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
          ),
        ),
        base = 'key_store_',
        signature = Uint8List(0);

  void initializeSignature(Uint8List signature) {
    this.signature = signature;
  }

  Future<String> buildAddress({String keyName = ''}) async {
    if (signature.isEmpty) {
      throw Exception(
        'Signature is not initialized. Please call initializeSignature() first.',
      );
    }

    final Sha1 sha1 = Sha1();
    final List<int> unmixedAddress = signature + utf8.encode(keyName);
    final hash = (await sha1.hash(unmixedAddress)).bytes;

    return "${getFullPrefix()}${base64.encode(hash)}";
  }

  String getFullPrefix() {
    return '$base${prefix}_';
  }

  Future<void> dispose() async {
    signature = Uint8List(0);
  }
}
