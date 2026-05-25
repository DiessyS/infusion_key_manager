import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:infusion_key_manager/core/key_build/data/key_options.dart';
import 'package:infusion_key_manager/core/key_build/enum/resource_usage_profile.dart';
import 'package:infusion_key_manager/core/key_build/key_build.dart';

void main() {
  group('KeyBuild Tests', () {
    test('KeyBuild should be instantiated', () {
      final keyBuild = KeyBuild();
      expect(keyBuild, isNotNull);
    });

    test('KeyBuild should build a key (argon2id)', () async {
      final keyBuild = KeyBuild().argon2id;
      final Uint8List secretKey = Uint8List.fromList([1, 2, 3, 4]);
      final KeyOptions options = KeyOptions(
        profile: ResourceUsageProfile.balanced,
      );
      const int digestLength = 32;

      final Uint8List result = await keyBuild.build(
        secretKey: secretKey,
        options: options,
        digestLength: digestLength,
      );

      expect(result, isA<Uint8List>());
    });

    test('KeyBuild should check a hash (argon2id)', () async {
      final keyBuild = KeyBuild().argon2id;
      final Uint8List secret = Uint8List.fromList([1, 2, 3, 4]);
      final Uint8List userKey = Uint8List.fromList([1, 2, 3, 4]);
      final KeyOptions options = KeyOptions(
        profile: ResourceUsageProfile.balanced,
      );
      const int digestLength = 32;

      final Uint8List hash = await keyBuild.build(
        secretKey: secret,
        options: options,
        digestLength: digestLength,
      );

      final bool isEqual = await keyBuild.checkAsHash(
        userKey: userKey,
        hash: hash,
        options: options,
        digestLength: digestLength,
      );

      expect(isEqual, true);
    });
  });

  test('KeyBuild should build a key (blake2b)', () async {
    final keyBuild = KeyBuild().blake2b;
    final Uint8List secretKey = Uint8List.fromList([1, 2, 3, 4]);
    final Uint8List salt = Uint8List.fromList([5, 6, 7, 8]);
    const int digestLength = 32;

    final Uint8List result = await keyBuild.build(
      secretKey: secretKey,
      salt: salt,
      digestLength: digestLength,
    );

    expect(result, isA<Uint8List>());
  });

  test('KeyBuild should check a hash (blake2b)', () async {
    final keyBuild = KeyBuild().blake2b;
    final Uint8List secret = Uint8List.fromList([1, 2, 3, 4]);
    final Uint8List userKey = Uint8List.fromList([1, 2, 3, 4]);
    final Uint8List salt = Uint8List.fromList([5, 6, 7, 8]);
    const int digestLength = 32;

    final Uint8List hash = await keyBuild.build(
      secretKey: secret,
      salt: salt,
      digestLength: digestLength,
    );

    final bool isEqual = await keyBuild.checkAsHash(
      userKey: userKey,
      hash: hash,
      salt: salt,
      digestLength: digestLength,
    );

    expect(isEqual, true);
  });
}
