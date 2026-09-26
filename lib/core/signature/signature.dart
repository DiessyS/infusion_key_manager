import 'package:infusion_key_manager/core/signature/algorithms/ed25519.dart';

class Signature {
  Ed25519? _ed25519;

  Ed25519 get ed25519 => _ed25519 ??= Ed25519();

  void dispose() {
    _ed25519 = null;
  }
}
