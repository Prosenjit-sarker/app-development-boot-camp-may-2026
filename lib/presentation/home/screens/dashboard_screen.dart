import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_development_boot_camp/models/transaction_model.dart';
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
    double progress = income == 0 ? 0 : expense / income;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mexpense", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            height: 220,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text("Balance: $balance",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 24)),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Income: $income",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18)),
                      SizedBox(
                        height: 6,
                      ),
                      Text("Expense: $expense",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18)),
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 90,
                      width: 90,
                      child: CircularProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.blue.shade100,
                        valueColor: const AlwaysStoppedAnimation(Colors.red),
                        strokeWidth: 7,
                      ),
                    ),
                    Text("${(progress * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(color: Colors.white)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Add Transaction",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: TransactionListScreen(
              transactions: transactions,
              onDelete: deleteTransaction,
            ),
          )
        ],
      ),
    );
  }
}
