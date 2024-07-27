import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelpManager {
  static Future<void> showInitialPromptDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool dontShowAgain = prefs.getBool('dontShowAgain') ?? false;

    if (!dontShowAgain) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Welcome to Budget Tracker!'),
              content: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Here is how you can use the app:'),
                      const SizedBox(height: 10),
                      const Text('1. Set your budget and track expenses.'),
                      const Text('2. Add funds and manage your expenses.'),
                      const Text('3. Toggle between light and dark modes.'),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: dontShowAgain,
                            onChanged: (bool? value) async {
                              setState(() {
                                dontShowAgain = value ?? false;
                              });
                              await prefs.setBool(
                                  'dontShowAgain', dontShowAgain);
                            },
                          ),
                          const Text('Don\'t show this again'),
                        ],
                      ),
                    ],
                  );
                },
              ),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    prefs.setBool('hasSeenPrompt', true);
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }

  static Future<void> showHelpDialog(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Help Information'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Here is how you can use the app:'),
                SizedBox(height: 10),
                Text('1. Set your budget and track expenses.'),
                Text('2. Add funds and manage your expenses.'),
                Text('3. Toggle between light and dark modes.'),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
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
}
