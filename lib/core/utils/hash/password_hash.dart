import 'dart:convert';

import 'package:crypto/crypto.dart';

String generatePasswordHash(String password) {
  final bytes = utf8.encode(password);
  return sha256.convert(bytes).toString();
}
