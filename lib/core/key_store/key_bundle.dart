import 'dart:typed_data';

import 'package:infusion_key_manager/core/key_store/core/key_generic.dart';
import 'package:infusion_key_manager/core/key_store/dto/key_data.dart';

class KeyBundle extends KeyGeneric {
  KeyBundle() : super('bundle');

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
