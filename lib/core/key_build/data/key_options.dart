import 'dart:typed_data';
import 'package:cryptography/helpers.dart';
import 'package:infusion_key_manager/core/key_build/enum/resource_usage_profile.dart';
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

  KeyOptions.byResourceUsageProfile({
    required ResourceUsageProfile profile,
  }) {
    salt = randomBytes(_saltLength);
    argonParams = ArgonParams(
      memory: profile.memory,
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
