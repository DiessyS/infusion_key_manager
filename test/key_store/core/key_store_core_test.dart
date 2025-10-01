import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:infusion_key_manager/core/key_store/core/key_store_core.dart';

void main() {
  group('KeyStoreCore Tests', () {
    test('KeyStoreCore should initialize with correct prefix', () {
      final keyStoreCore = KeyStoreCore(prefix: 'test_prefix');
      expect(keyStoreCore.prefix, 'test_prefix');
    });

    test('KeyStoreCore should build address correctly', () async {
      final keyStoreCore = KeyStoreCore(prefix: 'test_prefix');
      keyStoreCore.initializeSignature(Uint8List.fromList([1, 2, 3, 4, 5]));
      final String address = await keyStoreCore.buildAddress(
        keyName: 'test_key',
      );
      expect(
        address.startsWith('key_store_test_prefix_'),
        true,
      );
    });

    test('KeyStoreCore should throw exception if signature is not initialized',
        () async {
      final keyStoreCore = KeyStoreCore(prefix: 'test_prefix');
      expect(
        () => keyStoreCore.buildAddress(keyName: 'test_key'),
        throwsA(isA<Exception>()),
      );
    });

    test('KeyStoreCore should return correct full prefix', () {
      final keyStoreCore = KeyStoreCore(prefix: 'test_prefix');
      final String fullPrefix = keyStoreCore.getFullPrefix();
      expect(fullPrefix, 'key_store_test_prefix_');
    });

    test('KeyStoreCore should dispose correctly', () async {
      final keyStoreCore = KeyStoreCore(prefix: 'test_prefix');
      keyStoreCore.initializeSignature(Uint8List.fromList([1, 2, 3, 4, 5]));
      await keyStoreCore.dispose();
      expect(keyStoreCore.hasSignature(), false);
    });
  });
}
