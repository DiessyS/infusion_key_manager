import 'package:flutter_test/flutter_test.dart';
import 'package:infusion_key_manager/core/key_build/data/key_options.dart';

void main() {
  group('KeyOptions Tests', () {
    test('Default KeyOptions should have correct values', () {
      final keyOptions = KeyOptions();
      expect(keyOptions.salt.length, 0);
      expect(keyOptions.argonParams.memory, 1024 * 64);
      expect(keyOptions.argonParams.parallelism, 4);
      expect(keyOptions.argonParams.iterations, 3);
    });

    test('KeyOptions for derive should have correct values', () {
      final keyOptions = KeyOptions.forDerive();
      expect(keyOptions.salt.length, 16);
      expect(keyOptions.argonParams.memory, 1024 * 64);
      expect(keyOptions.argonParams.parallelism, 4);
      expect(keyOptions.argonParams.iterations, 3);
    });

    test('KeyOptions for hash should have correct values', () {
      final keyOptions = KeyOptions.forHash();
      expect(keyOptions.salt.length, 16);
      expect(keyOptions.argonParams.memory, 1024 * 512);
      expect(keyOptions.argonParams.parallelism, 4);
      expect(keyOptions.argonParams.iterations, 3);
    });
  });
}
