library infusion_key_manager;

import 'package:infusion_key_manager/core/key_build/key_build.dart';
import 'package:infusion_key_manager/core/key_store/key_cache.dart';
import 'package:infusion_key_manager/core/key_store/key_store.dart';

class InfusionKeyManager {
  final KeyBuild _keyBuild;
  final KeyStore _keyStore;
  final KeyCache _keyCache;

  KeyBuild get keyBuild => _keyBuild;
  KeyStore get keyStore => _keyStore;
  KeyCache get keyCache => _keyCache;

  InfusionKeyManager()
      : _keyBuild = KeyBuild(),
        _keyStore = KeyStore(),
        _keyCache = KeyCache();

  Future<void> dispose() async {
    await _keyStore.dispose();
    _keyCache.dispose();
  }
}
