import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:infusion_key_manager/core/key_build/data/key_options.dart';

import 'data/key_props.dart';

class KeyBuild {
  Argon2id? _argon2Id;

  /// Argon2id password build
  Future<Uint8List> build({
    required Uint8List secretKey,
    required KeyOptions options,
    required int digestLength,
  }) async {
    _argon2Id = Argon2id(
      memory: options.argonParams.memory,
      parallelism: options.argonParams.parallelism,
      iterations: options.argonParams.iterations,
      hashLength: digestLength,
    );
    final KeyProps props = KeyProps(key: secretKey, salt: options.salt);
    return await compute(_syncBuild, props);
  }

  /// Sha256 password hashing (bad for public available passwords)
  Future<String> buildWithSha256(String password) async {
    final Uint8List passwordBytes = utf8.encode(password);
    final Hash hash = await Sha256().hash(passwordBytes);
    return hash.toString();
  }

  Future<bool> checkAsHash({
    required Uint8List userKey,
    required Uint8List hash,
    required KeyOptions options,
    required int digestLength,
  }) async {
    final Uint8List userHash = await build(
      secretKey: userKey,
      options: options,
      digestLength: digestLength,
    );
    return listEquals(userHash, hash);
  }

  Future<Uint8List> _syncBuild(KeyProps props) async {
    final SecretKey derivation = await _argon2Id!.deriveKey(
      secretKey: SecretKey(props.key),
      nonce: props.salt,
    );
    return Uint8List.fromList(await derivation.extractBytes());
  }

  void dispose() {
    _argon2Id = null;
  }
}
