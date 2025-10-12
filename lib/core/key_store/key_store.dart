import 'dart:typed_data';

import 'package:infusion_key_manager/core/key_store/core/key_generic.dart';
import 'package:infusion_key_manager/core/key_store/dto/key_data.dart';

class KeyStore extends KeyGeneric {
  final String address = 'master';

  bool _keyReady = false;
  bool get keyReady => _keyReady;

  KeyStore() : super('store');

  Future store({
    required Uint8List key,
  }) async {
    await genericStore(key: KeyData(address: address, key: key));
    _keyReady = true;
  }

  Future<Uint8List?> read() async {
    return await genericRead(address: address);
  }

  @override
  Future<void> dispose() async {
    await genericDispose(address: address);
    _keyReady = false;
  }
}
