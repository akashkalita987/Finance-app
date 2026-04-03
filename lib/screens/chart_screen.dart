import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction.dart';

class ChartScreen extends StatelessWidget {
  final List<Transaction> transactions;
  const ChartScreen({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final expenses = transactions.where((t) => t.isExpense).toList();
    final Map<String, double> categoryTotals = {};
    for (var tx in expenses) {
      categoryTotals[tx.category] =
          (categoryTotals[tx.category] ?? 0) + tx.amount;
    }

    final colors = [
      Colors.red, Colors.blue, Colors.orange, Colors.purple,
      Colors.teal, Colors.green, Colors.pink, Colors.indigo
    ];
    final sections = categoryTotals.entries.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Spending Chart')),
      body: expenses.isEmpty
          ? const Center(child: Text('No expense data yet.'))
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text('Expenses by Category',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 260,
                    child: PieChart(PieChartData(
                      sections: sections.asMap().entries.map((e) {
                        final i = e.key;
                        final entry = e.value;
                        return PieChartSectionData(
                          value: entry.value,
                          title:
                              '${entry.key}\n₹${entry.value.toStringAsFixed(0)}',
                          color: colors[i % colors.length],
                          radius: 90,
                          titleStyle: const TextStyle(
                              fontSize: 11, color: Colors.white),
                        );
                      }).toList(),
                      sectionsSpace: 2,
                    )),
                  ),
                ],
              ),
            ),
    );
  }
}