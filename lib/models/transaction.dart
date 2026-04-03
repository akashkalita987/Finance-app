import 'dart:convert';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final String category;
  final bool isExpense;
  final DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.isExpense,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'amount': amount,
    'category': category,
    'isExpense': isExpense,
    'date': date.toIso8601String(),
  };

  factory Transaction.fromMap(Map<String, dynamic> map) => Transaction(
    id: map['id'],
    title: map['title'],
    amount: map['amount'],
    category: map['category'],
    isExpense: map['isExpense'],
    date: DateTime.parse(map['date']),
  );

  String toJson() => jsonEncode(toMap());
  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(jsonDecode(source));
}