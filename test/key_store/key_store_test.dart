import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infusion_key_manager/core/key_store/key_store.dart';

void main() {
  group('KeyStore Tests', () {
    test('KeyStore should be initialized correctly', () {
      final keyStore = KeyStore();
      final isKeyReady = keyStore.keyReady;
      expect(isKeyReady, false);
    });

    test('KeyStore should store and read keys correctly', () async {
      FlutterSecureStorage.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();

      final keyStore = KeyStore()..initializeSignature(Uint8List(2));
      final Uint8List testKey = Uint8List.fromList([1, 2, 3, 4, 5]);
      const String customAddress = 'test_key';

      await keyStore.store(key: testKey, customAddress: customAddress);
      final Uint8List? retrievedKey =
          await keyStore.read(customAddress: customAddress);

      expect(retrievedKey, testKey);
    });

    test('KeyStore should dispose correctly', () async {
      FlutterSecureStorage.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();

      final keyStore = KeyStore()..initializeSignature(Uint8List(2));
      final Uint8List testKey = Uint8List.fromList([1, 2, 3, 4, 5]);
      const String customAddress = 'test_key';

      await keyStore.store(key: testKey, customAddress: customAddress);
      await keyStore.dispose();

      expect(
        () => keyStore.read(customAddress: customAddress),
        throwsA(
          isA<Exception>(),
        ),
      );
    });
  });
}
