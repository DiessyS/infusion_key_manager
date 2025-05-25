import 'package:flutter_test/flutter_test.dart';
import 'package:infusion_key_manager/core/key_build/data/key_options.dart';
import 'package:infusion_key_manager/core/key_build/enum/resource_usage_profile.dart';

void main() {
  group('KeyOptions Tests', () {
    test('Default KeyOptions should have correct values (minimal)', () {
      final keyOptions = KeyOptions(profile: ResourceUsageProfile.minimal);
      expect(keyOptions.salt.length, 16);
      expect(
        keyOptions.argonParams.memory,
        ResourceUsageProfile.minimal.memory,
      );
      expect(
        keyOptions.argonParams.parallelism,
        ResourceUsageProfile.minimal.parallelism,
      );
      expect(
        keyOptions.argonParams.iterations,
        ResourceUsageProfile.minimal.iteration,
      );
    });

    test('Default KeyOptions should have correct values (balanced)', () {
      final keyOptions = KeyOptions(profile: ResourceUsageProfile.balanced);
      expect(keyOptions.salt.length, 16);
      expect(
        keyOptions.argonParams.memory,
        ResourceUsageProfile.balanced.memory,
      );
      expect(
        keyOptions.argonParams.parallelism,
        ResourceUsageProfile.balanced.parallelism,
      );
      expect(
        keyOptions.argonParams.iterations,
        ResourceUsageProfile.balanced.iteration,
      );
    });

    test('Default KeyOptions should have correct values (high)', () {
      final keyOptions = KeyOptions(profile: ResourceUsageProfile.high);
      expect(keyOptions.salt.length, 16);
      expect(
        keyOptions.argonParams.memory,
        ResourceUsageProfile.high.memory,
      );
      expect(
        keyOptions.argonParams.parallelism,
        ResourceUsageProfile.high.parallelism,
      );
      expect(
        keyOptions.argonParams.iterations,
        ResourceUsageProfile.high.iteration,
      );
    });

    test('Default KeyOptions should have correct values (ultra)', () {
      final keyOptions = KeyOptions(profile: ResourceUsageProfile.ultra);
      expect(keyOptions.salt.length, 16);
      expect(
        keyOptions.argonParams.memory,
        ResourceUsageProfile.ultra.memory,
      );
      expect(
        keyOptions.argonParams.parallelism,
        ResourceUsageProfile.ultra.parallelism,
      );
      expect(
        keyOptions.argonParams.iterations,
        ResourceUsageProfile.ultra.iteration,
      );
    });
  });
}
