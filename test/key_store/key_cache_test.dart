import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infusion_key_manager/core/key_store/key_cache.dart';

void main() {
  group('KeyCache Tests', () {
    test('KeyCache should be initialized correctly', () {
      final keyCache = KeyCache();
      expect(keyCache, isNotNull);
    });

    test('KeyCache should store and read keys correctly', () async {
      FlutterSecureStorage.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();

      final keyCache = KeyCache()..initializeSignature(Uint8List(2));
      final Uint8List testKey = Uint8List.fromList([1, 2, 3, 4, 5]);
      const String cacheIdentifier = 'test_key';

      await keyCache.store(key: testKey, cacheIdentifier: cacheIdentifier);
      final Uint8List? retrievedKey =
          await keyCache.read(cacheIdentifier: cacheIdentifier);

      expect(retrievedKey, testKey);
    });

    test('KeyCache should store multiple keys and read them correctly',
        () async {
      FlutterSecureStorage.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();

      final keyCache = KeyCache()..initializeSignature(Uint8List(2));
      final Uint8List testKey1 = Uint8List.fromList([1, 2, 3, 4, 5]);
      final Uint8List testKey2 = Uint8List.fromList([6, 7, 8, 9, 10]);
      const String cacheIdentifier1 = 'test_key_1';
      const String cacheIdentifier2 = 'test_key_2';

      await keyCache.store(key: testKey1, cacheIdentifier: cacheIdentifier1);
      await keyCache.store(key: testKey2, cacheIdentifier: cacheIdentifier2);

      final Uint8List? retrievedKey1 =
          await keyCache.read(cacheIdentifier: cacheIdentifier1);
      final Uint8List? retrievedKey2 =
          await keyCache.read(cacheIdentifier: cacheIdentifier2);

      expect(retrievedKey1, testKey1);
      expect(retrievedKey2, testKey2);
    });

    test('KeyCache should clear cache correctly', () async {
      FlutterSecureStorage.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();

      final keyCache = KeyCache()..initializeSignature(Uint8List(2));
      final Uint8List testKey = Uint8List.fromList([1, 2, 3, 4, 5]);
      const String cacheIdentifier = 'test_key';

      await keyCache.store(key: testKey, cacheIdentifier: cacheIdentifier);
      await keyCache.clearCache();

      final Uint8List? retrievedKey =
          await keyCache.read(cacheIdentifier: cacheIdentifier);

      expect(retrievedKey, null);
    });
  });

  test('KeyCache should clear cache correctly with multiple keys', () async {
    FlutterSecureStorage.setMockInitialValues({});
    WidgetsFlutterBinding.ensureInitialized();

    final keyCache = KeyCache()..initializeSignature(Uint8List(2));
    final Uint8List testKey1 = Uint8List.fromList([1, 2, 3, 4, 5]);
    final Uint8List testKey2 = Uint8List.fromList([6, 7, 8, 9, 10]);
    const String cacheIdentifier1 = 'test_key_1';
    const String cacheIdentifier2 = 'test_key_2';

    await keyCache.store(key: testKey1, cacheIdentifier: cacheIdentifier1);
    await keyCache.store(key: testKey2, cacheIdentifier: cacheIdentifier2);
    await keyCache.clearCache();

    final Uint8List? retrievedKey1 =
        await keyCache.read(cacheIdentifier: cacheIdentifier1);
    final Uint8List? retrievedKey2 =
        await keyCache.read(cacheIdentifier: cacheIdentifier2);

    expect(retrievedKey1, null);
    expect(retrievedKey2, null);
  });

  test('KeyCache should invalidate a specific key', () async {
    FlutterSecureStorage.setMockInitialValues({});
    WidgetsFlutterBinding.ensureInitialized();

    final keyCache = KeyCache()..initializeSignature(Uint8List(2));
    final Uint8List testKey = Uint8List.fromList([1, 2, 3, 4, 5]);
    const String cacheIdentifier = 'test_key';

    await keyCache.store(key: testKey, cacheIdentifier: cacheIdentifier);
    final bool isKeyStored =
        (await keyCache.read(cacheIdentifier: cacheIdentifier)) != null;
    await keyCache.invalidate(cacheIdentifier: cacheIdentifier);

    final Uint8List? retrievedKey =
        await keyCache.read(cacheIdentifier: cacheIdentifier);

    expect(isKeyStored, true,
        reason: 'Key should be stored before invalidation');
    expect(retrievedKey, null);
  });
}
