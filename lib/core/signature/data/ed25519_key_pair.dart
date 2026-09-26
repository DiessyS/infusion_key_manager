import 'dart:typed_data';

import 'package:serializable/serializable.dart';

class Ed25519KeyPair extends Serializable {
  Uint8List publicKey = Uint8List(0);
  Uint8List privateKey = Uint8List(0);

  @override
  fromJson(Map<String, dynamic> map) {
    publicKey = Uint8List.fromList(map['pbk'].cast<int>());
    privateKey = Uint8List.fromList(map['pvk'].cast<int>());
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'pbk': publicKey.cast<int>(),
      'pvk': privateKey.cast<int>(),
    };
  }

  void dispose() {
    publicKey.fillRange(0, publicKey.length, 0);
    privateKey.fillRange(0, privateKey.length, 0);
  }
}
