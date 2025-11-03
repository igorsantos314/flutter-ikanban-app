import 'package:intl/intl.dart';

String convertDateTimeToFormatedDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

DateTime? parseDateOrNull(String input) {
  final s = input.trim();
  final parts = s.split('/');
  if (parts.length != 3) return null;

  final day = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final year = int.tryParse(parts[2]);

  if (day == null || month == null || year == null) return null;

  try {
    final date = DateTime(year, month, day);
    // validação para evitar "overflow" (ex.: 32/01/2020 vira 01/02/2020)
    if (date.year == year && date.month == month && date.day == day) {
      return date;
    }
    return null;
  } catch (_) {
    return null;
  }
}