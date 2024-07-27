import 'dart:convert';

class Expense {
  String title;
  double amount;
  DateTime date;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
    );
  }

  static String encode(List<Expense> expenses) => json.encode(
        expenses
            .map<Map<String, dynamic>>((expense) => expense.toMap())
            .toList(),
      );

  static List<Expense> decode(String expenses) =>
      (json.decode(expenses) as List<dynamic>)
          .map<Expense>((item) => Expense.fromMap(item))
          .toList();
}
