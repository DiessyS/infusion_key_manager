import 'package:infusion_key_manager/core/key_build/algorithms/argon2id.dart';
import 'package:infusion_key_manager/core/key_build/algorithms/blake2b.dart';

class KeyBuild {
  Argon2id? _argon2id;
  Blake2b? _blake2b;

  /// Argonid2 Wrapper for key derivation and equality check
  Argon2id get argon2id => _argon2id ??= Argon2id();

  /// Blake2b Wrapper for hashing and equality check
  Blake2b get blake2b => _blake2b ??= Blake2b();

  KeyBuild();

  void dispose() {
    _argon2id = null;
    _blake2b = null;
  }
}
