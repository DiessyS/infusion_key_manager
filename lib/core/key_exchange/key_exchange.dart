import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:infusion_key_manager/core/key_exchange/data/hybrid_encapsulated_data.dart';
import 'package:infusion_key_manager/core/key_exchange/data/hybrid_key_pair.dart';
import 'package:ml_kem/ml_kem.dart';

/// Hybrid Key Exchange class that combines both classical and post-quantum key exchange algorithms (X25519 and ML-KEM).
class KeyExchange {
  Future<HybridKeyPair> generateKeyPair() async {
    final HybridKeyPair keyPair = HybridKeyPair();

    // Classic
    final algorithm = X25519();
    final classicKeyPair = await algorithm.newKeyPair();
    keyPair.cPublicKey =
        Uint8List.fromList((await classicKeyPair.extractPublicKey()).bytes);
    keyPair.cPrivateKey =
        Uint8List.fromList(await classicKeyPair.extractPrivateKeyBytes());

    // For debugging and testing purposes
    if (Platform.isWindows) {
      return keyPair;
    }

    // Post-Quantum
    final mlKem = MlKem();
    final pqKeyPair = await mlKem.generateKeyPair();
    keyPair.qPublicKey = pqKeyPair.publicKey;
    keyPair.qPrivateKey = pqKeyPair.privateKey;

    return keyPair;
  }

  // encapsulate
  Future<HybridEncapsulatedData> encapsulate(
      Uint8List cPublicKey, Uint8List qPublicKey) async {
    HybridEncapsulatedData encapsulatedData = HybridEncapsulatedData();

    // classic
    final algorithm = X25519();
    final ephemeral = await algorithm.newKeyPair();
    final sharedSecretKey = await algorithm.sharedSecretKey(
      keyPair: ephemeral,
      remotePublicKey: SimplePublicKey(cPublicKey, type: KeyPairType.x25519),
    );

    final classicSharedSecret = await sharedSecretKey.extractBytes();
    encapsulatedData.cEncapsulatedKey =
        Uint8List.fromList((await ephemeral.extractPublicKey()).bytes);

    if (Platform.isWindows) {
      encapsulatedData.mixedSharedSecret =
          Uint8List.fromList(classicSharedSecret);
      return encapsulatedData;
    }

    // post-quantum
    final mlKem = MlKem();
    final pqEncapsulated = await mlKem.encapsulate(qPublicKey);

    encapsulatedData.qEncapsulatedKey = pqEncapsulated.encapsulation;

    final builder = BytesBuilder();
    builder.add(classicSharedSecret);
    builder.add(pqEncapsulated.sharedSecret);
    encapsulatedData.mixedSharedSecret = builder.toBytes();

    return encapsulatedData;
  }

  Future<Uint8List> decapsulate(
      HybridKeyPair myKeyPair, HybridEncapsulatedData encapsulatedData) async {
    // classic
    final algorithm = X25519();
    final myClassicKeyPair = SimpleKeyPairData(
      myKeyPair.cPrivateKey,
      publicKey:
          SimplePublicKey(myKeyPair.cPublicKey, type: KeyPairType.x25519),
      type: KeyPairType.x25519,
    );
    final sharedSecretKey = await algorithm.sharedSecretKey(
      keyPair: myClassicKeyPair,
      remotePublicKey: SimplePublicKey(encapsulatedData.cEncapsulatedKey,
          type: KeyPairType.x25519),
    );
    final classicSharedSecret =
        Uint8List.fromList(await sharedSecretKey.extractBytes());

    if (Platform.isWindows) {
      return classicSharedSecret;
    }

    // post-quantum
    final mlKem = MlKem();
    final pqSharedSecret = await mlKem.decapsulate(
      privateKey: myKeyPair.qPrivateKey,
      encapsulation: encapsulatedData.qEncapsulatedKey,
    );

    final builder = BytesBuilder();
    builder.add(classicSharedSecret);
    builder.add(pqSharedSecret);

    return builder.toBytes();
  }
}
