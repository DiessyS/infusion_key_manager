import 'dart:typed_data';
import 'package:cryptography/helpers.dart';
import 'package:serializable/serializable.dart';

import 'argon_params.dart';

class KeyOptions extends Serializable {
  Uint8List salt = Uint8List(0);
  final int _saltLength = 16;
  ArgonParams argonParams = ArgonParams.getForDerive();

  KeyOptions();

  KeyOptions.forDerive() {
    salt = randomBytes(_saltLength);
    argonParams = ArgonParams.getForDerive();
  }

  KeyOptions.forHash() {
    salt = randomBytes(_saltLength);
    argonParams = ArgonParams.getForHashing();
  }

  KeyOptions.custom({
    required int memory,
    required int parallelism,
    required int iterations,
  }) {
    salt = randomBytes(_saltLength);
    argonParams = ArgonParams(
      memory: memory,
      parallelism: parallelism,
      iterations: iterations,
    );
  }

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
