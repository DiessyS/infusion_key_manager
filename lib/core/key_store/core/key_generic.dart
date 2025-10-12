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

  /// Dumps all keys stored with the current prefix.
  /// Returns a list of KeyData objects containing the address and key.
  /// The address (encoded) is the full key used in secure storage.
  Future<List<KeyData>> dump() async {
    final Map<String, String> keys = await secureStorage.readAll();

    if (keys.isEmpty) {
      return [];
    }

    final String prefix = getFullPrefix();
    final List<KeyData> keyDataList = keys.entries
        .where(
          (entry) => entry.key.startsWith(prefix),
        )
        .map(
          (entry) => KeyData(
            address: entry.key,
            key: base64.decode(entry.value),
          ),
        )
        .toList();

    return keyDataList;
  }
}
