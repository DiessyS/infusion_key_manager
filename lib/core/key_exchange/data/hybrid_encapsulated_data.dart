import 'dart:convert';
import 'dart:typed_data';

class HybridEncapsulatedData {
  Uint8List cEncapsulatedKey = Uint8List(0);
  Uint8List qEncapsulatedKey = Uint8List(0);
  Uint8List mixedSharedSecret = Uint8List(0);

  HybridEncapsulatedData();

  Uint8List getEncapsulatedKey() {
    final data = {
      'cek': cEncapsulatedKey.cast<int>(),
      'qek': qEncapsulatedKey.cast<int>(),
    };
    return Uint8List.fromList(utf8.encode(json.encode(data)));
  }
}
