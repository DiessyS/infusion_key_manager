import 'dart:convert';
import 'dart:typed_data';

import 'package:infusion_key_manager/core/key_store/core/key_store_core.dart';

class KeyStore extends KeyStoreCore {
  bool _keyReady = false;

  /// Indicates whether a key has been stored and is ready for use. (Default address only)
  bool get keyReady => _keyReady;

  KeyStore() : super(prefix: 'store_');

  Future store({
    required Uint8List key,
    String? customAddress,
  }) async {
    final String address = await buildAddress(keyName: customAddress ?? '');
    await secureStorage.write(key: address, value: base64.encode(key));

    if (customAddress == null) {
      // Only set _keyReady to true if storing with the default address
      _keyReady = true;
    }
  }

  Future<Uint8List?> read({String? customAddress}) async {
    final String address = await buildAddress(keyName: customAddress ?? '');
    final String? key = await secureStorage.read(key: address);
    return key == null ? null : base64.decode(key);
  }

  @override
  Future<void> dispose({String? customAddress}) async {
    final String address = await buildAddress(keyName: customAddress ?? '');
    await secureStorage.delete(key: address);
    if (customAddress == null) {
      _keyReady = false;
    }
    super.dispose();
  }
}
