import 'dart:typed_data';

import 'package:serializable/serializable.dart';

/// The HybridKeyPair is designed to store both the quantum and classical keys<br>
/// q stands for quantum-resistant key<br>
/// c stands for classical key<br>
class HybridKeyPair extends Serializable {
  Uint8List qPublicKey = Uint8List(0);
  Uint8List qPrivateKey = Uint8List(0);
  Uint8List cPublicKey = Uint8List(0);
  Uint8List cPrivateKey = Uint8List(0);

  HybridKeyPair();

  @override
  fromJson(Map<String, dynamic> map) {
    qPublicKey = Uint8List.fromList(map['qpbk'].cast<int>());
    qPrivateKey = Uint8List.fromList(map['qpvk'].cast<int>());
    cPublicKey = Uint8List.fromList(map['cpbk'].cast<int>());
    cPrivateKey = Uint8List.fromList(map['cpvk'].cast<int>());
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'qpbk': qPublicKey.cast<int>(),
      'qpvk': qPrivateKey.cast<int>(),
      'cpbk': cPublicKey.cast<int>(),
      'cpvk': cPrivateKey.cast<int>(),
    };
  }

  dispose() {
    qPublicKey.fillRange(0, qPublicKey.length, 0);
    qPrivateKey.fillRange(0, qPrivateKey.length, 0);
    cPublicKey.fillRange(0, cPublicKey.length, 0);
    cPrivateKey.fillRange(0, cPrivateKey.length, 0);
  }

  bool isMissingPostQuantumKey() {
    return qPublicKey.isEmpty || qPrivateKey.isEmpty;
  }
}
