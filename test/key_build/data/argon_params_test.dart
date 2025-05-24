import 'package:flutter_test/flutter_test.dart';
import 'package:infusion_key_manager/core/key_build/data/argon_params.dart';
import 'package:infusion_key_manager/core/key_build/enum/resource_usage_profile.dart';

void main() {
  group('ArgonParams tests', () {
    test('Default ArgonParams should have correct values (minimal)', () {
      const ResourceUsageProfile profile = ResourceUsageProfile.balanced;
      final argonParams = ArgonParams(
        memory: profile.memory,
        parallelism: profile.parallelism,
        iterations: profile.iteration,
      );
      expect(argonParams.memory, profile.memory);
      expect(argonParams.parallelism, profile.parallelism);
      expect(argonParams.iterations, profile.iteration);
    });

    test('ArgonParams should be serializable', () {
      const ResourceUsageProfile profile = ResourceUsageProfile.balanced;
      final argonParams = ArgonParams(
        memory: profile.memory,
        parallelism: profile.parallelism,
        iterations: profile.iteration,
      );
      final Map<String, dynamic> json = argonParams.toJson();
      final ArgonParams fromJson = ArgonParams.fromJson(json);
      expect(fromJson.memory, argonParams.memory);
      expect(fromJson.parallelism, argonParams.parallelism);
      expect(fromJson.iterations, argonParams.iterations);
    });

    test('ArgonParams should have correct values from JSON', () {
      const ResourceUsageProfile profile = ResourceUsageProfile.balanced;
      final Map<String, dynamic> json = {
        'm': profile.memory,
        'p': profile.parallelism,
        'i': profile.iteration,
      };
      final argonParams = ArgonParams.fromJson(json);
      expect(argonParams.memory, profile.memory);
      expect(argonParams.parallelism, profile.parallelism);
      expect(argonParams.iterations, profile.iteration);
    });
  });
}
