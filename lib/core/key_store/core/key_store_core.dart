import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyStoreCore {
  final FlutterSecureStorage secureStorage;
  final String _base;
  final String prefix;
  Uint8List _signature;

  KeyStoreCore({required this.prefix})
      : secureStorage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            keyCipherAlgorithm:
                KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
            storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
          ),
        ),
        _base = 'key_store_',
        _signature = Uint8List(0);

  void initializeSignature(Uint8List signature) {
    _signature = signature;
  }

  Future<String> buildAddress({String keyName = ''}) async {
    if (!hasSignature()) {
      throw Exception(
        'Signature is not initialized. Please call initializeSignature() first.',
      );
    }

    final sha1 = Sha1();
    final sink = sha1.newHashSink();

    sink.add(_signature);
    sink.add(utf8.encode(keyName));
    sink.close();

    final hash = await sink.hash();

    return "${getFullPrefix()}${_uint8listToRadixString(hash.bytes)}";
  }

  bool hasSignature() {
    return _signature.isNotEmpty;
  }

  String getFullPrefix() {
    return '$_base${prefix}_';
  }

  Future<void> dispose() async {
    _signature = Uint8List(0);
  }

  String _uint8listToRadixString(List<int> bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
