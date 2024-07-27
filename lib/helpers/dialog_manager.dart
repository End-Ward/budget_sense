import 'package:flutter/material.dart';

void showSetBudgetDialog(
  BuildContext context,
  Function(double) onBudgetSet,
  double currentBudget,
  Function() onSaveExpenses,
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
) {
  TextEditingController budgetController = TextEditingController();
  bool showError = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Set Budget"),
            content: TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter budget amount",
                errorText: showError ? "Please enter a valid number" : null,
              ),
              onChanged: (value) {
                setState(() {
                  showError = false;
                });
              },
            ),
            actions: [
              ElevatedButton(
                child: const Text("Set"),
                onPressed: () {
                  String budgetText = budgetController.text.trim();
                  if (budgetText.isNotEmpty &&
                      double.tryParse(budgetText) != null) {
                    double tempTotalBudget = double.parse(budgetText);
                    if (tempTotalBudget >= 0) {
                      if (currentBudget > 0) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Confirm Setting Budget"),
                              content: const Text(
                                "Setting a new budget will clear past transactions. Are you sure you want to proceed?",
                              ),
                              actions: [
                                TextButton(
                                  child: const Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ElevatedButton(
                                  child: const Text("Confirm"),
                                  onPressed: () {
                                    onBudgetSet(tempTotalBudget);
                                    onSaveExpenses();
                                    Navigator.of(context)
                                        .pop(); // Close confirmation dialog
                                    Navigator.of(context)
                                        .pop(); // Close original dialog

                                    scaffoldMessengerKey.currentState!
                                        .showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Budget set successfully'),
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        onBudgetSet(tempTotalBudget);
                        onSaveExpenses();
                        Navigator.of(context).pop();

                        scaffoldMessengerKey.currentState!.showSnackBar(
                          const SnackBar(
                            content: Text('Budget set successfully'),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } else {
                      setState(() {
                        showError = true;
                      });
                    }
                  } else {
                    setState(() {
                      showError = true;
                    });
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}

void showAddExpenseDialog(
  BuildContext context,
  Function(String, double) onExpenseAdd,
  Function() onSaveExpenses,
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
) {
  TextEditingController titleController = TextEditingController();
  TextEditingController expenseController = TextEditingController();
  bool showError = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Add Expense"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration:
                      const InputDecoration(labelText: "Enter expense title"),
                ),
                TextField(
                  controller: expenseController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Enter expense amount",
                    errorText: showError ? "Please enter a valid number" : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      showError = false;
                    });
                  },
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                child: const Text("Add"),
                onPressed: () {
                  String titleText = titleController.text.trim();
                  String expenseText = expenseController.text.trim();

                  if (titleText.isNotEmpty && expenseText.isNotEmpty) {
                    double expenseAmount = double.tryParse(expenseText) ?? 0.0;
                    if (expenseAmount > 0) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Confirm Add Expense"),
                            content: const Text(
                              "Are you sure you want to add this expense?",
                            ),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                child: const Text("Add"),
                                onPressed: () {
                                  onExpenseAdd(titleText, expenseAmount);
                                  onSaveExpenses();
                                  Navigator.of(context)
                                      .pop(); // Close confirmation dialog
                                  Navigator.of(context)
                                      .pop(); // Close original dialog

                                  scaffoldMessengerKey.currentState!
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text('New Expense added'),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      setState(() {
                        showError = true;
                      });
                    }
                  } else {
                    setState(() {
                      showError = true;
                    });
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}

void showAddFundsDialog(
  BuildContext context,
  Function(double) onFundsAdd,
  Function() onSaveExpenses,
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
) {
  TextEditingController fundsController = TextEditingController();
  bool showError = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Add Funds"),
            content: TextField(
              controller: fundsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter amount to add",
                errorText: showError ? "Please enter a valid number" : null,
              ),
              onChanged: (value) {
                setState(() {
                  showError = false;
                });
              },
            ),
            actions: [
              ElevatedButton(
                child: const Text("Add"),
                onPressed: () {
                  String fundsText = fundsController.text.trim();
                  if (fundsText.isNotEmpty &&
                      double.tryParse(fundsText) != null) {
                    double additionalFunds = double.parse(fundsText);
                    if (additionalFunds > 0) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Confirm Add Funds"),
                            content: const Text(
                              "Are you sure you want to add these funds?",
                            ),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                child: const Text("Add"),
                                onPressed: () {
                                  onFundsAdd(additionalFunds);
                                  onSaveExpenses();
                                  Navigator.of(context)
                                      .pop(); // Close confirmation dialog
                                  Navigator.of(context)
                                      .pop(); // Close original dialog

                                  scaffoldMessengerKey.currentState!
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text('Funds added successfully'),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      setState(() {
                        showError = true;
                      });
                    }
                  } else {
                    setState(() {
                      showError = true;
                    });
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}
