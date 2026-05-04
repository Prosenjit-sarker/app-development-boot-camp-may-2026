import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_development_boot_camp/models/transaction_model.dart';

class TransactionListScreen extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Function(String) onDelete;

  const TransactionListScreen({
    super.key,
    required this.transactions,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final t = transactions[index];

          return ListTile(
            title: Text(t.title),
            subtitle: Text(
              "${t.amount} • ${t.type}\n${DateFormat('dd MMM yyyy').format(t.date)}",
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => onDelete(t.id),
            ),
          );
        },
      ),
    );
  }
}