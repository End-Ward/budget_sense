import 'package:flutter/material.dart';

class AnimatedCircularProgressIndicator extends StatefulWidget {
  final String formattedCurrentBudget;
  final String formattedTotalBudget;
  final double currentBudget;
  final double totalBudget;
  final ThemeMode themeMode;

  const AnimatedCircularProgressIndicator({
    super.key,
    required this.formattedCurrentBudget,
    required this.formattedTotalBudget,
    required this.currentBudget,
    required this.totalBudget,
    required this.themeMode,
  });

  @override
  _AnimatedCircularProgressIndicatorState createState() =>
      _AnimatedCircularProgressIndicatorState();
}

class _AnimatedCircularProgressIndicatorState
    extends State<AnimatedCircularProgressIndicator>
    with TickerProviderStateMixin {
  late AnimationController _currentBudgetController;
  late Animation<double> _currentBudgetAnimation;

  @override
  void initState() {
    super.initState();

    _currentBudgetController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _currentBudgetAnimation = Tween<double>(begin: 0, end: widget.currentBudget)
        .animate(_currentBudgetController);

    // Start the animations
    _currentBudgetController.forward();
  }

  @override
  void didUpdateWidget(AnimatedCircularProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentBudget != oldWidget.currentBudget) {
      _currentBudgetAnimation = Tween<double>(
              begin: oldWidget.currentBudget, end: widget.currentBudget)
          .animate(_currentBudgetController);
      _currentBudgetController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _currentBudgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _currentBudgetController,
      builder: (context, child) {
        double progress = widget.totalBudget > 0
            ? (_currentBudgetAnimation.value / widget.totalBudget)
            : 0.0;

        Color progressColor = Colors.red;
        if (progress >= 0.25 && progress <= 0.60) {
          progressColor = Colors.yellow;
        } else if (progress > 0.60 && progress <= 1.0) {
          progressColor = Colors.green;
        }

        return Padding(
          padding: const EdgeInsets.only(top: 30.0), // Add top padding here
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: CircularProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      strokeWidth: 20.0,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "₱ ${_currentBudgetAnimation.value.toStringAsFixed(2)}", // Display formatted current budget
                        style: const TextStyle(
                            fontSize: 27.0, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Balance",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        "₱ ${widget.totalBudget.toStringAsFixed(2)}", // Display formatted total budget
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
