import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';

class StorageService {
  static const _key = 'transactions';

  static Future<List<Transaction>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data.map((e) => Transaction.fromJson(e)).toList();
  }

  static Future<void> saveTransactions(List<Transaction> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, list.map((e) => e.toJson()).toList());
  }
}