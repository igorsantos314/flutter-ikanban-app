import 'dart:developer' as developer;

class DevLog {
  static log({String? identifier, required String message}) {
    developer.log(message, name: identifier ?? "control.flow.igs");
  }
}