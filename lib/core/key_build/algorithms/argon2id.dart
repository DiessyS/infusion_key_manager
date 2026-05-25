import 'package:cryptography/cryptography.dart' as crypto;
import 'package:flutter/foundation.dart';
import 'package:infusion_key_manager/core/key_build/data/key_options.dart';
import 'package:infusion_key_manager/core/key_build/data/key_props.dart';

class Argon2id {
  Future<Uint8List> build({
    required Uint8List secretKey,
    required KeyOptions options,
    required int digestLength,
    List<int> pepper = const [],
  }) async {
    final crypto.Argon2id argon2Id = crypto.Argon2id(
      memory: options.argonParams.memory,
      parallelism: options.argonParams.parallelism,
      iterations: options.argonParams.iterations,
      hashLength: digestLength,
    );
    final KeyProps props = KeyProps(key: secretKey, salt: options.salt);
    final crypto.SecretKey derivation = await argon2Id.deriveKey(
      secretKey: crypto.SecretKey(props.key),
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
