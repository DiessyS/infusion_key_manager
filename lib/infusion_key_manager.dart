library infusion_key_manager;

import 'dart:typed_data';

import 'package:infusion_key_manager/core/key_build/key_build.dart';
import 'package:infusion_key_manager/core/key_exchange/key_exchange.dart';
import 'package:infusion_key_manager/core/key_store/key_bundle.dart';
import 'package:infusion_key_manager/core/key_store/key_store.dart';
import 'package:infusion_key_manager/core/signature/signature.dart';

class InfusionKeyManager {
  KeyBuild? _keyBuild;
  KeyExchange? _keyExchange;
  KeyStore? _keyStore;
  KeyBundle? _keyBundle;
  Signature? _signature;

  /// Argonid2 Wrapper for key derivation and equality check
  KeyBuild get keyBuild => _keyBuild ??= KeyBuild();

  /// Hibrid key exchange protocol for secure key exchange between parties
  KeyExchange get keyExchange => _keyExchange ??= KeyExchange();

  /// Securely stores a master key (one) on secure storage
  KeyStore get keyStore => _keyStore ??= KeyStore();

  /// Securely stores multiple keys on secure storage
  KeyBundle get keyBundle => _keyBundle ??= KeyBundle();

  /// Ed25519 digital signature operations
  Signature get signature => _signature ??= Signature();

  InfusionKeyManager();

  void initializeSignature(Uint8List signature) {
    keyStore.initializeSignature(signature);
  }

  Future<void> dispose() async {
    await _keyStore?.dispose();
    await _keyBundle?.dispose();
    _signature?.dispose();
    _keyBuild = null;
    _keyExchange = null;
    _keyStore = null;
    _keyBundle = null;
    _signature = null;
  }
}
