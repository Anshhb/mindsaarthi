import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/ai_service.dart';

Future<String> getTodayQuote() async {
  final prefs = await SharedPreferences.getInstance();
  final today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD
  final cachedThought = prefs.getString('daily_thought_$today');

  if (cachedThought != null) {
    return cachedThought;
  }

  try {
    final thought = await AIService.getDailyThought();
    await prefs.setString('daily_thought_$today', thought);
    return thought;
  } catch (e) {
    return "Every day is a new opportunity to grow.";
  }
}

String month(int m) {
  const months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  return months[m - 1];
}

String formatHour(int h) {
  final hour = h % 12 == 0 ? 12 : h % 12;
  return hour.toString();
}

final getTodayQuoteProvider = FutureProvider<String>((ref) => getTodayQuote());

final monthProvider = Provider.family<String, int>((ref, m) => month(m));

final formatHourProvider = Provider.family<String, int>(
  (ref, h) => formatHour(h),
);
