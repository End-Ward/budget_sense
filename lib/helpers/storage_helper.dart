import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

Future<void> saveExpensesToPrefs(
    List<Expense> expenses, double currentBudget, double totalBudget) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('expenses', Expense.encode(expenses));
  prefs.setDouble('currentBudget', currentBudget);
  prefs.setDouble('totalBudget', totalBudget);
}

Future<Map<String, dynamic>> loadExpensesFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final String expensesString = prefs.getString('expenses') ?? '[]';
  final double currentBudget = prefs.getDouble('currentBudget') ?? 0.0;
  final double totalBudget = prefs.getDouble('totalBudget') ?? 0.0;

  final List<Expense> expenses = Expense.decode(expensesString);

  return {
    'expenses': expenses,
    'currentBudget': currentBudget,
    'totalBudget': totalBudget,
  };
}
