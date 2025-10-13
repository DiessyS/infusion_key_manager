library infusion_key_manager;

import 'dart:typed_data';

import 'package:infusion_key_manager/core/key_build/key_build.dart';
import 'package:infusion_key_manager/core/key_store/key_bundle.dart';
import 'package:infusion_key_manager/core/key_store/key_cache.dart';
import 'package:infusion_key_manager/core/key_store/key_store.dart';

class InfusionKeyManager {
  KeyBuild? _keyBuild;
  KeyStore? _keyStore;
  KeyCache? _keyCache;
  KeyBundle? _keyBundle;

  /// Argonid2 Wrapper for key derivation and equality check
  KeyBuild get keyBuild => _keyBuild ??= KeyBuild();

  /// Securely stores a master key (one) on secure storage
  KeyStore get keyStore => _keyStore ??= KeyStore();

  /// Securely caches derived keys on secure storage
  KeyCache get keyCache => _keyCache ??= KeyCache();

  /// Securely stores multiple keys on secure storage
  KeyBundle get keyBundle => _keyBundle ??= KeyBundle();

  InfusionKeyManager();

  void initializeSignature(Uint8List signature) {
    keyStore.initializeSignature(signature);
    keyCache.initializeSignature(signature);
  }

  Future<void> dispose() async {
    if (_keyStore != null) await _keyStore!.dispose();
    _keyCache?.dispose();
    _keyBundle?.dispose();
    _keyBuild = null;
    _keyStore = null;
    _keyCache = null;
    _keyBundle = null;
  }
}
