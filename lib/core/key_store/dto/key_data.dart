import 'dart:typed_data';

class KeyData {
  final String address;
  final Uint8List key;

  KeyData({
    required this.address,
    required this.key,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'key': key,
    };
  }

  factory KeyData.fromJson(Map<String, dynamic> json) {
    return KeyData(
      address: json['address'],
      key: json['key'],
    );
  }
}
