import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:infusion_key_manager/core/key_build/data/key_props.dart';

class Blake2b {
  Future<Uint8List> build({
    required Uint8List secretKey,
    required Uint8List salt,
    required int digestLength,
    List<int> info = const [],
  }) async {
    final Hmac blake2b = Hmac.blake2b();
    final Hkdf hkdf = Hkdf(
      hmac: blake2b,
      outputLength: digestLength,
    );
    final KeyProps props = KeyProps(key: secretKey, salt: salt);
    final SecretKey derivedKey = await hkdf.deriveKey(
      secretKey: SecretKey(props.key),
      nonce: props.salt,
      info: info,
    );
    return Uint8List.fromList(await derivedKey.extractBytes());
  }

  Future<bool> checkAsHash({
    required Uint8List userKey,
    required Uint8List hash,
    required Uint8List salt,
    required int digestLength,
    List<int> info = const [],
  }) async {
    final Uint8List userHash = await build(
      secretKey: userKey,
      salt: salt,
      digestLength: digestLength,
      info: info,
    );
    return listEquals(userHash, hash);
  }
}
