import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionTile extends StatelessWidget {
  final Transaction tx;
  final VoidCallback onDelete;

  const TransactionTile({super.key, required this.tx, required this.onDelete});

  static const categoryIcons = {
    'Food': Icons.restaurant,
    'Transport': Icons.directions_bus,
    'Shopping': Icons.shopping_bag,
    'Bills': Icons.receipt_long,
    'Health': Icons.local_hospital,
    'Entertainment': Icons.movie,
    'Salary': Icons.work,
    'Other': Icons.category,
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tx.isExpense ? Colors.red[50] : Colors.green[50],
          child: Icon(
            categoryIcons[tx.category] ?? Icons.category,
            color: tx.isExpense ? Colors.red : Colors.green,
          ),
        ),
        title: Text(tx.title),
        subtitle: Text(
          '${tx.category}  •  ${DateFormat('dd MMM yyyy').format(tx.date)}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${tx.isExpense ? '-' : '+'}₹${tx.amount.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: tx.isExpense ? Colors.red : Colors.green,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
