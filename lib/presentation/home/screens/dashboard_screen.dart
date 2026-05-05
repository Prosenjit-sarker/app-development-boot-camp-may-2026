import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_development_boot_camp/models/transaction_model.dart';
import 'package:app_development_boot_camp/presentation/home/theme/app_gradients.dart';
import 'package:app_development_boot_camp/presentation/home/widgets/gradient_button.dart';
import 'add_transaction_screen.dart';
import 'transaction_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<TransactionModel> transactions = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("transactions") ?? [];

    setState(() {
      transactions = data.map((e) => TransactionModel.fromJson(e)).toList();
    });
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      "transactions",
      transactions.map((e) => e.toJson()).toList(),
    );
  }

  void addTransaction(TransactionModel t) {
    setState(() {
      transactions.add(t);
    });
    saveData();
  }

  void deleteTransaction(String id) {
    setState(() {
      transactions.removeWhere((e) => e.id == id);
    });
    saveData();
  }

  double get income => transactions
      .where((e) => e.type == "income")
      .fold(0, (a, b) => a + b.amount);

  double get expense => transactions
      .where((e) => e.type == "expense")
      .fold(0, (a, b) => a + b.amount);

  double get balance => income - expense;

  @override
  Widget build(BuildContext context) {
    final double rawProgress = income == 0 ? 0 : expense / income;
    final double progress = rawProgress.clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mexpense",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: AppGradients.brand)),
      ),
      extendBodyBehindAppBar: false,
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.background()),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(18),
                height: 220,
                decoration: BoxDecoration(
                  gradient: AppGradients.brand,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppGradients.brandEnd.withValues(alpha: 0.28),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            "Balance",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            balance.toStringAsFixed(2),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          _MetricRow(
                            label: "Income",
                            value: income,
                            dotColor: AppGradients.income,
                          ),
                          const SizedBox(height: 10),
                          _MetricRow(
                            label: "Expense",
                            value: expense,
                            dotColor: AppGradients.expense,
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 92,
                          width: 92,
                          child: CircularProgressIndicator(
                            value: progress,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.22),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                            strokeWidth: 8,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${(progress * 100).toStringAsFixed(0)}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "spent",
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GradientButton(
                  gradient: AppGradients.brand,
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddTransactionScreen(),
                      ),
                    );

                    if (result != null) {
                      addTransaction(result);
                    }
                  },
                  child: const Text(
                    "Add Transaction",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TransactionListScreen(
                  transactions: transactions,
                  onDelete: deleteTransaction,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
    required this.dotColor,
  });

  final String label;
  final double value;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value.toStringAsFixed(2),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// Intentionally left private widgets only for this screen.
