import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../widgets/transaction_tile.dart';

class HistoryScreen extends StatefulWidget {
  final List<Transaction> transactions;
  final Function(String) onDelete;

  const HistoryScreen(
      {super.key, required this.transactions, required this.onDelete});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filter = 'All';
  final filters = ['All', 'Income', 'Expense'];

  @override
  Widget build(BuildContext context) {
    final filtered = widget.transactions.where((t) {
      if (_filter == 'Income') return !t.isExpense;
      if (_filter == 'Expense') return t.isExpense;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction History')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: filters
                  .map((f) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(f),
                          selected: _filter == f,
                          onSelected: (_) => setState(() => _filter = f),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No transactions found.'))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => TransactionTile(
                      tx: filtered[i],
                      onDelete: () => widget.onDelete(filtered[i].id),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}