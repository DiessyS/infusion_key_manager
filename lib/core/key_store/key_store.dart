import 'dart:convert';
import 'dart:typed_data';

import 'package:infusion_key_manager/core/key_store/core/key_store_core.dart';

class KeyStore extends KeyStoreCore {
  bool _keyReady = false;
  bool get keyReady => _keyReady;

  KeyStore() : super(prefix: 'store_');

  Future store({
    required Uint8List key,
    String? customAddress,
  }) async {
    final String address = await buildAddress(keyName: customAddress ?? '');
    await secureStorage.write(key: address, value: base64.encode(key));
    _keyReady = true;
  }

  Future<Uint8List?> read({String? customAddress}) async {
    final String address = await buildAddress(keyName: customAddress ?? '');
    final String? key = await secureStorage.read(key: address);
    return key == null ? null : base64.decode(key);
  }

  @override
  Future<void> dispose() async {
    final String address = await buildAddress();
    await secureStorage.delete(key: address);
    _keyReady = false;
    super.dispose();
  }
}
