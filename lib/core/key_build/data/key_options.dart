import 'dart:typed_data';
import 'package:cryptography/helpers.dart';
import 'package:infusion_key_manager/core/key_build/enum/resource_usage_profile.dart';
import 'package:serializable/serializable.dart';

import 'argon_params.dart';

class KeyOptions extends Serializable {
  Uint8List salt = Uint8List(0);
  final int _saltLength = 16;
  late final ArgonParams argonParams;

  KeyOptions({
    required ResourceUsageProfile profile,
    bool memoryReinforcement = false,
  }) {
    const int memoryReinforcementFactor = 8;
    final int memory = memoryReinforcement
        ? profile.memory * memoryReinforcementFactor
        : profile.memory;

    salt = randomBytes(_saltLength);
    argonParams = ArgonParams(
      memory: memory,
      parallelism: profile.parallelism,
      iterations: profile.iteration,
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
