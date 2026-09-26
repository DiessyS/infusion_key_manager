import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:infusion_key_manager/core/signature/data/ed25519_key_pair.dart';
import 'package:infusion_key_manager/core/signature/signature.dart';

void main() {
  group('Signature', () {
    test('signs and verifies a message with Ed25519', () async {
      final ed25519 = Signature().ed25519;
      final keyPair = await ed25519.generateKeyPair();
      final message = Uint8List.fromList('message'.codeUnits);

      final signed = await ed25519.sign(
        message: message,
        keyPair: keyPair,
      );

      expect(signed, hasLength(64));
      expect(
        await ed25519.verify(
          message: message,
          signature: signed,
          publicKey: keyPair.publicKey,
        ),
        isTrue,
      );
      expect(
        await ed25519.verify(
          message: Uint8List.fromList('different message'.codeUnits),
          signature: signed,
          publicKey: keyPair.publicKey,
        ),
        isFalse,
      );
    });

    test('serializes and restores an Ed25519 key pair', () async {
      final keyPair = await Signature().ed25519.generateKeyPair();
      final restored = Ed25519KeyPair()..fromJson(keyPair.toJson());

      expect(restored.publicKey, keyPair.publicKey);
      expect(restored.privateKey, keyPair.privateKey);
    });
  });
}
