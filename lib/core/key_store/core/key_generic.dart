import 'dart:convert';
import 'dart:typed_data';

import 'package:infusion_key_manager/core/key_store/core/key_store_core.dart';
import 'package:infusion_key_manager/core/key_store/dto/key_data.dart';

class KeyGeneric extends KeyStoreCore {
  KeyGeneric(String prefix) : super(prefix: prefix);

  Future genericStore({
    required KeyData key,
  }) async {
    final String keyAddress = await buildAddress(keyName: key.address);
    await secureStorage.write(key: keyAddress, value: base64.encode(key.key));
  }

  Future<Uint8List?> genericRead({required String address}) async {
    final String keyAddress = await buildAddress(keyName: address);
    final String? key = await secureStorage.read(key: keyAddress);
    return key == null ? null : base64.decode(key);
  }

  Future<void> genericDispose(
      {required String address, bool disposeSignatureSystem = true}) async {
    final String keyAddress = await buildAddress(keyName: address);
    await secureStorage.delete(key: keyAddress);
    if (disposeSignatureSystem) {
      super.dispose();
    }
  }

  Future<Map<String, String>> extractAllKeys() async {
    final Map<String, String> keys = await secureStorage.readAll();
    keys.removeWhere((key, value) => !key.startsWith(getFullPrefix()));
    return keys;
  }

  /// Dumps all keys stored with the current prefix into a string.
  Future<String> dump() async {
    final keys = await extractAllKeys();

    if (keys.isEmpty) {
      return '';
    }

    return jsonEncode(keys);
  }

  /// Restores keys from a previously dumped string.
  Future<void> restore({required String dump}) async {
    final Map<String, dynamic> decoded = jsonDecode(dump);
    for (var entry in decoded.entries) {
      await secureStorage.write(key: entry.key, value: entry.value);
    }
  }
}
