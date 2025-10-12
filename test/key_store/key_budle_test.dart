import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infusion_key_manager/core/key_store/dto/key_data.dart';
import 'package:infusion_key_manager/core/key_store/key_bundle.dart';

void main() {
  group('KeyBundle Tests', () {
    test('KeyBundle should be initialized correctly', () {
      final keyBundle = KeyBundle();
      expect(keyBundle, isNotNull);
    });

    test('KeyBundle should store and read keys correctly', () async {
      FlutterSecureStorage.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();

      final keyBundle = KeyBundle()..initializeSignature(Uint8List(2));
      final Uint8List testKey = Uint8List.fromList([1, 2, 3, 4, 5]);
      const String address = 'test_key';
      final KeyData keyData = KeyData(
        key: testKey,
        address: address,
      );

      await keyBundle.store(key: keyData);
      final Uint8List? retrievedKey = await keyBundle.read(address: address);

      expect(retrievedKey, testKey);
    });

    test('KeyBundle should store multiple keys and read them correctly',
        () async {
      FlutterSecureStorage.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();

      final keyBundle = KeyBundle()..initializeSignature(Uint8List(2));
      final Uint8List testKey1 = Uint8List.fromList([1, 2, 3, 4, 5]);
      const String address1 = 'test_key_1';
      final KeyData keyData1 = KeyData(
        key: testKey1,
        address: address1,
      );
      final Uint8List testKey2 = Uint8List.fromList([6, 7, 8, 9, 10]);
      const String address2 = 'test_key_2';
      final KeyData keyData2 = KeyData(
        key: testKey2,
        address: address2,
      );

      await keyBundle.store(key: keyData1);
      await keyBundle.store(key: keyData2);

      final Uint8List? retrievedKey1 = await keyBundle.read(address: address1);
      final Uint8List? retrievedKey2 = await keyBundle.read(address: address2);

      expect(retrievedKey1, testKey1);
      expect(retrievedKey2, testKey2);
    });
  });
}
