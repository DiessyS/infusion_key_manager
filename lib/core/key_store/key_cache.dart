import 'dart:typed_data';

import 'package:infusion_key_manager/core/key_store/core/key_generic.dart';
import 'package:infusion_key_manager/core/key_store/dto/key_data.dart';

class KeyCache extends KeyGeneric {
  KeyCache() : super('cache');

  Future store({
    required KeyData key,
  }) async {
    await genericStore(key: key);
  }

  Future<Uint8List?> read({
    required String cacheIdentifier,
  }) async {
    return await genericRead(address: cacheIdentifier);
  }

  Future<void> invalidate({
    required String cacheIdentifier,
  }) async {
    await genericDispose(
      address: cacheIdentifier,
      disposeSignatureSystem: false,
    );
  }

  Future<void> clearCache() async {
    final List<KeyData> allKeys = await dump();
    for (var key in allKeys) {
      await secureStorage.delete(key: key.address);
    }
  }
}
