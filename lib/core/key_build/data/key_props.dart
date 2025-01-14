import 'dart:typed_data';

class KeyProps {
  final Uint8List key;
  final Uint8List salt;

  KeyProps({
    required this.key,
    required this.salt,
  });
}
