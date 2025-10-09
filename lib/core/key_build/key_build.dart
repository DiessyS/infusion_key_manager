import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:infusion_key_manager/core/key_build/data/key_options.dart';

import 'data/key_props.dart';

class KeyBuild {
  Future<Uint8List> build({
    required Uint8List secretKey,
    required KeyOptions options,
    required int digestLength,
    List<int> pepper = const [],
  }) async {
    final Argon2id argon2Id = Argon2id(
      memory: options.argonParams.memory,
      parallelism: options.argonParams.parallelism,
      iterations: options.argonParams.iterations,
      hashLength: digestLength,
    );
    final KeyProps props = KeyProps(key: secretKey, salt: options.salt);
    final SecretKey derivation = await argon2Id.deriveKey(
      secretKey: SecretKey(props.key),
      nonce: props.salt,
      optionalSecret: pepper,
    );
    return Uint8List.fromList(await derivation.extractBytes());
  }

  Future<bool> checkAsHash({
    required Uint8List userKey,
    required Uint8List hash,
    required KeyOptions options,
    required int digestLength,
    List<int> pepper = const [],
  }) async {
    final Uint8List userHash = await build(
      secretKey: userKey,
      options: options,
      digestLength: digestLength,
      pepper: pepper,
    );
    return listEquals(userHash, hash);
  }
}
