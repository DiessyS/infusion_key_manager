import 'dart:convert';
import 'dart:typed_data';

import 'core/key_store_core.dart';

class KeyCache extends KeyStoreCore {
  KeyCache() : super(prefix: 'cache__');

  Future store({
    required Uint8List key,
    String cacheIdentifier = '',
  }) async {
    final String address = await buildAddress(keyName: cacheIdentifier);
    await secureStorage.write(key: address, value: base64.encode(key));
  }

  Future<Uint8List?> read({
    String cacheIdentifier = '',
  }) async {
    final String address = await buildAddress(keyName: cacheIdentifier);
    final String? key = await secureStorage.read(key: address);
    return key == null ? null : base64.decode(key);
  }

  Future<void> clearCache() async {
    final Map<String, String> keys = await secureStorage.readAll();
    final String prefix = getFullPrefix();
    final Iterable<String> keysToDelete =
        keys.keys.where((key) => key.startsWith(prefix));

    await Future.wait(
      keysToDelete.map((key) => secureStorage.delete(key: key)),
    );
  }
}
