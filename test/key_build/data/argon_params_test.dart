import 'package:flutter_test/flutter_test.dart';
import 'package:infusion_key_manager/core/key_build/data/argon_params.dart';

void main() {
  group('ArgonParams tests', () {
    test('Default ArgonParams should have correct values', () {
      final argonParams = ArgonParams();
      expect(argonParams.memory, 1024 * 64);
      expect(argonParams.parallelism, 4);
      expect(argonParams.iterations, 3);
    });

    test('ArgonParams for derive should have correct values', () {
      final argonParams = ArgonParams.getForDerive();
      expect(argonParams.memory, 1024 * 64);
      expect(argonParams.parallelism, 4);
      expect(argonParams.iterations, 3);
    });

    test('ArgonParams for hash should have correct values', () {
      final argonParams = ArgonParams.getForHashing();
      expect(argonParams.memory, 1024 * 512);
      expect(argonParams.parallelism, 4);
      expect(argonParams.iterations, 3);
    });
  });
}
