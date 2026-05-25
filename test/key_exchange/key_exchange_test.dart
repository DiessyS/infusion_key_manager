import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:infusion_key_manager/core/key_exchange/key_exchange.dart';

void main() {
  group('KeyExchange', () {
    late KeyExchange keyExchange;

    setUp(() {
      keyExchange = KeyExchange();
    });

    test('generateKeyPair populates classic and (if not Windows) PQ keys', () async {
      final keyPair = await keyExchange.generateKeyPair();

      expect(keyPair.cPublicKey, isNotEmpty);
      expect(keyPair.cPrivateKey, isNotEmpty);

      if (Platform.isWindows) {
        expect(keyPair.qPublicKey, isEmpty);
      } else {
        expect(keyPair.qPublicKey, isNotEmpty);
        expect(keyPair.qPrivateKey, isNotEmpty);
      }
    });

    test('End-to-End Hybrid Key Exchange: Alice and Bob derive the identical shared secret', () async {
      final bobKeyPair = await keyExchange.generateKeyPair();

      final qPublicKeyToUse = bobKeyPair.qPublicKey ?? Uint8List(0);

      final aliceEncapsulatedData = await keyExchange.encapsulate(
        bobKeyPair.cPublicKey,
        qPublicKeyToUse,
      );

      expect(aliceEncapsulatedData.cEncapsulatedKey, isNotEmpty);
      expect(aliceEncapsulatedData.mixedSharedSecret, isNotEmpty);
      if (!Platform.isWindows) {
        expect(aliceEncapsulatedData.qEncapsulatedKey, isNotEmpty);
      }

      final bobDecapsulatedSecret = await keyExchange.decapsulate(
        bobKeyPair,
        aliceEncapsulatedData,
      );

      expect(
        bobDecapsulatedSecret,
        equals(aliceEncapsulatedData.mixedSharedSecret),
        reason: 'Bob and Alice must derive the exact same hybrid shared secret.',
      );
    });
  });
}
