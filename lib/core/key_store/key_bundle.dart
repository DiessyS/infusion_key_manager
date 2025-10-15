import 'dart:typed_data';

import 'package:infusion_key_manager/core/key_store/core/key_generic.dart';
import 'package:infusion_key_manager/core/key_store/dto/key_data.dart';

/// The keybundle is designed to store keys independently of the context
class KeyBundle extends KeyGeneric {
  KeyBundle() : super('bundle') {
    // No need to initialize a signature
    // the KeyBundle is not designed to be data bounded
    initializeSignature(Uint8List.fromList([0]));
  }

  Future store({
    required KeyData key,
  }) async {
    await genericStore(key: key);
  }

  Future<Uint8List?> read({
    required String address,
  }) async {
    return await genericRead(address: address);
  }
}
