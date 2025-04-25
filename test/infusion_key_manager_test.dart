import 'package:infusion_key_manager/infusion_key_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:typed_data';

void main() {
  group('InfusionKeyManager', () {
    late InfusionKeyManager keyManager;

    setUp(() {
      keyManager = InfusionKeyManager();
    });

    test('should initialize KeyBuild, KeyStore, and KeyCache', () {
      expect(keyManager.keyBuild, isNotNull);
      expect(keyManager.keyStore, isNotNull);
      expect(keyManager.keyCache, isNotNull);
    });

    test('should dispose the signature from keyStore and keyCache', () async {
      FlutterSecureStorage.setMockInitialValues({});

      keyManager.keyStore.signature = Uint8List(2);
      keyManager.keyCache.signature = Uint8List(2);

      await keyManager.dispose();

      expect(keyManager.keyStore.signature, []);
      expect(keyManager.keyCache.signature, []);
    });
  });
}
