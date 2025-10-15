import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infusion_key_manager/core/key_store/core/key_generic.dart';
import 'package:infusion_key_manager/core/key_store/dto/key_data.dart';

void main() {
  group('KeyGeneric Tests', () {
    test('KeyGeneric should be initialized correctly', () {
      final keyGeneric = KeyGeneric('test_prefix');
      expect(keyGeneric, isNotNull);
      expect(keyGeneric.prefix, 'test_prefix');
    });

    test('KeyGeneric should store and read keys correctly', () async {
      FlutterSecureStorage.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();

      final keyGeneric = KeyGeneric('test_prefix')
        ..initializeSignature(Uint8List(2));
      final Uint8List testKey = Uint8List.fromList([1, 2, 3, 4, 5]);
      const String address = 'test_key';
      final KeyData keyData = KeyData(
        key: testKey,
        address: address,
      );

      await keyGeneric.genericStore(key: keyData);
      final Uint8List? retrievedKey =
          await keyGeneric.genericRead(address: address);

      expect(retrievedKey, testKey);
    });

    test('KeyGeneric should dispose keys correctly', () async {
      FlutterSecureStorage.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();

      final keyGeneric = KeyGeneric('test_prefix')
        ..initializeSignature(Uint8List(2));
      final Uint8List testKey = Uint8List.fromList([1, 2, 3, 4, 5]);
      const String address = 'test_key';
      final KeyData keyData = KeyData(
        key: testKey,
        address: address,
      );

      await keyGeneric.genericStore(key: keyData);
      await keyGeneric.genericDispose(
          address: address, disposeSignatureSystem: false);

      final Uint8List? retrievedKey =
          await keyGeneric.genericRead(address: address);

      expect(retrievedKey, isNull);
    });

    test('KeyGeneric should extract all keys correctly', () async {
      FlutterSecureStorage.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();

      final keyGeneric = KeyGeneric('test_prefix')
        ..initializeSignature(Uint8List(2));
      final Uint8List testKey1 = Uint8List.fromList([1, 2, 3, 4, 5]);
      final Uint8List testKey2 = Uint8List.fromList([6, 7, 8, 9, 10]);
      const String address1 = 'test_key1';
      const String address2 = 'test_key2';
      final KeyData keyData1 = KeyData(
        key: testKey1,
        address: address1,
      );
      final KeyData keyData2 = KeyData(
        key: testKey2,
        address: address2,
      );

      await keyGeneric.genericStore(key: keyData1);
      await keyGeneric.genericStore(key: keyData2);

      final Map<String, String> allKeys = await keyGeneric.extractAllKeys();

      expect(allKeys.length, 2);
    });

    test('KeyGeneric should dump and restore keys correctly', () async {
      FlutterSecureStorage.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();

      final keyGeneric = KeyGeneric('test_prefix')
        ..initializeSignature(Uint8List(2));
      final Uint8List testKey1 = Uint8List.fromList([1, 2, 3, 4, 5]);
      final Uint8List testKey2 = Uint8List.fromList([6, 7, 8, 9, 10]);
      const String address1 = 'test_key1';
      const String address2 = 'test_key2';
      final KeyData keyData1 = KeyData(
        key: testKey1,
        address: address1,
      );
      final KeyData keyData2 = KeyData(
        key: testKey2,
        address: address2,
      );

      await keyGeneric.genericStore(key: keyData1);
      await keyGeneric.genericStore(key: keyData2);

      final String dump = await keyGeneric.dump();
      expect(dump.isNotEmpty, true);

      // Clear all keys
      await keyGeneric.genericDispose(
          address: address1, disposeSignatureSystem: false);
      await keyGeneric.genericDispose(
          address: address2, disposeSignatureSystem: false);

      // Restore from dump
      await keyGeneric.restore(dump: dump);

      final Uint8List? restoredKey1 =
          await keyGeneric.genericRead(address: address1);
      final Uint8List? restoredKey2 =
          await keyGeneric.genericRead(address: address2);

      expect(restoredKey1, testKey1);
      expect(restoredKey2, testKey2);
    });
  });
}
