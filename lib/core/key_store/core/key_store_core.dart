import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
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
        base = 'key_store__',
        signature = Uint8List(0);

  void initializeSignature(Uint8List signature) {
    this.signature = signature;
  }

  Future<String> buildAddress({String keyName = ''}) async {
    if (signature.isEmpty) {
      throw ArgumentError('the signature cannot be empty.');
    }

    final Sha1 sha1 = Sha1();
    final List<int> unmixedAddress = signature + utf8.encode(keyName);
    return "${getFullPrefix()}${(await sha1.hash(unmixedAddress)).toString()}";
  }

  String getFullPrefix() {
    return '$base$prefix';
  }

  Future<void> dispose() async {
    signature = Uint8List(0);
  }
}
