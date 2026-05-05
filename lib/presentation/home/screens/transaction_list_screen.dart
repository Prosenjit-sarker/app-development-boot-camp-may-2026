import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_development_boot_camp/models/transaction_model.dart';
import 'package:app_development_boot_camp/presentation/home/theme/app_gradients.dart';

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
      child: ListView.separated(
        itemCount: transactions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final t = transactions[index];
          final bool isIncome = t.type == "income";
          final Color accent =
              isIncome ? AppGradients.income : AppGradients.expense;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    gradient: AppGradients.brand,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${DateFormat('dd MMM yyyy').format(t.date)} • ${t.type}",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      t.amount.toStringAsFixed(2),
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.grey.shade700,
                      onPressed: () => onDelete(t.id),
                      tooltip: "Delete",
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
