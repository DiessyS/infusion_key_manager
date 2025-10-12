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

    test('KeyGeneric dump should return all stored keys with prefix', () async {
      FlutterSecureStorage.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();

      final keyGeneric = KeyGeneric('test_prefix')
        ..initializeSignature(Uint8List(2));

      final Uint8List testKey1 = Uint8List.fromList([1, 2, 3]);
      final Uint8List testKey2 = Uint8List.fromList([4, 5, 6]);
      final KeyData keyData1 = KeyData(
        key: testKey1,
        address: 'key1',
      );
      final KeyData keyData2 = KeyData(
        key: testKey2,
        address: 'key2',
      );

      await keyGeneric.genericStore(key: keyData1);
      await keyGeneric.genericStore(key: keyData2);

      final List<KeyData> allKeys = await keyGeneric.dump();

      expect(allKeys.length, 2);
      expect(listEquals(allKeys[0].key, testKey1), true);
      expect(listEquals(allKeys[1].key, testKey2), true);
    });
  });
}
