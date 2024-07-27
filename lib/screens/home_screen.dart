import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../widgets/animated_circular_progress_indicator.dart';
import '../helpers/storage_helper.dart';
import '../helpers/budget_manager.dart';
import '../helpers/dialog_manager.dart';
import '../helpers/help_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  ThemeMode themeMode = ThemeMode.light;
  double _currentBudget = 0.0;
  double _totalBudget = 0.0;
  List<Expense> expenses = [];

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  late BudgetManager _budgetManager;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
    HelpManager.showInitialPromptDialog(context); // Show initial prompt dialog
  }

  Future<void> _saveExpenses() async {
    await saveExpensesToPrefs(expenses, _currentBudget, _totalBudget);
  }

  Future<void> _loadExpenses() async {
    final data = await loadExpensesFromPrefs();
    setState(() {
      expenses = data['expenses'];
      _currentBudget = data['currentBudget'];
      _totalBudget = data['totalBudget'];

      _budgetManager = BudgetManager(
        currentBudget: _currentBudget,
        totalBudget: _totalBudget,
        expenses: expenses,
        saveExpenses: () async {
          await _saveExpenses();
          setState(() {
            expenses = expenses;
            _currentBudget = _budgetManager.currentBudget;
            _totalBudget = _budgetManager.totalBudget;
          });
        },
      );
    });
  }

  void toggleTheme() {
    setState(() {
      themeMode =
          themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void setBudget(double newBudget) {
    _budgetManager.setBudget(newBudget);
    _updateStateFromBudgetManager();
  }

  void setTotalBudget(double newTotalBudget) {
    _budgetManager.setTotalBudget(newTotalBudget);
    _updateStateFromBudgetManager();
  }

  void addExpense(String title, double expenseAmount) {
    _budgetManager.addExpense(
      title,
      expenseAmount,
      (errorMessage) {
        _showErrorDialog(context, errorMessage);
      },
    );
    _updateStateFromBudgetManager();
  }

  void addFunds(double additionalFunds) {
    _budgetManager.addFunds(
      additionalFunds,
      (errorMessage) {
        _showErrorDialog(context, errorMessage);
      },
    );
    _updateStateFromBudgetManager();
  }

  void _updateStateFromBudgetManager() {
    setState(() {
      _currentBudget = _budgetManager.currentBudget;
      _totalBudget = _budgetManager.totalBudget;
      expenses = _budgetManager.expenses;
    });
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Warning"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Color appBarColor =
        themeMode == ThemeMode.dark ? Colors.black : Colors.white;
    Color bodyColor =
        themeMode == ThemeMode.dark ? Colors.grey[900]! : Colors.grey[200]!;

    String formattedCurrentBudget =
        NumberFormat("#,##0.00", "en_US").format(_currentBudget);
    String formattedTotalBudget =
        NumberFormat("#,##0.00", "en_US").format(_totalBudget);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBar(
            title: const Text(
              "Budget Tracker",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: appBarColor,
            elevation: 10,
            leading: IconButton(
              icon: Icon(
                themeMode == ThemeMode.dark ? Icons.wb_sunny : Icons.nightlight,
              ),
              onPressed: toggleTheme,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  HelpManager.showHelpDialog(context); // Show the help dialog
                },
              ),
              IconButton(
                icon: const Icon(Icons.wallet),
                onPressed: () {
                  showSetBudgetDialog(
                    context,
                    setTotalBudget,
                    _totalBudget,
                    _saveExpenses,
                    _scaffoldMessengerKey,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.add_circle),
                onPressed: () {
                  showAddFundsDialog(
                    context,
                    addFunds,
                    _saveExpenses,
                    _scaffoldMessengerKey,
                  );
                },
              ),
            ],
          ),
        ),
        body: Container(
          color: bodyColor,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AnimatedCircularProgressIndicator(
                formattedCurrentBudget: formattedCurrentBudget,
                formattedTotalBudget: formattedTotalBudget,
                currentBudget: _currentBudget,
                totalBudget: _totalBudget,
                themeMode: themeMode,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(12.0),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          ' Recent Transactions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        Expanded(child: buildExpenseList(context, expenses)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddExpenseDialog(
              context,
              addExpense,
              _saveExpenses,
              _scaffoldMessengerKey,
            );
          },
          backgroundColor:
              themeMode == ThemeMode.dark ? Colors.grey[700] : Colors.grey[300],
          foregroundColor:
              themeMode == ThemeMode.dark ? Colors.white : Colors.black,
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  // Modified buildExpenseList function
  Widget buildExpenseList(BuildContext context, List<Expense> expenses) {
    // Reverse the order of the expenses list
    List<Expense> reversedExpenses = List.from(expenses.reversed);

    return ListView.builder(
      itemCount: reversedExpenses.length,
      itemBuilder: (context, index) {
        final expense = reversedExpenses[index];
        Color textColor;
        if (expense.title == 'Set Budget' || expense.title == 'Added Funds') {
          textColor = Colors.green;
        } else {
          textColor = Colors.red;
        }
        return ListTile(
          title: Text(
            expense.title,
            style: TextStyle(
                color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            DateFormat('MMM dd, yyyy - hh:mm a')
                .format(expense.date), // Updated format
            style: const TextStyle(
                fontSize: 14.0), // Adjust font size for readability
          ),
          trailing: Text(
            '₱ ${expense.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: textColor,
              fontSize: 15.0, // Adjust font size for amount
              fontWeight: FontWeight.bold, // Make amount text bold
            ),
          ),
        );
      },
    );
  }
}
