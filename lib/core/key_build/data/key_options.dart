import 'dart:typed_data';
import 'package:serializable/serializable.dart';

import 'argon_params.dart';

class KeyOptions extends Serializable {
  Uint8List salt = Uint8List(0);
  ArgonParams argonParams = ArgonParams.getForDerive();

  KeyOptions();

  @override
  fromJson(Map<String, dynamic> map) {
    salt = Uint8List.fromList(map['s'].cast<int>());
    argonParams = ArgonParams.fromJson(map['a']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      's': salt.cast<int>(),
      'a': argonParams.toJson(),
    };
  }
}
