import 'dart:typed_data';

import 'package:cryptography/cryptography.dart' as crypto;
import 'package:infusion_key_manager/core/signature/data/ed25519_key_pair.dart';

class Ed25519 {
  final crypto.Ed25519 _algorithm = crypto.Ed25519();

  Future<Ed25519KeyPair> generateKeyPair() async {
    final keyPair = await _algorithm.newKeyPair();

    return Ed25519KeyPair()
      ..publicKey = Uint8List.fromList((await keyPair.extractPublicKey()).bytes)
      ..privateKey = Uint8List.fromList(await keyPair.extractPrivateKeyBytes());
  }

  Future<Uint8List> sign({
    required Uint8List message,
    required Ed25519KeyPair keyPair,
  }) async {
    final signature = await _algorithm.sign(
      message,
      keyPair: _toSimpleKeyPair(keyPair),
    );
    return Uint8List.fromList(signature.bytes);
  }

  Future<bool> verify({
    required Uint8List message,
    required Uint8List signature,
    required Uint8List publicKey,
  }) {
    return _algorithm.verify(
      message,
      signature: crypto.Signature(
        signature,
        publicKey: crypto.SimplePublicKey(
          publicKey,
          type: crypto.KeyPairType.ed25519,
        ),
      ),
    );
  }

  crypto.SimpleKeyPair _toSimpleKeyPair(Ed25519KeyPair keyPair) {
    return crypto.SimpleKeyPairData(
      keyPair.privateKey,
      publicKey: crypto.SimplePublicKey(
        keyPair.publicKey,
        type: crypto.KeyPairType.ed25519,
      ),
      type: crypto.KeyPairType.ed25519,
    );
  }
}
