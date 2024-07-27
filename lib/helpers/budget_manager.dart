import '../models/expense.dart';

class BudgetManager {
  double currentBudget;
  double totalBudget;
  List<Expense> expenses;
  Future<void> Function() saveExpenses;

  BudgetManager({
    required this.currentBudget,
    required this.totalBudget,
    required this.expenses,
    required this.saveExpenses,
  });

  void setBudget(double newBudget) {
    double expenseAmount = currentBudget - newBudget;
    currentBudget = newBudget;
    if (currentBudget < 0) {
      currentBudget = 0;
    }
    expenses.add(Expense(
      title: 'Set Budget',
      amount: -expenseAmount,
      date: DateTime.now(),
    ));
    saveExpenses();
  }

  void setTotalBudget(double newTotalBudget) {
    if (totalBudget > 0) {
      currentBudget = 0.0;
      expenses.clear();
    }

    totalBudget = newTotalBudget;

    if (currentBudget == 0.0) {
      currentBudget = newTotalBudget;
    }

    expenses.add(Expense(
      title: 'Set Budget',
      amount: newTotalBudget,
      date: DateTime.now(),
    ));

    saveExpenses();
  }

  void addExpense(
      String title, double expenseAmount, Function(String) showError) {
    if (currentBudget <= 0) {
      showError(
          "You can't add an expense without setting a new budget or adding more funds!");
      return;
    }

    if (expenseAmount > currentBudget) {
      showError(
          "\tYou have added more than the remaining of your current balance! \n\n\tPlease add more funds to your Tracker.");
      return;
    }

    currentBudget -= expenseAmount;
    if (currentBudget < 0) {
      currentBudget = 0;
    }
    expenses.add(Expense(
      title: title,
      amount: expenseAmount,
      date: DateTime.now(),
    ));
    if (currentBudget == 0) {
      showError("Budget all spent! Please set a new budget or add funds!");
    }
    saveExpenses();
  }

  void addFunds(double additionalFunds, Function(String) showError) {
    if (totalBudget <= 0) {
      showError(
          "Error! No Budget set! Please set a budget before adding funds!");
      return;
    }

    currentBudget += additionalFunds;

    if (currentBudget > totalBudget) {
      totalBudget = currentBudget;
    }

    expenses.add(Expense(
      title: 'Added Funds',
      amount: additionalFunds,
      date: DateTime.now(),
    ));

    saveExpenses();
  }
}
